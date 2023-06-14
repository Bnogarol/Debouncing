library ieee;
use ieee.std_logic_1164.all;

--Entidade de criação de um FF tipo D
entity ffd is
    port (
        clk :	in		std_logic;      --Sinal do clock
        rst :	in		std_logic;      --Reset de borda de descida
        d   :	in		std_logic;      --Vetor de entrada de tamanho nBits
        q   :	out	    std_logic       --Vetor de saida de tamanho nBits
    );

end entity;

architecture rtl of ffd is
    
begin
    
    process(clk, rst)               --Process que ocorre com mudança de clock ou reset (assincrono)
    begin
        if rst = '0' then           --Zerar saída se rst comutou para nivel baixo 
            q <= '0';  
        elsif rising_edge(clk) then --Quando clock passa por borda de subida, atualiza saída
            q <= d;              
        end if;

    end process;

end architecture rtl;
