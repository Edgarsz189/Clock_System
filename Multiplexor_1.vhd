library ieee;
use ieee.std_logic_1164.all;

entity Multiplexor_1 is 
port( 	clk : 	in std_logic;								-- Señal de reloj 512 Hz
			qrt : 	in std_logic_vector(3 downto 0);  	-- salida (3 elementos)	  
       	D_M: 		in std_logic_vector(3 downto 0);  	--salida (4 elementos)
        	U_M: 		in std_logic_vector(3 downto 0); 
        	D_S: 		in std_logic_vector(3 downto 0);
        	U_S: 		in std_logic_vector(3 downto 0);
			Salida: 	out std_logic_vector(3 downto 0);
			DUS:		out std_logic;
			DDS:		out std_logic;
			DUM:		out std_logic;
			DDM:		out std_logic;
			Dqrt:		out std_logic
			
	);

end Multiplexor_1;

architecture Arq_Multiplexor of Multiplexor_1 is 
signal D_US: std_logic;
signal D_DS: std_logic;
signal D_UM: std_logic;
signal D_DM: std_logic;
signal D_qrt: std_logic;
signal Salida_1: std_logic_vector(3 downto 0);
begin

process(clk)
variable C : integer range 0 to 5 := 0 ;
begin

	if rising_edge(clk) then 					-- Entra en el flanco positivo de la señal de reloj
		if C < 4 then 
			case C is
				when 0 =>  
				Salida_1 <= U_S ; 	--	Coloco las unidades de segundos a la salida
				C := C +1;								-- Incremento contador
				D_US <= '1';								-- Activo Display correspondiente
				D_DS <= '0';
				D_UM <= '0';
				D_DM <= '0';
				D_qrt <= '0';
				when 1 =>  
				Salida_1 <= D_S ; 	--	Coloco las decenas de segundos a la salida
				C := C +1;							-- Incremento contador
				D_US <= '0';
				D_DS <= '1';							-- Activo Display correspondiente
				D_UM <= '0';
				D_DM <= '0';
				D_qrt <= '0';
				when 2 =>  
				Salida_1 <= U_M ; 	--	Coloco las unidades de minuto a la salida
				C := C +1;								-- Incremento contador
				D_US <= '0';
				D_DS <= '0';
				D_UM <= '1';								-- Activo Display correspondiente
				D_DM <= '0';
				D_qrt <= '0';
				when 3 =>  
				Salida_1 <= D_M ; 	--	Coloco las decenas de minuto a la salida
				C := C +1;								-- Incremento contador
				D_US <= '0';
				D_DS <= '0';
				D_UM <= '0';
				D_DM <= '1';								-- Activo Display correspondiente
				D_qrt <= '0';
				when 4 =>  
				Salida_1 <= qrt ; 	--	Coloco los cuartos a la salida
				C := 0;								-- Reinicio contador
				D_US <= '0';
				D_DS <= '0';
				D_UM <= '0';
				D_DM <= '0';
				D_qrt <= '1';						-- Activo Display correspondiente
				when others => null;
				
			end case;
			
		end if;
		 
	end if;

end process;
--Asignación de señales
DUS <= D_US;
DDS <= D_DS;
DUM <= D_UM;
DDM <= D_DM;
Dqrt <= D_qrt;
Salida <= Salida_1;

end Arq_Multiplexor;