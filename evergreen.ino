#include <Process.h>
#include "evergreen.h"

const int redButtonPin = 4;
const int bluButtonPin = 2;
const int redLedPin    = 8;
const int bluLedPin    = 7;
const int grnLedPin    = 13;

int currBlu = 0;
int currRed = 0;

#define DEBUG_MASK(n, m) \
    Serial.print(n); \
    Serial.print(": 0b"); \
    Serial.print(m, BIN); \
    Serial.print("\n");

tyme last_seq_change;
tyme curr_time;
btn_mask btn_seq     = 0b0000000000000000;

void setup() {
    int rv;
    int ms = 100;
    flashFor(grnLedPin, ms);

    Bridge.begin();
    Serial.begin(9600);
    setupPins();

    runShellCmd("logger -t arduino booting evergreen...");
    /*rv = bootEvergreen();*/

    if (rv != 0) {
        runShellCmd("logger -t arduino failure");
        flashErrorInfinitely(rv);
    }
    else {
        runShellCmd("logger -t arduino success");
    }

    digitalWrite(grnLedPin, HIGH);
}

void flashErrorInfinitely(int n) {
    while(true) {
        flashNTimes(n);
        delay(700);
    }
}

void flashNTimes(int n) {
    int ms = 150;
    for (int i = 0; i < n; i++) {
        flashFor(grnLedPin, ms);
        delay(ms);
    }
}

void flashFor(int pin, int ms) {
    digitalWrite(pin, HIGH);
    delay(ms);
    digitalWrite(pin, LOW);
}

void setupPins() {
    pinMode(redLedPin, OUTPUT);
    pinMode(bluLedPin, OUTPUT);
    pinMode(grnLedPin, OUTPUT);
    pinMode(redButtonPin, INPUT);
    pinMode(bluButtonPin, INPUT);
}

/*int bootEvergreen() {*/
/*return runShellCmd("curl -k https://raw.githubusercontent.com/alexebird/evergreen/master/bin/evergreen.sh | ash > /tmp/log/boot.log 2>&1");*/
/*}*/

int runShellCmd(String str) {
    Process p;
    int rv = p.runShellCommand(str);
    char c;

    while (p.available() > 0) {
        c = p.read();
        Serial.print(c);
    }

    Serial.flush();
    return rv;
}

void loop() {
    currBlu = digitalRead(bluButtonPin);
    currRed = digitalRead(redButtonPin);

    writeLighting(currBlu, currRed);

    /*Serial.print("--------\n");*/
    btn_seq = handleBtns(btn_seq, currBlu, currRed);
    /*DEBUG_MASK("seq", btn_seq);*/
    /*Serial.print("\n\n");*/

    delay(200);
}

void printButtonChange(btn_mask mask) {
    if (mask == (BLU_MASK | RED_MASK)) {
        Serial.println("both down");
    }
    else if (mask == BLU_MASK) {
        Serial.println("blu down");
    }
    else if (mask == RED_MASK) {
        Serial.println("red down");
    }
}

/*
 * the ignore mask is for ignoring curr_mask changes.
 */
btn_mask ignore_mask = 0b00;

btn_mask handleBtns(btn_mask seq, int currBlu, int currRed) {
    btn_mask curr_mask = MK_MASK(currBlu, currRed);
    DEBUG_MASK("curr_mask", curr_mask);
    DEBUG_MASK("seq", seq);

    /*if (curr_mask == 0) {*/
        /*return seq;*/
    /*}*/

    if (!SEQ_MATCH(seq, curr_mask)) {
        printButtonChange(curr_mask);
        seq = SEQ_PUSH(seq, curr_mask);
        DEBUG_MASK("seq", seq);
        /*last_seq_change = millis();*/
    }
    /*else {*/
        /*curr_time = millis();*/
        /*if ((curr_time - last_seq_change) > HOLD_DOWN_MILLIS) {*/
            /*Serial.println("2 sec");*/
            /*//seq = SEQ_PUSH(seq, curr_mask);*/
            /*seq = SEQ_PUSH(seq, HOLD_DOWN_MASK);*/
        /*}*/
    /*}*/

    /*seq = btn_seq_action(seq, curr_mask);*/

    return seq;
}

btn_mask btn_seq_action(btn_mask seq, btn_mask mask) {
    /*for (int i = 0 ; i < size(foo); i ++) {*/
    /*}*/
    /*flashNTimes(3);*/
    /*digitalWrite(grnLedPin, HIGH);*/
    return seq;
}

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
}

void runNcat(String payload) {
    Serial.println(payload);
    Process p;
    // are Strings GC'd?
    p.runShellCommand("echo -n " + payload + " | ncat --send-only -u localhost 8888");
    //Asynchronously
}

/* vim: set expandtab ts=4 sw=4 ai : */
