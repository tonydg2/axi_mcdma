/******************************************************************************
* Copyright (C) 2023 Advanced Micro Devices, Inc. All Rights Reserved.
* SPDX-License-Identifier: MIT
******************************************************************************/
/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include <xil_io.h>
#include "xparameters.h"
#include "helpFunctions.h"

#define PL_REG32_ADDR  XPAR_AXIL_REG32_0_BASEADDR

#define ADDR_SG  0xA0010000;
#define ADDR_DMA 0xA0000000;
#define ADDR_MEM 0xC0000000;
#define ADDR_REG 0xA0012000;
#define NXDS_S0  0x00;
#define BADD_S0  0x08;
#define CTRL_S0  0x14;
#define NXDS_S1  0x40;
#define BADD_S1  0x48;
#define CTRL_S1  0x54;
#define NXDS_M0  0x80;
#define BADD_M0  0x88;
#define CTRL_M0  0x94;
#define NXDS_M1  0xC0;
#define BADD_M1  0xC8;
#define CTRL_M1  0xD4;
#define MM2S_CR  0x000;
#define MM2S_CH  0x008;
#define M_CH0CR  0x040;
#define M_CH0CD  0x048;
#define M_CH0TD  0x050;
#define M_CH1CR  0x080;
#define M_CH1CD  0x088;
#define M_CH1TD  0x090;
#define S2MM_CR  0x500;
#define S2MM_CH  0x508;
#define S_CH0CR  0x540;
#define S_CH0CD  0x548;
#define S_CH0TD  0x550;
#define S_CH1CR  0x580;
#define S_CH1CD  0x588;
#define S_CH1TD  0x590;

static void mcdmaCfg(void);


int main()
{
    init_platform();

    xil_printf("\n\rtesting adg2\n\r");

    versionCtrl();
    versionCtrl0();

/*************************************************************************************************/


/*************************************************************************************************/

    int val = 11;
    //val = Xil_In32(0xa0010000);
    //val = Xil_In32(0xa0020000);
    //Xil_Out32(0xa0010000,0x5);

    xil_printf("Val = %d\n\r",val);
    xil_printf("Val = %x\n\r",val);
    
    val = Xil_In32(0xa001200C);
    xil_printf("Reg3 = %x\n\r",val);
    val = Xil_In32(0xa0012010);
    xil_printf("Reg4 = %x\n\r",val);

    

    xil_printf("\n\r----------------------------------------\n\r");
    xil_printf("** END **\n\r");
    xil_printf("----------------------------------------\n\r\n\r");

    cleanup_platform();
    return 0;
}

void mcdmaCfg(void) {

    static unsigned gitL,gitM,timeStamp;
    gitL = Xil_In32(PL_REG32_ADDR + 0); // gitl
    gitM = Xil_In32(PL_REG32_ADDR + 0x4); // gitm
    timeStamp = Xil_In32(PL_REG32_ADDR + 0x8); // timestamp
    
    static unsigned sec,min,hr,yr,mon,day;
    //sec = (timeStamp & (((1 << numBits) - 1) << startBit)) >> startBit;   //  09B1219F  Fri Mar  1 18:06:31 2024
    sec = (timeStamp & (((1 << 6) - 1) << 0)) >> 0;
    min = (timeStamp & (((1 << 6) - 1) << 6)) >> 6;
    hr  = (timeStamp & (((1 << 5) - 1) << 12)) >> 12;
    yr  = (timeStamp & (((1 << 6) - 1) << 17)) >> 17;
    mon = (timeStamp & (((1 << 4) - 1) << 23)) >> 23;
    day = (timeStamp & (((1 << 5) - 1) << 27)) >> 27;

    xil_printf("\n\r*************** VERSION ****************\n\r");
    xil_printf("  Git Hash: %x%x\n\r",gitM,gitL);
    xil_printf("  TIMESTAMP:%x = %d/%d/%d - %d:%d:%d\n\r",timeStamp,mon,day,yr,hr,min,sec);
    xil_printf("****************************************\n\r\n\r");

}