---------------------------------------------------------------
-- This entity prepare the color of a pixel which will be sent
---------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vga_color is
	 Port ( Data_in : in STD_LOGIC_VECTOR (11 downto 0);
           activeArea : in  STD_LOGIC;
           display : in STD_LOGIC;
           Red : out  STD_LOGIC_VECTOR (2 downto 0);
           Green : out  STD_LOGIC_VECTOR (2 downto 0);
           Blue : out  STD_LOGIC_VECTOR (1 downto 0));
end vga_color;

architecture Behavioral of vga_color is
begin

disp_proc : process (activeArea,display,Data_in) begin
	if activeArea = '0' then
		Red <= "000";
		Green <= "000";
		Blue <= "00";
	else
	   if display = '0' then
			Red <= "000";
			Green <= "000";
			Blue <= "00";
      else
		-- Red : 11 downto 8
		-- Green : 7 downto 4
		-- Blue : 3 downto 0
		-- Nexys2 D/A converter supports 3 bits red, 3 bits green, and 2 bits blue. 
		  Red <= Data_in(11 downto 9);
		  Green <= Data_in(7 downto 5);
		  Blue <= Data_in(3 downto 2);
		end if;
	end if;
end process disp_proc;
end Behavioral;
