----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.11.2026 14:44:35
-- Design Name: 
-- Module Name: sx1278_gpio_controller - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Controla las señales GPIO auxiliares del SX1278. Sincroniza
--              DIO0, retiene sus flancos ascendentes para que puedan ser
--              consultados por software y genera el reset fisico temporizado.
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sx1278_gpio_controller is
    generic (
        -- Frecuencia del reloj utilizado por el controlador.
        CLK_FREQ_HZ : integer := 100_000_000;
        -- Duracion del pulso de reset fisico activo en bajo.
        RESET_TIME_MS : integer := 10
    );
    port (
        -- Reloj principal.
        clk : in std_logic;
        -- Reset general sincrono.
        rst : in std_logic;
        -- Solicitud de reset fisico del SX1278.
        peripheral_reset_request_i : in std_logic;
        -- Pulso generado por software para limpiar el evento DIO0 retenido.
        event_clear_i : in std_logic;

        -- Entrada asincronica DIO0 proveniente del SX1278.
        sx1278_dio0_i : in std_logic;
        -- Reset fisico del SX1278, activo en bajo.
        sx1278_reset_o : out std_logic;

        -- Nivel de DIO0 luego de atravesar el sincronizador.
        dio0_level_o : out std_logic;
        -- Indica que se detecto un flanco ascendente pendiente de atencion.
        event_pending_o : out std_logic;
        -- Indica que el reset fisico temporizado se encuentra activo.
        reset_active_o : out std_logic;
        -- Interrupcion de nivel mantenida mientras exista un evento pendiente.
        interrupt_o : out std_logic
    );
end sx1278_gpio_controller;

architecture Behavioral of sx1278_gpio_controller is
    constant RESET_CYCLES : integer := (CLK_FREQ_HZ/1_000)*RESET_TIME_MS;
    constant N_RESET_COUNTER : integer := integer(ceil(log2(real(RESET_CYCLES+1))));

    -- DIO0 es asincronica respecto de clk. Los dos primeros registros reducen
    -- el riesgo de metastabilidad y el tercero conserva el nivel anterior para
    -- detectar el flanco ascendente sincronizado.
    signal dio0_sync_reg : std_logic_vector(3-1 downto 0);
    signal dio0_rising_edge : std_logic;

    signal event_pending : std_logic;
    signal reset_active : std_logic;
    signal reset_counter : unsigned(N_RESET_COUNTER-1 downto 0);
begin

    dio0_edge_detector : process(clk)
    begin
        if rising_edge(clk) then
            if rst='1' then
                dio0_sync_reg<=(others=>'0');
            else
                dio0_sync_reg(0)<=sx1278_dio0_i;
                dio0_sync_reg(1)<=dio0_sync_reg(0);
                dio0_sync_reg(2)<=dio0_sync_reg(1);
            end if;
        end if;
    end process;

    dio0_rising_edge<=dio0_sync_reg(1) and not dio0_sync_reg(2);

    event_register : process(clk)
    begin
        if rising_edge(clk) then
            if rst='1' then
                event_pending<='0';
            elsif dio0_rising_edge='1' then
                event_pending<='1';
            elsif event_clear_i='1' then
                event_pending<='0';
            end if;
        end if;
    end process;

    peripheral_reset : process(clk)
    begin
        if rising_edge(clk) then
            if rst='1' then
                reset_active<='0';
                reset_counter<=TO_UNSIGNED(0,reset_counter'length);
            elsif peripheral_reset_request_i='1' then
                reset_active<='1';
                reset_counter<=TO_UNSIGNED(0,reset_counter'length);
            elsif reset_active='1' then
                if reset_counter=TO_UNSIGNED(RESET_CYCLES-1,reset_counter'length) then
                    reset_active<='0';
                    reset_counter<=TO_UNSIGNED(0,reset_counter'length);
                else
                    reset_counter<=reset_counter+TO_UNSIGNED(1,reset_counter'length);
                end if;
            end if;
        end if;
    end process;

    -- El reset general tambien mantiene al periferico fisicamente reseteado.
    sx1278_reset_o<=not (rst or reset_active);

    dio0_level_o<=dio0_sync_reg(1);
    event_pending_o<=event_pending;
    reset_active_o<=reset_active;
    interrupt_o<=event_pending;

end Behavioral;
