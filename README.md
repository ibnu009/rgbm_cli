###### Documentation languages

RGB Mobile Custom CLI Commands.

```dart
// To install:
pub global activate rgb_cli 
// (to use this add the following to system PATH: [FlutterSDKInstallDir]\bin\cache\dart-sdk\bin

flutter pub global activate rgb_cli

// To create a page (module-aware):
// Pages generate: views, view_model, bindings and register routes.
// Usage with module flag:
rgb create page:login -m auth

// Without -m defaults to module "general":
rgb create page:home

// To create a new view model in a specific folder:
// Long form:
rgb create view_model:view_model_name on home
// Alias:
rgb create -vm:view_model_name on home

// To create a domain usecase (interface + implementation):
// Generates: lib/domain/usecase/<name>/{<name>_interface.dart,<name>_use_case.dart}
rgb create -u address
// or long form
rgb create use_case:address

// To build the app:
rgb build
// Example: rgb build -android -staging
// Options: -android (-a), -ios(-i)
// Environments: -staging (-s), -production (-p), -aab

// To generate a class model:
// Note: 'assets/models/user.json' path of your template file in json format
// Note: on  == folder output file
// Getx will automatically search for the home folder
// and insert your class model there.
rgb generate model on home with assets/models/user.json

//Note: the URL must return a json format
rgb generate model on home from "https://api.github.com/users/ibnu009"

// To install a package in your project (dependencies):
rgb install camera

// To install several packages from your project:
rgb install http path camera

// To install a package with specific version:
rgb install path:1.6.4

// To install a dev package in your project (dependencies_dev):
rgb install flutter_launcher_icons --dev

// To remove a package from your project:
rgb remove http

// To remove several packages from your project:
rgb remove http path

// To update CLI:
rgb update
// or `rgb upgrade`

// Shows the current CLI version:
rgb -v
// or `rgb -version`

// For help
rgb help
```

# CLI Details

Below is the list of outputs each command generates, based on current implementation:

- __create page:<name> [-m <module>]__
  - Generates Use Case under domain:
    - `lib/domain/use_case/<name>/<name>_interface.dart`
    - `lib/domain/use_case/<name>/<name>_use_case.dart`
  - Generates Presentation layer under the selected module (default module: `general`):
    - `lib/presentation/<module>/<name>/view_model/<name>_view_model.dart`
    - `lib/presentation/<module>/<name>/views/<name>_view.dart`
    - `lib/presentation/<module>/<name>/bindings/<name>_binding.dart`
  - Registers a new route in the app routes (AppPages).

- __create view_model:<name> on <module>__ (alias: `-vm` or `vm`)
  - Creates a ViewModel file using the ViewModel template.
  - Output folder is derived from the `on` target; current implementation writes under the module's `controllers/` directory.
  - If a Binding exists for the module/page, adds the dependency to it automatically.

- __create use_case:<name>__ (alias: `-u`, `uc`)
  - Creates domain layer artifacts:
    - `lib/domain/use_case/<name>/<name>_interface.dart`
    - `lib/domain/use_case/<name>/<name>_use_case.dart`

- __generate model on <module> with <path/to/file.json>__ (or: `from "<url>"`)
  - Creates a Dart model file from JSON:
    - `<target_path>/<name>_model.dart`
  - Unless `--skipProvider` is passed, also generates a Provider with basic endpoints:
    - `<target_path>/providers/<name>_provider.dart`

- __build__
  - Build app using build-app.sh script
  - Options: -android (-a), -ios(-i)
  - Envs: -staging (-s), -production (-p), -aab
  - Examples: rgb build -a -s | rgb build -i -p | rgb build -aab

- __init__
  - Creates a minimal `lib/main.dart` for GetX pattern.
  - Installs Get and scaffolds an initial page (invokes `create page`).
  - Creates initial `lib/` structure and module directories.

- __install <packages> [--dev]__
  - Adds dependencies (or dev_dependencies with `--dev`) to `pubspec.yaml` and runs `flutter pub get`.

- __remove <packages>__
  - Removes dependencies from `pubspec.yaml` and runs `flutter pub get`.

- __sort [--relative] [--skipRename]__
  - Sorts and formats imports across project files; optionally uses relative imports and can skip renaming based on separator rules.

- __update__ / __upgrade__
  - Updates this CLI to the latest version.

- __-v__ / __--version__
  - Shows the current CLI version.

- __help__
  - Lists available commands with brief hints.
