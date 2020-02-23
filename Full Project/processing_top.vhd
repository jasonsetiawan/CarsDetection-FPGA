-----------------------------------------------------------------
-- TOP ENTITY of DETECTION
-- Designer : Jason Danny Setiawan
-----------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity processing_top is
    Port ( reset : in  STD_LOGIC;		
           clk : in  STD_LOGIC;		-- 100MHz
           start : in  STD_LOGIC; 	-- Logic '1' will trigger this entity
           mem_state : in  STD_LOGIC;
           x_base : in  STD_LOGIC_VECTOR (5 downto 0); -- max 49
           y_base : in  STD_LOGIC_VECTOR (5 downto 0); -- max 39
           ii_rd_data : in  STD_LOGIC_VECTOR (18 downto 0);
           iix2_rd_data : in  STD_LOGIC_VECTOR (22 downto 0);
           ii_rdaddress : out  STD_LOGIC_VECTOR (11 downto 0); -- You'll have to change to ((12-n) downto 0) if u use 2^n channels output.
           iix2_rdaddress : out  STD_LOGIC_VECTOR (11 downto 0); -- You'll have to change to ((12-n) downto 0) if u use 2^n channels output.
           result : out  STD_LOGIC;
			  done : out  STD_LOGIC
			  );
end processing_top;

architecture Behavioral of processing_top is

-------------------------------------------------
-- Address Decoder Related component and signal--
-------------------------------------------------
component address_decoder
	 Port ( ii_reg_index : in  STD_LOGIC_VECTOR (3 downto 0);
           width_ii : in  STD_LOGIC_VECTOR (5 downto 0);
           offset : in  STD_LOGIC_VECTOR (11 downto 0);
           x_rect0 : in  STD_LOGIC_VECTOR (5 downto 0);
           y_rect0 : in  STD_LOGIC_VECTOR (5 downto 0);
           w_rect0 : in  STD_LOGIC_VECTOR (5 downto 0);
           h_rect0 : in  STD_LOGIC_VECTOR (5 downto 0);
           x_rect1 : in  STD_LOGIC_VECTOR (5 downto 0);
           y_rect1 : in  STD_LOGIC_VECTOR (5 downto 0);
           w_rect1 : in  STD_LOGIC_VECTOR (5 downto 0);
           h_rect1 : in  STD_LOGIC_VECTOR (5 downto 0);
           x_rect2 : in  STD_LOGIC_VECTOR (5 downto 0);
           y_rect2 : in  STD_LOGIC_VECTOR (5 downto 0);
           w_rect2 : in  STD_LOGIC_VECTOR (5 downto 0);
           h_rect2 : in  STD_LOGIC_VECTOR (5 downto 0);
           ii_address : out  STD_LOGIC_VECTOR (11 downto 0));
end component address_decoder;

component ii_offset
	 Port ( mem_state : in  STD_LOGIC;
           x : in  STD_LOGIC_VECTOR (5 downto 0);
           y : in  STD_LOGIC_VECTOR (5 downto 0);
           width : in  STD_LOGIC_VECTOR (5 downto 0);
           offset : out  STD_LOGIC_VECTOR (11 downto 0));
end component ii_offset;

component iix2_address_decoder
	Port (  iix2_reg_index : in  STD_LOGIC_VECTOR (1 downto 0);
           width : in  STD_LOGIC_VECTOR (5 downto 0);
           offset : in  STD_LOGIC_VECTOR (11 downto 0);
           iix2_address : out  STD_LOGIC_VECTOR (11 downto 0));
end component iix2_address_decoder;

constant II_WIDTH : unsigned(5 downto 0) := to_unsigned(50,6);
constant II_HEIGHT : unsigned(5 downto 0) := to_unsigned(40,6);

signal x_rect0 : std_logic_vector(5 downto 0);
signal x_rect1 : std_logic_vector(5 downto 0);
signal x_rect2 : std_logic_vector(5 downto 0);
signal y_rect0 : std_logic_vector(5 downto 0);
signal y_rect1 : std_logic_vector(5 downto 0);
signal y_rect2 : std_logic_vector(5 downto 0);
signal w_rect0 : std_logic_vector(5 downto 0);
signal w_rect1 : std_logic_vector(5 downto 0);
signal w_rect2 : std_logic_vector(5 downto 0);
signal h_rect0 : std_logic_vector(5 downto 0);
signal h_rect1 : std_logic_vector(5 downto 0);
signal h_rect2 : std_logic_vector(5 downto 0);

