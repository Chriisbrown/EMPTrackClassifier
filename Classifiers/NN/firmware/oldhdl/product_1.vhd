-- ==============================================================
-- RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
-- Version: 2018.2
-- Copyright (C) 1986-2018 Xilinx, Inc. All Rights Reserved.
-- 
-- ===========================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity product_1 is
port (
    ap_clk : IN STD_LOGIC;
    ap_rst : IN STD_LOGIC;
    a_V : IN STD_LOGIC_VECTOR (14 downto 0);
    w_V : IN STD_LOGIC_VECTOR (12 downto 0);
    ap_return : OUT STD_LOGIC_VECTOR (13 downto 0);
    ap_ce : IN STD_LOGIC );
end;


architecture behav of product_1 is 
    constant ap_const_logic_1 : STD_LOGIC := '1';
    constant ap_const_boolean_1 : BOOLEAN := true;
    constant ap_const_boolean_0 : BOOLEAN := false;
    constant ap_const_lv32_E : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000001110";
    constant ap_const_lv32_1B : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000011011";
    constant ap_const_logic_0 : STD_LOGIC := '0';

    signal p_Val2_s_fu_43_p2 : STD_LOGIC_VECTOR (27 downto 0);
    signal p_Val2_s_reg_49 : STD_LOGIC_VECTOR (27 downto 0);
    signal ap_block_state1_pp0_stage0_iter0 : BOOLEAN;
    signal ap_block_state2_pp0_stage0_iter1 : BOOLEAN;
    signal ap_block_pp0_stage0_11001 : BOOLEAN;
    signal ap_block_pp0_stage0 : BOOLEAN;

    component myproject_mul_mulcud IS
    generic (
        ID : INTEGER;
        NUM_STAGE : INTEGER;
        din0_WIDTH : INTEGER;
        din1_WIDTH : INTEGER;
        dout_WIDTH : INTEGER );
    port (
        din0 : IN STD_LOGIC_VECTOR (14 downto 0);
        din1 : IN STD_LOGIC_VECTOR (12 downto 0);
        dout : OUT STD_LOGIC_VECTOR (27 downto 0) );
    end component;



begin
    myproject_mul_mulcud_U27 : component myproject_mul_mulcud
    generic map (
        ID => 1,
        NUM_STAGE => 1,
        din0_WIDTH => 15,
        din1_WIDTH => 13,
        dout_WIDTH => 28)
    port map (
        din0 => a_V,
        din1 => w_V,
        dout => p_Val2_s_fu_43_p2);




    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((ap_const_boolean_0 = ap_block_pp0_stage0_11001) and (ap_const_logic_1 = ap_ce))) then
                p_Val2_s_reg_49 <= p_Val2_s_fu_43_p2;
            end if;
        end if;
    end process;
        ap_block_pp0_stage0 <= not((ap_const_boolean_1 = ap_const_boolean_1));
        ap_block_pp0_stage0_11001 <= not((ap_const_boolean_1 = ap_const_boolean_1));
        ap_block_state1_pp0_stage0_iter0 <= not((ap_const_boolean_1 = ap_const_boolean_1));
        ap_block_state2_pp0_stage0_iter1 <= not((ap_const_boolean_1 = ap_const_boolean_1));
    ap_return <= p_Val2_s_reg_49(27 downto 14);
end behav;
