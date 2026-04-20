# Hướng dẫn Agent Skills cho Beacon

Tài liệu này mô tả toàn bộ hệ thống agent persona và skills nội bộ dùng với GitHub Copilot Agent trong dự án Beacon.

## 1) Vị trí thư mục

- Bộ rules tổng: `.github/copilot-instructions.md`
- Bộ agent/skills cục bộ: `.github/.copilot/`

## 2) Danh sách Agents

### 1. `code-reviewer`
- File: `.github/.copilot/agents/code-reviewer.md`
- Công dụng: review code trước merge theo các trục correctness, kiến trúc, maintainability, security, verification.
- Dùng khi: trước khi merge PR hoặc khi cần đánh giá chất lượng tổng thể thay đổi.

### 2. `test-engineer`
- File: `.github/.copilot/agents/test-engineer.md`
- Công dụng: đề xuất chiến lược test, coverage và kịch bản verify theo mức rủi ro.
- Dùng khi: thêm logic mới, sửa bug quan trọng, chạm auth/routing/network.

### 3. `security-auditor`
- File: `.github/.copilot/agents/security-auditor.md`
- Công dụng: audit bảo mật tập trung auth/token/storage/network.
- Dùng khi: thay đổi liên quan đăng nhập, token, interceptor, lưu dữ liệu cục bộ.

## 3) Danh sách Skills

### Nhóm Define / Plan

1. `spec-skill`
- File: `.github/.copilot/skills/spec-skill.md`
- Dùng để chốt phạm vi, acceptance criteria, ràng buộc kỹ thuật trước khi code.

2. `planning-task-skill`
- File: `.github/.copilot/skills/planning-task-skill.md`
- Dùng để tách task lớn thành lát cắt nhỏ, dễ verify, dễ review.

### Nhóm Build

3. `context-engineering-skill`
- File: `.github/.copilot/skills/context-engineering-skill.md`
- Dùng để nạp đúng context và source-of-truth trước khi agent sửa code.

4. `flutter-feature-skill`
- File: `.github/.copilot/skills/flutter-feature-skill.md`
- Dùng khi thêm/mở rộng feature Flutter theo clean architecture.

5. `api-integration-skill`
- File: `.github/.copilot/skills/api-integration-skill.md`
- Dùng khi thêm/chỉnh endpoint, model mapping, failure handling.

### Nhóm Verify

6. `test-strategy-skill`
- File: `.github/.copilot/skills/test-strategy-skill.md`
- Dùng để xác định test level và checklist verify cho từng thay đổi.

7. `bugfix-skill`
- File: `.github/.copilot/skills/bugfix-skill.md`
- Dùng để sửa bug theo 5 bước reproduce -> localize -> reduce -> fix -> guard.

8. `performance-skill`
- File: `.github/.copilot/skills/performance-skill.md`
- Dùng khi có dấu hiệu chậm, rebuild dư thừa, network inefficiency.

### Nhóm Review

9. `code-review-skill`
- File: `.github/.copilot/skills/code-review-skill.md`
- Dùng như quality gate trước merge.

10. `security-hardening-skill`
- File: `.github/.copilot/skills/security-hardening-skill.md`
- Dùng để rà soát bảo mật cho thay đổi nhạy cảm.

### Nhóm Ship

11. `git-versioning-skill`
- File: `.github/.copilot/skills/git-versioning-skill.md`
- Dùng để chuẩn hóa branch, commit, PR theo `doc/git_workflow.md`.

12. `ci-cd-skill`
- File: `.github/.copilot/skills/ci-cd-skill.md`
- Dùng để thiết lập quality gates và tự động hóa pipeline.

13. `release-launch-skill`
- File: `.github/.copilot/skills/release-launch-skill.md`
- Dùng cho checklist trước/sau release và phương án rollback.

14. `documentation-adr-skill`
- File: `.github/.copilot/skills/documentation-adr-skill.md`
- Dùng để ghi nhận quyết định kỹ thuật và cập nhật tài liệu vận hành.

15. `workflow-map-skill`
- File: `.github/.copilot/skills/workflow-map-skill.md`
- Dùng như bản đồ chọn skill nhanh theo vòng đời task.

## 4) Cách sử dụng đề xuất

## Luồng chuẩn cho một task

1. Đọc `.github/copilot-instructions.md`
2. Đọc `.github/.copilot/instructions/project-context.md`
3. Đọc `.github/.copilot/instructions/architecture-rules.md`
4. Chọn skill theo vòng đời:
   - Define/Plan: `spec-skill`, `planning-task-skill`
   - Build: `context-engineering-skill`, `flutter-feature-skill` hoặc `api-integration-skill`
   - Verify: `test-strategy-skill`, `bugfix-skill`
   - Review: `code-review-skill`, `security-hardening-skill`
   - Ship: `git-versioning-skill`, `ci-cd-skill`, `release-launch-skill`, `documentation-adr-skill`
5. Khi cần review chuyên sâu, gọi agent persona tương ứng:
   - Chất lượng tổng thể: `code-reviewer`
   - Kiểm thử/cov: `test-engineer`
   - Bảo mật: `security-auditor`

## 5) Nguyên tắc vận hành

1. Không áp dụng máy móc: chọn skill theo đúng loại task.
2. Task nhỏ chỉ cần 1 skill chính + 1 skill verify.
3. Luôn ưu tiên code thực tế hơn tài liệu cũ nếu có lệch.
4. Sau thay đổi quan trọng, cập nhật lại tài liệu trong `doc/` và `.github/.copilot/` để giữ đồng bộ.
