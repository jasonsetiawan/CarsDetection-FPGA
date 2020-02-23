
-- VHDL Instantiation Created from source file ii_gen_top.vhd -- 15:01:20 01/22/2020
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT ii_gen_top
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		ii_start : IN std_logic;
		Din : IN std_logic_vector(11 downto 0);
		image_scale : IN std_logic_vector(1 downto 0);
		scaleImg_x_base : IN std_logic_vector(5 downto 0);
		scaleImg_y_base : IN std_logic_vector(5 downto 0);
		mem_state : IN std_logic;
		ii_data_in : IN std_logic_vector(18 downto 0);
		iix2_data_in : IN std_logic_vector(22 downto 0);          
		ii_wren : OUT std_logic;
		ii_address : OUT std_logic_vector(11 downto 0);
		ii_data_o : OUT std_logic_vector(18 downto 0);
		iix2_data_o : OUT std_logic_vector(22 downto 0);
		done : OUT std_logic;
		image_rdaddress : OUT std_logic_vector(13 downto 0);
		stateout : OUT std_logic_vector(2 downto 0);
		c : OUT std_logic_vector(5 downto 0);
		d : OUT std_logic_vector(5 downto 0)
		);
	END COMPONENT;

	Inst_ii_gen_top: ii_gen_top PORT MAP(
		clk => ,
		reset => ,
		ii_start => ,
		Din => ,
		image_scale => ,
		scaleImg_x_base => ,
		scaleImg_y_base => ,
		mem_state => ,
		ii_data_in => ,
		iix2_data_in => ,
		ii_wren => ,
		ii_address => ,
		ii_data_o => ,
		iix2_data_o => ,
		done => ,
		image_rdaddress => ,
		stateout => ,
		c => ,
		d => 
	);


