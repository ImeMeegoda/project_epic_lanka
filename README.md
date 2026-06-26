# Quotes App

A Flutter application that displays inspirational quotes using the DummyJSON Quotes API.

## How to Run

1. Make sure you have Flutter installed (version 3.41.6 or later)
2. Clone the repository
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to launch the app on your connected device or emulator

## Flutter Version & Packages

- **Flutter**: 3.41.6 (stable channel)
- **Dart**: 3.11.4
- **Packages used**:
  - `http: ^1.2.1` - For making API requests to the DummyJSON API
  - `cupertino_icons: ^1.0.8` - Default icon pack

## Features

- **Splash Screen**: Shows the app icon and title before navigating to the home screen
- **Home Screen (Quote of the Day)**: Displays a random quote fetched from the API
- **Quotes List Screen**: Shows a scrollable list of quotes in card format
- **Quote Detail Screen**: Full view of a selected quote with back navigation

## API

All data is fetched from [DummyJSON Quotes API](https://dummyjson.com/docs/quotes):

- `GET /quotes/random` - Random quote for home screen
- `GET /quotes?limit=20&skip=0` - Paginated list of quotes
- Quote detail is passed via navigation (no additional API call needed)

## Project Structure

```
lib/
  main.dart                  - App entry point and theme configuration
  models/
    quote.dart               - Quote data model
  services/
    quote_service.dart       - API service for fetching quotes
  screens/
    splash_screen.dart       - Splash/loading screen
    home_screen.dart         - Quote of the Day screen
    quotes_list_screen.dart  - List of all quotes
    quote_detail_screen.dart - Detailed view of a single quote
```

## Assumptions & Known Limitations

- The app fetches a new random quote each time the home screen is opened
- Quote detail screen receives data via navigation arguments rather than re-fetching from API
- Pagination is set to 20 quotes per request (default first page)
- Internet connection is required to load quotes
- Loading and error states are handled with a spinner and retry button
