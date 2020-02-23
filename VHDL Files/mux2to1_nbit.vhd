library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2to1_nbit is
	Generic(DATA_WIDTH: integer := 14); 
   Port ( a : in  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
          b : in  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
          s : in  STD_LOGIC;
          q : out  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0));
end mux2to1_nbit;

architecture Behavioral of mux2to1_nbit is
begin
-------------
-- s	|	q	|
-------------
-- 0	|	a	|
-- 1	|	b	|
-------------
	process (a,b,s) begin
		if s = '1' then
			q <= b;
		else
			q <= a;
		end if;
	end process;
end Behavioral;

