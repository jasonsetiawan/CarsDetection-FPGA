
-- VHDL Instantiation Created from source file draw.vhd -- 03:57:01 01/24/2020
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT draw
	PORT(
		reset : IN std_logic;
		clk_roi : IN std_logic;
		clk_draw : IN std_logic;
		start_draw : IN std_logic;
		scale : IN std_logic_vector(1 downto 0);
		xpos_roi : IN std_logic_vector(5 downto 0);
		ypos_roi : IN std_logic_vector(5 downto 0);
		roi_done : IN std_logic;
		roi_result : IN std_logic;          
		box_wraddress : OUT std_logic_vector(13 downto 0);
		box_wrdata : OUT std_logic_vector(11 downto 0);
		box_wren : OUT std_logic;
		draw_done : OUT std_logic
		);
	END COMPONENT;

	Inst_draw: draw PORT MAP(
		reset => ,
		clk_roi => ,
		clk_draw => ,
		start_draw => ,
		scale => ,
		xpos_roi => ,
		ypos_roi => ,
		roi_done => ,
		roi_result => ,
		box_wraddress => ,
		box_wrdata => ,
		box_wren => ,
		draw_done => 
	);


