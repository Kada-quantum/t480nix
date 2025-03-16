{
  inputs,
  pkgs,
}:
pkgs.wrapArduinoCLI
{
  libraries = with inputs.arduino-nix;
  with arduinoLibraries; [
    (latestVersion arduinoLibraries."Heltec ESP32 Dev-Boards")
    (latestVersion arduinoLibraries."Heltec_ESP32_LoRa_v3")
  ];

  packages = with inputs.arduino-nix;
  with arduinoPackages; [
    (latestVersion platforms.arduino.avr)
    (latestVersion platforms.Heltec-esp32.esp32)
    (latestVersion platforms.Maixduino.k210)
  ];
}
