<p align="center">
  <img src="https://github.com/deathblade666/flutter_launcher/blob/3d5efb56d8d912cf97836d1730d918bf92aa29d2/android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png">
</p>

# flutter_launcher

Unname as of yet, this flutter project is an android launcher. The idea is to have a modern, minimalistic UI without compromising on access to data when you need it. Inspired by [KISS](https://github.com/Neamar/KISS/) and [Kvaesitso](https://github.com/MM2-0/Kvaesitso).

## Features

### Current
 - Search and launch apps via return or tapping on the list item
 - Use your preferred search engine from your home screen
 - Navigate to a site directly from your home screen
 - Set Favorites for quick access (currently up to 4)
 - Modular UI, only show the UI elements you need/want
 - 3 Custom Widgets
   - Calendar
   - Tasks
   - Notes

### In Progress
List of features that I'm actively working on implementing
 - Set custom Gesture controls
   - Current plan is just for right and left swipe, but could expand as development continues
- Re-order Widgets
  - The ability to set a custom order to the custom widgets.
- Re-implement Settings
  - ~~due to some reliability issues with the long press I'll be looking to moving Settings.~~ 
  - This is to be reviewed as the issue should now be fixed but moving the settings menu may provider better UX
- Modular Code
  - No user fracing stuff here but plan on reorganizing the code base where everything that could be standalone is
 - [x] ~~Pinning Favorites~~
   - ~~Currently when you pin a favorite it populates all four fields, this will be fixed in the future~~
 - [x] ~~Widget support~~
   - ~~Seems native widgets are a bit out of the question (cant find any resources on how to implemnt) so designing some custom ones~~

### Planned
- Improved Search query for matching apps
- Change amount of favorites to be more dynamic

### Future
This is a list of feature that I hope to accomplish but currently do not have the knowledge to do so
- WebCal?
- Dynamic Date
  - have the date widget change depending factors such as, if media is play change to media controls
- Native Widget Support (on back burner for now)

## Build

``
git clone https://github.com/deathblade666/flutter_launcher
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

``cd`` to the directory you cloned to.

run ``flutter build apk``

## Showcase

|Home screen | Favorites | Widget Pane |
|--|--|--|
| ![alt](https://github.com/deathblade666/flutter_launcher/blob/ff093da368df531a681971d2554e0317e3613f6c/screenshots/Screenshot%20from%202024-09-18%2014-40-34.png)|![alt](https://github.com/deathblade666/flutter_launcher/blob/78c59e7e86f6e0871a92862655a66f1970fc4fbf/screenshots/Screenshot%20from%202024-10-01%2019-55-52.png)|![alt](https://github.com/deathblade666/flutter_launcher/blob/a054e8bca7eca378aa405f4b28598edd9a0fde42/screenshots/Screenshot%20from%202024-10-01%2019-46-19.png) |

## Widgets

|Tasks|Calendar|Notes|
|--|--|--|
| ![alt](https://github.com/deathblade666/flutter_launcher/blob/a054e8bca7eca378aa405f4b28598edd9a0fde42/screenshots/Screenshot%20from%202024-10-01%2019-46-33.png)| ![alt](https://github.com/deathblade666/flutter_launcher/blob/a054e8bca7eca378aa405f4b28598edd9a0fde42/screenshots/Screenshot%20from%202024-10-01%2019-46-37.png)|![alt](https://github.com/deathblade666/flutter_launcher/blob/a054e8bca7eca378aa405f4b28598edd9a0fde42/screenshots/Screenshot%20from%202024-10-01%2019-46-42.png)|


## Default Flutter README Stuff
This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
