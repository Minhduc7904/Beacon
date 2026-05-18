# Posts API Integration Tasks

Tai lieu nay tach prompt tich hop API posts thanh cac task nho, co thu tu phu thuoc ro rang de de review, rollback va quan ly tien do.

## Nguyen Tac Lam Viec Chung

Dung cac nguyen tac sau truoc khi bat dau tung task:

- Chi thuc hien dung task duoc yeu cau trong lan do.
- Khong tu lam sang task tiep theo, ke ca khi thay lien quan.
- Sau khi xong moi task, dung lai va bao:
  - Da sua file nao.
  - Thay doi chinh la gi.
  - Verify da chay gi.
  - Co blocker/rui ro gi khong.
- Tuan thu Clean Architecture: `data -> domain -> presentation`.
- Dung Riverpod `StateNotifier`.
- Dung `DioClient` + `ApiHandler`.
- UseCase tra `Either<Failure, T>`.
- Thong bao UI qua `appMessageProvider`.
- Endpoint di qua `ApiEndpoints`.
- Dependency moi phai wiring trong `lib/core/providers/providers.dart`.
- UI tuan thu `ui-design-skill`.
- Khong dung mock data cho production feed.
- Khong tu bia contract backend neu `backend.md` chua co.

## Quy Tac Su Dung Skills

Truoc khi thuc hien moi task, agent phai chon skill hop ly, doc `SKILL.md` cua skill do va bao ngan gon dang dung skill nao, vi sao.

Nguyen tac chon skill:

- Moi task nen co 1 skill chinh va toi da 1-2 skill ho tro.
- Neu bat dau session moi hoac chuyen ngu canh lon, dung `context-engineering-skill` truoc.
- Neu task cham API, endpoint, request/response, business code hoac repository/usecase, dung `api-integration-skill`.
- Neu task cham UI, layout, input, button, icon, text, dropdown, bottom sheet hoac grid, dung `ui-design-skill`.
- Neu task them/doi luong Flutter theo data-domain-presentation, dung `flutter-feature-skill`.
- Neu task co rui ro test, regression, pagination, async state hoac edge cases, dung `test-strategy-skill`.
- Neu task lien quan auth/token/authorization, quyen owner/friend hoac thong tin nguoi dung, can nhac `security-hardening-skill`.
- Neu task lien quan feed/grid/pagination/scroll/rebuild, can nhac `performance-skill`.
- Neu gap loi runtime/logic trong luc lam, dung `bugfix-skill` de truy root cause truoc khi sua.
- Truoc khi chot loat thay doi lon, dung `code-review-skill`.
- Khi tao branch/commit/PR, dung `git-versioning-skill`.
- Neu pham vi task thay doi hoac can tach lai ke hoach, dung `workflow-map-skill` va `planning-task-skill`.

## Skill Map Theo Task

| Task | Skill chinh | Skill ho tro hop ly | Ghi chu |
| --- | --- | --- | --- |
| Task 0 - Audit | `context-engineering-skill` | `workflow-map-skill`, `api-integration-skill` | Doc source of truth va xac nhan gap truoc khi code. |
| Task 1 - Posts API Foundation | `api-integration-skill` | `context-engineering-skill`, `test-strategy-skill` | Tao endpoint/model/datasource/repository/usecase/provider. |
| Task 2 - Dang Anh | `api-integration-skill` | `flutter-feature-skill`, `ui-design-skill` | Noi `POST /media` voi `POST /posts`, them caption input. |
| Task 3 - Feed API | `api-integration-skill` | `flutter-feature-skill`, `performance-skill` | Thay mock bang API, them pagination va state loading/error/empty. |
| Task 4 - Dropdown Filter | `ui-design-skill` | `flutter-feature-skill`, `api-integration-skill` | Dropdown thay streak chip khi xem feed, filter reload dung API. |
| Task 5 - Single/Grid View | `ui-design-skill` | `flutter-feature-skill`, `performance-skill` | Chuyen view, grid 3 cot, giu filter va pagination. |
| Task 6 - Reaction | `api-integration-skill` | `flutter-feature-skill`, `test-strategy-skill` | Upsert/delete reaction, dong bo `myReaction` va `reactionSummary`. |
| Task 7 - Owner Edit/Delete | `api-integration-skill` | `ui-design-skill`, `security-hardening-skill` | Owner-only controls, confirm delete, patch caption/visibility. |
| Task 8 - Reaction Details Gap | `spec-skill` | `api-integration-skill`, `documentation-adr-skill` | Khong bia schema; ghi ro backend contract can bo sung. |
| Task 9 - Cleanup/Verify | `test-strategy-skill` | `code-review-skill`, `git-versioning-skill` | Analyze/test/review, chuan bi commit neu duoc yeu cau. |

