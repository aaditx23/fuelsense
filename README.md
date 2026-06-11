# Flutter Template 🚀

A production-ready Flutter template with clean architecture, dependency injection, local database, and API integration.

## 📁 Project Structure

```
lib/
├── main.dart
├── data/
│   ├── local/
│   │   ├── app_database.dart
│   │   ├── app_database.g.dart  # Generated
│   │   ├── dao/
│   │   │   └── name_dao.dart
│   │   └── entity/
│   │       └── name_entity.dart
│   ├── model/
│   │   ├── todo_model.dart
│   │   └── todo_model.g.dart    # Generated
│   └── repository/
│       └── placeholder_repository.dart
├── di/
│   ├── setup_di.dart
│   ├── database_di.dart
│   └── repository_di.dart
├── navigation/
│   └── routes.dart
└── views/
    └── screens/
        ├── screen01/
        │   ├── screen01.dart
        │   └── screen01_provider.dart
        └── screen02/
            ├── screen02.dart
            └── screen02_provider.dart
```

## 📦 Libraries & Packages

### Core Dependencies
| Package | Version | Purpose |
|---------|---------|---------|
| [flutter](https://flutter.dev) | SDK | Core framework |
| [provider](https://pub.dev/packages/provider) | ^6.1.1 | State management |
| [get_it](https://pub.dev/packages/get_it) | ^7.6.0 | Dependency injection |

### Database
| Package | Version | Purpose |
|---------|---------|---------|
| [floor](https://pub.dev/packages/floor) | ^1.4.2 | Local SQLite database |
| [sqflite](https://pub.dev/packages/sqflite) | - | SQLite plugin (Floor dependency) |

### Networking
| Package | Version | Purpose |
|---------|---------|---------|
| [http](https://pub.dev/packages/http) | ^1.1.0 | HTTP client for API calls |

### Code Generation
| Package | Version | Purpose |
|---------|---------|---------|
| [json_annotation](https://pub.dev/packages/json_annotation) | ^4.8.1 | JSON serialization annotations |
| [json_serializable](https://pub.dev/packages/json_serializable) | ^6.8.0 | JSON code generation |
| [floor_generator](https://pub.dev/packages/floor_generator) | ^1.4.2 | Floor database code generation |
| [build_runner](https://pub.dev/packages/build_runner) | ^2.4.6 | Code generation runner |

## 🚀 Getting Started

### Prerequisites
- Flutter SDK: `>=3.0.0`
- Dart SDK: `>=3.0.0`

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd flutter_template
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 🔨 Development Commands

### Generate code (after model/database changes)
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Watch mode (auto-generates on file changes)
```bash
dart run build_runner watch
```

### Clean generated files
```bash
dart run build_runner clean
```

### Flutter clean
```bash
flutter clean
flutter pub get
```

## ✨ Features

### Screen 01 - Local Database Demo
- ✅ Floor database integration
- ✅ CRUD operations (Create, Read)
- ✅ Real-time UI updates with Provider
- ✅ Input validation
- ✅ Empty state handling

### Screen 02 - API Integration Demo
- ✅ HTTP GET requests
- ✅ JSON serialization/deserialization
- ✅ Loading states
- ✅ Error handling
- ✅ User input validation

## 🏗️ Architecture

This template follows **Clean Architecture** principles:

- **Data Layer**: Handles data operations (database, API)
- **Domain Layer**: Business logic (minimal in this template)
- **Presentation Layer**: UI and state management

### Dependency Injection
Uses `get_it` for service location pattern:
- Database instances
- Repository instances
- Singleton pattern for shared resources

### State Management
Uses `Provider` pattern:
- `ChangeNotifier` for state management
- Reactive UI updates with `notifyListeners()`
- Separation of business logic from UI

## 📝 Adding New Features

### Add a new database entity
1. Create entity in `data/local/entity/`
2. Create DAO in `data/local/dao/`
3. Update `app_database.dart` with new entity
4. Run code generation: `dart run build_runner build`
5. Register DAO in DI

### Add a new API model
1. Create model in `data/model/`
2. Add `@JsonSerializable()` annotation
3. Run code generation: `dart run build_runner build`
4. Create repository method in `data/repository/`
5. Create provider for state management

### Add a new screen
1. Create folder in `views/screens/`
2. Create screen widget (UI)
3. Create provider for state management
4. Add route in `navigation/routes.dart`
5. Wrap screen with `ChangeNotifierProvider` in routes

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```


## 📄 License

This project is licensed under the MIT License.

## 🔗 Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Provider Documentation](https://pub.dev/packages/provider)
- [Floor Documentation](https://pub.dev/packages/floor)
- [GetIt Documentation](https://pub.dev/packages/get_it)

---

**Built with ❤️ using Flutter**
