# Quotes App - Clean Architecture Implementation

A production-ready Flutter application that displays inspirational quotes using the DummyJSON Quotes API. This project is structured following the **Feature-first Clean Architecture** principles as part of the Technical Onboarding Plan.

## Architecture Overview

The project is organized into layers to ensure a separation of concerns, high testability, and maintainability:

- **Presentation Layer**: Handles UI and State Management (Screens, Widgets, and Blocs/Cubits).
- **Domain Layer**: Contains the business logic (Entities, Repository interfaces, and Use Cases/Failures). This layer is independent of any other layer.
- **Data Layer**: Implements the repositories and handles data sources (Remote API via HTTP and Local Storage via SharedPreferences).

## Project Structure

```text
lib/
├── features/
│   └── quotes/
│       ├── data/                  # Data layer: Models, Repositories (Impl), DataSources
│       ├── domain/                # Domain layer: Entities, Repository (Interfaces), Failures
│       └── presentation/          # Presentation layer: Screens, Widgets, Blocs/Cubits
├── main.dart                      # App entry point & Explicit Dependency Injection
└── router.dart                    # App routing configuration (go_router)
```

## Onboarding Progress

This repository reflects the completion of **Week 1: Architecture, Clean Code & DI** of the Technical Onboarding Plan:

- [x] **Feature Structure**: Consolidated all logic into the `quotes` feature folder.
- [x] **Layer Responsibilities**: Strict separation between Presentation, Domain, and Data.
- [x] **Explicit Dependency Injection**: DataSources and Repositories are initialized and injected at the root (`main.dart`).
- [x] **SOLID Principles**: Used interface-based repositories to decouple the UI from data implementation.
- [x] **Automated Testing**: Unit tests for Cubits, Blocs, and Repository logic with Mock/Fake providers.

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

## Features
- **Quote of the Day**: Random quotes with offline caching support.
- **Searchable List**: Instant filtering of quotes.
- **Favorites**: Persist your favorite quotes locally.
- **Resilient Networking**: Custom failure handling for timeouts and connectivity issues.

## Core Stack
- **State Management**: `flutter_bloc` (Cubit & BLoC)
- **Navigation**: `go_router`
- **Networking**: `http`
- **Storage**: `shared_preferences`
- **Testing**: `flutter_test`
