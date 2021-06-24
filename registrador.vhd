library IEEE;
use ieee.std_logic_1164.all;

entity registrador is
port(
		clock,reset,load	:in std_logic;
		D					: in std_logic_vector(7 downto 0);
		Q					: out std_logic_vector(7 downto 0)
		);
		end registrador;
architecture arq of registrador is
begin
	process(clock, reset, load)
	begin
		if(reset = '1') then
			Q <= "00000000";
		elsif(clock'event and clock = '1') then
			if load = '1' then
			   Q <= D;
			end if;
		end if;
	end process;
	
end arq;