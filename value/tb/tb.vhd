library ieee;
   use ieee.std_logic_1164.all;

library ltypes;
   use ltypes.types;

library checkers;


entity tb_value is
end entity;


architecture test of tb_value is

   constant CLK_PERIOD : time := 10 ns;

   constant WIDTH  : positive := 4;
   constant LENGTH : positive := 5;

   signal data : std_logic_vector(WIDTH - 1 downto 0);

   constant VALID_VALUES : types.slv_vector(0 to LENGTH - 1) := (
      "0000", "1010", "XX11", "1X1X", "1011"
   );

begin

   DUT : entity checkers.Value
   generic map (
      WIDTH  => WIDTH,
      LENGTH => LENGTH,
      PREFIX => "prefix: "
   ) port map (
      data   => data,
      values => VALID_VALUES
   );


   main : process is
   begin
      for i in VALID_VALUES'range loop
         wait for CLK_PERIOD;
         data <= VALID_VALUES(i);
      end loop;

      wait for CLK_PERIOD;
      std.env.finish;
   end process;

end architecture;
