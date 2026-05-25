# Unit Test Plan

## 1. Đánh giá `test-strategy-skill`

Đã đọc lại `.agents/skills/test-strategy-skill/SKILL.md` trước khi re-scan. Nội dung hiện phù hợp để hướng dẫn testing cho Flutter/Riverpod trong Beacon: ưu tiên unit test, phân biệt unit/widget/integration, không test UI thuần bằng unit test, dùng mock/fake/fixture đúng boundary, và chọn test theo rủi ro nghiệp vụ.

Trong lần re-scan sau pull `main` này, không sửa `SKILL.md`. Các cập nhật bên dưới chỉ áp dụng cho `docs/unit-test-plan.md`.

## 2. A. Tổng quan hiện trạng test sau pull `main`

### Test hiện có

Project hiện có 2 file `_test.dart`:
- `test/widget_test.dart`: smoke widget test để đảm bảo `MyApp` build được với `ProviderScope`, `SharedPreferences.setMockInitialValues` và `dotenv.testLoad`.
- `test/core/widgets/dev/test/test_post_media_flow_test.dart`: unit test cho `TestPostMediaFlow` thuộc dev/test helper trong `lib/core/widgets/dev/test/test_post_media.dart`.

Phân loại hiện tại:
- Core production test: chưa có.
- Feature/domain/data production test: chưa có.
- Widget smoke test: có `test/widget_test.dart`.
- Dev/smoke/helper test: có `test/core/widgets/dev/test/test_post_media_flow_test.dart`.
- Integration/E2E test: chưa có.

Chưa có production business logic test cho:
- `core/errors`, `core/network`, `core/storage`, `core/utils`.
- `features/*/domain/usecase`.
- `features/*/data/models`, `features/*/data/repositories`.
- `features/*/presentation/controllers`.

### Test package hiện có

Trong `pubspec.yaml`, `dev_dependencies` hiện có:
- `flutter_test`
- `flutter_lints`
- `flutter_launcher_icons`

Chưa có:
- `mocktail`
- `fake_async`
- `integration_test`
- `build_runner`
- `riverpod_test`
- `bloc_test`

Ghi chú package:
- Nên thêm `mocktail` khi bắt đầu viết batch test thật.
- Chỉ thêm `fake_async` khi bắt đầu test timer/debounce/countdown sâu.
- Không thêm `bloc_test` vì code hiện tại không dùng Bloc/Cubit.
- Không thêm `integration_test` trong giai đoạn unit test.
- `build_runner` chưa cần vì kế hoạch ưu tiên mock thủ công/mocktail, chưa dùng generated mocks.
- Riverpod provider test có thể dùng `ProviderContainer` từ `flutter_riverpod`, chưa cần package riêng.

### Kiến trúc/state management hiện tại

Scan hiện tại cho thấy project dùng Riverpod là chính:
- `StateNotifierProvider` + `StateNotifier` cho auth, home, feed, safety, friends, message groups, post preview, onboarding.
- Có `StateProvider`/`FutureProvider` trong `core/providers/providers.dart`.
- Không thấy Bloc/Cubit trong `lib/`.
- Không thấy `ChangeNotifier` làm state management chính; chỉ có `ValueNotifier` trong `AppRouteStackObserver`.

Feature hiện có trong `lib/features`:
- `auth`
- `feed`
- `friend_requests`
- `friends`
- `home`
- `message_groups`
- `onboarding`
- `post_preview`
- `posts`
- `safety`
- `splash`
- `widgets`

Core module hiện có trong `lib/core`:
- `config`, `constants`, `errors`, `messages`, `network`, `notifications`, `observers`, `pages`, `preferences`, `providers`, `realtime`, `storage`, `theme`, `utils`, `widgets`.

### Cấu trúc test hiện tại

Cấu trúc test chưa mirror `lib/` và chưa có thư mục dùng chung cho fixtures/mocks/fakes. Khi triển khai test thật, chỉ tạo thư mục theo batch đang làm, không tạo cây thư mục rỗng.

## 3. Changes after latest main pull re-scan

### Confirmed still valid

- Tất cả source path cũ trong bảng plan vẫn còn tồn tại.
- Nhóm P0 core/auth/safety/posts vẫn đúng hướng và vẫn nên ưu tiên trước repository/notifier phức tạp.
- `AuthRepositoryImpl`, `AuthLocalDatasourceImpl`, `AuthNotifier`, `HomeCheckinNotifier`, `FeedNotifier`, `PostsRepositoryImpl` vẫn cần nằm sau pure logic vì cần mock/fake nhiều hơn.
- Các phần platform-heavy như camera, Firebase, SignalR, push notification vẫn không phù hợp cho batch đầu.
- Cảnh báo `AuthInterceptor` dùng `DateTime.now()` và tạo `Dio` trực tiếp vẫn còn đúng.
- Cảnh báo `HomeCheckinNotifier` dùng `Timer.periodic` và `DateTime.now()` vẫn còn đúng.
- Cảnh báo `HomeNotifier` phụ thuộc `availableCameras()`, `CameraController`, `File`, package `image` vẫn còn đúng.

### Updated entries

- Old: toàn bộ pure P0 dùng priority `P0-A`.
  New: tách thành `P0-A1`, `P0-A2`, `P0-A3`, `P0-A4`.
  Reason: P0-A quá rộng để triển khai một lượt.
- Old: Batch đầu tiên là toàn bộ `P0-A`.
  New: batch đầu tiên chỉ là `P0-A1` gồm core network/error parser và pure utils.
  Reason: giảm mock/helper, dễ pass ổn định trước khi sang usecase.
- Old: `TimeUtils` chỉ ghi là P1 chung.
  New: giữ P1 nhưng ghi rõ chỉ test pure conversion/format trước; các hàm dựa `DateTime.now()` cần fake time/clock trước khi test sâu.
- Old: risk date parser ghi chung cho message/friends models.
  New: xác nhận `MessageGroupMemberModel` và `MessageGroupRealtimeServiceImpl` đã có guard `raw.length > 10`, nhưng `MessageGroupModel`, `GroupMessageModel`, `FriendPresenceModel`, `FriendsRealtimeServiceImpl` vẫn có rủi ro `substring(10)`.
- Old: message group plan chỉ có list/detail notifier và vài model.
  New: bổ sung group management usecases/controllers/repository/models mới sau pull.

### Added entries

