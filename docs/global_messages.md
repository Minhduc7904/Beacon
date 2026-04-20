# Global Message System

Hệ thống thông báo toàn cục — hiển thị toast notifications trên mọi trang, hỗ trợ nhiều message cùng lúc, tự động biến mất sau một khoảng thời gian.

---

## Cấu trúc file

```
lib/core/
├── messages/
│   ├── app_message.dart           # Model
│   └── app_message_notifier.dart  # StateNotifier
└── widgets/
  └── message_toast/
    ├── message_toast.dart          # Animated toast widget
    └── global_message_overlay.dart # Overlay bọc toàn bộ app
```

---

## Cách hoạt động

```
Controller gọi addError / addSuccess
        ↓
appMessageProvider (List<AppMessage>) thay đổi
        ↓
GlobalMessageOverlay rebuild → render MessageToast mới ở top
        ↓
Sau 3s → slide xuống + fade out → removeMessage → xóa khỏi list
```

---

## Kiểu thông báo (`MessageType`)

| Enum | Màu | Icon | Dùng khi |
|------|-----|------|----------|
| `success` | Xanh lá | ✓ | Thao tác thành công |
| `error` | Đỏ | ✕ | Lỗi, thất bại |
| `warning` | Cam | ⚠ | Cảnh báo |
| `info` | Xanh dương | ℹ | Thông tin chung |

---

## API — `AppMessageNotifier`

```dart
// Truy cập từ bất kỳ đâu có WidgetRef / Ref
ref.read(appMessageProvider.notifier)
```

| Method | Mô tả |
|--------|--------|
| `addSuccess(String message)` | Hiển thị toast xanh |
| `addError(String message)` | Hiển thị toast đỏ |
| `addInfo(String message)` | Hiển thị toast xanh dương |
| `addWarning(String message)` | Hiển thị toast cam |
| `removeMessage(String id)` | Xóa thủ công (thường tự động) |

---

## Cách sử dụng

### Trong Controller / Notifier

```dart
// Inject qua constructor (xem providers.dart)
final AppMessageNotifier _messageNotifier;

// Gọi khi có kết quả
result.fold(
  (failure) => _messageNotifier.addError(failure.message),
  (data)    => _messageNotifier.addSuccess('Thành công!'),
);
```

### Từ Widget (với WidgetRef)

```dart
// ConsumerWidget hoặc ConsumerStatefulWidget
ref.read(appMessageProvider.notifier).addSuccess('Đã lưu thay đổi');
ref.read(appMessageProvider.notifier).addError('Không thể kết nối');
ref.read(appMessageProvider.notifier).addWarning('Phiên đăng nhập sắp hết hạn');
ref.read(appMessageProvider.notifier).addInfo('Có phiên bản mới');
```

---

## Ví dụ — `AuthNotifier`

```dart
// Đăng nhập thành công
_messageNotifier.addSuccess('Chào mừng ${user.firstName} ${user.lastName}!');

// Đăng nhập thất bại
_messageNotifier.addError(failure.message);  // vd: 'Không thể kết nối đến máy chủ'
```

---

## Tích hợp vào App (`main.dart`)

`GlobalMessageOverlay` được wrap trong `builder` khi chạy môi trường dev (`AppEnv.isDev`):

```dart
MaterialApp.router(
  builder: (context, child) {
    final appChild = child ?? const SizedBox.shrink();
    if (!AppEnv.isDev) {
      return appChild;
    }
    return GlobalMessageOverlay(child: appChild);
  },
  routerConfig: appRouter,
)
```

Nhờ vậy overlay luôn nằm trên tất cả các trang mà không cần thêm gì vào từng trang.

---

## Hành vi Toast

- **Xuất hiện**: Slide từ trên xuống (350ms, `easeOut`)
- **Biến mất**: Tự động sau **3 giây** — slide xuống + fade out (300ms, `easeIn`)
- **Tap để đóng sớm**: Nhấn vào toast hoặc nút `✕`
- **Nhiều toast cùng lúc**: Xếp chồng từ trên xuống, mỗi cái có vòng đời độc lập

---

## Thêm vào Controller mới

1. Inject `AppMessageNotifier` qua constructor
2. Truyền `ref.watch(appMessageProvider.notifier)` trong `providers.dart`
3. Gọi `_messageNotifier.addError/addSuccess/...` theo kết quả

```dart
// providers.dart
final myNotifierProvider = StateNotifierProvider<MyNotifier, MyState>((ref) {
  return MyNotifier(
    ref.watch(myUseCaseProvider),
    ref.watch(appMessageProvider.notifier), // ← thêm dòng này
  );
});
```
