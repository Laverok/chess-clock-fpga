library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Mux7Seg is -- Responsible for displaying numbers on a 7seg display
    Port ( clk : in STD_LOGIC;
    	   data_in : in STD_LOGIC_VECTOR (31 downto 0); -- 8x4bit BCD input
           seven_seg : out STD_LOGIC_VECTOR (6 downto 0); -- 6:0 -> A:G leds 
           anode : out STD_LOGIC_VECTOR(7 downto 0)); -- Controls which digit is displayed at the moment
end Mux7Seg;

architecture Behavioral of Mux7Seg is
	signal ctrl : STD_LOGIC_VECTOR(2 downto 0) := "000"; -- Used for multiplexing data on 7seg
	signal digit : STD_LOGIC_VECTOR (3 downto 0); -- Digit being sent to the 7seg
	
begin

	mux : process(clk) begin -- 7seg multiplexing
		if (rising_edge(clk)) then
		case ctrl is
			when "111" =>
				digit <= Data_In(31 downto 28);
				anode <= "01111111";
			when "110" =>
				digit <= Data_In(27 downto 24);
				anode <= "10111111";
			when "101" =>
				digit <= Data_In(23 downto 20);
				anode <= "11011111";
			when "100" =>
				digit <= Data_In(19 downto 16);
				anode <= "11101111";
			when "011" =>
				digit <= Data_In(15 downto 12);
				anode <= "11110111";
			when "010" =>
				digit <= Data_In(11 downto 8);
				anode <= "11111011";
			when "001" =>
				digit <= Data_In(7 downto 4);
				anode <= "11111101";
			when "000" =>
				digit <= Data_In(3 downto 0);
				anode <= "11111110";
			when others =>
				digit <= "0000";
		end case;
		end if;	
	end process;
	
	ctrl_inc : process(clk) begin -- Increments the multiplexer signal on clock's rising edge
		if (rising_edge(clk)) then
			if (ctrl = "111") then
				ctrl <= "000";
			else
				ctrl <= ctrl + 1;	
			end if;
		end if;	
	
	end process;
	
	BCD7Seg : process(digit) begin -- BCD to 7 segment conversion
		case digit is
			when "0000" =>
				seven_seg <= "0000001";
			when "0001" =>
				seven_seg <= "1001111"; 
			when "0010" =>
				seven_seg <= "0010010"; 
			when "0011" =>
				seven_seg <= "0000110"; 
			when "0100" =>
				seven_seg <= "1001100"; 
			when "0101" =>
				seven_seg <= "0100100"; 
			when "0110" =>
				seven_seg <= "0100000"; 
			when "0111" =>
				seven_seg <= "0001111"; 
			when "1000" =>
				seven_seg <= "0000000"; 
			when "1001" =>
				seven_seg <= "0000100"; 
			when others =>
				seven_seg <= "1111111"; 
		end case;
	end process;
end Behavioral;
