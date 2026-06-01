# Integration Test Guide

## Muc tieu

Integration test N2N cua Beacon dung de kiem tra mobile app that goi backend API that qua HTTP. Trong auth N2N hien tai, mobile khong fake backend/repository nua.

Hai flow dang co:

```text
Register flow: Splash -> Onboarding -> Register -> Home
Login flow:    Splash -> Onboarding -> Login seeded user -> Home
```

Backend chay bang EF Core InMemory DB trong moi truong dev/test. Truoc moi test, mobile goi reset endpoint cua backend de xoa DB InMemory va seed lai data co dinh.

## N2N khac fake test nhu the nao

N2N flow:

```text
Flutter integration test
  -> MyApp that
  -> Auth UI that
  -> Riverpod providers that
  -> AuthRepository that
  -> Dio HTTP client
  -> Beacon API Docker o localhost:5000
  -> EF Core InMemory DB seeded san
```

Nhung thu duoc fake trong N2N chi la side effect local:

- `SharedPreferences`: dung mock storage de test khong dung storage that cua may.
- `AuthLocalDatasource`: luu access token/refresh token trong memory cho test.
- `NetworkInfo`: tra ve always-connected de test khong phu thuoc platform network API.
- `PushNotificationService`: no-op, vi auth N2N khong test FCM/platform notification.

Nhung thu khong fake:

- `authRepositoryProvider`
- `checkinRepositoryProvider`
- `postsRepositoryProvider`
- `friendsRepositoryProvider`
- `messageGroupsRepositoryProvider`
- `safetyRepositoryProvider`
- Backend API
- Database state cua backend

## Backend env files

Hai file env tien loi nam o backend repo:

```text
C:\Users\Admin\Desktop\Beacon\Beacon-CA\.env.n2n
C:\Users\Admin\Desktop\Beacon\Beacon-CA\.env.sqlserver
```

Hai file nay la override file. Khi dung Docker Compose, hay truyen chung voi file `.env` base:

```powershell
cd C:\Users\Admin\Desktop\Beacon\Beacon-CA
docker compose --env-file .env --env-file .env.n2n up -d --build --force-recreate api
```

File `.env` base van giu cac bien chung nhu DB password, JWT secret, MinIO credential, Firebase credential. File `.env.n2n` chi override cac bien lien quan den che do test N2N.

### .env.n2n

Dung khi chay Flutter N2N integration test.

```env
DATABASE_PROVIDER=InMemory
DEV_SEED_ENABLED=true
DEV_SEED_RESET_ON_STARTUP=true
DEV_SEED_RESET_TOKEN=local-n2n-token
EXTERNAL_SERVICES_USE_NOOP_STORAGE=true
```

Y nghia:

- `DATABASE_PROVIDER=InMemory`: backend dung EF Core InMemory thay vi SQL Server. Startup se khong chay migration SQL.
- `DEV_SEED_ENABLED=true`: bat dev seeder va cho phep reset endpoint hoat dong.
- `DEV_SEED_RESET_ON_STARTUP=true`: moi lan API start se reset DB va seed lai data co dinh.
- `DEV_SEED_RESET_TOKEN=local-n2n-token`: token local ma mobile test phai gui trong header `X-Dev-Seed-Token`.
- `EXTERNAL_SERVICES_USE_NOOP_STORAGE=true`: backend dung storage no-op de auth/home test khong phu thuoc MinIO upload/download.

### .env.sqlserver

Dung de quay lai backend current/normal SQL Server mode.

```env
DATABASE_PROVIDER=SqlServer
DEV_SEED_ENABLED=false
DEV_SEED_RESET_ON_STARTUP=false
DEV_SEED_RESET_TOKEN=
EXTERNAL_SERVICES_USE_NOOP_STORAGE=false
```

Y nghia:

- `DATABASE_PROVIDER=SqlServer`: backend dung SQL Server va migration nhu cu.
- `DEV_SEED_ENABLED=false`: tat dev seeder va reset endpoint.
- `DEV_SEED_RESET_ON_STARTUP=false`: khong reset DB khi API start.
- `DEV_SEED_RESET_TOKEN=`: khong cau hinh token reset.
- `EXTERNAL_SERVICES_USE_NOOP_STORAGE=false`: dung MinIO/storage that theo config hien tai.

## Cach bat backend N2N

