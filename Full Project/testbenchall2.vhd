
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY testbenchall2 IS
END testbenchall2;
 
ARCHITECTURE behavior OF testbenchall2 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top
    PORT(
         clk50 : IN  std_logic;
         reset : IN  std_logic;
         camera : IN  std_logic;
         vga_vsync : OUT  std_logic;
         vga_hsync : OUT  std_logic;
         vga_red : OUT  std_logic_vector(2 downto 0);
         vga_green : OUT  std_logic_vector(2 downto 0);
         vga_blue : OUT  std_logic_vector(1 downto 0);
         stateout_top : OUT  std_logic_vector(3 downto 0);
         state_iigen : OUT  std_logic_vector(2 downto 0);
         x_iigen : OUT  std_logic_vector(5 downto 0);
         y_iigen : OUT  std_logic_vector(5 downto 0);
         ii_data : OUT  std_logic_vector(18 downto 0);
         iix2_data : OUT  std_logic_vector(22 downto 0);
         greyout : OUT  std_logic_vector(7 downto 0);
         stateout_roi : OUT  std_logic_vector(2 downto 0);
         weakout : OUT  std_logic_vector(6 downto 0);
         strongout : OUT  std_logic_vector(3 downto 0);
         roi_done_out : OUT  std_logic;
         result_roi_out : OUT  std_logic;
         featureout : OUT  std_logic_vector(28 downto 0);
         varnormout : OUT  std_logic_vector(8 downto 0);
         weakthresh : OUT  std_logic_vector(20 downto 0);
         strongaccu : OUT  std_logic_vector(21 downto 0);
         ii_reg_idx_out : OUT  std_logic_vector(3 downto 0);
         iix2_reg_idx_out : OUT  std_logic_vector(1 downto 0);
			addr_for_ii : OUT std_logic_vector(13 downto 0);
         data_ii_out : OUT  std_logic_vector(18 downto 0);
         data_iix2_out : OUT  std_logic_vector(22 downto 0);
         leaf_sel_out : OUT  std_logic;
         ii_rd : OUT  std_logic_vector(18 downto 0);
         drawbegin_out : OUT  std_logic;
			img_data : OUT std_logic_vector(11 downto 0);
         drawdone_out : OUT  std_logic;
			clb : out std_logic_vector(13 downto 0);
			image_address_base_out : out std_logic_vector(13 downto 0);
         state_draw : OUT  std_logic_vector(2 downto 0);
         countin : OUT  std_logic_vector(8 downto 0);
         xbase_roi_out : OUT  std_logic_vector(5 downto 0);
         ybase_roi_out : OUT  std_logic_vector(5 downto 0);
         xbase_iigen_out : OUT  std_logic_vector(5 downto 0);
         ybase_iigen_out : OUT  std_logic_vector(5 downto 0);
         xbase_iiproc_out : OUT  std_logic_vector(5 downto 0);
         ybase_iiproc_out : OUT  std_logic_vector(5 downto 0);
			img_dataB : OUT std_logic_vector(11 downto 0);
			ii_ad : OUT std_logic_vector(11 downto 0);
			offsetout : OUT std_logic_vector(11 downto 0);
			infoin	: out std_logic_vector(8 downto 0);
			infoout : out std_logic_vector(8 downto 0);
         pll_locked : OUT  std_logic
        );
    END COMPONENT; 
	 
   --Inputs
   signal clk50 : std_logic := '0';
   signal reset : std_logic := '0';
   signal camera : std_logic := '0';

 	--Outputs
   signal vga_vsync : std_logic;
   signal vga_hsync : std_logic;
   signal vga_red : std_logic_vector(2 downto 0);
   signal vga_green : std_logic_vector(2 downto 0);
   signal vga_blue : std_logic_vector(1 downto 0);
   signal stateout_top : std_logic_vector(3 downto 0);
   signal state_iigen : std_logic_vector(2 downto 0);
   signal x_iigen : std_logic_vector(5 downto 0);
   signal y_iigen : std_logic_vector(5 downto 0);
   signal ii_data : std_logic_vector(18 downto 0);
   signal iix2_data : std_logic_vector(22 downto 0);
   signal greyout : std_logic_vector(7 downto 0);
   signal stateout_roi : std_logic_vector(2 downto 0);
   signal weakout : std_logic_vector(6 downto 0);
   signal strongout : std_logic_vector(3 downto 0);
   signal roi_done_out : std_logic;
   signal result_roi_out : std_logic;
   signal featureout : std_logic_vector(28 downto 0);
   signal varnormout : std_logic_vector(8 downto 0);
   signal weakthresh : std_logic_vector(20 downto 0);
   signal strongaccu : std_logic_vector(21 downto 0);
   signal ii_reg_idx_out : std_logic_vector(3 downto 0);
   signal iix2_reg_idx_out : std_logic_vector(1 downto 0);
   signal data_ii_out : std_logic_vector(18 downto 0);
   signal data_iix2_out : std_logic_vector(22 downto 0);
   signal leaf_sel_out : std_logic;
   signal ii_rd : std_logic_vector(18 downto 0);
   signal drawbegin_out : std_logic;
   signal drawdone_out : std_logic;
   signal state_draw : std_logic_vector(2 downto 0);
   signal countin : std_logic_vector(8 downto 0);
   signal xbase_roi_out : std_logic_vector(5 downto 0);
   signal ybase_roi_out : std_logic_vector(5 downto 0);
   signal xbase_iigen_out : std_logic_vector(5 downto 0);
   signal ybase_iigen_out : std_logic_vector(5 downto 0);
   signal xbase_iiproc_out : std_logic_vector(5 downto 0);
   signal ybase_iiproc_out : std_logic_vector(5 downto 0);
	signal img_data :  std_logic_vector(11 downto 0);
   signal pll_locked : std_logic;
	signal addr_for_ii : std_logic_vector(13 downto 0);
	signal img_dataB : std_logic_vector(11 downto 0);
	signal clb :std_logic_vector(13 downto 0);
	signal image_address_base_out :std_logic_vector(13 downto 0);
	signal ii_ad :  std_logic_vector(11 downto 0);
	signal offsetout : std_logic_vector(11 downto 0);
	signal infoin	: std_logic_vector(8 downto 0);
	signal infoout :  std_logic_vector(8 downto 0);


   -- Clock period definitions
   constant clk50_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top PORT MAP (
          clk50 => clk50,
          reset => reset,
          camera => camera,
          vga_vsync => vga_vsync,
          vga_hsync => vga_hsync,
          vga_red => vga_red,
          vga_green => vga_green,
          vga_blue => vga_blue,
          stateout_top => stateout_top,
          state_iigen => state_iigen,
          x_iigen => x_iigen,
          y_iigen => y_iigen,
          ii_data => ii_data,
          iix2_data => iix2_data,
          greyout => greyout,
          stateout_roi => stateout_roi,
          weakout => weakout,
          strongout => strongout,
          roi_done_out => roi_done_out,
          result_roi_out => result_roi_out,
          featureout => featureout,
          varnormout => varnormout,
          weakthresh => weakthresh,
          strongaccu => strongaccu,
          ii_reg_idx_out => ii_reg_idx_out,
          iix2_reg_idx_out => iix2_reg_idx_out,
			 img_data => img_data,
          data_ii_out => data_ii_out,
          data_iix2_out => data_iix2_out,
          leaf_sel_out => leaf_sel_out,
          ii_rd => ii_rd,
			 ii_ad => ii_ad,
			 offsetout => offsetout,
          drawbegin_out => drawbegin_out,
          drawdone_out => drawdone_out,
          state_draw => state_draw,
			 clb => clb,
			 addr_for_ii => addr_for_ii, 
			 image_address_base_out => image_address_base_out,
          countin => countin,
			 infoin => infoin,
			 infoout => infoout,
          xbase_roi_out => xbase_roi_out,
          ybase_roi_out => ybase_roi_out,
          xbase_iigen_out => xbase_iigen_out,
          ybase_iigen_out => ybase_iigen_out,
          xbase_iiproc_out => xbase_iiproc_out,
          ybase_iiproc_out => ybase_iiproc_out,
			 img_dataB => img_dataB,
          pll_locked => pll_locked
        );

   -- Clock process definitions
   clk50_process :process
   begin
		clk50 <= '0';
		wait for clk50_period/2;
		clk50 <= '1';
		wait for clk50_period/2;
   end process;
END;
