# Git Workflow — Beacon App

## Tổng quan

Dự án dùng mô hình **GitHub Flow** mở rộng với nhánh `main` được bảo vệ. Mọi thay đổi đều đi qua Pull Request, không ai push thẳng vào `main`.

```
main (production-ready)
 ├── feature/tên-tính-năng
 ├── fix/tên-lỗi
 ├── hotfix/tên-lỗi-khẩn
 └── chore/tên-công-việc
```

---

## Nhánh

### Nhánh chính

| Nhánh | Mô tả |
|-------|-------|
| `main` | Code luôn ổn định, đã được review và test. Chỉ merge qua PR. |

### Nhánh làm việc (tạo từ `main`, xoá sau khi merge)

| Prefix | Dùng khi | Ví dụ |
|--------|----------|-------|
| `feature/` | Tính năng mới | `feature/notifications` |
| `fix/` | Sửa lỗi thông thường | `fix/auth-token-expired` |
| `hotfix/` | Lỗi nghiêm trọng trên production | `hotfix/crash-on-login` |
| `chore/` | Cấu hình, refactor, update deps | `chore/update-dio` |

**Quy tắc đặt tên nhánh:**
- Chữ thường, dùng dấu `-` thay khoảng trắng
- Ngắn gọn, mô tả đúng mục đích
- Không dùng tên cá nhân (~~`john/login`~~)

---

## Quy trình làm việc

### 1. Bắt đầu task mới

```bash
# Luôn lấy code mới nhất từ main trước
git checkout main
git pull origin main

# Tạo nhánh mới
git checkout -b feature/tên-tính-năng
```

### 2. Trong quá trình làm việc

```bash
# Commit thường xuyên, mỗi commit là một đơn vị logic nhỏ
git add .
git commit -m "feat(auth): add refresh token logic"

# Push lên remote để backup và team xem tiến độ
git push origin feature/tên-tính-năng
```

### 3. Cập nhật code từ main (tránh conflict lớn)

```bash
# Kéo thay đổi mới nhất từ main vào nhánh hiện tại
git fetch origin
git rebase origin/main

# Nếu có conflict: giải quyết từng file, rồi
git add .
git rebase --continue
```

> Dùng `rebase` thay `merge` để giữ lịch sử commit sạch.

### 4. Tạo Pull Request

1. Push nhánh lên remote: `git push origin feature/tên-tính-năng`
2. Tạo PR trên GitHub: base `main` ← compare `feature/...`
3. Điền mô tả theo template PR (xem bên dưới)
4. Chỉ định ít nhất **1 reviewer**
5. Chờ approve trước khi merge

### 5. Sau khi PR được merge

```bash
# Xoá nhánh local
git branch -d feature/tên-tính-năng

# Xoá nhánh remote
git push origin --delete feature/tên-tính-năng

# Cập nhật main local
git checkout main
git pull origin main
```

---

## Commit Message

Theo chuẩn **Conventional Commits**:

```
<type>(<scope>): <mô tả ngắn>

[body — giải thích tại sao, không phải làm gì]

[footer — breaking changes, issue references]
```

### Types

| Type | Dùng khi |
|------|----------|
| `feat` | Thêm tính năng mới |
| `fix` | Sửa lỗi |
| `refactor` | Tái cấu trúc code, không thêm tính năng hay sửa lỗi |
| `chore` | Cấu hình, deps, tooling |
| `docs` | Chỉ thay đổi tài liệu |
| `style` | Format, thiếu dấu chấm phẩy, không ảnh hưởng logic |
| `test` | Thêm hoặc sửa test |
| `perf` | Cải thiện hiệu năng |

### Scopes (theo feature/layer)

`auth` · `dashboard` · `notifications` · `network` · `storage` · `router` · `providers` · `ui`

### Ví dụ commit tốt

```
feat(auth): add logout use case with token cleanup
fix(network): map DioException connection error to NetworkFailure
refactor(auth): inject AppMessageNotifier into AuthNotifier
chore(deps): upgrade dio to 5.8.0
docs(api): update endpoint constants comment
```

### Ví dụ commit xấu ❌

```
fix bug
update code
WIP
asdfghj
```

---

## Pull Request Template

Khi tạo PR, mô tả theo cấu trúc:

```markdown
## Mô tả
<!-- Tóm tắt thay đổi và lý do -->

## Loại thay đổi
- [ ] Tính năng mới (feat)
- [ ] Sửa lỗi (fix)
- [ ] Refactor
- [ ] Khác (chore, docs, ...)

## Checklist
- [ ] Code tự review trước khi tạo PR
- [ ] Không có lỗi compile
- [ ] Đã test trên thiết bị / web
- [ ] Không để lại `print()` hay code debug
- [ ] Commit message theo convention

## Screenshots (nếu có UI thay đổi)
```

---

## Quy tắc Review

**Người tạo PR:**
- PR không nên vượt quá **400 dòng thay đổi** — nếu lớn hơn, tách nhỏ
- Tự review diff trước khi assign reviewer
- Respond mọi comment, không được resolve comment của người khác

**Reviewer:**
- Review trong vòng **1 ngày làm việc**
- Comment rõ ràng: giải thích lý do, đề xuất cách sửa
- Dùng prefix để phân biệt mức độ:
  - `[blocker]` — phải sửa trước khi merge
  - `[suggestion]` — nên sửa nhưng không bắt buộc
  - `[question]` — hỏi để hiểu, không yêu cầu thay đổi
- Approve khi không còn `[blocker]` nào

---

## Xử lý tình huống

### Commit nhầm vào main local

```bash
# Chưa push — di chuyển commit sang nhánh mới
git checkout -b fix/tên-fix
git checkout main
git reset --hard origin/main
```

### Cần lấy 1 commit từ nhánh khác

```bash
git cherry-pick <commit-hash>
```

### Hủy thay đổi chưa commit

```bash
# Hủy staged
git restore --staged .

# Hủy cả unstaged
git restore .
```

### Đổi tên commit cuối (chưa push)

```bash
git commit --amend -m "fix(auth): correct token storage key"
```

### Gộp nhiều commit nhỏ thành 1 trước khi PR

```bash
# Gộp 3 commit cuối
git rebase -i HEAD~3
# Đổi 'pick' → 'squash' cho các commit muốn gộp
```

---

## Ví dụ luồng hoàn chỉnh

```bash
# 1. Tạo nhánh
git checkout main && git pull origin main
git checkout -b feature/notifications

# 2. Làm việc
# ... code ...
git add .
git commit -m "feat(notifications): create notification model and datasource"

# ... code tiếp ...
git commit -m "feat(notifications): add notification list page"

# 3. Sync với main trước khi tạo PR
git fetch origin
git rebase origin/main

# 4. Push và tạo PR
git push origin feature/notifications
# → Tạo PR trên GitHub

# 5. Sau khi merge
git checkout main && git pull origin main
git branch -d feature/notifications
git push origin --delete feature/notifications
```
