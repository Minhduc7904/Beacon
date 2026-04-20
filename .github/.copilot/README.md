# Beacon Copilot Agent Pack

Thư mục này là bộ hướng dẫn vận hành GitHub Copilot Agent theo chuẩn nội bộ của Beacon.

## Mục tiêu

1. Giữ mọi thay đổi đúng kiến trúc dự án Flutter hiện tại.
2. Chuẩn hóa cách AI Agent lập kế hoạch, code, verify và review.
3. Giảm lỗi do hardcode, sửa lan phạm vi, hoặc bỏ qua kiểm chứng.

## Cấu trúc

```
.github/.copilot/
├── README.md
├── instructions/
│   ├── project-context.md
│   └── architecture-rules.md
├── agents/
│   ├── code-reviewer.md
│   ├── test-engineer.md
│   └── security-auditor.md
└── skills/
	├── api-integration-skill.md
	├── bugfix-skill.md
	├── ci-cd-skill.md
	├── code-review-skill.md
	├── context-engineering-skill.md
	├── documentation-adr-skill.md
	├── flutter-feature-skill.md
	├── git-versioning-skill.md
	├── performance-skill.md
	├── planning-task-skill.md
	├── release-launch-skill.md
	├── security-hardening-skill.md
	├── spec-skill.md
	├── test-strategy-skill.md
	└── workflow-map-skill.md
```

## Trình tự dùng chuẩn cho mỗi task

1. Đọc `instructions/project-context.md` để nạp ngữ cảnh dự án.
2. Đọc `instructions/architecture-rules.md` để nắm rule bắt buộc.
3. Chọn 1-3 skill phù hợp trong `skills/` theo loại công việc.
4. Nếu cần review chuyên sâu, kích hoạt agent trong `agents/` tương ứng.

## Mapping nhanh theo vòng đời

- Define: `spec-skill.md`, `planning-task-skill.md`
- Build: `flutter-feature-skill.md`, `api-integration-skill.md`, `context-engineering-skill.md`
- Verify: `test-strategy-skill.md`, `bugfix-skill.md`, `performance-skill.md`
- Review: `code-review-skill.md`, `security-hardening-skill.md`
- Ship: `git-versioning-skill.md`, `ci-cd-skill.md`, `release-launch-skill.md`, `documentation-adr-skill.md`
- Mặc định chọn skill nhanh theo giai đoạn: `workflow-map-skill.md`

## Nguyên tắc bảo trì

1. Ưu tiên cập nhật `instructions/*` khi kiến trúc đổi.
2. Khi team có quy trình lặp mới, bổ sung skill mới trong `skills/*`.
3. Nội dung luôn bám code thực tế trong repo, không sao chép máy móc từ nguồn bên ngoài.

