---
description: "Use when: designing or updating Flutter UI, UX, animation, motion, redesigns, image-to-code, or mobile visual quality."
applyTo: "lib/**/presentation/**/*.dart"
---

# Local Taste Skill Loading

This project vendors Taste Skill files at the repository root under `skills/`.

Before every UI, UX, visual design, redesign, animation, motion, image-to-code, or mobile screen implementation task:

1. Read `skills/llms.txt`.
2. Choose the relevant Taste Skill.
3. Open the matching `skills/<skill-folder>/SKILL.md`.
4. Combine the Taste Skill guidance with Beacon Flutter UI rules in `.agents/instructions/ui-design.instructions.md`.

Default routing for Beacon App:

- Mobile UI concepts and visual direction: `skills/imagegen-frontend-mobile/SKILL.md`
- Existing screen redesign or polish: `skills/redesign-skill/SKILL.md`
- UI/UX animation, motion timing, and premium interaction quality: `skills/gpt-tasteskill/SKILL.md`
- Clean, dense product UI: `skills/minimalist-skill/SKILL.md`
- Soft premium visual polish: `skills/soft-skill/SKILL.md`
- Image-to-code implementation: `skills/image-to-code-skill/SKILL.md`
- Complete, unabridged implementation output: `skills/output-skill/SKILL.md`
- Broad full-redesign taste guidance: `skills/taste-skill/SKILL.md`

Do not skip this instruction when the task touches UI/UX/animation, even if the change is small.
