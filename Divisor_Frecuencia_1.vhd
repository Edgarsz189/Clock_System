-- El siguiente programa toma como entrada una señal de reloj (50 MHz) y la divide para obter una frecuencia de 1 Hz
library ieee;
use ieee.std_logic_1164.all;

entity Divisor_Frecuencia_1 is 
port(clk, Reset : in std_logic;
clkOut: out std_logic


);


end Divisor_Frecuencia_1;
architecture Arq1 of Divisor_Frecuencia_1 is
signal Contador : integer range 0 to 25000000 := 0;-- Declaro señal tipo entera
signal Temporal : std_logic;
begin
Process(clk, Reset)
begin
	if Reset = '1' then 
		Contador <= 0;								-- Reinicia contador
	elsif rising_edge(clk) then 				-- Si hay un flanco positivo entra
			if Contador = 24999999 then 
				Temporal <= not Temporal;		-- Invierte señal temporal
				Contador <= 0;						-- Reinicia contador
			else 
				Contador <= Contador +1;   	-- Incremento contador en 1
		end if;
	end if ; 
end process;
clkOut <= Temporal; 								-- Asigno señal a la salida 
end Arq1;