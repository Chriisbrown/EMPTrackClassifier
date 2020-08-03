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


begin

  process(clk)
begin 
  if rising_edge(clk) then
    X(0) <= to_tx(to_integer(signed(LinksIn(0).data(31 downto 0))));
    X(1) <= to_tx(to_integer(signed(LinksIn(1).data(31 downto 0))));
    X(2) <= to_tx(to_integer(signed(LinksIn(2).data(31 downto 0))));
    X(3) <= to_tx(to_integer(signed(LinksIn(3).data(31 downto 0))));
    X(4) <= to_tx(to_integer(unsigned(LinksIn(4).data(31 downto 0))));
    X(5) <= to_tx(to_integer(unsigned(LinksIn(5).data(31 downto 0))));
    X(6) <= to_tx(to_integer(unsigned(LinksIn(6).data(31 downto 0))));
    X(7) <= to_tx(to_integer(unsigned(LinksIn(7).data(31 downto 0))));
    X(8) <= to_tx(to_integer(unsigned(LinksIn(8).data(31 downto 0))));
    X(9) <= to_tx(to_integer(unsigned(LinksIn(9).data(31 downto 0))));
    X(10) <= to_tx(to_integer(unsigned(LinksIn(10).data(31 downto 0)))); 
    X(11) <= to_tx(to_integer(unsigned(LinksIn(11).data(31 downto 0)))); 
    X(12) <= to_tx(to_integer(unsigned(LinksIn(12).data(31 downto 0)))); 
    X(13) <= to_tx(to_integer(unsigned(LinksIn(13).data(31 downto 0))));  
    X(14) <= to_tx(to_integer(unsigned(LinksIn(14).data(31 downto 0)))); 
    X(15) <= to_tx(to_integer(unsigned(LinksIn(15).data(31 downto 0))));  
    X(16) <= to_tx(to_integer(unsigned(LinksIn(16).data(31 downto 0)))); 
    X(17) <= to_tx(to_integer(unsigned(LinksIn(17).data(31 downto 0)))); 
    X(18) <= to_tx(to_integer(unsigned(LinksIn(18).data(31 downto 0)))); 
    X(19) <= to_tx(to_integer(unsigned(LinksIn(19).data(31 downto 0)))); 
    X(20) <= to_tx(to_integer(unsigned(LinksIn(20).data(31 downto 0))));
    v <= true when LinksIn(0).valid = '1' else false;
  end if;
end process;

end architecture rtl;
