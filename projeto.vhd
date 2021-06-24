library IEEE;
use ieee.std_logic_1164.all;

entity projeto is
port(
		clock          : in std_logic;
		reset          : in std_logic;
		data_in        : in std_logic_vector(7 downto 0);--entrada de dados
		data_out       : out std_logic_vector(7 downto 0);--saída de dados
		
		p_R0           : out std_logic_vector(7 downto 0);--Portas para debug
		p_R1           : out std_logic_vector(7 downto 0);
		p_R2           : out std_logic_vector(7 downto 0);
		p_R3           : out std_logic_vector(7 downto 0);
		p_ULA          : out std_logic_vector(7 downto 0);
		
		cout,ov,N,Z    : out std_logic--flags
		);
		end projeto;
architecture arq of projeto is
TYPE STATE_TYPE IS (s0, s1, s2, s3, s4, s5, s6, s7, s8);
SIGNAL estado_atual, proximo_estado: STATE_TYPE;

component datapath2 is
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
end component;

signal c : std_logic_vector(12 downto 0);
signal s_N,s_Z : std_logic;

begin
-- mapeando portas para debug
N <= s_N;
Z <= s_Z;

DP: datapath2 port map(clock    => clock,
                      reset    => reset,
						    data_in  => data_in,
							 p_R0     => p_R0,
							 p_R1     => p_R1,
							 p_R2     => p_R2,
							 p_R3     => p_R3,
							 p_ULA    => p_ULA,
							 c        => c,
							 data_out => data_out,
							 cout     => cout,
							 ov       => ov,
							 N        => s_N,
							 Z        => s_Z);
							 
