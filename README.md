# Precise Clock

A simple Android app that shows the current time to high precision based on the
local device clock. APK files can be found under releases.

## Build it yourself

After downloading the Flutter SDK, build from source using:

```shell
flutter build apk --target-platform android-arm64
```

While the only supported platform out-of-the-box is Android, support for other
platforms can be added by generating the necessary project files in Flutter. To
add a platform, run the following command with the desired platforms included:

```shell
flutter create --platforms=ios, web, linux, windows, macos .
```
