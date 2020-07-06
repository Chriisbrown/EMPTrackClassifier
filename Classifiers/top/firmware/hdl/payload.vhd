LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


use work.ipbus.all;
use work.emp_data_types.all;
use work.emp_project_decl.all;

use work.emp_device_decl.all;
use work.emp_ttc_decl.all;

library Classifier;
use Classifier.GBDT.all;

ENTITY emp_payload IS
  PORT(
    clk         : IN STD_LOGIC; -- ipbus signals
    rst         : IN STD_LOGIC;
    ipb_in      : IN ipb_wbus;
    ipb_out     : OUT ipb_rbus;
    clk_payload : IN STD_LOGIC_VECTOR( 2 DOWNTO 0 );
    rst_payload : IN STD_LOGIC_VECTOR( 2 DOWNTO 0 );
    clk_p       : IN STD_LOGIC; -- data clock
    rst_loc     : IN STD_LOGIC_VECTOR( N_REGION - 1 DOWNTO 0 );
    clken_loc   : IN STD_LOGIC_VECTOR( N_REGION - 1 DOWNTO 0 );
    ctrs        : IN ttc_stuff_array;
    bc0         : OUT STD_LOGIC;
    d           : IN ldata( 4 * N_REGION - 1 DOWNTO 0 );  -- data in
    q           : OUT ldata( 4 * N_REGION - 1 DOWNTO 0 ); -- data out
    gpio        : OUT STD_LOGIC_VECTOR( 29 DOWNTO 0 );    -- IO to mezzanine connector
    gpio_en     : OUT STD_LOGIC_VECTOR( 29 DOWNTO 0 )     -- IO to mezzanine connector( three-state enables )
  );
END emp_payload;

ARCHITECTURE rtl OF emp_payload IS

    type dr_t is array(PAYLOAD_LATENCY downto 0) of ldata(3 downto 0);

    COMPONENT my_gbdt
      PORT (
        ap_start : IN STD_LOGIC;
        ap_done : OUT STD_LOGIC;
        ap_idle : OUT STD_LOGIC;
        ap_ready : OUT STD_LOGIC;
        ap_return : OUT STD_LOGIC_VECTOR(95 DOWNTO 0);
        a_V : IN STD_LOGIC_VECTOR(2 DOWNTO 0)
      );
    END COMPONENT;

BEGIN

-- ---------------------------------------------------------------------------------
    ipb_out <= IPB_RBUS_NULL;

    gen: for i in N_REGION - 1 downto 0 generate
        constant ich: integer := i * 4 + 3;
        constant icl: integer := i * 4;
        signal dr: dr_t;
        
        attribute SHREG_EXTRACT: string;
        attribute SHREG_EXTRACT of dr: signal is "no"; -- Don't absorb FFs into shreg

    begin

        gen: for j in 3 downto 0 generate

                BDTTop : my_gbdt
                PORT MAP (
                    ap_start => '1',
                    ap_done => open,
                    ap_idle => open,
                    ap_ready => open,
                    ap_return => dr(0)(j).data,
                    a_V => d(icl+j).data
                );
                                            
                dr(0)(j).valid <= d(icl).valid;
                dr(0)(j).start <= d(icl).start;
                dr(0)(j).strobe <= d(icl).strobe;

        end generate;


        process(clk_p) -- Mother of all shift registers
        begin
            if rising_edge(clk_p) then
            
            dr(PAYLOAD_LATENCY downto 1) <= dr(PAYLOAD_LATENCY - 1 downto 0);
            end if;
        end process;

        q(ich downto icl) <= dr(PAYLOAD_LATENCY) ;

        
    end generate;

    bc0 <= '0';

    gpio <= (others => '0');
    gpio_en <= (others => '0');

END rtl;