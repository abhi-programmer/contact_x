# ContactX

A Flutter contact management application built with GetX, Firebase Firestore, Repository Pattern, and Clean Architecture principles.

## Features

- Create Contact
- Update Contact
- Delete Contact
- View Contact Details
- Mark / Unmark Favourite Contacts
- Real-time Firestore Synchronization
- Reactive UI using GetX
- Unit Tested Business Logic

---

## Architecture

The project follows a layered architecture to improve maintainability, scalability, and testability.

```text
Presentation Layer
│
├── UI
├── Controllers
│
Domain Layer
│
├── Entities
├── Repository Contracts
├── Use Cases
│
Data Layer
│
├── Models
├── Repository Implementations
├── Firebase Data Sources
│
Firebase Firestore
```

### Flow

```text
UI
 ↓
Controller
 ↓
UseCase
 ↓
Repository
 ↓
DataSource
 ↓
Firestore
```

---

## Tech Stack

- Flutter
- Dart
- GetX
- Firebase Firestore
- Repository Pattern
- Clean Architecture
- Mocktail
- Flutter Test

---

## Project Structure

```text
lib/
│
├── bindings/
│
├── core/
│
├── features/
│   └── contacts/
│       ├── data/
│       │   ├── datasource/
│       │   ├── models/
│       │   └── repositories/
│       │
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       │
│       └── presentation/
│           ├── controllers/
│           ├── pages/
│           └── widgets/
│
└── main.dart
```

---

## State Management

GetX is used for:

- State Management
- Dependency Injection
- Navigation
- Reactive UI Updates

---

## Testing

The following unit tests have been implemented:

- ContactModel Serialization Tests
- AddContactUseCase Tests
- UpdateContactUseCase Tests
- DeleteContactUseCase Tests
- GetContactsUseCase Tests

Run tests:

```bash
flutter test
```

---

## Static Analysis

Run code analysis:

```bash
flutter analyze
```

Format code:

```bash
dart format lib test
```

---

## Getting Started

### Install Dependencies

```bash
flutter pub get
```

### Run Application

```bash
flutter run
```

### Build APK

```bash
flutter build apk --release
```

---

## Key Improvements

This version includes:

- Improved project structure
- Use Case based business logic separation
- Repository abstraction
- Enhanced maintainability
- Unit testing coverage
- Better scalability for future features

---

## Author

Abhay Sananse

Senior Flutter Developer
