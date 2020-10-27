-- ==============================================================
-- RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
-- Version: 2018.2
-- Copyright (C) 1986-2018 Xilinx, Inc. All Rights Reserved.
-- 
-- ===========================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity product is
port (
    ap_clk : IN STD_LOGIC;
    ap_rst : IN STD_LOGIC;
    a_V : IN STD_LOGIC_VECTOR (16 downto 0);
    w_V : IN STD_LOGIC_VECTOR (8 downto 0);
    ap_return : OUT STD_LOGIC_VECTOR (16 downto 0);
    ap_ce : IN STD_LOGIC );
end;


architecture behav of product is 
    constant ap_const_logic_1 : STD_LOGIC := '1';
    constant ap_const_logic_0 : STD_LOGIC := '0';
    constant ap_const_boolean_1 : BOOLEAN := true;
    constant ap_const_boolean_0 : BOOLEAN := false;
    constant ap_const_lv32_1 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000001";
    constant ap_const_lv32_11 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000010001";

    signal ap_block_state1_pp0_stage0_iter0 : BOOLEAN;
    signal ap_block_state2_pp0_stage0_iter1 : BOOLEAN;
    signal ap_block_state3_pp0_stage0_iter2 : BOOLEAN;
    signal ap_block_pp0_stage0_11001 : BOOLEAN;
    signal grp_fu_43_p2 : STD_LOGIC_VECTOR (17 downto 0);
    signal p_Val2_s_reg_59 : STD_LOGIC_VECTOR (17 downto 0);
    signal ap_block_pp0_stage0 : BOOLEAN;
    signal grp_fu_43_p1 : STD_LOGIC_VECTOR (8 downto 0);
    signal grp_fu_43_ce : STD_LOGIC;
    signal a_V_int_reg : STD_LOGIC_VECTOR (16 downto 0);
    signal w_V_int_reg : STD_LOGIC_VECTOR (8 downto 0);
    signal grp_fu_43_p10 : STD_LOGIC_VECTOR (17 downto 0);

    component oldKNN_mul_mul_17dEe IS
    generic (
        ID : INTEGER;
        NUM_STAGE : INTEGER;
        din0_WIDTH : INTEGER;
        din1_WIDTH : INTEGER;
        dout_WIDTH : INTEGER );
    port (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        din0 : IN STD_LOGIC_VECTOR (16 downto 0);
        din1 : IN STD_LOGIC_VECTOR (8 downto 0);
        ce : IN STD_LOGIC;
        dout : OUT STD_LOGIC_VECTOR (17 downto 0) );
    end component;



begin
    oldKNN_mul_mul_17dEe_U106 : component oldKNN_mul_mul_17dEe
    generic map (
        ID => 1,
        NUM_STAGE => 2,
        din0_WIDTH => 17,
        din1_WIDTH => 9,
        dout_WIDTH => 18)
    port map (
        clk => ap_clk,
        reset => ap_rst,
        din0 => a_V_int_reg,
        din1 => grp_fu_43_p1,
        ce => grp_fu_43_ce,
        dout => grp_fu_43_p2);




    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((ap_const_logic_1 = ap_ce)) then
                a_V_int_reg <= a_V;
                w_V_int_reg <= w_V;
            end if;
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((ap_const_boolean_0 = ap_block_pp0_stage0_11001) and (ap_const_logic_1 = ap_ce))) then
                p_Val2_s_reg_59 <= grp_fu_43_p2;
            end if;
        end if;
    end process;
        ap_block_pp0_stage0 <= not((ap_const_boolean_1 = ap_const_boolean_1));
        ap_block_pp0_stage0_11001 <= not((ap_const_boolean_1 = ap_const_boolean_1));
        ap_block_state1_pp0_stage0_iter0 <= not((ap_const_boolean_1 = ap_const_boolean_1));
        ap_block_state2_pp0_stage0_iter1 <= not((ap_const_boolean_1 = ap_const_boolean_1));
        ap_block_state3_pp0_stage0_iter2 <= not((ap_const_boolean_1 = ap_const_boolean_1));
    ap_return <= p_Val2_s_reg_59(17 downto 1);

    grp_fu_43_ce_assign_proc : process(ap_ce, ap_block_pp0_stage0_11001)
    begin
        if (((ap_const_logic_1 = ap_ce) and (ap_const_boolean_0 = ap_block_pp0_stage0_11001))) then 
            grp_fu_43_ce <= ap_const_logic_1;
        else 
            grp_fu_43_ce <= ap_const_logic_0;
        end if; 
    end process;

    grp_fu_43_p1 <= grp_fu_43_p10(9 - 1 downto 0);
    grp_fu_43_p10 <= std_logic_vector(IEEE.numeric_std.resize(unsigned(w_V_int_reg),18));
end behav;
