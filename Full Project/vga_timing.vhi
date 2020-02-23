
-- VHDL Instantiation Created from source file vga_timing.vhd -- 03:06:52 01/22/2020
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT vga_timing
	PORT(
		clk : IN std_logic;          
		Hsync : OUT std_logic;
		Vsync : OUT std_logic;
		activeArea : OUT std_logic;
		dispArea : OUT std_logic
		);
	END COMPONENT;

	Inst_vga_timing: vga_timing PORT MAP(
		clk => ,
		Hsync => ,
		Vsync => ,
		activeArea => ,
		dispArea => 
	);