- `lib/core/utils/debouncer.dart`.
- `CreateMessageGroupUseCase`, `AddGroupMembersUseCase`, `SendGroupMessageUseCase`, `SendPostMessageUseCase`.
- `UpdateMessageGroupRequireApprovalUseCase`, `UpdateMessageGroupMemberCustomNameUseCase`, `DeleteMessageGroupUseCase`, `LeaveMessageGroupUseCase`.
- `MessageGroupsRepositoryImpl`.
- `CreateMessageGroupSheetNotifier`, `AddGroupMembersNotifier` và state tương ứng.
- `MessageGroupMemberModel`, `MessageGroupDetailModel`, `GroupMessagePageModel`.
- `MessageGroupRealtimeServiceImpl`, `FriendsRealtimeServiceImpl` cho P2 sau khi có abstraction/fake phù hợp.

### Removed/Stale entries

- Không có entry nào trong bảng cũ bị xóa vì source file không tồn tại.
- Không đưa thêm test cho UI thuần, splash page, static layout, theme, icon, animation vào unit test plan.
- Không đưa camera/Firebase/SignalR/push notification vào batch đầu dù code hiện tại có thêm logic liên quan.

### Open questions / need manual confirmation

- Message group management có thể nâng lên `P0-B` sau khi `P0-A` pass nếu chat là flow release-critical, nhưng hiện để `P1` để tránh mở rộng batch đầu.
- Nếu cần test notification/realtime parser sớm, nên tách parser thuần ra khỏi service platform/global trước.
- Nếu muốn test countdown/deadline sâu, cần quyết định inject clock/ticker hay tách helper thuần trước.

## 4. B. Test Strategy đề xuất

### Đánh giá nhanh kế hoạch hiện tại

Kế hoạch cũ đúng hướng nhưng vẫn quá rộng nếu triển khai một lần. Sau re-scan, `message_groups` có thêm nhiều usecase/controller mới, nên càng cần giữ batch nhỏ. Mục tiêu hiện tại là unit test theo lát mỏng, bắt đầu từ code thuần ít phụ thuộc, không động vào platform/network/storage thật.

### P0-A: batch đầu tiên, nhưng chia nhỏ

`P0-A1` - Core network/error + pure utils:
- `ApiHandler`
- `ApiResponse`
- `ExceptionToFailure`
- `EmailUtils`
- `PhoneNumberUtils`

`P0-A2` - Auth usecases thuần:
- `LoginUseCase`
- `RegisterUseCase`
- `CheckEmailAvailabilityUseCase`
- `CheckPhoneAvailabilityUseCase`
- `UpdateMeUseCase`

`P0-A3` - Safety/check-in pure logic:
- `CheckinUseCase`
- `UpdateSafetySettingsUseCase`
- `HomeCheckinState.phase`

`P0-A4` - Posts/reaction pure logic:
- `CreatePostUseCase`
- `UpdatePostUseCase`
- `SetPostReactionUseCase`
- `SetPostReactionIconUseCase`
- `DeletePostReactionUseCase`
- `ReactionSummaryModel`

### P0-B

- Repository/local datasource cần fake network/storage: `AuthRepositoryImpl`, `AuthLocalDatasourceImpl`, `PostsRepositoryImpl`.
- Notifier/state orchestration cần nhiều mock: `AuthNotifier`, `HomeCheckinNotifier`, `FeedNotifier`.
- Không test countdown/timer sâu trong `HomeCheckinNotifier` nếu chưa inject clock/ticker.

### P1

- Model mapping mở rộng cho auth, home, safety, posts, post preview, friends, friend requests, message groups.
- Profile/post-preview/safety settings/message/friends/onboarding notifiers.
- Message group management usecases/controllers mới sau pull.
- Storage/preferences wrappers.
- `Debouncer` chỉ khi bắt đầu dùng `fake_async`.

### P2

- Remote datasource endpoint/payload tests bằng mock `DioClient`.
- Realtime service mapping sau khi có fake `SignalRService` hoặc tách mapper thuần.
- Push notification parser/navigation policy sau khi tách khỏi Firebase/global router/platform.
- Camera-related logic sau khi có camera/image/file abstraction.
- Integration/E2E sau này, không trộn với unit test batch đầu.

### Không nên unit test hoặc chưa cần test

- UI thuần: màu, padding, shadow, static layout, animation.
- Camera plugin thật, Firebase messaging thật, SignalR connection thật, HTTP thật.
- File upload multipart thật trừ khi đã tách file builder hoặc dùng fake file nhỏ có kiểm soát.
- Dev/demo widget style cards, trừ logic dev-only đã có test hoặc có bug cụ thể.

### Nên để widget test hoặc E2E sau

- Login/register form render validation và navigation.
- Auth guard, route fallback, register multi-step route guard.
- Check-in/safety UI states.
- Full post creation flow camera -> preview -> upload -> create post.
- Chat list/detail realtime smoke flow.
- Push notification tap navigation.

## 5. Business-critical scenarios cần được bảo vệ bằng test

Auth/session:
- User không thể login/register/update profile với input sai.
- Email/phone availability phải normalize input trước khi gọi repository.
- Token/session được lưu đúng sau login/register.
- Logout phải clear token/session kể cả khi remote logout fail.
- Unauthorized/network/server error phải map đúng `Failure`.
- FCM token update/delete không được làm hỏng logout/session flow.

Onboarding:
- First-run flag phải đọc đúng từ storage.
- Complete onboarding phải persist đúng key và không làm app kẹt ở onboarding.

Check-in/safety:
- Check-in hợp lệ phải đánh dấu user là safe.
- Check-in input sai phải bị chặn trước khi gọi repository.
- Deadline/grace period phải phân loại đúng trạng thái.
- Monitoring off thì không được chuyển sang alert sai.
- Safety settings phải validate deadline, grace period, reminder và auto alert đúng.
- Tắt monitoring phải force auto alert off theo rule hiện tại.

Alert/deadline:
- Các phase hiện tại (`pending`, `grace`, `emergency`, `checkedIn`, `monitoringOff`, `unknown`) phải được tính đúng.
- Không phụ thuộc `DateTime.now()` thật trong unit test nếu test logic thời gian.
- Countdown/timer/auto warning chỉ test sâu sau khi inject clock/ticker hoặc tách helper thuần.

