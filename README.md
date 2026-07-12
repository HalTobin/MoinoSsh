# MoinoSSH

Simple app to connect to a remote server through SSH and manage it with very basic sysadmin tools.

## Features
The app currently have the following tools:
- Systemd services management
- File explorer based on SFTP protocol (WIP)
- Reading and editing text files (WIP)

### Warning
The application is still in active development and is not ready yet.

## About this project

This project is made with Flutter/Dart, and targets:
- Windows
- MacOS
- Linux
- Android
- iOS

### Libraries

This project works thanks to these libraries:
- [lucide-icons](https://github.com/lucide-icons/lucide)
- [lucide-flutter](https://github.com/vqh2602/lucide-flutter-main)
- [dynamic_color](https://pub.dev/packages/dynamic_color)
- [provider](https://pub.dev/packages/provider)
- [path_provider](https://pub.dev/packages/path_provider)
- [file_picker](https://pub.dev/packages/file_picker)
- [dartssh2](https://pub.dev/packages/dartssh2)
- [encrypt](https://pub.dev/packages/encrypt/versions)
- [pointycastle](https://pub.dev/packages/pointycastle)
- [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage)
- [shared_preferences](https://pub.dev/packages/shared_preferences)
- [drift](https://pub.dev/packages/drift)
- [collection](https://pub.dev/packages/collection)
- [url_launcher](https://pub.dev/packages/url_launcher)

## Getting Started

### Configuration

Run this command when opening the project for the first time or when updating database:
```dart run build_runner build```
