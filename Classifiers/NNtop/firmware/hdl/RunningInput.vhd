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
    input_1_V_ap_vld : OUT STD_LOGIC;
    input_1_V : OUT STD_LOGIC_VECTOR (335 downto 0);
    feature_vector : in std_logic_vector (261 downto 0);
    feature_v : in std_logic;
    ap_start : out std_logic
  );
end RunningInput;
-- -------------------------------------------------------------------------

-- -------------------------------------------------------------------------
architecture rtl of RunningInput is

begin
  process(ap_clk)
begin
  if rising_edge(ap_clk) then

    input_1_V(3 downto 0) <= "0000";
    input_1_V(15 downto 4) <= feature_vector(11 downto 0 );
    input_1_V(19 downto 16) <= "0000";
    input_1_V(31 downto 20) <= feature_vector(23 downto 12);
    input_1_V(35 downto 32) <= "0000";
    input_1_V(47 downto 36) <= feature_vector(35 downto 24);


    input_1_V(51 downto 48) <= "0000";
    input_1_V(63 downto 52) <= feature_vector(47 downto 36);
    input_1_V(67 downto 64) <= "0000";
    input_1_V(79 downto 68) <= feature_vector(59 downto 48);
    input_1_V(83 downto 80) <= "0000";
    input_1_V(95 downto 84) <= feature_vector(71 downto 60);

    input_1_V(99 downto 96) <= "0000";
    input_1_V(111 downto 100) <= feature_vector(83 downto 72);
    input_1_V(115 downto 112) <= "0000"; 
    input_1_V(127 downto 116) <= feature_vector(95 downto 84);
    input_1_V(131 downto 128) <= "0000"; 
    input_1_V(143 downto 132) <= feature_vector(107 downto 96); 
    
    input_1_V(147 downto 144) <= "0000";
    input_1_V(159 downto 148) <= feature_vector(119 downto 108); 
    input_1_V(163 downto 160) <= "0000";
    input_1_V(175 downto 164) <= feature_vector(131 downto 120);
    input_1_V(179 downto 176) <= "0000";
    input_1_V(191 downto 180) <= feature_vector(143 downto 132);

    input_1_V(195 downto 192) <= "0000";
    input_1_V(207 downto 196) <=feature_vector(155 downto 144); 
    input_1_V(211 downto 208) <= "0000";
    input_1_V(223 downto 214) <= feature_vector(167 downto 156); 
    input_1_V(227 downto 224) <= "0000";
    input_1_V(239 downto 228)  <= feature_vector(179 downto 168);

    input_1_V(243 downto 240) <= "0000";
    input_1_V(255 downto 244) <= feature_vector(191 downto 180); 
    input_1_V(259 downto 256) <= "0000";
    input_1_V(271 downto 260) <= feature_vector(203 downto 192); 
    input_1_V(275 downto 272) <= "0000"; 
    input_1_V(287 downto 276) <=feature_vector(215 downto 204);

    
    input_1_V(291 downto 288) <= "0000";
    input_1_V(303 downto 292) <= feature_vector(227 downto 216); 
    input_1_V(307 downto 304) <= "0000";
    input_1_V(319 downto 308) <= feature_vector(239 downto 228); 
    input_1_V(323 downto 320) <= "0000";
    input_1_V(335 downto 323)  <= feature_vector(251 downto 240); 

    input_1_V_ap_vld <= feature_v;
    ap_start <= '1';--LinksIn(0).start;
    
  end if;

end process;

end architecture rtl;
