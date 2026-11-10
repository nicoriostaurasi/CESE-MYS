# SPI sobre el conector JE de la Zybo
# JE1 -> SCLK
# JE2 -> MOSI
# JE3 -> MISO
# JE4 -> NSS

set_property -dict { PACKAGE_PIN V12 IOSTANDARD LVCMOS33 } [get_ports spi_sclk_o]
set_property -dict { PACKAGE_PIN W16 IOSTANDARD LVCMOS33 } [get_ports spi_mosi_o]
set_property -dict { PACKAGE_PIN J15 IOSTANDARD LVCMOS33 } [get_ports spi_miso_i]
set_property -dict { PACKAGE_PIN H15 IOSTANDARD LVCMOS33 } [get_ports spi_nss_o]