Posts/reaction/feed:
- Create/update post phải validate caption, media và location.
- Reaction không được tăng/giảm sai count.
- Toggle reaction phải xử lý đúng same reaction, different reaction và delete reaction.
- Feed local state phải cập nhật đúng sau reaction, update post và delete post.
- Post preview không được gọi upload/create khi input không hợp lệ.

Friends/friend requests:
- Send/accept/decline friend request phải map offline/remote error đúng.
- Presence event chỉ cập nhật đúng friend hiện có.
- Friend type/delete friend nên được test khi flow friends trở thành release-critical.

Message groups/chat:
- Create group/add members phải trim, bỏ id rỗng, de-duplicate và chặn danh sách rỗng.
- Require-approval toggle và member custom name phải gửi payload đã normalize.
- Send message phải trim content; send post message phải validate post/content và dùng clientMessageId đúng.
- Chat list incoming message phải move group lên đầu, update last message, unread/seen đúng.
- Mark seen/typing status phải không cập nhật sai current user.
- Realtime payload thiếu group/message/user id phải bị bỏ qua, không crash.

Notification/realtime:
- Push notification message/post reaction payload phải parse đúng trước khi navigation.
- Realtime subscriptions không được duplicate handler khi resubscribe.
- Không gọi Firebase/SignalR thật trong unit test.

Model mapping:
- JSON thiếu field/null/sai type không được làm app crash nếu code có fallback.
- Date parser phải không `RangeError` với short malformed string.
- Các model quan trọng phải parse đúng dữ liệu từ backend response.

## 6. Quy tắc triển khai theo batch nhỏ

- Không triển khai toàn bộ plan một lượt.
- Mỗi lần chỉ triển khai một batch nhỏ.
- Batch đầu tiên bắt buộc là `P0-A1`.
- Chỉ chuyển sang `P0-A2` sau khi `P0-A1` pass.
- Chỉ chuyển sang `P0-B` sau khi `P0-A1` đến `P0-A4` pass ổn định.
- Chỉ chuyển sang `P1` sau khi `P0-A` và `P0-B` ổn định.
- Không đụng camera, Firebase, SignalR, push notification hoặc E2E trong batch đầu.
- Các phần platform-heavy chỉ để `P2` hoặc task riêng sau khi đã có abstraction phù hợp.
- Nếu một test cần refactor đáng kể, hạ xuống batch sau thay vì kéo refactor vào `P0-A`.

## 7. Definition of Done cho mỗi batch

Một batch chỉ được xem là hoàn thành khi:
- Tất cả test mới pass bằng `flutter test`.
- `flutter analyze` không phát sinh lỗi mới.
- Không gọi API thật trong unit test.
- Không gọi Firebase/camera/SignalR/platform service thật trong unit test.
- Không phụ thuộc thời gian thật nếu logic có deadline/countdown.
- Không tạo mock/helper/fixture chưa dùng.
- Không tạo thư mục rỗng.
- Không sửa production code quá phạm vi cần thiết.
- Nếu có sửa production code để dễ test, phải ghi rõ lý do.
- Mỗi test deterministic, chạy lại nhiều lần vẫn cho cùng kết quả.

## 8. C. Danh sách unit test đề xuất

