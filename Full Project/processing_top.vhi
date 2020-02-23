
-- VHDL Instantiation Created from source file processing_top.vhd -- 14:12:09 01/23/2020
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT processing_top
	PORT(
		reset : IN std_logic;
		clk : IN std_logic;
		start : IN std_logic;
		mem_state : IN std_logic;
		x_base : IN std_logic_vector(5 downto 0);
		y_base : IN std_logic_vector(5 downto 0);
		ii_rd_data : IN std_logic_vector(18 downto 0);
		iix2_rd_data : IN std_logic_vector(22 downto 0);          
		ii_rdaddress : OUT std_logic_vector(12 downto 0);
		iix2_rdaddress : OUT std_logic_vector(12 downto 0);
		result : OUT std_logic;
		state_num : OUT std_logic_vector(2 downto 0);
		ii_reg_idx_out : OUT std_logic_vector(3 downto 0);
		iix2_reg_idx_out : OUT std_logic_vector(1 downto 0);
		weakNode_cnt_out : OUT std_logic_vector(6 downto 0);
		weak_cnt_out : OUT std_logic_vector(3 downto 0);
		StrongStage_cnt_out : OUT std_logic_vector(3 downto 0);
		data_ii_out : OUT std_logic_vector(18 downto 0);
		data_iix2_out : OUT std_logic_vector(22 downto 0);
		leaf_val_out : OUT std_logic_vector(14 downto 0);
		leaf_sel_out : OUT std_logic;
		feature_out : OUT std_logic_vector(28 downto 0);
		normalized_out : OUT std_logic_vector(20 downto 0);
		strong_accu_out : OUT std_logic_vector(21 downto 0);
		varnorm_out : OUT std_logic_vector(8 downto 0);
		done : OUT std_logic
		);
	END COMPONENT;

	Inst_processing_top: processing_top PORT MAP(
		reset => ,
		clk => ,
		start => ,
		mem_state => ,
		x_base => ,
		y_base => ,
		ii_rd_data => ,
		iix2_rd_data => ,
		ii_rdaddress => ,
		iix2_rdaddress => ,
		result => ,
		state_num => ,
		ii_reg_idx_out => ,
		iix2_reg_idx_out => ,
		weakNode_cnt_out => ,
		weak_cnt_out => ,
		StrongStage_cnt_out => ,
		data_ii_out => ,
		data_iix2_out => ,
		leaf_val_out => ,
		leaf_sel_out => ,
		feature_out => ,
		normalized_out => ,
		strong_accu_out => ,
		varnorm_out => ,
		done => 
	);


