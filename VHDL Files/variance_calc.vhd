library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity variance_calc is
    Port ( clk : in  STD_LOGIC;
           ii_a : in  STD_LOGIC_VECTOR (18 downto 0);
           ii_b : in  STD_LOGIC_VECTOR (18 downto 0);
           ii_c : in  STD_LOGIC_VECTOR (18 downto 0);
           ii_d : in  STD_LOGIC_VECTOR (18 downto 0);
           iix2_a : in  STD_LOGIC_VECTOR (27 downto 0);
           iix2_b : in  STD_LOGIC_VECTOR (27 downto 0);
           iix2_c : in  STD_LOGIC_VECTOR (27 downto 0);
           iix2_d : in  STD_LOGIC_VECTOR (27 downto 0);
			  norm_factor : out  STD_LOGIC_VECTOR (8 downto 0));
end variance_calc;

architecture Behavioral of variance_calc is

-- ii
signal sum_ii	 : std_logic_vector(20 downto 0);
signal sub_ii	 : std_logic_vector(20 downto 0);
signal sigma_ii : std_logic_vector(20 downto 0);

--iix2
signal sum_iix2 : std_logic_vector(28 downto 0);
signal sub_iix2 : std_logic_vector(28 downto 0);
signal sigma_iix2 : std_logic_vector(28 downto 0);

--(iix)2
signal squared_sigma : std_logic_vector(41 downto 0);
signal squared_sigma_alw_pos : std_logic_vector(42 downto 0);

signal iix2_x8 : std_logic_vector (31 downto 0):=(others=>'0');
signal iix2_x4 : std_logic_vector (30 downto 0):=(others=>'0');
signal iix2_x11: std_logic_vector (31 downto 0):=(others=>'0');
signal iix2per1500 : std_logic_vector(17 downto 0);

signal variance : std_logic_vector(42 downto 0);
signal variance_msb : std_logic_vector(22 downto 0);
 
component sqrt
	Port( clk : in std_logic;
			x_in : in std_logic_vector(22 downto 0);
			x_out: out std_logic_vector(11 downto 0));
end component;		
	
attribute box_type : string;
attribute box_type of sqrt:
component is "black_box";

signal stddev_msb : std_logic_vector(11 downto 0):=(others=>'0');
signal stddev : std_logic_vector (21 downto 0):=(others=>'0');

begin

-- ii(x) = (a+d)-(b+c) --> integral image
sum_ii <= std_logic_vector(unsigned("00" & ii_a) + unsigned("00" & ii_d)); 
sub_ii <= std_logic_vector(unsigned("00" & ii_b) + unsigned("00" & ii_c));
sigma_ii <= std_logic_vector(unsigned(sum_ii) - unsigned (sub_ii));

-- ii(x2) = (a+d)-(b+c) --> squared integral image
sum_iix2 <= std_logic_vector(unsigned('0' & iix2_a) + unsigned('0' & iix2_d)); 
sub_iix2 <= std_logic_vector(unsigned('0' & iix2_b) + unsigned('0' & iix2_c));
sigma_iix2 <= std_logic_vector(unsigned(sum_iix2) - unsigned (sub_iix2));

-- (ii(x))2 =ii(x) * ii(x)
squared_sigma <= std_logic_vector(unsigned(sigma_ii)*unsigned(sigma_ii));
squared_sigma_alw_pos(42) <= '0';
squared_sigma_alw_pos(41 downto 0) <= squared_sigma;

-- ii(x2)/N , since N = 50 * 30 = 1500, then
-- 1500 : 2 x 2 x 3 x 5 x 5 x 5
-- ii(x2)/N = ii(x2)/1500 = 11*ii(x2)/16500, aprox 16384 = 2^14
iix2_x8(31 downto 3) <= sigma_iix2;
iix2_x4(30 downto 2) <= sigma_iix2;
iix2_x11 <= std_logic_vector(unsigned(iix2_x8)+unsigned(iix2_x4)-unsigned(sigma_iix2));
iix2per1500 <= iix2_x11(31 downto 14);

-- variance = iix2 - iix2per1500
-- variance = variance_msb * 2^20
-- sqrt(variance) = sqrt(variance_msb * 2^20) 
-- stddev = sqrt(variance_msb) * 2^10

variance	<= std_logic_vector(unsigned(squared_sigma_alw_pos) - unsigned(iix2per1500));
variance_msb <= variance(42 downto 20);

stddev_inst : sqrt port map(
	clk   => clk,
	x_in  => variance_msb,
	x_out => stddev_msb);

norm_factor <= stddev_msb(11 downto 3);

end Behavioral;

