library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

--library GBDT;
use work.Constants.all;
use work.Types.all;


entity RunningNull is
  port(
    clk : in std_logic;  -- clock
    X : in txArray(0 to nFeatures-1) := (others => to_tx(0));           -- input features
    X_vld : in boolean := false; -- input valid
    y : out tyArray(0 to 2) := (others => to_ty(0));            -- output score
    y_vld : out boolArray(0 to 2) := (others => false) -- output valid
  );
end RunningNull;

architecture rtl of RunningNull is
  signal temp_v : boolean;

begin
    process(clk)
        begin 
        if rising_edge(clk) then


          y(0) <= to_ty(to_integer(X(0)));
          temp_V <= X_vld;
          y_vld(0) <= temp_V;

          y(1) <= to_ty(to_integer(X(1)));
          temp_V <= X_vld;
          y_vld(1) <= temp_V;

            
            
            
        end if; 
            
        end process;

end rtl;