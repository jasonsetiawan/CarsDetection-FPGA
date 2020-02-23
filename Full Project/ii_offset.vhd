----------------------------------------------------------------------------------
-- Designer : 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ii_offset is
    Port ( mem_state : in  STD_LOGIC;
           x : in  STD_LOGIC_VECTOR (5 downto 0);
           y : in  STD_LOGIC_VECTOR (5 downto 0);
           width : in  STD_LOGIC_VECTOR (5 downto 0);
           offset : out  STD_LOGIC_VECTOR (11 downto 0));
end ii_offset;

architecture Behavioral of ii_offset is

signal sig_offset : std_logic_vector(11 downto 0);
signal y_pos		: std_logic_vector(11 downto 0);

begin
	y_pos <= std_logic_vector(unsigned(y)*unsigned(width));
	-- mem_state = '1' start from 0
	-- mem_state = '0' start from 4096
	sig_offset (11) <= not mem_state;
	sig_offset (10 downto 0) <= std_logic_vector(unsigned(x) + unsigned(y_pos(10 downto 0)));

	offset <= sig_offset;
end Behavioral;

