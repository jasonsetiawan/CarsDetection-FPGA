-----------------------------------|
-- Design : Jason Danny Setiawan   |
-----------------------------------|

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ii_address_calculator is
    Port ( x : in  STD_LOGIC_VECTOR (5 downto 0);
           y : in  STD_LOGIC_VECTOR (5 downto 0);
           width_ii : in  STD_LOGIC_VECTOR (5 downto 0);
           offset : in  STD_LOGIC_VECTOR (11 downto 0);
           ii_address : out  STD_LOGIC_VECTOR (11 downto 0));
end ii_address_calculator;

architecture Behavioral of ii_address_calculator is

signal y_decider : std_logic_vector(11 downto 0);
signal x_decider : std_logic_vector(11 downto 0);

begin

y_decider <= std_logic_vector(unsigned(y)*unsigned(width_ii));
x_decider <= std_logic_vector(unsigned(x)+unsigned(offset));

ii_address <= std_logic_vector(unsigned(y_decider)+unsigned(x_decider)-unsigned(width_ii)-1);

end Behavioral;

