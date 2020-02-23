-------------------------------------------------------------------------------------
-- FPGA-BASED IMPELEMENTATION OF VIOLA JONES ALGORITHM FOR CARS DETECTION SYSTEM
-- 
-- System Spesification:
-- -- Board FPGA : Digilent Nexys2 with Xilinx Spartan 3E-500 FG-320 FPGA.
-- -- Image input 128 x 96 pixels, directly inserted into BRAM
-- -- Training Data 500 positive images, 450 negative images, UIUC Dataset
	-- Trained in OpenCV using Gentle Adaboost using Haar-like Feature, non-tilted.
	-- Trained with objection of 8 stages classifier.
	-- VGA Monitor frame rate 60 fps, detection system is not looped.
	-- *not suitable from moving images

-- Available Scales
-- -- A car with a dimension approximately half or two-fifth original image should
	-- be detected.

-- Simple Application Notes
-- -- Cars that can be detected are the side-viewed cars.
	-- Some LOGICORE might need to be regenerated.
	-- See code for mechanisms.

-- Credits:
	-- Thanks to Peter Irgens and his team for parallelized processing and pre-processing
	-- sub-system. 
	-- Thanks to Pong P. Chu for giving basic calculation and processing/drawing on VGA.

-- Designers : Jason D. Setiawan (jasonsetiawan03@student.ub.ac.id)
-----------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top is
    Port ( clk50 : in  STD_LOGIC;
			  reset : in  STD_LOGIC;
			  available : in  STD_LOGIC;
           vga_vsync : out  STD_LOGIC;
           vga_hsync : out  STD_LOGIC;
           vga_red : out  STD_LOGIC_VECTOR (2 downto 0);
           vga_green : out  STD_LOGIC_VECTOR (2 downto 0);
           vga_blue : out  STD_LOGIC_VECTOR (1 downto 0);
			  pll_locked : out  STD_LOGIC);
end top;

architecture Behavioral of top is

constant II_WIDTH : unsigned(5 downto 0) := to_unsigned(50,6);
constant II_HEIGHT : unsigned(5 downto 0) := to_unsigned(40,6);
constant ROI_WIDTH : unsigned(5 downto 0) := to_unsigned(50,6);
constant ROI_HEIGHT : unsigned(5 downto 0) := to_unsigned(30,6);

COMPONENT image_buffer
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
    clkb : IN STD_LOGIC;
    web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addrb : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
    dinb : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(11 DOWNTO 0));
END COMPONENT;
attribute box_type : string;
attribute box_type of image_buffer:
component is "black_box";

COMPONENT clk_pll
	PORT(
		CLKIN_IN : IN std_logic;
		RST_IN : IN std_logic;          
		CLKDV_OUT : OUT std_logic;
		CLK0_OUT : OUT std_logic;
		CLK2X_OUT : OUT std_logic;
		LOCKED_OUT : OUT std_logic);
END COMPONENT;

COMPONENT vga_addr_gen
	PORT(
		clk_vga : IN std_logic;
		enable : IN std_logic;
		vsync : IN std_logic;          
		address : OUT std_logic_vector(13 downto 0));
END COMPONENT;

COMPONENT vga_color
	PORT(
		Data_in : IN std_logic_vector(11 downto 0);
		activeArea : IN std_logic;
		display : IN std_logic;          
		Red : OUT std_logic_vector(2 downto 0);
		Green : OUT std_logic_vector(2 downto 0);
		Blue : OUT std_logic_vector(1 downto 0));
END COMPONENT;

COMPONENT vga_timing
	PORT(
		clk : IN std_logic;          
		Hsync : OUT std_logic;
		Vsync : OUT std_logic;
		activeArea : OUT std_logic;
		dispArea : OUT std_logic);
END COMPONENT;

COMPONENT ii_gen_top
PORT(
	clk : IN std_logic;
	reset : IN std_logic;
	ii_start : IN std_logic;
	din : IN std_logic_vector(11 downto 0);
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
	image_rdaddress : out STD_LOGIC_VECTOR(13 downto 0);
	done : OUT std_logic);
END COMPONENT;

