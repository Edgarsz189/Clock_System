library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity Contador_1 is
Port (
        	clk  : 	in  std_logic; 	-- Reloj de 1Hz.
      	reset: 	in  std_logic;   	-- seÃ±al para resetear el contador
			--pause : 	in std_logic ;	-- seÃ±al para pausar el conteo
			--inc : 	in std_logic ;	
			qrt : 	out std_logic_vector (3 downto 0) ;  -- salida (3 elementos)	  
       	D_M: 		out std_logic_vector(3 downto 0);  -- SeÃ±al de salida para las de
        	U_M: 		out std_logic_vector(3 downto 0); 
        	D_S: 		out std_logic_vector(3 downto 0);
        	U_S: 		out std_logic_vector(3 downto 0));
			
end Contador_1;

architecture ArqContador of Contador_1 is
-- Defino seÃ±ales auxiliares y las inicializo:
		signal M1: 		std_logic_vector(3 downto 0) 	:= 	"0001";	-- 1 decimal (decenas de minutos)
   	signal M0: 		std_logic_vector(3 downto 0) 	:= 	"0101";	-- 5 decimal (unidades de minutos)
   	signal S1: 		std_logic_vector(3 downto 0) 	:= 	"0000";	-- 0 decimal (decenas de segundos)
   	signal S0: 		std_logic_vector(3 downto 0) 	:= 	"0000";	-- 0 decimal (unidades de segundo)
		signal qrt1: 	std_logic_vector(3 downto 0)	:= 	"0001" ;	-- 1 decimal (cuartos)
		type state_t is (Init, After_Init, CDS0, CDS1, CDM0, CDM1, CDqrt);				-- Creo un tipo de dato
		signal state : state_t := Init;
	
begin

process (clk, reset)  -- El proceso es sensible a las señales: clk y reset
variable B: 	integer range 0 to 9 := 0 ;	-- banderas de tipo entero (inicializado en cero)
begin
	if reset = '1' then  -- Si la seÃ±al de reset esta activa reseteo valores de las seÃ±ales a:
		M1 	<=	"0001"; -- 1 decimal (decenas de minutos)
		M0 	<=	"0101"; -- 5 decimal (unidades de minutos)
		S1 	<=	"0000"; -- 0 decimal (decenas de segundos)
		S0		<= "0000"; -- 0 decimal (unidades de segundos)
		qrt1	<= "0001"; 	-- 1 decimal (cuartos)p
	
	
	elsif rising_edge(clk) then 	-- Si se da un flanco positivo en la seÃ±al de reloj (1 Hz) entra
		case state is 
			
			when Init => 
				M1 	<=	"0001"; -- 1 decimal (decenas de minutos)
				M0 	<=	"0101"; -- 5 decimal (unidades de minutos)
				S1 	<=	"0000"; -- 0 decimal (decenas de segundos)
				S0		<= "0000"; -- 0 decimal (unidades de segundos)
				qrt1	<= "0001"; 	-- 1 decimal (cuartos)
				state <= After_Init;
			when After_Init =>
				M1 	<=	"0001"; -- 1 decimal (decenas de minutos)
				M0 	<=	"0100"; -- 4 decimal (unidades de minutos)
				S1 	<=	"0101"; -- 5 decimal (decenas de segundos)
				S0		<= "1001"; -- 9 decimal (unidades de segundos)
				state <= CDS0;		-- Estado para disminuir unidades de segundo	
			when CDS0 =>
			if S0 /= 0 then 		-- Si S0 no ha llegado a cero entonces... 
				S0 <= S0 -1;		-- Resto unidades de segundo
				B := B +1 ;			
				if B = 9 and S1 /= 0 then 
				state <= CDS1;		-- cambio de estado para disminuir decenas de segundo
				elsif	B = 9 and S1 = 0  and M0 /=0 then 
				state <= CDM0;
				elsif B = 9 and M0 = 0 and M1 /= 0 then
				state <= CDM1;
				elsif B = 9 and M1 = 0 then 
				state <= CDqrt;			
				end if;
			end if;
			
			when CDS1 =>
				
				if S1 /= 0 then 
				S1 <= S1 - 1 ;			-- Disminuyo unidades de segundos
				S0 <= "1001" ;			-- Asigno un 9 a unidades de segundos
				B := 0;
				state <= CDS0;			-- Regresa al estado para disminuir unidades de segundo
				end if;
				
			when CDM0 =>
				if M0 /= 0 then 
					M0 <= M0 - 1 ;			-- Disminuyo unidades de minutos
					S0 <= "1001" ;			-- Asigno un 9 a unidades de segundos
					S1 <= "0101" ;			-- Asigno un 5 a decenas de segundos
					state <= CDS0;			-- Regresa al estado para disminuir unidades de segundo
					B := 0;
				end if;

			when CDM1 =>
				if M1 /= 0 then
					M1 <= M1 -1 ;			-- Disminuyo decenas de minutos
					S0 <= "1001";			-- Asigno un 9 a unidades de segundos
					B := 0;
					S1 <= "0101";			-- Asigno un 5 a decenas de segundos
					M0 <= "1001";			-- Asigno un 9 a unidades de minutos
					state <= CDS0;			-- Regresa al estado para disminuir unidades de segundo
				end if;
				
			when CDqrt=>
				M1 	<=	"0001"; -- 1 decimal (decenas de minutos)
				M0 	<=	"0101"; -- 5 decimal (unidades de minutos)
				S1 	<=	"0000"; -- 0 decimal (decenas de segundos)
				S0		<= "0000"; -- 0 decimal (unidades de segundos)
				B	 	:= 0 ;
				if qrt1 < 4 then 
					qrt1 <= qrt1 +1 ;		-- Incremento los cuartos
					state <= After_Init;		-- cambio de estado 
				else 
					qrt1 <= "0001";
					state <= After_Init;		-- cambio de estado 
				end if;
			when others => 
				M1 	<=	"0001"; -- 1 decimal (decenas de minutos)
				M0 	<=	"0101"; -- 5 decimal (unidades de minutos)
				S1 	<=	"0000"; -- 0 decimal (decenas de segundos)
				S0		<= "0000"; -- 0 decimal (unidades de segundos)
		end case;
		
		
				
	end if ; 						-- End if del condicional del reloj
	
	

end process;
--AsignaciÃ³n de seÃ±ales.
D_M 	<= 	M1;
U_M 	<= 	M0;
U_S 	<= 	S0;
D_S 	<= 	S1;
qrt 	<= 	qrt1 ;
end ArqContador;
