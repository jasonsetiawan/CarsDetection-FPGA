--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:59:35 01/24/2020
-- Design Name:   
-- Module Name:   C:/Users/Jason/Desktop/SKRIPSI/PROJECT/Revisi1/draw_tb.vhd
-- Project Name:  Revisi1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: draw
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY draw_tb IS
END draw_tb;
 
ARCHITECTURE behavior OF draw_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT draw
    PORT(
         reset : IN  std_logic;
         clk_roi : IN  std_logic;
         clk_draw : IN  std_logic;
         start_draw : IN  std_logic;
         scale : IN  std_logic_vector(1 downto 0);
         xpos_roi : IN  std_logic_vector(5 downto 0);
         ypos_roi : IN  std_logic_vector(5 downto 0);
         roi_done : IN  std_logic;
         roi_result : IN  std_logic;
         box_wraddress : OUT  std_logic_vector(13 downto 0);
         box_wrdata : OUT  std_logic_vector(11 downto 0);
         box_wren : OUT  std_logic;
         draw_done : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal reset : std_logic := '0';
   signal clk_roi : std_logic := '0';
   signal clk_draw : std_logic := '0';
   signal start_draw : std_logic := '0';
   signal scale : std_logic_vector(1 downto 0) := (others => '0');
   signal xpos_roi : std_logic_vector(5 downto 0) := (others => '0');
   signal ypos_roi : std_logic_vector(5 downto 0) := (others => '0');
   signal roi_done : std_logic := '0';
   signal roi_result : std_logic := '0';

 	--Outputs
   signal box_wraddress : std_logic_vector(13 downto 0);
   signal box_wrdata : std_logic_vector(11 downto 0);
   signal box_wren : std_logic;
   signal draw_done : std_logic;

   -- Clock period definitions
   constant clk_roi_period : time := 10 ns;
   constant clk_draw_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: draw PORT MAP (
          reset => reset,
          clk_roi => clk_roi,
          clk_draw => clk_draw,
          start_draw => start_draw,
          scale => scale,
          xpos_roi => xpos_roi,
          ypos_roi => ypos_roi,
          roi_done => roi_done,
          roi_result => roi_result,
          box_wraddress => box_wraddress,
          box_wrdata => box_wrdata,
          box_wren => box_wren,
          draw_done => draw_done
        );

   -- Clock process definitions
   clk_roi_process :process
   begin
		clk_roi <= '0';
		wait for clk_roi_period/2;
		clk_roi <= '1';
		wait for clk_roi_period/2;
   end process;
 
   clk_draw_process :process
   begin
		clk_draw <= '0';
		wait for clk_draw_period/2;
		clk_draw <= '1';
		wait for clk_draw_period/2;
   end process;

END;
