library ieee;
use ieee.std_logic_1164.all;
entity fsm_display is
	port (
		cw : in std_logic;
		en : in std_logic;
		clk, reset : in std_logic;
		enable : in std_logic;
		an : out std_logic_vector(7 downto 0);
		sseg : out std_logic_vector(7 downto 0)
	);
end fsm_display;

architecture mult_seg_arch of fsm_display is
	type eg_state_type is (s0, s1, s2, s3, s4, s5, s6, s7);
	signal state_reg, state_next : eg_state_type;
begin
	-- state register
	process (clk, reset)
	begin
		if (reset = '1') then
			state_reg <= s0;
		elsif (clk'event and clk = '1') then -- clock rising edge
			if (enable = '1') then
				state_reg <= state_next; -- state change
			end if;
		end if;
	end process;
	-- next-state logic
	process (state_reg, en, cw)
		begin
			case state_reg is
				when s0 => 
					if en = '1' then
						state_next <= s0;
					else
						if cw = '0' then
							state_next <= s7;
						else
							state_next <= s1;
						end if;
					end if;
				when s1 => 
					if en = '1' then
						state_next <= s1;
					else
						if cw = '0' then
							state_next <= s0;
						else
							state_next <= s2;
						end if;
					end if;
				when s2 => 
					if en = '1' then
						state_next <= s2;
					else
						if cw = '0' then
							state_next <= s1;
						else
							state_next <= s3;
						end if;
					end if;
				when s3 => 
					if en = '1' then
						state_next <= s3;
					else
						if cw = '0' then
							state_next <= s2;
						else
							state_next <= s4;
						end if;
					end if;
				when s4 => 
					if en = '1' then
						state_next <= s4;
					else
						if cw = '0' then
							state_next <= s3;
						else
							state_next <= s5;
						end if;
					end if;
				when s5 => 
					if en = '1' then
						state_next <= s5;
					else
						if cw = '0' then
							state_next <= s4;
						else
							state_next <= s6;
						end if;
					end if;
				when s6 => 
					if en = '1' then
						state_next <= s6;
					else
						if cw = '0' then
							state_next <= s5;
						else
							state_next <= s7;
						end if;
					end if;
				when s7 => 
					if en = '1' then
						state_next <= s7;
					else
						if cw = '0' then
							state_next <= s6;
						else
							state_next <= s0;
						end if;
					end if;
			end case;
		end process;
		-- Moore output logic
		process (state_reg)
			begin
				case state_reg is
					when s0 => 
						an <= "11110111";
						sseg <= "10011100";
					when s1 => 
						an <= "11111011";
						sseg <= "10011100";
					when s2 => 
						an <= "11111101";
						sseg <= "10011100";
					when s3 => 
						an <= "11111110";
						sseg <= "10011100";
					when s4 => 
						an <= "11111110";
						sseg <= "10100011";
					when s5 => 
						an <= "11111101";
						sseg <= "10100011";
					when s6 => 
						an <= "11111011";
						sseg <= "10100011";
					when s7 => 
						an <= "11110111";
						sseg <= "10100011";
				end case;
			end process;
end mult_seg_arch;

