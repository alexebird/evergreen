#include <Process.h>

const int redButtonPin = 4;
const int bluButtonPin = 2;
const int redLedPin    = 8;
const int bluLedPin    = 7;
const int grnLedPin    = 13;

unsigned long time;
int redButtonRawValue = 0;
int bluButtonRawValue = 0;

void setup() {
  int rv;
  int ms = 100;
  flashFor(grnLedPin, ms);

  Bridge.begin();
  Serial.begin(9600);
  setupPins();

  runShellCmd("logger -t arduino booting evergreen...");
  rv = bootEvergreen();
  
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
   delay(500);
  }
}

void flashNTimes(int n) {
  int ms = 50;
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

int bootEvergreen() {
  return runShellCmd("curl -k https://raw.githubusercontent.com/alexebird/evergreen/master/bin/evergreen.sh | ash");
}

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
  redButtonRawValue = digitalRead(redButtonPin);
  bluButtonRawValue = digitalRead(bluButtonPin);

  if (redButtonRawValue == HIGH) {
    digitalWrite(redLedPin, HIGH);
  }
  else {
    digitalWrite(redLedPin, LOW);
  }

  if (bluButtonRawValue == HIGH) {
    digitalWrite(bluLedPin, HIGH);
  }
  else {
    digitalWrite(bluLedPin, LOW);
  }

  if (bluButtonRawValue == HIGH && redButtonRawValue == HIGH) {
    runNcat("BR");
  }
  else if (bluButtonRawValue == HIGH && redButtonRawValue == LOW) {
    runNcat("Br");
  }
  else if (bluButtonRawValue == LOW && redButtonRawValue == HIGH) {
    runNcat("bR");
  }
  else if (bluButtonRawValue == LOW && redButtonRawValue == LOW) {
    runNcat("br");
  }

  delay(1);
}

void runNcat(String payload) {
  Serial.println(payload);
  Process p;
  // are Strings GC'd?
  p.runShellCommand("echo -n " + payload + " | ncat --send-only -u mothership.alxb.us 8888");
  //Asynchronously
}
