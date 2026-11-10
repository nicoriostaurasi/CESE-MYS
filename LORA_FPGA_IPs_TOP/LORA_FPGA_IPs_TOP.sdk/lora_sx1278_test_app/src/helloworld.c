/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * Prueba monolitica de referencia para el SX1278.
 *
 * TEST_CONFIG solamente configura el transceptor.
 * TEST_CONFIG_TX configura y transmite el texto definido en TX_PAYLOAD.
 * TEST_RX configura, inicia una recepcion y muestra el paquete por UART.
 */

#include <string.h>
#include "platform.h"
#include "sleep.h"
#include "xil_io.h"
#include "xil_printf.h"
#include "xparameters.h"

#define TEST_CONFIG       0
#define TEST_CONFIG_TX    1
#define TEST_RX           2

#define TEST_MODE         TEST_CONFIG_TX
#define TX_PAYLOAD        "LORA FPGA"

#define SPI_BASEADDR XPAR_AXI_SPI_CONTROLLER_0_S_AXI_BASEADDR
#define GPIO_BASEADDR XPAR_AXI_LORA_GPIO_CONTRO_0_S_AXI_BASEADDR

#define SPI_CONTROL_OFFSET       0x00U
#define SPI_STATUS_OFFSET        0x04U
#define SPI_TX_DATA_OFFSET       0x08U
#define SPI_RX_DATA_OFFSET       0x0CU

#define SPI_CONTROL_START        0x01U
#define SPI_CONTROL_CLEAR_DONE   0x02U
#define SPI_STATUS_BUSY          0x01U
#define SPI_STATUS_DONE          0x02U
#define SPI_STATUS_RX_EMPTY      0x04U

#define GPIO_CONTROL_OFFSET      0x00U
#define GPIO_STATUS_OFFSET       0x04U
#define GPIO_EVENT_OFFSET        0x08U
#define GPIO_EVENT_CLEAR_OFFSET  0x0CU

#define GPIO_CONTROL_RESET       0x01U
#define GPIO_STATUS_RESET_ACTIVE 0x02U
#define GPIO_EVENT_PENDING       0x01U

#define SPI_TIMEOUT_ITERATIONS   1000000U
// Tengo que hacer que tenga un timeout eterno por el polling
#define DIO0_TIMEOUT_ITERATIONS  10000000U
#define SPI_TEST_PERIOD_US    	 1000000U
#define MAX_PAYLOAD_LENGTH       50U

static int spi_transfer(const u8 *tx_data, u8 *rx_data, u32 length)
{
    u32 index;
    u32 timeout;
    u32 status;

    Xil_Out32(SPI_BASEADDR + SPI_CONTROL_OFFSET, SPI_CONTROL_CLEAR_DONE);

    for (index = 0U; index < length; index++) {
        Xil_Out32(SPI_BASEADDR + SPI_TX_DATA_OFFSET, tx_data[index]);
    }

    Xil_Out32(SPI_BASEADDR + SPI_CONTROL_OFFSET, SPI_CONTROL_START);

    for (timeout = 0U; timeout < SPI_TIMEOUT_ITERATIONS; timeout++) {
        status = Xil_In32(SPI_BASEADDR + SPI_STATUS_OFFSET);
        if ((status & SPI_STATUS_DONE) != 0U) {
            break;
        }
    }

    if (timeout == SPI_TIMEOUT_ITERATIONS) {
        xil_printf("ERROR: timeout SPI, status=0x%08lx\r\n", status);
        return -1;
    }

    for (index = 0U; index < length; index++) {
        status = Xil_In32(SPI_BASEADDR + SPI_STATUS_OFFSET);
        if ((status & SPI_STATUS_RX_EMPTY) != 0U) {
            xil_printf("ERROR: RX SPI incompleto en byte %lu\r\n", index);
            return -1;
        }
        if (rx_data != NULL) {
            rx_data[index] = (u8)Xil_In32(SPI_BASEADDR + SPI_RX_DATA_OFFSET);
        } else {
            (void)Xil_In32(SPI_BASEADDR + SPI_RX_DATA_OFFSET);
        }
    }

    return 0;
}

