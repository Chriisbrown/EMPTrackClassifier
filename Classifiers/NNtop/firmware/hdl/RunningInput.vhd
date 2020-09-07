LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


use work.ipbus.all;
use work.emp_data_types.all;
use work.emp_project_decl.all;

use work.emp_device_decl.all;
use work.emp_ttc_decl.all;


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

begin
  process(ap_clk)
begin
  if rising_edge(ap_clk) then


    input_1_V(335 downto 320) <= LinksIn(0).data(15 downto 0);
    input_1_V(319 downto 304) <= LinksIn(0).data(31 downto 16);
    input_1_V(303 downto 288) <= LinksIn(0).data(47 downto 32); 

    input_1_V(287 downto 272) <= LinksIn(1).data(15 downto 0);
    input_1_V(271 downto 256) <= LinksIn(1).data(31 downto 16);
    input_1_V(255 downto 240) <= LinksIn(1).data(47 downto 32);

    input_1_V(239 downto 224) <= LinksIn(2).data(15 downto 0); 
    input_1_V(223 downto 208) <= LinksIn(2).data(31 downto 16); 
    input_1_V(207 downto 192) <= LinksIn(2).data(47 downto 32); 
 
    input_1_V(191 downto 176) <= LinksIn(3).data(15 downto 0); 
    input_1_V(175 downto 160) <= LinksIn(3).data(31 downto 16);
    input_1_V(159 downto 144) <= LinksIn(3).data(47 downto 32);

    input_1_V(143 downto 128) <= LinksIn(4).data(15 downto 0); 
    input_1_V(127 downto 112) <= LinksIn(4).data(31 downto 16); 
    input_1_V(111 downto 96)  <= LinksIn(4).data(47 downto 32);

    input_1_V(95 downto 80) <= LinksIn(5).data(15 downto 0); 
    input_1_V(79 downto 64) <= LinksIn(5).data(31 downto 16);  
    input_1_V(63 downto 48) <= LinksIn(5).data(47 downto 32);

    
    input_1_V(47 downto 32) <= LinksIn(6).data(15 downto 0); 
    input_1_V(31 downto 16) <= LinksIn(6).data(31 downto 16); 
    input_1_V(15 downto 0)  <= LinksIn(6).data(47 downto 32); 

    input_1_V_ap_vld <= LinksIn(0).valid;
  end if;

end process;

end architecture rtl;
