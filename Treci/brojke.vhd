library ieee;
use ieee.std_logic_1164.all;

entity brojke is
    port (
        mb_left, mb_right, mb_up, mb_down, mb_center: in std_logic;
	mb_code: out std_logic_vector(7 downto 0)
    );
end brojke;

architecture behavioral of brojke is
    signal btns: std_logic_vector(4 downto 0);
    signal code: std_logic_vector(7 downto 0);

begin

    -- Koristite samo jedan izraz za grupiranje jednobitnih ulaznih
    -- signala (tipki) u visebitni signal btns, zavisno od razvojne
    -- plocice koju koristite (ULX2S ili ULX3S)

    btns <= mb_down & mb_left & mb_center & mb_up & mb_right; -- ULX2S
    
    with btns select
    code <=
	"00000000" when "00000",
	"00000000" when "10000", -- down NULL
	"00110011" when "01000", -- left 3
	"00110110" when "00100", -- center 6
	"00110101" when "00010", -- up 5
	"00110011" when "00001", -- right 3
	"00110001" when "11000", -- down and left 1
	"00110000" when "10100", -- down and center 0
	"00110010" when "10010", -- down and up 2
	"00110000" when "10001", -- down and right 0
        "--------" when others ; -- dc
    
    mb_code <= code;
    
end;