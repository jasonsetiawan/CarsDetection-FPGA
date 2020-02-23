
-- VHDL Instantiation Created from source file vga_addr_gen.vhd -- 03:04:56 01/22/2020
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT vga_addr_gen
	PORT(
		clk_vga : IN std_logic;
		enable : IN std_logic;
		vsync : IN std_logic;          
		address : OUT std_logic_vector(14 downto 0)
		);
	END COMPONENT;

	Inst_vga_addr_gen: vga_addr_gen PORT MAP(
		clk_vga => ,
		enable => ,
		vsync => ,
		address => 
	);


