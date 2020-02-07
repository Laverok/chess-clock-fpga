library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity top_tb is
end top_tb;

architecture testbench of top_tb is

	component top
		Port(clk : in STD_LOGIC;
			seven_seg : out STD_LOGIC_VECTOR(6 downto 0);
			anode : out STD_LOGIC_VECTOR(7 downto 0);
			player_switch : in STD_LOGIC;
			pause: in STD_LOGIC;   
			reset : in STD_LOGIC; 
			player_leds : out STD_LOGIC_VECTOR(1 downto 0) := "00");
	end component;
	
	signal clk : STD_LOGIC;
	signal seven_seg : STD_LOGIC_VECTOR(6 downto 0);
	signal anode : STD_LOGIC_VECTOR(7 downto 0);
	signal player_switch : STD_LOGIC;
	signal pause: STD_LOGIC;   
	signal reset : STD_LOGIC; 
	signal player_leds : STD_LOGIC_VECTOR(1 downto 0) := "00";
begin
	UUT: top
		port map(
			clk=>clk,
			seven_seg=>seven_seg,
			anode=>anode,
			player_switch=>player_switch,
			pause=>pause,
			reset=>reset,
			player_leds=>player_leds); 

clock : process begin
	clk <= '0';
    wait for 50 ns;
    clk <= '1';
    wait for 50 ns;
end process;

player_switch_stimulus: process begin
	player_switch <= '0';
	wait for 150 ns;
	player_switch <= '1';
	wait for 150 ns;
end process;

pause_stimulus : process begin
	pause <= '0';
	wait for 600 ns;
	pause <= '1';
	wait for 200 ns;
end process;

reset_stimulus : process begin
	reset <= '0';
	wait for 50 ns;
	reset <= '1';
	wait for 100 ns;
	reset <= '0';
	wait for 5000 ns;
	reset <= '1';
	wait for 200 ns;
	reset <= '0';
end process;

end testbench;
