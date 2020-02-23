
-- VHDL Instantiation Created from source file vga_color.vhd -- 03:05:37 01/22/2020
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT vga_color
	PORT(
		Data_in : IN std_logic_vector(11 downto 0);
		activeArea : IN std_logic;
		display : IN std_logic;          
		Red : OUT std_logic_vector(2 downto 0);
		Green : OUT std_logic_vector(2 downto 0);
		Blue : OUT std_logic_vector(1 downto 0)
		);
	END COMPONENT;

	Inst_vga_color: vga_color PORT MAP(
		Data_in => ,
		activeArea => ,
		display => ,
		Red => ,
		Green => ,
		Blue => 
	);


