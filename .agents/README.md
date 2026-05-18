# Beacon Copilot Agent Pack

Thư mục này là bộ hướng dẫn vận hành GitHub Copilot Agent theo chuẩn nội bộ của Beacon.

## Mục tiêu

1. Giữ mọi thay đổi đúng kiến trúc dự án Flutter hiện tại.
2. Chuẩn hóa cách AI Agent lập kế hoạch, code, verify và review.
3. Giảm lỗi do hardcode, sửa lan phạm vi, hoặc bỏ qua kiểm chứng.

## Cấu trúc

```
.agents/
├── README.md
├── instructions/
│   ├── project-context.md
│   ├── architecture-rules.md
│   └── ui-design.instructions.md
├── agents/
│   ├── code-reviewer.md
│   ├── test-engineer.md
│   └── security-auditor.md
└── skills/
	├── api-integration-skill/
	│   └── SKILL.md
	├── bugfix-skill/
	│   └── SKILL.md
	├── ci-cd-skill/
	│   └── SKILL.md
	├── code-review-skill/
	│   └── SKILL.md
	├── context-engineering-skill/
	│   └── SKILL.md
	├── documentation-adr-skill/
	│   └── SKILL.md
	├── flutter-feature-skill/
	│   └── SKILL.md
	├── ui-design-skill/
	│   └── SKILL.md
	├── git-versioning-skill/
	│   └── SKILL.md
	├── performance-skill/
	│   └── SKILL.md
	├── planning-task-skill/
	│   └── SKILL.md
	├── release-launch-skill/
	│   └── SKILL.md
	├── security-hardening-skill/
	│   └── SKILL.md
	├── spec-skill/
	│   └── SKILL.md
	├── test-strategy-skill/
	│   └── SKILL.md
	└── workflow-map-skill/
	    └── SKILL.md
```

## Trình tự dùng chuẩn cho mỗi task

1. Đọc `instructions/project-context.md` để nạp ngữ cảnh dự án.
2. Đọc `instructions/architecture-rules.md` để nắm rule bắt buộc.
3. Chọn 1-3 skill phù hợp trong `skills/` theo loại công việc.
4. Nếu cần review chuyên sâu, kích hoạt agent trong `agents/` tương ứng.

## Mapping nhanh theo vòng đời

- Define: `spec-skill`, `planning-task-skill`
- Build: `flutter-feature-skill`, `ui-design-skill`, `api-integration-skill`, `context-engineering-skill`
- Verify: `test-strategy-skill`, `bugfix-skill`, `performance-skill`
- Review: `code-review-skill`, `security-hardening-skill`
- Ship: `git-versioning-skill`, `ci-cd-skill`, `release-launch-skill`, `documentation-adr-skill`
- Mặc định chọn skill nhanh theo giai đoạn: `workflow-map-skill`

## Nguyên tắc bảo trì

1. Ưu tiên cập nhật `instructions/*` khi kiến trúc đổi.
2. Khi team có quy trình lặp mới, bổ sung skill mới trong `skills/*`.
3. Nội dung luôn bám code thực tế trong repo, không sao chép máy móc từ nguồn bên ngoài.

