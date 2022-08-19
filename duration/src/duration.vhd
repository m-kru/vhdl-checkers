-- SPDX-License-Identifier: MIT
-- https://github.com/m-kru/vhdl-checkers
-- Copyright (c) 2022 Michał Kruszewski

library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std.all;

-- The Duration checker ensures that given value lasts for given
-- time on given data signal.
--
-- POLICY - check policy. Must be one of: 'equal', 'less than' or 'more than'.
-- PREFIX - an optional prefix used in report messages.
entity Duration is
   generic (
      WIDTH  : positive := 1;
      POLICY : string := "equal";
      SVRITY : SEVERITY_LEVEL := failure;
      PREFIX : string := ""
   );
   port (
      data     : in std_logic_vector(WIDTH - 1 downto 0);
      duration : in time;
      value    : in std_logic_vector(WIDTH - 1 downto 0)
   );
begin

   assert POLICY = "equal" or POLICY = "less than" or POLICY = "more than"
      report "POLICY must be one of: 'equal', 'less than' or 'more than'"
      severity failure;

end entity;


architecture Check of Duration is

   impure function policy_to_str return string is
   begin
      if POLICY = "equal" then
         return "";
      end if;
      return POLICY & " ";
   end function;

begin

   process is
      variable start_time : time := 0 fs;
      variable duration_time : time;
      variable violated : boolean;
   begin
      loop
         wait until data'event;
         violated := false;

         if data = value then
            start_time := now;
         elsif data'last_value = value then
            duration_time := now - start_time;
            if POLICY = "equal" then
               if duration_time /= DURATION then violated := true; end if;
            elsif POLICY = "less than" then
               if duration_time >= DURATION then violated := true; end if;
            elsif POLICY = "more than" then
               if duration_time <= DURATION then violated := true; end if;
            end if;
            if violated then
               report PREFIX & "value 0b" & to_bstring(value) &
                  " (" & to_string(to_integer(unsigned(value))) & ")" &
                  " (0x" & to_hstring(value) & ")" &
                  " lasted for " & to_string(duration_time) &
                  ", but was supposed to last for " & policy_to_str & to_string(DURATION)
                  severity SVRITY;
            end if;
         end if;
      end loop;
   end process;

end architecture;
