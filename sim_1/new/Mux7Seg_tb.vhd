library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Mux7Seg_tb is
end Mux7Seg_tb;

architecture testbench of Mux7Seg_tb is
	
	component Mux7Seg
		Port ( clk : in STD_LOGIC;
    	   	   data_in : in STD_LOGIC_VECTOR (15 downto 0);
           	   seven_seg : out STD_LOGIC_VECTOR (6 downto 0);
           	   anode : out STD_LOGIC_VECTOR(3 downto 0));
	end component;
	
	signal clk : STD_LOGIC;
	signal data_in : STD_LOGIC_VECTOR (15 downto 0) := X"0000";
    signal seven_seg : STD_LOGIC_VECTOR (6 downto 0);
    signal anode : STD_LOGIC_VECTOR(3 downto 0);
begin
	UUT: Mux7Seg
        port map(
        	clk => clk,
        	data_in => data_in,
        	seven_seg => seven_seg,
        	anode => anode);

CLOCK : process
begin
	clk <= '0';
    wait for 50 ns;
    clk <= '1';
    wait for 50 ns;
end process;

DATA_STIMULUS : process
begin
	data_in <= data_in + 1;
	wait for 200 ns;	
end process;

end testbench;