static int sx1278_write_register(u8 address, u8 value)
{
    u8 frame[2];

    frame[0] = address | 0x80U;
    frame[1] = value;

    xil_printf("SPI WR Reg[0x%02x] = 0x%02x\r\n", address, value);
    return spi_transfer(frame, NULL, sizeof(frame));
}

#if TEST_MODE == TEST_RX
static int sx1278_read_register(u8 address, u8 *value)
{
    u8 tx_frame[2];
    u8 rx_frame[2];

    tx_frame[0] = address & 0x7FU;
    tx_frame[1] = 0x00U;

    if (spi_transfer(tx_frame, rx_frame, sizeof(tx_frame)) != 0) {
        return -1;
    }

    *value = rx_frame[1];
    xil_printf("SPI RD Reg[0x%02x] = 0x%02x\r\n", address, *value);
    return 0;
}
#endif

static int sx1278_reset(void)
{
    u32 timeout;

    xil_printf("Reset SX1278\r\n");
    Xil_Out32(GPIO_BASEADDR + GPIO_CONTROL_OFFSET, GPIO_CONTROL_RESET);

    for (timeout = 0U; timeout < SPI_TIMEOUT_ITERATIONS; timeout++) {
        if ((Xil_In32(GPIO_BASEADDR + GPIO_STATUS_OFFSET) &
             GPIO_STATUS_RESET_ACTIVE) == 0U) {
            return 0;
        }
    }

    xil_printf("ERROR: timeout esperando fin de reset\r\n");
    return -1;
}

static int sx1278_configure(void)
{
    static const u8 configuration[][2] = {
        {0x01U, 0x88U}, /* LoRa, LF, sleep. */
        {0x01U, 0x89U}, /* LoRa, LF, standby. */
        {0x06U, 0x6CU}, /* Frecuencia: 433 MHz. */
        {0x07U, 0x40U},
        {0x08U, 0x00U},
        {0x1DU, 0x72U}, /* BW 125 kHz, CR 4/5, header explicito. */
        {0x1EU, 0x74U}, /* SF7, CRC habilitado. */
        {0x26U, 0x04U}, /* AGC automatico. */
        {0x20U, 0x00U}, /* Preambulo de 8 simbolos. */
        {0x21U, 0x08U},
        {0x09U, 0xFCU}, /* PA_BOOST, 14 dBm. */
        {0x0CU, 0x23U}, /* LNA boost. */
        {0x0EU, 0x00U}, /* Base FIFO TX. */
        {0x0FU, 0x00U}, /* Base FIFO RX. */
        {0x12U, 0xFFU}  /* Limpieza de IRQ. */
    };
    u32 index;

    xil_printf("Configurando SX1278\r\n");
    for (index = 0U; index < (sizeof(configuration) / sizeof(configuration[0]));
         index++) {
        if (sx1278_write_register(configuration[index][0],
                                  configuration[index][1]) != 0) {
            return -1;
        }
    }

    return 0;
}

#if TEST_MODE != TEST_CONFIG
static int wait_dio0_event(void)
{
    u32 timeout;

    for (timeout = 0U; timeout < DIO0_TIMEOUT_ITERATIONS; timeout++) {
        if ((Xil_In32(GPIO_BASEADDR + GPIO_EVENT_OFFSET) &
             GPIO_EVENT_PENDING) != 0U) {
            return 0;
        }
    }

    xil_printf("ERROR: timeout esperando DIO0\r\n");
    return -1;
}
#endif

#if TEST_MODE == TEST_CONFIG_TX
static int sx1278_transmit(const u8 *payload, u8 length)
{
    u8 fifo_frame[MAX_PAYLOAD_LENGTH + 1U];
    u32 index;

    if ((length == 0U) || (length > MAX_PAYLOAD_LENGTH)) {
        return -1;
    }

    Xil_Out32(GPIO_BASEADDR + GPIO_EVENT_CLEAR_OFFSET, 1U);

    if (sx1278_write_register(0x01U, 0x89U) != 0 ||
        sx1278_write_register(0x0DU, 0x00U) != 0) {
        return -1;
    }

    fifo_frame[0] = 0x80U;
    for (index = 0U; index < length; index++) {
        fifo_frame[index + 1U] = payload[index];
    }
    if (spi_transfer(fifo_frame, NULL, (u32)length + 1U) != 0) {
        return -1;
    }

    if (sx1278_write_register(0x22U, length) != 0 ||
        sx1278_write_register(0x12U, 0xFFU) != 0 ||
        sx1278_write_register(0x40U, 0x40U) != 0 ||
        sx1278_write_register(0x01U, 0x8BU) != 0) {
        return -1;
    }

    xil_printf("Esperando TxDone por DIO0\r\n");
    if (wait_dio0_event() != 0) {
        return -1;
    }

    (void)sx1278_write_register(0x12U, 0x08U);
    Xil_Out32(GPIO_BASEADDR + GPIO_EVENT_CLEAR_OFFSET, 1U);
    xil_printf("TX finalizada: %u bytes\r\n", length);
    return 0;
}
#endif