signal offset_sig : std_logic_vector(11 downto 0);
signal ii_reg_index : std_logic_vector(3 downto 0);
signal iix2_reg_index: std_logic_vector(1 downto 0);

signal iix2_address_sig : std_logic_vector(11 downto 0);
signal ii_address_sig : std_logic_vector(11 downto 0);
signal ii_rdaddress_mux_selector : std_logic;
signal ii_address_mux : std_logic_vector(11 downto 0);
 
signal weak_stage_num: std_logic_vector(3 downto 0); 

------------------------------------------------
----- Counter Related component and signal -----
------------------------------------------------
component counter
	 Generic (COUNT_WIDTH : integer := 4);
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           en : in  STD_LOGIC;
           count : out  STD_LOGIC_VECTOR ((COUNT_WIDTH-1)downto 0));
end component counter;

signal strongStage_count: std_logic_vector(3 downto 0); -- unsigned
signal weakNode_count: std_logic_vector(6 downto 0); -- unsigned
signal weak_count: std_logic_vector(3 downto 0);
-----------------------------------------------
--			        Control Signal              --
-----------------------------------------------
signal cascade_done: std_logic;
signal cascade_start: std_logic;
  
signal calculation_reset: std_logic; -- reset the strong accumulator to zero
signal en_strongAccum_sig: std_logic;
signal en_var_norm_sig: std_logic;
  
signal ii_reg_we_sig: std_logic;
signal ii_reg_address: std_logic_vector(3 downto 0); -- unsigned

signal ii_rdaddress_mux_sel: std_logic;
signal iix2_reg_we_sig: std_logic;
signal iix2_regLoad_DONE: std_logic;
signal iix2_regLoad_DONE_latch: std_logic;
signal iix2_regLoad_DONE_reset: std_logic;

signal ii_reg_index_count_en: std_logic;
signal ii_reg_index_count_reset: std_logic;
signal weakNode_count_en: std_logic;
signal weakNode_count_reset: std_logic;
signal weak_count_en: std_logic;
signal weak_count_reset: std_logic;
signal strongStage_count_en: std_logic;
signal strongStage_count_reset: std_logic;
signal iix2_reg_index_count_en: std_logic;
signal iix2_reg_index_count_reset: std_logic;

signal detection : std_logic := '1';

type state_type is (reset_state, latch_rom_state, latch_ram_address_state, read_mem_state,
	latch_iix2_reg_state, latch_ii_reg_state, latch_strong_accu_state, latch_strong_cmp_state, flagdone_state, done_state);
signal current_state, next_state : state_type;

----------------------------------------------------------------------------
-- 									ROM COMPONENT										  --
----------------------------------------------------------------------------
component leftLeaves_rom
	Port ( clk	: in std_logic;
			 a 	: in std_logic_vector(6 downto 0);
			 spo	: out std_logic_vector(14 downto 0));
end component;
attribute box_type : string;
attribute box_type of leftLeaves_rom:
component is "black_box";

component rightLeaves_rom
	Port ( clk	: in std_logic;
			 a 	: in std_logic_vector(6 downto 0);
			 spo	: out std_logic_vector(14 downto 0));
end component;
attribute box_type of rightLeaves_rom:
component is "black_box";

component weakTresh_rom
	Port ( clk	: in std_logic;
			 a 	: in std_logic_vector(6 downto 0);
			 spo	: out std_logic_vector(11 downto 0));
end component;
attribute box_type of weakTresh_rom:
component is "black_box";

component weakStageNum_rom
	Port ( clk	: in std_logic;
			 a 	: in std_logic_vector(3 downto 0);
			 spo	: out std_logic_vector(3 downto 0));
end component; 
attribute box_type of weakStageNum_rom:
component is "black_box";

component strongThresh_rom
	Port ( clk	: in std_logic;
			 a 	: in std_logic_vector(3 downto 0);
			 spo	: out std_logic_vector(14 downto 0));
end component; 
attribute box_type of strongThresh_rom:
component is "black_box";

