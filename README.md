# Railway-turntable-controller

Can be used to Controll a turntable for a model train.

## Usage

1. Connect to Table vie BLE
2. Add Tracks in App
3. Tab on Track you want the main track to point at
4. App sends Angle to device
   * If angle is below zero turn left else right
   * Angle is alsways between 0° and 180°
6. Device sends current angle of main track repeatedly

![OVERVIEW](https://user-images.githubusercontent.com/61799454/166105521-a509abd4-6a7d-44bb-a94d-fa2c47ca06c8.png)