COMPONENT ii_ram_buffer
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(18 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(18 DOWNTO 0);
    clkb : IN STD_LOGIC;
    web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addrb : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    dinb : IN STD_LOGIC_VECTOR(18 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(18 DOWNTO 0)
  );
END COMPONENT;
attribute box_type of ii_ram_buffer:
component is "black_box";

COMPONENT iix2_ram_buffer
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(22 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(22 DOWNTO 0);
    clkb : IN STD_LOGIC;
    web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addrb : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    dinb : IN STD_LOGIC_VECTOR(22 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(22 DOWNTO 0)
  );
END COMPONENT;
attribute box_type of iix2_ram_buffer:
component is "black_box";

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
	ii_rdaddress : OUT std_logic_vector(11 downto 0);
	iix2_rdaddress : OUT std_logic_vector(11 downto 0);
	result : OUT std_logic;
	done : OUT std_logic
	);
END COMPONENT;

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

component mux2to1_1bit
Port ( 
	a : in  STD_LOGIC;
	b : in  STD_LOGIC;
	s : in  STD_LOGIC;
	q : out  STD_LOGIC
	);
end component;

component mux2to1_nbit
Generic(DATA_WIDTH: integer := 14); 
Port (
	a : in  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
	b : in  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
	s : in  STD_LOGIC;
	q : out  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0)
	);
end component;

---- CLK SIGNAL ----
signal clk	: std_logic;
signal clk_roi : std_logic;
signal clk_vga : std_logic;
signal clk_iigen : std_logic;
signal clk_draw : std_logic;
signal ov7670_pclk_sig : std_logic;

-- VGA signals
signal activearea : std_logic;
signal display : std_logic;
signal vsync : std_logic;

-- Read signals main buffer
signal rddata_vga : std_logic_vector(11 downto 0);
signal rdaddr_vga : std_logic_vector(13 downto 0);

signal rddata_iigen : std_logic_vector(11 downto 0);
signal rdaddr_iigen : std_logic_vector(13 downto 0);

-- Write signal main buffer
signal wren_box : std_logic;
signal wraddr_box : std_logic_vector(13 downto 0);
signal wrdata_box : std_logic_vector(11 downto 0);


-- Read and write signals ii buffer
signal wren_iigen_buff : std_logic;
signal wrdata_iiA	: std_logic_vector(18 downto 0);
signal wrdata_iix2A : std_logic_vector(22 downto 0);
signal addr_iiA : std_logic_vector(11 downto 0);

signal rddata_iiA : std_logic_vector(18 downto 0);
signal rddata_iix2A : std_logic_vector(22 downto 0);

signal addr_iiB : std_logic_vector(11 downto 0);
signal rddata_iiB	: std_logic_vector(18 downto 0);
signal addr_iix2B : std_logic_vector(11 downto 0);
signal rddata_iix2B : std_logic_vector(22 downto 0);

signal mainbufferA_sel : std_logic;
signal mainbufferB_sel : std_logic;

signal clk_mainbufferA : std_logic;
signal clk_mainbufferB : std_logic;
signal addr_mainbufferA : std_logic_vector(13 downto 0);
signal addr_mainbufferB : std_logic_vector(13 downto 0);

-- Control signals
---- iigen
signal iigen_start : std_logic;
signal iigen_reset : std_logic;
signal iigen_done	: std_logic;
---- processing
signal roi_start : std_logic;
signal roi_reset : std_logic;
signal roi_done	: std_logic;
signal roi_result	: std_logic;

----drawing
signal draw_start : std_logic;
signal draw_reset : std_logic;
signal draw_done	: std_logic;

-- scale cnt
signal scale_cnt_en		: std_logic;
signal scale_cnt_reset 	: std_logic;

signal busy	: std_logic;
signal plllocked : std_logic;

signal mem_state : std_logic;
signal next_mem_state : std_logic;

-- Scaled
signal scale_cnt : std_logic_vector(1 downto 0);
type w_scaled_type is array (0 to 3) of std_logic_vector(5 downto 0);
constant w_scaled : w_scaled_type := (std_logic_vector(to_unsigned(0,6)),
												  std_logic_vector(to_unsigned(64,6)),
												  std_logic_vector(to_unsigned(53,6)),
												  std_logic_vector(to_unsigned(0,6)));

type h_scaled_type is array (0 to 3) of std_logic_vector(5 downto 0);
constant h_scaled : h_scaled_type := (std_logic_vector(to_unsigned(0,6)),
												  std_logic_vector(to_unsigned(48,6)),
												  std_logic_vector(to_unsigned(40,6)),
												  std_logic_vector(to_unsigned(0,6)));
signal scaled_width : std_logic_vector(5 downto 0);
signal scaled_height : std_logic_vector(5 downto 0);

-- ii generator address base
signal xbase_iigen : std_logic_vector(5 downto 0);
signal ybase_iigen : std_logic_vector(5 downto 0);
signal next_xbase_iigen : std_logic_vector(5 downto 0);
signal next_ybase_iigen : std_logic_vector(5 downto 0);

