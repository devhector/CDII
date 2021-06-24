library IEEE;
use ieee.std_logic_1164.all;

entity datapath2 is
port(
		data_in			: in std_logic_vector(7 downto 0);
		clock          : in std_logic;
		reset          : in std_logic;
	   p_R0				: out std_logic_vector(7 downto 0);
		p_R1				: out std_logic_vector(7 downto 0);
		p_R2				: out std_logic_vector(7 downto 0);
		p_R3				: out std_logic_vector(7 downto 0);
		p_ULA			   : out std_logic_vector(7 downto 0);
		c              : in std_logic_vector(12 downto 0);
		data_out       : out std_logic_vector(7 downto 0);
		cout,ov,N,Z    : out std_logic
		);
		end datapath2;
architecture arq of datapath2 is

component registrador is
port(
		clock,reset,load	:in std_logic;
		D					: in std_logic_vector(7 downto 0);
		Q					: out std_logic_vector(7 downto 0)
		);
end component;

component soma_sub is
port(
		A,B				: in std_logic_vector(7 downto 0);
		sel            : in std_logic;
		S					: out std_logic_vector(7 downto 0);
		cout,ov        : out std_logic
		);
end component;

signal mux_1,mux_2,mux_3,mux_4 : std_logic_vector(7 downto 0);
signal s_R0,s_R1,s_R2,s_R3 : std_logic_vector(7 downto 0);
signal opA,opB,resultado :std_logic_vector(7 downto 0); 

begin

p_R0 <= s_R0;
p_R1 <= s_R1;
p_R2 <= s_R2;
p_R3 <= s_R3;
p_ULA <= resultado;

data_out <= opB;

--flags: 
--N:0-positivo ; 1-negativo 
N <= resultado(7);
--Z:1-valor igual 0; 0-valor diferente de 0
Z <= '1' when resultado = "00000000" else '0'; 

MUX1: mux_1 <= data_in when c(0) = '0' else resultado;
MUX2: mux_2 <= data_in when c(1) = '0' else resultado;
MUX3: mux_3 <= data_in when c(2) = '0' else resultado;
MUX4: mux_4 <= data_in when c(3) = '0' else resultado;

--registrador R0
R0: registrador port map(clock => clock,
                         reset => reset,
								 load  => c(4),
								 D     => mux_1,
								 Q     => s_R0);

--registrador R1
R1: registrador port map(clock => clock,
                         reset => reset,
								 load  => c(5),
								 D     => mux_2,
								 Q     => s_R1);

--registrador R2
R2: registrador port map(clock => clock,
                         reset => reset,
								 load  => c(6),
								 D     => mux_3,
								 Q     => s_R2);
								 
--registrador R3								 
R3: registrador port map(clock => clock,
                         reset => reset,
								 load  => c(7),
								 D     => mux_4,
								 Q     => s_R3);


--MUX4:1 seleciona operando A
MUX5: with c(9 downto 8) select
           opA <= s_R0 when "00",
                  s_R1 when "01",
                  s_R2 when "10",
                  s_R3 when others; 						

--MUX4:1 seleciona operando B
MUX6: with c(11 downto 10) select
           opB <= s_R0 when "00",
                  s_R1 when "01",
                  s_R2 when "10",
                  s_R3 when others;


--somador/subtrator						
SOMADOR_SUBTRATOR: soma_sub port map(A => opA,
                                     B => opB,
												 sel => c(12),
												 S => resultado,
												 cout => cout,
												 ov => ov);
						
end arq;