Chay:

```powershell
cd C:\Users\Admin\Desktop\Beacon\Beacon-CA
docker compose --env-file .env --env-file .env.n2n up -d --build --force-recreate api
```

Kiem tra nhanh env trong container:

```powershell
docker compose exec -T api printenv | Select-String -Pattern 'Database|DevSeed|ExternalServices'
```

Ket qua mong doi:

```text
Database__Provider=InMemory
DevSeed__Enabled=true
DevSeed__ResetOnStartup=true
DevSeed__ResetToken=local-n2n-token
ExternalServices__UseNoOpStorage=true
```

Kiem tra reset endpoint:

```powershell
Invoke-WebRequest `
  -Method Post `
  -Uri 'http://localhost:5000/api/v1/dev/test-data/reset' `
  -Headers @{ 'X-Dev-Seed-Token' = 'local-n2n-token' } `
  -UseBasicParsing
```

Neu thanh cong, endpoint tra `200`.

## Cach quay lai SQL Server mode

Chay:

```powershell
cd C:\Users\Admin\Desktop\Beacon\Beacon-CA
docker compose --env-file .env --env-file .env.sqlserver up -d --build --force-recreate api
```

Sau khi quay lai SQL Server mode, endpoint reset dev se khong con hoat dong. Neu goi:

```text
POST /api/v1/dev/test-data/reset
```

backend se tra `404`, vi endpoint chi expose trong `Development + InMemory + DevSeed enabled`.

## Reset endpoint duoc goi khi nao

Endpoint:

```http
POST /api/v1/dev/test-data/reset
X-Dev-Seed-Token: local-n2n-token
```

Mobile test goi endpoint nay trong `integration_test/helpers/integration_test_app.dart`, ham `resetBackendTestData()`.

Thu tu khi test bat dau:

```text
testWidgets(...)
  -> pumpBeaconIntegrationApp(tester)
  -> BeaconIntegrationTestApp.create()
  -> load APP_ENV / BASE_URL / DEV_SEED_RESET_TOKEN
  -> POST /api/v1/dev/test-data/reset
  -> backend EnsureDeleted
  -> backend EnsureCreated
  -> backend seed users/safety/friendship/message group
  -> ProviderScope override local side effects
  -> pump MyApp
  -> user flow tren UI
```

Reset endpoint duoc goi truoc khi app duoc pump len UI. Muc dich la moi test run co DB sach va data co dinh, nen chay lai test nhieu lan khong bi trung username/email/phone.

Endpoint nay khong duoc goi trong app production. No chi nam trong integration test helper.

## Seed data backend

Seeded login account:

```text
username: beacon_n2n_seed
password: Beacon@123
email:    beacon.n2n.seed@example.com
phone:    +84987654321
```

Seeder cung tao them:

- 1 user ban be: `beacon_n2n_friend`
- safety settings mac dinh cho seeded user va friend user
- friendship giua 2 user
- direct message group giua 2 user

Phase auth N2N khong seed media/posts de tranh phu thuoc MinIO.

## Mobile dart-define env

Mobile test nhan env bang `--dart-define`. Cac bien nay khong doi env cua backend; chung chi noi mobile biet phai goi API nao va token reset nao.

### APP_ENV

```text
--dart-define=APP_ENV=dev
```

Dung de app biet dang chay che do dev/test. Gia tri nay uu tien hon `.env` mobile.

### BASE_URL

Desktop/Windows:

```text
--dart-define=BASE_URL=http://localhost:5000/api/v1
```

Android emulator:

```text
--dart-define=BASE_URL=http://10.0.2.2:5000/api/v1
```

`BASE_URL` la base path cho REST API. Auth login se goi `{BASE_URL}/auth/login`, register se goi `{BASE_URL}/auth/register`.

### SIGNALR_HUB_URL

Desktop/Windows:

```text
--dart-define=SIGNALR_HUB_URL=http://localhost:5000/hubs/beacon
```

Android emulator:

```text
--dart-define=SIGNALR_HUB_URL=http://10.0.2.2:5000/hubs/beacon
```

Bien nay la URL SignalR hub. Trong auth N2N hien tai co the bo qua neu khong can realtime, vi mobile co fallback tu `BASE_URL` sang `/hubs/beacon`.

### DEV_SEED_RESET_TOKEN

