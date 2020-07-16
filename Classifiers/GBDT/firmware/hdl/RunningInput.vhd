LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


use work.ipbus.all;
use work.emp_data_types.all;
use work.emp_project_decl.all;

use work.emp_device_decl.all;
use work.emp_ttc_decl.all;



library work;
use work.Constants.all;
use work.Types.all;

entity RunningInput is
  port(
    clk    : in std_logic;
    X : out txArray(nFeatures - 1 downto 0) := (others => to_tx(0));
    v : out boolean := false;
    LinksIn : in ldata(4 * N_REGION - 1 downto 0) := ( others => LWORD_NULL )
  );
end RunningInput;
-- -------------------------------------------------------------------------

-- -------------------------------------------------------------------------
architecture rtl of RunningInput is
  signal Features_0 : tx;
  signal Features_1 : tx;
  signal Features_2 : tx;
  signal Features_3 : tx;
  signal Features_4 : tx;
  signal Features_5 : tx;
  signal Features_6 : tx;
  signal Features_7 : tx;
  signal Features_8 : tx;
  signal Features_9 : tx;
  signal Features_10 :tx;
  signal Features_11 :tx;
  signal Features_12 :tx;
  signal Features_13 :tx;
  signal Features_14 :tx;
  signal Features_15 :tx;
  signal Features_16 :tx;
  signal Features_17 :tx;
  signal Features_18 :tx;
  signal Features_19 :tx;
  signal Features_20 :tx;

begin
  Features_0  <= to_tx(LinksIn(0).data);
  Features_1  <= to_tx(LinksIn(1).data);
  Features_2  <= to_tx(LinksIn(2).data);
  Features_3  <= to_tx(LinksIn(3).data);
  Features_4  <= to_tx(LinksIn(4).data);
  Features_5  <= to_tx(LinksIn(5).data);
  Features_6  <= to_tx(LinksIn(6).data);
  Features_7  <= to_tx(LinksIn(7).data);
  Features_8  <= to_tx(LinksIn(8).data);
  Features_9  <= to_tx(LinksIn(9).data);
  Features_10 <= to_tx(LinksIn(10).data);
  Features_11 <= to_tx(LinksIn(11).data);
  Features_12 <= to_tx(LinksIn(12).data);
  Features_13 <= to_tx(LinksIn(13).data);
  Features_14 <= to_tx(LinksIn(14).data);
  Features_15 <= to_tx(LinksIn(15).data);
  Features_16 <= to_tx(LinksIn(16).data);
  Features_17 <= to_tx(LinksIn(17).data);
  Features_18 <= to_tx(LinksIn(18).data);
  Features_19 <= to_tx(LinksIn(19).data);
  Features_20 <= to_tx(LinksIn(20).data);

  X(0) <= Features_0;
  X(1) <= Features_1;
  X(2) <= Features_2;
  X(3) <= Features_3;
  X(4) <= Features_4;
  X(5) <= Features_5;
  X(6) <= Features_6;
  X(7) <= Features_7;
  X(8) <= Features_8;
  X(9) <= Features_9;
  X(10) <= Features_10;
  X(11) <= Features_11;
  X(12) <= Features_12;
  X(13) <= Features_13;
  X(14) <= Features_14;
  X(15) <= Features_15;
  X(16) <= Features_16;
  X(17) <= Features_17;
  X(18) <= Features_18;
  X(19) <= Features_19;
  X(20) <= Features_20;

  v <= True;

end architecture rtl;
