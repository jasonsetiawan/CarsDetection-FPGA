----------------------------------------------------------------------------------
-- Counter to count weak classifier
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter is
	 Generic (COUNT_WIDTH : integer := 4);
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           en : in  STD_LOGIC;
           count : out  STD_LOGIC_VECTOR ((COUNT_WIDTH-1)downto 0));
end counter;

architecture Behavioral of counter is

begin
	count_proc: process (clk, rst, en)	
		variable num: unsigned(COUNT_WIDTH-1 downto 0) := (others=>'0');
		begin
			if (rst ='1') then
				num := (others=>'0');
			elsif (rising_edge(clk) and (en='1')) then
				num := num + 1;
			end if;
		count <= std_logic_vector(num);
		end process;
end Behavioral;

