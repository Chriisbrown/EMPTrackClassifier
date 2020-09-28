LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.math_real.all;


use work.ipbus.all;
use work.emp_data_types.all;
use work.emp_project_decl.all;

use work.emp_device_decl.all;
use work.emp_ttc_decl.all;

use work.Constants.all;
use work.Types.all;


entity NNFeatureTransform is
    port(
      ap_clk    : in std_logic;
      input_1_V_ap_vld : out STD_LOGIC;
      input_1_V : out STD_LOGIC_VECTOR (NN_bit_width*nFeatures -1 downto 0);
      LinksIn : in ldata(4 * N_REGION - 1 downto 0) := ( others => LWORD_NULL );
      ap_start: out std_logic
    );
  end NNFeatureTransform;

architecture rtl of NNFeatureTransform is
    signal tw_qR   : integer;
    signal tw_phi  : integer;
    signal tw_tanL : integer;
    signal tw_z0   : integer;
    signal tw_d0   : integer;
    signal tw_bendchi : integer;

    signal tw_chirz   : integer;
    signal tw_chirphi : integer;
    signal tw_valid1 : std_logic;
    signal tw_valid2 : std_logic;


    
  begin
    process(ap_clk)
  begin
    if rising_edge(ap_clk) then

      tw_qr   <= to_integer(signed(LinksIn(0).data(14 downto 0)));
      tw_phi  <= to_integer(signed(LinksIn(0).data(26 downto 15)));
      tw_tanL <= to_integer(signed(LinksIn(0).data(42 downto 27)));
      tw_z0   <= to_integer(signed(LinksIn(0).data(54 downto 43)));

      tw_d0      <= to_integer(signed(LinksIn(1).data(12 downto 0)));
     
      tw_bendchi <= to_integer(signed(LinksIn(1).data(24 downto 13)));
      tw_hitmask <= LinksIn(1).data(31 downto 25);
      tw_chirz   <= to_integer(signed(LinksIn(1).data(43 downto 32)));
      tw_chirphi <= to_integer(signed(LinksIn(1).data(55 downto 44)));

      tw_valid1 <= LinksIn(0).valid;
      tw_valid2 <= LinksIn(1).valid;

      if (tw_tanL >= -161 and tw_tanL < -20) then
        Feature_layer1  <= to_integer(unsigned(LinksIn(1).data(25 downto 25)));
        Feature_layer2  <= to_integer(unsigned(LinksIn(1).data(26 downto 26)));
        Feature_layer3  <= to_integer(unsigned(LinksIn(1).data(27 downto 27)));
        Feature_layer4  <= to_integer(unsigned(LinksIn(1).data(28 downto 28)));
        Feature_layer5  <= to_integer(unsigned(LinksIn(1).data(29 downto 29)));
        Feature_layer6  <= to_integer(unsigned(LinksIn(1).data(30 downto 30)));
        Feature_disk1  <= 0;
        Feature_disk2  <= 0;
        Feature_disk3  <= 0;
        Feature_disk4  <= 0;
        Feature_disk5  <= 0;

      elsif (tw_tanL >= -20 and tw_tanL < 64) then
        Feature_layer1  <= to_integer(unsigned(LinksIn(1).data(25 downto 25)));
        Feature_layer2  <= to_integer(unsigned(LinksIn(1).data(26 downto 26)));
        Feature_layer3  <= to_integer(unsigned(LinksIn(1).data(27 downto 27)));
        Feature_layer4  <= 0;
        Feature_layer5  <= 0;
        Feature_layer6  <= 0;
        Feature_disk1  <= to_integer(unsigned(LinksIn(1).data(28 downto 28)));
        Feature_disk2  <= to_integer(unsigned(LinksIn(1).data(29 downto 29)));
        Feature_disk3  <= to_integer(unsigned(LinksIn(1).data(30 downto 30)));
        Feature_disk4  <= to_integer(unsigned(LinksIn(1).data(31 downto 31)));
        Feature_disk5  <= 0;

      elsif (tw_tanL >= 64 and tw_tanL < 181) then
        Feature_layer1  <= to_integer(unsigned(LinksIn(1).data(25 downto 25)));
        Feature_layer2  <= to_integer(unsigned(LinksIn(1).data(26 downto 26)));
        Feature_layer3  <= 0;
        Feature_layer4  <=0;
        Feature_layer5  <=0;
        Feature_layer6  <=0;
        Feature_disk1  <= 0;
        Feature_disk2  <= to_integer(unsigned(LinksIn(1).data(27 downto 27)));
        Feature_disk3  <= to_integer(unsigned(LinksIn(1).data(28 downto 28)));
        Feature_disk4  <= to_integer(unsigned(LinksIn(1).data(29 downto 29)));
        Feature_disk5  <= to_integer(unsigned(LinksIn(1).data(30 downto 30))));

      elsif (tw_tanL >= 181 and tw_tanL < 365) then
        Feature_layer1  <= to_integer(unsigned(LinksIn(1).data(25 downto 25)));
        Feature_layer2  <= 0;
        Feature_layer3  <= 0;
        Feature_layer4  <= 0;
        Feature_layer5  <= 0;
        Feature_layer6  <= 0;
        Feature_disk1  <= to_integer(unsigned(LinksIn(1).data(26 downto 26)));
        Feature_disk2  <= to_integer(unsigned(LinksIn(1).data(27 downto 27)));
        Feature_disk3  <= to_integer(unsigned(LinksIn(1).data(28 downto 28)));
        Feature_disk4  <= to_integer(unsigned(LinksIn(1).data(29 downto 29)));
        Feature_disk5  <= to_integer(unsigned(LinksIn(1).data(30 downto 30)));
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
  
      input_1_V(0*NN_bit_width + NN_bit_width-1 downto 0*NN_bit_width) <= std_logic_vector(to_signed((tw_chirz+tw_chirhpi),NN_bit_width));
      input_1_V(1*NN_bit_width + NN_bit_width-1 downto 1*NN_bit_width) <= std_logic_vector(to_signed(tw_bendchi,NN_bit_width));
      input_1_V(2*NN_bit_width + NN_bit_width-1 downto 2*NN_bit_width) <= std_logic_vector(to_signed(tw_chirhpi,NN_bit_width)); 
  
      input_1_V(3*NN_bit_width + NN_bit_width-1 downto 3*NN_bit_width) <= std_logic_vector(to_signed(tw_chirz,NN_bit_width));
      input_1_V(4*NN_bit_width + NN_bit_width-1 downto 4*NN_bit_width) <= std_logic_vector(to_unsigned((Feature_layer1 +  Feature_layer2 +  Feature_layer3  
                                                                                                   +  Feature_layer4 +  Feature_layer5 +  Feature_layer6
                                                                                                   +  Feature_disk1  +  Feature_disk2  +  Feature_disk3  
                                                                                                   +  Feature_disk4  +  Feature_disk5 )*feature_integer_multiplier,
                                                                                                     NN_bit_width));
  
      input_1_V(5*NN_bit_width + NN_bit_width-1 downto 5*NN_bit_width) <= std_logic_vector(to_unsigned(Feature_layer1*feature_integer_multiplier,NN_bit_width)); 
      input_1_V(6*NN_bit_width + NN_bit_width-1 downto 6*NN_bit_width) <= std_logic_vector(to_unsigned(Feature_layer2*feature_integer_multiplier,NN_bit_width)); 
      input_1_V(7*NN_bit_width + NN_bit_width-1 downto 7*NN_bit_width) <= std_logic_vector(to_unsigned(Feature_layer3*feature_integer_multiplier,NN_bit_width)); 
   
      input_1_V(8*NN_bit_width + NN_bit_width-1 downto 8*NN_bit_width) <= std_logic_vector(to_unsigned(Feature_layer4*feature_integer_multiplier,NN_bit_width)); 
      input_1_V(9*NN_bit_width + NN_bit_width-1 downto 9*NN_bit_width) <= std_logic_vector(to_unsigned(Feature_layer5*feature_integer_multiplier,NN_bit_width));
      input_1_V(10*NN_bit_width + NN_bit_width-1 downto 10*NN_bit_width) <= std_logic_vector(to_unsigned(Feature_layer6*feature_integer_multiplier,NN_bit_width));
  
      input_1_V(11*NN_bit_width + NN_bit_width-1 downto 11*NN_bit_width) <= std_logic_vector(to_unsigned(Feature_disk1*feature_integer_multiplier,NN_bit_width)); 
      input_1_V(12*NN_bit_width + NN_bit_width-1 downto 12*NN_bit_width) <= std_logic_vector(to_unsigned(Feature_disk2*feature_integer_multiplier,NN_bit_width)); 
      input_1_V(13*NN_bit_width + NN_bit_width-1 downto 13*NN_bit_width) <= std_logic_vector(to_unsigned(Feature_disk3*feature_integer_multiplier,NN_bit_width));
  
      input_1_V(14*NN_bit_width + NN_bit_width-1 downto 14*NN_bit_width) <= std_logic_vector(to_unsigned(Feature_disk4*feature_integer_multiplier,NN_bit_width)); 
      input_1_V(15*NN_bit_width + NN_bit_width-1 downto 15*NN_bit_width) <= std_logic_vector(to_unsigned(Feature_disk5*feature_integer_multiplier,NN_bit_width)); 

      input_1_V(16*NN_bit_width + NN_bit_width-1 downto 16*NN_bit_width) <= std_logic_vector(to_signed(tw_qR,NN_bit_width));
      
      input_1_V(17*NN_bit_width + NN_bit_width-1 downto 17*NN_bit_width) <= std_logic_vector(to_signed(tw_tanL,NN_bit_width)); 
      input_1_V(18*NN_bit_width + NN_bit_width-1 downto 18*NN_bit_width) <= std_logic_vector(to_signed(tw_z0,NN_bit_width)); 
      input_1_V(19*NN_bit_width + NN_bit_width-1 downto 19*NN_bit_width) <= std_logic_vector(to_unsigned((Feature_disk1 +  Feature_disk2 +  Feature_disk3  
                                                                                                     +  Feature_disk4  +  Feature_disk5)*feature_integer_multiplier,
                                                                                                        NN_bit_width));
      input_1_V(20*NN_bit_width + NN_bit_width-1 downto 20*NN_bit_width) <= std_logic_vector(to_unsigned((Feature_layer1 +  Feature_layer2 +  Feature_layer3 
                                                                                                     +  Feature_layer4 +  Feature_layer5 +  Feature_layer6)*feature_integer_multiplier,
                                                                                                        NN_bit_width));
      
      if (tw_valid1 = '1' and tw_valid2 =  '1') then
        input_1_V_ap_vld <= '1';
      else
        input_1_V_ap_vld <= '0';
      end if;

      ap_start <= '1';
      
    end if;
  
  end process;
  
  end architecture rtl;