component rect0_x_rom
	Port ( clk	: in std_logic;
			 a 	: in std_logic_vector(6 downto 0);
			 spo	: out std_logic_vector(5 downto 0));
end component;
attribute box_type of rect0_x_rom:
component is "black_box";

component rect0_y_rom
	Port ( clk	: in std_logic;
			 a 	: in std_logic_vector(6 downto 0);
			 spo	: out std_logic_vector(5 downto 0));
end component;
attribute box_type of rect0_y_rom:
component is "black_box";

component rect0_w_rom
	Port ( clk	: in std_logic;
			 a 	: in std_logic_vector(6 downto 0);
			 spo	: out std_logic_vector(5 downto 0));
end component;
attribute box_type of rect0_w_rom:
component is "black_box";

component rect0_h_rom
	Port ( clk	: in std_logic;
			 a 	: in std_logic_vector(6 downto 0);
			 spo	: out std_logic_vector(5 downto 0));
end component;
attribute box_type of rect0_h_rom:
component is "black_box";

component rect0_weight_rom
	Port ( clk	: in std_logic;
			 a 	: in std_logic_vector(6 downto 0);
			 spo	: out std_logic_vector(21 downto 0));
end component;
attribute box_type of rect0_weight_rom:
component is "black_box";

component rect1_x_rom
	Port ( clk	: in std_logic;
			 a 	: in std_logic_vector(6 downto 0);
			 spo	: out std_logic_vector(5 downto 0));
end component;
attribute box_type of rect1_x_rom:
component is "black_box";

component rect1_y_rom
	Port ( clk	: in std_logic;
			 a 	: in std_logic_vector(6 downto 0);
			 spo	: out std_logic_vector(5 downto 0));
end component;
attribute box_type of rect1_y_rom:
component is "black_box";

component rect1_w_rom
	Port ( clk	: in std_logic;
			 a 	: in std_logic_vector(6 downto 0);
			 spo	: out std_logic_vector(5 downto 0));
end component;
attribute box_type of rect1_w_rom:
component is "black_box";

component rect1_h_rom
	Port ( clk	: in std_logic;
			 a 	: in std_logic_vector(6 downto 0);
			 spo	: out std_logic_vector(5 downto 0));
end component;
attribute box_type of rect1_h_rom:
component is "black_box";

component rect1_weight_rom
	Port ( clk	: in std_logic;
			 a 	: in std_logic_vector(6 downto 0);
			 spo	: out std_logic_vector(21 downto 0));
end component;
attribute box_type of rect1_weight_rom:
component is "black_box";

component rect2_x_rom
	Port ( clk	: in std_logic;
			 a 	: in std_logic_vector(6 downto 0);
			 spo	: out std_logic_vector(5 downto 0));
end component;
attribute box_type of rect2_x_rom:
component is "black_box";

component rect2_y_rom
	Port ( clk	: in std_logic;
			 a 	: in std_logic_vector(6 downto 0);
			 spo	: out std_logic_vector(5 downto 0));
end component;
attribute box_type of rect2_y_rom:
component is "black_box";

component rect2_w_rom
	Port ( clk	: in std_logic;
			 a 	: in std_logic_vector(6 downto 0);
			 spo	: out std_logic_vector(5 downto 0));
end component;
attribute box_type of rect2_w_rom:
component is "black_box";

component rect2_h_rom
	Port ( clk	: in std_logic;
			 a 	: in std_logic_vector(6 downto 0);
			 spo	: out std_logic_vector(5 downto 0));
end component;
attribute box_type of rect2_h_rom:
component is "black_box";

component rect2_weight_rom
	Port ( clk	: in std_logic;
			 a 	: in std_logic_vector(6 downto 0);
			 spo	: out std_logic_vector(21 downto 0));
end component;
attribute box_type of rect2_weight_rom:
component is "black_box";
--------------------------------------------------------
--						 DATAPATH SIGNAL							--
--------------------------------------------------------
signal strong_tresh 	: std_logic_vector (14 downto 0);
signal weakthresh		: std_logic_vector (11 downto 0); 
signal leftleaves 	: std_logic_vector (14 downto 0);
signal rightleaves 	: std_logic_vector (14 downto 0);

signal weight0		 	: std_logic_vector (21 downto 0);
signal weight1		 	: std_logic_vector (21 downto 0);
signal weight2		 	: std_logic_vector (21 downto 0);

