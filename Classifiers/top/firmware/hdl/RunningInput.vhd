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
  Constant Multiplier: integer:= 128;
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

  signal Feature_nlayer: integer;
  signal Feature_ndisk: integer;

begin
  process(clk)
begin
  if rising_edge(clk) then
    X(20) <= to_tx(to_integer(signed(LinksIn(0).data(11 downto 0))));
    X(19) <= to_tx(to_integer(signed(LinksIn(0).data(23 downto 12))));
    X(18) <= to_tx(to_integer(signed(LinksIn(0).data(35 downto 24))));
    X(17) <= to_tx(to_integer(signed(LinksIn(0).data(47 downto 36))));

    Feature_nstub <= to_integer(unsigned(LinksIn(0).data(50 downto 48))); 
    X(16) <= to_tx(to_integer(to_unsigned(Feature_nstub*Multiplier,12))); 
    
    Feature_layer1 <= to_integer(unsigned(LinksIn(0).data(51 downto 51)));
    X(15) <= to_tx(to_integer(to_unsigned(Feature_layer1*Multiplier,12))); 

    Feature_layer2 <= to_integer(unsigned(LinksIn(0).data(52 downto 52)));
    X(14) <= to_tx(to_integer(to_unsigned(Feature_layer2*Multiplier,12))); 

    Feature_layer3 <= to_integer(unsigned(LinksIn(0).data(53 downto 53)));
    X(13) <= to_tx(to_integer(to_unsigned(Feature_layer3*Multiplier,12)));

    Feature_layer4 <= to_integer(unsigned(LinksIn(0).data(54 downto 54)));
    X(12) <= to_tx(to_integer(to_unsigned(Feature_layer4*Multiplier,12))); 

    Feature_layer5 <= to_integer(unsigned(LinksIn(0).data(55 downto 55)));
    X(11) <= to_tx(to_integer(to_unsigned(Feature_layer5*Multiplier,12))); 

    Feature_layer6 <= to_integer(unsigned(LinksIn(0).data(56 downto 56)));
    X(10) <= to_tx(to_integer(to_unsigned(Feature_layer1*Multiplier,12))); 

    Feature_disk1 <= to_integer(unsigned(LinksIn(1).data(0 downto 0)));
    X(9) <= to_tx(to_integer(to_unsigned(Feature_disk1*Multiplier,12))); 

    Feature_disk2 <= to_integer(unsigned(LinksIn(1).data(1 downto 1)));
    X(8) <= to_tx(to_integer(to_unsigned(Feature_disk2*Multiplier,12))); 

    Feature_disk3 <= to_integer(unsigned(LinksIn(1).data(2 downto 2)));
    X(7) <= to_tx(to_integer(to_unsigned(Feature_disk3*Multiplier,12))); 

    Feature_disk4 <= to_integer(unsigned(LinksIn(1).data(3 downto 3)));
    X(6) <= to_tx(to_integer(to_unsigned(Feature_disk4*Multiplier,12))); 

    Feature_disk5 <= to_integer(unsigned(LinksIn(1).data(4downto 4)));
    X(5) <= to_tx(to_integer(to_unsigned(Feature_disk5*Multiplier,12))); 

    X(4) <= to_tx(to_integer(unsigned(LinksIn(1).data(16 downto 5))));
    X(3) <= to_tx(to_integer(unsigned(LinksIn(1).data(28 downto 17))));
    X(2) <= to_tx(to_integer(unsigned(LinksIn(1).data(40 downto 29))));

    Feature_nlayer <= to_integer(unsigned(LinksIn(1).data(43 downto 41)));
    X(1) <= to_tx(to_integer(to_unsigned(Feature_nlayer*Multiplier,12))); 

    Feature_ndisk <= to_integer(unsigned(LinksIn(1).data(46 downto 44)));
    X(0) <= to_tx(to_integer(to_unsigned(Feature_ndisk*Multiplier,12))); 

  end if;

end process;
  v <= true when LinksIn(0).valid = '1' else false;
end architecture rtl;
