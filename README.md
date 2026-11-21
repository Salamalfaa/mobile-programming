# Aplikasi Perpustakaan

Aplikasi Flutter untuk mengelola buku melalui REST API Laravel di folder
[`perpus-api`](./perpus-api). Fitur yang tersedia:

- Login dan pendaftaran akun dengan token Sanctum yang disimpan secara lokal.
- Daftar buku, pencarian, pagination, dan pull-to-refresh.
- Tambah, edit, hapus, serta detail buku dengan validasi API.
- Tampilan responsif untuk ponsel dan layar desktop/web.

## Menjalankan backend

Di Windows, buka terminal pada folder proyek:

```powershell
Set-Location perpus-api
.\setup.bat
php artisan serve
```

Backend berjalan di `http://localhost:8000`. Akun demo setelah seeding:

- Email: `admin@example.com`
- Password: `password`

## Menjalankan aplikasi Flutter

Dari folder root proyek:

```powershell
flutter pub get
flutter run -d chrome
```

Untuk emulator Android, gunakan:

```powershell
flutter run
```

URL API otomatis memakai `http://10.0.2.2:8000/api/` di emulator Android dan
`http://localhost:8000/api/` di web. Untuk perangkat fisik, jalankan backend
dengan `php artisan serve --host=0.0.0.0`, lalu berikan alamat IP laptop:

```powershell
flutter run --dart-define=API_BASE_URL=http://<IP-LAPTOP>:8000/api/
```

HTTP dan `usesCleartextTraffic` hanya untuk pengembangan lokal. Gunakan HTTPS
dan konfigurasi jaringan produksi yang sesuai sebelum merilis aplikasi.

## Verifikasi

```powershell
flutter analyze
flutter test
flutter build apk --debug
flutter build web
```
