library ieee;
use ieee.std_logic_1164.all;--bibliotecas para operação com vetores de numeros e conversão
use ieee.numeric_std.all;

entity debouncing is
  port(
    button  : in std_logic;    --Entrada para fazer debounce
    clk     : in std_logic;    --Sinal de clock
    result  : out std_logic    --Saída corrigida
  );
end entity debouncing;

architecture behavioral of debouncing is
    signal ff_in, ff_out : std_logic_vector(0 to 2);
    signal xorQ0_Q1: std_logic;
    signal cout_contador: std_logic;
    constant rst: std_logic:= '1'; --Reset travado em 1
    constant nBits: integer := 19; --Tamanho do valor para fazer a correção
    constant value_to_count: std_logic_vector(nBits-1 downto 0):= "1111010000100100000";
begin
    g1: for i in 0 to 1 generate
        generate_ffd : entity work.ffd(rtl) port map (clk, rst, ff_in(i), ff_out(i));
    end generate g1;

    g2: entity work.contadorN_Bits(rtl) generic map (nBits) port map (xorQ0_Q1,clk,cout_contador,value_to_count);
    
    --Faz as conexões de entradas e saídas dos FF
    ff_in(0)<=button;
    ff_in(1)<=ff_out(0);
    ff_in(2)<=ff_out(1);
    
    xorQ0_Q1 <= ff_out(0) xor ff_out(1);

    --Process para comutação da saída (result) em função das condições de debounce
    process(clk)
    begin
        if rising_edge(clk) then
            if cout_contador = '1' then
                result<=ff_in(2);
            end if;
        end if;
    end process;
    end architecture behavioral;
