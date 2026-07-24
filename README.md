# Quotes App

A Flutter application that displays inspirational quotes using the DummyJSON Quotes API. The project now also reflects a more structured onboarding-style architecture with state management, dependency injection, routing, and local storage support.

## How to Run

1. Make sure you have Flutter installed
2. Clone the repository
3. Run `flutter pub get`
4. Run `flutter run` to launch the app on your connected device or emulator

## Flutter Version & Packages

- **Flutter**: 3.44.4
- **Dart**: 3.12.2
- **Main packages**:
  - `flutter_bloc` - State management with Cubit
  - `go_router` - Navigation and route handling
  - `shared_preferences` - Simple local storage for cached data and favorites
  - `http` - API requests
  - `cupertino_icons` - Default icon pack

## Features

- **Splash Screen**: Animated entry experience before the app opens
- **Home Screen**: Displays a random quote with loading, retry, cached fallback, and typed error messaging
- **Quotes List Screen**: Shows quote cards with refresh support, loading and error handling, and navigation to detail view
- **Quote Detail Screen**: Displays a quote in full view and supports favorite storage
- **Offline-friendly behavior**: Cached quote data can be shown if the network request fails
- **Week 2/3 onboarding feature**: Added a reactive state flow using Cubit and BLoC patterns, with explicit failure types for timeouts, server issues, and network problems

## App Architecture

The app now follows a cleaner structure with separate responsibilities:

- **Repository layer** for quote data access
- **Cubit layer** for reactive UI state and failure handling
- **Storage service** for cached quotes and favorites
- **Router setup** for screen navigation
- **Typed failure model** for clearer UI feedback and more resilient onboarding-style testing

## API

All data is fetched from [DummyJSON Quotes API](https://dummyjson.com/docs/quotes):

- `GET /quotes/random` - Random quote for the home screen
- `GET /quotes?limit=30&skip=0` - List of quotes
- `GET /quotes/{id}` - Quote detail fetch

## Project Structure

```text
lib/
  main.dart                    - App entry point and provider setup
  router.dart                  - App routing configuration
  cubits/                      - Cubit state management for quotes
  repositories/                - Repository abstraction and implementation
  services/                    - Storage and other app services
  screens/                     - Splash, home, list, and detail screens
  models/                      - Quote data model
  widgets/                     - Reusable UI components
```

## Roadmap Status

The onboarding roadmap is now considered fully complete for the current app scope:

- Clean architecture split between screens, state, repositories, services, and models
- Dependency injection via repository providers and storage injection
- Reactive state management with Cubit and BLoC
- Route-based navigation with a splash flow and deep-link support
- Persistent favorite storage and favorites-list navigation
- Searchable quote list and resilient offline fallback behavior
- Automated tests and analyzer-based validation

## Notes

- The app is designed to be more maintainable and easier to extend for onboarding-style learning
- Some features now use cached data when the network is unavailable
- The current setup is focused on learning, architecture clarity, clean UI state flow, and stronger test coverage
