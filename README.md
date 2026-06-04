# Houzeo Contacts App

A modern Contact Management application built using Flutter, GetX, Firebase Firestore, and Firebase Anonymous Authentication.

This application allows users to create, manage, search, and organize contacts with a clean Material 3 user interface and real-time cloud storage.

---

## Features

### Contact Management

- View all contacts
- Add new contacts
- Edit existing contacts
- Delete contacts with confirmation dialog
- View detailed contact information

### Favorites

- Mark contacts as favorite
- Remove contacts from favorites
- Dedicated Favorites tab

### Search & Sorting

- Search contacts by name
- Real-time filtering
- Alphabetical (A-Z) sorting

### Calling Functionality

- Call contacts directly from the contact detail screen

### Cloud Integration

- Firebase Firestore integration
- Real-time data synchronization
- User-specific contact storage

### Authentication

- Firebase Anonymous Authentication
- Automatic user identification without requiring login

---

## Tech Stack

- Flutter
- Dart
- GetX (State Management & Navigation)
- Firebase Firestore
- Firebase Authentication
- Material 3

---

## Architecture

The application follows a clean and scalable architecture:

```text
lib/

├── controllers/
├── models/
├── screens/
├── services/
├── widgets/
└── main.dart
```

### Layers

- Models → Data representation
- Services → Firebase and external services
- Controllers → Business logic and state management
- Screens → UI implementation
- Widgets → Reusable UI components

---

## Firebase Structure

```text
users
 └── {uid}
      └── contacts
           └── {contactId}
```

Each user has their own isolated contact collection.

---

## Screens

### Contacts Screen

- Display all contacts
- Search contacts
- Favorite / Unfavorite contacts

### Add Contact Screen

- Create a new contact
- Form validation

### Edit Contact Screen

- Update contact information
- Validation support

### Contact Detail Screen

- View complete contact information
- Call contact
- Edit contact
- Delete contact

### Favorites Screen

- View all favorite contacts

---

## Installation

### Clone Repository

```bash
git clone <repository-url>
```

### Install Dependencies

```bash
flutter pub get
```

### Configure Firebase

Add your Firebase configuration files:

Android:

```text
android/app/google-services.json
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

## Key Highlights

- Clean GetX Architecture
- Firebase Firestore Integration
- Firebase Anonymous Authentication
- Real-Time Data Updates
- Search & Filtering
- Favorites Management
- Contact CRUD Operations
- Material 3 Design
- Scalable Folder Structure

---

## Assignment Deliverables

Included:

- Source Code
- Firebase Integration
- APK Build
- Documentation
- Screenshots

---

## Developer

Abhay Sananse

Flutter Developer | 4.6+ Years Experience
