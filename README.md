# Precise Clock

Shows the current time to high precision based on the local device clock.

After downloading the Flutter SDK, build using:

```shell
flutter build apk --target-platform android-arm64
```

While the only currently supported platform out-of-the-box is Android, support
for other platforms can be added by generated the necessary project files in
Flutter. To add a platform, run the following command with the desired platforms
included.

```shell
flutter create --platforms=ios, web, linux, windows, macos .
```
