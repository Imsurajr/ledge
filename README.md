# Ledge

Ledge is a lightweight Flutter app that maintains a simple entry list — each entry showing an **avatar**, **name**, and **created at** timestamp.

While the feature set is intentionally minimal, this project exists primarily as a **reference implementation** of:

- **Flutter BLoC** for state management
- **Clean Architecture** (presentation / domain / data layering)
- **Dependency Injection** via a service locator
- **Test-Driven Development (TDD)** — every layer is backed by tests written before (or alongside) implementation

## ✨ Features

- Add a new entry with a name and auto-generated avatar
- View entries in a list, sorted by creation time
- Timestamps rendered in a human-readable "created at" format
- Fully reactive UI driven by BLoC state transitions

## 🏗️ Architecture

The project follows Clean Architecture principles, split into three layers per feature:

```
lib/
├── core/
│   ├── errors/
│   │   ├── exceptions.dart       # Thrown from data sources
│   │   └── failure.dart          # Mapped to & surfaced by the domain layer
│   ├── services/
│   │   └── injection_container.dart  # get_it service locator setup
│   └── usecase/
│       └── usecase.dart          # Base UseCase<Type, Params> contract
│
├── features/
│   └── auth/                     # Feature module (e.g. entry list lives here)
│       ├── data/
│       │   ├── datasources/      # Local/remote data sources
│       │   ├── models/           # DTOs / data models
│       │   └── repositories/     # Repository implementations
│       ├── domain/
│       │   ├── entities/         # Core business entities
│       │   ├── repositories/     # Repository interfaces
│       │   └── usecases/         # Business logic (AddEntry, GetEntries, etc.)
│       └── presentation/
│           ├── bloc/             # BLoCs (events, states, bloc)
│           ├── cubit/            # Cubits for simpler state slices
│           ├── views/            # Screens
│           └── widgets/          # Reusable UI components
│
├── utils/
│   ├── constants.dart            # App-wide constants
│   └── typedef.dart              # Shared type aliases (e.g. ResultFuture<T>)
│
└── main.dart
```

**Dependency flow:** `presentation → domain ← data`
The domain layer has zero dependencies on Flutter or external packages, keeping business logic fully testable in isolation. `injection_container.dart` wires concrete implementations (data sources, repositories, use cases, blocs/cubits) into `get_it` at startup, so the presentation layer only ever depends on abstractions.

## 🧱 Tech Stack

| Concern              | Package                     |
|-----------------------|------------------------------|
| State Management      | `flutter_bloc` (BLoC + Cubit) |
| Dependency Injection  | `get_it` (manual service locator via `injection_container.dart`) |
| Functional error handling | `dartz` (`Either<Failure, T>`), custom `Exception`/`Failure` types |
| Shared typing         | `typedef.dart` (e.g. `ResultFuture<T> = Future<Either<Failure, T>>`) |
| Testing               | `flutter_test`, `bloc_test`, `mocktail` |

## ✅ Test-Driven Development

Every feature was built outer-to-inner following the TDD red-green-refactor cycle:

1. **Domain layer** — use case tests written first against mocked repositories
2. **Data layer** — repository implementation tests against mocked data sources, including success and failure (exception → failure mapping) paths
3. **Presentation layer** — BLoC tests using `bloc_test` to assert exact state emission sequences for each event

The `test/` directory mirrors `lib/` feature-for-feature and layer-for-layer:

```
test/
└── features/
    └── auth/
        ├── data/
        │   ├── datasources/
        │   ├── models/
        │   └── repositories/
        ├── domain/
        │   └── usecases/
        └── presentation/
            ├── bloc/
            └── cubit/
```

Run the full test suite:

```bash
flutter test
```

Run with coverage:

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (stable channel)
- Dart >= 3.0

### Installation

```bash
git clone <https://github.com/Imsurajr/ledge>
cd ledge
flutter pub get
```



### Run the app

```bash
flutter run
```

## 📂 Project Structure Philosophy

- **Entities** are pure Dart, framework-agnostic
- **Use cases** encapsulate a single business action (`AddEntry`, `GetEntries`)
- **Repositories** are abstracted in the domain layer and implemented in the data layer, keeping the domain unaware of Dio, local storage, or any external dependency
- **BLoC** only talks to use cases — never directly to repositories or data sources

## 🤝 Contributing

This project is primarily a learning/reference repo for clean architecture + TDD patterns in Flutter. Issues and PRs demonstrating alternative testing strategies or DI patterns are welcome.

## 📄 License

Imsurajr