process (reset, clock)
begin
		if (reset = '1') then
			estado_atual <= s0;
		elsif (clock'EVENT and clock = '1') then
			estado_atual <= proximo_estado;
		end if;
end process;

	process (estado_atual,s_N,s_Z)
	begin
		case estado_atual is
		   when s0  =>
				  
				  c(0) <= '0'; --Mux0 data_in/resultadoULA
				  c(1) <= '0'; --Mux1 data_in/resultadoULA
				  c(2) <= '0'; --Mux2 data_in/resultadoULA
				  c(3) <= '0'; --Mux3 data_in/resultadoULA

				  c(4) <= '0'; --carga R0
				  c(5) <= '0'; --carga R1
				  c(6) <= '0'; --carga R2
				  c(7) <= '0'; --carga R3
				  
				  c(9 downto 8)   <= "00"; --opA - Mux4_1 00:R0 / 01:R1 / 10:R2 / 11:R3
				  c(11 downto 10) <= "00"; --opB - Mux4_1 00:R0 / 01:R1 / 10:R2 / 11:R3
				  
				  c(12) <= '0'; --ULA: 0:soma / 1:subtrai

				  proximo_estado <= s1;

		   when s1 =>
           
  			     --R0<=Data_in,R1<=Data_in
				  
				  c(0) <= '0'; --Mux0 data_in/resultadoULA
				  c(1) <= '0'; --Mux1 data_in/resultadoULA
				  c(2) <= '0'; --Mux2 data_in/resultadoULA
				  c(3) <= '0'; --Mux3 data_in/resultadoULA

				  c(4) <= '1'; --carga R0
				  c(5) <= '1'; --carga R1
				  c(6) <= '0'; --carga R2
				  c(7) <= '0'; --carga R3
				  
				  c(9 downto 8)   <= "00"; --opA - Mux4_1 00:R0 / 01:R1 / 10:R2 / 11:R3
				  c(11 downto 10) <= "00"; --opB - Mux4_1 00:R0 / 01:R1 / 10:R2 / 11:R3
				  
				  c(12) <= '0'; --ULA: 0:soma / 1:subtrai

				  proximo_estado <= s2;

		   when s2  =>
				  
				  --R2 <= Data_in(1);
				  
				  c(0) <= '0'; --Mux0 data_in/resultadoULA
				  c(1) <= '0'; --Mux1 data_in/resultadoULA
				  c(2) <= '0'; --Mux2 data_in/resultadoULA
				  c(3) <= '0'; --Mux3 data_in/resultadoULA

				  c(4) <= '0'; --carga R0
				  c(5) <= '0'; --carga R1
				  c(6) <= '1'; --carga R2
				  c(7) <= '0'; --carga R3
				  
				  c(9 downto 8)   <= "00"; --opA - Mux4_1 00:R0 / 01:R1 / 10:R2 / 11:R3
				  c(11 downto 10) <= "00"; --opB - Mux4_1 00:R0 / 01:R1 / 10:R2 / 11:R3
				  
				  c(12) <= '0'; --ULA: 0:soma / 1:subtrai

				  proximo_estado <= s3;

		   when s3  =>
			
				-- R3 <= Data_in(10)
				  
				  c(0) <= '0'; --Mux0 data_in/resultadoULA
				  c(1) <= '0'; --Mux1 data_in/resultadoULA
				  c(2) <= '0'; --Mux2 data_in/resultadoULA
				  c(3) <= '0'; --Mux3 data_in/resultadoULA

				  c(4) <= '0'; --carga R0
				  c(5) <= '0'; --carga R1
				  c(6) <= '0'; --carga R2
				  c(7) <= '1'; --carga R3
				  
				  c(9 downto 8)   <= "00"; --opA - Mux4_1 00:R0 / 01:R1 / 10:R2 / 11:R3
				  c(11 downto 10) <= "00"; --opB - Mux4_1 00:R0 / 01:R1 / 10:R2 / 11:R3
				  
				  c(12) <= '0'; --ULA: 0:soma / 1:subtrai

				  proximo_estado <= s4;
		   when s4  =>
			
				--R1 <= R1 + R2
				  
				  c(0) <= '0'; --Mux0 data_in/resultadoULA
				  c(1) <= '1'; --Mux1 data_in/resultadoULA
				  c(2) <= '0'; --Mux2 data_in/resultadoULA
				  c(3) <= '0'; --Mux3 data_in/resultadoULA

				  c(4) <= '0'; --carga R0
				  c(5) <= '1'; --carga R1
				  c(6) <= '0'; --carga R2
				  c(7) <= '0'; --carga R3
				  
				  c(9 downto 8)   <= "01"; --opA - Mux4_1 00:R0 / 01:R1 / 10:R2 / 11:R3
				  c(11 downto 10) <= "10"; --opB - Mux4_1 00:R0 / 01:R1 / 10:R2 / 11:R3
				  
				  c(12) <= '0'; --ULA: 0:soma / 1:subtrai

				  proximo_estado <= s5;
		   when s5  =>
				  
				  --R0 <= R0 + R1
				  
				  c(0) <= '1'; --Mux0 data_in/resultadoULA
				  c(1) <= '0'; --Mux1 data_in/resultadoULA
				  c(2) <= '0'; --Mux2 data_in/resultadoULA
				  c(3) <= '0'; --Mux3 data_in/resultadoULA

				  c(4) <= '1'; --carga R0
				  c(5) <= '0'; --carga R1
				  c(6) <= '0'; --carga R2
				  c(7) <= '0'; --carga R3
				  
				  c(9 downto 8)   <= "00"; --opA - Mux4_1 00:R0 / 01:R1 / 10:R2 / 11:R3
				  c(11 downto 10) <= "01"; --opB - Mux4_1 00:R0 / 01:R1 / 10:R2 / 11:R3
				  
				  c(12) <= '0'; --ULA: 0:soma / 1:subtrai

				  proximo_estado <= s6;
		   when s6  =>
			
				--R3 <= R3 - R2
				  
				  c(0) <= '0'; --Mux0 data_in/resultadoULA
				  c(1) <= '0'; --Mux1 data_in/resultadoULA
				  c(2) <= '0'; --Mux2 data_in/resultadoULA
				  c(3) <= '1'; --Mux3 data_in/resultadoULA

				  c(4) <= '0'; --carga R0
				  c(5) <= '0'; --carga R1
				  c(6) <= '0'; --carga R2
				  c(7) <= '1'; --carga R3
				  
				  c(9 downto 8)   <= "11"; --opA - Mux4_1 00:R0 / 01:R1 / 10:R2 / 11:R3
				  c(11 downto 10) <= "10"; --opB - Mux4_1 00:R0 / 01:R1 / 10:R2 / 11:R3
				  
				  c(12) <= '1'; --ULA: 0:soma / 1:subtrai
					
					if s_Z = '1' then
						proximo_estado <= s7;
					else
						proximo_estado <= s4;
					end if;
				  
		   when s7  =>
				  
				  c(0) <= '0'; --Mux0 data_in/resultadoULA
				  c(1) <= '0'; --Mux1 data_in/resultadoULA
				  c(2) <= '0'; --Mux2 data_in/resultadoULA
				  c(3) <= '0'; --Mux3 data_in/resultadoULA

				  c(4) <= '0'; --carga R0
				  c(5) <= '0'; --carga R1
				  c(6) <= '0'; --carga R2
				  c(7) <= '0'; --carga R3
				  
				  c(9 downto 8)   <= "00"; --opA - Mux4_1 00:R0 / 01:R1 / 10:R2 / 11:R3
				  c(11 downto 10) <= "00"; --opB - Mux4_1 00:R0 / 01:R1 / 10:R2 / 11:R3
				  
				  c(12) <= '0'; --ULA: 0:soma / 1:subtrai

				  proximo_estado <= s1;

		end case;
	end process;

end arq;