| Priority | Source file | Test file | Target cần test | Lý do | Test cases chính | Mock/Fake / Prerequisite |
|---|---|---|---|---|---|---|
| P0-A1 | `lib/core/network/api_handler.dart` | `test/core/network/api_handler_test.dart` | `ApiHandler.handle`, `rethrowDioException` | Core parser/error mapping cho mọi datasource | success parse data; invalid body throws `ServerException`; success false 400/401/422/500; code mapper ưu tiên message; Dio timeout -> `NetworkException`; badResponse mapped exception | Fake `Response`, `DioException` |
| P0-A1 | `lib/core/network/api_response.dart` | `test/core/network/api_response_test.dart` | `ApiResponse.fromJson` | Parse wrapper API dùng chung | success/message/code/data; `fromJsonT` được gọi khi có data; null data; optional message/code fallback | Fixture map |
| P0-A1 | `lib/core/errors/failures.dart` | `test/core/errors/failures_test.dart` | `ExceptionToFailure` | Repository phụ thuộc mapper này | Dio 401 -> `UnauthorizedFailure`; Dio timeout -> `NetworkFailure`; `ServerException` giữ status; `CacheException`; fallback exception | Fake exceptions |
| P0-A1 | `lib/core/utils/email_utils.dart` | `test/core/utils/email_utils_test.dart` | Email sanitize/validation | Dùng nhiều form/usecase, logic thuần | trim; valid mixed case; invalid missing @/domain/space | None |
| P0-A1 | `lib/core/utils/phone_number_utils.dart` | `test/core/utils/phone_number_utils_test.dart` | Phone sanitize/E.164 | Auth/profile phụ thuộc phone normalize | separators removed; VN local/84/+84 valid; invalid prefixes; international flag; E.164 conversion | None |
| P0-A2 | `lib/features/auth/domain/usecase/login_usecase.dart` | `test/features/auth/domain/usecase/login_usecase_test.dart` | `LoginUseCase` validation/delegation | Chặn input sai trước API | empty username; empty password; password < 8; valid gọi repository đúng params; repository failure pass-through | Mock `AuthRepository` |
| P0-A2 | `lib/features/auth/domain/usecase/register_usecase.dart` | `test/features/auth/domain/usecase/register_usecase_test.dart` | `RegisterUseCase` validation | Flow đăng ký có nhiều rule | empty/invalid email; empty family/given/username; password empty/<6; confirm mismatch; invalid VN phone; valid delegates | Mock `AuthRepository` |
| P0-A2 | `lib/features/auth/domain/usecase/check_email_availability_usecase.dart` | `test/features/auth/domain/usecase/check_email_availability_usecase_test.dart` | Email availability | Validation + map unavailable thành `ValidationFailure` | trims email; empty/invalid không gọi repo; available returns normalized email; unavailable returns registerEmailExists; repo failure pass-through | Mock `AuthRepository` |
| P0-A2 | `lib/features/auth/domain/usecase/check_phone_availability_usecase.dart` | `test/features/auth/domain/usecase/check_phone_availability_usecase_test.dart` | Phone availability | Chuẩn hóa phone sang E.164 trước API | empty/invalid phone; `0912345678` gọi repo `+84912345678`; unavailable -> registerPhoneExists; failure pass-through | Mock `AuthRepository` |
| P0-A2 | `lib/features/auth/domain/usecase/update_me_usecase.dart` | `test/features/auth/domain/usecase/update_me_usecase_test.dart` | Profile update validation/normalize | Dữ liệu hồ sơ nhạy cảm | no changes; blank name; invalid email/phone; email lowercase; phone E.164; valid delegates trimmed values | Mock `AuthRepository` |
| P0-A3 | `lib/features/home/domain/usecase/checkin_usecase.dart` | `test/features/home/domain/usecase/checkin_usecase_test.dart` | Check-in validation | Business rule trước API, ít phụ thuộc | note > 1000 returns validation; trims note/mediaId; valid delegates; repository failure pass-through | Mock `CheckinRepository` |
| P0-A3 | `lib/features/home/presentation/controllers/home_checkin_state.dart` | `test/features/home/presentation/controllers/home_checkin_state_test.dart` | `HomeCheckinState.phase` | Deadline/grace/emergency là logic thuần | monitoring off; checked in; pending; overdue null remaining -> emergency; overdue within grace -> grace; overdue outside grace -> emergency | None |
| P0-A3 | `lib/features/safety/domain/usecase/update_safety_settings_usecase.dart` | `test/features/safety/domain/usecase/update_safety_settings_usecase_test.dart` | Safety settings validation/normalize | Alert/deadline rule quan trọng | no field; invalid deadline; minutes <0/>1440; monitoring false forces autoAlert false; valid delegates trimmed values | Mock `SafetyRepository` |
| P0-A4 | `lib/features/posts/domain/usecase/create_post_usecase.dart` | `test/features/posts/domain/usecase/create_post_usecase_test.dart` | Create post validation | Đăng bài là flow chính | empty media; caption >2000; partial location; invalid lat/lng; blank caption -> null; valid delegates | Mock `PostsRepository` |
| P0-A4 | `lib/features/posts/domain/usecase/update_post_usecase.dart` | `test/features/posts/domain/usecase/update_post_usecase_test.dart` | Update post validation | Tránh request sai và update nhầm | empty postId; no changes; caption too long; trims postId/caption; delegates visibility | Mock `PostsRepository` |
| P0-A4 | `lib/features/posts/domain/usecase/set_post_reaction_usecase.dart` | `test/features/posts/domain/usecase/set_post_reaction_usecase_test.dart` | Reaction enum validation | Reaction là flow user-facing | empty postId validation; icon enum maps to repo; failure pass-through | Mock `PostsRepository` |
| P0-A4 | `lib/features/posts/domain/usecase/set_post_reaction_icon_usecase.dart` | `test/features/posts/domain/usecase/set_post_reaction_icon_usecase_test.dart` | Raw reaction icon validation | Backend nhận icon string | empty postId; empty icon; trim input; delegates | Mock `PostsRepository` |
| P0-A4 | `lib/features/posts/domain/usecase/delete_post_reaction_usecase.dart` | `test/features/posts/domain/usecase/delete_post_reaction_usecase_test.dart` | Delete reaction validation | Toggle reaction phụ thuộc | empty postId; valid delegates | Mock `PostsRepository` |
| P0-A4 | `lib/features/posts/data/models/reaction_summary_model.dart` | `test/features/posts/data/models/reaction_summary_model_test.dart` | Reaction summary mapping | Feed counts phụ thuộc mapping | icon map int/num/string; unknown icon ignored; missing icons -> empty; totalCount fallback 0 | Fixture map |
| P0-B | `lib/features/auth/data/repositories/auth_repository_impl.dart` | `test/features/auth/data/repositories/auth_repository_impl_test.dart` | Login/register/logout/getMe/updateMe/updateAvatar/FCM | Session/token critical nhưng cần nhiều fake | no network; login/register saves tokens/expiresAt; remote exception -> Failure; logout clears tokens even remote fails; logout offline still clears tokens | Mock remote/local/network |
| P0-B | `lib/features/auth/data/datasources/auth_local_datasource_impl.dart` | `test/features/auth/data/datasources/auth_local_datasource_impl_test.dart` | Secure token storage | Token/session persistence | save/read access/refresh token; null expiresAt deletes key; invalid expiresAt returns null; clear deletes token keys | Fake `SecureStorage` |
| P0-B | `lib/features/auth/presentation/controllers/auth_notifier.dart` | `test/features/auth/presentation/controllers/auth_notifier_test.dart` | Auth state transitions | Drives navigation/messages, nhiều dependency | login validation; login success/getMe success; login success/getMe fail; register conflict; logout clears profile and returns initial | Mock usecases/services, fake/real `AppMessageNotifier` |
| P0-B | `lib/features/home/presentation/controllers/home_checkin_notifier.dart` | `test/features/home/presentation/controllers/home_checkin_notifier_test.dart` | Load/checkin flow, không test countdown sâu | Safety flow nhưng có timer | load success status/settings; status failure sets error; checkin success updates checkedIn/streak; emergency checkin keeps overdue; duplicate checkin ignored | Mock usecases/message notifier; countdown sâu sau clock/ticker |
| P0-B | `lib/features/feed/presentation/controllers/feed_notifier.dart` | `test/features/feed/presentation/controllers/feed_notifier_test.dart` | Feed load/reaction/update/delete state | Feed là surface chính của posts/reaction | load all/me/friend delegates; loadMore appends; toggle same/different/delete reaction; update/delete post local state; failure adds message | Mock usecases, fake/real message notifier |
| P0-B | `lib/features/posts/data/repositories/posts_repository_impl.dart` | `test/features/posts/data/repositories/posts_repository_impl_test.dart` | Network guard + exception mapping | Shared posts pattern | offline returns `NetworkFailure`; remote exception mapped; create passes visibility; reaction helpers call correct remote method | Mock datasource/network |
| P1 | `lib/core/utils/time_utils.dart` | `test/core/utils/time_utils_test.dart` | Time convert/format | Safety/check-in/chat display phụ thuộc time | UTC -> VN; VN -> UTC; format date/time; parse ISO; HH:MM UTC/VN conversion; invalid HH:MM null | Pure cases first; `DateTime.now()` cases need fake clock/refactor |
| P1 | `lib/core/utils/debouncer.dart` | `test/core/utils/debouncer_test.dart` | `Debouncer.run/cancel/dispose` | Search debounce dùng trong message group add/create sheets | run after delay; second run cancels first; cancel prevents action; dispose prevents action | Add `fake_async` only when implementing this |
| P1 | `lib/core/messages/app_message_notifier.dart` | `test/core/messages/app_message_notifier_test.dart` | Global message state | Side effect UI dùng chung | add success/error/info/warning; remove by id; remove unknown no-op; ordering preserved | None |
| P1 | `lib/core/storage/shared_prefs_storage.dart` | `test/core/storage/shared_prefs_storage_test.dart` | SharedPrefs wrapper | Storage abstraction | set/get string; set/get bool; remove; clearAll | `SharedPreferences.setMockInitialValues` |
| P1 | `lib/core/preferences/app_preferences_impl.dart` | `test/core/preferences/app_preferences_impl_test.dart` | Dark mode preferences | Simple storage wrapper | default false; set true/false uses `StorageKeys.isDarkMode` | Fake `LocalStorage` |
| P1 | `lib/features/auth/data/models/user_model.dart` | `test/features/auth/data/models/user_model_test.dart` | User name fallback mapping | Backend có thể trả fullName | family/given direct; split fullName; one-part fullName; missing fallback; toJson fullName | Fixture map |
| P1 | `lib/features/auth/data/models/tokens_model.dart` | `test/features/auth/data/models/tokens_model_test.dart` | Token date mapping | Token expiry quan trọng | valid expiresAt; null/invalid date; toJson round-trip | Fixture map |
| P1 | `lib/features/auth/data/models/user_profile_model.dart` | `test/features/auth/data/models/user_profile_model_test.dart` | Profile mapping | Profile dùng nhiều màn hình | bool flags; nullable phone/avatar; invalid createdAt fallback; nullable lastLogin | Fixture map |
| P1 | `lib/features/auth/presentation/pages/register/register_draft_data.dart` | `test/features/auth/presentation/pages/register/register_draft_data_test.dart` | Draft getters/payload | Register step routing phụ thuộc | hasEmail/Password/Name/Username/Phone; copyWith; toApiPayload trims | None |
| P1 | `lib/features/auth/presentation/controllers/profile_notifier.dart` | `test/features/auth/presentation/controllers/profile_notifier_test.dart` | Profile load/update/avatar state | Profile edit user-facing | skip load when cached; force refresh; update success sets me profile/message; update failure sets error; concurrent update ignored | Mock usecases/message notifier |
| P1 | `lib/features/auth/presentation/controllers/me_profile_notifier.dart` | `test/features/auth/presentation/controllers/me_profile_notifier_test.dart` | Async profile state | Shared profile cache | fetch success; fetch failure stores `AsyncError`; setProfile; clearProfile; lastFailure | Mock `GetMeUseCase` |
| P1 | `lib/features/home/data/models/today_status_model.dart` | `test/features/home/data/models/today_status_model_test.dart` | Today status mapping | Check-in deadline/status | pending/checkedin/overdue/unknown; int parsing; date parsing; bool defaults | Fixture map |
| P1 | `lib/features/home/data/models/checkin_record_model.dart` | `test/features/home/data/models/checkin_record_model_test.dart` | Check-in record mapping | Check-in result state | manual/recovery/emergency/unknown; numeric/string lat/lng; invalid date null | Fixture map |
| P1 | `lib/features/safety/data/models/safety_settings_model.dart` | `test/features/safety/data/models/safety_settings_model_test.dart` | Safety settings mapping/toPatchJson | Settings response/payload | int/num/string minute parsing; bool defaults; toPatchJson includes editable fields | Fixture map |
| P1 | `lib/features/safety/presentation/controllers/safety_settings_notifier.dart` | `test/features/safety/presentation/controllers/safety_settings_notifier_test.dart` | Load/update state | Settings screen behavior | load skip if cached; force refresh; failure message; update success saves settings/message; update failure false | Mock usecases |
| P1 | `lib/features/post_preview/presentation/controllers/post_preview_notifier.dart` | `test/features/post_preview/presentation/controllers/post_preview_notifier_test.dart` | Upload/create orchestration | Post creation flow | empty path no-op; caption too long no upload; upload failure; create failure keeps uploaded media; success sets createdPost | Mock upload/create usecases |
| P1 | `lib/features/post_preview/data/models/media_upload_result_model.dart` | `test/features/post_preview/data/models/media_upload_result_model_test.dart` | Media upload mapping | Upload result feeds createPost | required fields; nullable thumbnail/width/height; size int/num/string; invalid createdAt null | Fixture map |
| P1 | `lib/features/message_groups/domain/usecase/create_message_group_usecase.dart` | `test/features/message_groups/domain/usecase/create_message_group_usecase_test.dart` | Create group validation | Group creation now has pure business rule | empty/blank ids -> validation; trim ids; drop blanks; de-duplicate; delegates normalized ids | Mock `MessageGroupsRepository` |
| P1 | `lib/features/message_groups/domain/usecase/add_group_members_usecase.dart` | `test/features/message_groups/domain/usecase/add_group_members_usecase_test.dart` | Add members validation | Prevent invalid member mutation | empty groupId; empty/blank ids; trim/de-duplicate ids; delegates normalized params | Mock `MessageGroupsRepository` |
| P1 | `lib/features/message_groups/domain/usecase/send_group_message_usecase.dart` | `test/features/message_groups/domain/usecase/send_group_message_usecase_test.dart` | `SendGroupMessageUseCase`, `SendPostMessageUseCase` | Chat send and shared post message rules | trim group/content; empty postId/content validation for post message; custom clientMessageId pass-through; generated id UUID shape | Mock repository; exact random id not deterministic |
| P1 | `lib/features/message_groups/domain/usecase/update_message_group_member_custom_name_usecase.dart` | `test/features/message_groups/domain/usecase/update_message_group_member_custom_name_usecase_test.dart` | Custom nickname normalize | Member nickname UX | trims group/user/name; blank customName -> null; delegates current behavior | Mock repository |
| P1 | `lib/features/message_groups/domain/usecase/update_message_group_require_approval_usecase.dart` | `test/features/message_groups/domain/usecase/update_message_group_require_approval_usecase_test.dart` | Require approval toggle | Group safety/permission rule | trims groupId; true/false delegates; repository failure pass-through | Mock repository |
| P1 | `lib/features/message_groups/domain/usecase/delete_message_group_usecase.dart` | `test/features/message_groups/domain/usecase/delete_message_group_usecase_test.dart` | Delete group delegation | Destructive group action | trims groupId; delegates; failure pass-through | Mock repository |
| P1 | `lib/features/message_groups/domain/usecase/leave_message_group_usecase.dart` | `test/features/message_groups/domain/usecase/leave_message_group_usecase_test.dart` | Leave group delegation | Membership action | trims groupId; delegates; failure pass-through | Mock repository |
| P1 | `lib/features/message_groups/data/repositories/message_groups_repository_impl.dart` | `test/features/message_groups/data/repositories/message_groups_repository_impl_test.dart` | Network guard + exception mapping | Chat/group repository now broad | offline failure; create/add/delete/leave/update/markSeen success; remote exception mapped | Mock datasource/network |
| P1 | `lib/features/message_groups/data/models/message_group_model.dart` | `test/features/message_groups/data/models/message_group_model_test.dart` | Message group mapping | Chat list sorting/unread | bool from bool/num/string; type fallback private; unread int; date with/without timezone; malformed short date after guard | Fixture map; may need production guard before negative short-date case |
| P1 | `lib/features/message_groups/data/models/message_group_member_model.dart` | `test/features/message_groups/data/models/message_group_member_model_test.dart` | Member mapping | Seen/nickname UI | family/given/customName/avatar; role int/num/string; lastSeen aliases; guarded short malformed date | Fixture map |
| P1 | `lib/features/message_groups/data/models/message_group_detail_model.dart` | `test/features/message_groups/data/models/message_group_detail_model_test.dart` | Detail mapping | Group info/members pages | members list maps; non-list members -> empty; bool/type fallback; requireApproval default false | Fixture map |
| P1 | `lib/features/message_groups/data/models/group_message_model.dart` | `test/features/message_groups/data/models/group_message_model_test.dart` | Message mapping | Chat detail | sender username fallback; UTC date with/without timezone; post nested mapping; type mapping; missing content fallback | Fixture map; may need guard before short-date negative case |
| P1 | `lib/features/message_groups/data/models/message_group_page_model.dart` | `test/features/message_groups/data/models/message_group_page_model_test.dart` | Group page mapping | Backend wrapper can be nested | payload root/data; meta limit/hasMore; non-list data -> empty | Fixture map |
| P1 | `lib/features/message_groups/data/models/group_message_page_model.dart` | `test/features/message_groups/data/models/group_message_page_model_test.dart` | Message page mapping | Chat pagination | items list; cursor/hasMore; missing list -> empty; nested data contract if supported | Fixture map |
| P1 | `lib/features/message_groups/presentation/controllers/message_group_list_notifier.dart` | `test/features/message_groups/presentation/controllers/message_group_list_notifier_test.dart` | Chat list sort/incoming/seen | Unread badge behavior | load sorts newest first; error state; incoming from current user unread 0/seen; incoming peer increments unread and moves top; seen resets unread when latest seen | Mock `GetMessageGroupsUseCase` |
| P1 | `lib/features/message_groups/presentation/controllers/group_chat_detail_notifier.dart` | `test/features/message_groups/presentation/controllers/group_chat_detail_notifier_test.dart` | Chat detail send/sort/typing/seen | Message screen state | load sorts ascending; send empty ignored; send success upserts; send failure error; incoming duplicate replaces; typing ignores current user; seen status updates member | Mock repository/realtime usecases |
| P1 | `lib/features/message_groups/presentation/controllers/create_message_group_sheet_notifier.dart` | `test/features/message_groups/presentation/controllers/create_message_group_sheet_notifier_test.dart` | Friend search/select/load-more state | New create group sheet logic | load success/error; search trims and debounce loads; loadMore append; toggle friend add/remove; duplicate/blank ignored | Mock `GetFriendsUseCase`; `fake_async` for debounce |
| P1 | `lib/features/message_groups/presentation/controllers/add_group_members_notifier.dart` | `test/features/message_groups/presentation/controllers/add_group_members_notifier_test.dart` | Add members search/select/submit state | Group member mutation UI | load/search/loadMore; toggle; submit no selection false; submit success message; submit failure error | Mock `GetFriendsUseCase`, `AddGroupMembersUseCase`; `fake_async` for debounce |
| P1 | `lib/features/friends/data/models/friend_presence_model.dart` | `test/features/friends/data/models/friend_presence_model_test.dart` | Presence date/bool mapping | Online state | bool/num/string; date with/without timezone; invalid/empty date null; short malformed date after guard | Fixture map; may need guard before short-date negative case |
| P1 | `lib/features/friends/presentation/controllers/friends_presence_notifier.dart` | `test/features/friends/presentation/controllers/friends_presence_notifier_test.dart` | Presence pagination/event update | Home/friends presence | load success/error; loadMore append; forceRefresh clears; apply event updates existing only; friendByUserId trims | Mock `GetFriendsPresenceUseCase` |
| P1 | `lib/features/friend_requests/data/models/friend_request_model.dart` | `test/features/friend_requests/data/models/friend_request_model_test.dart` | Sender/receiver fallback mapping | Received/sent lists share model | receiver fields preferred; sender fallback; createdAt invalid null | Fixture map |
| P1 | `lib/features/friend_requests/data/repositories/friend_request_repository_impl.dart` | `test/features/friend_requests/data/repositories/friend_request_repository_impl_test.dart` | Friend request repository | Request actions user-facing | offline failure; send/accept/decline success; remote exception mapped; get received/sent delegates | Mock datasource/network |
| P1 | `lib/features/onboarding/data/datasources/onboarding_local_datasource_impl.dart` | `test/features/onboarding/data/datasources/onboarding_local_datasource_impl_test.dart` | Onboarding storage key | First-run flow | default false; completed true; uses `StorageKeys.hasCompletedOnboarding` | Fake `LocalStorage` |
| P1 | `lib/features/onboarding/presentation/controllers/onboarding_notifier.dart` | `test/features/onboarding/presentation/controllers/onboarding_notifier_test.dart` | Complete onboarding state | First-run UX | success loading -> completed; exception -> error and app message | Mock usecase/message notifier |
| P2 | `lib/features/*/data/datasources/*_remote_datasource_impl.dart` | `test/features/<feature>/data/datasources/*_remote_datasource_impl_test.dart` | Endpoint/payload/query mapping | Useful after P0/P1 coverage | endpoint constants; query trims cursor; body omits null/blank fields; `ApiHandler` error rethrow | Mock `DioClient`; no real API |
| P2 | `lib/core/network/interceptor.dart` | `test/core/network/auth_interceptor_test.dart` | Auth header/refresh behavior | Important but hard to isolate | adds Bearer token; skips auth endpoints; expired token refresh success/failure; clears tokens on refresh failure | Needs small refactor: inject clock + refresh client/factory |
| P2 | `lib/core/notifications/push_notification_service.dart` | `test/core/notifications/push_notification_service_test.dart` | Payload parsing/token sync decisions | Notification navigation important but platform-heavy | unsupported platform no-op; empty token no-op; post reaction payload parsing; message payload group construction | Needs extracted parser/navigation policy or heavy mocks |
| P2 | `lib/core/realtime/signalr_service.dart` | `test/core/realtime/signalr_service_test.dart` | SignalR wrapper | Hard to test without hub abstraction | no token skips connect; duplicate connect awaits pending; empty invoke ignored | Needs wrapper/interface around `HubConnectionBuilder` |
| P2 | `lib/features/message_groups/data/services/message_group_realtime_service_impl.dart` | `test/features/message_groups/data/services/message_group_realtime_service_impl_test.dart` | Realtime DTO mapping/subscription behavior | Chat realtime critical but SignalR-dependent | invalid args ignored; unread count parsing; typing status parsing; seen fallback event; join/leave trims groupId | Prefer fake `SignalRService`/extracted mapper |
| P2 | `lib/features/friends/data/services/friends_realtime_service_impl.dart` | `test/features/friends/data/services/friends_realtime_service_impl_test.dart` | Presence realtime DTO mapping | Online status realtime | map payload object; map positional args; invalid/empty user ignored; short date guard | Prefer fake `SignalRService`/extracted mapper |
| P2 | `lib/features/home/presentation/controllers/home_notifier.dart` | `test/features/home/presentation/controllers/home_notifier_test.dart` | Camera state and crop helpers | Camera/File IO heavy | reset/copyWith pure state first; camera failure messages only after abstraction | Needs camera service + image/file adapter |

