Bạn là Flutter senior engineer trong codebase Beacon.

Hãy thực hiện task:

# Phase 2: UserProfileCache

## Bối cảnh

Các phase trước đã hoàn thành và đã verify:

- Đã thêm Isar database foundation.
- Đã thêm collection thật đầu tiên `SafetySettingsCache`.
- Đã thêm `CurrentUserCacheScope`.
- `currentUserId` được lưu trong `SecureStorage`.
- `AuthRepositoryImpl` đã cập nhật:
  - login success lưu current user id nếu có.
  - register success lưu current user id nếu có.
  - getMe success lưu current user id.
  - logout clear current user id.
- `SafetyRepositoryImpl` đã tích hợp cache fallback qua `SafetySettingsCache`.

Bây giờ triển khai phase tiếp theo:

`UserProfileCache`

## Skill bắt buộc phải đọc trước khi làm

Trước khi sửa code, hãy đọc và tuân thủ:

- `.agents/skills/local-database-skill/SKILL.md`
- `.agents/skills/test-strategy-skill/SKILL.md`
- `.agents/skills/context-engineering-skill/SKILL.md` nếu có trong project

Phải tuân thủ:
- Không import database sai tầng.
- Không import Isar vào presentation/controller/notifier/widget/domain/usecase.
- Không annotate API model hoặc domain entity bằng `@collection`.
- Không lưu token/secret/password/FCM token vào Isar.
- Không dùng token/email/username/device id làm cache scope.
- Không chạy lệnh Flutter/Dart.
- Không tạo folder rỗng, helper/fake/fixture chưa dùng.
- Test phải deterministic.

## Mục tiêu

Triển khai cache local cho user profile.

Sau task này:

### Khi online

`getMe`:
- gọi remote như hiện tại;
- remote success thì trả profile remote;
- đồng thời upsert `UserProfileCache` theo `cacheScopeUserId`.

`updateMe`:
- gọi remote như hiện tại;
- remote success thì trả profile remote;
- đồng thời upsert `UserProfileCache`.

`updateMyAvatar` nếu repository hiện có method này:
- gọi remote như hiện tại;
- remote success thì trả profile/avatar result hiện tại;
- nếu response có đủ profile hoặc avatar data cần thiết thì cập nhật cache phù hợp;
- nếu không đủ dữ liệu để cập nhật cache an toàn, không hack.

### Khi offline

`getMe`:
- lấy `currentUserId` từ `CurrentUserCacheScope`;
- nếu có `currentUserId` và có `UserProfileCache` tương ứng thì trả cached profile;
- nếu không có `currentUserId` hoặc không có cache thì giữ behavior cũ: trả `NetworkFailure`.

### Failure

- `UnauthorizedFailure`, `ServerFailure`, `ValidationFailure` hoặc failure nghiệp vụ không được fallback cache âm thầm.
- Không hỗ trợ offline update profile/avatar trong phase này.
- Mutation failure không mutate cache.

## Phạm vi được phép thêm

Có thể thêm:

```text
lib/features/auth/data/local_models/user_profile_cache.dart
lib/features/auth/data/mappers/user_profile_cache_mapper.dart
lib/features/auth/data/datasources/user_profile_local_datasource.dart
lib/features/auth/data/datasources/user_profile_local_datasource_impl.dart

Có thể thêm test tương ứng, ví dụ:

test/features/auth/data/mappers/user_profile_cache_mapper_test.dart

Nếu repository test hiện tại đã có auth_repository_impl_test.dart, hãy cập nhật file hiện có thay vì tạo test trùng lặp.

Chỉ tạo fake/helper mới nếu được dùng thật trong test.

Phạm vi được phép sửa

Có thể sửa:

lib/core/database/isar_collections.dart
lib/core/providers/providers.dart
lib/features/auth/data/repositories/auth_repository_impl.dart
test/features/auth/data/repositories/auth_repository_impl_test.dart

Có thể sửa các test auth liên quan nếu constructor/provider behavior thay đổi.

Không được phép sửa

Không sửa các vùng sau trong task này:

lib/features/safety/data/repositories/safety_repository_impl.dart
lib/features/home/
lib/features/posts/
lib/features/feed/
lib/features/friends/
lib/features/friend_requests/
lib/features/message_groups/
lib/features/post_preview/

Không sửa:

UI.
Controller/notifier nếu không bắt buộc.
Usecase.
Remote datasource nếu không bắt buộc.
Token storage behavior ngoài những gì đã có.
Safety cache behavior đã pass.
TodayStatusCache.
Posts/feed cache.
Offline mutation queue.
Quy tắc kiến trúc
Không import Isar trong:
presentation;
controller/notifier;
widget;
domain entity;
usecase.
Không annotate API model hoặc domain entity bằng @collection.
Tạo cache model riêng:
UserProfileCache
Repository chỉ trả domain entity/result hiện có, không trả cache model.
Local datasource chỉ phụ trách đọc/ghi cache.
Mapper chịu trách nhiệm chuyển đổi:
remote/domain model -> cache;
cache -> domain entity/model hiện repository đang trả.
Không làm behavior nghiệp vụ thay đổi ngoài cache fallback đã mô tả.
Quy tắc user cache scope

UserProfileCache là dữ liệu user-scoped.

Bắt buộc có field scope, ví dụ:

cacheScopeUserId

Quy tắc:

cacheScopeUserId lấy từ CurrentUserCacheScope.
Với getMe online success:
nếu response có profile id đáng tin cậy, có thể dùng chính profile id đó để save/update current user id và upsert cache;
nếu current user id chưa tồn tại nhưng profile id tồn tại, dùng profile id làm scope.
Với offline getMe:
chỉ đọc cache nếu CurrentUserCacheScope.getCurrentUserId() trả user id hợp lệ.
Không tạo key tạm bằng token/email/username/device id.
Không cache bằng key global kiểu current_user.
Không để profile user A hiển thị cho user B.
Logout clear current user id đã có ở phase trước; trong phase này nếu có cơ chế clear profile cache khi logout mà không phải sửa rộng thì có thể làm, nhưng nếu phải động rộng vào auth/logout flow thì báo lại trước.
Quy tắc dữ liệu local

UserProfileCache nên chứa các field cần thiết để khôi phục profile domain/entity hiện tại.

Hãy đọc kỹ UserProfileModel, UserProfile, AuthResponse hoặc model liên quan trong codebase trước khi quyết định field.

Field thường cần cân nhắc:

cacheScopeUserId
userId / id
username
email
familyName
givenName
fullName nếu domain cần
phoneNumber nếu có
avatarUrl / avatarId nếu có
isActive / flags nếu có
createdAt / updatedAt / lastLogin nếu có
cachedAtUtc

Không lưu:

access token;
refresh token;
password;
secret;
FCM token.

Nếu có field nhạy cảm hoặc không chắc có nên cache không, hãy chọn phương án tối thiểu và giải thích.

Behavior mong muốn cho AuthRepositoryImpl

Chỉ tích hợp vào các method thật sự tồn tại trong codebase.

getMe

Luồng mong muốn:

Nếu online:
gọi remote như hiện tại;
nếu remote success:
lưu current user id nếu profile id hợp lệ;
upsert UserProfileCache;
trả remote profile;
nếu remote failure nghiệp vụ:
trả failure;
không fallback cache âm thầm.
Nếu offline:
lấy current user id;
nếu không có current user id: trả NetworkFailure;
nếu có current user id:
đọc UserProfileCache;
có cache thì trả cached profile;
không có cache thì trả NetworkFailure.
updateMe

Luồng mong muốn:

Nếu online:
gọi remote như hiện tại;
remote success:
cập nhật current user id nếu cần;
upsert UserProfileCache;
trả remote profile;
remote fail:
không mutate cache;
trả failure hiện tại.
Nếu offline:
giữ behavior hiện tại, trả NetworkFailure.
updateMyAvatar hoặc method tương đương

Nếu method trả về full profile:

remote success thì upsert profile cache.

Nếu method chỉ trả về avatar url/id:

chỉ cập nhật field avatar trong cache nếu local datasource hỗ trợ update partial an toàn.
Nếu chưa có cache hoặc thiếu scope, không hack.

Nếu method không đủ dữ liệu:

không cập nhật cache và ghi rõ lý do trong output.
logout

Nếu trong phase này có thể clear UserProfileCache theo current user id một cách an toàn:

clear profile cache khi logout.

Nếu logout hiện clear current user id trước khi có thể clear profile cache:

không sửa rộng nếu rủi ro;
báo lại cần task cache cleaner chung sau.

Không làm cache cleaner toàn cục phức tạp trong phase này nếu vượt scope.

Metadata stale/cache

UserProfileCache phải có:

cachedAtUtc

Nếu domain/state hiện tại chưa hỗ trợ metadata isFromCache hoặc cachedAtUtc, không ép sửa UI trong phase này.

Cache model và mapper/local datasource phải giữ metadata để phase sau có thể dùng.

Provider wiring

Trong lib/core/providers/providers.dart:

Thêm provider cho UserProfileLocalDatasource nếu repository cần inject.
Wire AuthRepositoryImpl với local datasource và CurrentUserCacheScope.
Không thêm provider cho feature khác.
Không tạo provider chưa dùng.
Test yêu cầu
Mapper test

Test mapper cho UserProfileCache:

domain/model -> cache.
cache -> domain.
có cacheScopeUserId.
có cachedAtUtc.
nullable/default field theo behavior hiện có.
không map token/secret vào cache.
Local datasource test

Nếu test Isar thật gây nặng, không bắt buộc gọi Isar thật trong unit test.

Ưu tiên:

fake/in-memory local datasource cho repository test;
mapper test thuần;
local datasource test bằng fake nếu có abstraction.

Nếu cần test adapter Isar thật:

tách riêng thành smoke test nhỏ;
không trộn với business unit test;
không tự chạy test.
AuthRepositoryImpl test

Cập nhật/thêm test tối thiểu:

getMe online success upsert cache theo user id.
getMe online success khi current user id chưa có nhưng profile id có thì vẫn cache theo profile id.
getMe online success nhưng không có user id hợp lệ thì không cache, vẫn trả remote success nếu behavior hiện tại cho phép.
getMe offline có current user id và có cache thì trả cached profile.
getMe offline không có current user id thì trả NetworkFailure.
getMe offline có current user id nhưng không có cache thì trả NetworkFailure.
Remote unauthorized/server/validation failure không fallback cache.
updateMe success upsert cache.
updateMe failure không update cache.
updateMe offline trả NetworkFailure.
logout vẫn clear token/current user id như phase trước.
nếu có clear profile cache trong logout, test clear cache được gọi.

Không gọi Isar thật trong repository unit test.

Nếu không thể tích hợp một phần

Nếu phát hiện method nào không đủ dữ liệu để cache an toàn, hãy:

Không hack.
Giữ behavior hiện tại.
Báo rõ:
method nào chưa tích hợp cache;
thiếu field gì;
file/model nào cần bổ sung hoặc cần task sau.
Ràng buộc command

Không tự chạy:

flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
flutter build apk --debug

Sau khi sửa xong, chỉ trả command để tôi chạy thủ công.

Output sau khi hoàn thành

Trả lời bằng tiếng Việt có dấu, gồm:

Tóm tắt đã làm.
Skill đã đọc.
File đã thêm.
File đã sửa.
Collection schema mới là gì.
UserProfileCache gồm những field chính nào.
User profile cache scope lấy từ đâu.
AuthRepositoryImpl đã thay đổi behavior gì.
Method nào chưa cache được và lý do nếu có.
Test đã thêm/sửa.
Có chạy lệnh Flutter/Dart không.
Command tôi cần chạy thủ công.
Expected result cho từng command.
Nếu fail cần gửi log nào.
Rollback plan.
Command verify đề xuất

Trả lại cho tôi các command sau, không tự chạy:

dart run build_runner build --delete-conflicting-outputs

Mục đích: sinh .g.dart cho UserProfileCache.
Expected result: generated file được tạo/cập nhật, không có lỗi generator.

flutter test test/features/auth

Mục đích: chạy test auth repository/current user/profile cache.
Expected result: test auth pass.

flutter test test/features/safety

Mục đích: regression safety cache sau khi thêm schema/provider mới.
Expected result: test safety pass.

flutter analyze

Mục đích: kiểm tra static analysis.
Expected result: không có error mới.

Nếu ổn, mới chạy:

flutter test

Mục đích: regression toàn bộ test.
Expected result: toàn bộ test pass.

Nếu cần smoke build Android:

flutter build apk --debug

Mục đích: kiểm tra build Android với Isar native libs và generated code.
Expected result: build debug thành công.

Rollback plan bắt buộc

Nếu phase này fail, rollback phải gồm:

Xóa UserProfileCache và generated files liên quan.
Xóa user profile local datasource/cache mapper.
Gỡ schema khỏi isar_collections.dart.
Gỡ provider user profile local datasource.
Khôi phục AuthRepositoryImpl về behavior trước phase 2.
Khôi phục test auth liên quan.
Giữ database foundation, SafetySettingsCache, CurrentUserCacheScope và safety repository cache nếu chúng đã pass từ phase trước.
App quay lại trạng thái chỉ có safety cache, chưa có profile cache.

Nhắc lại:

Chỉ làm UserProfileCache.
Không làm TodayStatusCache.
Không làm posts/feed cache.
Không làm offline mutation.
Không chạy lệnh Flutter/Dart.
Không hack user scope.