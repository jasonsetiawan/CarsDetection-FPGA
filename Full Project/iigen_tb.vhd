LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY iigen_tb IS
END iigen_tb;
 
ARCHITECTURE behavior OF iigen_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ii_gen_top
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         ii_start : IN  std_logic;
         Din : IN  std_logic_vector(11 downto 0);
         image_scale : IN  std_logic_vector(1 downto 0);
         scaleImg_x_base : IN  std_logic_vector(5 downto 0);
         scaleImg_y_base : IN  std_logic_vector(5 downto 0);
         mem_state : IN  std_logic;
         ii_data_in : IN  std_logic_vector(18 downto 0);
         iix2_data_in : IN  std_logic_vector(22 downto 0);
         ii_wren : OUT  std_logic;
         ii_address : OUT  std_logic_vector(11 downto 0);
         ii_data_o : OUT  std_logic_vector(18 downto 0);
         iix2_data_o : OUT  std_logic_vector(22 downto 0);
         done : OUT  std_logic;
         image_rdaddress : OUT  std_logic_vector(13 downto 0);
         stateout : OUT  std_logic_vector(2 downto 0);
         c : OUT  std_logic_vector(5 downto 0);
         d : OUT  std_logic_vector(5 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal ii_start : std_logic := '0';
   signal Din : std_logic_vector(11 downto 0) := (others => '0');
   signal image_scale : std_logic_vector(1 downto 0) := (others => '0');
   signal scaleImg_x_base : std_logic_vector(5 downto 0) := (others => '0');
   signal scaleImg_y_base : std_logic_vector(5 downto 0) := (others => '0');
   signal mem_state : std_logic := '0';
   signal ii_data_in : std_logic_vector(18 downto 0) := (others => '0');
   signal iix2_data_in : std_logic_vector(22 downto 0) := (others => '0');

 	--Outputs
   signal ii_wren : std_logic;
   signal ii_address : std_logic_vector(11 downto 0);
   signal ii_data_o : std_logic_vector(18 downto 0);
   signal iix2_data_o : std_logic_vector(22 downto 0);
   signal done : std_logic;
   signal image_rdaddress : std_logic_vector(13 downto 0);
   signal stateout : std_logic_vector(2 downto 0);
   signal c : std_logic_vector(5 downto 0);
   signal d : std_logic_vector(5 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ii_gen_top PORT MAP (
          clk => clk,
          reset => reset,
          ii_start => ii_start,
          Din => Din,
          image_scale => image_scale,
          scaleImg_x_base => scaleImg_x_base,
          scaleImg_y_base => scaleImg_y_base,
          mem_state => mem_state,
          ii_data_in => ii_data_in,
          iix2_data_in => iix2_data_in,
          ii_wren => ii_wren,
          ii_address => ii_address,
          ii_data_o => ii_data_o,
          iix2_data_o => iix2_data_o,
          done => done,
          image_rdaddress => image_rdaddress,
          stateout => stateout,
          c => c,
          d => d
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
