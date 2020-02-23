library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity synch_counter is
	Generic (COUNT_WIDTH : integer := 4);
	Port( clk: in std_logic;
			reset: in std_logic;
			en: in std_logic;
			count: out std_logic_vector(COUNT_WIDTH-1 downto 0));
end synch_counter;

architecture Behavioral of synch_counter is
begin

count_proc: process (clk, reset, en)
 variable num: unsigned(COUNT_WIDTH-1 downto 0) := (others=>'0');
begin
	if (rising_edge(clk)) then 
		if (reset='1') then
			num := (others=>'0');
		elsif ((en='1')) then
			num := num + 1;
		end if;
	end if;
	count <= std_logic_vector(num);
end process;
end Behavioral;

