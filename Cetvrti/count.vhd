library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity count is
    port (
	clk_25m: in std_logic;
	btn_down, btn_up: in std_logic;
	sw: in std_logic_vector(3 downto 0);
	led: out std_logic_vector(7 downto 0)
    );
end count;

architecture x of count is
    signal R: std_logic_vector(7 downto 0);
    signal clk_key: std_logic;
    signal Reset: std_logic;
    
    constant max: std_logic_vector(7 downto 0) := "00010100";

begin
    
    Reset <= btn_down;
    
    process(clk_key)
    begin
	if rising_edge(clk_key) then
		if Reset = '1' then
			R <= "00000000";
		else 
			case R is
				when max - '1' => 
					R <= "00000000";
				when others =>
					R <= R + '1';
			end case;
		end if;
	end if;
    end process;

    led <= R;
    
    I_debouncer: entity work.debouncer port map (
	clk => clk_25m, key => btn_up, debounced => clk_key
    );
    
end x;

