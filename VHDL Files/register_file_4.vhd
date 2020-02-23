library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register_file_4 is
	 Generic( address_width : integer;
				 data_width		: integer);
    Port ( clk : in  STD_LOGIC;
           write_en : in  STD_LOGIC;
           write_reg_address : in  STD_LOGIC_VECTOR((address_width-1) downto 0);
           write_data : in  STD_LOGIC_VECTOR((data_width-1) downto 0);
           q0 : out  STD_LOGIC_VECTOR ((data_width-1) downto 0);
           q1 : out  STD_LOGIC_VECTOR ((data_width-1) downto 0);
           q2 : out  STD_LOGIC_VECTOR ((data_width-1) downto 0);
           q3 : out  STD_LOGIC_VECTOR ((data_width-1) downto 0));
end register_file_4;

architecture Behavioral of register_file_4 is

type my_register is array (0 to (2**address_width-1)) of std_logic_vector ((data_width-1) downto 0);
signal regist : my_register := (others=>(others=>'0'));

begin
	process (clk) is begin
		if rising_edge(clk) then
			if write_en = '1' then
				regist(to_integer(unsigned(write_reg_address))) <= write_data;
			end if;
		end if;
	end process;
	q0 <= regist(0);
	q1 <= regist(1);
	q2 <= regist(2);
	q3 <= regist(3);
end Behavioral;

