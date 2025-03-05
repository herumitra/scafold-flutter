# vimedika

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

### Struktur Folder
<div class="highlight highlight-source-dart position-relative" data-snippet-clipboard-copy-content="
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
">