library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity contadorN_Bits is
    generic (
        nBits: integer := 8
    );
    port (
        sclr    :   in      std_logic;
        clk     :	in		std_logic;    
        cout    :   out     std_logic;
        value_to_count  :  in   std_logic_vector (nBits-1 downto 0)
        );

end entity;

architecture rtl of contadorN_Bits is
    signal value   :    unsigned(nBits-1 downto 0);          --Vetor de saida de tamanho nBits
    signal ENA     :    std_logic;
    signal cout_aux : std_logic;
begin
    ENA <= not cout_aux;
    process(clk, sclr, ENA)               --Process que ocorre com mudança de clock ou reset (assincrono)
    begin
        if sclr = '1' then           --Se rst comutou para nivel baixo 
            value <= (others=>'0');   --Reinicia saida
            cout_aux <= '0';
        elsif rising_edge(clk) then --Quando clock passa por borda de subida
            if ENA = '1' then
                value<=value+1;                 --Saída recebe entrada
                if value = unsigned(value_to_count) then
                    value <= (others=>'0');
                    cout_aux <= '1';
                end if;
            end if;
        end if;
    end process;
    cout<=cout_aux;

end architecture rtl;
