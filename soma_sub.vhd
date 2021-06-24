library IEEE;
use ieee.std_logic_1164.all;

entity soma_sub is
port(
		A,B				: in std_logic_vector(7 downto 0);
		sel            : in std_logic;
		S					: out std_logic_vector(7 downto 0);
		cout,ov        : out std_logic
		);
		end soma_sub;
architecture arq of soma_sub is

component fulladder is
port(
		A,B				: in std_logic;
		cin            : in std_logic;
		S					: out std_logic;
		cout           : out std_logic
		);
end component;

signal carry : std_logic_vector(8 downto 0);
signal aux : std_logic_vector(7 downto 0);

begin

carry(0) <= sel;
cout <= carry(8);
ov <= carry(8) xor carry(7);

SOMA: for i in 0 to 7 generate
        sc: fulladder port map(A(i),aux(i),carry(i),S(i),carry(i+1));
          aux(i) <= B(i) xor sel;
		end generate; 

	
end arq;