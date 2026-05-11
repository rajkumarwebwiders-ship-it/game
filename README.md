# Coach Game Tracker

A clean and optimized Flutter mobile application designed for coaches to easily create and manage game schedules. This project demonstrates a modular architecture using BLoC for business logic, ValueNotifier for local UI state, and seamless Firebase Firestore integration.

## Features
- **Create Game Screen**: Intuitive form with Date/Time pickers and validated inputs.
- **Reactive UI**: Implemented without `setState` using BLoC and ValueNotifier for maximum performance.
- **Modular Architecture**: Separate layers for Models, Services, BLoC, Themes, and Widgets.
- **Premium Design**: Centralized theme management and custom UI components (SnackBar, Inputs).

---

## Local Setup Instructions

### 1. Prerequisites
- **Flutter SDK**: `^3.38.5` or higher
- **Dart SDK**: `^3.10.4`
- **Firebase Account**: Required for Firestore integration
- **Development Environment**: Android Studio / VS Code with Flutter plugins

### 2. Clone the Repository
```bash
git clone https://github.com/rajkumarwebwiders-ship-it/game.git
cd game
```

### 3. Install Dependencies
```bash
flutter pub get
```

### 4. Firebase Configuration
This project is already configured with the FlutterFire CLI logic. To run it with your own Firebase project:
1. Initialize Firebase in the project:
   ```bash
   flutterfire configure
   ```
2. This will generate/update `lib/firebase_options.dart`.
3. Ensure your `android/app/src/main/AndroidManifest.xml` includes internet permissions (already added).

### 5. Run the Application
```bash
flutter run
```

---

## Firebase Setup Explanation

### Firestore Structure
The application uses **Cloud Firestore** to store game data in a root-level collection.

- **Collection Name**: `games`
- **Document Fields**:
  - `date`: String (Format: `yyyy-MM-dd`)
  - `time`: String (Format: `HH:mm`)
  - `location`: String
  - `sport`: String (e.g., Camogie, Hurling)
  - `grade`: String (e.g., U14, Junior)
  - `teamA`: String
  - `teamB`: String
  - `status`: String (Default: `"open"`)
  - `createdAt`: Timestamp (Server time)

### Security Rules
For initial testing, ensure your Firestore security rules allow writes:
```javascript
service cloud.firestore {
  match /databases/{database}/documents {
    match /games/{gameId} {
      allow read, write: if true; // Update this for production!
    }
  }
}
```

---

## Project Structure
- **lib/bloc/**: State management logic (Events, States, BLoC).
- **lib/models/**: Data models and Firestore serialization.
- **lib/screens/**: Main UI pages.
- **lib/services/**: Backend interactions (Firestore service).
- **lib/theme/**: Centralized global design system.
- **lib/widgets/**: Reusable custom UI components.