signal ii_rd_data_mux1 : std_logic_vector (18 downto 0);
signal ii_rd_data_mux2 : std_logic_vector (18 downto 0);
signal ii_rd_data_mux : std_logic_vector (18 downto 0);
signal iix2_rd_data_mux : std_logic_vector (22 downto 0);

component klasifikasi
	Port ( clk : in  STD_LOGIC;
			 rst : in  STD_LOGIC;
          en_strongAccum : in  STD_LOGIC;
          en_varnorm : in  STD_LOGIC;
          leftleaf : in  STD_LOGIC_VECTOR (14 downto 0); --signed 14 bit
          rightleaf : in  STD_LOGIC_VECTOR (14 downto 0);--signed 14 bit
          weaktresh : in  STD_LOGIC_VECTOR (11 downto 0);-- signed 12 bit
          strongtresh : in  STD_LOGIC_VECTOR (14 downto 0);--signed 14 bit
          weight0 : in  STD_LOGIC_VECTOR (21 downto 0);
          weight1 : in  STD_LOGIC_VECTOR (21 downto 0);
          weight2 : in  STD_LOGIC_VECTOR (21 downto 0);
          ii_reg_we : in  STD_LOGIC;
          ii_reg_index : in  STD_LOGIC_VECTOR (3 downto 0);
          ii_data : in  STD_LOGIC_VECTOR (18 downto 0);
          iix2_reg_we : in  STD_LOGIC;
          iix2_reg_index : in  STD_LOGIC_VECTOR (1 downto 0);
          iix2_data : in  STD_LOGIC_VECTOR (22 downto 0);
          deteksi : out  STD_LOGIC);
end component;
 
begin

---- Pixel offset for roi scaning functionality ----
-- generates the base roi pixel address relative to the integral image dimensions
inst_pixel_offset : ii_offset port map 
	  (mem_state => mem_state,							-- '1' start from 0, '0' start from 4096
		x => x_base, 										-- range from 0 to 49
		y => y_base, 										-- range from 0 to 39
		width => std_logic_vector(II_WIDTH),		-- 50
		offset => offset_sig);							-- output
---- Integral Image Address Decoder ----
-- generate addresses relative to roi to register rectangle feature values
inst_ii_address_decoder : address_decoder port map
	(ii_reg_index => ii_reg_index,
	 width_ii => std_logic_vector(II_WIDTH),
	 offset   => offset_sig,
	 x_rect0  => x_rect0,
	 y_rect0  => y_rect0,
	 w_rect0  => w_rect0,
	 h_rect0  => h_rect0, 
	 x_rect1  => x_rect1,
	 y_rect1  => y_rect1,
	 w_rect1  => w_rect1,
	 h_rect1  => h_rect1,
	 x_rect2  => x_rect2,
	 y_rect2  => y_rect2,
	 w_rect2  => w_rect2,
	 h_rect2  => h_rect2,
	 ii_address => ii_address_sig);

inst_iix2_address_decoder : iix2_address_decoder port map
	(iix2_reg_index => iix2_reg_index,
	 width			 => std_logic_vector(II_WIDTH),
	 offset			 => offset_sig,
	 iix2_address	 => iix2_address_sig
	);

---- Integral Image Read Address Multiplexer
--
ii_rd_addr_mux: process (ii_rdaddress_mux_selector, ii_address_sig, iix2_address_sig)
  begin
    if (ii_rdaddress_mux_selector = '1') then 
      ii_address_mux <= iix2_address_sig; 	-- read ram from iix2_address (used for corners in ii(x) as well)
    else 
      ii_address_mux <= ii_address_sig; 		-- read ram from ii_address (generated by address decoder)
    end if;
  end process;

ii_rdaddress <= ii_address_mux;
iix2_rdaddress <= iix2_address_sig;

-- II reg index increment
ii_reg_index_counter: counter
generic map(COUNT_WIDTH  => 4) 
port map(
	clk => clk,
	rst => ii_reg_index_count_reset,
	en => ii_reg_index_count_en,
	count => ii_reg_index
);

-- IIx2 reg index increment
iix2_reg_index_counter: counter
generic map(COUNT_WIDTH => 2)
port map(
	clk => clk,
	rst => iix2_reg_index_count_reset,
	en => iix2_reg_index_count_en,
	count => iix2_reg_index
);

