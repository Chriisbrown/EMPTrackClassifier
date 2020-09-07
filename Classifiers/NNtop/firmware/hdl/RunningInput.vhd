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
    ap_clk    : in std_logic;
    input_1_V_ap_vld : IN STD_LOGIC;
    input_1_V : IN STD_LOGIC_VECTOR (335 downto 0);
    LinksIn : in ldata(4 * N_REGION - 1 downto 0) := ( others => LWORD_NULL )
  );
end RunningInput;
-- -------------------------------------------------------------------------

-- -------------------------------------------------------------------------
architecture rtl of RunningInput is
  Constant Multiplier: integer:= 65536;

  signal Feature_LogChi: integer;
  signal Feature_LogBendChi: integer;
  signal Feature_LogChiRphi: integer;
  signal Feature_LogChiRz: integer;

  signal Feature_nstub: integer;
  signal Feature_layer1: integer;
  signal Feature_layer2: integer;
  signal Feature_layer3: integer;
  signal Feature_layer4: integer;
  signal Feature_layer5: integer;
  signal Feature_layer6: integer;

  signal Feature_disk1: integer;
  signal Feature_disk2: integer;
  signal Feature_disk3: integer;
  signal Feature_disk4: integer;
  signal Feature_disk5: integer;
  
  signal Feature_InvR: integer;
  signal Feature_Tanl: integer;
  signal Feature_Z0: integer;
   
  signal Feature_nlayer: integer;
  signal Feature_ndisk: integer;

  signal temp_v: boolean;

begin
  process(clk)
begin
  if rising_edge(clk) then

    Feature_LogChi <= to_integer(signed(LinksIn(0).data(15 downto 0))); 
    input_1_V(335 downto 320) <= to_tx(to_integer(to_signed(Feature_LogChi*1,16)));

    Feature_LogBendChi <= to_integer(signed(LinksIn(0).data(31 downto 16))); 
    input_1_V(319 downto 304) <= to_tx(to_integer(to_signed(Feature_LogBendChi*1,16)));

    Feature_LogChiRphi <= to_integer(signed(LinksIn(0).data(47 downto 32))); 
    input_1_V(303 downto 288) <= to_tx(to_integer(to_signed(Feature_LogChiRphi*1,16)));

    Feature_LogChiRz <= to_integer(signed(LinksIn(1).data(15 downto 0))); 
    input_1_V(287 downto 272) <= to_tx(to_integer(to_signed(Feature_LogChiRz*1,16)));

    Feature_nstub <= to_integer(unsigned(LinksIn(1).data(19 downto 16))); 
    input_1_V(271 downto 256) <= to_tx(to_integer(to_unsigned(Feature_nstub*Multiplier,16))); 
    
    Feature_layer1 <= to_integer(unsigned(LinksIn(1).data(20 downto 20)));
    input_1_V(255 downto 240) <= to_tx(to_integer(to_unsigned(Feature_layer1*Multiplier,16))); 

    Feature_layer2 <= to_integer(unsigned(LinksIn(1).data(21 downto 21)));
    input_1_V(239 downto 224) <= to_tx(to_integer(to_unsigned(Feature_layer2*Multiplier,16))); 

    Feature_layer3 <= to_integer(unsigned(LinksIn(1).data(22 downto 22)));
    input_1_V(223 downto 208) <= to_tx(to_integer(to_unsigned(Feature_layer3*Multiplier,16)));

    Feature_layer4 <= to_integer(unsigned(LinksIn(1).data(23 downto 23)));
    input_1_V(207 downto 192) <= to_tx(to_integer(to_unsigned(Feature_layer4*Multiplier,16))); 

    Feature_layer5 <= to_integer(unsigned(LinksIn(1).data(24 downto 24)));
    input_1_V(191 downto 176) <= to_tx(to_integer(to_unsigned(Feature_layer5*Multiplier,16))); 

    Feature_layer6 <= to_integer(unsigned(LinksIn(1).data(25 downto 25)));
    input_1_V(175 downto 160) <= to_tx(to_integer(to_unsigned(Feature_layer6*Multiplier,16))); 

    Feature_disk1 <= to_integer(unsigned(LinksIn(1).data(26 downto 26)));
    input_1_V(159 downto 144) <= to_tx(to_integer(to_unsigned(Feature_disk1*Multiplier,16))); 

    Feature_disk2 <= to_integer(unsigned(LinksIn(1).data(27 downto 27)));
    input_1_V(143 downto 128) <= to_tx(to_integer(to_unsigned(Feature_disk2*Multiplier,16))); 

    Feature_disk3 <= to_integer(unsigned(LinksIn(1).data(28 downto 28)));
    input_1_V(127 downto 112) <= to_tx(to_integer(to_unsigned(Feature_disk3*Multiplier,16))); 

    Feature_disk4 <= to_integer(unsigned(LinksIn(1).data(29 downto 29)));
    input_1_V(111 downto 96) <= to_tx(to_integer(to_unsigned(Feature_disk4*Multiplier,16))); 

    Feature_disk5 <= to_integer(unsigned(LinksIn(1).data(30 downto 30)));
    input_1_V(95 downto 80) <= to_tx(to_integer(to_unsigned(Feature_disk5*Multiplier,16))); 

    Feature_InvR <= to_integer(unsigned(LinksIn(2).data(15 downto 0)));
    input_1_V(79 downto 64) <= to_tx(to_integer(to_unsigned(Feature_InvR*1,16))); 

    Feature_Tanl <= to_integer(unsigned(LinksIn(2).data(31 downto 16)));
    input_1_V(63 downto 48) <= to_tx(to_integer(to_unsigned(Feature_Tanl*1,16))); 

    Feature_Z0 <= to_integer(unsigned(LinksIn(2).data(47 downto 32)));
    input_1_V(47 downto 32) <= to_tx(to_integer(to_unsigned(Feature_Z0*1,16))); 

    Feature_nlayer <= to_integer(unsigned(LinksIn(2).data(50 downto 48)));
    input_1_V(31 downto 16) <= to_tx(to_integer(to_unsigned(Feature_nlayer*Multiplier,16))); 

    Feature_ndisk <= to_integer(unsigned(LinksIn(2).data(53 downto 51)));
    input_1_V(15 downto 0) <= to_tx(to_integer(to_unsigned(Feature_ndisk*Multiplier,16))); 

    temp_v <= to_boolean(LinksIn(0).valid);
    input_1_V_ap_vld <= temp_v;
  end if;

end process;

end architecture rtl;
