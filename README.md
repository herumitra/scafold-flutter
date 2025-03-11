# scafold flutter

A new Flutter project.

### Struktur Folder
```
lib/
├── src/
│   ├── config/                # Konfigurasi aplikasi (misalnya API, konfigurasi global)
│   ├── models/                # Model atau entitas yang digunakan di aplikasi 
│   ├── items/                # Detail item yang ditampilkan di home_screen.dart
│   │   ├── dashboard_item.dart
│   │   ├── laporan_belanja_pengeluaran_item.dart
│   │   ├── laporan_laba_rugi_item.dart
│   │   ├── laporan_penjualan_item.dart
│   │   ├── master_kategori_member_item.dart
│   │   ├── master_kategori_produk_item.dart
│   │   ├── master_kategori_supplier_item.dart
│   │   ├── master_konversi_satuan_item.dart
│   │   ├── master_member_item.dart
│   │   ├── master_produk_item.dart
│   │   ├── master_satuan_item.dart
│   │   ├── master_supplier_item.dart
│   │   ├── master_supplier_produk_item.dart
│   │   ├── profile_item.dart
│   │   ├── transaksi_pembelian_item.dart
│   │   ├── transaksi_penerimaan_item.dart
│   │   ├── transaksi_penjualan_item.dart
│   │   ├── transaksi_retur_pembelian_item.dart
│   │   └── transaksi_retur_penjualan_item.dart
│   ├── providers/             # Manajemen status atau provider 
│   ├── screens/               # Setiap layar atau tampilan aplikasi
│   │   ├── home_screen.dart
│   │   └── login_screen.dart 
│   ├── widgets/               # Komponen atau widget reusable
│   │   └── custom_menu.dart
│   ├── services/              # Layanan atau API yang digunakan untuk komunikasi dengan server
│   ├── utils/                 # Utilities atau helper functions
│   │   └── constants.dart
│   └── main.dart              # Titik awal aplikasi
├── assets/                    # Asset-asset seperti gambar, font, dll.
│   ├── images/
│   └── fonts/
pubspec.yaml                  # File konfigurasi proyek
```