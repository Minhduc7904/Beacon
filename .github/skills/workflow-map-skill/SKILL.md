---
name: workflow-map-skill
description: "Use when: choosing the right combination of Beacon skills by lifecycle stage from define to ship."
---

# Skill: Workflow Map cho AI Agent

## Mục tiêu

Chọn đúng bộ skill theo từng giai đoạn để giảm sai sót trong vòng đời phát triển.

## Bản đồ dùng nhanh

1. Define: `spec-skill`, `planning-task-skill`
2. Build: `context-engineering-skill`, `flutter-feature-skill`, `ui-design-skill`, `api-integration-skill`
3. Verify: `test-strategy-skill`, `bugfix-skill`, `performance-skill`
4. Review: `code-review-skill`, `security-hardening-skill`
5. Ship: `git-versioning-skill`, `ci-cd-skill`, `release-launch-skill`, `documentation-adr-skill`

## Cách dùng

- Chọn 1 skill chính + 1-2 skill hỗ trợ cho mỗi task.
- Không bật quá nhiều skill cùng lúc nếu task nhỏ.

## Done khi

- Mỗi task có quy trình rõ từ lúc nhận yêu cầu đến lúc verify và bàn giao.