-- ii processing address base
signal xbase_iiproc : std_logic_vector(5 downto 0);
signal ybase_iiproc : std_logic_vector(5 downto 0);
signal next_xbase_iiproc : std_logic_vector(5 downto 0);
signal next_ybase_iiproc : std_logic_vector(5 downto 0);

-- sliding windows address_base
signal xbase_roi : std_logic_vector(5 downto 0);
signal ybase_roi : std_logic_vector(5 downto 0);
signal next_xbase_roi : std_logic_vector(5 downto 0);
signal next_ybase_roi : std_logic_vector(5 downto 0);

-- DRAW signal
signal xpos_roi : std_logic_vector(5 downto 0);
signal ypos_roi : std_logic_vector(5 downto 0);

-- ASM
type state_type is (reset_st, capturebegin_st, capture_st, scalereset_st, iigen_init_st, roireset_st, iigen_roi_reset_st, iigen_roi_st,
	scale_st, drawbegin_st, draw_st, doneframe_st);
signal current_state, next_state : state_type;

begin

pll_locked <= plllocked;
Inst_clk_pll: clk_pll PORT MAP(
		CLKIN_IN => clk50,
		RST_IN => '0',
		CLKDV_OUT => clk_vga,
		CLK0_OUT => clk,
		CLK2X_OUT => clk_iigen,
		LOCKED_OUT => plllocked);
clk_draw <= clk;
clk_roi <= clk;

image_main_buffer : image_buffer PORT MAP (
    clka => clk_mainBufferA,
    wea(0) => wren_box,
    addra => addr_mainbufferA,
    dina => wrdata_box,
    douta => rddata_vga,
    clkb => clk_mainBufferB,
    web(0) => '0',
    addrb => addr_mainbufferB,
    dinb => (others=>'0'),
    doutb => rddata_iigen);

Inst_ii_gen_top: ii_gen_top PORT MAP(
	clk => clk_iigen,
	reset => iigen_reset,
	ii_start => iigen_start, 
	din => rddata_iigen,
	image_scale => scale_cnt,
	scaleImg_x_base => xbase_iigen,
	scaleImg_y_base => ybase_iigen,
	mem_state => mem_state,
	ii_data_in => rddata_iiA,
	iix2_data_in => rddata_iix2A,
	ii_wren => wren_iigen_buff,
	ii_address => addr_iiA,
	ii_data_o => wrdata_iiA,
	iix2_data_o => wrdata_iix2A,
	image_rdaddress => rdaddr_iigen,
	done => iigen_done);
	
ii_buffer : ii_ram_buffer
  PORT MAP (
    clka => clk_iigen,
    wea(0) => wren_iigen_buff,
    addra => addr_iiA,
    dina => wrdata_iiA,
    douta => rddata_iiA,
    clkb => clk,
    web(0) => '0',
    addrb => addr_iiB,
    dinb => (others=>'0'),
    doutb => rddata_iiB);
 
iix2_buffer : iix2_ram_buffer
  PORT MAP (
    clka => clk_iigen,
    wea(0) => wren_iigen_buff,
    addra => addr_iiA,
    dina => wrdata_iix2A,
    douta => rddata_iix2A,
    clkb => clk,
    web(0) => '0',
    addrb => addr_iix2B,
    dinb => (others=>'0'),
    doutb => rddata_iix2B);

Inst_processing_top: processing_top PORT MAP(
	reset => roi_reset,
	clk => clk_roi,
	start => roi_start,
	mem_state => mem_state,
	x_base => xbase_roi,
	y_base => ybase_roi,
	ii_rd_data => rddata_iiB,
	iix2_rd_data => rddata_iix2B,
	ii_rdaddress => addr_iiB,
	iix2_rdaddress => addr_iix2B,
	result => roi_result,
	done => roi_done);

xpos_roi <= std_logic_vector(unsigned(xbase_iiproc) + unsigned(xbase_roi)); 
ypos_roi <= std_logic_vector(unsigned(ybase_iiproc) + unsigned(ybase_roi));
Inst_draw: draw PORT MAP(
	reset => draw_reset,
	clk_roi => clk_roi,
	clk_draw => clk_draw,
	start_draw => draw_start,
	scale => scale_cnt,
	xpos_roi => xpos_roi,
	ypos_roi => ypos_roi,
	roi_done => roi_done,
	roi_result => roi_result,
	box_wraddress => wraddr_box,
	box_wrdata => wrdata_box,
	box_wren => wren_box,
	draw_done => draw_done
);

