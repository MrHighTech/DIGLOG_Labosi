library ieee;
use ieee.std_logic_1164.all;

entity slova is
    port (
        btn_left, btn_right, btn_up, btn_down, btn_center: in std_logic;
	rs232_tx: out std_logic;
	clk_25m: in std_logic;
        led: out std_logic_vector(7 downto 0);
	sw: in std_logic_vector(3 downto 0)
    );
end slova;


architecture behavioral of slova is
    signal code: std_logic_vector(7 downto 0);
    signal btns: std_logic_vector(4 downto 0);
    signal code_swup: std_logic_vector(7 downto 0);
    signal code_swdown: std_logic_vector(7 downto 0);

begin

    -- Koristite samo jedan izraz za grupiranje jednobitnih ulaznih
    -- signala (tipki) u visebitni signal btns, zavisno od razvojne
    -- plocice koju koristite (ULX2S ili ULX3S)

    btns <= btn_down & btn_left & btn_center & btn_up & btn_right; -- ULX2S
	
    with btns select
    code_swup <=
	"00000000" when "00000",
	"00000000" when "00100", -- center NULL
	"01001101" when "01000", -- left M
	"01100001" when "10000", -- down a 
	"01110100" when "00010", -- up t
	"01100101" when "00001", -- right e
	"01000010" when "01100", -- center and left B
	"01100101" when "10100", -- center and down e
	"01101110" when "00110", -- center and up n
	"01100011" when "00101", -- center and right c
        "--------" when others ; -- dc
	
    with sw(0) select
    code <= 
        code_swup when '0',
	code_swdown when '1';
	
    led <= code;


    serializer: entity serial_tx port map (
	clk => clk_25m, byte_in => code, ser_out => rs232_tx
    );
    
    br: entity work.brojke port map (
        mb_down => btn_down, mb_left => btn_left, mb_center => btn_center, mb_up => btn_up, mb_right => btn_right, mb_code => code_swdown
    );
end;
