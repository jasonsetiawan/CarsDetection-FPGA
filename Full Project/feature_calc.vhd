----------------------------------------------------------------------------------
-- Start Sat 26/10 5.35
-- Done  Sat 26/10 6.12
-- Jason Danny Setiawan
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity feature_calc is
    Port ( weight_0 : in  STD_LOGIC_VECTOR (21 downto 0);
           weight_1 : in  STD_LOGIC_VECTOR (21 downto 0);
           weight_2 : in  STD_LOGIC_VECTOR (21 downto 0);
           a_0 : in  STD_LOGIC_VECTOR (18 downto 0);
           b_0 : in  STD_LOGIC_VECTOR (18 downto 0);
           c_0 : in  STD_LOGIC_VECTOR (18 downto 0);
           d_0 : in  STD_LOGIC_VECTOR (18 downto 0);
           a_1 : in  STD_LOGIC_VECTOR (18 downto 0);
           b_1 : in  STD_LOGIC_VECTOR (18 downto 0);
           c_1 : in  STD_LOGIC_VECTOR (18 downto 0);
           d_1 : in  STD_LOGIC_VECTOR (18 downto 0);
           a_2 : in  STD_LOGIC_VECTOR (18 downto 0);
           b_2 : in  STD_LOGIC_VECTOR (18 downto 0);
           c_2 : in  STD_LOGIC_VECTOR (18 downto 0);
           d_2 : in  STD_LOGIC_VECTOR (18 downto 0);
           feature : out  STD_LOGIC_VECTOR (28 downto 0));
end feature_calc;

architecture Behavioral of feature_calc is

component f_rect_calc
	Port ( weight : in  STD_LOGIC_VECTOR (21 downto 0);
           a : in  STD_LOGIC_VECTOR (18 downto 0);
           b : in  STD_LOGIC_VECTOR (18 downto 0);
           c : in  STD_LOGIC_VECTOR (18 downto 0);
           d : in  STD_LOGIC_VECTOR (18 downto 0);
           result : out  STD_LOGIC_VECTOR (26 downto 0));
end component;

signal sum1 : std_logic_vector(26 downto 0);
signal sum2 : std_logic_vector(26 downto 0);
signal sum3 : std_logic_vector(26 downto 0);

begin
	
rect_0 : f_rect_calc port map(
	weight => weight_0,
	a		 => a_0,
	b		 => b_0,
	c	 	 => c_0,
	d		 => d_0,
	result => sum1);

rect_1 : f_rect_calc port map(
	weight => weight_1,
	a		 => a_1,
	b		 => b_1,
	c	 	 => c_1,
	d		 => d_1,
	result => sum2);
	
rect_2 : f_rect_calc port map(
	weight => weight_2,
	a		 => a_2,
	b		 => b_2,
	c	 	 => c_2,
	d		 => d_2,
	result => sum3);

feature <= std_logic_vector(signed(sum1(26) & sum1(26) & sum1) + signed(sum2(26) & sum2(26) & sum2) 
			+ signed(sum3(26) & sum3(26) & sum3));


end Behavioral;

