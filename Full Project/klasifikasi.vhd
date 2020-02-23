---------------------------------------------------------------
-- 
--------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity klasifikasi is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           en_strongAccum : in  STD_LOGIC;
           en_varnorm : in  STD_LOGIC;
           leftleaf : in  STD_LOGIC_VECTOR (14 downto 0); --signed 14 bit
           rightleaf : in  STD_LOGIC_VECTOR (14 downto 0);--signed 14 bit
           weaktresh : in  STD_LOGIC_VECTOR (11 downto 0);-- signed 12 bit
           strongtresh : in  STD_LOGIC_VECTOR (14 downto 0);--signed 14 bit
           weight0 : in  STD_LOGIC_VECTOR (21 downto 0);
           weight1 : in  STD_LOGIC_VECTOR (21 downto 0);
           weight2 : in  STD_LOGIC_VECTOR (21 downto 0);
           ii_reg_we : in  STD_LOGIC;
           ii_reg_index : in  STD_LOGIC_VECTOR (3 downto 0);
           ii_data : in  STD_LOGIC_VECTOR (18 downto 0);
           iix2_reg_we : in  STD_LOGIC;
           iix2_reg_index : in  STD_LOGIC_VECTOR (1 downto 0);
           iix2_data : in  STD_LOGIC_VECTOR (22 downto 0);
           deteksi : out  STD_LOGIC);
end klasifikasi;

architecture Behavioral of klasifikasi is

component feature_calc
	Port (  weight_0 : in  STD_LOGIC_VECTOR (21 downto 0);
           weight_1 : in  STD_LOGIC_VECTOR (21 downto 0);
           weight_2 : in  STD_LOGIC_VECTOR (21 downto 0);
           a_0 : in  STD_LOGIC_VECTOR (18 downto 0);
           b_0 : in  STD_LOGIC_VECTOR (18 downto 0);
           c_0 : in  STD_LOGIC_VECTOR (18 downto 0);
           d_0 : in  STD_LOGIC_VECTOR (18 downto 0);
           a_1 : in  STD_LOGIC_VECTOR (18 downto 0);
           b_1 : in  STD_LOGIC_VECTOR (18 downto 0);
           c_1 : in  STD_LOGIC_VECTOR (18 downto 0);
           d_1 : in  STD_LOGIC_VECTOR (18 downto 0);
           a_2 : in  STD_LOGIC_VECTOR (18 downto 0);
           b_2 : in  STD_LOGIC_VECTOR (18 downto 0);
           c_2 : in  STD_LOGIC_VECTOR (18 downto 0);
           d_2 : in  STD_LOGIC_VECTOR (18 downto 0);
           feature : out  STD_LOGIC_VECTOR (28 downto 0));
end component feature_calc;

component variance_calc
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
end component variance_calc;

component register_file
	 Generic( address_width : integer;
				 data_width		: integer);
    Port ( clk : in  STD_LOGIC;
           write_en : in  STD_LOGIC;
           write_reg_address : in  STD_LOGIC_VECTOR((address_width-1) downto 0);
           write_data : in  STD_LOGIC_VECTOR((data_width-1) downto 0);
           q0 : out  STD_LOGIC_VECTOR ((data_width-1) downto 0);
           q1 : out  STD_LOGIC_VECTOR ((data_width-1) downto 0);
           q2 : out  STD_LOGIC_VECTOR ((data_width-1) downto 0);
           q3 : out  STD_LOGIC_VECTOR ((data_width-1) downto 0);
           q4 : out  STD_LOGIC_VECTOR ((data_width-1) downto 0);
           q5 : out  STD_LOGIC_VECTOR ((data_width-1) downto 0);
           q6 : out  STD_LOGIC_VECTOR ((data_width-1) downto 0);
           q7 : out  STD_LOGIC_VECTOR ((data_width-1) downto 0);
           q8 : out  STD_LOGIC_VECTOR ((data_width-1) downto 0);
           q9 : out  STD_LOGIC_VECTOR ((data_width-1) downto 0);
           q10 : out STD_LOGIC_VECTOR ((data_width-1) downto 0);
           q11 : out STD_LOGIC_VECTOR ((data_width-1) downto 0));
end component register_file;

component register_file_4
	Generic( address_width : integer;
				data_width	  : integer);
    Port ( clk : in  STD_LOGIC;
           write_en : in  STD_LOGIC;
           write_reg_address : in  STD_LOGIC_VECTOR((address_width-1) downto 0);
           write_data : in  STD_LOGIC_VECTOR((data_width-1) downto 0);
           q0 : out  STD_LOGIC_VECTOR ((data_width-1) downto 0);
           q1 : out  STD_LOGIC_VECTOR ((data_width-1) downto 0);
           q2 : out  STD_LOGIC_VECTOR ((data_width-1) downto 0);
           q3 : out  STD_LOGIC_VECTOR ((data_width-1) downto 0));
end component register_file_4;

-- all rects are unsigned
signal r0: std_logic_vector(18 downto 0); 
signal r1: std_logic_vector(18 downto 0); 
signal r2: std_logic_vector(18 downto 0); 
signal r3: std_logic_vector(18 downto 0); 
signal r4: std_logic_vector(18 downto 0); 
signal r5: std_logic_vector(18 downto 0); 
signal r6: std_logic_vector(18 downto 0); 
signal r7: std_logic_vector(18 downto 0); 
signal r8: std_logic_vector(18 downto 0); 
signal r9: std_logic_vector(18 downto 0); 
signal r10: std_logic_vector(18 downto 0);
signal r11: std_logic_vector(18 downto 0);

