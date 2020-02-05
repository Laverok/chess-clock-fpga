library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mod6cntr is -- Modulo 6 down counter
    port(clk : in std_logic;
         set : in std_logic; -- Enables setting the counter value manually
         reset : in std_logic; -- Resets the counter
         cntr_in : in std_logic_vector(3 downto 0); -- 4bit input
         cntr_out : out std_logic_vector(3 downto 0)); -- 4bit output
end mod6cntr;
			
architecture Behavioral of mod6cntr is
signal count : std_logic_vector(3 downto 0) := "0101"; -- Temporary count signal, equal to 5 by default
begin
    process(clk, set, reset) is
    begin
        if reset = '1' then
            count <= (others => '0');
        elsif set = '1' then
            count <= cntr_in;
        elsif rising_edge(clk) then
            if count <= 0 then
                count <= "0101"; -- Resets the counter value
            else
                count <= count - 1;
            end if;    
        end if;
        cntr_out <= count;
    end process;
end Behavioral;