Ghi chú:
- Các test cần inject clock, fake timer, camera/Firebase/SignalR abstraction không được đưa vào `P0-A1` đến `P0-A4`.
- Các test cần refactor nhỏ nhưng giá trị cao có thể để `P0-B` hoặc `P1`.
- Các test cần refactor lớn hoặc platform abstraction phải để `P2` hoặc task riêng.

## 9. D. Cấu trúc thư mục test đề xuất

```text
test/
  core/
    errors/
    messages/
    network/
    preferences/
    storage/
    utils/
  features/
    auth/
      data/
        datasources/
        models/
        repositories/
      domain/usecase/
      presentation/
        controllers/
        pages/register/
    feed/
      presentation/controllers/
    friend_requests/
      data/
        models/
        repositories/
      domain/usecase/
    friends/
      data/
        models/
        repositories/
        services/
      domain/usecase/
      presentation/controllers/
    home/
      data/models/
      domain/usecase/
      presentation/controllers/
    message_groups/
      data/
        models/
        repositories/
        services/
      domain/usecase/
      presentation/controllers/
    onboarding/
      data/
        datasources/
        repositories/
      domain/usecase/
      presentation/controllers/
    post_preview/
      data/
        models/
        repositories/
      domain/usecase/
      presentation/controllers/
    posts/
      data/
        models/
        repositories/
      domain/usecase/
    safety/
      data/
        models/
        repositories/
      domain/usecase/
      presentation/controllers/
  fixtures/
    auth/
    posts/
    message_groups/
    friends/
    safety/
    checkin/
  helpers/
    provider_container.dart
    test_data.dart
  mocks/
    mock_repositories.dart
    mock_datasources.dart
    mock_usecases.dart
    fake_storage.dart
    fake_network_info.dart
```