signal iia : std_logic_vector(18 downto 0); 
signal iib : std_logic_vector(18 downto 0); 
signal iic : std_logic_vector(18 downto 0); 
signal iid : std_logic_vector(18 downto 0); 
signal ii2a: std_logic_vector(27 downto 0); 
signal ii2b: std_logic_vector(27 downto 0); 
signal ii2c: std_logic_vector(27 downto 0); 
signal ii2d: std_logic_vector(27 downto 0); 

signal result_feature: std_logic_vector(28 downto 0); -- signed
signal var_norm_factor: std_logic_vector(8 downto 0); -- unsigned (harusnya)
signal var_norm_factor_reg: std_logic_vector(8 downto 0) := (others=>'0');
signal var_norm_weak_thresh: std_logic_vector(20 downto 0); --signed
signal leaf_selector: std_logic;
signal leaf_value: std_logic_vector(14 downto 0); -- signed
signal strong_accumulator_result: std_logic_vector(21 downto 0):= (others => '0'); -- signed
signal stage_detection: std_logic;

signal iix2_data_mult : std_logic_vector(27 downto 0);

signal result_mult0: std_logic_vector(26 downto 0); -- 27 bit signed
signal result_mult1: std_logic_vector(15 downto 0); -- 16 bit signed


begin

inst_feature_rect : register_file 
	generic map (address_width => 4, data_width => 19)
	port map (
		clk => clk,
		write_en => ii_reg_we,
		write_reg_address => ii_reg_index,
		write_data => ii_data,
		q0 => r0,
		q1 => r1,
		q2 => r2,
		q3 => r3,
		q4 => r4,
		q5 => r5,
		q6 => r6,
		q7 => r7,
		q8 => r8,
		q9 => r9,
		q10 => r10,
		q11 => r11);

inst_ii_rect : register_file_4
	generic map (address_width => 2, data_width => 19)
	port map (
		clk => clk,
		write_en => iix2_reg_we,
		write_reg_address => iix2_reg_index,
		write_data => ii_data,
		q0 => iia,
		q1 => iib,
		q2 => iic,
		q3 => iid);

iix2_data_mult <= '0' & iix2_data & "0000";
inst_ii2_rect : register_file_4
	generic map (address_width => 2, data_width => 28)
	port map (
		clk => clk,
		write_en => iix2_reg_we,
		write_reg_address => iix2_reg_index,
		write_data => iix2_data_mult,
		q0 => ii2a,
		q1 => ii2b,
		q2 => ii2c,
		q3 => ii2d);

inst_feature_calc : feature_calc
	port map (weight_0 => weight0,
				 weight_1 => weight1,
				 weight_2 => weight2,
				 a_0		 => r0,
				 b_0		 => r1,
				 c_0		 => r2,
				 d_0		 => r3,
				 a_1		 => r4,
				 b_1		 => r5,
				 c_1		 => r6,
				 d_1		 => r7,
				 a_2		 => r8,
				 b_2		 => r9,
				 c_2		 => r10,
				 d_2		 => r11,
				 feature	 => result_feature);
-- a1 <= r0;
-- b1 <= r1;
-- a2 <= r4;
-- b2 <= r5;
-- a3 <= r8;
				 
inst_var_calc : variance_calc
	port map (clk => clk,
				 ii_a => iia,
				 ii_b => iib,
				 ii_c => iic,
				 ii_d => iid,
				 iix2_a => ii2a,
				 iix2_b => ii2b,
				 iix2_c => ii2c,
				 iix2_d => ii2d,
				 norm_factor => var_norm_factor);

-- save var value at the right time
var_reg_process : process (clk, en_varnorm) begin
	if rising_edge (clk) then
		if en_varnorm = '1' then
			var_norm_factor_reg <= var_norm_factor;
		end if;
	end if;
end process;

var_norm_weak_thresh <= std_logic_vector(signed(weaktresh)*signed(var_norm_factor_reg));

weak_thresh_comparation: process (result_feature, var_norm_weak_thresh)
begin
  if signed(result_feature) > signed(var_norm_weak_thresh) then
    leaf_selector <= '1';
  else
    leaf_selector <= '0';
  end if;
end process;

left_right_tree_mux: process(leftleaf, rightleaf, leaf_selector)
begin
	if leaf_selector ='1' then
		leaf_value <= rightleaf;
	else
		leaf_value <= leftleaf;
	end if;
end process;

strong_accumulation: process (clk, rst, strong_accumulator_result, en_strongAccum)
begin
	if (rising_edge(clk)) then 
		if (rst='1') then
			strong_accumulator_result <= (others=>'0');
		elsif (en_strongAccum='1') then
			strong_accumulator_result <= std_logic_vector(signed(leaf_value)+signed(strong_accumulator_result));
		end if;
	end if;
end process;

process (strong_accumulator_result, strongtresh)
begin
  if signed(strong_accumulator_result) > signed(strongtresh) then
    stage_detection <= '1';
  else
    stage_detection <= '0';
  end if;
end process;

---- detection output ----
deteksi <= stage_detection;
end Behavioral;

