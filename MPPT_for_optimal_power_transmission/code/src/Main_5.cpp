#include <Arduino.h>

// Define the pins for sensing voltage and current
const int voltageInputPin = A1; // Analog pin used to monitor PV module voltage
const int currentInputPin = A8; // Analog pin used to monitor PV module current
const int currentOutputMonitorPin = A5; // Analog pin used to monitor output current (IMON)
const int currentControlPin = A4; // DAC output pin to control the converter (ICTRL)

// Constant voltage output
const double outputVoltage = 3.3; // The voltage output is always 3.3V

// Variables to store the last and current measurements
double lastInputPower = 0.0;
bool increaseCurrent = true; // Direction of last perturbation, true for increase, false for decrease

// Set the initial control voltage for ICTRL
double controlVoltage = 0.5; // Start with a 0.5V which should be mid-range of current control

// Perturbation size for the control voltage (fine-tune this value based on your system's response)
const double perturbationSize = 0.01; // This is a small perturbation size for control voltage

void setup() {
  Serial.begin(9600);
  pinMode(currentControlPin, OUTPUT);
  analogWriteResolution(10); // Set the DAC resolution to 10-bit
}

void perturbCurrentControl() {
  // Adapted to perturb the control voltage rather than the duty cycle
  if (increaseCurrent) {
    controlVoltage += perturbationSize;
  } else {
    controlVoltage -= perturbationSize;
  }

  // Constrain the control voltage to valid range (0 to 1V)
  controlVoltage = constrain(controlVoltage, 0.0, 1.0);

  // Convert the control voltage to a DAC value (10-bit resolution with 3.3V reference)
  int dacValue = (int)(controlVoltage * 1023.0 / 3.3);

  // Write the DAC value to the ICTRL pin
  analogWrite(currentControlPin, dacValue);
  
  // Add a delay for stability and give time for the voltage to settle
  delay(1000);
}


// Function to read the input voltage from the PV module
double readVoltage(int pin) {
  int sensorValue = analogRead(pin);
  return sensorValue * (3.3 / (1023.0*0.128));
}

// Function to read the input current from the PV module
double readCurrent(int pin) {
  int sensorValue = analogRead(pin);
  return sensorValue * (3.3 / 1023.0);
}

// Function to calculate power from voltage and current
double calculatePower(double voltage, double current) {
  return voltage * current;
}


double readOutputCurrent(int pin) {
  int sensorValue = analogRead(pin); // Read the analog value from IMON pin
  double voltage = sensorValue * (3.3 / 1023.0); // Convert the value to voltage assuming a 3.3V ADC reference
  double current = voltage / 0.4; // Convert the IMON voltage to current
  return current; // Return the current
}

void loop() {
  // Read the current input voltage and current from the PV module
  double inputVoltage = readVoltage(voltageInputPin);
  double inputCurrent = readCurrent(currentInputPin);

  // Calculate the current input power
  double currentInputPower = calculatePower(inputVoltage, inputCurrent);

  // Decide whether to increase or decrease the control voltage
  if (currentInputPower > lastInputPower) {
    // If the power has increased, keep perturbing in the same direction
    controlVoltage += (increaseCurrent ? perturbationSize : -perturbationSize);
  } else if (currentInputPower < lastInputPower) {
    // If the power has decreased, change the perturbation direction
    controlVoltage += (increaseCurrent ? -perturbationSize : perturbationSize);
    increaseCurrent = !increaseCurrent; // Toggle the direction for the next iteration
  }
  // No else case needed for currentInputPower == lastInputPower as no change is needed

  // Ensure controlVoltage stays within the 0 to 1V range
  controlVoltage = constrain(controlVoltage, 0.0, 1.0);

  //int dacvalue_2 = 1 * 1023.0 / 3.3;
  // Convert controlVoltage to the appropriate DAC value
  int dacValue = (int)(controlVoltage * 1023.0 / 3.3); // Adjust for 3.3V scale to DAC scale
  analogWrite(currentControlPin, dacValue);
  //analogWrite(currentControlPin, dacvalue_2);
  // Read and display the output current for monitoring purposes
  double outputCurrent = readOutputCurrent(currentOutputMonitorPin);

  // Optionally print current readings to the Serial monitor for debugging
  Serial.print("Input Voltage: "); Serial.println(inputVoltage);
  Serial.print("Input Current: "); Serial.println(inputCurrent);
  Serial.print("Input Power: "); Serial.println(currentInputPower);
  Serial.print("Control Voltage: "); Serial.println(controlVoltage);
  Serial.print("Output Current: "); Serial.println(outputCurrent);

  // Update the lastInputPower for the next loop iteration
  lastInputPower = currentInputPower;

  // Add a short delay to allow for physical changes to take effect and stabilize
  delay(1000);
}

















// ========================================



// #include <Arduino.h>

// // Define the pins for sensing voltage and current
// const int voltageInputPin = A1; // Analog pin used to monitor PV module voltage
// const int currentInputPin = A8; // Analog pin used to monitor PV module current
// const int currentOutputMonitorPin = A5; // Analog pin used to monitor output current (IMON)
// const int currentControlPin = A4; // DAC output pin to control the converter (ICTRL)

// // Constant voltage output
// const double outputVoltage = 3.3; // The voltage output is always 3.3V

// // Variables to store the last and current measurements
// double lastInputPower = 0.0;
// bool increaseCurrent = true; // Direction of last perturbation, true for increase, false for decrease

// // Set the initial control voltage for ICTRL
// double controlVoltage = 0.5; // Start with a 0.5V which should be mid-range of current control

// // Perturbation size for the control voltage (fine-tune this value based on your system's response)
// const double perturbationSize = 0.01; // This is a small perturbation size for control voltage

// const int cell_voltage;