## Task 0 - Audit Va Xac Nhan Gap

Muc tieu: doc ky source + backend, chua sua code.

Pham vi doc:

- `backend.md`
- `lib/features/home/`
- `lib/features/feed/`
- `lib/features/post_preview/`
- `lib/features/friends/`
- `lib/core/network/api_endpoints.dart`
- `lib/core/providers/providers.dart`
- `lib/core/network/api_handler.dart`
- `lib/core/constants/api_error_codes.dart`
- `lib/core/constants/error_messages.dart`

Can bao lai:

- Feed hien mock o dau.
- Upload anh hien chi goi `POST /media` o dau.
- Backend thieu API nao so voi yeu cau.
- Reaction enum hien co lech backend ra sao.

Done khi:

- Co bao cao ngan cac diem lech truoc khi code.

## Task 1 - Posts API Foundation

Muc tieu: tao nen data/domain/provider cho posts, chua cham UI lon.

API trong task:

- `POST /posts`
- `GET /posts/feed`
- `GET /posts/friends/{friendId}`
- `GET /posts/me`

Can lam:

- Them endpoint constants trong `ApiEndpoints`.
- Them error codes/messages cho post/media/reaction lien quan.
- Tao feature `posts` hoac cau truc tuong duong theo Clean Architecture.
- Tao entities/models:
  - `Post`
  - `PostMedia`
  - `PostOwner`
  - `ReactionSummary`
  - `MyReaction`
  - `PostPage`
- Tao datasource/repository/usecase cho create + list.
- Wiring provider trong `providers.dart`.

Done khi:

- Code compile ve mat import/type.
- Chua doi behavior UI.
- `flutter analyze` khong loi do task nay gay ra.

## Task 2 - Dang Anh: POST /media + POST /posts

Muc tieu: sau khi chup anh, user nhap caption roi gui tao post that.

Pham vi:

- `lib/features/post_preview/`
- Dung lai upload `POST /media`.
- Sau upload thanh cong, goi `CreatePostUseCase(mediaId, caption, visibility)`.

Can lam:

- Them o nhap caption truoc nut gui.
- Validate caption toi da 2000 ky tu.
- Neu upload media thanh cong nhung create post fail, giu `mediaId` de retry khong upload lai neu hop ly.
- Chi `pop(true)` khi `POST /posts` thanh cong.
- Message qua `appMessageProvider`.

Done khi:

- Chup anh -> preview -> nhap caption -> gui goi dung 2 API theo thu tu.
- Loi upload/create deu hien thi dung.
- Khong hardcode endpoint trong UI.

## Task 3 - Feed API Thay Mock

Muc tieu: home feed dung `GET /posts/feed`, chua can filter nang cao.

Pham vi:

- `lib/features/feed/`
- `HomeBody` cho dang dung `feedProvider`

Can lam:

- Bo `FeedMockData` khoi flow production.
- `FeedNotifier.load()` goi `GetFeedPostsUseCase`.
- Map backend post sang entity UI hoac chuyen UI sang dung entity posts.
- Render loading/error/empty.
- Them cursor pagination co ban khi luot gan cuoi.

Done khi:

- Home keo xuong thay bai tu API.
- Thu tu theo API/latest.
- Khong con delay/mock trong feed production.

## Task 4 - Dropdown Filter O Vi Tri Streak Chip

Muc tieu: home dau van co streak chip, khi xem feed thi vi tri do thanh dropdown.

Filter can co:

- Tat ca
- Toi
- Mot nguoi ban cu the

API tuong ung:

- Tat ca: `GET /posts/feed`
- Toi: `GET /posts/me`
- Friend: `GET /posts/friends/{friendId}`

Can lam:

