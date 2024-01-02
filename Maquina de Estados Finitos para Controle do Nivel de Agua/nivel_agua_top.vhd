----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:	 09:25:08 03/12/2022 
-- Design Name: 
-- Module Name:	 nivel_agua_top - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity nivel_agua_top is
	Port (
		clk : in STD_LOGIC;
		reset : in STD_LOGIC;
		sw : in STD_LOGIC_VECTOR (2 downto 0);
		btn : in STD_LOGIC_VECTOR (1 downto 0);
		led : out STD_LOGIC_VECTOR (7 downto 0);
		an : out STD_LOGIC_VECTOR (3 downto 0);
		sseg : out STD_LOGIC_VECTOR (7 downto 0)
	);
end nivel_agua_top;

architecture Behavioral of nivel_agua_top is
	constant N: integer := 29;
	constant K: integer := 8;
	signal start, stop, nmin, nmax, inc: std_logic;
	signal abert_valv_reg, abert_valv_next: unsigned(K-1 downto 0);
	signal vfechada,vaberta, abre, fecha: std_logic;
	signal nivel_reg, nivel_next,novo: unsigned(N-1 downto 0);
	constant NIVEL_MAXIMO: unsigned (N-1 downto 0):= to_unsigned(500_000_000,N);
	constant NIVEL_MINIMO: unsigned (N-1 downto 0):= to_unsigned(10_000,N);
	signal nivel_saida: unsigned(N-1 downto 0);
	signal in3, in2, in1, in0: std_logic_vector(7 downto 0);
	type state_type is (desligado, ligado);
	signal control_reg, control_next: state_type;
	signal velocidade: unsigned(N-1 downto 0);
begin
	nivel_saida(N-1 downto 2) <= (others=>'0');
	with sw select 
		nivel_saida(1 downto 0) <= "00" when "000",
			"01" when "001"|"010"|"100",
			"10" when "110"|"101"|"011",
			"11" when others;
	nivel_agua_unit: entity work.nivel_agua (Behavioral)
	Port map(
		clk =>clk,
		reset=>reset,
		cf=>vfechada,
		ca=>vaberta,
		nmin=>nmin,
		nmax=>nmax,
		start=>start,
		stop=>stop,
		m1=>fecha,
		m0=>abre
	);
	deb_unit1: entity work.debounce (fsmd_arch)
	port map(
		clk =>clk,
		reset=>reset,
		sw=>btn(0),
		db_level=>open, 
		db_tick=>start
	);
	deb_unit0: entity work.debounce (fsmd_arch)
	port map(
		clk =>clk,
		reset=>reset,
		sw=>btn(1),
		db_level=>open, 
		db_tick=>stop
	);
	process(clk, reset)
	begin
		if reset = '1' then 
			nivel_reg <= (others=>'0');
			control_reg <= desligado;
			abert_valv_reg <= (others => '0');
		elsif clk' event and clk='1' then
			nivel_reg <= nivel_next;
			control_reg <= control_next;
			abert_valv_reg <= abert_valv_next;
		end if;
	end process;
	control_next <= ligado when start = '1' else
		desligado when stop = '1' else
		control_reg;
	abert_valv_next <= abert_valv_reg+1 when abre = '1' and abert_valv_reg /= 2**K-1 else
		abert_valv_reg-1 when fecha = '1' and abert_valv_reg /= 0 else
		abert_valv_reg;
	vfechada <= '1' when abert_valv_reg = 0 else
		'0';
	vaberta <= '1' when abert_valv_reg = 2**K-1 else
		'0';
	novo <= nivel_reg - nivel_saida when nivel_reg > nivel_saida else
		(others => '0');
	velocidade(N-1 downto 3) <= (others => '0');
	velocidade(2 downto 0) <= abert_valv_reg(K-1 downto K-3);
	process(nivel_reg, abert_valv_reg, velocidade, novo)
	begin
		if abert_valv_reg /= 0 then 
			if novo <= 2**N-velocidade-1 then
				nivel_next <= novo + velocidade;
			else 
				nivel_next <= (others=>'1');
			end if;
		else--if abert_valv_reg = 0 then
			nivel_next <= novo;
		end if;
	end process;
	nmin <= '1' when nivel_reg <= NIVEL_MINIMO else
		'0';
	nmax <= '1' when nivel_reg >= NIVEL_MAXIMO else
				'0';

	disp_unit: entity work.disp_mux (arch)
	port map(
		clk=>clk, reset=>reset,
		in3=>in3, in2=>in2, in1=>in1, in0=>in0,
		an=>an,
		sseg=>sseg
	);
	with nivel_saida(1 downto 0) select
	in3 <= "10000001" when "00",
			"11001111" when "01",
			"10010010" when "10",
			"10000110" when others;
	with control_reg select
	in2 <= "11000010" when desligado,
			 "11110001" when others;
	in1 <= "10001000" when abert_valv_reg = 2**K-1 else
			 "10111000" when abert_valv_reg = 0 else
			 "11111111";
	in0 <= "11100000" when nmin = '1' else 
			 "10110001" when nmax = '1' else
			 "11111111";
			 
	with nivel_reg(N-1 downto N-3) select
	led <= "10000000" when "000",
			"01000000" when "001",
			"00100000" when "010",
			"00010000" when "011",
			"00001000" when "100",
			"00000100" when "101",
			"00000010" when "110",
			"00000001" when others;

end Behavioral;

