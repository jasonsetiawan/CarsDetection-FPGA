library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2to1_1bit is
    Port ( a : in  STD_LOGIC;
           b : in  STD_LOGIC;
           s : in  STD_LOGIC;
           q : out  STD_LOGIC);
end mux2to1_1bit;

architecture Behavioral of mux2to1_1bit is
begin
-------------
-- s	|	q	|
-------------
-- 0	|	a	|
-- 1	|	b	|
-------------
	q <= (a and not s) or (b and s); 
end Behavioral;