Không tạo toàn bộ cây thư mục ngay. Tạo theo batch test đang triển khai để tránh thư mục rỗng và helper chưa dùng.

## 10. E. Quy ước viết test

- File test mirror source path và kết thúc bằng `_test.dart`.
- `group()` theo class/function chính, ví dụ `group('LoginUseCase', ...)`.
- Tên `test()` mô tả behavior, ví dụ `returns ValidationFailure when password is shorter than 8 characters`.
- Mỗi test dùng Arrange - Act - Assert. Chỉ thêm comment `// Arrange`, `// Act`, `// Assert` khi test dài.
- Không gọi API thật, Firebase thật, camera thật, SignalR thật, secure storage thật trong unit test.
- Mock dependency ở boundary: repository, datasource, network info, storage, usecase, message notifier, realtime service.
- Dùng fake/in-memory khi behavior đơn giản hơn mock: `FakeNetworkInfo`, `FakeSecureStorage`, `FakeLocalStorage`.
- Dùng fixture JSON cho payload nested hoặc lặp lại nhiều lần: posts, message groups, profile, safety.
- Không mock class đang được test.
- Không verify quá nhiều implementation detail. Ưu tiên assert state/output/failure. Chỉ `verify()` call khi contract quan trọng, ví dụ repository không được gọi khi validation fail.
- Mỗi `StateNotifier` test tạo instance mới và dispose sau test nếu cần.
- Riverpod provider tests dùng `ProviderContainer` riêng từng test và dispose trong `addTearDown`.
- Logic phụ thuộc thời gian phải deterministic. Với code hiện tại, ưu tiên refactor nhỏ để inject clock trước khi test countdown/deadline sâu.
- Unit test không kiểm tra màu/padding/icon/animation. Những phần đó để widget/golden test sau nếu thật sự có rủi ro.

