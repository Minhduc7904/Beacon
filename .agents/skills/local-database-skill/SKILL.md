---
name: local-database-skill
description: "Use when: planning or implementing Flutter local database, cache, offline-read, local datasources, repository cache orchestration, stale data handling, and deterministic tests."
---

# Skill: Local Database và Cache cho Beacon

## 1. Mục tiêu

Dùng skill này để thiết kế và triển khai local database/cache trong Flutter app Beacon theo đúng Clean Architecture hiện có.

Skill hướng dẫn agent:

- Thiết kế local database/cache cho Flutter app.
- Triển khai local datasource theo từng feature.
- Phối hợp remote datasource, local datasource và network status trong repository.
- Hỗ trợ offline-read mà không làm bẩn domain/presentation.
- Chuẩn bị nền tảng offline-first khi sản phẩm cần.
- Tránh để UI, notifier, controller hoặc usecase phụ thuộc trực tiếp vào database package.
- Đảm bảo dữ liệu nhạy cảm không bị lưu sai storage.
- Đảm bảo test mapper, local datasource và repository cache orchestration có tính deterministic.

## 2. Khi dùng

Phải dùng skill này khi task liên quan đến:

- Thêm package local database.
- Tạo database foundation.
- Tạo collection/table/local model.
- Thêm local datasource.
- Thêm mapper giữa remote/domain/cache.
- Thêm cache fallback.
- Thêm cache-first background refresh.
- Thêm network-first cache fallback.
- Thêm cache invalidation.
- Clear cache khi logout hoặc đổi user.
- Xử lý stale data.
- Viết test mapper/local datasource/repository orchestration.
- Thiết kế offline mutation queue.

## 3. Nguyên tắc phân tầng

- Không đưa local database trực tiếp vào UI, presentation, controller, notifier hoặc widget.
- Không để domain entity/usecase phụ thuộc trực tiếp vào database package.
- Không annotate API model hoặc domain entity bằng annotation database nếu annotation đó làm phụ thuộc sai tầng.
- Tạo local/cache model riêng trong data layer.
- Repository là nơi phối hợp remote datasource, local datasource và network status.
- Repository trả domain entity hoặc result hiện có của app, không trả cache model.
- Local datasource chỉ phụ trách đọc/ghi local database.
- Mapper chịu trách nhiệm chuyển đổi giữa remote model, domain entity và cache model.

## 4. Nguyên tắc chọn dữ liệu để lưu local

Nên lưu local:

- Dữ liệu structured cần query/cache/offline-read.
- Dữ liệu read-heavy.
- Dữ liệu có thể stale trong thời gian ngắn.
- Dữ liệu cần mở app nhanh hơn.
- Dữ liệu cần hiển thị khi offline.

Không nên lưu local:

- `access token`.
- `refresh token`.
- `password`.
- `secret`.
- `FCM token` nếu chưa có lý do rõ.
- Raw image/video bytes.
- Object storage key nếu chưa có security review.
- Dữ liệu location nếu chưa có TTL hoặc chính sách rõ.
- Dữ liệu quá nhạy cảm mà chưa có yêu cầu sản phẩm rõ.

Quy tắc storage:

- Token/session secret tiếp tục nằm ở secure storage.
- Cờ nhỏ như theme/onboarding có thể tiếp tục dùng `SharedPreferences`.
- Local database dùng cho structured cache/query/offline-read, không thay thế mọi storage hiện có.

## 5. Ràng buộc package và compatibility

- Không pin version theo cảm tính.
- Không tự ý chọn package hoặc fork khác nếu chưa được người dùng xác nhận.
- Khi thêm package local database/generator, phải kiểm tra dependency compatibility trước.
- Nếu dependency solver/codegen/build fail, dừng và báo log cụ thể.
- Không tự ý đổi sang package khác để "lách" lỗi.
- Với database dùng code generation, phải có bước kiểm tra generator riêng.
- Với database yêu cầu schema/collection không rỗng, không cố mở database production với schema rỗng.

Ví dụ với Isar:

- `Isar.open()` của `Isar 3.1.0+1` không hỗ trợ schema list rỗng.
- Nếu dùng Isar, database foundation thực tế cần ít nhất một collection schema thật hoặc phải có quyết định rõ về schema tạm.

