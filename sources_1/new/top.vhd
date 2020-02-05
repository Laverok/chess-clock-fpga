library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity top is -- Top unit
	Port(clk : in STD_LOGIC;
		 seven_seg : out STD_LOGIC_VECTOR(6 downto 0); -- 6:0 -> A:G leds
		 anode : out STD_LOGIC_VECTOR(7 downto 0); -- Controls which digit is displayed at the moment
		 player_switch : in STD_LOGIC; -- Switches the player who has to make a move
		 pause: in STD_LOGIC; -- Pauses the clock
		 reset : in STD_LOGIC; -- Resets the clock up to the preset value
		 player_leds : out STD_LOGIC_VECTOR(1 downto 0) := "00"); -- [Led11, Led6], signals which player has to make a move
end top;

architecture Behavioral of top is
	
	component Mux7Seg is
		Port(clk : in STD_LOGIC;
    	   data_in : in STD_LOGIC_VECTOR (31 downto 0);
           seven_seg : out STD_LOGIC_VECTOR (6 downto 0);
           anode : out STD_LOGIC_VECTOR(7 downto 0));
    end component;
    
    component prescaler is
    	Generic(scale_factor : integer);
    	Port(clk_in : in STD_LOGIC;
    		 CE : in STD_LOGIC := '1';
		     clk_out : out STD_LOGIC);
	end component;
	
	component mod10cntr is
	port(clk : in std_logic;
         set : in std_logic := '0';
         reset : in std_logic := '0';
         cntr_in : in std_logic_vector(3 downto 0) := "0000";
         cntr_out : out std_logic_vector(3 downto 0)); 
	end component;
	
	component mod6cntr is
	port(clk : in std_logic;
         set : in std_logic := '0';
         reset : in std_logic := '0';
         cntr_in : in std_logic_vector(3 downto 0) := "0000";
         cntr_out : out std_logic_vector(3 downto 0)); 
	end component;
	
	signal clk_7seg : STD_LOGIC; -- Prescaled clock, 1000kHz
	signal clk_player1 : STD_LOGIC; -- Player 1 clock, 1Hz
	signal clk_player2 : STD_LOGIC; -- Player 2 clock, 1Hz
	signal player_select : STD_LOGIC_VECTOR(1 downto 0) := "00"; -- [Player1, Player2], 1->player's clock is decrementing
	signal temp_data : STD_LOGIC_VECTOR(31 downto 0);
	signal preset_value : STD_LOGIC_VECTOR(31 downto 0) := X"01000100"; -- Preset value of the clock, hexadecimal format for convenience
	signal set_enable : STD_LOGIC_VECTOR(7 downto 0) := "00000000"; -- If the value is equal to 1, allows the corresponding digit to be set
	signal game_over : STD_LOGIC := '0'; -- 1 -> game is over
	
begin
	Display : Mux7Seg 
		port map(clk=>clk_7seg, data_in=>temp_data, seven_seg=>seven_seg, anode=>anode);
		
	Display_clk : prescaler 
		generic map(scale_factor=>50000) 
		port map(clk_in=>clk, CE=>open, clk_out=>clk_7seg);
		
	Cntr_clk1 : prescaler
		generic map(scale_factor=>50000000)
		port map(clk_in=>clk, CE=>player_select(0), clk_out=>clk_player1);
		
	Cntr_clk2 : prescaler
		generic map(scale_factor=>50000000)
		port map(clk_in=>clk, CE=>player_select(1), clk_out=>clk_player2);
			
	secLowCntr1 : mod10cntr
		port map(clk=>clk_player1, set=>set_enable(0), reset=>open, cntr_in=>preset_value(3 downto 0), cntr_out=>temp_data(3 downto 0));
	
	secHighCntr1 : mod6cntr
		port map(clk=>temp_data(3), set=>set_enable(1), reset=>open, cntr_in=>preset_value(7 downto 4), cntr_out=>temp_data(7 downto 4));
		
	minLowCntr1 : mod10cntr
		port map(clk=>temp_data(6), set=>set_enable(2), reset=>open, cntr_in=>preset_value(11 downto 8), cntr_out=>temp_data(11 downto 8));
		
	minHighCntr1 : mod6cntr	
		port map(clk=>temp_data(11), set=>set_enable(3), reset=>open, cntr_in=>preset_value(15 downto 12), cntr_out=>temp_data(15 downto 12));	
		
		
	secLowCntr2 : mod10cntr
		port map(clk=>clk_player2, set=>set_enable(4), reset=>open, cntr_in=>preset_value(19 downto 16), cntr_out=>temp_data(19 downto 16));
	
	secHighCntr2 : mod6cntr
		port map(clk=>temp_data(19), set=>set_enable(5), reset=>open, cntr_in=>preset_value(23 downto 20), cntr_out=>temp_data(23 downto 20));
		
	minLowCntr2 : mod10cntr
		port map(clk=>temp_data(22), set=>set_enable(6), reset=>open, cntr_in=>preset_value(27 downto 24), cntr_out=>temp_data(27 downto 24));
		
	minHighCntr2 : mod6cntr	
		port map(clk=>temp_data(27), set=>set_enable(7), reset=>open, cntr_in=>preset_value(31 downto 28), cntr_out=>temp_data(31 downto 28));	
			
	clock_active : process(clk) begin -- Determines which player's clock is currently active, if the pause or game_over signal is high, stops the clock 
		if rising_edge(clk) then
			if pause = '1' or game_over = '1' then
				player_select <= "00";
			elsif player_switch = '1' then
				player_select <= "10";
				player_leds <= "10";
			elsif player_switch = '0' then
				player_select <= "01";
				player_leds <= "01";
			end if;
		end if;
	end process;
	
	reset_clock : process(clk) begin -- Resets the clock
		if reset = '1' then
			set_enable <= "11111111";
		else
			set_enable <= "00000000";	
		end if;	
	end process;
	
	end_game : process(clk) begin -- Ends the game if any of the players clock goes down to 0
		if temp_data(31 downto 16) = X"0000" or temp_data(15 downto 0) = X"0000" then
			game_over <= '1';
		end if;		
	end process;
	
end Behavioral;
