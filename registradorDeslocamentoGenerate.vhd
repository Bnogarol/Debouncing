library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registradorDeslocamentoGenerate is
	generic(
    	N: integer := 8  -- Quantia de LEDs
  	);
  	port(
		clk:  in  std_logic;    -- Sinal de clock
		clk_button: in std_logic; --Sinal de clock vindo do botão
		rst:  in  std_logic;    -- Sinal de reset assíncrono
		rx:   in  std_logic;    -- Dado de entrada
		tx:   out std_logic;    -- Dado de saída
		leds: out std_logic_vector (N-1 downto 0) --Array de LEDs de saída
  	);
end entity registradorDeslocamentoGenerate;

architecture behavioral of registradorDeslocamentoGenerate is
	signal D_flipflops: std_logic_vector(N-2 downto 0);  -- Vetor de entrada dos flip-flops
	signal Q_flipflops: std_logic_vector(N-2 downto 0);  -- Vetor de saída dos flip-flops
	signal clk_debounced: std_logic;					   -- Clock do botão pós debounce
begin

	--Entidade para fazer debounce do clock de botão
	debounce : entity work.debouncing(behavioral) port map (clk_button, clk, clk_debounced);

	--Gerar os FF tipo D para o registrador
	ff_d: for i in N-2 downto 0 generate
		generate_ffd: entity work.ffd(rtl) port map(clk_debounced,rst,D_flipflops(i),Q_flipflops(i));
	end generate ff_d;
  
	--As entrada são conectadas à chave de entrada e as saídas dos respectivos próximos FF
	D_flipflops(N-2 downto 0)<=Q_Flipflops(N-3 downto 0)&rx;

	--O sinal de transmissão é a saída do último FF
	tx<=Q_flipflops(N-2);
  
	--Atualiza os LEDs nas bordas de subida do clock (botão)
	process(clk_debounced, rst) --Process de reset assíncrono             
	begin
		if rst = '0' then           
			leds <= (others =>'0'); 
		elsif rising_edge(clk_debounced) then 
			leds <=Q_flipflops & rx;              
		end if;
	end process;

  
end architecture behavioral;
