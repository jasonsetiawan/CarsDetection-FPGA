library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rgb2grey is
    Port ( Datain : in  STD_LOGIC_VECTOR (11 downto 0);
           Dataout : out  STD_LOGIC_VECTOR (7 downto 0));
end rgb2grey;

architecture Behavioral of rgb2grey is

signal r4,g4,b4 : std_logic_vector(3 downto 0);
signal r,g,b : std_logic_vector(7 downto 0);
signal temp1, temp2, temp3 : unsigned(13 downto 0);
signal Y		 : std_logic_vector(13 downto 0);

begin

r4 <= Datain(11 downto 8);
g4 <= Datain(7 downto 4);
b4 <= Datain(3 downto 0);

r <= r4 & r4;
g <= g4 & g4;
b <= b4 & b4;

-- Y = R*0.299 + G*0.587 + B*0.114
-- Since Multiplication takes much multipliers, I use bitshifting
-- Y = 19/64 R + 37/64 G + 7/64 B
-- 64Y = 19R + 37G + 7B
-- 64Y = (16+4-1)R + (32+4+1)G + (8-1)B

temp1 <= unsigned("00" & r & "0000") + unsigned("0000" & r & "00") - unsigned("000000" & r);
temp2 <= unsigned('0' & g & "00000") + unsigned("0000" & g & "00") + unsigned("000000" & g);
temp3 <= unsigned("000" & b & "000") - unsigned ("000000" & b); 

-- Y <= std_logic_vector((unsigned("00" & r & "00")+unsigned(r)) + (unsigned('0' & g & "000")+unsigned(g)) + unsigned("000" & b & b(3))); 
-- Y <= std_logic_vector((unsigned("00" & r & r & "0000"))+ (unsigned("0000" & r & r & "00"))- unsigned("000000"& r & r)+
--							unsigned('0' & g & g & "00000") + unsigned("0000" & g & g & "00") + unsigned("000000" & g & g)+
--							unsigned("000" & b & b & "000") - unsigned("000000" & b & b)); 

Y <= std_logic_vector(temp1 + temp2 + temp3);
-- a <= std_logic_vector(temp1);
-- m <= std_logic_vector(temp2);
-- c <= std_logic_vector(temp3);

Dataout <= Y(13 downto 6);

end Behavioral;

