----------------------------------------------------------------------------------
-- iix2 address decoder
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity iix2_address_decoder is
    Port ( iix2_reg_index : in  STD_LOGIC_VECTOR (1 downto 0);
           width : in  STD_LOGIC_VECTOR (5 downto 0);
           offset : in  STD_LOGIC_VECTOR (11 downto 0);
           iix2_address : out  STD_LOGIC_VECTOR (11 downto 0));
end iix2_address_decoder;

architecture Behavioral of iix2_address_decoder is

signal multiplication : std_logic_vector(11 downto 0);
signal iix2_address_a : std_logic_vector(11 downto 0);
signal iix2_address_b : std_logic_vector(11 downto 0);
signal iix2_address_c : std_logic_vector(11 downto 0);
signal iix2_address_d : std_logic_vector(11 downto 0);

begin

multiplication <= std_logic_vector(to_unsigned(30,6)*unsigned(width));

-- A---B
-- |	 |
-- C---D

iix2_address_a <= std_logic_vector(unsigned(offset) - unsigned(width) - 1);
iix2_address_b <= std_logic_vector(unsigned(iix2_address_a) + to_unsigned(50,6));
iix2_address_c <= std_logic_vector(unsigned(offset) + unsigned(multiplication) -unsigned(width) - 1);
iix2_address_d <= std_logic_vector(unsigned(iix2_address_c) + to_unsigned(50,6));

mux_output: process (iix2_reg_index, iix2_address_a, iix2_address_b, iix2_address_c, iix2_address_d)
begin
	case iix2_reg_index is
		when "00" =>
			iix2_address <= iix2_address_a;
		when "01" =>
			iix2_address <= iix2_address_b;
		when "10" =>
			iix2_address <= iix2_address_c;
		when "11" =>
			iix2_address <= iix2_address_d;
		when others =>
			iix2_address <= iix2_address_a; -- actually impossible
	end case;
end process;

end Behavioral;

