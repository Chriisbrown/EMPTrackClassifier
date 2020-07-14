library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;


library BDT;
use BDT.Types.all;
use BDT.Constants.all;

entity RunningInput is
  port(
    clk    : in std_logic;
    X : out txArray(nFeatures - 1 downto 0) := (others => to_tx(0));
    v : out boolean := false;
    LinksIn : in ldata(4 * N_REGION - 1 downto 0) := ( others => LWORD_NULL );
  );
end RunningInput;
-- -------------------------------------------------------------------------
-- -------------------------------------------------------------------------
architecture rtl of RunningInput is

  type tIntArray is array(integer range <>) of integer;

begin
-- pragma synthesis_off
  process(clk)
    variable XRead : tIntArray(X'left downto X'right) := (others => 0);
  begin
  if rising_edge(clk) then
    for i in  X'range loop
        XRead(i) <= LinksIn(i);
        X(i) <= to_tx(XRead(i));
      end loop;
      v <= true;
    
  end if;
  end process;
-- pragma synthesis_on    
end architecture rtl;
