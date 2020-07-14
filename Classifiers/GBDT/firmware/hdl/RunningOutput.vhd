-- #########################################################################
-- #########################################################################
-- ###                                                                   ###
-- ###   Use of this code, whether in its current form or modified,      ###
-- ###   implies that you consent to the terms and conditions, namely:   ###
-- ###    - You acknowledge my contribution                              ###
-- ###    - This copyright notification remains intact                   ###
-- ###                                                                   ###
-- ###   Many thanks,                                                    ###
-- ###     Dr. Andrew W. Rose, Imperial College London, 2018             ###
-- ###                                                                   ###
-- #########################################################################
-- #########################################################################

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

library BDT;
use BDT.Types.all;
use BDT.Constants.all;

entity RunningOutput is
  port(
    clk    : in std_logic;
    y : in tyArray(nClasses - 1 downto 0) := (others => to_ty(0));
    v : in boolean := false;
    LinksOut : out ldata(4 * N_REGION - 1 downto 0) := ( others => LWORD_NULL );
  );
end RunningOutput;
-- -------------------------------------------------------------------------
-- -------------------------------------------------------------------------
architecture rtl of RunningOutput is
begin
-- pragma synthesis_off
  process(clk)
  begin
  if rising_edge(clk) then
    if v then
      for i in  y'range loop
        LinksOut(i) <= to_integer(y(i))
      end loop;
    end if;
  end if;
  end process;
-- pragma synthesis_on    
end architecture rtl;
