library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;


use work.Constants.all;
use work.Types.all;


entity RunningNull is
  port(
    ap_clk : IN STD_LOGIC;
    ap_rst : IN STD_LOGIC;
    ap_start : IN STD_LOGIC;
    ap_done : OUT STD_LOGIC;
    ap_idle : OUT STD_LOGIC;
    ap_ready : OUT STD_LOGIC;
    input_1_V_ap_vld : IN STD_LOGIC;
    input_1_V : IN STD_LOGIC_VECTOR (NN_bit_width*nFeatures -1 downto 0);
    layer13_out_0_V : OUT STD_LOGIC_VECTOR (NN_bit_width -1 downto 0);
    layer13_out_0_V_ap_vld : OUT STD_LOGIC;
    const_size_in_1 : OUT STD_LOGIC_VECTOR (NN_bit_width -1 downto 0);
    const_size_in_1_ap_vld : OUT STD_LOGIC;
    const_size_out_1 : OUT STD_LOGIC_VECTOR (NN_bit_width -1 downto 0);
    const_size_out_1_ap_vld : OUT STD_LOGIC );
end RunningNull;

architecture rtl of RunningNull is
  constant feature_number : integer := 16;
begin
    process(ap_clk)
        begin 
        if rising_edge(ap_clk) then

          layer13_out_0_V <= input_1_V(NN_bit_width*(feature_number+1) -1 downto NN_bit_width*feature_number);
          layer13_out_0_V_ap_vld <= input_1_V_ap_vld;
   
        end if; 
            
        end process;

end rtl;