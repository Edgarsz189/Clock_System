--Decodificador para display de 7 segmentos, Recibe una entrada BCD 
--y a su salida enciende lo correspondinte para formar los numeros del 1 al 9
-- El display de 7 segmentos es de catodo común
library ieee;
use ieee.std_logic_1164.all;

entity Decod_7 is 
	port (	bcd: 					in std_logic_vector (3 downto 0);
				a,b,c,d,e,f,g: 	out std_logic
	
	);
end Decod_7;

architecture Arq1 of Decod_7 is 
signal Salida: std_logic_vector(6 downto 0);
begin 
process(bcd)				-- Entra al proceso cuando bcd cambia
begin
	case bcd is
		when "0000" => 
				Salida <= "1111110" ;	-- 0 decimal
		when "0001" => 
				Salida <= "0110000" ;	-- 1 Decimal
		when "0010" => 
				Salida <= "1101101" ;	-- 2 Decimal
		when "0011" => 
				Salida <= "1111001" ;	-- 3 Decimal
		when "0100" => 
				Salida <= "0110011" ;	-- 4 Decimal
		when "0101" => 
				Salida <= "1011011" ;	-- 5 Decimal
		when "0110" => 
				Salida <= "1011111" ;	-- 6 Decimal
		when "0111" => 	
				Salida <= "1110001" ;	-- 7 Decimal
		when "1000" => 
				Salida <= "1111111" ;	-- 8 Decimal
		when "1001" => 
				Salida <= "1110011" ;	-- 9 Decimal
		when others => 
				Salida <= "0000000" ;
	end case;
end process;
--Asignación de señales:
		a <= Salida(6);
		b <= Salida(5);
		c <= Salida(4);
		d <= Salida(3);
		e <= Salida(2);
		f <= Salida(1);
		g <= Salida(0);

end Arq1;