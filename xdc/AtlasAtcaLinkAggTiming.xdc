##############################################################################
## This file is part of 'ATLAS ATCA LINK AGG DEV'.
## It is subject to the license terms in the LICENSE.txt file found in the 
## top-level directory of this distribution and at: 
##    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html. 
## No part of 'ATLAS ATCA LINK AGG DEV', including this file, 
## may be copied, modified, propagated, or distributed except according to 
## the terms contained in the LICENSE.txt file.
##############################################################################

###############
# Common Clocks
###############

create_clock -name baseEthRefClkP -period 1.600 [get_ports { ethRefClkP[0] }]
create_clock -name fpEthRefClkP   -period 1.600 [get_ports { ethRefClkP[1] }]

create_clock -name fabEthRefClkP  -period 6.400 [get_ports { fabEthRefClkP }]

create_clock -name qsfpEthRefClkP -period 6.400 [get_ports { qsfpEthRefClkP }]
create_clock -name qsfpRef160ClkP -period 6.237 [get_ports { qsfpRef160ClkP }]

create_clock -name sfpEthRefClkP  -period 6.400 [get_ports { sfpEthRefClkP }]
create_clock -name sfpRef160ClkP  -period 6.237 [get_ports { sfpRef160ClkP }]

set_clock_groups -asynchronous \
   -group [get_clocks -include_generated_clocks {baseEthRefClkP}] \
   -group [get_clocks -include_generated_clocks {fpEthRefClkP}] \
   -group [get_clocks -include_generated_clocks {fabEthRefClkP}] \
   -group [get_clocks -include_generated_clocks {qsfpEthRefClkP}] \
   -group [get_clocks -include_generated_clocks {qsfpRef160ClkP}] \
   -group [get_clocks -include_generated_clocks {sfpEthRefClkP}] \
   -group [get_clocks -include_generated_clocks {sfpRef160ClkP}]

create_generated_clock -name axilClk   [get_pins {U_Core/U_ClkRst/U_Pll/PllGen.U_Pll/CLKOUT0}] 
create_generated_clock -name eth125Clk [get_pins {U_Core/U_ClkRst/U_Pll/PllGen.U_Pll/CLKOUT1}] 
create_generated_clock -name eth62Clk  [get_pins {U_Core/U_ClkRst/U_eth62Clk/O}] 

set_clock_groups -asynchronous -group [get_clocks {axilClk}] -group [get_clocks {eth125Clk}]
set_clock_groups -asynchronous -group [get_clocks {axilClk}] -group [get_clocks {eth62Clk}]

#########################################################
# Front Panel at 10/100/1000 & BASE ETH[1] at 10/100/1000
#########################################################

create_generated_clock -name baseEthClk0 [get_pins {U_Core/U_Eth/GEN_SGMII[0].EN_ETH/U_Eth/U_1GigE/U_MMCM/CLKOUT0}] 
create_generated_clock -name baseEthClk1 [get_pins {U_Core/U_Eth/GEN_SGMII[0].EN_ETH/U_Eth/U_1GigE/U_MMCM/CLKOUT1}] 
create_generated_clock -name baseEthClk2 [get_pins {U_Core/U_Eth/GEN_SGMII[0].EN_ETH/U_Eth/U_1GigE/U_MMCM/CLKOUT2}] 
create_generated_clock -name baseEthClk3 [get_pins {U_Core/U_Eth/GEN_SGMII[0].EN_ETH/U_Eth/U_1GigE/U_MMCM/CLKOUT3}] 
create_generated_clock -name baseEthClk4 [get_pins {U_Core/U_Eth/GEN_SGMII[0].EN_ETH/U_Eth/U_1GigE/U_MMCM/CLKOUT4}] 

set_clock_groups -physically_exclusive -group [get_clocks {baseEthClk0}] -group [get_clocks {baseEthClk3}] -group [get_clocks {baseEthClk4}]

create_generated_clock -name fpEthClk0 [get_pins {U_Core/U_Eth/GEN_SGMII[1].EN_ETH/U_Eth/U_1GigE/U_MMCM/CLKOUT0}] 
create_generated_clock -name fpEthClk1 [get_pins {U_Core/U_Eth/GEN_SGMII[1].EN_ETH/U_Eth/U_1GigE/U_MMCM/CLKOUT1}] 
create_generated_clock -name fpEthClk2 [get_pins {U_Core/U_Eth/GEN_SGMII[1].EN_ETH/U_Eth/U_1GigE/U_MMCM/CLKOUT2}] 
create_generated_clock -name fpEthClk3 [get_pins {U_Core/U_Eth/GEN_SGMII[1].EN_ETH/U_Eth/U_1GigE/U_MMCM/CLKOUT3}] 
create_generated_clock -name fpEthClk4 [get_pins {U_Core/U_Eth/GEN_SGMII[1].EN_ETH/U_Eth/U_1GigE/U_MMCM/CLKOUT4}] 

