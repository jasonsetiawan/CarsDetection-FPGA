---------------------------------------------------------------------------------- 
-- This Component are made to generate address for pixel read from 
-- Main Buffer that will be written to VGA
-- Designer : Jason Danny Setiawan
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vga_addr_gen is
	Port ( clk_vga : in STD_LOGIC;
			 enable : in STD_LOGIC;
			 vsync : in STD_LOGIC;
			 address : out STD_LOGIC_VECTOR (13 downto 0));  
end vga_addr_gen;

architecture Behavioral of vga_addr_gen is

signal addr: STD_LOGIC_VECTOR(13 downto 0) := (others => '0');	
begin

address <= addr;
process (clk_vga) begin
	if rising_edge (clk_vga) then
		if (enable='1') then
			if (unsigned(addr) < to_unsigned(12287,14)) then
				addr <= std_logic_vector(unsigned(addr) + 1);
			end if;
		end if;
		if vsync = '0' then 
			addr <= (others => '0');
		end if;
	end if;
end process;    
end Behavioral;

