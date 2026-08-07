# Quotes App - Clean Architecture Implementation

A production-ready Flutter application that displays inspirational quotes using the [DummyJSON Quotes API](https://dummyjson.com/docs/quotes). This project follows **Feature-first Clean Architecture** principles, ensuring scalability and high testability.

## Architecture Overview

The project is organized into layers to ensure a separation of concerns:

- **Domain Layer**: The core of the application. Contains **Entities**, **Repository Interfaces**, and **Use Cases**. It is completely independent of other layers and contains the business logic.
- **Data Layer**: Responsible for data retrieval and persistence. Contains **Models** (Data Transfer Objects), **Repository Implementations**, and **Data Sources** (Remote API via `http` and Local Storage via `shared_preferences`).
- **Presentation Layer**: Handles the UI and State Management. Built with **Jetpack Compose-like declarative UI** in Flutter, using **BLoC/Cubit** for state management and **GoRouter** for navigation.

## Project Structure

```text
lib/
├── features/
│   └── quotes/
│       ├── data/                  # Data layer: Models, Repositories (Impl), DataSources
│       ├── domain/                # Domain layer: Entities, Repository (Interfaces), Failures, UseCases
│       └── presentation/          # Presentation layer: Screens, Widgets, Blocs/Cubits
├── injection_container.dart       # Explicit Dependency Injection (DI) Container
├── main.dart                      # App entry point & DI Initialization
├── router.dart                    # Centralized Routing (go_router)
└── theme.dart                     # Material 3 Theme configuration
```

## Detailed Breakdown

### 1. Domain Layer (Business Logic)
Contains the following Use Cases that define what the app can do:
- `GetQuotes`: Fetch a paginated list of quotes.
- `GetRandomQuote`: Get a single random quote for the Home screen.
- `GetQuoteById`: Retrieve details for a specific quote.
- `SaveFavoriteQuote`: Add a quote to the local favorites list.
- `RemoveFavoriteQuote`: Remove a quote from favorites.
- `GetFavoriteQuotes`: Retrieve all locally stored favorites.
- `GetFavoriteCount`: Get the total number of favorite quotes.

### 2. Presentation Layer (UI)
The app consists of the following screens:
- **Splash Screen**: Initial loading and branding.
- **Main Screen**: Bottom navigation container.
- **Home Screen**: Displays the "Quote of the Day".
- **Quotes List**: Searchable list of all available quotes.
- **Quote Detail**: Detailed view with favorite toggling.
- **Favorites Screen**: List of saved quotes for quick access.

### 3. Dependency Injection
We use an **Explicit Dependency Injection** pattern via the `DependencyInjection` class in `lib/injection_container.dart`. This ensures that all components (DataSources -> Repositories -> UseCases) are properly wired at startup without relying on magic or complex DI frameworks.

## Core Stack

- **UI & Theme**: Flutter (Material 3)
- **State Management**: `flutter_bloc` (Cubit)
- **Navigation**: `go_router`
- **Network**: `http`
- **Local Storage**: `shared_preferences`
- **UI Components**: `shimmer` (loading states), `flutter_svg` (vector icons)
- **Testing**: `flutter_test` (Unit & Widget tests)

## Getting Started

### Prerequisites
- Flutter SDK (latest stable)
- Android Studio / VS Code

### Installation
1. Clone the repository.
2. Run `flutter pub get` to install dependencies.
3. Run `flutter analyze` to verify code quality.
4. Run `flutter test` to execute the unit tests.
5. Run `flutter run` to launch the app.