-- weak node increment
-- -- This counter is used to load new parameters from ROM
weakNode_counter: counter
generic map(COUNT_WIDTH => 7)
port map(
	clk => clk,
	rst => weakNode_count_reset,
	en => weakNode_count_en,
	count => weakNode_count
);

-- weak num increment
-- -- This counter will show the number of weak stages passes by the roi
weak_counter: counter
generic map(COUNT_WIDTH => 4)
port map(
	clk => clk,
	rst => weak_count_reset,
	en => weak_count_en,
	count => weak_count
);

-- Strong stage increment
strongStage_counter: counter
generic map(COUNT_WIDTH => 4)
port map(
  clk => clk,
  rst => strongStage_count_reset,
  en => strongStage_count_en,
  count => strongStage_count
);

----------------------------------------------------------------------
--						SEMI-ALGORITHMIC STATE MACHINE			   		  --
----------------------------------------------------------------------

sync_process : process (clk, reset) begin
	if (reset = '1') then
		current_state <= reset_state;
	elsif (rising_edge(clk)) then
		current_state <= next_state;
	end if;
end process;

iix2_regLoad_DONE_reg: process (clk, iix2_regLoad_DONE_reset, iix2_regLoad_DONE_latch) begin
	if (iix2_regLoad_DONE_reset='1') then
		iix2_regLoad_DONE <= '0';
	elsif (rising_edge(clk) and (iix2_regLoad_DONE_latch='1')) then
		iix2_regLoad_DONE <= '1';
	end if;
end process;

cascade_start <= start;

