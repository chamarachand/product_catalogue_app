# Product Catalogue App

## Project Overview

A Flutter application that displays a catalogue of products with a dedicated details page. The app supports product search, favourite products, and light/dark themes.

The app has two main screens:

- **Product List** — Displays all products in a responsive grid view containing the product image, name, price, category, and favourite toggle. Also includes a search bar that allows users to search products by name in real time
- **Product Details** — Shows a larger image of the selected product with its full description and a favourite toggle that stays synchronized with the list screen.

## Main Features

- Browse products in a catalogue grid view
- View detailed product information
- Product search with substring matching
- Add and remove favourite products with persistence
- Light and dark themes with persistent theme selection
- Responsive UI for phones, tablets, and landscape mode

---

## Setup Instructions

### Flutter Version

- Flutter SDK: 3.38.5 (stable channel)

Navigate to the project directory.

### Install dependencies

```bash
flutter pub get
```

### Run the project

```bash
flutter run
```

### Build an APK

```bash
flutter build apk --release
```

The generated APK will be available at:

`build/app/outputs/flutter-apk/app-release.apk`

---

## Architecture

### Folder Structure

```
lib/
├── core/
│   ├── constants/
│   ├── errors/
│   ├── services/
│   └── theme/
├── features/
│   ├── catalogue/
│   │   ├── cubit/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   └── repository/
│   │   └── presentation/
│   │       ├── pages/
│   │       └── widgets/
│   └── theme/
│       └── cubit/
└── main.dart
```

---

## State Management Approach

The application uses **Bloc/Cubit** for managing application state. **setState** is used for simple local UI state

### ProductCubit manages:

- Loading products
- Searching products
- Favourite management
- Error handling

### ThemeCubit manages:

- Light/dark theme handling

---

## API Integration Approach

The app uses the public **DummyJSON API** (`https://dummyjson.com/products`) to retrieve product data.

The data flow follows a repository-based approach:

```
UI → Cubit → Repository → API Service
```

- `ProductRepository` acts as an abstraction layer between the UI and data sources.
- API requests are handled using the `http` package.
- Custom exceptions are used to provide meaningful error handling.

---

## Local Storage

`SharedPreferences` is used to store and manage:

- Favourite product IDs
- Selected theme preference

---

## Assumptions

- The application requires a consistent UI experience across Android and iOS
- Product IDs are unique and suitable for favourite persistence.
- Light/dark theme preference should persist across app restarts.
- Currency displayed in the application is USD ($).

---

## Challenges

## Responsive Grid Layout

Making the UI responsive across various screen sizes.

Solution:

- Used `LayoutBuilder` to handle different screen constraints.
- Used `SliverGridDelegateWithMaxCrossAxisExtent` to dynamically adjust the grid layout based on available screen width.

---

# Improvements

- Add pagination to handle a large number of products.
- Add a dedicated favourites screen.
- Debounce search input to improve performance when searching through large datasets.
- Add product cart functionality.
- Use system theme as the default theme preference
- Add Bloc testing

---

## Screenshots

- [Phone Screenshots (iOS simulator)](https://drive.google.com/drive/folders/1lX6xvZ2T-4O6Nh10WbDGASp2zRN4ppOj?usp=sharing)
- [Tablet Screenshots (Android tablet)](https://drive.google.com/drive/folders/1Q165fUum9-hRKoLmMM4sv0JwzXzUACsv?usp=drive_link)

## Demo Video

- [Phone Demo Video (iOS simulator)](https://drive.google.com/drive/folders/1Sx3xW3gSAgJMLpm7JtNjWxw7W9cN7Z_1?usp=sharing)
- [Tablet Demo Video (Android tablet)](https://drive.google.com/drive/folders/1tOZEk24nLz3z_XUeeeSccCt5bOkWARJF?usp=sharing)

## APK

- [Download APK](https://drive.google.com/drive/folders/1sYpt_mZ_geHsI4Enx3oYFZMQNxZbs-9h?usp=sharing)
