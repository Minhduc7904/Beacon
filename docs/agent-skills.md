# Hướng dẫn Agent Skills cho Beacon

Tài liệu này mô tả toàn bộ hệ thống agent persona và skills nội bộ dùng với GitHub Copilot Agent trong dự án Beacon.

## 1) Vị trí thư mục

- Bộ rules tổng: `.agents/copilot-instructions.md`
- Bộ agent/skills cục bộ: `.agents/`

## 2) Danh sách Agents

### 1. `code-reviewer`
- File: `.agents/agents/code-reviewer.md`
- Công dụng: review code trước merge theo các trục correctness, kiến trúc, maintainability, security, verification.
- Dùng khi: trước khi merge PR hoặc khi cần đánh giá chất lượng tổng thể thay đổi.

### 2. `test-engineer`
- File: `.agents/agents/test-engineer.md`
- Công dụng: đề xuất chiến lược test, coverage và kịch bản verify theo mức rủi ro.
- Dùng khi: thêm logic mới, sửa bug quan trọng, chạm auth/routing/network.

### 3. `security-auditor`
- File: `.agents/agents/security-auditor.md`
- Công dụng: audit bảo mật tập trung auth/token/storage/network.
- Dùng khi: thay đổi liên quan đăng nhập, token, interceptor, lưu dữ liệu cục bộ.

## 3) Danh sách Skills

### Nhóm Define / Plan

1. `spec-skill`
- File: `.agents/skills/spec-skill/SKILL.md`
- Dùng để chốt phạm vi, acceptance criteria, ràng buộc kỹ thuật trước khi code.

2. `planning-task-skill`
- File: `.agents/skills/planning-task-skill/SKILL.md`
- Dùng để tách task lớn thành lát cắt nhỏ, dễ verify, dễ review.

### Nhóm Build

3. `context-engineering-skill`
- File: `.agents/skills/context-engineering-skill/SKILL.md`
- Dùng để nạp đúng context và source-of-truth trước khi agent sửa code.

4. `flutter-feature-skill`
- File: `.agents/skills/flutter-feature-skill/SKILL.md`
- Dùng khi thêm/mở rộng feature Flutter theo clean architecture.

5. `ui-design-skill`
- File: `.agents/skills/ui-design-skill/SKILL.md`
- Dùng khi tạo/chỉnh UI và cần bám chặt typography, color theme, shared widgets.
- Checklist verify trước merge: `docs/ui_design_checklist.md`

6. `api-integration-skill`
- File: `.agents/skills/api-integration-skill/SKILL.md`
- Dùng khi thêm/chỉnh endpoint, model mapping, failure handling.

### Nhóm Verify

7. `test-strategy-skill`
- File: `.agents/skills/test-strategy-skill/SKILL.md`
- Dùng để xác định test level và checklist verify cho từng thay đổi.

8. `integration-test-skill`
- File: `.agents/skills/integration-test-skill/SKILL.md`
- Dùng khi thêm hoặc mở rộng Flutter integration/E2E test với fake backend, ProviderScope overrides và test robot.

9. `bugfix-skill`
- File: `.agents/skills/bugfix-skill/SKILL.md`
- Dùng để sửa bug theo 5 bước reproduce -> localize -> reduce -> fix -> guard.

10. `performance-skill`
- File: `.agents/skills/performance-skill/SKILL.md`
- Dùng khi có dấu hiệu chậm, rebuild dư thừa, network inefficiency.

### Nhóm Review

11. `code-review-skill`
- File: `.agents/skills/code-review-skill/SKILL.md`
- Dùng như quality gate trước merge.

12. `security-hardening-skill`
- File: `.agents/skills/security-hardening-skill/SKILL.md`
- Dùng để rà soát bảo mật cho thay đổi nhạy cảm.

### Nhóm Ship

13. `git-versioning-skill`
- File: `.agents/skills/git-versioning-skill/SKILL.md`
- Dùng để chuẩn hóa branch, commit, PR theo `docs/git_workflow.md`.

14. `ci-cd-skill`
- File: `.agents/skills/ci-cd-skill/SKILL.md`
- Dùng để thiết lập quality gates và tự động hóa pipeline.

15. `release-launch-skill`
- File: `.agents/skills/release-launch-skill/SKILL.md`
- Dùng cho checklist trước/sau release và phương án rollback.

16. `documentation-adr-skill`
- File: `.agents/skills/documentation-adr-skill/SKILL.md`
- Dùng để ghi nhận quyết định kỹ thuật và cập nhật tài liệu vận hành.

17. `workflow-map-skill`
- File: `.agents/skills/workflow-map-skill/SKILL.md`
- Dùng như bản đồ chọn skill nhanh theo vòng đời task.

## 4) Cách sử dụng đề xuất

## Luồng chuẩn cho một task

1. Đọc `.agents/copilot-instructions.md`
2. Đọc `.agents/instructions/project-context.md`
3. Đọc `.agents/instructions/architecture-rules.md`
4. Nếu task liên quan UI, đọc `.agents/instructions/ui-design.instructions.md`
5. Chọn skill theo vòng đời:
   - Define/Plan: `spec-skill`, `planning-task-skill`
   - Build: `context-engineering-skill`, `flutter-feature-skill`, `ui-design-skill` hoặc `api-integration-skill`
   - Verify: `test-strategy-skill`, `integration-test-skill`, `bugfix-skill`
   - Review: `code-review-skill`, `security-hardening-skill`
   - Ship: `git-versioning-skill`, `ci-cd-skill`, `release-launch-skill`, `documentation-adr-skill`
6. Khi cần review chuyên sâu, gọi agent persona tương ứng:
   - Chất lượng tổng thể: `code-reviewer`
   - Kiểm thử/cov: `test-engineer`
   - Bảo mật: `security-auditor`

## 5) Nguyên tắc vận hành

1. Không áp dụng máy móc: chọn skill theo đúng loại task.
2. Task nhỏ chỉ cần 1 skill chính + 1 skill verify.
3. Luôn ưu tiên code thực tế hơn tài liệu cũ nếu có lệch.
4. Sau thay đổi quan trọng, cập nhật lại tài liệu trong `docs/` và `.agents/` để giữ đồng bộ.
