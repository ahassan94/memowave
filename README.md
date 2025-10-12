# memowave

A small Flutter note-taking app I built for myself on Android and iOS. Keeps
everything on-device with a local SQLite database. No accounts, no sync.

## Features

- Create / edit / delete notes
- Swipe left on a note to delete it
- Categories (General, Work, Personal, Ideas, To-do)
- Full-text search across titles and bodies
- Notes are stored locally via `sqflite`
- State management with `provider`
- Material 3 theme

## Screenshots

<!-- TODO: add screenshots once the 1.0 release is cut -->

| List | Editor | Search |
|---|---|---|
| (screenshot) | (screenshot) | (screenshot) |

## Build

Requires Flutter 3.10+ and Dart 3.

```
flutter pub get
flutter run
```

### Android release build

```
flutter build apk --release
```

### iOS release build

```
flutter build ios --release
```

## Tests

```
flutter test
```

The database tests run against an in-memory sqlite via `sqflite_common_ffi`,
so they work on desktop without a connected device.

## License

MIT. See `LICENSE`.
