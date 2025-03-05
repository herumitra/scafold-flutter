# scafold flutter

A new Flutter project.

### Struktur Folder
```
lib/
├── src/
│   ├── config/                # Konfigurasi aplikasi (misalnya API, konfigurasi global)
│   │   ├── api_config.dart
│   │   └── app_config.dart
│   ├── models/                # Model atau entitas yang digunakan di aplikasi
│   │   ├── user.dart
│   │   └── product.dart
│   ├── providers/             # Manajemen status atau provider
│   │   ├── user_provider.dart
│   │   └── product_provider.dart
│   ├── screens/               # Setiap layar atau tampilan aplikasi
│   │   ├── home_screen.dart
│   │   └── profile_screen.dart
│   ├── widgets/               # Komponen atau widget reusable
│   │   ├── custom_button.dart
│   │   └── product_card.dart
│   ├── services/              # Layanan atau API yang digunakan untuk komunikasi dengan server
│   │   ├── api_service.dart
│   │   └── authentication_service.dart
│   ├── utils/                 # Utilities atau helper functions
│   │   ├── constants.dart
│   │   └── validators.dart
│   └── main.dart              # Titik awal aplikasi
├── assets/                    # Asset-asset seperti gambar, font, dll.
│   ├── images/
│   └── fonts/
├── test/                      # Test Unit dan Widget Test
│   ├── widget_test.dart
│   └── unit_test.dart
pubspec.yaml                  # File konfigurasi proyek
```