STATE_MACHINE : process (current_state, cascade_start, weak_stage_num, weakNode_count, weak_count, 
	ii_reg_index, iix2_reg_index, iix2_regLoad_DONE, detection) begin

	en_var_norm_sig <= '0';
	calculation_reset <= '0';
	en_strongAccum_sig <= '0';
	ii_reg_we_sig <= '0';
	ii_reg_index_count_en <= '0';
	ii_reg_index_count_reset <= '0';
	iix2_reg_we_sig <= '0';
	iix2_reg_index_count_en <= '0';
	iix2_reg_index_count_reset <= '0';
	weakNode_count_en <= '0';
	weakNode_count_reset <= '0';
	weak_count_en <= '0';
	weak_count_reset <= '0';
	strongStage_count_en <= '0';
	strongStage_count_reset <= '0';
	ii_rdaddress_mux_selector <= '0';
	cascade_done <= '0';
	iix2_regLoad_DONE_latch <= '0';
	iix2_regLoad_DONE_reset <= '0';

	case current_state is
		when reset_state => 
		-- reset
			calculation_reset <= '1';
			ii_reg_index_count_reset   <= '1';
			iix2_reg_index_count_reset <= '1';
			weakNode_count_reset       <= '1';
			weak_count_reset           <= '1';
			strongStage_count_reset    <= '1';
			iix2_regLoad_DONE_reset    <= '1';
			result <= '0';
			if (cascade_start='1') then
				next_state <= latch_rom_state;
			else
				next_state <= reset_state;
			end if;
	
		when latch_rom_state =>								-- udah ke latching di proses terakhir, tinggal masukin
			ii_rdaddress_mux_selector  <= '1';
			next_state <= latch_ram_address_state;
		
		when latch_ram_address_state =>					-- Baca nilai RAM
			if (iix2_regLoad_DONE = '0') then			-- Done ketrigger saat udah selesai baca sudut
				ii_rdaddress_mux_selector <= '1'; 		-- Read corner value first
			else
				ii_rdaddress_mux_selector <= '0';		-- Read another value then
			end if;
			next_state <= read_mem_state;					-- Read rect value
			
		when read_mem_state =>
			if (iix2_regLoad_DONE = '0') then			-- Done ketrigger saat udah selesai baca sudut
				ii_rdaddress_mux_selector <= '1'; 		-- Read corner value first
				next_state <= latch_iix2_reg_state;		-- Read corner value, use address from iix2 (sama soalnya addressnya)
			else
				ii_rdaddress_mux_selector <= '0';		-- Read another value then
				next_state <= latch_ii_reg_state;		-- Read rect value
			end if;
		
		when latch_iix2_reg_state =>
			ii_rdaddress_mux_selector  <= '1';
			iix2_reg_we_sig <= '1';
			if (iix2_reg_index = "11") then				-- 4 corner register counter (00,01,10,11) counts at 11
				en_var_norm_sig <= '1';							-- start variance normalization
				iix2_regLoad_DONE_latch <= '1';			-- ngasi tanda biar ram nya baca fitur, bukan sudut lagi
				next_state <= latch_ram_address_state; -- balik ke ram address generator
			else
				iix2_reg_index_count_en <= '1'; 			-- increment ii and iix2 register index 
				next_state <= latch_ram_address_state;	-- baca lagi dengan index + 1
			end if;
		
		when latch_ii_reg_state =>
			en_var_norm_sig <= '1';								-- Calculation in progress, take a multiclock to do sqrt()
			ii_reg_we_sig <= '1';
			if (ii_reg_index = "1011") then				-- 0000 until 1011 (12) rectangle feature value latched
				next_state <= latch_strong_accu_state;
			else
				ii_reg_index_count_en <= '1';				-- increment sampai 12
				next_state <= latch_ram_address_state; -- Read again using index address + 1
			end if;
		
		when latch_strong_accu_state =>
			en_strongAccum_sig <= '1';							-- Mulai ngitung leaf
			ii_reg_index_count_reset <= '1';				-- index nya di nol in, biar fitur berikutnya bisa dicek
			if (unsigned(weak_count)) < (unsigned(weak_stage_num) - to_unsigned(1,4)) then  -- apakah weak stage nya udah tercek semua?
				weakNode_count_en <= '1';					-- sudah, increment weaknode count buat ganti nilai parameter rom
				weak_count_en		<= '1';					-- weak stage + 1, buat dirapel
				next_state <= latch_rom_state;			-- ganti param rom
			else
				next_state <= latch_strong_cmp_state;
			end if;
		
		when latch_strong_cmp_state =>
			if (unsigned(weakNode_count) < to_unsigned(61,6)) then
				weakNode_count_en <= '1';
				calculation_reset <= '1';
				weak_count_reset <= '1';
				if (detection = '1') then
					strongStage_count_en <= '1';
					next_state <= latch_rom_state;
				else
					next_state <= flagdone_state;
				end if;
			else
				if (detection = '1') then
					result <= '1';
				end if;
				next_state <= flagdone_state;
			end if;
		
		when flagdone_state =>
        cascade_done <= '1'; 					-- make sure that this flag is asserted for only one cycle 
        next_state <= done_state;
   
      when done_state => 
        next_state <= done_state; -- stay here and only reset when top level flags a reset	
		when others =>	
	end case;
end process;

done <= cascade_done;


-- ROM INSTANTIATION
-- STRONG CLASSIFIERS ROM
-- Strong Treshold ROM : Provide strong threshold data (signed int) from 10 stages.
	strongthreshrom : strongthresh_rom port map (
	clk => clk,
	a	 => strongStage_count,
	spo => strong_tresh);

-- Weak Stage Num ROM : Provide the number of weak classifier (signed int) from each 10 stages.
	weakstagenumrom : weakstagenum_rom port map (
	clk => clk,
	a	 => strongStage_count,
	spo => weak_stage_num);

-- WEAK CLASSIFIERS ROM
-- Weak Thresh ROM : Provide weak threshold value (signed int) from 67 weak classifiers.
	weakthreshrom : weaktresh_rom port map (
	clk => clk,
	a	 => weakNode_count,
	spo => weakthresh);
	
-- Left Leaves ROM : Provide left leaves value (signed int) from 67 weak classifiers.
	leftleavesrom : leftleaves_rom port map (
	clk => clk,
	a	 => weakNode_count,
	spo => leftleaves);
	
-- Right Leaves ROM : Provide right leaves value (signed int) from 67 weak classifiers.
	rightleavesrom : rightleaves_rom port map (
	clk => clk,
	a	 => weakNode_count,
	spo => rightleaves);
	
-- FEATURE ADDRESS & WEIGHT ROM
-- <--RECT0-->
-- R0x_rom : Provide x position of rectangle 0 in each feature.
	R0x_rom : rect0_x_rom port map (
	clk => clk,
	a	 => weakNode_count,
	spo => x_rect0);

