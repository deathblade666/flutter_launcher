# flutter_launcher

Unname as of yet, this flutter project is an android launcher. The idea is to have a modern, minimalistic UI without compromising on access to data when you need it. Inspired by KISS and Kvaesitso.

## Current features
 - Search and launch apps via return or tapping on the list item
 - Use your preferred search engine from your home screen
 - Navigate to a site directly from your home screen
 - Set Favorites for quick access (currently up to 4)
 - Modular UI, only show the UI elements you need/want

## Featurs in Progress
List of features that I'm actively working on implementing
 - Pinning Favorites 
   - Currently when you pin a favorite it populates all four fields, this will be fixed in the future
 - Set custom Gesture controls
   - Current plan is just for right and left swipe, but could expand as development continues

## Future Feaures
This is a list of feature that i hope to accomplish but currently do not have the knowledge to do so

 - Widget support

## ShowCase - Coming soon!

| | | |
|--|--|--|
| | | |

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
