LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.math_real.all;


use work.ipbus.all;
use work.emp_data_types.all;
use work.emp_project_decl.all;

use work.emp_device_decl.all;
use work.emp_ttc_decl.all;


entity FeatureTransform is
    port(
      ap_clk    : in std_logic;
      feature_vector : out std_logic_vector (251 downto 0);
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
    signal tw_bendchi : integer;
    signal tw_hitmask : std_logic_vector(6 downto 0);
    signal tw_chirz   : integer;
    signal tw_chirphi : integer;


    signal Feature_BendChi: integer;
    signal Feature_ChiRphi: integer;
    signal Feature_ChiRz: integer;

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
     
      tw_bendchi <= to_integer(unsigned(LinksIn(1).data(24 downto 13)));
      tw_hitmask <= LinksIn(1).data(31 downto 25);
      tw_chirz   <= to_integer(unsigned(LinksIn(1).data(43 downto 32)));
      tw_chirphi <= to_integer(unsigned(LinksIn(1).data(55 downto 44)));


      Feature_BendChi <= to_integer(to_unsigned(tw_bendchi,12));
      Feature_ChiRphi <= to_integer(to_unsigned(tw_chirphi*16,12));
      Feature_ChiRz   <= to_integer(to_unsigned(tw_chirz,12));

      Feature_InvR <= to_integer(to_signed(tw_qR,12));
      Feature_Tanl <= to_integer(to_signed(tw_tanL,12));
      Feature_Z0 <= to_integer(to_signed(tw_z0,12));

      if (tw_tanL >= 0 and tw_tanL < 207) then
        Feature_layer1  <= to_integer(unsigned(tw_hitmask(0 downto 0)));
        Feature_layer2  <= to_integer(unsigned(tw_hitmask(1 downto 1)));
        Feature_layer3  <= to_integer(unsigned(tw_hitmask(2 downto 2)));
        Feature_layer4  <= to_integer(unsigned(tw_hitmask(3 downto 3)));
        Feature_layer5  <= to_integer(unsigned(tw_hitmask(4 downto 4)));
        Feature_layer6  <= to_integer(unsigned(tw_hitmask(5 downto 5)));
        Feature_disk1  <= 0;
        Feature_disk2  <= 0;
        Feature_disk3  <= 0;
        Feature_disk4  <= 0;
        Feature_disk5  <= 0;

      elsif (tw_tanL >= 207 and tw_tanL < 331) then
        Feature_layer1  <= to_integer(unsigned(tw_hitmask(0 downto 0)));
        Feature_layer2  <= to_integer(unsigned(tw_hitmask(1 downto 1)));
        Feature_layer3  <= to_integer(unsigned(tw_hitmask(2 downto 2)));
        Feature_layer4  <= 0;
        Feature_layer5  <= 0;
        Feature_layer6  <= 0;
        Feature_disk1  <= to_integer(unsigned(tw_hitmask(3 downto 3)));
        Feature_disk2  <= to_integer(unsigned(tw_hitmask(4 downto 4)));
        Feature_disk3  <= to_integer(unsigned(tw_hitmask(5 downto 5)));
        Feature_disk4  <= to_integer(unsigned(tw_hitmask(6 downto 6)));
        Feature_disk5  <= 0;

      elsif (tw_tanL >= 331 and tw_tanL < 504) then
        Feature_layer1  <= to_integer(unsigned(tw_hitmask(0 downto 0)));
        Feature_layer2  <= to_integer(unsigned(tw_hitmask(1 downto 1)));
        Feature_layer3  <= 0;
        Feature_layer4  <=0;
        Feature_layer5  <=0;
        Feature_layer6  <=0;
        Feature_disk1  <= 0;
        Feature_disk2  <= to_integer(unsigned(tw_hitmask(2 downto 2)));
        Feature_disk3  <= to_integer(unsigned(tw_hitmask(3 downto 3)));
        Feature_disk4  <= to_integer(unsigned(tw_hitmask(4 downto 4)));
        Feature_disk5  <= to_integer(unsigned(tw_hitmask(5 downto 5)));

      elsif (tw_tanL >= 504 and tw_tanL < 774) then
        Feature_layer1  <= to_integer(unsigned(tw_hitmask(0 downto 0)));
        Feature_layer2  <= 0;
        Feature_layer3  <= 0;
        Feature_layer4  <= 0;
        Feature_layer5  <= 0;
        Feature_layer6  <= 0;
        Feature_disk1  <= to_integer(unsigned(tw_hitmask(1 downto 1)));
        Feature_disk2  <= to_integer(unsigned(tw_hitmask(2 downto 2)));
        Feature_disk3  <= to_integer(unsigned(tw_hitmask(3 downto 3)));
        Feature_disk4  <= to_integer(unsigned(tw_hitmask(4 downto 4)));
        Feature_disk5  <= to_integer(unsigned(tw_hitmask(5 downto 5)));
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
  
      feature_vector(11 downto 0)  <= std_logic_vector(to_unsigned(Feature_ChiRz+ Feature_ChiRphi,12));
      feature_vector(23 downto 12) <= std_logic_vector(to_unsigned(Feature_BendChi,12));
      feature_vector(35 downto 24) <= std_logic_vector(to_unsigned(Feature_ChiRphi,12)); 
  
      feature_vector(47 downto 36) <= std_logic_vector(to_unsigned(Feature_ChiRz,12));
      feature_vector(59 downto 48) <= std_logic_vector(to_unsigned((Feature_layer1 +  Feature_layer2 +  Feature_layer3  +  Feature_layer4  +  Feature_layer5  +  Feature_layer6
                                    + Feature_disk1 +  Feature_disk2 +  Feature_disk3  +  Feature_disk4  +  Feature_disk5 )*128,12));
  
      feature_vector(71 downto 60)  <= std_logic_vector(to_unsigned(Feature_layer1*128,12)); 
      feature_vector(83 downto 72)  <= std_logic_vector(to_unsigned(Feature_layer2*128,12)); 
      feature_vector(95 downto 84)  <= std_logic_vector(to_unsigned(Feature_layer3*128,12)); 
   
      feature_vector(107 downto 96)  <= std_logic_vector(to_unsigned(Feature_layer4*128,12)); 
      feature_vector(119 downto 108) <= std_logic_vector(to_unsigned(Feature_layer5*128,12));
      feature_vector(131 downto 120) <= std_logic_vector(to_unsigned(Feature_layer6*128,12));
  
      feature_vector(143 downto 132)  <= std_logic_vector(to_unsigned(Feature_disk1*128,12)); 
      feature_vector(155 downto 144)  <= std_logic_vector(to_unsigned(Feature_disk2*128,12)); 
      feature_vector(167 downto 156)  <= std_logic_vector(to_unsigned(Feature_disk3*128,12));
  
      feature_vector(179 downto 168) <= std_logic_vector(to_unsigned(Feature_disk4*128,12)); 
      feature_vector(191 downto 180) <= std_logic_vector(to_unsigned(Feature_disk5*128,12)); 

      feature_vector(203 downto 192) <= std_logic_vector(to_signed(Feature_InvR,12));
      
      feature_vector(215 downto 204) <= std_logic_vector(to_signed(Feature_Tanl,12)); 
      feature_vector(227 downto 216) <= std_logic_vector(to_signed(Feature_Z0,12)); 
      feature_vector(239 downto 228) <= std_logic_vector(to_unsigned((Feature_disk1 +  Feature_disk2 +  Feature_disk3  +  Feature_disk4  +  Feature_disk5)*128,12));
      feature_vector(251 downto 240) <= std_logic_vector(to_unsigned((Feature_layer1 +  Feature_layer2 +  Feature_layer3  +  Feature_layer4  +  Feature_layer5  +  Feature_layer6)*128,12));
      
      valid <= LinksIn(0).valid;
  
      feature_v <= valid;
     
      
    end if;
  
  end process;
  
  end architecture rtl;