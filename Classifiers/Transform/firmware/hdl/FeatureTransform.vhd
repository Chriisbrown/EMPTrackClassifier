LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.math_real.all


use work.ipbus.all;
use work.emp_data_types.all;
use work.emp_project_decl.all;

use work.emp_device_decl.all;
use work.emp_ttc_decl.all;


entity FeatureTransform is
    port(
      ap_clk    : in std_logic;
      feature_vector : out std_logic_vector (261 downto 0);
      feature_v : out std_logic;
      LinksIn : in ldata(4 * N_REGION - 1 downto 0) := ( others => LWORD_NULL )
    );
  end FeatureTransform;

architecture rtl of FeatureTransform is
    signal tw_qR   : integer;
    signal tw_phi  : integer;
    signal tw_tanL : integer;
    signal tw_z0   : integer;
    signal tw_d0   : integer;
    signal tw_chi     : integer;
    signal tw_bendchi : integer;
    signal tw_hitmask : std_logic_vector(6 downto 0);
    signal tw_chirz   : integer;
    signal tw_chirphi : integer;


    signal Feature_LogChi: integer;
    signal Feature_LogBendChi: integer;
    signal Feature_LogChiRphi: integer;
    signal Feature_LogChiRz: integer;

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

    signal valid: std_logic;
    

    
  begin
    process(ap_clk)
  begin
    if rising_edge(ap_clk) then

      tw_qr   <= to_integer(signed(LinksIn(0).data(14 downto 0)));
      tw_phi  <= to_integer(signed(LinksIn(0).data(26 downto 15)));
      tw_tanL <= to_integer(signed(LinksIn(0).data(42 downto 27)));
      tw_z0   <= to_integer(signed(LinksIn(0).data(55 downto 43)));

      tw_d0      <= to_integer(signed(LinksIn(1).data(12 downto 0)));
      tw_chi     <= to_integer(unsigned(LinksIn(1).data(16 downto 13)));
      tw_bendchi <= to_integer(unsigned(LinksIn(1).data(19 downto 17)));
      tw_hitmask <= LinksIn(1).data(26 downto 20);
      tw_chirz   <= to_integer(unsigned(LinksIn(1).data(30 downto 27)));
      tw_chirphi <= to_integer(unsigned(LinksIn(1).data(34 downto 31)));

      Feature_LogChi     <= to_integer(to_signed(log(tw_chi),12));
      Feature_LogBendChi <= to_integer(to_signed(log(tw_bendchi),12));
      Feature_LogChiRphi <= to_integer(to_signed(log(tw_chirz),12));
      Feature_LogChiRz   <= to_integer(to_signed(log(tw_chirphi),12));

      Feature_InvR <= to_integer(to_unsigned(tw_qR,12));
      Feature_Tanl <= to_integer(to_unsigned(tw_tanL,12));
      Feature_Z0 <= to_integer(to_unsigned(tw_z0,12));

      if (tw_tanL >= 0 and tw_tanL < 102016) then
        Feature_layer1  <= to_integer(to_unsigned(tw_hitmask(0)*Multiplier,12));
        Feature_layer2  <= to_integer(to_unsigned(tw_hitmask(1)*Multiplier,12));
        Feature_layer3  <= to_integer(to_unsigned(tw_hitmask(2)*Multiplier,12));
        Feature_layer4  <= to_integer(to_unsigned(tw_hitmask(3)*Multiplier,12));
        Feature_layer5  <= to_integer(to_unsigned(tw_hitmask(4)*Multiplier,12));
        Feature_layer6  <= to_integer(to_unsigned(tw_hitmask(5)*Multiplier,12));
        Feature_disk1  <= 0;
        Feature_disk2  <= 0;
        Feature_disk3  <= 0;
        Feature_disk4  <= 0;
        Feature_disk5  <= 0;

      elsif (tw_tanL >= 102016 and tw_tanL < -298869) then
        Feature_layer1  <= to_integer(to_unsigned(tw_hitmask(0)*Multiplier,12));
        Feature_layer2  <= to_integer(to_unsigned(tw_hitmask(1)*Multiplier,12));
        Feature_layer3  <= to_integer(to_unsigned(tw_hitmask(2)*Multiplier,12));
        Feature_layer4  <= 0;
        Feature_layer5  <= 0;
        Feature_layer6  <= 0;
        Feature_disk1  <= to_integer(to_unsigned(tw_hitmask(3)*Multiplier,12));
        Feature_disk2  <= to_integer(to_unsigned(tw_hitmask(4)*Multiplier,12));
        Feature_disk3  <= to_integer(to_unsigned(tw_hitmask(5)*Multiplier,12));
        Feature_disk4  <= to_integer(to_unsigned(tw_hitmask(6)*Multiplier,12));
        Feature_disk5  <= 0;

      elsif (tw_tanL >= -298869 and tw_tanL < -58691) then
        Feature_layer1  <= to_integer(to_unsigned(tw_hitmask(0)*Multiplier,12));
        Feature_layer2  <= to_integer(to_unsigned(tw_hitmask(1)*Multiplier,12));
        Feature_layer3  <= 0;
        Feature_layer4  <= 0;
        Feature_layer5  <= 0;
        Feature_layer6  <= 0;
        Feature_disk1  <= to_integer(to_unsigned(tw_hitmask(2)*Multiplier,12));
        Feature_disk2  <= to_integer(to_unsigned(tw_hitmask(3)*Multiplier,12));
        Feature_disk3  <= to_integer(to_unsigned(tw_hitmask(4)*Multiplier,12));
        Feature_disk4  <= to_integer(to_unsigned(tw_hitmask(5)*Multiplier,12));
        Feature_disk5  <= 0;

      elsif (tw_tanL >= -58691 and tw_tanL < -30016) then
        Feature_layer1  <= to_integer(to_unsigned(tw_hitmask(0)*Multiplier,12));
        Feature_layer2  <= to_integer(to_unsigned(tw_hitmask(1)*Multiplier,12));
        Feature_layer3  <= 0;
        Feature_layer4  <= 0;
        Feature_layer5  <= 0;
        Feature_layer6  <= 0;
        Feature_disk1  <= to_integer(to_unsigned(tw_hitmask(2)*Multiplier,12));
        Feature_disk2  <= to_integer(to_unsigned(tw_hitmask(3)*Multiplier,12));
        Feature_disk3  <= to_integer(to_unsigned(tw_hitmask(4)*Multiplier,12));
        Feature_disk4  <= to_integer(to_unsigned(tw_hitmask(5)*Multiplier,12));
        Feature_disk5  <= 0;
      else
        Feature_layer1  <= 0;
        Feature_layer2  <= 0;
        Feature_layer3  <= 0;
        Feature_layer4  <= 0;
        Feature_layer5  <= 0;
        Feature_layer6  <= 0;
        Feature_disk1  <= 0;
        Feature_disk2  <= 0;
        Feature_disk3  <= 0;
        Feature_disk4  <= 0;
        Feature_disk5  <= 0;
          
      end if;
  
      feature_vector(11 downto 0)  <= Feature_LogChi;
      feature_vector(23 downto 12) <= Feature_LogBendChi;
      feature_vector(35 downto 24) <= Feature_LogChiRphi; 
  
      feature_vector(47 downto 36) <= Feature_LogChiRz;
      feature_vector(59 downto 48) <= Feature_layer1 +  Feature_layer2 +  Feature_layer3  +  Feature_layer4  +  Feature_layer5  +  Feature_layer6
                                    + Feature_disk1 +  Feature_disk2 +  Feature_disk3  +  Feature_disk4  +  Feature_disk5  +  Feature_disk6
  
      feature_vector(71 downto 60)  <= Feature_layer1; 
      feature_vector(83 downto 72)  <= Feature_layer2; 
      feature_vector(95 downto 84)  <= Feature_layer3; 
   
      feature_vector(107 downto 96)  <= Feature_layer4; 
      feature_vector(119 downto 108) <= Feature_layer5;
      feature_vector(131 downto 120) <= Feature_layer6;
  
      feature_vector(143 downto 132)  <= Feature_disk1; 
      feature_vector(155 downto 144)  <= Feature_disk2; 
      feature_vector(167 downto 156)  <= Feature_disk3;
  
      feature_vector(179 downto 168) <= Feature_disk4; 
      feature_vector(191 downto 180) <= Feature_disk5;  
      feature_vector(213 downto 202) <= Feature_InvR;
  
      feature_vector(225 downto 214) <= Feature_Tanl; 
      feature_vector(237 downto 226) <= Feature_Z0; 
      feature_vector(249 downto 238) <= Feature_layer1 +  Feature_layer2 +  Feature_layer3  +  Feature_layer4  +  Feature_layer5  +  Feature_layer6;
      feature_vector(261 downto 250) <= Feature_disk1 +  Feature_disk2 +  Feature_disk3  +  Feature_disk4  +  Feature_disk5  +  Feature_disk6;
      
      valid <= LinksIn(0).valid;
  
      feature_v <= valid
     
      
    end if;
  
  end process;
  
  end architecture rtl;