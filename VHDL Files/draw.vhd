---------------------------------------------------------------------------------- 
-- This Component are made to generate box on detected ROI on screen
-- Designer : Jason Danny Setiawan
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity draw is
    Port ( reset : in  STD_LOGIC;
           clk_roi : in  STD_LOGIC;
           clk_draw : in  STD_LOGIC;
           start_draw : in  STD_LOGIC;
           scale : in  STD_LOGIC_VECTOR (1 downto 0);
           xpos_roi : in  STD_LOGIC_VECTOR (5 downto 0);
           ypos_roi : in  STD_LOGIC_VECTOR (5 downto 0);
           roi_done : in  STD_LOGIC;
           roi_result : in  STD_LOGIC;
			  
			  box_wraddress : out  STD_LOGIC_VECTOR (13 downto 0);
           box_wrdata : out  STD_LOGIC_VECTOR (11 downto 0);
           box_wren : out  STD_LOGIC;
           draw_done : out  STD_LOGIC);
end draw;

architecture Behavioral of draw is

component counter
	 Generic (COUNT_WIDTH : integer := 4);
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           en : in  STD_LOGIC;
           count : out  STD_LOGIC_VECTOR ((COUNT_WIDTH-1)downto 0));
end component;

component synch_counter
	Generic (COUNT_WIDTH : integer := 4);
	Port( clk: in std_logic;
			reset: in std_logic;
			en: in std_logic;
			count: out std_logic_vector(COUNT_WIDTH-1 downto 0));
end component;

