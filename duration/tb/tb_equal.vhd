library ieee;
   use ieee.std_logic_1164.all;

library checkers;

entity tb_duration_equal is
end entity;


architecture test of tb_duration_equal is

   constant CLK_PERIOD : time := 10 ns;

   constant WIDTH : positive := 2;
   constant VALUE : std_logic_vector(WIDTH-1 downto 0) := "10";

   signal data : std_logic_vector(WIDTH-1 downto 0) := VALUE;

begin


   DUT : entity checkers.Duration
   generic map (
      WIDTH  => WIDTH
   ) port map (
      data     => data,
      duration => 7 * clk_period,
      value    => VALUE
   );


   main : process is
   begin
      wait for 7 * CLK_PERIOD;
      data <= (others => '0');

      wait for CLK_PERIOD;
      std.env.finish;
   end process;

end architecture;
