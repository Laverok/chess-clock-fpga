library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity prescaler_tb is
end prescaler_tb;

architecture testbench of prescaler_tb is
	
	component prescaler
		generic(scale_factor : integer);
		port(clk_in : in STD_LOGIC;
			 clk_out : out STD_LOGIC);
	end component;
	
	signal clk_in : STD_LOGIC;
	signal clk_out : STD_LOGIC;
	
begin
	UUT: prescaler
		generic map(scale_factor => 4)
        port map(
        	clk_in => clk_in,
        	clk_out => clk_out );

CLOCK : process
begin
	clk_in <= '0';
    wait for 50 ns;
    clk_in <= '1';
    wait for 50 ns;
end process;

end testbench;
