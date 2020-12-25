# mirror media app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Running cli

### debug mode
- flutter run --flavor dev lib/main_dev.dart
- flutter run --flavor prod lib/main_prod.dart

### release mode
- flutter run --flavor dev --release lib/main_dev.dart
- flutter run --flavor prod --release lib/main_prod.dart
 
### generate release archive
 - flutter build appbundle --flavor prod lib/main_prod.dart
 - flutter build ios --flavor prod lib/main_prod.dart