- Load danh sach ban be bang `GetFriendsUseCase`.
- Tao feed filter state.
- Khi doi filter, reset feed + reload tu trang dau.
- Home page dau van hien thi streak chip.
- Feed page hien thi dropdown thay streak chip.

Diem can bao:

- Backend `GET /posts/feed` la "ban than + ban be", khong phai "chi tat ca ban be".
- Neu label gay hieu nham thi dung "Tat ca" thay vi "Tat ca ban be".

Done khi:

- Doi filter reload dung API.
- Khong mat trang thai UI bat thuong khi luot home/feed.

## Task 5 - Chuyen Xem Tung Anh Va Dang Luoi

Muc tieu: feed ho tro single vertical view va grid 3 anh/hang.

Can lam:

- Them `FeedViewMode.single/grid`.
- Single view giu `PageView` tung anh.
- Grid view dung 3 cot.
- Nut chuyen view nam duoi cung khi xem tung anh.
- Tap anh trong grid chuyen ve single tai dung anh.
- Filter hien tai ap dung cho ca single/grid.
- Pagination dung chung cho ca hai mode.

Done khi:

- Chuyen qua lai khong reload sai hoac mat filter.
- Grid moi hang 3 anh.
- Load more van hoat dong.

## Task 6 - Reaction Cho Bai Cua Ban

Muc tieu: react/huy react bai cua ban cu the, dung API that.

API:

- `PUT /posts/{postId}/reaction`
- `DELETE /posts/{postId}/reaction`

Can lam:

- Doi reaction enum theo backend: `heart`, `haha`, `like`, `sad`, `wow`.
- Neu tap cung reaction hien tai: goi `DELETE`.
- Neu tap reaction khac: goi `PUT`.
- Update `myReaction` va `reactionSummary` tu response.
- Chi cho react khi dang xem bai cua friend, khong phai bai cua minh.
- Khong con mock `FeedReaction(userName: 'Toi')`.

Done khi:

- React/upsert/huy goi dung API.
- Count va selected reaction cap nhat dung.
- API error rollback hoac reload lai post hop ly.

## Task 7 - Owner Edit/Delete

Muc tieu: user quan ly bai cua chinh minh.

API:

- `PATCH /posts/{postId}`
- `DELETE /posts/{postId}`

Can lam:

- Neu `ownerUserId == currentUser.id`, hien thi menu sua/xoa.
- Sua caption/visibility bang bottom sheet hoac dialog don gian.
- Xoa co confirm.
- Delete thanh cong remove khoi state.
- Patch thanh cong update item trong state.
- Khong hien thi reaction action cho chu bai.

Can bao ro:

- Backend chi cho sua `caption/visibility`, chua co API thay anh/media.

Done khi:

- Chu bai sua/xoa duoc.
- Friend khong thay owner controls.

## Task 8 - Reaction Details Cho Chu Bai

Muc tieu: xu ly yeu cau "hien thi nhung nguoi da react".

Hien trang backend:

- `backend.md` chi co `reactionSummary`.
- Khong co danh sach user da react.

Cach lam:

- Neu backend chua bo sung API/field, khong tu bia model.
- Chi hien thi summary/counts theo icon.
- Bao blocker ro: can backend them `reactions: [{ userId, displayName, avatarUrl, icon }]` hoac endpoint rieng.

Done khi:

- UI khong crash.
- Co note ro phan chua the lam vi thieu backend contract.

## Task 9 - Cleanup, Analyze, Test

Muc tieu: chot chat luong.

Can lam:

- Xoa mock import khong con dung.
- Kiem tra naming, state, provider.
- Chay `flutter analyze`.
- Chay `flutter test` neu co test lien quan.
- Test thu cong cac flow chinh.

Done khi:

- Analyze pass hoac bao loi khong lien quan.
- Co checklist ket qua tung flow.

## Thu Tu Khuyen Nghi

Nen lam tuan tu:

1. Task 0
2. Task 1
3. Task 2
4. Task 3
5. Task 4
6. Task 5
7. Task 6
8. Task 7
9. Task 8
10. Task 9

Khuyen nghi review rieng Task 1-3 truoc, vi day la phan API/core flow. Task 4-8 cham nhieu UI/state hon nen nen tach thanh cac dot review nho.