## 11. F. Rủi ro và điểm nên refactor nhỏ trước khi test

- Trong `P0-A1` đến `P0-A4`, không refactor các service platform-heavy như camera, Firebase, SignalR, push notification.
- Trong `P0-A`, chỉ refactor nhỏ nếu bắt buộc để test pure logic. Nếu cần refactor đáng kể, hạ target xuống `P0-B`/`P1`/`P2`.
- Mọi refactor lớn phải được ghi thành TODO/task riêng, không thực hiện lẫn với batch test đầu tiên.
- Nếu logic đang nằm trong UI nhưng chưa cần test ngay, chỉ ghi nhận là rủi ro, chưa refactor.
- Nếu code dùng `DateTime.now()` hoặc `Timer.periodic`, chỉ test phần pure logic trước; countdown/timer sâu để batch sau sau khi inject clock/ticker.
- `AuthInterceptor` vẫn dùng `DateTime.now()` và tạo `Dio` trực tiếp trong `_performRefreshTokenRequest()`. Nếu muốn test refresh-token nghiêm túc, nên inject clock và refresh client/factory.
- `HomeCheckinNotifier` vẫn dùng `Timer.periodic` và `DateTime.now()` trực tiếp. Nên inject clock/ticker hoặc tách `_calculateRemainingSeconds` thành service/helper thuần trước khi test countdown/auto-alert.
- `HomeNotifier` vẫn phụ thuộc `availableCameras()`, `CameraController`, `File`, package `image`, `DateTime.now()`. Không refactor lớn lúc này; chỉ test `HomeState` thuần nếu cần, camera flow để P2/task riêng.
- `PushNotificationService` vẫn phụ thuộc Firebase static streams, global `appRouter`, platform và `HttpClient` để tải avatar notification. Nên tách payload parser/navigation decision thành helper thuần nếu cần unit test.
- `SignalRService` vẫn trực tiếp tạo `HubConnectionBuilder`. `MessageGroupRealtimeServiceImpl` và `FriendsRealtimeServiceImpl` có logic mapper đáng test nhưng nên có fake `SignalRService` hoặc tách mapper thuần trước.
- `SendPostMessageUseCase` dùng `Random.secure()` trực tiếp. Nếu cần assert clientMessageId deterministic, inject id generator; hiện chỉ nên test shape UUID và custom id pass-through.
- Date parser hiện vẫn có rủi ro `raw.substring(10)` không guard trong `MessageGroupModel`, `GroupMessageModel`, `FriendPresenceModel`, `FriendsRealtimeServiceImpl`. `MessageGroupMemberModel` và `MessageGroupRealtimeServiceImpl` đã có guard `raw.length > 10`.
- Một số `copyWith` còn khó clear nullable field (`MessageGroupListState`, `GroupChatDetailState`). Nếu test cần clear `errorMessage`/`groupDetail`, nên bổ sung clear flag nhỏ, không refactor rộng.
- Datasource upload/avatar gọi `MultipartFile.fromFile`, cần file thật nếu test trực tiếp. Giai đoạn đầu nên test usecase/notifier bằng mock; datasource multipart để P2 hoặc tách file builder.
- `DioClient` là concrete class, có thể mock bằng `mocktail` nhưng dài hạn có thể thêm abstraction nếu datasource test tăng nhiều.

