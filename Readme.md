## Flutter setup

**Step 1: Install Flutter SDK**

https://docs.flutter.dev/install/manual

Download the flutter sdk and extract it to a desired location on your machine. Add the flutter tool to your path. (environemental variables for flutter cli to work)

**Step 2: Setup android sdk**

You dont need complete android studio installation. You can just install the command line tools and set up the sdk.

https://developer.android.com/studio#command-line-tools-only

Download the command line tools and extract it to a desired location on your machine. Add the sdk tools to your path. (environemental variables for android sdk cli to work)

Run flutter commands to config this android sdk

`flutter config --android-sdk <path-to-android-sdk>`

`flutter doctor --android-licenses`

All set

Now you have a working flutter sdk and android sdk setup. You can now run flutter commands to create and run your flutter apps.

This way you can use yor physical android device and enable usb debugging via developer options to run your flutter apps on your device.Instead of getting overhelmed by the android studio timely updates and downloads that exhausts you mobile data (Atleast for me "I am still a 4G guy")

## Flutter setup for emulator without install android studio

Folder Paths to set

---

C:\AndroidSDK\cmdline-tools\latest\bin
C:\Program Files\Java\jdk-17\bin
C:\AndroidSDK\emulator

Add ANDROID_HOME=C:\AndroidSDK

as a new variable in System Variables

Commands to run

---

sdkmanager "platform-tools" "platforms;android-36" "build-tools;36.0.0" "emulator" "system-images;android-36;google_apis;x86_64"

sdkmanager --licenses

avdmanager create avd -n MyAVD -k "system-images;android-36;google_apis;x86_64"

emulator -list-avds

emulator -avd MyAVD

## wireless debugging setup

developer options -> wireless debugging -> pair device with pairing code

then in your terminal run

```powershell

adb pair <ip-address>:<port>
```

then enter the pairing code you see on your device and then run

```powershell

adb connect <ip-address>:<port>
```

Done now you can run your flutter apps on your device wirelessly without any usb cable. (Make sure your device and your computer are on the same network (wifi /hotspot)).