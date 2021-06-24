library IEEE;
use ieee.std_logic_1164.all;

entity fulladder is
port(
		A,B				: in std_logic;
		cin            : in std_logic;
		S					: out std_logic;
		cout           : out std_logic
		);
		end fulladder;
architecture arq of fulladder is
begin


s<= A xor B xor cin;
cout <= (A and B) or (A and cin) or (B and Cin);
	
end arq;