Skill này vẫn là hướng dẫn tổng quát, không chỉ phục vụ Isar.

## 6. Ràng buộc chạy lệnh Flutter/Dart

- Không tự chạy lệnh Flutter/Dart trừ khi người dùng yêu cầu rõ.
- Nếu cần verify, chỉ trả command để người dùng chạy thủ công.
- Với mỗi command cần ghi rõ mục đích, expected result và log cần gửi nếu fail.
- Ưu tiên command hẹp nếu test/build dễ bị stuck.

Các command thường chỉ nên trả về cho người dùng:

| Command | Mục đích | Expected result | Nếu fail cần gửi |
| --- | --- | --- | --- |
| `flutter pub get` | Cài/cập nhật dependency | Dependency solver thành công, không conflict | Toàn bộ đoạn solver error |
| `dart run build_runner build --delete-conflicting-outputs` | Sinh code cho local database/generator | File generated được tạo/cập nhật đúng | Log lỗi generator và file liên quan |
| `flutter analyze` | Kiểm tra static analysis | Không có error mới | Danh sách analyzer error |
| `flutter test` | Chạy test liên quan | Test pass | Tên test fail và stack trace |
| `flutter build apk --debug` | Smoke build debug Android | Build thành công | Log build error đầu tiên và dependency conflict nếu có |

## 7. Cấu trúc thư mục đề xuất

Database foundation tổng quát:

```text
lib/core/database/
  app_database.dart
  <database>_database.dart
  database_collections.dart
  database_exception.dart
```

Theo feature:

```text
lib/features/<feature>/data/
  datasources/<feature>_local_datasource.dart
  datasources/<feature>_local_datasource_impl.dart
  local_models/<entity>_cache.dart
  mappers/<entity>_cache_mapper.dart
```

Điều chỉnh theo cấu trúc thật của project. Không tạo folder rỗng hoặc file chưa dùng.

## 8. Chiến lược mapper

- Chuyển đổi `Remote model/domain entity -> cache model`.
- Chuyển đổi `Cache model -> domain entity`.
- Cache model có thể chứa field kỹ thuật như:
  - `cacheKey`
  - `cacheScopeUserId`
  - `cachedAtUtc`
  - `expiresAtUtc`
  - `lastSyncedAtUtc`
  - `source`
  - `schemaVersion`
- Domain entity không nên bị bẩn bởi field storage.
- Nếu UI cần biết dữ liệu từ cache/stale, dùng state metadata hoặc result wrapper phù hợp thay vì nhét bừa vào entity.

## 9. Chiến lược cache phổ biến

### Network-first + cache fallback

Dùng khi dữ liệu cần độ đúng cao.

Luồng:

1. Online: gọi API trước.
2. API success: trả remote data và upsert cache.
3. Offline hoặc lỗi mạng có cache: trả cached data.
4. Offline không cache: giữ failure hiện tại.
5. Unauthorized/server/validation failure: không fallback cache âm thầm.

### Cache-first + background refresh

Dùng khi UX cần nhanh và dữ liệu có thể stale nhẹ.

Luồng:

1. Đọc cache trước.
2. Hiển thị cached data nếu có.
3. Đồng thời refresh từ API.
4. API success: update cache và refresh UI.
5. API fail: giữ cache, báo trạng thái phù hợp nếu cần.

### Cache-only khi offline

Dùng cho offline-read fallback.

Luồng:

1. Offline: đọc local cache.
2. Có cache: hiển thị dữ liệu gần nhất.
3. Không cache: báo không có dữ liệu offline.
4. Không tự cho phép offline mutation nếu chưa có queue/idempotency/conflict strategy.

## 10. Quy tắc stale data

- Mọi cached data phải có `cachedAtUtc` hoặc metadata tương đương.
- Với dữ liệu nhạy cảm về thời gian, cần TTL hoặc rule revalidate rõ.
- Không hiển thị cache cũ như dữ liệu realtime nếu nghiệp vụ cần dữ liệu mới.
- Không dùng cached data để kích hoạt hành động nguy hiểm nếu chưa có thiết kế riêng.
- Khi dữ liệu phụ thuộc ngày hiện tại, cache phải có date key và không dùng dữ liệu ngày cũ như dữ liệu hôm nay.
- Nếu UI cần, state phải có `isFromCache`, `isRefreshing`, `cachedAtUtc` hoặc metadata tương đương.

