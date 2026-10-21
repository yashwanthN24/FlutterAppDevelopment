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