```text
--dart-define=DEV_SEED_RESET_TOKEN=local-n2n-token
```

Mobile test dung bien nay de gui header `X-Dev-Seed-Token` khi goi reset endpoint. Gia tri phai trung voi `DEV_SEED_RESET_TOKEN` trong backend `.env.n2n`.

## Cach chay mobile N2N tests

Truoc tien bat backend N2N:

```powershell
cd C:\Users\Admin\Desktop\Beacon\Beacon-CA
docker compose --env-file .env --env-file .env.n2n up -d --build --force-recreate api
```

Sau do chay test o mobile repo:

```powershell
cd C:\Users\Admin\Desktop\Beacon\beacon_app
```

Windows desktop:

```powershell
flutter test integration_test\auth\login_flow_n2n_test.dart -d windows -r expanded `
  --dart-define=APP_ENV=dev `
  --dart-define=BASE_URL=http://localhost:5000/api/v1 `
  --dart-define=SIGNALR_HUB_URL=http://localhost:5000/hubs/beacon `
  --dart-define=DEV_SEED_RESET_TOKEN=local-n2n-token

flutter test integration_test\auth\register_flow_n2n_test.dart -d windows -r expanded `
  --dart-define=APP_ENV=dev `
  --dart-define=BASE_URL=http://localhost:5000/api/v1 `
  --dart-define=SIGNALR_HUB_URL=http://localhost:5000/hubs/beacon `
  --dart-define=DEV_SEED_RESET_TOKEN=local-n2n-token


```

Android emulator:

```powershell
flutter test integration_test\auth\login_flow_n2n_test.dart -d emulator-5554 -r expanded `
  --dart-define=APP_ENV=dev `
  --dart-define=BASE_URL=http://10.0.2.2:5000/api/v1 `
  --dart-define=SIGNALR_HUB_URL=http://10.0.2.2:5000/hubs/beacon `
  --dart-define=DEV_SEED_RESET_TOKEN=local-n2n-token

flutter test integration_test\auth\register_flow_n2n_test.dart -d emulator-5554 -r expanded `
  --dart-define=APP_ENV=dev `
  --dart-define=BASE_URL=http://10.0.2.2:5000/api/v1 `
  --dart-define=SIGNALR_HUB_URL=http://10.0.2.2:5000/hubs/beacon `
  --dart-define=DEV_SEED_RESET_TOKEN=local-n2n-token
