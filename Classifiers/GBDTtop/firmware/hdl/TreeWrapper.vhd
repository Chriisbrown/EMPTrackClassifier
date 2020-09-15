LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


use work.ipbus.all;
use work.emp_data_types.all;
use work.emp_project_decl.all;

use work.emp_device_decl.all;
use work.emp_ttc_decl.all;

--library GBDT;
use work.Constants.all;
use work.Types.all;



entity TreeWrapper is
  port (
    clk : in std_logic;
    LinksIn : in ldata(4 * N_REGION - 1 downto 0) := ( others => LWORD_NULL );
    LinksOut : out ldata(4 * N_REGION - 1 downto 0) := ( others => LWORD_NULL )
    
  );
end entity TreeWrapper;

architecture rtl of TreeWrapper is
  signal X : txArray(0 to nFeatures - 1) := (others => to_tx(0));
  signal X_vld : boolean := false;
  signal y : tyArray(0 to nClasses - 1) := (others => to_ty(0));
  signal y_vld : boolArray(0 to nClasses - 1) := (others => false);
  signal feature_vector : std_logic_vector (261 downto 0);
  signal feature_v : std_logic;
begin

    Input : entity work.FeatureTransform
    port map(clk, feature_vector, feature_v,LinksIn);

    UIN : entity work.RunningInput
    port map(clk, feature_vector,feature_v,X,X_vld);

    UUT : entity work.RunningNull
    port map(clk, X, X_vld, y, y_vld);

    Output : entity work.RunningOutput
    port map(clk, y, y_vld(0),LinksOut);

end architecture rtl;
