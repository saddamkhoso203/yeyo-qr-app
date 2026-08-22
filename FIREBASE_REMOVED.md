# Firebase removal

Firebase configuration files and Firebase package dependencies were removed from this project.

The current migration intentionally does NOT add the YeYo APIs yet.

Next API integration scope:
- POST /scan
- GET /drivers/{driver_code}

Before running the project, run:
flutter clean
flutter pub get

Then resolve any remaining Firebase references reported by:
flutter analyze
