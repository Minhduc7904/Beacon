# Skill: Git Workflow và Versioning

## Mục tiêu

Giữ lịch sử commit rõ ràng, dễ review, dễ truy vết và phù hợp `docs/git_workflow.md`.

## Khi dùng

- Mọi thay đổi code.

## Quy tắc bắt buộc

1. Làm việc trên branch từ `main` theo prefix: `feature/`, `fix/`, `hotfix/`, `chore/`.
2. Commit theo Conventional Commits: `feat|fix|refactor|docs|chore|test|perf`.
3. Một commit nên là một thay đổi logic rõ ràng.
4. Trước PR, rebase hoặc sync từ `main` để giảm conflict.

## Checklist trước PR

- [ ] Tự review diff
- [ ] Không để code debug dư thừa
- [ ] Đã verify flow thay đổi
- [ ] Mô tả PR rõ phạm vi và rủi ro

## Done khi

- PR dễ review, commit message rõ nghĩa, không trộn nhiều mục tiêu.