## 12. G. Kế hoạch triển khai theo bước

1. Chuẩn hóa test dependencies:
   - Thêm `mocktail` vào `dev_dependencies`.
   - Chỉ thêm `fake_async` khi bắt đầu test timer/debounce/deadline sâu.
   - Chưa thêm `integration_test` trong giai đoạn unit test.
   - Chưa thêm `bloc_test`; code hiện tại không dùng Bloc/Cubit.
   - Chưa thêm `build_runner` nếu không dùng generated mocks.

2. Batch đầu tiên: `P0-A1`
   - `ApiHandler`, `ApiResponse`, `ExceptionToFailure`.
   - `EmailUtils`, `PhoneNumberUtils`.
   - Không tạo fixture/mock/helper ngoài phần test đang dùng.
   - Không đụng clock/timer/platform.

3. Batch `P0-A2`
   - `LoginUseCase`, `RegisterUseCase`.
   - `CheckEmailAvailabilityUseCase`, `CheckPhoneAvailabilityUseCase`.
   - `UpdateMeUseCase`.
   - Dùng mock `AuthRepository`, không storage/network thật.

4. Batch `P0-A3`
   - `CheckinUseCase`.
   - `HomeCheckinState.phase`.
   - `UpdateSafetySettingsUseCase`.
   - Không test `HomeCheckinNotifier` countdown sâu ở batch này.

5. Batch `P0-A4`
   - `CreatePostUseCase`, `UpdatePostUseCase`.
   - Reaction usecases.
   - `ReactionSummaryModel`.

6. Batch `P0-B`
   - `AuthRepositoryImpl`, `AuthLocalDatasourceImpl`, `PostsRepositoryImpl`.
   - `AuthNotifier`, `HomeCheckinNotifier`, `FeedNotifier`.
   - Tạo fake storage/network/message notifier nếu cần và chỉ khi test dùng ngay.

7. Batch `P1`
   - Model mapping mở rộng.
   - Profile/post-preview/safety settings/onboarding/friends/message group notifiers.
   - Message group management usecases/controllers mới.
   - Storage/preference wrappers.
   - `Debouncer` khi đã thêm `fake_async`.

8. Batch `P2`
   - Remote datasource endpoint/payload tests bằng mock `DioClient`.
   - Realtime service mapping sau khi có fake `SignalRService` hoặc mapper thuần.
   - Push notification parser sau khi tách logic thuần.
   - Camera-related logic sau khi có camera/image/file abstraction.
   - Integration/E2E sau này, không trộn với unit test batch đầu.

9. Coverage và quality gate:
   - Chạy `flutter test` sau mỗi batch.
   - Chạy `flutter analyze` trước khi merge.
   - Chạy coverage để phát hiện vùng logic quan trọng còn trống.
   - Không chạy theo coverage bằng cách test UI thuần, màu sắc, padding hoặc animation.

## 13. H. Lệnh chạy test

```powershell
flutter test
```

Chạy một file:

```powershell
flutter test test/features/auth/domain/usecase/login_usecase_test.dart
```

Chạy một nhóm test theo tên:

```powershell
flutter test --plain-name "LoginUseCase"
```

Coverage:

```powershell
flutter test --coverage
```

Nếu máy có `lcov/genhtml`:

```powershell
genhtml coverage/lcov.info -o coverage/html
```

## 14. Package cần thêm

Nên thêm ở giai đoạn viết test thật:

```yaml
dev_dependencies:
  mocktail: any
```

Chỉ thêm `fake_async` khi bắt đầu test countdown/timer/debounce/deadline sâu:

```yaml
dev_dependencies:
  fake_async: any
```

Khi thực hiện, pin version theo version hiện hành tương thích Dart/Flutter của project. Không cần thêm `bloc_test` hiện tại vì project không dùng Bloc/Cubit. Không thêm `integration_test` cho `P0-A`/`P0-B`; chỉ thêm khi chuyển sang E2E.
