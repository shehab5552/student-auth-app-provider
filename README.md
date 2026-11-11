# Student Auth — Provider Edition

This is the Provider rewrite of the supplied Student Auth Flutter project.
The original UI, validation rules, request models, repository behavior, and
four authentication flows are retained.

## Run

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

## State-management architecture

- `repositories/`: authentication contract and in-memory demo implementation.
- `providers/auth_provider.dart`: `AuthProvider extends ChangeNotifier`; owns UI state and use-case orchestration.
- `main.dart`: `MultiProvider` provides `AuthRepository` first, then `ChangeNotifierProvider<AuthProvider>`.
- `views/auth/`: pages use `context.watch<AuthProvider>()` in `build` to react to state and `context.read<AuthProvider>()` in event handlers to call methods without subscribing.
- `models/` and `utils/`: unchanged request/user models and form validation.

## Key Provider patterns used

```dart
// Provide a repository and a ChangeNotifier.
MultiProvider(
  providers: [
    Provider<AuthRepository>(create: (_) => AuthRepositoryImpl()),
    ChangeNotifierProvider<AuthProvider>(
      create: (context) => AuthProvider(context.read<AuthRepository>()),
    ),
  ],
  child: const MyAppView(),
)

// In a page's build method: subscribe to changes.
final auth = context.watch<AuthProvider>();

// In a button callback: invoke a method without subscribing.
context.read<AuthProvider>().login(request);
```

`notifyListeners()` is called by `AuthProvider` when loading, result, message,
or authenticated-user state changes. The page that calls `watch` rebuilds in
response to those notifications.

## Demo limitations retained from the original

- Accounts live in memory and are lost when the app process restarts.
- The repository simulates network delay; it is not connected to a backend.
- Password reset uses the demo OTP `123456`; no email is sent.
- This is an educational authentication flow, not production authentication.
