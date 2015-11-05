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
  
  runShellCmd("logger -t arduino discovering mothership...");
  rv = discoverMothership();
  
  if (rv != 0) {
    runShellCmd("logger -t arduino failure");
    flashErrorInfinitely();
  }
  else {
    runShellCmd("logger -t arduino success");
    flashFor(grnLedPin, ms);
    delay(ms);
    flashFor(grnLedPin, ms);
    delay(ms);
  }

  runShellCmd("logger -t arduino posting ifconfig...");
  rv = postIfconfig();
  
  if (rv != 0) {
    runShellCmd("logger -t arduino failure");
    flashErrorInfinitely();
  }
  else {
    runShellCmd("logger -t arduino success");
    flashFor(grnLedPin, ms);
    delay(ms);
    flashFor(grnLedPin, ms);
    delay(ms);
    flashFor(grnLedPin, ms);
    delay(ms);
  }

  digitalWrite(grnLedPin, HIGH);
}

void flashErrorInfinitely() {
  int ms = 50;
  while(true) {
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

int discoverMothership() {
  return runShellCmd("nslookup mothership.alxb.us");
}

int postIfconfig() {
  return runShellCmd("ifconfig | tr '\n' '$' > /root/ifconfig.txt && curl -XPOST mothership.alxb.us:8889/arduino -d @/root/ifconfig.txt ; rm -f /root/ifconfig.txt");
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
