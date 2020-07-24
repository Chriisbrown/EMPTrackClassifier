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
  Features_layer6 <= to_tx(to_integer(unsigned(LinksIn(0).data(6 downto 6))));

  Features_disk1 <= to_tx(to_integer(unsigned(LinksIn(1).data(63 downto 63))));
  Features_disk2 <= to_tx(to_integer(unsigned(LinksIn(1).data(62 downto 62))));
  Features_disk3 <= to_tx(to_integer(unsigned(LinksIn(1).data(61 downto 61))));
  Features_disk4 <= to_tx(to_integer(unsigned(LinksIn(1).data(60 downto 60))));
  Features_disk5 <= to_tx(to_integer(unsigned(LinksIn(1).data(59 downto 59))));
  Features_BigInvR <= to_tx(to_integer(unsigned(LinksIn(1).data(58 downto 47))));
  Features_TanL <= to_tx(to_integer(unsigned(LinksIn(1).data(46 downto 35))));
  Features_ModZ <= to_tx(to_integer(unsigned(LinksIn(1).data(34 downto 23))));
  Features_dtot <= to_tx(to_integer(unsigned(LinksIn(1).data(22 downto 20))));
  Features_ltot <= to_tx(to_integer(unsigned(LinksIn(1).data(19 downto 17))));

  --Features_logchi  <= to_tx(to_integer(signed(LinksIn(0).data(52 to 63))));
  --Features_logbendchi  <= to_tx(to_integer(signed(LinksIn(0).data(40 to 51))));
  --Features_logchirphi  <= to_tx(to_integer(signed(LinksIn(0).data(28 to 39))));
  --Features_logchirz  <= to_tx(to_integer(signed(LinksIn(0).data(16 to 27))));
  --Features_nstub  <= to_tx(to_integer(unsigned(LinksIn(0).data(12 to 15))));
  --Features_layer1 <= to_tx(to_integer(unsigned(LinksIn(0).data(11 to 11))));
  --Features_layer2 <= to_tx(to_integer(unsigned(LinksIn(0).data(10 to 10))));
  --Features_layer3 <= to_tx(to_integer(unsigned(LinksIn(0).data(9 to 9))));
  --Features_layer4 <= to_tx(to_integer(unsigned(LinksIn(0).data(8 to 8))));
  --Features_layer5 <= to_tx(to_integer(unsigned(LinksIn(0).data(7 to 7))));
  --Features_layer6 <= to_tx(to_integer(unsigned(LinksIn(0).data(6 to 6))));

  --Features_disk1 <= to_tx(to_integer(unsigned(LinksIn(0).data(63 to 63))));
  --Features_disk2 <= to_tx(to_integer(unsigned(LinksIn(0).data(62 to 62))));
  --Features_disk3 <= to_tx(to_integer(unsigned(LinksIn(0).data(61 to 61))));
  --Features_disk4 <= to_tx(to_integer(unsigned(LinksIn(0).data(60 to 60))));
  --Features_disk5 <= to_tx(to_integer(unsigned(LinksIn(0).data(59 to 59))));
  --Features_BigInvR <= to_tx(to_integer(unsigned(LinksIn(0).data(47 to 58))));
  --Features_TanL <= to_tx(to_integer(unsigned(LinksIn(0).data(35 to 46))));
  --Features_ModZ <= to_tx(to_integer(unsigned(LinksIn(0).data(23 to 34))));
  --Features_dtot <= to_tx(to_integer(unsigned(LinksIn(0).data(20 to 22))));
  --Features_ltot <= to_tx(to_integer(unsigned(LinksIn(0).data(17 to 19))));

  X(0) <= Features_logchi; 
  X(1) <= Features_logbendchi;
  X(2) <= Features_logchirphi;
  X(3) <= Features_logchirz;
  X(4) <= shift_right(Features_nstub, 6);
  X(5) <= shift_right(Features_layer1,6);
  X(6) <= shift_right(Features_layer2,6);
  X(7) <= shift_right(Features_layer3,6);
  X(8) <= shift_right(Features_layer4,6);
  X(9) <= shift_right(Features_layer5,6);
  X(10) <= shift_right(Features_layer6,6);
  X(11) <= shift_right(Features_disk1 ,6);
  X(12) <= shift_right(Features_disk2 ,6);
  X(13) <= shift_right(Features_disk3 ,6);
  X(14) <= shift_right(Features_disk4 ,6);
  X(15) <= shift_right(Features_disk5 ,6);
  X(16) <= Features_BigInvR;
  X(17) <= Features_TanL;
  X(18) <= Features_ModZ;
  X(19) <= shift_right(Features_dtot,6);
  X(20) <= shift_right(Features_ltot,6);

  v <= true when LinksIn(0).valid = '1' else false;

end architecture rtl;
