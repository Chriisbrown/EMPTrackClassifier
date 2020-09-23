LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


use work.ipbus.all;
use work.emp_data_types.all;
use work.emp_project_decl.all;

use work.emp_device_decl.all;
use work.emp_ttc_decl.all;

use work.Constants.all;
use work.Types.all;

entity RunningInput is
  port(
    ap_clk    : in std_logic;
    input_1_V_ap_vld : OUT STD_LOGIC;
    input_1_V : OUT STD_LOGIC_VECTOR (NN_bit_width*nFeatures -1 downto 0);
    feature_vector : in txArray(0 to nFeatures - 1) := (others => to_tx(0));
    feature_v : boolean := false;
    ap_start : out std_logic
  );
end RunningInput;
-- -------------------------------------------------------------------------

-- -------------------------------------------------------------------------
architecture rtl of RunningInput is
  
  function Vector_to_features(x : txArray) return std_logic_vector is
  begin
    signal input_1 : STD_LOGIC_VECTOR (NN_bit_width*nFeatures -1 downto 0);
    vector_loop : for i in 0 to nFeatures-1 generate
    begin
      input_1(i*NN_bit_width + NN_bit_width-1 downto i*NN_bit_width-1) <= std_logic_vector(to_signed(to_integer(x(i)),NN_bit_width));
    end generate;
    return input_1;
  end Vector_to_features;
  

begin
  process(ap_clk)
begin
  if rising_edge(ap_clk) then

    
    input_1_V <= Vector_to_features(feature_vector);
    input_1_V_ap_vld <= to_std_logic(feature_v);
    ap_start <= '1';--LinksIn(0).start;
    
  end if;

end process;

end architecture rtl;
