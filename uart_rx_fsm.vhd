-- uart_rx_fsm.vhd: UART controller - finite state machine controlling RX side
-- Author(s): Arsenii Zakharenko (xzakha02)

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;



entity UART_RX_FSM is
    port(
       CLK          : in std_logic;
       RST          : in std_logic;
       DIN          : in std_logic;                   
       CLK_CNT      : in std_logic_vector(4 downto 0); 
       BITS_CNT     : in std_logic_vector(3 downto 0); 
       DOUT_VLD     : out std_logic;                   
       READ_Y       : out std_logic;                   
       CLK_Y        : out std_logic       
    );
end entity;



architecture behavioral of UART_RX_FSM is

    -- Describing 5 possible states and setting the first of them.
    type state is (IDLE, WAIT_START, GET_BITS, WAIT_STOP, VALIDATION);
    signal STATE_NOW : state := IDLE; 

begin

    -- Using case construction to describe all outputs for all states.
    -- Setting up transitions between them.
    process(CLK, RST) begin
        if rising_edge(CLK) then
           if RST = '1' then
            STATE_NOW <= IDLE;
           else 
              case STATE_NOW is

                 when IDLE =>

                    DOUT_VLD <= '0';
                    READ_Y <= '0';
                    CLK_Y <= '0';

                    if DIN = '0' then
                       STATE_NOW <= WAIT_START;
                    end if;

                 when WAIT_START =>

                    DOUT_VLD <= '0';
                    READ_Y <= '0';
                    CLK_Y <= '1';

                    if CLK_CNT = "10000" then
                       STATE_NOW <= GET_BITS;
                    end if;

                 when GET_BITS =>

                    DOUT_VLD <= '0';
                    READ_Y <= '1';
                    CLK_Y <= '1';

                    if BITS_CNT = "1000" then
                       STATE_NOW <= WAIT_STOP;
                    end if;

                 when WAIT_STOP =>

                    DOUT_VLD <= '0';
                    READ_Y <= '0';
                    CLK_Y <= '1';

                    if CLK_CNT = "10000" then
                       STATE_NOW <= VALIDATION;
                    end if;

                 when VALIDATION =>

                    DOUT_VLD <= '1';
                    READ_Y <= '0';
                    CLK_Y <= '0';

                    -- Finally returning to the first state.
                    STATE_NOW <= IDLE;
              end case;
           end if;
        end if;
     end process;
  


end architecture;
