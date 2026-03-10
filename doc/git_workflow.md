# Git Workflow — Beacon App

## Mô hình nhánh

```
main          ← production, luôn stable, chỉ merge từ develop
develop       ← nhánh tích hợp, base cho mọi feature
feature/*     ← tính năng mới
fix/*         ← bug fix
hotfix/*      ← fix khẩn cấp trực tiếp từ main
```

---

## Luồng làm việc

### 1. Bắt đầu tính năng mới

```bash
# Luôn bắt đầu từ develop mới nhất
git checkout develop
git pull origin develop

# Tạo nhánh feature
git checkout -b feature/ten-tinh-nang
# Ví dụ: feature/notification-list, feature/student-profile
```

### 2. Làm việc & commit

```bash
# Sau mỗi đơn vị công việc nhỏ, commit ngay
git add .
git commit -m "type(scope): mô tả ngắn gọn"
```

**Quy tắc commit message:**

| Type | Dùng khi |
|------|----------|
| `feat` | Thêm tính năng mới |
| `fix` | Sửa bug |
| `refactor` | Cấu trúc lại code, không thêm feature/fix |
| `style` | Sửa UI, format, không ảnh hưởng logic |
| `docs` | Cập nhật tài liệu |
| `chore` | Cập nhật dependency, config |
| `test` | Thêm/sửa test |

**Ví dụ:**
```
feat(auth): add refresh token logic
fix(dashboard): correct stats card alignment
refactor(network): extract error mapping to failures.dart
docs(readme): update setup instructions
chore(deps): upgrade go_router to 14.6.3
```

### 3. Push và tạo Pull Request

```bash
# Push nhánh lên remote
git push origin feature/ten-tinh-nang

# Tạo PR trên GitHub: feature/ten-tinh-nang → develop
```

**Checklist trước khi tạo PR:**
- [ ] Code không có lỗi compile (`flutter analyze`)
- [ ] Đã test trên thiết bị/emulator
- [ ] Không commit file thừa (`.env`, build output, ...)
- [ ] Commit message rõ ràng, đúng format

### 4. Code Review

- Mỗi PR cần ít nhất **1 người review** trước khi merge
- Reviewer dùng **Comment** để hỏi, **Request changes** nếu cần sửa, **Approve** khi OK
- Author tự merge sau khi được approve (dùng **Squash and merge**)

### 5. Merge vào develop

```bash
# Trên GitHub: Squash and merge → develop
# Sau khi merge, xoá nhánh feature trên remote (GitHub tự hỏi)
```

### 6. Release lên main

```bash
# Khi develop ổn định, ready để release
git checkout main
git pull origin main
git merge develop --no-ff -m "release: v1.x.x"
git tag v1.x.x
git push origin main --tags
```

---

## Fix Bug

### Bug thường (không khẩn cấp)

```bash
# Tạo từ develop
git checkout develop
git pull origin develop
git checkout -b fix/mo-ta-bug

# Sau khi fix → PR vào develop như bình thường
```

### Hotfix (khẩn cấp, production bị lỗi)

```bash
# Tạo từ main
git checkout main
git pull origin main
git checkout -b hotfix/mo-ta-loi

# Fix xong → merge vào CẢ HAI main và develop
git checkout main
git merge hotfix/mo-ta-loi --no-ff
git tag v1.x.x-hotfix

git checkout develop
git merge hotfix/mo-ta-loi --no-ff

git push origin main develop --tags
git branch -d hotfix/mo-ta-loi
```

---

## Xử lý conflict

```bash
# Khi develop đã có commit mới mà nhánh của mình chưa có
git checkout feature/ten-tinh-nang
git fetch origin
git rebase origin/develop

# Nếu có conflict:
# 1. Mở file conflict, sửa tay
# 2. git add <file>
# 3. git rebase --continue

# Sau rebase, force push (chỉ dùng cho nhánh cá nhân)
git push origin feature/ten-tinh-nang --force-with-lease
```

---

## Quy tắc chung

| Quy tắc | Chi tiết |
|---------|----------|
| **Không push thẳng vào `main` hoặc `develop`** | Luôn qua PR |
| **Không force push lên `main`/`develop`** | Chỉ force push nhánh cá nhân |
| **Commit nhỏ, thường xuyên** | 1 commit = 1 việc cụ thể |
| **Tên nhánh tiếng Anh, kebab-case** | `feature/student-list`, không phải `feature/danh_sach` |
| **Xoá nhánh sau khi merge** | Tránh rác nhánh cũ |
| **Không commit secret/token** | Dùng `.env` và thêm vào `.gitignore` |

---

## Sơ đồ luồng

```
main ────────────────────────────────────────── release tag
  └── develop ──────────────────────────────── tích hợp liên tục
        ├── feature/auth ──────── PR ──► develop
        ├── feature/dashboard ─── PR ──► develop
        └── fix/login-crash ───── PR ──► develop
```

```
Hotfix:
main ──── hotfix/xxx ──┬──► main (tag)
                       └──► develop
```

---

## Lệnh hữu ích

```bash
# Xem trạng thái nhánh
git log --oneline --graph --all

# Huỷ thay đổi chưa commit
git restore .

# Stash tạm thời để chuyển nhánh
git stash
git stash pop

# Xem ai sửa dòng nào trong file
git blame lib/core/network/dio_client.dart

# Undo commit cuối (giữ lại code)
git reset --soft HEAD~1
```