COMPONENT fifo2
  PORT (
    a : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
    d : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    dpra : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
    clk : IN STD_LOGIC;
    we : IN STD_LOGIC;
    spo : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    dpo : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END COMPONENT;
attribute box_type : string;
attribute box_type of fifo2:
component is "black_box";
			
signal info_in : std_logic_vector (15 downto 0);
signal info_out: std_logic_vector (15 downto 0) := (others=>'0');

signal detection : std_logic;
signal scale_sig : std_logic_vector (1 downto 0);
signal xpos_sig : std_logic_vector (5 downto 0);
signal ypos_sig : std_logic_vector (5 downto 0);

signal counter_in_reset : std_logic;
signal counter_in_en : std_logic;
signal count_box_in : std_logic_vector (8 downto 0) := (others => '0');

signal counter_out_reset : std_logic;
signal counter_out_en : std_logic;
signal count_box_out : std_logic_vector(8 downto 0);

signal counter_dim_reset : std_logic;
signal counter_dim_en : std_logic;
signal count_dim : std_logic_vector(7 downto 0);

signal xbox_s1 : std_logic_vector(6 downto 0);
signal xbox_s2 : std_logic_vector(11 downto 0);
signal xbox_s2a : std_logic_vector(11 downto 0);
signal xbox_s2b : std_logic_vector(11 downto 0);
signal xbox_s2c : std_logic_vector(11 downto 0);
signal xbox_s2d : std_logic_vector(11 downto 0);
signal xbox : std_logic_vector(6 downto 0);

signal ybox_s1 : std_logic_vector(6 downto 0);
signal ybox_s2 : std_logic_vector(11 downto 0);
signal ybox_s2a : std_logic_vector(11 downto 0);
signal ybox_s2b : std_logic_vector(11 downto 0);
signal ybox_s2c : std_logic_vector(11 downto 0);
signal ybox_s2d : std_logic_vector(11 downto 0);
signal ybox : std_logic_vector(6 downto 0);
signal ybox_m : std_logic_vector(7 downto 0);

signal offset : std_logic_vector(15 downto 0);
signal box_base_address : std_logic_vector(15 downto 0);

signal sel_inc_num : std_logic;
signal inc_num : std_logic_vector(7 downto 0);

signal rewr_address_reset : std_logic
;
signal rewr_address_accum_en : std_logic;
signal rewr_address_sig : std_logic_vector(13 downto 0);
signal img_rewr_en: std_logic;

signal hor_box_dimension : std_logic_vector (7 downto 0);
signal ver_box_dimension : std_logic_vector (7 downto 0);

signal count_out : std_logic_vector(8 downto 0) := "000000001";

signal counter_top : std_logic_vector(2 downto 0):= "000";

type state_type is (reset_st, info_st, buffsetup_st, top_st, right_st, left_st, bottom_st, 
	checkboxout_st, done_st,top_del_st);
signal current_state, next_state : state_type;

begin

counter_in_reset <= reset;
counter_in_en <= roi_result;

-- DATA IN RESULT CONCATENATED
info_in <= '0' & roi_result & scale & xpos_roi & ypos_roi;

-- DATA OUT RESULT SPLITTED
detection 	<= '1';
scale_sig 	<= info_out(13 downto 12);
xpos_sig		<= info_out(11 downto 6);
ypos_sig		<= info_out(5 downto 0);

fifo : fifo2
  PORT MAP (
    a => count_box_in,
    d => info_in,
    dpra => count_out,
    clk => clk_roi,
    we => roi_result,
    spo => open,
    dpo => info_out
  );

-- PARAMETERS RELATIVE TO II
process (scale_sig) begin
	case scale_sig is
		when "01" => 
			hor_box_dimension <= std_logic_vector(to_unsigned(100,8)); --50*2
			ver_box_dimension <= std_logic_vector(to_unsigned(60,8));  --30*2
		
		when "10" => 
			hor_box_dimension <= std_logic_vector(to_unsigned(120,8)); --50*77/32
			ver_box_dimension <= std_logic_vector(to_unsigned(72,8));  --30*77/32
		
		when others =>
			hor_box_dimension <= std_logic_vector(to_unsigned(0,8)); --invalid
			ver_box_dimension <= std_logic_vector(to_unsigned(0,8)); --invalid
	end case;
end process;
---
xbox_s1	<= xpos_sig & '0';

xbox_s2a	<=	xpos_sig & "000000";
xbox_s2b <= "000" & xpos_sig & "000";
xbox_s2c <= "0000" & xpos_sig & "00";
xbox_s2d <= "000000" & xpos_sig;
xbox_s2 <= std_logic_vector(unsigned(xbox_s2a) + unsigned(xbox_s2b) + unsigned(xbox_s2c) + unsigned(xbox_s2d));

ybox_s1	<= ypos_sig & '0';

ybox_s2a	<=	ypos_sig & "000000";
ybox_s2b <= "000" & ypos_sig & "000";
ybox_s2c <= "0000" & ypos_sig & "00";
ybox_s2d <= "000000" & ypos_sig;
ybox_s2 <= std_logic_vector(unsigned(ybox_s2a) + unsigned(ybox_s2b) + unsigned(ybox_s2c) + unsigned(ybox_s2d));

process (scale_sig, xbox_s1, xbox_s2, ybox_s1, ybox_s2) begin
	case scale_sig is
		when "01" =>
			xbox <= xbox_s1 (6 downto 0); 
			ybox <= ybox_s1 (6 downto 0);
		when "10" => 
			xbox <= xbox_s2 (11 downto 5); 
			ybox <= ybox_s2 (11 downto 5);
		when others =>
			xbox <= (others => '0');
			ybox <= (others => '0');
	end case;
end process;
			
ybox_m <= '0' & ybox;			
offset <= std_logic_vector(unsigned(ybox_m)*to_unsigned(128,8)); -- 8bit * 8 bit = 16 bit
box_base_address <= std_logic_vector(unsigned(offset) + unsigned(xbox)); -- 16 bit

-- INCREMENT NUMBER
-- FOR HORIZONTAL INCREASE BY 1, while FOR VERTICAL INCREASE BY IMG_WIDTH = 160
mux_inc_num: process (sel_inc_num)
 begin
   if sel_inc_num='0' then
	  inc_num <= std_logic_vector(to_unsigned(1,8)); -- FOR TOP AND BOTTOM
	else 
	  inc_num <= std_logic_vector(to_unsigned(128,8)); -- FOR RIGHT AND LEFT
	end if;
 end process;
	
-- MULTIPLEXER
rewr_address_reg: process (clk_draw, rewr_address_reset, rewr_address_accum_en, box_base_address, inc_num)
 begin
   if rising_edge(clk_draw) then
	  if rewr_address_reset = '1' then
	    rewr_address_sig <= box_base_address(13 downto 0);
	  elsif rewr_address_accum_en = '1' then
	    rewr_address_sig <= std_logic_vector(unsigned(rewr_address_sig) + unsigned(inc_num)); -- 14 bit
	  end if;
   end if;
 end process;

box_in_cnt : counter
	generic map (COUNT_WIDTH => 9)
	port map(
		clk	=> clk_roi,
		rst	=> counter_in_reset,
		en		=> counter_in_en,
		count => count_box_in);

box_out_cnt : counter
	generic map (COUNT_WIDTH => 9)
	port map(
		clk	=> clk_draw,
		rst	=> counter_out_reset,
		en		=> counter_out_en,
		count	=> count_box_out);

line_pixel_cnt : synch_counter
	generic map (COUNT_WIDTH => 8)
	port map(
		clk	=> clk_draw,
		reset	=> counter_dim_reset,
		en		=> counter_dim_en,
		count => count_dim);

mux_read_wr : process (clk_roi, count_box_in) begin
	if rising_edge (clk_roi) then
		if count_box_in = "000000000" then
			count_out <= "111111111";
		else
			count_out <= count_box_out;
		end if;
	end if;
end process;
---------------
----- FSM -----
---------------
SYNCH_PROC : process (clk_draw,reset) begin
	if reset = '1' then
		current_state <= reset_st;
	elsif rising_edge(clk_draw) then
		current_state <= next_state;
	end if;
end process;

FSM : process(current_state, start_draw, count_dim, hor_box_dimension, ver_box_dimension, count_box_in, count_out,detection) 
begin
	rewr_address_reset <= '0';
	sel_inc_num <= '0';
	img_rewr_en <= '0';
	rewr_address_accum_en <= '0';
	counter_dim_reset	<= '0';
	counter_dim_en <= '0';
	counter_out_reset <= '0';
	counter_out_en <= '0';
	draw_done	<= '0';

case current_state is
	when reset_st =>
		counter_out_reset <= '1';
		if start_draw = '1' then
			if (unsigned(count_box_in) = to_unsigned(0,9))then
				next_state <= done_st;
			else
				next_state <= info_st;
			end if;
		else
			next_state <= reset_st;
		end if;
	
	when info_st =>
			next_state <= buffsetup_st;
			
	when buffsetup_st =>
		counter_out_en <= '0';
		rewr_address_reset <= '1';
		if detection = '1' then
			next_state <= top_st;
		else
			next_state <= checkboxout_st;
		end if;
--	A-----B
--
-- C		D
	when top_st =>
		img_rewr_en <= '1';
		
		if (unsigned(count_dim) < unsigned(hor_box_dimension)) then
			rewr_address_accum_en <= '1';
			counter_dim_en <= '1';
			sel_inc_num <= '0';
			next_state <= top_st;
		else
			counter_dim_reset <= '1';
			next_state <= right_st;
		end if;
	
	when top_del_st =>
		rewr_address_accum_en <= '1';
		rewr_address_reset <= '0';
		sel_inc_num <= '1';
		next_state <= top_st;
--	A-----B
--			|
-- C		D
	when right_st =>
		img_rewr_en <= '1';
		sel_inc_num <= '1';
		
		if count_dim < ver_box_dimension then
			rewr_address_accum_en <= '1';
			counter_dim_en <= '1';
			next_state <= right_st;
		else
			counter_dim_reset <= '1';
			rewr_address_reset <= '1'; -- BACK TO A
			next_state <= left_st;
		end if;
--	A-----B
--	|		|
-- C		D		
	when left_st =>
		img_rewr_en <= '1';
		sel_inc_num <= '1';
		
		if count_dim < ver_box_dimension then
			rewr_address_accum_en <= '1';
			counter_dim_en <= '1';
			next_state <= left_st;
		else
			counter_dim_reset <= '1';
			next_state <= bottom_st;
		end if;

--	A-----B
--	|		|
-- C-----D		
	when bottom_st =>
		img_rewr_en <= '1';
		sel_inc_num <= '0';
		
		if count_dim < hor_box_dimension then
			rewr_address_accum_en <= '1';
			counter_dim_en <= '1';
			next_state <= bottom_st;
		else
			counter_dim_reset <= '1';
			next_state <= checkboxout_st;
		end if;

	when checkboxout_st =>
		if unsigned(count_out) = unsigned(count_box_in)-1 then
	      next_state <= done_st;
	   else
			counter_out_en<= '1';  -- inc count_box_out to address new box parameters
	      counter_dim_reset <= '1'; -- sync reset img_wraddress to box_base_address for next s_TOP state, if any
        next_state <= info_st;
	   end if;
	
	when done_st =>
		draw_done <= '1';
		next_state <= reset_st;
	end case;
end process;

--output
box_wrdata		<= "111100000000"; -- Merah aja ya :)) (RED)
box_wraddress	<= rewr_address_sig;
box_wren			<= img_rewr_en;
end Behavioral;

