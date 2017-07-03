/**
 * RemoteIR library - Test program.
 *
 * Copyright (C) 2010 Shinichiro Nakamura (CuBeatSystems)
 * http://shinta.main.jp/
 */

#include <mbed.h>

#include "ReceiverIR.h"
#include "TransmitterIR.h"
#include "TextLCD.h"

#define TEST_LOOP_BACK  0

ReceiverIR ir_rx(p15);
TransmitterIR ir_tx(p21);
TextLCD lcd(p24, p26, p27, p28, p29, p30);
BusOut led(LED4, LED3, LED2, LED1);
Ticker ledTicker;

/**
 * Receive.
 *
 * @param format Pointer to a format.
 * @param buf Pointer to a buffer.
 * @param bufsiz Size of the buffer.
 *
 * @return Bit length of the received data.
 */
int receive(RemoteIR::Format *format, uint8_t *buf, int bufsiz, int timeout = 100) {
    int cnt = 0;
    while (ir_rx.getState() != ReceiverIR::Received) {
        cnt++;
        if (timeout < cnt) {
            return -1;
        }
    }
    return ir_rx.getData(format, buf, bufsiz * 8);
}

/**
 * Transmit.
 *
 * @param format Format.
 * @param buf Pointer to a buffer.
 * @param bitlength Bit length of the data.
 *
 * @return Bit length of the received data.
 */
int transmit(RemoteIR::Format format, uint8_t *buf, int bitlength, int timeout = 100) {
    int cnt = 0;
    while (ir_tx.getState() != TransmitterIR::Idle) {
        cnt++;
        if (timeout < cnt) {
            return -1;
        }
    }
    return ir_tx.setData(format, buf, bitlength);
}

/**
 * Display a current status.
 */
void display_status(char *status, int bitlength) {
    lcd.locate(8, 0);
    lcd.printf("%-5.5s:%02d", status, bitlength);
}

/**
 * Display a format of a data.
 */
void display_format(RemoteIR::Format format) {
    lcd.locate(0, 0);
    switch (format) {
        case RemoteIR::UNKNOWN:
            lcd.printf("????????");
            break;
        case RemoteIR::NEC:
            lcd.printf("NEC     ");
            break;
        case RemoteIR::NEC_REPEAT:
            lcd.printf("NEC  (R)");
            break;
        case RemoteIR::AEHA:
            lcd.printf("AEHA    ");
            break;
        case RemoteIR::AEHA_REPEAT:
            lcd.printf("AEHA (R)");
            break;
        case RemoteIR::SONY:
            lcd.printf("SONY    ");
            break;
    }
}

/**
 * Display a data.
 *
 * @param buf Pointer to a buffer.
 * @param bitlength Bit length of a data.
 */
void display_data(uint8_t *buf, int bitlength) {
    lcd.locate(0, 1);
    const int n = bitlength / 8 + (((bitlength % 8) != 0) ? 1 : 0);
    for (int i = 0; i < n; i++) {
        lcd.printf("%02X", buf[i]);
    }
    for (int i = 0; i < 8 - n; i++) {
        lcd.printf("--");
    }
}

void ledfunc(void) {
    led = led + 1;
}

/**
 * Entry point.
 */
int main(void) {

    ledTicker.attach(&ledfunc, 0.5);

    /*
     * Splash.
     */
    lcd.cls();
    lcd.locate(0, 0);
    lcd.printf("RemoteIR        ");
    lcd.locate(0, 1);
    lcd.printf("Program example.");
    wait(3);

    /*
     * Initialize.
     */
    led = 0;
    lcd.cls();
    lcd.locate(0, 0);
    lcd.printf("Press a button  ");
    lcd.locate(0, 1);
    lcd.printf("on a controller.");

    /*
     * Execute.
     */
    while (1) {
        uint8_t buf1[32];
        uint8_t buf2[32];
        int bitlength1;
        int bitlength2;
        RemoteIR::Format format;

        memset(buf1, 0x00, sizeof(buf1));
        memset(buf2, 0x00, sizeof(buf2));

        {
            bitlength1 = receive(&format, buf1, sizeof(buf1));
            if (bitlength1 < 0) {
                continue;
            }
            display_status("RECV", bitlength1);
            display_data(buf1, bitlength1);
            display_format(format);
        }

#if TEST_LOOP_BACK
        wait_ms(100);

        {
            bitlength1 = transmit(format, buf1, bitlength1);
            if (bitlength1 < 0) {
                continue;
            }
            display_status("TRAN", bitlength1);
            display_data(buf1, bitlength1);
            display_format(format);
        }

        wait_ms(100);

        {
            bitlength2 = receive(&format, buf2, sizeof(buf2));
            if (bitlength2 < 0) {
                continue;
            }
            display_status("RECV", bitlength2);
            display_data(buf2, bitlength2);
            display_format(format);
        }

        wait_ms(100);

        {
            for (int i = 0; i < sizeof(buf1); i++) {
                if (buf1[i] != buf2[i]) {
                    display_status("CPERR", bitlength2);
                    wait(1);
                    continue;
                }
            }
        }
#endif
    }
}