Inst_vga_addr_gen: vga_addr_gen PORT MAP(
	clk_vga => clk_vga,
	enable => display,
	vsync => vsync,
	address => rdaddr_vga
);

Inst_vga_timing: vga_timing PORT MAP(
	clk => clk_vga,
	Hsync => vga_hsync,
	Vsync => vsync,
	activeArea => activeArea,
	dispArea => display);

Inst_vga_color: vga_color PORT MAP(
	Data_in => rddata_vga,
	activeArea => activeArea,
	display => display,
	Red => vga_red,
	Green => vga_green,
	Blue => vga_blue);
vga_vsync <= vsync;	

-- Main Buffer Multiplexer
clkmuxA :  mux2to1_1bit port map (
	a => clk_vga,
	b => clk_draw,
	s => mainbufferA_sel,
	q => clk_mainBufferA);

clkmuxB :  mux2to1_1bit port map (
	a => ov7670_pclk_sig,
	b => clk_iigen,
	s => mainbufferB_sel,
	q => clk_mainBufferB);
	
addrmuxA	: mux2to1_nbit 
generic map(DATA_WIDTH => 14)
port map (
	a => rdaddr_vga,
	b => wraddr_box,
	s => mainbufferA_sel,
	q => addr_mainbufferA);

addrmuxB	: mux2to1_nbit 
generic map(DATA_WIDTH => 14)
port map (
	a => "00000000000000", -- should be available wraddr
	b => rdaddr_iigen,
	s => mainbufferB_sel,
	q => addr_mainbufferB);
	
scale_cnt_proc : process (clk, scale_cnt_reset, scale_cnt_en) 
	variable cnt : unsigned (1 downto 0) := to_unsigned(1,2);
begin
	if (scale_cnt_reset = '1') then
		cnt := to_unsigned(1,2);
	elsif (rising_edge(clk) and (scale_cnt_en = '1')) then
		cnt := cnt + 1;
	end if;
	scale_cnt <= std_logic_vector(cnt);
end process;
scaled_width <= w_scaled(to_integer(unsigned(scale_cnt)));
scaled_height <= h_scaled(to_integer(unsigned(scale_cnt)));

-- ALGORITHMIC STATE MACHINE
-- -- Sync Process
SYNC_PROC : process (clk, reset,plllocked) begin
	if rising_edge (clk) then
		if reset = '1' or plllocked = '0' then
			current_state <= reset_st;
			mem_state <= '0';
			xbase_iigen <= (others => '0');
			ybase_iigen <= (others => '0');
			xbase_iiproc<= (others => '0');
			ybase_iiproc<= (others => '0');
		else
			current_state <= next_state;
			mem_state <= next_mem_state;
			xbase_roi <= next_xbase_roi;
			ybase_roi <= next_ybase_roi;
			xbase_iigen <= next_xbase_iigen;
			ybase_iigen <= next_ybase_iigen;
			xbase_iiproc <= next_xbase_iiproc;
			ybase_iiproc <= next_ybase_iiproc;
		end if;
	end if;
end process;

STATE_OUTPUT_DECODE : process (current_state, iigen_start, iigen_done, roi_start, roi_done, draw_start, draw_done, 
	scaled_width, scaled_height, xbase_iigen, ybase_iigen, xbase_iiproc, ybase_iiproc,
	xbase_roi, ybase_roi, mem_state, available, busy, roi_result, scale_cnt) 
begin

iigen_start	<= '0';
iigen_reset	<= '0';
roi_reset		<= '0';
roi_start		<= '0';
draw_start		<= '0';
draw_reset		<= '0';
scale_cnt_en	<= '0';
scale_cnt_reset<= '0';

next_mem_state <= mem_state;
next_xbase_roi	<= xbase_roi;
next_ybase_roi	<= ybase_roi;
next_xbase_iigen	<= xbase_iigen;
next_ybase_iigen	<= ybase_iigen;
next_xbase_iiproc	<= xbase_iiproc;
next_ybase_iiproc <= ybase_iiproc;
mainbufferA_sel <= '0';
mainbufferB_sel <= '0';

