LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


use work.ipbus.all;
use work.emp_data_types.all;
use work.emp_project_decl.all;

use work.emp_device_decl.all;
use work.emp_ttc_decl.all;

--library GBDT;




entity NNWrapper is
  port (
    ap_clk : in std_logic;
    LinksIn : in ldata(4 * N_REGION - 1 downto 0) := ( others => LWORD_NULL );
    LinksOut : out ldata(4 * N_REGION - 1 downto 0) := ( others => LWORD_NULL )
    
  );
end entity NNWrapper;

architecture rtl of TreeWrapper is
  signal input_1_V_ap_vld : IN STD_LOGIC;
  signal input_1_V : IN STD_LOGIC_VECTOR (335 downto 0);
  signal layer13_out_0_V : OUT STD_LOGIC_VECTOR (15 downto 0);
  signal layer13_out_0_V_ap_vld : OUT STD_LOGIC;
begin

    Input : entity work.RunningInput
    port map(ap_clk, input_1_V, input_1_V_ap_vld,LinksIn);

    UUT : entity work.myproject
    port map(ap_clk,input_1_V,input_1_V_ap_vld,layer13_out_0_V,layer13_out_0_V_ap_vld)

    Output : entity work.RunningOutput
    port map(ap_clk, layer13_out_0_V,layer13_out_0_V_ap_vld,LinksOut);

end architecture rtl;
