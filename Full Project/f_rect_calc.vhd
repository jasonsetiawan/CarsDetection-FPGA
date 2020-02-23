--------------------------------------
-- Design by : Jason Danny Setiawan
-- Start : Fri 25/10 18.04
-- Done	: Fri 25/10 20.33
--------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity f_rect_calc is
    Port ( weight : in  STD_LOGIC_VECTOR (21 downto 0);
           a : in  STD_LOGIC_VECTOR (18 downto 0);
           b : in  STD_LOGIC_VECTOR (18 downto 0);
           c : in  STD_LOGIC_VECTOR (18 downto 0);
           d : in  STD_LOGIC_VECTOR (18 downto 0);
           result : out  STD_LOGIC_VECTOR (26 downto 0));
end f_rect_calc;

architecture Behavioral of f_rect_calc is

signal add : std_logic_vector(20 downto 0);
signal sub : std_logic_vector(20 downto 0);
signal sigma : std_logic_vector(20 downto 0);
signal sigmapos : std_logic_vector(21 downto 0);
signal result0 : std_logic_vector(43 downto 0);

begin

-- formula
-- F = (sum pixel value) * weight
-- F = ((a+d) - (b+c)) * weight

--   A --- B
--   |     |
--   |	  |	<-- Integral Image
--   C --- D

add <= std_logic_vector(unsigned("00" & a) + unsigned("00" & d));
sub <= std_logic_vector(unsigned("00" & b) + unsigned("00" & c));

sigma <= std_logic_vector(unsigned(add)-unsigned(sub));

sigmapos(21) <= '0';
sigmapos(20 downto 0) <= sigma;

-- Signed multiplication needs the same length
result0 <= std_logic_vector(signed(sigmapos)*signed(weight));
-- Since weight is ranged between (-3) and 3 (3 bit max), then the output must not longer than 25 bit. 
-- It is safe using 27 bits only as long as maintaining the MSB.
result <= result0(43) & result0(25 downto 0);

end Behavioral;

