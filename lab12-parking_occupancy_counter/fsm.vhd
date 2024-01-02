library ieee;
use ieee.std_logic_1164.all;
entity fsm is
	port (
		a : in std_logic;
		b : in std_logic;
		clk, reset : in std_logic;
		enable : in std_logic;
		car_enter : out std_logic;
		car_exit : out std_logic
	);
end fsm;

architecture arch of fsm is
	type eg_state_type is (SN, SA, SAB, SB, SL);
	signal state_reg, state_next : eg_state_type;
begin
	-- state register
	process (clk, reset)
	begin
		if (reset = '1') then
			state_reg <= SN;
		elsif (clk'EVENT and clk = '1') then -- clock rising edge
			if (enable = '1') then
				state_reg <= state_next; -- state change
			end if;
		end if;
	end process;
	-- next-state logic
	process (state_reg, a, b, enable)
		begin
			case state_reg is
				when SN => 
					if a = '0' and b = '0' then
						state_next <= SN;
					elsif a = '1' and b = '0' then
						state_next <= SA;
					else
						state_next <= state_reg;
					end if;
				when SA => 
					if a = '1' and b = '0' then
						state_next <= SA;
					elsif a = '1' and b = '1' then
						state_next <= SAB;
					elsif a = '0' and b = '0' then
						state_next <= SL;
					elsif a = '0' then
						state_next <= SN;
					else
						state_next <= state_reg;
					end if;
				when SAB => 
					if a = '1' and b = '1' then
						state_next <= SAB;
					elsif a = '0' and b = '1' then
						state_next <= SB;
					elsif b = '0' then
						state_next <= SA;
					else
						state_next <= state_reg;
					end if;
				when SB => 
					if a = '0' and b = '1' then
						state_next <= SB;
					elsif a = '0' and b = '0' then
						state_next <= SL;
					else
						state_next <= state_reg;
					end if;
				when SL => 
					if enable = '1' then
						state_next <= SN;
					else
						state_next <= state_reg;
					end if;
			end case;
		end process;
		-- Moore output logic
		process (state_reg)
			begin
				case state_reg is
					when SN => 
						car_enter <= '0';
						car_exit <= '0';
					when SA => 
						car_enter <= '0';
						car_exit <= '0';
					when SAB => 
						car_enter <= '0';
						car_exit <= '0';
					when SB => 
						car_enter <= '0';
						car_exit <= '0';
					when SL => 
						car_enter <= '1';
						car_exit <= '1';
				end case;
			end process;
end arch;