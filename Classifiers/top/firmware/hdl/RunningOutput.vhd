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

entity RunningOutput is
  port(
    clk    : in std_logic;
    y : in tyArray(nClasses - 1 downto 0) := (others => to_ty(0));
    v : in boolean := false;
    LinksOut : out ldata(N_REGION - 1 downto 0) := ( others => LWORD_NULL )
  );
end RunningOutput;
-- -------------------------------------------------------------------------
-- -------------------------------------------------------------------------
architecture rtl of RunningOutput is
  signal Prediction_0 : ty;
  signal dr: ldata(N_REGION * 4 - 1 downto 0);
  signal OutV: std_logic;
  
begin

  Prediction_0 <= y(0);
  dr(0).data(63 downto 0) <= std_logic_vector(unsigned(prediction_0));


  OutV <= '1' when v else '0';
  dr(0).valid <= OutV;
  LinksOut(0) <= dr(0);

end architecture rtl;