// // Function to read the output current based on IMON pin voltage
// double readOutputCurrent(int pin) {
//   int sensorValue = analogRead(pin); // Read the analog value from IMON pin
//   double voltage = sensorValue * (3.3 / 1023.0); // Convert the value to voltage assuming a 3.3V ADC reference
//   double current = voltage / 0.4; // Convert the IMON voltage to current
//   return current; // Return the current
// }

// // Function to read the input voltage from the PV module
// double readVoltage(int pin) {
//   int sensorValue = analogRead(pin); // Read the analog value from voltage sensing pin
//   double voltage = sensorValue * (3.3 / 1023.0); // Convert the value to voltage assuming a 3.3V ADC reference
//   // Include any necessary scaling factor if your voltage sensor requires it
//   return voltage;
// }

// // Function to read the input current from the PV module
// double readCurrent(int pin) {
//   int sensorValue = analogRead(pin); // Read the analog value from current sensing pin
//   double voltage = sensorValue * (3.3 / 1023.0); // Convert the value to voltage assuming a 3.3V ADC reference
//   // Include any necessary scaling factor if your current sensor requires it
//   double current = voltage; // Assuming 1V = 1A for illustration, replace with your actual conversion
//   return current;
// }

// // Function to calculate power from voltage and current
// double calculatePower(double voltage, double current) {
//   return voltage * current;
// }

// // Function to perturb the control voltage for the ICTRL pin
// void perturbCurrentControl() {
//   // This function has been adapted to perturb the control voltage rather than the duty cycle
//   if (increaseCurrent) {
//     controlVoltage += perturbationSize; // Increase the control voltage to increase the current
//   } else {
//     controlVoltage -= perturbationSize; // Decrease the control voltage to decrease the current
//   }
  
//   // Constrain the control voltage to valid DAC range (0 to 1V for the ICTRL pin)
//   controlVoltage = constrain(controlVoltage, 0.0, 1.0);

//   // Convert the control voltage to a DAC value (assuming 10-bit DAC)
//   int dacValue = (int)(controlVoltage / 1.0 * 1023);
//   analogWrite(currentControlPin, dacValue);

//   delay(1000);
// }

// void setup() {
//   Serial.begin(9600);
//   analogWriteResolution(10); // Set the DAC resolution (if you want to use a different resolution, change this value)
//   pinMode(currentControlPin, OUTPUT);
//   // Additional setup code if needed
// }

// int i;

// void loop() {
  
//   i += 0.1;

//   // Sense the input voltage and current
//   double inputVoltage = readVoltage(voltageInputPin);
//   double inputCurrent = readCurrent(currentInputPin);
  


//   // Calculate the input power
//   double inputPower = inputVoltage * inputCurrent;
  
//   // MPPT Algorithm: Perturb the current control voltage and observe the effect on input power
//   double lastControlVoltage = controlVoltage;
//   if (inputPower > lastInputPower) {
//     // If input power has increased, perturb the control voltage in the same direction
//     controlVoltage += (increaseCurrent ? perturbationSize : -perturbationSize);
//   } else {
//     // If input power has decreased, perturb the control voltage in the opposite direction
//     controlVoltage += (increaseCurrent ? -perturbationSize : perturbationSize);
//     increaseCurrent = !increaseCurrent; // Change the direction for the next perturbation
//   }

  
//   // Constrain the control voltage to the valid range for ICTRL (0 to 1V)
//   controlVoltage = constrain(controlVoltage, 0.0, 1.0);

//   // cell_voltage = map(voltageInputPin, 0, 2882, 0, 22000);

//   // Convert the control voltage to a DAC value (assuming 10-bit DAC)
//   int dacValue = (int)(controlVoltage / 1.0 * 1023);
//   analogWrite(currentControlPin, dacValue);

//   // Measure the output current
//   double outputCurrent = readOutputCurrent(currentOutputMonitorPin);
  
//   // Calculate the output power (constant voltage output)
//   double outputPower = outputCurrent * outputVoltage;

//   Print the values for debugging

//   Serial.print("Input Voltage: ");
//   Serial.print(inputVoltage);
//   Serial.print(" V, Input Current: ");
//   Serial.print(inputCurrent);
//   Serial.print(" A, Input Power: ");
//   Serial.print(inputPower);
//   Serial.print(" W, Control Voltage: ");
//   Serial.print(controlVoltage);
//   Serial.print(" V, Output Current: ");
//   Serial.print(outputCurrent);
//   Serial.print(" A, Output Power: ");
//   Serial.print(outputPower);
//   Serial.println(" W");


//   Serial.print(">time:");
//   Serial.println(millis());
//   Serial.print(">sin:");
//   Serial.println(sin(i));
//   Serial.print(">cos:");
//   Serial.println(cos(i));


//   // Plotting
//   Serial.print("loop");
//   Serial.println(cos(i));
  
//   // Plot a sinus
//   Serial.print(">sin:");
//   Serial.println(sin(i));

//   // Plot a cosinus
//   Serial.print(">cos:");
//   Serial.println(cos(i));



//   // Update the last input power for the next iteration
//   lastInputPower = inputPower;

//   // Delay for stability
//   delay(1000);

// }

// // #include <Arduino.h>

// // void setup() {
// //   Serial.begin(115200);
// //   // Print log
// //   Serial.println("setup");
// // }

// // float i=0;
// // void loop() {
// //   i+=0.1;

// //   // Print log
// //   Serial.print("loop");
// //   Serial.println(i);
  
// //   // Plot a sinus
// //   Serial.print(">sin:");
// //   Serial.println(sin(i));

// //   // Plot a cosinus
// //   Serial.print(">cos:");
// //   Serial.println(cos(i));
    
// //   delay(300);
// // }

