---------------------------------------------------------
-- This entity synchronize hsync and vsync to vga
-- Thanks to Pong P. Chu for creating basic designs.
--------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity vga_timing is
	 Port ( clk : in  STD_LOGIC;
           Hsync : out  STD_LOGIC;
           Vsync : out  STD_LOGIC;
           activeArea : out  STD_LOGIC;
           dispArea : out STD_LOGIC);
end vga_timing;

architecture Behavioral of vga_timing is

constant HD : INTEGER := 640;
constant HF : INTEGER := 16; 
constant HB : INTEGER := 48;
constant HR : INTEGER := 96;
constant HP : INTEGER := HD + HF + HB + HR - 1;
constant VD : INTEGER := 480;
constant VF : INTEGER := 10;
constant VB : INTEGER := 33;
constant VR : INTEGER := 2;
constant VP : INTEGER := VD + VF + VB + VR - 1;

signal video : STD_LOGIC;
signal hcnt,vcnt : INTEGER := 0;

begin

count_proc : process(clk,vcnt,hcnt) begin
		if rising_edge(clk) then
			if (hcnt = HP) then
				hcnt <= 0;
				if (vcnt = VP) then
					vcnt <= 0;
				else
					vcnt <= vcnt + 1;
				end if;
			else
				hcnt <= hcnt +1;
			end if;
		end if;
end process count_proc;

hsync_gen : process(clk) begin
	if rising_edge(clk) then
		if (hcnt >= (HD+HF) and hcnt <= (HD+HF+HR-1)) then 
			Hsync <= '0';
		else
			Hsync <= '1';
		end if;
	end if;
end process hsync_gen;

vsync_gen : process(clk) begin
	if rising_edge(clk) then
		if (vcnt >= (VD + VF) and vcnt <= (VD + VF + VR - 1)) then
			Vsync <= '0';
		else
			Vsync <= '1';
		end if;
	end if;
end process vsync_gen;

video <= '1' when (hcnt < HD) and (vcnt < VD) else '0';
activeArea <= video;

dispArea <= '1' when (hcnt < 128) and (vcnt < 96) else '0';


end Behavioral;