#if TEST_MODE == TEST_RX
static int sx1278_receive_once(void)
{
    u8 irq_flags;
    u8 length;
    u8 fifo_address;
    u8 tx_frame[MAX_PAYLOAD_LENGTH + 1U];
    u8 rx_frame[MAX_PAYLOAD_LENGTH + 1U];
    u32 index;

    Xil_Out32(GPIO_BASEADDR + GPIO_EVENT_CLEAR_OFFSET, 1U);

    if (sx1278_write_register(0x40U, 0x00U) != 0 ||
        sx1278_write_register(0x12U, 0xFFU) != 0 ||
        sx1278_write_register(0x01U, 0x8EU) != 0) {
        return -1;
    }

    xil_printf("Esperando RxDone por DIO0\r\n");
    if (wait_dio0_event() != 0 ||
        sx1278_read_register(0x12U, &irq_flags) != 0) {
        return -1;
    }

    if ((irq_flags & 0x20U) != 0U) {
        xil_printf("ERROR: paquete recibido con CRC incorrecto\r\n");
        (void)sx1278_write_register(0x12U, 0xFFU);
        return -1;
    }

    if (sx1278_read_register(0x13U, &length) != 0 ||
        sx1278_read_register(0x10U, &fifo_address) != 0) {
        return -1;
    }

    if (length > MAX_PAYLOAD_LENGTH) {
        length = MAX_PAYLOAD_LENGTH;
    }

    if (sx1278_write_register(0x0DU, fifo_address) != 0) {
        return -1;
    }

    tx_frame[0] = 0x00U;
    for (index = 0U; index < length; index++) {
        tx_frame[index + 1U] = 0x00U;
    }
    if (spi_transfer(tx_frame, rx_frame, (u32)length + 1U) != 0) {
        return -1;
    }

    xil_printf("RX (%u bytes): ", length);
    for (index = 0U; index < length; index++) {
        xil_printf("%c", rx_frame[index + 1U]);
    }
    xil_printf("\r\n");

    (void)sx1278_write_register(0x12U, 0xFFU);
    Xil_Out32(GPIO_BASEADDR + GPIO_EVENT_CLEAR_OFFSET, 1U);
    return 0;
}
#endif

int main(void)
{
    int result = 0;

    init_platform();
    xil_printf("\r\nSX1278 test monolitico\r\n");
    xil_printf("SPI=0x%08lx GPIO=0x%08lx\r\n",
               (u32)SPI_BASEADDR, (u32)GPIO_BASEADDR);

    result = sx1278_reset();
    if (result == 0) {
        result = sx1278_configure();
    }

    while(1){
	#if TEST_MODE == TEST_CONFIG
		if (result == 0) {
		    result = sx1278_reset();
		    if (result == 0) {
		        result = sx1278_configure();
		    }
			xil_printf("CONFIG finalizada\r\n");
		}
	#elif TEST_MODE == TEST_CONFIG_TX
		if (result == 0) {
			const u8 payload[] = TX_PAYLOAD;
			result = sx1278_transmit(payload, (u8)(sizeof(payload) - 1U));
		}
	#elif TEST_MODE == TEST_RX
		if (result == 0) {
			result = sx1278_receive_once();
		}
	#else
	#error TEST_MODE invalido
	#endif

		xil_printf("Prueba %s\r\n", (result == 0) ? "OK" : "FALLIDA");
        usleep(SPI_TEST_PERIOD_US);
    }

}
