# flutter_launcher

A new Flutter project.

## Getting Started

``
git clone https://gitbhub.com/deathblade666/flutter_launcher
``

``
cd flutter_launcher
``

``
flutter pub get
``

### Update installed_apps (dep) compilSDK

``
cd ~/.pub-cache/hosted/pub.dev/installed_apps-1.5.0/android
``

``
vim build.gradle
``

Change compileSDK from 30 to 34
save and exit

### Build

1. ``cd`` to the directory you cloned to.
2. run ``flutter build apk``


This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
