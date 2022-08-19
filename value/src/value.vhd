-- SPDX-License-Identifier: MIT
-- https://github.com/m-kru/vhdl-checkers
-- Copyright (c) 2022 Michał Kruszewski

library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std.all;

library ltypes;
   use ltypes.types;

-- The Value checker ensures that data value is always in a set of valid values.
--
-- INIT - an extra valid value that is checked only during start up.
-- PREFIX - an optional prefix used in report messages.
entity Value is
   generic (
      WIDTH  : positive;
      LENGTH : positive;
      INIT   : std_logic_vector(WIDTH - 1 downto 0) := (others => 'U');
      SVRITY : SEVERITY_LEVEL := failure;
      PREFIX : string := ""
   );
   port (
      data   : in std_logic_vector(WIDTH - 1 downto 0);
      values : in types.slv_vector(0 to LENGTH - 1)(WIDTH - 1 downto 0)
   );
end entity;


architecture Check of Value is

   impure function valid return boolean is
   begin
      for i in values'range loop
         if data = values(i) then
            return true;
         end if;
      end loop;
      return false;
   end function;

begin

   process is
   begin
      if (not valid) and (data /= INIT) then
         report PREFIX & "invalid initial value 0b" & to_string(data) &
            " (" & to_string(to_integer(unsigned(data))) & ")" &
            " (0x" & to_hstring(data) & ")"
            severity SVRITY;
      end if;

      loop
         wait until data'event;

         if not valid then
            report PREFIX & "invalid value 0b" & to_string(data) &
               " (" & to_string(to_integer(unsigned(data))) & ")" &
               " (0x" & to_hstring(data) & ")"
               severity SVRITY;
         end if;
      end loop;
   end process;

end architecture;
