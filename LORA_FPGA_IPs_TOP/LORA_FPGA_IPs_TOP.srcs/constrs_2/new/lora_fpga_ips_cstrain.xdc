# SPI sobre el conector JE de la Zybo
# JE1 -> SCLK
# JE2 -> MOSI
# JE3 -> MISO
# JE4 -> NSS
set_property -dict {PACKAGE_PIN V12 IOSTANDARD LVCMOS33} [get_ports spi_sclk_o]
set_property -dict {PACKAGE_PIN W16 IOSTANDARD LVCMOS33} [get_ports spi_mosi_o]
set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS33} [get_ports spi_miso_i]
set_property -dict {PACKAGE_PIN H15 IOSTANDARD LVCMOS33} [get_ports spi_nss_o]

# GPIO auxiliares del SX1278 sobre el conector JD
#|06|05|04|03|02|01|
#|12|11|10|09|08|07|
# JD9 -> V17 -> DIO 0
# JD7 -> U14 -> RESET
set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS33} [get_ports sx1278_dio0_i]
set_property -dict {PACKAGE_PIN U14 IOSTANDARD LVCMOS33} [get_ports sx1278_reset_o]
