# Brand Identity Skill — Setup

No dependencies, no API keys. This is a documentation-and-templates skill: it teaches an
agent a method and gives it starter files. Make the skill discoverable in the projects
where you want it.

## Option A — per project (recommended)

Symlink this skill directory into a project's `.claude/skills/` so `/brand-identity` is
available there:

```bash
mkdir -p /path/to/project/.claude/skills
ln -s "$(pwd)/skills/brand-identity" /path/to/project/.claude/skills/brand-identity
```

(Use a copy instead of a symlink if the project is shared with people who won't have
this repo: `cp -r skills/brand-identity /path/to/project/.claude/skills/brand-identity`.)

## Option B — globally for your machine

Make it available in every project by linking into your user skills directory:

```bash
mkdir -p ~/.claude/skills
ln -s "$(pwd)/skills/brand-identity" ~/.claude/skills/brand-identity
```

## Verify

Restart Claude Code (or reload skills) in the target project and run:

```
/brand-identity
```

This skill directory is self-contained — `SKILL.md`, `GUIDE.md`, and `templates/` all
live together and reference each other with `./` paths. Link or copy the whole
directory; don't copy `SKILL.md` on its own.

## No-install path

You don't need the skill machinery at all. Read `GUIDE.md`, copy
`templates/mark.template.svg` and `templates/theme.template.css` into a project, and
edit from there.
