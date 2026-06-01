Kế Hoạch Dev DB In-Memory Và Test N2N Beacon
Summary
Giữ môi trường hiện tại/production dùng SQL Server như cũ.
Thêm môi trường dev/test ở BE dùng EF Core InMemory, seed data cố định, reset được trước mỗi lần chạy test.
Sửa Flutter integration test để gọi BE thật qua HTTP, không fake repository/backend ở mobile nữa.
Tách auth N2N thành 2 flow đúng behavior thật: register -> Home và login bằng seeded user -> Home.
Key Changes
Backend thêm config:
Database__Provider=SqlServer|InMemory, mặc định SqlServer.
DevSeed__Enabled=true|false.
DevSeed__ResetOnStartup=true|false.
DevSeed__ResetToken=<local secret> cho reset endpoint dev-only.
ExternalServices__UseNoOpStorage=true|false để tránh phụ thuộc MinIO khi test auth N2N.
Backend thêm dev-only endpoint:
POST /api/v1/dev/test-data/reset
Chỉ hoạt động khi ASPNETCORE_ENVIRONMENT=Development và Database__Provider=InMemory.
Yêu cầu header token, ví dụ X-Dev-Seed-Token.
Endpoint sẽ EnsureDeleted, EnsureCreated, rồi seed lại data.
Backend seed tối thiểu:
User login seeded: username/password cố định cho test login.
Ít nhất 1 user bạn bè và friendship để Home preload không phụ thuộc dữ liệu rỗng.
Safety settings mặc định cho seeded users.
Không seed media/posts trong phase đầu để không cần MinIO.
Backend startup:
Nếu SqlServer: chạy migration hiện tại như cũ.
Nếu InMemory: bỏ migration, bỏ Hangfire SQL storage, bỏ SQL health check, dùng NoOp storage nếu config bật.
Production không expose reset endpoint và không chạy dev seed.
Mobile env:
Cho BASE_URL, SIGNALR_HUB_URL, APP_ENV, DEV_SEED_RESET_TOKEN đọc ưu tiên từ --dart-define, fallback về .env.
Test N2N trỏ BASE_URL tới BE dev, ví dụ emulator Android dùng http://10.0.2.2:5000/api/v1, desktop dùng http://localhost:5000/api/v1.
Mobile Test Changes
Thay integration_test/helpers/integration_test_app.dart:
Không override authRepositoryProvider, checkinRepositoryProvider, postsRepositoryProvider, friendsRepositoryProvider, messageGroupsRepositoryProvider, safetyRepositoryProvider.
Giữ override hợp lý cho test harness: SharedPreferences, in-memory auth local datasource, fake/no-op push notification, optional always-connected NetworkInfo.
Gọi reset endpoint BE trước khi pump app.
Sửa test hiện tại:
register_flow_n2n_test: reset seed, đi onboarding -> register bằng user test, expect HomePage.
login_flow_n2n_test: reset seed, đi onboarding -> login bằng seeded user, expect HomePage.
Bỏ assert fake call count vì không còn fake repository.
Cập nhật docs command chạy:
Start BE với Database__Provider=InMemory, DevSeed__Enabled=true.
Run Flutter integration test với --dart-define=BASE_URL=... và --dart-define=DEV_SEED_RESET_TOKEN=....
Test Plan
BE:
Unit/integration test cho seeder idempotent.
Test reset endpoint: success trong Development + InMemory + token đúng; reject khi Production, SqlServer, hoặc token sai.
Test startup InMemory không gọi migration/Hangfire SQL.
Mobile:
flutter analyze integration_test lib/core/config lib/core/network.
Chạy register_flow_n2n_test với BE dev đang chạy.
Chạy login_flow_n2n_test với BE dev đang chạy.
Chạy lại auth unit tests liên quan để chắc env fallback không phá behavior cũ.
Manual smoke:
Đổi env về production/current SQL Server, API vẫn dùng connection hiện tại và không expose reset endpoint.
Assumptions
InMemory DB mất dữ liệu khi API restart là chấp nhận được.
Reset seed trước mỗi test run là hành vi mặc định.
N2N nghĩa là mobile gọi BE thật qua HTTP; chỉ fake các side effect local như push notification/storage token, không fake backend/repository.
BE repo đang có nhiều thay đổi chưa commit, khi implement phải giữ nguyên và không revert các thay đổi không thuộc scope này.