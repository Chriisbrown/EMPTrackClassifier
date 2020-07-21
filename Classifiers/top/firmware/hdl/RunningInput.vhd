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
  signal Features_logchi : tx;
  signal Features_logbendchi : tx;
  signal Features_logchirphi : tx;
  signal Features_logchirz : tx;
  signal Features_nstub : tx;
  signal Features_layer1 : tx;
  signal Features_layer2: tx;
  signal Features_layer3: tx;
  signal Features_layer4: tx;
  signal Features_layer5: tx;
  signal Features_layer6 :tx;
  signal Features_disk1 :tx;
  signal Features_disk2 :tx;
  signal Features_disk3 :tx;
  signal Features_disk4 :tx;
  signal Features_disk5 :tx;
  signal Features_BigInvR :tx;
  signal Features_TanL :tx;
  signal Features_ModZ  :tx;
  signal Features_dtot :tx;
  signal Features_ltot :tx;

begin
  Features_logchi  <= to_tx(to_integer(signed(LinksIn(0).data(63 downto 52))));
  Features_logbendchi  <= to_tx(to_integer(signed(LinksIn(0).data(51 downto 40))));
  Features_logchirphi  <= to_tx(to_integer(signed(LinksIn(0).data(39 downto 28))));
  Features_logchirz  <= to_tx(to_integer(signed(LinksIn(0).data(27 downto 16))));
  Features_nstub  <= to_tx(to_integer(unsigned(LinksIn(0).data(15 downto 12))));
  Features_layer1 <= to_tx(to_integer(unsigned(LinksIn(0).data(11 downto 11))));
  Features_layer2 <= to_tx(to_integer(unsigned(LinksIn(0).data(10 downto 10))));
  Features_layer3 <= to_tx(to_integer(unsigned(LinksIn(0).data(9 downto 9))));
  Features_layer4 <= to_tx(to_integer(unsigned(LinksIn(0).data(8 downto 8))));
  Features_layer5 <= to_tx(to_integer(unsigned(LinksIn(0).data(7 downto 7))));
  Features_layer6 <= to_tx(to_integer(unsigned(LinksIn(0).data(6 downto 6)));

  Features_disk1 <= to_tx(to_integer(unsigned(LinksIn(0).data(63 downto 63))));
  Features_disk2 <= to_tx(to_integer(unsigned(LinksIn(0).data(62 downto 62))));
  Features_disk3 <= to_tx(to_integer(unsigned(LinksIn(0).data(61 downto 61))));
  Features_disk4 <= to_tx(to_integer(unsigned(LinksIn(0).data(60 downto 60))));
  Features_disk5 <= to_tx(to_integer(unsigned(LinksIn(0).data(59 downto 59))));
  Features_BigInvR <= to_tx(to_integer(unsigned(LinksIn(0).data(58 downto 47))));
  Features_TanL <= to_tx(to_integer(unsigned(LinksIn(0).data(46 downto 35))));
  Features_ModZ <= to_tx(to_integer(unsigned(LinksIn(0).data(34 downto 23))));
  Features_dtot <= to_tx(to_integer(unsigned(LinksIn(0).data(22 downto 20))));
  Features_ltot <= to_tx(to_integer(unsigned(LinksIn(0).data(19 downto 17))));

  X(0) <= Features_logchi; 
  X(1) <= Features_logbendchi;
  X(2) <= Features_logchirphi;
  X(3) <= Features_logchirz;
  X(4) <= Features_nstub * 2**7;
  X(5) <= Features_layer1* 2**7;
  X(6) <= Features_layer2* 2**7;
  X(7) <= Features_layer3* 2**7;
  X(8) <= Features_layer4* 2**7;
  X(9) <= Features_layer5* 2**7;
  X(10) <= Features_layer6* 2**7;
  X(11) <= Features_disk1* 2**7;
  X(12) <= Features_disk2* 2**7;
  X(13) <= Features_disk3* 2**7;
  X(14) <= Features_disk4* 2**7;
  X(15) <= Features_disk5* 2**7;
  X(16) <= Features_BigInvR;
  X(17) <= Features_TanL;
  X(18) <= Features_ModZ;
  X(19) <= Features_dtot* 2**7;
  X(20) <= Features_ltot* 2**7;

  v <= true when LinksIn(0).valid = '1' else false;

end architecture rtl;
