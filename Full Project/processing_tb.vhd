--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:22:08 01/23/2020
-- Design Name:   
-- Module Name:   C:/Users/Jason/Desktop/SKRIPSI/PROJECT/Revisi1/processing_tb.vhd
-- Project Name:  Revisi1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: processing_top
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
 
ENTITY processing_tb IS
END processing_tb;
 
ARCHITECTURE behavior OF processing_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT processing_top
    PORT(
         reset : IN  std_logic;
         clk : IN  std_logic;
         start : IN  std_logic;
         mem_state : IN  std_logic;
         x_base : IN  std_logic_vector(5 downto 0);
         y_base : IN  std_logic_vector(5 downto 0);
         ii_rd_data : IN  std_logic_vector(18 downto 0);
         iix2_rd_data : IN  std_logic_vector(22 downto 0);
         ii_rdaddress : OUT  std_logic_vector(11 downto 0);
         iix2_rdaddress : OUT  std_logic_vector(11 downto 0);
         result : OUT  std_logic;
         state_num : OUT  std_logic_vector(2 downto 0);
         ii_reg_idx_out : OUT  std_logic_vector(3 downto 0);
         iix2_reg_idx_out : OUT  std_logic_vector(1 downto 0);
         weakNode_cnt_out : OUT  std_logic_vector(6 downto 0);
         weak_cnt_out : OUT  std_logic_vector(3 downto 0);
         StrongStage_cnt_out : OUT  std_logic_vector(3 downto 0);
         data_ii_out : OUT  std_logic_vector(18 downto 0);
         data_iix2_out : OUT  std_logic_vector(22 downto 0);
         leaf_val_out : OUT  std_logic_vector(14 downto 0);
         leaf_sel_out : OUT  std_logic;
         feature_out : OUT  std_logic_vector(28 downto 0);
         normalized_out : OUT  std_logic_vector(20 downto 0);
         strong_accu_out : OUT  std_logic_vector(21 downto 0);
         varnorm_out : OUT  std_logic_vector(8 downto 0);
         iix2_data_mult_out : OUT  std_logic_vector(27 downto 0);
         done : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal reset : std_logic := '0';
   signal clk : std_logic := '0';
   signal start : std_logic := '0';
   signal mem_state : std_logic := '0';
   signal x_base : std_logic_vector(5 downto 0) := (others => '0');
   signal y_base : std_logic_vector(5 downto 0) := (others => '0');
   signal ii_rd_data : std_logic_vector(18 downto 0) := (others => '0');
   signal iix2_rd_data : std_logic_vector(22 downto 0) := (others => '0');

 	--Outputs
   signal ii_rdaddress : std_logic_vector(11 downto 0);
   signal iix2_rdaddress : std_logic_vector(11 downto 0);
   signal result : std_logic;
   signal state_num : std_logic_vector(2 downto 0);
   signal ii_reg_idx_out : std_logic_vector(3 downto 0);
   signal iix2_reg_idx_out : std_logic_vector(1 downto 0);
   signal weakNode_cnt_out : std_logic_vector(6 downto 0);
   signal weak_cnt_out : std_logic_vector(3 downto 0);
   signal StrongStage_cnt_out : std_logic_vector(3 downto 0);
   signal data_ii_out : std_logic_vector(18 downto 0);
   signal data_iix2_out : std_logic_vector(22 downto 0);
   signal leaf_val_out : std_logic_vector(14 downto 0);
   signal leaf_sel_out : std_logic;
   signal feature_out : std_logic_vector(28 downto 0);
   signal normalized_out : std_logic_vector(20 downto 0);
   signal strong_accu_out : std_logic_vector(21 downto 0);
   signal varnorm_out : std_logic_vector(8 downto 0);
   signal iix2_data_mult_out : std_logic_vector(27 downto 0);
   signal done : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: processing_top PORT MAP (
          reset => reset,
          clk => clk,
          start => start,
          mem_state => mem_state,
          x_base => x_base,
          y_base => y_base,
          ii_rd_data => ii_rd_data,
          iix2_rd_data => iix2_rd_data,
          ii_rdaddress => ii_rdaddress,
          iix2_rdaddress => iix2_rdaddress,
          result => result,
          state_num => state_num,
          ii_reg_idx_out => ii_reg_idx_out,
          iix2_reg_idx_out => iix2_reg_idx_out,
          weakNode_cnt_out => weakNode_cnt_out,
          weak_cnt_out => weak_cnt_out,
          StrongStage_cnt_out => StrongStage_cnt_out,
          data_ii_out => data_ii_out,
          data_iix2_out => data_iix2_out,
          leaf_val_out => leaf_val_out,
          leaf_sel_out => leaf_sel_out,
          feature_out => feature_out,
          normalized_out => normalized_out,
          strong_accu_out => strong_accu_out,
          varnorm_out => varnorm_out,
          iix2_data_mult_out => iix2_data_mult_out,
          done => done
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
END;