## 11. Quy tắc user cache scope

- Dữ liệu user-scoped phải có `cacheScopeUserId` hoặc key tương đương.
- `userId` nên lấy từ nguồn đáng tin cậy như profile/current user sau auth.
- Không tạo cache key tạm bằng token/email/username/device id.
- Nếu chưa xác định được user id thì không ghi cache user-scoped.
- Logout xác định được user id thì clear cache theo user id.
- Logout không xác định được user id thì fallback clear toàn bộ user-scoped cache.
- Khi đổi user hoặc auth `401` buộc logout, áp dụng cùng chính sách clear cache.
- Multi-account song song cần thiết kế namespace riêng, không giả định tự có.

## 12. Chiến lược mutation

- Mặc định P0/P1 chỉ hỗ trợ offline-read, không offline-write.
- Mutation online success mới được update cache.
- Mutation failure không mutate cache.
- Optimistic update chỉ được dùng nếu có rollback rõ.
- Offline mutation queue cần thiết kế riêng:
  - Client mutation id.
  - Idempotency key.
  - Retry policy.
  - Conflict strategy.
  - Ordering.
  - Duplicate prevention.
  - Server contract.
  - UI pending/error state.

## 13. Cache invalidation và cleanup

- Cần có rule invalidation theo từng feature.
- Có thể invalidation theo:
  - TTL.
  - Logout.
  - User switch.
  - Mutation success.
  - Hard refresh.
  - App version/schema version.
  - Permission/visibility change.
- Không để cache tăng vô hạn.
- Với list/feed/page cache, cần giới hạn số lượng hoặc thời gian lưu.
- Với dữ liệu nhạy cảm, ưu tiên TTL ngắn hoặc không cache.

## 14. Test strategy

- Phần lớn unit test không gọi database thật.
- Ưu tiên fake/in-memory local datasource cho repository test.
- Test mapper riêng.
- Test local datasource riêng.
- Test repository orchestration riêng.
- Nếu cần database thật, chỉ tạo adapter smoke test riêng, không trộn với business test.
- Không gọi API thật.
- Không gọi platform service thật.
- Test phải deterministic.
- Khi task có thêm/sửa test, phải đọc và tuân thủ thêm `.agents/skills/test-strategy-skill/SKILL.md`.
- Tên test/comment ưu tiên tiếng Việt có dấu, giữ nguyên tên class/function/enum/API contract.

Các case bắt buộc:

- Online success upsert cache.
- Offline có cache trả cached data.
- Offline không cache giữ failure hiện tại.
- Unauthorized/server/validation failure không fallback cache.
- Mutation success mới update cache.
- Mutation failure không update cache.
- Logout clear cache.
- Không xác định user id thì fallback clear toàn bộ user-scoped cache.
- Mapper xử lý null/malformed data theo behavior hiện có.
- Cache stale/expired không bị dùng sai.

## 15. Quy trình làm việc khi nhận task local database

Checklist tổng quát:

1. Đọc codebase liên quan trước.
2. Xác định dữ liệu cần cache và dữ liệu không được cache.
3. Xác định cache strategy phù hợp.
4. Xác định user scope và invalidation rule.
5. Kiểm tra package/compatibility nếu cần thêm dependency.
6. Thiết kế local model và mapper.
7. Thiết kế local datasource abstraction.
8. Tích hợp repository với thay đổi behavior nhỏ nhất.
9. Viết test mapper/local datasource/repository orchestration.
10. Trả command verify thủ công.
11. Ghi rollback plan.

## 16. Definition of Done

Một task local database/cache chỉ xong khi:

- Không phá behavior hiện tại ngoài thay đổi đã mô tả.
- Không import database sai tầng.
- Không lưu dữ liệu nhạy cảm sai chỗ.
- Có user scope rõ nếu dữ liệu thuộc người dùng.
- Có invalidation/cleanup rule.
- Có mapper/local datasource/repository test phù hợp.
- Có rollback plan.
- Có command verify để người dùng chạy thủ công.
- Nếu chưa verify bằng command thì ghi rõ chưa verify.
- Không tạo folder rỗng, helper/fake/fixture chưa dùng hoặc abstraction chưa có consumer rõ ràng.