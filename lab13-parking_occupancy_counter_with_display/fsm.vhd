library ieee;
use ieee.std_logic_1164.all;


entity fsm is
	port (
		a          : in std_logic;
		b          : in std_logic;
		clk, reset : in std_logic;
		enable     : in std_logic;
		car_enter  : out std_logic;
		car_exit   : out std_logic
	);
end fsm;

architecture arch of fsm is
	type eg_state_type is (I, IA, IAB, IB, EN, OB, OAB, OA, EX);
	signal state_reg, state_next : eg_state_type;
begin
	-- state register
	process (clk, reset, enable)
	begin
		if (reset = '1') then
			state_reg <= I;
		elsif (clk'event and clk = '1') then -- clock rising edge
			if (enable = '1') then
				state_reg <= state_next; -- state change
			end if;
		end if;
	end process;

	-- next-state logic
	process (state_reg, a, b)
	begin
		case state_reg is
			-- initial/normal state
			when I =>
				if a = '1' then
                    state_next <= IA; -- next state (enter flux)
				elsif a = '0' and b = '1' then
					state_next <= OB; -- next state (exit flux)
				else
					state_next <= I; -- current state
				end if;

			-- enter flux
			when IA =>
				if a = '1' and b = '1' then
					state_next <= IAB; -- next state
				elsif a = '1' and b = '0' then
					state_next <= IA; -- current state
				else -- a = '0'
					state_next <= I; -- previous state
				end if;
			when IAB =>
				if a = '0' and b = '1' then
					state_next <= IB; -- next state
				elsif a = '1' and b = '1' then
					state_next <= IAB; -- current state
				else -- b = '0'
					state_next <= IA; -- previous state
				end if;
			when IB =>
				if a = '0' and b = '0' then
					state_next <= EN; -- next state
				elsif a = '0' and b = '1' then
					state_next <= IB; -- current state
				else -- a = '1'
					state_next <= IAB; -- previous state
				end if;

			-- exit flux
			when OB =>
				if a = '1' and b = '1' then
					state_next <= OAB; -- next state
				elsif a = '0' and b = '1' then
					state_next <= OB; -- current state
				else -- b = '0'
					state_next <= I; -- previous state
				end if;
			when OAB =>
				if a = '1' and b = '0' then
					state_next <= OA; -- next state
				elsif a = '1' and b = '1' then
					state_next <= OAB; -- current state
				else -- a = '0'
					state_next <= OB; -- previous state
				end if;
			when OA =>
				if a = '0' and b = '0' then
					state_next <= EX; -- next state
				elsif a = '1' and b = '0' then
					state_next <= OA; -- current state
				else -- b = '1'
					state_next <= OAB; -- previous state
				end if;

			-- return flux
			when others => -- EN, EX
				state_next <= I;
		end case;
	end process;

	-- Moore output logic
	process (state_reg)
	begin
		case state_reg is
			when EN =>
				car_enter <= '1';
				car_exit <= '0';
			when EX =>
				car_enter <= '0';
				car_exit <= '1';
			when others =>
				car_enter <= '0';
				car_exit <= '0';
		end case;
	end process;

end arch;
