# Quotes App

A Flutter quote viewer built around a clean layered structure with routing, state management, repository access, and local persistence.

## What is included

This version of the app now includes:

- Splash flow and router-based navigation
- Home screen with a random quote fetch flow
- Quotes list screen with quote cards and detail navigation
- Quote detail screen with favorite toggle support
- Favorites screen for saved quotes
- Recent quote cache + favorites persistence using local storage
- Typed repository/service separation for cleaner app architecture

## How to Run

1. Make sure Flutter is installed
2. Open the project folder
3. Run `flutter pub get`
4. Run `flutter run`

## Main Packages

- `flutter_bloc` for state-driven screen behavior
- `equatable` for immutable state comparison
- `go_router` for typed route handling
- `http` for remote API requests
- `shared_preferences` for recent quote caching
- `flutter_secure_storage` for favorites persistence

## App Flow

- `main.dart` starts the app and configures the router
- `quote_repository.dart` provides the repository contract
- `quote_service.dart` handles the DummyJSON remote calls
- `quote_storage_service.dart` stores favorite quotes and recent cache locally
- `home_screen.dart` and `quotes_list_screen.dart` present quote data through Cubit state layers
- `quote_detail_screen.dart` allows interaction with favorites and stores recent viewing history
- `favorites_screen.dart` shows the saved favorites list

## API Source

The app uses the DummyJSON Quotes API:

- `GET /quotes/random`
- `GET /quotes?limit=20&skip=0`

## Project Structure

```text
lib/
  main.dart
  app/
    router.dart
  core/
    errors/
      quote_failure.dart
  models/
    quote.dart
  presentation/
    cubit/
      quote_cubit.dart
      quote_list_cubit.dart
  screens/
    splash_screen.dart
    main_screen.dart
    home_screen.dart
    quotes_list_screen.dart
    quote_detail_screen.dart
    favorites_screen.dart
  services/
    quote_repository.dart
    quote_service.dart
    quote_storage_service.dart
```

## Notes

- The app now follows a simple repository → service → UI structure
- Favorite quotes are persisted locally
- Recent quote history is cached for quick access
- The project is structured to support a small onboarding-style architecture walkthrough
