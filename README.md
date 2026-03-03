# Demo Flutter Project

Ứng dụng mẫu được xây dựng bằng Flutter nhằm phục vụ mục đích học tập và thử nghiệm các kỹ thuật như đa ngôn ngữ, trình phát audio, UI đẹp và cấu trúc dự án rõ ràng.

> **Chú ý:** đây là phiên bản mẫu nên dữ liệu chỉ được lưu trong bộ nhớ (các biến tạm) và không có cơ sở dữ liệu thực.

---

## 📌 Tổng quan dự án

- **Tên:** ứng dụng nghe nhạc
- **Ngôn ngữ:** Dart (Flutter)
- **Hệ điều hành:** hỗ trợ Android, iOS, web, Windows, macOS, Linux
- **Mục tiêu chính:**
  1. Trình diễn giao diện đẹp, thân thiện với người dùng.
  2. Hỗ trợ hai ngôn ngữ (English & Việt Nam).
  3. Tích hợp tính năng phát nhạc (Now Playing) với quản lý audio.
  4. Cấu trúc dự án rõ ràng phục vụ mở rộng sau này.

---

## ✨ Tính năng chính

- Giao diện người dùng hiện đại, responsive cho nhiều kích thước màn hình.
- Hỗ trợ **i18n** với `l10n` (Anh/Việt).
- Trang thông tin nhóm (About Us) giới thiệu thành viên.
- Trình phát audio cơ bản (play/pause, next, previous) với lớp `AudioPlayerManager`.
- Dữ liệu model giữ trong bộ nhớ để dễ dàng thử nghiệm.

---

## 🛠️ Yêu cầu và Công nghệ

- Flutter SDK (>= 3.0)
- Dart
- Thư viện được sử dụng (liệt kê trong `pubspec.yaml`):
  - `just_audio` (phát âm thanh)
  - `flutter_localizations` (đa ngôn ngữ)
  - ...

---

## 🚀 Cài đặt và Chạy

Làm theo các bước sau để thiết lập môi trường và chạy ứng dụng:

1. **Clone kho**
   ```bash
   git clone <repository-url> "d:/flutter prj/demo"
   cd "d:/flutter prj/demo"
   ```
2. **Cài đặt phụ thuộc**
   ```bash
   flutter pub get
   ```
3. **Chạy ứng dụng**
   - Trên thiết bị giả lập hoặc thiết bị thật (Android/iOS):
     ```bash
     flutter run
     ```
   - Hoặc chọn target phù hợp trong VS Code / Android Studio.

4. **Lưu ý**: vì đây chỉ là bản mẫu, bạn có thể sử dụng các thuộc tính tĩnh để kiểm thử.

---

## 📁 Cấu trúc dự án

```
lib/
  main.dart              # entry point
  app/                   # lớp cao nhất và cấu hình route
  data/                  # mô hình dữ liệu tạm
  ui/                    # widgets / màn hình
    now_playing/         # logic phát audio
  l10n/                  # tệp localisation và arb
```

Ngoài ra còn các thư mục `android/`, `ios/`, `web/`, ... do Flutter tạo tự động.

---

## 🧪 Kiểm thử

File `test/widget_test.dart` có ví dụ kiểm thử widget tự động. Chạy bằng:

```bash
flutter test
```

---

## 🤝 Đóng góp

Mọi cải tiến hoặc báo lỗi đều được hoan nghênh:

1. Fork repository.
2. Tạo nhánh mới `feature/my-feature`.
3. Commit và push lên.
4. Mở Pull Request miêu tả rõ ràng.

---

## 📄 Giấy phép

Dự án này dùng giấy phép MIT. Xem file `LICENSE` để biết chi tiết.

---

## 📚 Tài liệu tham khảo

- [Flutter Documentation](https://docs.flutter.dev/)
- [Internationalizing Flutter apps](https://flutter.dev/docs/development/accessibility-and-localization/internationalization)

Cám ơn bạn đã quan tâm đến dự án!
