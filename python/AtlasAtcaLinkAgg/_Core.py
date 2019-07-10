#!/usr/bin/env python3
##############################################################################
## This file is part of 'ATLAS ALTIROC DEV'.
## It is subject to the license terms in the LICENSE.txt file found in the 
## top-level directory of this distribution and at: 
##    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html. 
## No part of 'ATLAS ALTIROC DEV', including this file, 
## may be copied, modified, propagated, or distributed except according to 
## the terms contained in the LICENSE.txt file.
##############################################################################

import pyrogue as pr

import surf.axi                  as axi
import surf.xilinx               as xil
import surf.devices.micron       as prom
import surf.devices.nxp          as nxp
import surf.devices.silabs       as silabs
import surf.devices.ti           as ti
import surf.devices.transceivers as xceiver
import surf.devices.transceivers as xceiver

import AtlasAtcaLinkAgg

class Core(pr.Device):
    def __init__(   
        self,       
        name        = 'Core',
        description = 'Container for Atlas Atca Link Agg Core registers',
            **kwargs):
        
        super().__init__(
            name        = name,
            description = description,
            **kwargs)

        self.add(axi.AxiVersion( 
            name    = 'AxiVersion', 
            offset  = 0x00000000, 
            expand  = False,
        ))
        
        self.add(xil.AxiSysMonUltraScale(
            name    = 'SysMon', 
            offset  = 0x00001000, 
            expand  = False,
        ))
        
        self.add(prom.AxiMicronN25Q(
            name    = 'AxiMicronN25Q', 
            offset  = 0x00002000, 
            hidden  = True, # Hidden in GUI because indented for scripting
        ))        
        
        self.add(AtlasAtcaLinkAgg.Bsi(
            name    = 'Bsi', 
            offset  = 0x00003000, 
            expand  = False,
        ))        
        
        for i in range(4):
            self.add(xceiver.Sff8472(
                name    = f'Sfp[{i}]', 
                offset  = 0x00004000+i*0x00001000, 
                expand  = False,
            ))
            
        for i in range(2):
            self.add(xceiver.Sff8472(
                name    = f'Qsfp[{i}]', 
                offset  = 0x00008000+i*0x00001000, 
                expand  = False,
            ))     
            
        self.add(nxp.Pca9506(      
            name   = 'Pca9506', 
            offset = 0x0000A000,
            expand = False,
        ))                
        
        self.add(ti.Lmk61e2(      
            name   = 'Lmk', 
            offset = 0x0000B000,
            expand = False,
        ))             
        
        self.add(silabs.Si5345Lite(      
            name        = 'Pll', 
            description = 'This device contains Jitter cleaner PLL', 
            offset      = 0x00010000, 
            expand      = False,
        ))        
        
        # To do: AtlasAtcaLinkAggRudp.vhd modules at base address 0x01000000
        