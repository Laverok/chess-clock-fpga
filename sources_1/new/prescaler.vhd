library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity prescaler is -- Clock prescaler
	Generic(scale_factor : integer := 1); -- Determines how much the clock is scaled down, 1 by default
	Port(clk_in : in STD_LOGIC;
		 CE : in STD_LOGIC := '1'; -- Clock enable
		 clk_out : out STD_LOGIC);
end prescaler;

architecture Behavioral of prescaler is
	signal temp: STD_LOGIC := '0';
	signal count : integer range 0 to scale_factor-1 := 0;
begin
	freq_divider : process(clk_in, CE) begin
		if CE = '1' then
			if (rising_edge(clk_in)) then
				if (count = scale_factor-1) then
					temp <= not(temp);
					count <= 0;
				else
					count <= count + 1;
				end if;
			end if;	
		end if;
	end process;
	
	clk_out <= temp;
end Behavioral;
