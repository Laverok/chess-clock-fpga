library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mod10cntr_tb is
end mod10cntr_tb;

architecture testbench of mod10cntr_tb is

    component mod10cntr
        port(clk : in std_logic;
         set : in std_logic;
         reset : in std_logic;
         cntr_in : in std_logic_vector(3 downto 0);
         cntr_out : out std_logic_vector(3 downto 0)); 
    end component;
    
    signal clk : std_logic;
    signal set : std_logic;
    signal reset : std_logic;
    signal cntr_in : std_logic_vector(3 downto 0);
    signal cntr_out : std_logic_vector(3 downto 0);
    
begin
    UUT: mod10cntr
        port map(
            clk => clk,
            set => set,
            reset => reset,
            cntr_in => cntr_in,
            cntr_out => cntr_out);

CLOCK : process
begin
    clk <= '0';
    wait for 50 ns;
    clk <= '1';
    wait for 50 ns;
end process;

SET_STIMULUS : process
begin
    set <= '0';
    wait for 600 ns;
    set <= '1';
    wait;
end process;

RESET_STIMULUS : process
begin
    reset <= '0';
    wait for 700 ns;
   	reset <= '1';
   	wait;
end process;

CNTR_IN_STIMULUS : process
begin
	wait for 100 ns;
    cntr_in <= "0001";
end process;


end testbench;