set_clock_groups -physically_exclusive -group [get_clocks {fpEthClk0}] -group [get_clocks {fpEthClk3}] -group [get_clocks {fpEthClk4}]

# Relax timing for the refRstCnt counter (clocked at 625MHz but it has a CE at half the rate)
set_multicycle_path -through [get_pins -of_objects [get_cells -hier -filter {NAME =~ U_Core/U_Eth/GEN_SGMII[*].EN_ETH/U_Eth/*refRstCnt_reg*}] -filter {REF_PIN_NAME==Q}] -setup -start 2
set_multicycle_path -through [get_pins -of_objects [get_cells -hier -filter {NAME =~ U_Core/U_Eth/GEN_SGMII[*].EN_ETH/U_Eth/*refRstCnt_reg*}] -filter {REF_PIN_NAME==Q}] -hold  -start 1
set_multicycle_path -through [get_pins -of_objects [get_cells -hier -filter {NAME =~ U_Core/U_Eth/GEN_SGMII[*].EN_ETH/U_Eth/*refRst_reg*}]    -filter {REF_PIN_NAME==Q}] -setup -start 2
set_multicycle_path -through [get_pins -of_objects [get_cells -hier -filter {NAME =~ U_Core/U_Eth/GEN_SGMII[*].EN_ETH/U_Eth/*refRst_reg*}]    -filter {REF_PIN_NAME==Q}] -hold  -start 1   

################################################
# FABRIC ETH[1:4] at 1GbE x 1 Lane (1000BASE-KX)
################################################

create_generated_clock -name fabEth1GbETxClk0 [get_pins {U_Core/U_Eth/GEN_FAB[0].EN_ETH.U_Fab/GEN_ETH_1Gx1.U_Eth/GEN_LANE[0].U_GigEthGthUltraScale/U_GigEthGthUltraScaleCore/U0/transceiver_inst/GigEthGthUltraScaleCore_gt_i/inst/gen_gtwizard_gthe4_top.GigEthGthUltraScaleCore_gt_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_channel_container[0].gen_enabled_channel.gthe4_channel_wrapper_inst/channel_inst/gthe4_channel_gen.gen_gthe4_channel_inst[0].GTHE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_generated_clock -name fabEth1GbETxClk1 [get_pins {U_Core/U_Eth/GEN_FAB[1].EN_ETH.U_Fab/GEN_ETH_1Gx1.U_Eth/GEN_LANE[0].U_GigEthGthUltraScale/U_GigEthGthUltraScaleCore/U0/transceiver_inst/GigEthGthUltraScaleCore_gt_i/inst/gen_gtwizard_gthe4_top.GigEthGthUltraScaleCore_gt_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_channel_container[0].gen_enabled_channel.gthe4_channel_wrapper_inst/channel_inst/gthe4_channel_gen.gen_gthe4_channel_inst[0].GTHE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_generated_clock -name fabEth1GbETxClk2 [get_pins {U_Core/U_Eth/GEN_FAB[2].EN_ETH.U_Fab/GEN_ETH_1Gx1.U_Eth/GEN_LANE[0].U_GigEthGthUltraScale/U_GigEthGthUltraScaleCore/U0/transceiver_inst/GigEthGthUltraScaleCore_gt_i/inst/gen_gtwizard_gthe4_top.GigEthGthUltraScaleCore_gt_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_channel_container[0].gen_enabled_channel.gthe4_channel_wrapper_inst/channel_inst/gthe4_channel_gen.gen_gthe4_channel_inst[0].GTHE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_generated_clock -name fabEth1GbETxClk3 [get_pins {U_Core/U_Eth/GEN_FAB[3].EN_ETH.U_Fab/GEN_ETH_1Gx1.U_Eth/GEN_LANE[0].U_GigEthGthUltraScale/U_GigEthGthUltraScaleCore/U0/transceiver_inst/GigEthGthUltraScaleCore_gt_i/inst/gen_gtwizard_gthe4_top.GigEthGthUltraScaleCore_gt_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_channel_container[0].gen_enabled_channel.gthe4_channel_wrapper_inst/channel_inst/gthe4_channel_gen.gen_gthe4_channel_inst[0].GTHE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_generated_clock -name fabEth1GbERxClk0 [get_pins {U_Core/U_Eth/GEN_FAB[0].EN_ETH.U_Fab/GEN_ETH_1Gx1.U_Eth/GEN_LANE[0].U_GigEthGthUltraScale/U_GigEthGthUltraScaleCore/U0/transceiver_inst/GigEthGthUltraScaleCore_gt_i/inst/gen_gtwizard_gthe4_top.GigEthGthUltraScaleCore_gt_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_channel_container[0].gen_enabled_channel.gthe4_channel_wrapper_inst/channel_inst/gthe4_channel_gen.gen_gthe4_channel_inst[0].GTHE4_CHANNEL_PRIM_INST/RXOUTCLKPCS}]
create_generated_clock -name fabEth1GbERxClk1 [get_pins {U_Core/U_Eth/GEN_FAB[1].EN_ETH.U_Fab/GEN_ETH_1Gx1.U_Eth/GEN_LANE[0].U_GigEthGthUltraScale/U_GigEthGthUltraScaleCore/U0/transceiver_inst/GigEthGthUltraScaleCore_gt_i/inst/gen_gtwizard_gthe4_top.GigEthGthUltraScaleCore_gt_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_channel_container[0].gen_enabled_channel.gthe4_channel_wrapper_inst/channel_inst/gthe4_channel_gen.gen_gthe4_channel_inst[0].GTHE4_CHANNEL_PRIM_INST/RXOUTCLKPCS}]
create_generated_clock -name fabEth1GbERxClk2 [get_pins {U_Core/U_Eth/GEN_FAB[2].EN_ETH.U_Fab/GEN_ETH_1Gx1.U_Eth/GEN_LANE[0].U_GigEthGthUltraScale/U_GigEthGthUltraScaleCore/U0/transceiver_inst/GigEthGthUltraScaleCore_gt_i/inst/gen_gtwizard_gthe4_top.GigEthGthUltraScaleCore_gt_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_channel_container[0].gen_enabled_channel.gthe4_channel_wrapper_inst/channel_inst/gthe4_channel_gen.gen_gthe4_channel_inst[0].GTHE4_CHANNEL_PRIM_INST/RXOUTCLKPCS}]
create_generated_clock -name fabEth1GbERxClk3 [get_pins {U_Core/U_Eth/GEN_FAB[3].EN_ETH.U_Fab/GEN_ETH_1Gx1.U_Eth/GEN_LANE[0].U_GigEthGthUltraScale/U_GigEthGthUltraScaleCore/U0/transceiver_inst/GigEthGthUltraScaleCore_gt_i/inst/gen_gtwizard_gthe4_top.GigEthGthUltraScaleCore_gt_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_channel_container[0].gen_enabled_channel.gthe4_channel_wrapper_inst/channel_inst/gthe4_channel_gen.gen_gthe4_channel_inst[0].GTHE4_CHANNEL_PRIM_INST/RXOUTCLKPCS}]
set_clock_groups -asynchronous -group [get_clocks {eth62Clk}] -group [get_clocks -of_objects [get_pins {U_Core/U_Eth/GEN_FAB[*].EN_ETH.U_Fab/GEN_ETH_1Gx1.U_Eth/GEN_LANE[0].U_GigEthGthUltraScale/U_GigEthGthUltraScaleCore/U0/transceiver_inst/GigEthGthUltraScaleCore_gt_i/inst/gen_gtwizard_gthe4_top.GigEthGthUltraScaleCore_gt_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_channel_container[0].gen_enabled_channel.gthe4_channel_wrapper_inst/channel_inst/gthe4_channel_gen.gen_gthe4_channel_inst[0].GTHE4_CHANNEL_PRIM_INST/TXOUTCLK}]]

###################################################################
# FABRIC ETH[1:4] at 10GbE x 4 Lane (10GBASE-KX4 ... A.K.A. "XAUI")
###################################################################

create_generated_clock -name fabEthXauiTxClk0 [get_pins {U_Core/U_Eth/GEN_FAB[0].EN_ETH.U_Fab/GEN_ETH_10Gx4.U_Eth/XauiGthUltraScale_Inst/U_XauiGthUltraScaleCore/U0/XauiGthUltraScale156p25MHz10GigECore_gt_i/inst/gen_gtwizard_gthe4_top.XauiGthUltraScale156p25MHz10GigECore_gt_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_channel_container[0].gen_enabled_channel.gthe4_channel_wrapper_inst/channel_inst/gthe4_channel_gen.gen_gthe4_channel_inst[0].GTHE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_generated_clock -name fabEthXauiTxClk1 [get_pins {U_Core/U_Eth/GEN_FAB[1].EN_ETH.U_Fab/GEN_ETH_10Gx4.U_Eth/XauiGthUltraScale_Inst/U_XauiGthUltraScaleCore/U0/XauiGthUltraScale156p25MHz10GigECore_gt_i/inst/gen_gtwizard_gthe4_top.XauiGthUltraScale156p25MHz10GigECore_gt_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_channel_container[0].gen_enabled_channel.gthe4_channel_wrapper_inst/channel_inst/gthe4_channel_gen.gen_gthe4_channel_inst[0].GTHE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_generated_clock -name fabEthXauiTxClk2 [get_pins {U_Core/U_Eth/GEN_FAB[2].EN_ETH.U_Fab/GEN_ETH_10Gx4.U_Eth/XauiGthUltraScale_Inst/U_XauiGthUltraScaleCore/U0/XauiGthUltraScale156p25MHz10GigECore_gt_i/inst/gen_gtwizard_gthe4_top.XauiGthUltraScale156p25MHz10GigECore_gt_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_channel_container[0].gen_enabled_channel.gthe4_channel_wrapper_inst/channel_inst/gthe4_channel_gen.gen_gthe4_channel_inst[0].GTHE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_generated_clock -name fabEthXauiTxClk3 [get_pins {U_Core/U_Eth/GEN_FAB[3].EN_ETH.U_Fab/GEN_ETH_10Gx4.U_Eth/XauiGthUltraScale_Inst/U_XauiGthUltraScaleCore/U0/XauiGthUltraScale156p25MHz10GigECore_gt_i/inst/gen_gtwizard_gthe4_top.XauiGthUltraScale156p25MHz10GigECore_gt_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_channel_container[0].gen_enabled_channel.gthe4_channel_wrapper_inst/channel_inst/gthe4_channel_gen.gen_gthe4_channel_inst[0].GTHE4_CHANNEL_PRIM_INST/TXOUTCLK}]

create_generated_clock -name fabEthXauiRxClk0_0 [get_pins {U_Core/U_Eth/GEN_FAB[0].EN_ETH.U_Fab/GEN_ETH_10Gx4.U_Eth/XauiGthUltraScale_Inst/U_XauiGthUltraScaleCore/U0/XauiGthUltraScale156p25MHz10GigECore_gt_i/inst/gen_gtwizard_gthe4_top.XauiGthUltraScale156p25MHz10GigECore_gt_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_channel_container[0].gen_enabled_channel.gthe4_channel_wrapper_inst/channel_inst/gthe4_channel_gen.gen_gthe4_channel_inst[0].GTHE4_CHANNEL_PRIM_INST/RXOUTCLKPCS}]
create_generated_clock -name fabEthXauiRxClk0_1 [get_pins {U_Core/U_Eth/GEN_FAB[0].EN_ETH.U_Fab/GEN_ETH_10Gx4.U_Eth/XauiGthUltraScale_Inst/U_XauiGthUltraScaleCore/U0/XauiGthUltraScale156p25MHz10GigECore_gt_i/inst/gen_gtwizard_gthe4_top.XauiGthUltraScale156p25MHz10GigECore_gt_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_channel_container[0].gen_enabled_channel.gthe4_channel_wrapper_inst/channel_inst/gthe4_channel_gen.gen_gthe4_channel_inst[1].GTHE4_CHANNEL_PRIM_INST/RXOUTCLKPCS}]
create_generated_clock -name fabEthXauiRxClk0_2 [get_pins {U_Core/U_Eth/GEN_FAB[0].EN_ETH.U_Fab/GEN_ETH_10Gx4.U_Eth/XauiGthUltraScale_Inst/U_XauiGthUltraScaleCore/U0/XauiGthUltraScale156p25MHz10GigECore_gt_i/inst/gen_gtwizard_gthe4_top.XauiGthUltraScale156p25MHz10GigECore_gt_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_channel_container[0].gen_enabled_channel.gthe4_channel_wrapper_inst/channel_inst/gthe4_channel_gen.gen_gthe4_channel_inst[2].GTHE4_CHANNEL_PRIM_INST/RXOUTCLKPCS}]
create_generated_clock -name fabEthXauiRxClk0_3 [get_pins {U_Core/U_Eth/GEN_FAB[0].EN_ETH.U_Fab/GEN_ETH_10Gx4.U_Eth/XauiGthUltraScale_Inst/U_XauiGthUltraScaleCore/U0/XauiGthUltraScale156p25MHz10GigECore_gt_i/inst/gen_gtwizard_gthe4_top.XauiGthUltraScale156p25MHz10GigECore_gt_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_channel_container[0].gen_enabled_channel.gthe4_channel_wrapper_inst/channel_inst/gthe4_channel_gen.gen_gthe4_channel_inst[3].GTHE4_CHANNEL_PRIM_INST/RXOUTCLKPCS}]

create_generated_clock -name fabEthXauiRxClk1_0 [get_pins {U_Core/U_Eth/GEN_FAB[1].EN_ETH.U_Fab/GEN_ETH_10Gx4.U_Eth/XauiGthUltraScale_Inst/U_XauiGthUltraScaleCore/U0/XauiGthUltraScale156p25MHz10GigECore_gt_i/inst/gen_gtwizard_gthe4_top.XauiGthUltraScale156p25MHz10GigECore_gt_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_channel_container[0].gen_enabled_channel.gthe4_channel_wrapper_inst/channel_inst/gthe4_channel_gen.gen_gthe4_channel_inst[0].GTHE4_CHANNEL_PRIM_INST/RXOUTCLKPCS}]
create_generated_clock -name fabEthXauiRxClk1_1 [get_pins {U_Core/U_Eth/GEN_FAB[1].EN_ETH.U_Fab/GEN_ETH_10Gx4.U_Eth/XauiGthUltraScale_Inst/U_XauiGthUltraScaleCore/U0/XauiGthUltraScale156p25MHz10GigECore_gt_i/inst/gen_gtwizard_gthe4_top.XauiGthUltraScale156p25MHz10GigECore_gt_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_channel_container[0].gen_enabled_channel.gthe4_channel_wrapper_inst/channel_inst/gthe4_channel_gen.gen_gthe4_channel_inst[1].GTHE4_CHANNEL_PRIM_INST/RXOUTCLKPCS}]
create_generated_clock -name fabEthXauiRxClk1_2 [get_pins {U_Core/U_Eth/GEN_FAB[1].EN_ETH.U_Fab/GEN_ETH_10Gx4.U_Eth/XauiGthUltraScale_Inst/U_XauiGthUltraScaleCore/U0/XauiGthUltraScale156p25MHz10GigECore_gt_i/inst/gen_gtwizard_gthe4_top.XauiGthUltraScale156p25MHz10GigECore_gt_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_channel_container[0].gen_enabled_channel.gthe4_channel_wrapper_inst/channel_inst/gthe4_channel_gen.gen_gthe4_channel_inst[2].GTHE4_CHANNEL_PRIM_INST/RXOUTCLKPCS}]
create_generated_clock -name fabEthXauiRxClk1_3 [get_pins {U_Core/U_Eth/GEN_FAB[1].EN_ETH.U_Fab/GEN_ETH_10Gx4.U_Eth/XauiGthUltraScale_Inst/U_XauiGthUltraScaleCore/U0/XauiGthUltraScale156p25MHz10GigECore_gt_i/inst/gen_gtwizard_gthe4_top.XauiGthUltraScale156p25MHz10GigECore_gt_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_channel_container[0].gen_enabled_channel.gthe4_channel_wrapper_inst/channel_inst/gthe4_channel_gen.gen_gthe4_channel_inst[3].GTHE4_CHANNEL_PRIM_INST/RXOUTCLKPCS}]

create_generated_clock -name fabEthXauiRxClk2_0 [get_pins {U_Core/U_Eth/GEN_FAB[2].EN_ETH.U_Fab/GEN_ETH_10Gx4.U_Eth/XauiGthUltraScale_Inst/U_XauiGthUltraScaleCore/U0/XauiGthUltraScale156p25MHz10GigECore_gt_i/inst/gen_gtwizard_gthe4_top.XauiGthUltraScale156p25MHz10GigECore_gt_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_channel_container[0].gen_enabled_channel.gthe4_channel_wrapper_inst/channel_inst/gthe4_channel_gen.gen_gthe4_channel_inst[0].GTHE4_CHANNEL_PRIM_INST/RXOUTCLKPCS}]
create_generated_clock -name fabEthXauiRxClk2_1 [get_pins {U_Core/U_Eth/GEN_FAB[2].EN_ETH.U_Fab/GEN_ETH_10Gx4.U_Eth/XauiGthUltraScale_Inst/U_XauiGthUltraScaleCore/U0/XauiGthUltraScale156p25MHz10GigECore_gt_i/inst/gen_gtwizard_gthe4_top.XauiGthUltraScale156p25MHz10GigECore_gt_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_channel_container[0].gen_enabled_channel.gthe4_channel_wrapper_inst/channel_inst/gthe4_channel_gen.gen_gthe4_channel_inst[1].GTHE4_CHANNEL_PRIM_INST/RXOUTCLKPCS}]
create_generated_clock -name fabEthXauiRxClk2_2 [get_pins {U_Core/U_Eth/GEN_FAB[2].EN_ETH.U_Fab/GEN_ETH_10Gx4.U_Eth/XauiGthUltraScale_Inst/U_XauiGthUltraScaleCore/U0/XauiGthUltraScale156p25MHz10GigECore_gt_i/inst/gen_gtwizard_gthe4_top.XauiGthUltraScale156p25MHz10GigECore_gt_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_channel_container[0].gen_enabled_channel.gthe4_channel_wrapper_inst/channel_inst/gthe4_channel_gen.gen_gthe4_channel_inst[2].GTHE4_CHANNEL_PRIM_INST/RXOUTCLKPCS}]
create_generated_clock -name fabEthXauiRxClk2_3 [get_pins {U_Core/U_Eth/GEN_FAB[2].EN_ETH.U_Fab/GEN_ETH_10Gx4.U_Eth/XauiGthUltraScale_Inst/U_XauiGthUltraScaleCore/U0/XauiGthUltraScale156p25MHz10GigECore_gt_i/inst/gen_gtwizard_gthe4_top.XauiGthUltraScale156p25MHz10GigECore_gt_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_channel_container[0].gen_enabled_channel.gthe4_channel_wrapper_inst/channel_inst/gthe4_channel_gen.gen_gthe4_channel_inst[3].GTHE4_CHANNEL_PRIM_INST/RXOUTCLKPCS}]

create_generated_clock -name fabEthXauiRxClk3_0 [get_pins {U_Core/U_Eth/GEN_FAB[3].EN_ETH.U_Fab/GEN_ETH_10Gx4.U_Eth/XauiGthUltraScale_Inst/U_XauiGthUltraScaleCore/U0/XauiGthUltraScale156p25MHz10GigECore_gt_i/inst/gen_gtwizard_gthe4_top.XauiGthUltraScale156p25MHz10GigECore_gt_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_channel_container[0].gen_enabled_channel.gthe4_channel_wrapper_inst/channel_inst/gthe4_channel_gen.gen_gthe4_channel_inst[0].GTHE4_CHANNEL_PRIM_INST/RXOUTCLKPCS}]
create_generated_clock -name fabEthXauiRxClk3_1 [get_pins {U_Core/U_Eth/GEN_FAB[3].EN_ETH.U_Fab/GEN_ETH_10Gx4.U_Eth/XauiGthUltraScale_Inst/U_XauiGthUltraScaleCore/U0/XauiGthUltraScale156p25MHz10GigECore_gt_i/inst/gen_gtwizard_gthe4_top.XauiGthUltraScale156p25MHz10GigECore_gt_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_channel_container[0].gen_enabled_channel.gthe4_channel_wrapper_inst/channel_inst/gthe4_channel_gen.gen_gthe4_channel_inst[1].GTHE4_CHANNEL_PRIM_INST/RXOUTCLKPCS}]
create_generated_clock -name fabEthXauiRxClk3_2 [get_pins {U_Core/U_Eth/GEN_FAB[3].EN_ETH.U_Fab/GEN_ETH_10Gx4.U_Eth/XauiGthUltraScale_Inst/U_XauiGthUltraScaleCore/U0/XauiGthUltraScale156p25MHz10GigECore_gt_i/inst/gen_gtwizard_gthe4_top.XauiGthUltraScale156p25MHz10GigECore_gt_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_channel_container[0].gen_enabled_channel.gthe4_channel_wrapper_inst/channel_inst/gthe4_channel_gen.gen_gthe4_channel_inst[2].GTHE4_CHANNEL_PRIM_INST/RXOUTCLKPCS}]
create_generated_clock -name fabEthXauiRxClk3_3 [get_pins {U_Core/U_Eth/GEN_FAB[3].EN_ETH.U_Fab/GEN_ETH_10Gx4.U_Eth/XauiGthUltraScale_Inst/U_XauiGthUltraScaleCore/U0/XauiGthUltraScale156p25MHz10GigECore_gt_i/inst/gen_gtwizard_gthe4_top.XauiGthUltraScale156p25MHz10GigECore_gt_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_channel_container[0].gen_enabled_channel.gthe4_channel_wrapper_inst/channel_inst/gthe4_channel_gen.gen_gthe4_channel_inst[3].GTHE4_CHANNEL_PRIM_INST/RXOUTCLKPCS}]

set_clock_groups -asynchronous -group [get_clocks -include_generated_clocks {fabEthRefClkP}] -group [get_clocks -of_objects [get_pins {U_Core/U_Eth/GEN_FAB[*].EN_ETH.U_Fab/GEN_ETH_10Gx4.U_Eth/XauiGthUltraScale_Inst/U_XauiGthUltraScaleCore/U0/XauiGthUltraScale156p25MHz10GigECore_gt_i/inst/gen_gtwizard_gthe4_top.XauiGthUltraScale156p25MHz10GigECore_gt_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_channel_container[0].gen_enabled_channel.gthe4_channel_wrapper_inst/channel_inst/gthe4_channel_gen.gen_gthe4_channel_inst[0].GTHE4_CHANNEL_PRIM_INST/TXOUTCLK}]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {U_Core/U_Eth/GEN_FAB[*].EN_ETH.U_Fab/GEN_ETH_10Gx4.U_Eth/XauiGthUltraScale_Inst/U_XauiGthUltraScaleCore/U0/XauiGthUltraScale156p25MHz10GigECore_gt_i/inst/gen_gtwizard_gthe4_top.XauiGthUltraScale156p25MHz10GigECore_gt_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_channel_container[0].gen_enabled_channel.gthe4_channel_wrapper_inst/channel_inst/gthe4_channel_gen.gen_gthe4_channel_inst[0].GTHE4_CHANNEL_PRIM_INST/RXOUTCLKPCS}]] -group [get_clocks -of_objects [get_pins {U_Core/U_Eth/GEN_FAB[*].EN_ETH.U_Fab/GEN_ETH_10Gx4.U_Eth/XauiGthUltraScale_Inst/U_XauiGthUltraScaleCore/U0/XauiGthUltraScale156p25MHz10GigECore_gt_i/inst/gen_gtwizard_gthe4_top.XauiGthUltraScale156p25MHz10GigECore_gt_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_channel_container[0].gen_enabled_channel.gthe4_channel_wrapper_inst/channel_inst/gthe4_channel_gen.gen_gthe4_channel_inst[0].GTHE4_CHANNEL_PRIM_INST/TXOUTCLK}]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {U_Core/U_Eth/GEN_FAB[*].EN_ETH.U_Fab/GEN_ETH_10Gx4.U_Eth/XauiGthUltraScale_Inst/U_XauiGthUltraScaleCore/U0/XauiGthUltraScale156p25MHz10GigECore_gt_i/inst/gen_gtwizard_gthe4_top.XauiGthUltraScale156p25MHz10GigECore_gt_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_channel_container[0].gen_enabled_channel.gthe4_channel_wrapper_inst/channel_inst/gthe4_channel_gen.gen_gthe4_channel_inst[1].GTHE4_CHANNEL_PRIM_INST/RXOUTCLKPCS}]] -group [get_clocks -of_objects [get_pins {U_Core/U_Eth/GEN_FAB[*].EN_ETH.U_Fab/GEN_ETH_10Gx4.U_Eth/XauiGthUltraScale_Inst/U_XauiGthUltraScaleCore/U0/XauiGthUltraScale156p25MHz10GigECore_gt_i/inst/gen_gtwizard_gthe4_top.XauiGthUltraScale156p25MHz10GigECore_gt_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_channel_container[0].gen_enabled_channel.gthe4_channel_wrapper_inst/channel_inst/gthe4_channel_gen.gen_gthe4_channel_inst[0].GTHE4_CHANNEL_PRIM_INST/TXOUTCLK}]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {U_Core/U_Eth/GEN_FAB[*].EN_ETH.U_Fab/GEN_ETH_10Gx4.U_Eth/XauiGthUltraScale_Inst/U_XauiGthUltraScaleCore/U0/XauiGthUltraScale156p25MHz10GigECore_gt_i/inst/gen_gtwizard_gthe4_top.XauiGthUltraScale156p25MHz10GigECore_gt_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_channel_container[0].gen_enabled_channel.gthe4_channel_wrapper_inst/channel_inst/gthe4_channel_gen.gen_gthe4_channel_inst[2].GTHE4_CHANNEL_PRIM_INST/RXOUTCLKPCS}]] -group [get_clocks -of_objects [get_pins {U_Core/U_Eth/GEN_FAB[*].EN_ETH.U_Fab/GEN_ETH_10Gx4.U_Eth/XauiGthUltraScale_Inst/U_XauiGthUltraScaleCore/U0/XauiGthUltraScale156p25MHz10GigECore_gt_i/inst/gen_gtwizard_gthe4_top.XauiGthUltraScale156p25MHz10GigECore_gt_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_channel_container[0].gen_enabled_channel.gthe4_channel_wrapper_inst/channel_inst/gthe4_channel_gen.gen_gthe4_channel_inst[0].GTHE4_CHANNEL_PRIM_INST/TXOUTCLK}]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {U_Core/U_Eth/GEN_FAB[*].EN_ETH.U_Fab/GEN_ETH_10Gx4.U_Eth/XauiGthUltraScale_Inst/U_XauiGthUltraScaleCore/U0/XauiGthUltraScale156p25MHz10GigECore_gt_i/inst/gen_gtwizard_gthe4_top.XauiGthUltraScale156p25MHz10GigECore_gt_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_channel_container[0].gen_enabled_channel.gthe4_channel_wrapper_inst/channel_inst/gthe4_channel_gen.gen_gthe4_channel_inst[3].GTHE4_CHANNEL_PRIM_INST/RXOUTCLKPCS}]] -group [get_clocks -of_objects [get_pins {U_Core/U_Eth/GEN_FAB[*].EN_ETH.U_Fab/GEN_ETH_10Gx4.U_Eth/XauiGthUltraScale_Inst/U_XauiGthUltraScaleCore/U0/XauiGthUltraScale156p25MHz10GigECore_gt_i/inst/gen_gtwizard_gthe4_top.XauiGthUltraScale156p25MHz10GigECore_gt_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_channel_container[0].gen_enabled_channel.gthe4_channel_wrapper_inst/channel_inst/gthe4_channel_gen.gen_gthe4_channel_inst[0].GTHE4_CHANNEL_PRIM_INST/TXOUTCLK}]]

################################################
# FABRIC ETH[1:4] at 10GbE x 1 Lane (10GBASE-KR)
################################################

create_generated_clock -name fabEth10GbETxClk0 [get_pins {U_Core/U_Eth/GEN_FAB[0].EN_ETH.U_Fab/GEN_ETH_10Gx1.U_Eth/GEN_LANE[0].TenGigEthGthUltraScale_Inst/U_TenGigEthGthUltraScaleCore/inst/i_core_gtwiz_userclk_tx_inst_0/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk2_inst/O}]
create_generated_clock -name fabEth10GbETxClk1 [get_pins {U_Core/U_Eth/GEN_FAB[1].EN_ETH.U_Fab/GEN_ETH_10Gx1.U_Eth/GEN_LANE[0].TenGigEthGthUltraScale_Inst/U_TenGigEthGthUltraScaleCore/inst/i_core_gtwiz_userclk_tx_inst_0/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk2_inst/O}]
create_generated_clock -name fabEth10GbETxClk2 [get_pins {U_Core/U_Eth/GEN_FAB[2].EN_ETH.U_Fab/GEN_ETH_10Gx1.U_Eth/GEN_LANE[0].TenGigEthGthUltraScale_Inst/U_TenGigEthGthUltraScaleCore/inst/i_core_gtwiz_userclk_tx_inst_0/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk2_inst/O}]
create_generated_clock -name fabEth10GbETxClk3 [get_pins {U_Core/U_Eth/GEN_FAB[3].EN_ETH.U_Fab/GEN_ETH_10Gx1.U_Eth/GEN_LANE[0].TenGigEthGthUltraScale_Inst/U_TenGigEthGthUltraScaleCore/inst/i_core_gtwiz_userclk_tx_inst_0/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk2_inst/O}]

create_generated_clock -name fabEth10GbERxClk0 [get_pins {U_Core/U_Eth/GEN_FAB[0].EN_ETH.U_Fab/GEN_ETH_10Gx1.U_Eth/GEN_LANE[0].TenGigEthGthUltraScale_Inst/U_TenGigEthGthUltraScaleCore/inst/i_core_gtwiz_userclk_rx_inst_0/gen_gtwiz_userclk_rx_main.bufg_gt_usrclk2_inst/O}]
create_generated_clock -name fabEth10GbERxClk1 [get_pins {U_Core/U_Eth/GEN_FAB[1].EN_ETH.U_Fab/GEN_ETH_10Gx1.U_Eth/GEN_LANE[0].TenGigEthGthUltraScale_Inst/U_TenGigEthGthUltraScaleCore/inst/i_core_gtwiz_userclk_rx_inst_0/gen_gtwiz_userclk_rx_main.bufg_gt_usrclk2_inst/O}]
create_generated_clock -name fabEth10GbERxClk2 [get_pins {U_Core/U_Eth/GEN_FAB[2].EN_ETH.U_Fab/GEN_ETH_10Gx1.U_Eth/GEN_LANE[0].TenGigEthGthUltraScale_Inst/U_TenGigEthGthUltraScaleCore/inst/i_core_gtwiz_userclk_rx_inst_0/gen_gtwiz_userclk_rx_main.bufg_gt_usrclk2_inst/O}]
create_generated_clock -name fabEth10GbERxClk3 [get_pins {U_Core/U_Eth/GEN_FAB[3].EN_ETH.U_Fab/GEN_ETH_10Gx1.U_Eth/GEN_LANE[0].TenGigEthGthUltraScale_Inst/U_TenGigEthGthUltraScaleCore/inst/i_core_gtwiz_userclk_rx_inst_0/gen_gtwiz_userclk_rx_main.bufg_gt_usrclk2_inst/O}]

set_clock_groups -asynchronous \
   -group [get_clocks -of_objects [get_pins {U_Core/U_Eth/GEN_FAB[*].EN_ETH.U_Fab/GEN_ETH_10Gx1.U_Eth/GEN_LANE[0].TenGigEthGthUltraScale_Inst/U_TenGigEthGthUltraScaleCore/inst/i_core_gtwiz_userclk_tx_inst_0/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk2_inst/O}]] \
   -group [get_clocks -of_objects [get_pins {U_Core/U_Eth/GEN_FAB[*].EN_ETH.U_Fab/GEN_ETH_10Gx1.U_Eth/GEN_LANE[0].TenGigEthGthUltraScale_Inst/U_TenGigEthGthUltraScaleCore/inst/i_core_gtwiz_userclk_rx_inst_0/gen_gtwiz_userclk_rx_main.bufg_gt_usrclk2_inst/O}]] \
   -group [get_clocks -include_generated_clocks {fabEthRefClkP}]