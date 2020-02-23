library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity address_decoder is
    Port ( ii_reg_index : in  STD_LOGIC_VECTOR (3 downto 0);
           width_ii : in  STD_LOGIC_VECTOR (5 downto 0);
           offset : in  STD_LOGIC_VECTOR (11 downto 0);
           x_rect0 : in  STD_LOGIC_VECTOR (5 downto 0);
           y_rect0 : in  STD_LOGIC_VECTOR (5 downto 0);
           w_rect0 : in  STD_LOGIC_VECTOR (5 downto 0);
           h_rect0 : in  STD_LOGIC_VECTOR (5 downto 0);
           x_rect1 : in  STD_LOGIC_VECTOR (5 downto 0);
           y_rect1 : in  STD_LOGIC_VECTOR (5 downto 0);
           w_rect1 : in  STD_LOGIC_VECTOR (5 downto 0);
           h_rect1 : in  STD_LOGIC_VECTOR (5 downto 0);
           x_rect2 : in  STD_LOGIC_VECTOR (5 downto 0);
           y_rect2 : in  STD_LOGIC_VECTOR (5 downto 0);
           w_rect2 : in  STD_LOGIC_VECTOR (5 downto 0);
           h_rect2 : in  STD_LOGIC_VECTOR (5 downto 0);
           ii_address : out  STD_LOGIC_VECTOR (11 downto 0));
end address_decoder;

architecture Behavioral of address_decoder is

component ii_address_calculator
	Port (  x : in  STD_LOGIC_VECTOR (5 downto 0);
           y : in  STD_LOGIC_VECTOR (5 downto 0);
           width_ii : in  STD_LOGIC_VECTOR (5 downto 0);
           offset : in  STD_LOGIC_VECTOR (11 downto 0);
           ii_address : out  STD_LOGIC_VECTOR (11 downto 0));
end component ii_address_calculator;


signal sum_xw_rect0: std_logic_vector(5 downto 0);
signal sum_xw_rect1: std_logic_vector(5 downto 0);
signal sum_xw_rect2: std_logic_vector(5 downto 0);

signal sum_yh_rect0: std_logic_vector(5 downto 0);
signal sum_yh_rect1: std_logic_vector(5 downto 0);
signal sum_yh_rect2: std_logic_vector(5 downto 0);

signal ii_address0: std_logic_vector(11 downto 0) := (others=>'0');
signal ii_address1: std_logic_vector(11 downto 0) := (others=>'0');
signal ii_address2: std_logic_vector(11 downto 0) := (others=>'0');
signal ii_address3: std_logic_vector(11 downto 0) := (others=>'0');
signal ii_address4: std_logic_vector(11 downto 0) := (others=>'0');
signal ii_address5: std_logic_vector(11 downto 0) := (others=>'0');
signal ii_address6: std_logic_vector(11 downto 0) := (others=>'0');
signal ii_address7: std_logic_vector(11 downto 0) := (others=>'0');
signal ii_address8: std_logic_vector(11 downto 0) := (others=>'0');
signal ii_address9: std_logic_vector(11 downto 0) := (others=>'0');
signal ii_address10: std_logic_vector(11 downto 0) := (others=>'0');
signal ii_address11: std_logic_vector(11 downto 0) := (others=>'0');

begin

sum_xw_rect0 <= std_logic_vector(unsigned(x_rect0)+unsigned(w_rect0));
sum_xw_rect1 <= std_logic_vector(unsigned(x_rect1)+unsigned(w_rect1));
sum_xw_rect2 <= std_logic_vector(unsigned(x_rect2)+unsigned(w_rect2));

sum_yh_rect0 <= std_logic_vector(unsigned(y_rect0)+unsigned(h_rect0));
sum_yh_rect1 <= std_logic_vector(unsigned(y_rect1)+unsigned(h_rect1));
sum_yh_rect2 <= std_logic_vector(unsigned(y_rect2)+unsigned(h_rect2));

----------------------------
-- A----B
-- |	  |
-- C----D
----------------------------

ii_addr0_a : ii_address_calculator
	port map (x => x_rect0 , y => y_rect0, width_ii => width_ii, offset => offset, ii_address => ii_address0);

ii_addr0_b : ii_address_calculator
	port map (x => sum_xw_rect0, y => y_rect0, width_ii => width_ii, offset => offset, ii_address => ii_address1);

ii_addr0_c : ii_address_calculator
	port map (x => x_rect0, y => sum_yh_rect0, width_ii => width_ii, offset => offset, ii_address => ii_address2);

ii_addr0_d : ii_address_calculator
	port map (x => sum_xw_rect0, y => sum_yh_rect0, width_ii => width_ii, offset => offset, ii_address => ii_address3);

ii_addr1_a : ii_address_calculator
	port map (x => x_rect1, y => y_rect1, width_ii => width_ii, offset => offset, ii_address => ii_address4);

ii_addr1_b : ii_address_calculator
	port map (x => sum_xw_rect1, y => y_rect1, width_ii => width_ii, offset => offset, ii_address => ii_address5);

ii_addr1_c : ii_address_calculator
	port map (x => x_rect1, y => sum_yh_rect1, width_ii => width_ii, offset => offset, ii_address => ii_address6);

ii_addr1_d : ii_address_calculator
	port map (x => sum_xw_rect1, y => sum_yh_rect1, width_ii => width_ii, offset => offset, ii_address => ii_address7);

ii_addr2_a : ii_address_calculator
	port map (x => x_rect2, y => y_rect2, width_ii => width_ii, offset => offset, ii_address => ii_address8);

ii_addr2_b : ii_address_calculator
	port map (x => sum_xw_rect2, y => y_rect2, width_ii => width_ii, offset => offset, ii_address => ii_address9);

ii_addr2_c : ii_address_calculator
	port map (x => x_rect2, y => sum_yh_rect2, width_ii => width_ii, offset => offset, ii_address => ii_address10);

ii_addr2_d : ii_address_calculator
	port map (x => sum_xw_rect2, y => sum_yh_rect2, width_ii => width_ii, offset => offset, ii_address => ii_address11);

mux_control: process (ii_reg_index, ii_address0, ii_address1, ii_address2, ii_address3,
												ii_address4, ii_address5, ii_address6, ii_address7,
												ii_address8, ii_address9, ii_address10, ii_address11)
begin
	case ii_reg_index is
		when x"0" =>
			ii_address <= ii_address0;
		when x"1" =>
			ii_address <= ii_address1;
		when x"2" =>
			ii_address <= ii_address2;
		when x"3" =>
			ii_address <= ii_address3;
		when x"4" =>
			ii_address <= ii_address4;
		when x"5" =>
			ii_address <= ii_address5;
		when x"6" =>
			ii_address <= ii_address6;
		when x"7" =>
			ii_address <= ii_address7;
		when x"8" =>
			ii_address <= ii_address8;
		when x"9" =>
			ii_address <= ii_address9;
		when x"A" =>
			ii_address <= ii_address10;
		when x"B" =>
			ii_address <= ii_address11;
		when others =>
			ii_address <= ii_address0;
	end case;
end process;
end Behavioral;