```

Test hết 
```powershell
PS C:\Users\Admin\Desktop\Beacon\beacon_app> flutter test integration_test -d emulator-5554 -r expanded `
>>   --dart-define=APP_ENV=dev `
>>   --dart-define=BASE_URL=http://10.0.2.2:5000/api/v1 `
>>   --dart-define=SIGNALR_HUB_URL=http://10.0.2.2:5000/hubs/beacon `
>>   --dart-define=DEV_SEED_RESET_TOKEN=local-n2n-token
```

Luu y voi Windows desktop: neu Flutter bao `Building with plugins requires symlink support`, hay bat Windows Developer Mode roi chay lai.

## Giai thich tung file trong integration_test

### integration_test/auth/login_flow_n2n_test.dart

Test login bang account seeded san trong backend.

Flow:

```text
pump app
-> reset backend test data
-> open login from onboarding
-> nhap beacon_n2n_seed / Beacon@123
-> POST /api/v1/auth/login
-> backend tra token
-> mobile luu token vao in-memory local datasource
-> expect HomePage
```

### integration_test/auth/register_flow_n2n_test.dart

Test dang ky user moi tren backend dev.

Flow:

```text
pump app
-> reset backend test data
-> open register from onboarding
-> nhap defaultUser
-> POST /api/v1/auth/register
-> backend tao user moi va tra token
-> mobile luu token vao in-memory local datasource
-> expect HomePage
```

### integration_test/config/register_login_test_user.dart

Chua data user dung trong auth N2N:

- `defaultUser`: user dung cho register flow.
- `seededLoginUser`: user da duoc backend seeder tao san, dung cho login flow.

Neu sua password/username seeded trong backend seeder, phai sua `seededLoginUser` o file nay cho trung.

### integration_test/helpers/integration_test_app.dart

Day la test harness chinh.

Nhiem vu:

- load env tu `--dart-define`, fallback ve `.env` mobile neu co.
- goi `resetBackendTestData()` truoc khi pump app.
- tao `SharedPreferences` mock.
- tao auth local datasource in-memory.
- override only local side-effect providers.
- pump `MyApp` that trong `ProviderScope`.

File nay khong override auth repository/backend nua. Vi vay auth flow di qua HTTP client that.

### integration_test/robots/auth_flow_robot.dart

Robot thao tac UI cho auth flow.

Nhiem vu:

- tap nut login/register tren onboarding.
- nhap email/phone/password/name/username.
- submit register form.
- submit login form.
- wait va assert `HomePage`.

Robot khong tap theo text tieng Viet de tranh loi encoding/localization. Robot tap `Button` theo vi tri cua tung man va doi dung page widget nhu `RegisterPagePhoneNumber`, `RegisterPagePassword`, `RegisterPageName`, `RegisterPageUsername` truoc khi nhap field tiep theo. Cach nay tranh loi lech step khi backend request async chua navigate xong.

### integration_test/fakes/fake_realtime_services.dart

Chua fake/no-op services cho realtime side effects.

Trong auth N2N hien tai, helper dang dung `FakePushNotificationService` de tranh viec test phu thuoc FCM/platform notification. File nay cung co fake SignalR/friends/posts/message realtime service cho cac flow tuong lai neu can, nhung auth N2N hien tai khong fake backend data.

### integration_test/fakes/fake_auth_backend.dart

Legacy fake auth backend/repository tu flow cu. Auth N2N hien tai khong dung file nay nua. File nay chi nen dung cho test fake/local neu sau nay co nhu cau test UI isolated, khong dung cho N2N.

### integration_test/fakes/fake_feature_repositories.dart

Legacy fake repositories cho checkin/posts/friends/message/safety tu flow cu. Auth N2N hien tai khong override cac repository nay nua. Neu lam N2N dung nghia, khong dung file nay; hay seed backend dev thay vi fake repository trong mobile.

## Checks nen chay

```powershell
cd C:\Users\Admin\Desktop\Beacon\beacon_app
flutter analyze integration_test lib\core\config lib\core\network
flutter test test\features\auth -r expanded
```

Backend:

```powershell
cd C:\Users\Admin\Desktop\Beacon\Beacon-CA
dotnet build src\Beacon.sln --no-restore -v:minimal /nr:false
dotnet test src\tests\Beacon.IntergrationTests\Beacon.IntergrationTests.csproj --no-build --filter FullyQualifiedName~DevTestDataControllerTests --logger "console;verbosity=minimal"
```

## Troubleshooting

### Reset endpoint tra 404

Thuong la backend chua chay dung N2N env. Kiem tra:

```powershell
docker compose exec -T api printenv | Select-String -Pattern 'Database|DevSeed|ExternalServices'
```

Can thay:

```text
Database__Provider=InMemory
DevSeed__Enabled=true
```

Neu dang la `SqlServer`, recreate API bang `.env.n2n`.

### Reset endpoint tra 401

Token mobile gui khong trung backend. Kiem tra:

- backend `.env.n2n`: `DEV_SEED_RESET_TOKEN`
- Flutter command: `--dart-define=DEV_SEED_RESET_TOKEN=...`

Hai gia tri phai giong nhau.

### Mobile khong ket noi duoc API

- Windows desktop dung `http://localhost:5000/api/v1`.
- Android emulator dung `http://10.0.2.2:5000/api/v1`.
- Device that can LAN IP cua may chay Docker, vi du `http://192.168.1.10:5000/api/v1`.

### Windows target bao thieu Visual Studio toolchain

Neu chay `-d windows` va gap loi:

```text
Unable to find suitable Visual Studio toolchain
```

Day la loi moi truong build Windows desktop, khong phai loi N2N/backend. Cai Visual Studio Build Tools hoac Visual Studio voi workload:

- Desktop development with C++
- MSVC C++ x64/x86 build tools
- C++ CMake tools for Windows
- Windows SDK

Neu chua muon cai Windows toolchain, chay N2N tren Android emulator bang `-d emulator-5554` va dung `BASE_URL=http://10.0.2.2:5000/api/v1`.

### Docker van dung env cu

Sau khi doi env file, can recreate API:

```powershell
docker compose --env-file .env --env-file .env.n2n up -d --build --force-recreate api
```

Chi restart container khong chac da ap dung lai env moi.