-- R0y_rom : Provide y position of rectangle 0 in each feature.
	R0y_rom : rect0_y_rom port map (
	clk => clk,
	a	 => weakNode_count,
	spo => y_rect0);

-- R0w_rom : Provide w value of rectangle 0 in each feature.
	R0w_rom : rect0_w_rom port map (
	clk => clk,
	a	 => weakNode_count,
	spo => w_rect0);

-- R0h_rom : Provide h value of rectangle 0 in each feature.
	R0h_rom : rect0_h_rom port map (
	clk => clk,
	a	 => weakNode_count,
	spo => h_rect0);

-- R0x_rom : Provide weight of rectangle 0 in each feature.
	R0weight_rom : rect0_weight_rom port map (
	clk => clk,
	a	 => weakNode_count,
	spo => weight0);
	
-- <--RECT1-->
-- R1x_rom : Provide x position of rectangle 1 in each feature.
	R1x_rom : rect1_x_rom port map (
	clk => clk,
	a	 => weakNode_count,
	spo => x_rect1);

-- R1y_rom : Provide y position of rectangle 1 in each feature.
	R1y_rom : rect1_y_rom port map (
	clk => clk,
	a	 => weakNode_count,
	spo => y_rect1);

-- R1w_rom : Provide w value of rectangle 1 in each feature.
	R1w_rom : rect1_w_rom port map (
	clk => clk,
	a	 => weakNode_count,
	spo => w_rect1);

-- R1h_rom : Provide h value of rectangle 1 in each feature.
	R1h_rom : rect1_h_rom port map (
	clk => clk,
	a	 => weakNode_count,
	spo => h_rect1);

-- R1x_rom : Provide weight of rectangle 1 in each feature.
	R1weight_rom : rect1_weight_rom port map (
	clk => clk,
	a	 => weakNode_count,
	spo => weight1);

-- <--RECT2-->
-- R2x_rom : Provide x position of rectangle 2 in each feature.
	R2x_rom : rect2_x_rom port map (
	clk => clk,
	a	 => weakNode_count,
	spo => x_rect2);

-- R2y_rom : Provide y position of rectangle 2 in each feature.
	R2y_rom : rect2_y_rom port map (
	clk => clk,
	a	 => weakNode_count,
	spo => y_rect2);

-- R2w_rom : Provide w value of rectangle 2 in each feature.
	R2w_rom : rect2_w_rom port map (
	clk => clk,
	a	 => weakNode_count,
	spo => w_rect2);

-- R2h_rom : Provide h value of rectangle 2 in each feature.
	R2h_rom : rect2_h_rom port map (
	clk => clk,
	a	 => weakNode_count,
	spo => h_rect2);

-- R2x_rom : Provide weight of rectangle 2 in each feature.
	R2weight_rom : rect2_weight_rom port map (
	clk => clk,
	a	 => weakNode_count,
	spo => weight2);

-----------------------------------------------------------------
-- 						SPECIAL CASE										--
-----------------------------------------------------------------	
special_ii : process (x_rect0,x_rect1,x_rect2,x_base,
							y_rect0,y_rect1,y_rect2,y_base,ii_reg_index,clk) 
