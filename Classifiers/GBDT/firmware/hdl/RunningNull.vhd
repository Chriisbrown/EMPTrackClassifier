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
    y : out tyArray(0 to nClasses-1) := (others => to_ty(0));            -- output score
    y_vld : out boolArray(0 to nClasses-1) := (others => false) -- output valid
  );
end RunningNull;

architecture rtl of RunningNull is
    signal Prediction_0 : integer;
begin
    process(clk)
        begin 
        if rising_edge(clk) then

            Prediction_0 <= (to_integer(X(0)) + to_integer(X(1)) + to_integer(X(2)) + to_integer(X(3))
                           + to_integer(X(4)) + to_integer(X(5)) + to_integer(X(6)) + to_integer(X(7))
                           + to_integer(X(8)) + to_integer(X(9)) + to_integer(X(10)) + to_integer(X(11))
                           + to_integer(X(12)) + to_integer(X(13)) + to_integer(X(14)) + to_integer(X(15))
                           + to_integer(X(16)) + to_integer(X(17)) + to_integer(X(19)) + to_integer(X(18)) + to_integer(X(10)));

            y(0) <= to_ty(Prediction_0);

            
            
        end if; 
            
        end process;

end rtl;