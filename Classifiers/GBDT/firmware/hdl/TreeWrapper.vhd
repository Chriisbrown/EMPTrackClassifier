library ieee;
use ieee.std_logic_1164.all;

library work;
use work.Constants.all;
use work.Types.all;

entity TreeTop is
    clk : in std_logic;
    LinksIn : in ldata(4 * N_REGION - 1 downto 0) := ( others => LWORD_NULL );
    LinksOut : out ldata(4 * N_REGION - 1 downto 0) := ( others => LWORD_NULL );
end TreeTop;

architecture rtl of TreeTop is
  signal X : txArray(0 to nFeatures - 1) := (others => to_tx(0));
  signal X_vld : boolean := false;
  signal y : tyArray(0 to nClasses - 1) := (others => to_ty(0));
  signal y_vld : boolArray(0 to nClasses - 1) := (others => false);
begin

    Input : entity work.RunningInput
    port map(clk, X, X_vld,LinksIn);

    UUT : entity work.BDTTop
    port map(clk, X, X_vld, y, y_vld);

    Output : entity work.RunningOutput
    port map(clk, y, y_vld(0),LinksOut);

end architecture rtl;