begin
	if rising_edge(clk) then
		case (ii_reg_index) is
			when "0000" =>
				if (y_rect0 = "000000" and y_base = "000000") or (x_rect0 = "000000" and x_base = "000000") then
					ii_rd_data_mux2 <= (others=>'0');
				else
					ii_rd_data_mux2 <= ii_rd_data;
				end if;
			
			when "0001" =>
				if y_rect0 = "000000" and y_base = "000000" then
					ii_rd_data_mux2 <= (others=>'0');
				else
					ii_rd_data_mux2 <= ii_rd_data;
				end if;
			
			when "0010" =>
				if x_rect0 = "000000" and x_base = "000000" then
					ii_rd_data_mux2 <= (others=>'0');
				else
					ii_rd_data_mux2 <= ii_rd_data;
				end if;
				
			when "0100" =>
				if (y_rect1 = "000000" and y_base = "000000") or (x_rect1 = "000000" and x_base = "000000") then
					ii_rd_data_mux2 <= (others=>'0');
				else
					ii_rd_data_mux2 <= ii_rd_data;
				end if;
				
			when "0101" =>
				if y_rect1 = "000000" and y_base = "000000" then
					ii_rd_data_mux2 <= (others=>'0');
				else
					ii_rd_data_mux2 <= ii_rd_data;
				end if;
				
			when "0110" =>
				if x_rect1 = "000000" and x_base = "000000" then
					ii_rd_data_mux2 <= (others=>'0');
				else
					ii_rd_data_mux2 <= ii_rd_data;
				end if;
				
			when "1000" =>
				if x_rect2 = "000000" and x_base = "000000" then
					ii_rd_data_mux2 <= (others=>'0');
				else
					ii_rd_data_mux2 <= ii_rd_data;
				end if;	
				
			when "1001" =>
				if y_rect2 = "000000" and y_base = "000000" then
					ii_rd_data_mux2 <= (others=>'0');
				else
					ii_rd_data_mux2 <= ii_rd_data;
				end if;	
				
			when "1010" =>
				if (y_rect2 = "000000" and y_base = "000000") or (x_rect2 = "000000" and x_base = "000000") then
					ii_rd_data_mux2 <= (others=>'0');
				else
					ii_rd_data_mux2 <= ii_rd_data;
				end if;	

			when "1011" =>
				if (y_rect2 = "000000" and y_base = "000000") or (x_rect2 = "000000" and x_base = "000000") then
					ii_rd_data_mux2 <= (others=>'0');
				else
					ii_rd_data_mux2 <= ii_rd_data;
				end if;	
				
			when others =>
					ii_rd_data_mux2 <= ii_rd_data;
		end case;
	end if;
end process;

special_iix2 : process (clk,iix2_reg_index) begin
	if rising_edge(clk) then
		case (iix2_reg_index) is
			when "00" =>
				if x_base = "000000" or y_base = "000000"  then
					iix2_rd_data_mux <= (others=>'0');
					ii_rd_data_mux1 <= (others=>'0');
				else
					iix2_rd_data_mux <= iix2_rd_data;
					ii_rd_data_mux1 <= ii_rd_data;
				end if;
			
			when "01" =>
				if y_base = "000000" then
					iix2_rd_data_mux <= (others=>'0');
					ii_rd_data_mux1 <= (others=>'0');
				else
					iix2_rd_data_mux <= iix2_rd_data;
					ii_rd_data_mux1 <= ii_rd_data;
				end if;
			
			when "10" =>
				if x_base = "000000" then
					iix2_rd_data_mux <= (others=>'0');
					ii_rd_data_mux1 <= (others=>'0');
				else
					iix2_rd_data_mux <= iix2_rd_data;
					ii_rd_data_mux1 <= ii_rd_data;
				end if;
			
			when others =>
					iix2_rd_data_mux <= iix2_rd_data;
					ii_rd_data_mux1 <= ii_rd_data;
		end case;
	end if;
end process;

ii_data_mux: process (ii_rdaddress_mux_selector, ii_rd_data_mux1, ii_rd_data_mux2)
  begin
    if (ii_rdaddress_mux_selector = '1') then 
      ii_rd_data_mux <= ii_rd_data_mux1; 	-- read ram from iix2_address (used for corners in ii(x) as well)
    else 
      ii_rd_data_mux <= ii_rd_data_mux2; 	-- read ram from ii_address (generated by address decoder)
    end if;
  end process;
  
inst_deteksi_roi : klasifikasi port map(
	clk 					=> clk,
	rst 					=> calculation_reset,
	en_strongAccum 	=> en_strongAccum_sig,
	en_varnorm	 		=> en_var_norm_sig,
	leftleaf		 		=> leftleaves,
	rightleaf	 		=> rightleaves,
	weaktresh	 		=> weakthresh,
	strongtresh  		=> strong_tresh,
	weight0		  		=> weight0,
	weight1		  		=> weight1,
	weight2		  		=> weight2,
	ii_reg_we			=> ii_reg_we_sig,
	ii_reg_index		=> ii_reg_index,
	ii_data				=> ii_rd_data_mux,
	iix2_reg_we			=> iix2_reg_we_sig,
	iix2_reg_index		=> iix2_reg_index,
	iix2_data			=> iix2_rd_data_mux,
	deteksi				=> detection);
	
end Behavioral;