case current_state is
	when reset_st 			=>
		iigen_reset	<= '1';
		roi_reset 		<= '1';
		draw_reset		<= '1';
		scale_cnt_reset<= '1';
		next_mem_state <= '0';		
		next_xbase_roi	<= (others => '0');
		next_ybase_roi	<= (others => '0');
		next_xbase_iigen	<= (others => '0');
		next_ybase_iigen	<= (others => '0');
		next_xbase_iiproc	<= (others => '0');
		next_xbase_iiproc	<= (others => '0');	
		next_state <= capturebegin_st;
		
	when capturebegin_st =>
		if available = '1' then
			busy <= '1';
			next_state <= capture_st;
		else
			next_state <= scalereset_st;
		end if;
		
	when capture_st		=>
		if busy = '0' then
			next_state <= scalereset_st;
		else
			next_state <= capturebegin_st;
		end if;

	when scalereset_st	=>
		iigen_reset 	<= '1';
		roi_reset		<= '1';
		
		next_mem_state <= '0';
		next_xbase_roi <= (others => '0');
		next_ybase_roi <= (others => '0');
		next_xbase_iigen	<= (others => '0');
		next_ybase_iigen	<= (others => '0');
		next_xbase_iiproc	<= (others => '0');
		next_xbase_iiproc	<= (others => '0');	
		next_state <= iigen_init_st;
	
	when iigen_init_st	=>
		if iigen_done = '1' then	-- first ii generated
			next_xbase_iigen 	<= std_logic_vector(to_unsigned(1,6));
			next_ybase_iigen 	<= (others=>'0');
			next_state		<= iigen_roi_reset_st;
		else
			iigen_start	<= '1';
			mainbufferB_sel <= '1';
			next_state		<= iigen_init_st;
		end if;
		
	when roireset_st		=>
		mainbufferB_sel <= '1';
		roi_reset <= '1';
		if roi_result = '1' then
			next_state <= roireset_st;
		else
			next_state <= iigen_roi_st;
		end if;
	
	when iigen_roi_reset_st =>
		mainbufferB_sel <= '1';
		iigen_reset 	<= '1';
		roi_reset		<= '1';
		if roi_result = '1' then
			next_state	<= iigen_roi_reset_st;
		else
			next_state	<= iigen_roi_st;
			next_mem_state <= not mem_state;
		end if;
	
	when iigen_roi_st		=>
		next_xbase_roi		<= (others => '0');
		mainbufferB_sel 	<= '1';
		iigen_start		<= '1';
		roi_start			<= '1';
		
		if roi_done = '1' then
			if (unsigned(ybase_roi) <= (II_HEIGHT-ROI_HEIGHT) and -- < or <= ?
				(unsigned(ybase_roi) <= (unsigned(scaled_height)-ROI_HEIGHT))) then
				next_ybase_roi <= std_logic_vector(unsigned(ybase_roi) + to_unsigned(1,6));
				next_state <= roireset_st;
			else
				if iigen_done = '1' then
					next_ybase_roi <= (others => '0'); -- reset
					next_xbase_iiproc <= xbase_iigen;
					next_ybase_iiproc <= ybase_iigen;
					
					if (unsigned(xbase_iigen) <= (unsigned(scaled_width)-II_WIDTH)) then -- < or <= ?
						next_xbase_iigen <= std_logic_vector(unsigned(xbase_iigen) + to_unsigned(1,6)); -- + II_WIDTH - ROI_WIDTH -> 0
						next_state <= iigen_roi_reset_st;
					else
						if ((scale_cnt = "01")and(unsigned(ybase_iigen)) < (unsigned(scaled_height)-II_HEIGHT-to_unsigned(3,2))) then -- < or <= ?
							next_xbase_iigen <= (others => '0');
							-- After 11 rows of ROIs have been scanned, it remains 8 more. Its ybase will be incremented by 9, so the middle
							-- two rows are scanned TWICE. The purpose is simply not to modified the II dimension.
							next_ybase_iigen <= std_logic_vector(unsigned(ybase_iigen) + to_unsigned(8,6)); 
							next_state <= iigen_roi_reset_st;
						else
							next_state <= scale_st;
						end if;
					end if;
				else -- ii_gen_done = 0 not done yet
					next_state <= iigen_roi_st;
				end if;
			end if;
		else -- roi_done = 0
			next_state <= iigen_roi_st;
		end if;

	when scale_st			=>
		iigen_reset 	<= '1';
		roi_reset		<= '1';
		if scale_cnt = "10" then
			next_state <= drawbegin_st;
		else
			scale_cnt_en <= '1';
			next_state <= scalereset_st;
		end if;
		
	when drawbegin_st		=>
		draw_start <= '1';
		next_state <= draw_st;
		
	when draw_st			=>
		mainbufferA_sel <= '1';
		if draw_done <= '0' then
			draw_start <= '1';
			next_state <= draw_st;
		else
			next_state <= doneframe_st;
		end if;
	
	when doneframe_st =>
		next_state <= doneframe_st;
end case;
end process;
end Behavioral;

