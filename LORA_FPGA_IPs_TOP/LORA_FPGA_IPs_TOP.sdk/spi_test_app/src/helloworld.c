/******************************************************************************
 * Aplicacion monolitica de desarrollo para AXI_SPI_CONTROLLER.
 *
 * Esta aplicacion no representa la arquitectura final del firmware. Sirve
 * como referencia para verificar el camino Cortex-A9 -> AXI4-Lite -> IP SPI.
 * El periferico SPI puede estar desconectado; en ese caso es esperable recibir
 * ceros por MISO.
 ******************************************************************************/

#include "platform.h"
#include "sleep.h"
#include "xil_io.h"
#include "xil_printf.h"
#include "xil_types.h"
#include "xparameters.h"

/* Direccion asignada al IP en el Address Editor del proyecto actual. */
#if defined(XPAR_AXI_SPI_CONTROLLER_0_S_AXI_BASEADDR)
#define SPI_BASE_ADDRESS XPAR_AXI_SPI_CONTROLLER_0_S_AXI_BASEADDR
#else
#define SPI_BASE_ADDRESS 0x43C00000U
#endif

/* Mapa de registros AXI4-Lite. */
#define SPI_CONTROL_OFFSET 0x00U
#define SPI_STATUS_OFFSET  0x04U
#define SPI_TX_DATA_OFFSET 0x08U
#define SPI_RX_DATA_OFFSET 0x0CU

/* Bits de CONTROL. */
#define SPI_CONTROL_START      (1U << 0)
#define SPI_CONTROL_CLEAR_DONE (1U << 1)

/* Bits de STATUS. */
#define SPI_STATUS_BUSY     (1U << 0)
#define SPI_STATUS_DONE     (1U << 1)
#define SPI_STATUS_RX_EMPTY (1U << 2)

#define SPI_TEST_FRAME_LENGTH 2U
#define SPI_POLL_DELAY_US     10U
#define SPI_TIMEOUT_POLLS     100000U
#define SPI_TEST_PERIOD_US    1000000U

static u32 spi_read_register(u32 offset)
{
    return Xil_In32(SPI_BASE_ADDRESS + offset);
}

static void spi_write_register(u32 offset, u32 value)
{
    Xil_Out32(SPI_BASE_ADDRESS + offset, value);
}

static void print_status(u32 status)
{
    xil_printf("STATUS=0x%08x  BUSY=%d DONE=%d RX_EMPTY=%d\r\n",
               status,
               (status & SPI_STATUS_BUSY) != 0U,
               (status & SPI_STATUS_DONE) != 0U,
               (status & SPI_STATUS_RX_EMPTY) != 0U);
}

static int wait_for_transfer_done(void)
{
    u32 poll;

    for (poll = 0U; poll < SPI_TIMEOUT_POLLS; ++poll) {
        if ((spi_read_register(SPI_STATUS_OFFSET) & SPI_STATUS_DONE) != 0U) {
            return 0;
        }

        usleep(SPI_POLL_DELAY_US);
    }

    return -1;
}

static int spi_transfer(const u8 *tx_data, u8 *rx_data, u32 length)
{
    u32 index;
    u32 status;

    if ((tx_data == 0) || (rx_data == 0) || (length == 0U)) {
        return -1;
    }

    status = spi_read_register(SPI_STATUS_OFFSET);
    if ((status & SPI_STATUS_BUSY) != 0U) {
        return -2;
    }

    /* Descarta el DONE retenido de una transferencia anterior. */
    spi_write_register(SPI_CONTROL_OFFSET, SPI_CONTROL_CLEAR_DONE);

    /* Cada escritura agrega un byte a la RAM TX interna del IP. */
    for (index = 0U; index < length; ++index) {
        spi_write_register(SPI_TX_DATA_OFFSET, tx_data[index]);
    }

    spi_write_register(SPI_CONTROL_OFFSET, SPI_CONTROL_START);

    if (wait_for_transfer_done() != 0) {
        return -3;
    }

    /* Cada lectura de RX_DATA consume una posicion de la RAM RX. */
    for (index = 0U; index < length; ++index) {
        status = spi_read_register(SPI_STATUS_OFFSET);
        if ((status & SPI_STATUS_RX_EMPTY) != 0U) {
            return -4;
        }

        rx_data[index] = (u8)spi_read_register(SPI_RX_DATA_OFFSET);
    }

    spi_write_register(SPI_CONTROL_OFFSET, SPI_CONTROL_CLEAR_DONE);
    return 0;
}

int main(void)
{
    /* Trama reconocible para observar SCLK, NSS y MOSI con el analizador. */
    const u8 tx_frame[SPI_TEST_FRAME_LENGTH] = {0x42U, 0x00U};
    u8 rx_frame[SPI_TEST_FRAME_LENGTH] = {0U, 0U};
    u32 status;
    u32 transfer_count;
    int result;

    init_platform();

    xil_printf("\r\n");
    xil_printf("========================================\r\n");
    xil_printf(" AXI SPI CONTROLLER - PRUEBA MONOLITICA\r\n");
    xil_printf("========================================\r\n");
    xil_printf("Base AXI: 0x%08x\r\n", SPI_BASE_ADDRESS);
    xil_printf("Periodo de prueba: %d ms\r\n", SPI_TEST_PERIOD_US / 1000U);

    transfer_count = 0U;

    while (1) {
        ++transfer_count;
        rx_frame[0] = 0U;
        rx_frame[1] = 0U;

        xil_printf("\r\nPrueba #%d\r\n", transfer_count);
        status = spi_read_register(SPI_STATUS_OFFSET);
        print_status(status);

        xil_printf("TX: 0x%02x 0x%02x\r\n", tx_frame[0], tx_frame[1]);
        result = spi_transfer(tx_frame, rx_frame, SPI_TEST_FRAME_LENGTH);

        if (result != 0) {
            xil_printf("ERROR: transferencia SPI fallida (%d)\r\n", result);
            print_status(spi_read_register(SPI_STATUS_OFFSET));
        } else {
            xil_printf("RX: 0x%02x 0x%02x\r\n", rx_frame[0], rx_frame[1]);

            if (rx_frame[1] == 0x12U) {
                xil_printf("OK: SX1278 detectado, RegVersion=0x12\r\n");
            } else {
                xil_printf("OK: transferencia terminada; MISO=0x%02x.\r\n",
                           rx_frame[1]);
            }

            print_status(spi_read_register(SPI_STATUS_OFFSET));
        }

        usleep(SPI_TEST_PERIOD_US);
    }
}
