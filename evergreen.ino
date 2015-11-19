#include <Process.h>
#include "evergreen.h"

const int bluButtonPin = 4;
const int redButtonPin = 2;
/*const int dbgButtonPin = 12;*/
const int bluLedPin    = 7;
const int redLedPin    = 9;
const int dbgLedPin    = 13;

int currBlu = 0;
int currRed = 0;
int currDbg = 0;

boolean detected = false;

#define DEBUG_MASK(n, m) \
    Serial.print(n); \
    Serial.print(": 0b"); \
    Serial.print(m, BIN); \
    Serial.print("\n");

tyme last_seq_change;
tyme curr_time;
btn_mask btn_seq = 0b0000000000000000;

void setup() {
    Bridge.begin();
    Serial.begin(9600);
    setupPins();
    flashOnce(dbgLedPin, 1000);
}

void setupPins() {
    pinMode(redLedPin, OUTPUT);
    pinMode(bluLedPin, OUTPUT);
    pinMode(dbgLedPin, OUTPUT);
    pinMode(redButtonPin, INPUT);
    pinMode(bluButtonPin, INPUT);
    /*pinMode(dbgButtonPin, INPUT);*/
}

void flashOnce(int pin, int ms) {
    digitalWrite(pin, HIGH);
    delay(ms);
    digitalWrite(pin, LOW);
}

/*int lastDbg;*/

void loop() {
    currBlu = digitalRead(bluButtonPin);
    currRed = digitalRead(redButtonPin);
    /*currDbg = digitalRead(dbgButtonPin);*/

    /*if (currDbg == LOW && lastDbg == HIGH) {*/
        /*Serial.println("debug");*/
        /*runShellCmd("/root/debug.sh");*/
    /*}*/
    /*lastDbg = currDbg;*/

    writeLighting(currBlu, currRed);

    btn_seq = handleBtns(btn_seq, currBlu, currRed);

    /*delay(2);*/
}

/*void writeLighting(int currBlu, int currRed, int currDbg) {*/
void writeLighting(int currBlu, int currRed) {
    if (currBlu == HIGH) {
        digitalWrite(bluLedPin, HIGH);
    }
    else {
        digitalWrite(bluLedPin, LOW);
    }

    if (currRed == HIGH) {
        digitalWrite(redLedPin, HIGH);
    }
    else {
        digitalWrite(redLedPin, LOW);
    }

    /*if (currDbg == HIGH) {*/
        /*digitalWrite(dbgLedPin, LOW);*/
    /*}*/
    /*else {*/
        /*digitalWrite(dbgLedPin, HIGH);*/
    /*}*/
}

void print_seq(btn_mask seq) {
    Serial.print("seq: ");
    int mask = 0;
    for (int i = 1; i <= (BTN_MASK_SIZE / MASK_WIDTH); i++) {
        mask = (seq >> (BTN_MASK_SIZE - (MASK_WIDTH * i))) & 0b1111;
        if (mask < 0b10) {
            Serial.print("000");
        }
        else if (mask < 0b100) {
            Serial.print("00");
        }
        else if (mask < 0b1000) {
            Serial.print("0");
        }
        Serial.print(mask, BIN);
        Serial.print(" ");
    }
    Serial.print("\n");
}

btn_mask handleBtns(btn_mask seq, int currBlu, int currRed) {
    btn_mask curr_mask = MK_MASK(currBlu, currRed);

    if (!SEQ_MATCH(SEQ_CLEAR_HOLD_BIT(seq), curr_mask)) {
        detected = false;
        seq = SEQ_PUSH(seq, curr_mask);
        last_seq_change = millis();
    }
    else {
        curr_time = millis();
        if ((curr_time - last_seq_change) > HOLD_DOWN_MILLIS) {
            if (LAST_MASK(seq) != NULL_MASK && (LAST_MASK(seq) & HOLD_MASK) == 0) {
                detected = false;
                seq |= HOLD_MASK;
            }
        }
    }

    if (!detected) {
        btn_seq_action(seq);
    }

    return seq;
}

String curl_api(String path) {
    return  "/bin/ash -c '. /root/evergreen-env.sh ; curl -k -XPOST -H\"Authorization: ${GRPINGPONG_API_KEY}\" ${MOTHERSHIP}/api/" + path + "'";
}

void btn_seq_action(btn_mask seq) {
    if ((seq & MASK_x3) == MASK_BLU_INC_POINT) {
        detected = true;
        Serial.println("blu inc point");
        flashOnce(dbgLedPin, 200);
        runShellCmd(curl_api("scoreboard_games/blue/increment"));
        flashOnce(dbgLedPin, 200);
    }
    else if ((seq & MASK_x4) == MASK_BLU_DEC_POINT) {
        detected = true;
        Serial.println("blu dec point");
        runShellCmd(curl_api("scoreboard_games/blue/decrement"));
    }
    else if ((seq & MASK_x3) == MASK_RED_INC_POINT) {
        detected = true;
        Serial.println("red inc point");
        runShellCmd(curl_api("scoreboard_games/red/increment"));
    }
    else if ((seq & MASK_x4) == MASK_RED_DEC_POINT) {
        detected = true;
        Serial.println("red dec point");
        runShellCmd(curl_api("scoreboard_games/red/decrement"));
    }
    else if (((seq & MASK_x2) == MASK_NEW_GAME1) ||
             ((seq & MASK_x3) == MASK_NEW_GAME2) ||
             ((seq & MASK_x3) == MASK_NEW_GAME3)) {
        detected = true;
        Serial.println("new game");
        runShellCmd(curl_api("scoreboard_games"));
    }
    else if ((seq & MASK_x2) == MASK_DEBUG) {
        detected = true;
        Serial.println("debug");
        runShellCmd("/bin/ash -c '. /root/evergreen-env.sh ; /root/debug.sh'");
        flashOnce(dbgLedPin, 200);
        delay(200);
        flashOnce(dbgLedPin, 200);
    }
}

void runShellCmd(String str) {
    Process p;
    p.runShellCommand(str);
    /*p.runShellCommandAsynchronously(str);*/
    char c;

    while (p.available() > 0) {
        c = p.read();
        Serial.print(c);
    }

    Serial.flush();
}

/* vim: set expandtab ts=4 sw=4 ft=c ai : */
