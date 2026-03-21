# codex-agents

面向 Codex 的 agent 与路由工具集，提供一组可直接安装的自定义 agent、一个 `orchestrator-routing` skill，以及配套的生命周期 CLI。

当前已发布版本是 `v0.1.3`。

## 这个仓库提供什么

- 一组放在 [`agents/`](/Users/ryan/Projects/Ai/other/codex-agents/agents) 下的 Codex custom agents
- 一个默认编排入口 [`orchestrator.toml`](/Users/ryan/Projects/Ai/other/codex-agents/agents/orchestrator.toml)
- 一个可安装的 [`orchestrator-routing` skill](/Users/ryan/Projects/Ai/other/codex-agents/skills/orchestrator-routing/SKILL.md)
- 一个 CLI：[`bin/codex-agents`](/Users/ryan/Projects/Ai/other/codex-agents/bin/codex-agents)
- 一个由工具维护的 `~/.codex/AGENTS.md` 入口块，用来让 Codex 默认优先走 `orchestrator-routing`

## 当前包含的 Agents

- `orchestrator`
- `product-manager`
- `ux-architect`
- `ui-designer`
- `frontend-developer`
- `backend-architect`
- `software-architect`
- `docs-researcher`
- `code-reviewer`
- `reality-checker`
- `technical-writer`

## 安装

推荐的 Homebrew 安装方式：

```bash
brew install rzhao1116-arch/homebrew-tap/codex-agents
```

本地源码安装：

```bash
git clone https://github.com/rzhao1116-arch/codex-agents.git
cd codex-agents
bin/codex-agents install
bin/codex-agents link
codex-agents status
```

自定义 Codex Home：

```bash
codex-agents install --target /tmp/test-codex-home
```

安装后会把内容写到：

```bash
~/.codex/agents/
~/.codex/skills/
~/.codex/AGENTS.md
```

## 常用命令

```bash
codex-agents install
codex-agents update
codex-agents status
codex-agents doctor
codex-agents uninstall
codex-agents list
codex-agents version
codex-agents link
codex-agents unlink
```

## 使用方式

- 对于明显跨阶段、跨角色的任务，默认先让 `orchestrator-routing` 介入
- 让它先判断任务复杂度：`simple`、`multi-step`、`complex`
- 让它裁剪最小可用角色链，而不是默认把所有角色都串一遍
- 让它显式输出：
  - `complexity`
  - `role-chain`
  - `next-step`
  - `reason`

典型路径：

- 模糊需求 -> `orchestrator-routing -> product-manager -> ...`
- 交互或流程问题 -> `orchestrator-routing -> ux-architect -> frontend-developer -> reality-checker`
- 后端架构问题 -> `orchestrator-routing -> software-architect -> backend-architect -> code-reviewer -> reality-checker`
- 官方文档或 SDK 问题 -> `orchestrator-routing -> docs-researcher`

## 版本说明

- `v0.1.0`：首个公开版本，agent 仍然是 Markdown 形态
- `v0.1.1`：agent 迁移为 Codex 原生 `.toml`
- `v0.1.2`：清理仓库内非 release 文档，并把 Homebrew 公式切到 `v0.1.2`
- `v0.1.3`：补齐中英文说明与发布元数据，并把 GitHub Release / 仓库公式 / Homebrew tap 对齐到同一版本

## 注意事项

- `install` 或 `update` 之后，最好新开一个 Codex 会话，让最新的 skill 和 agent 列表生效
- 如果新会话里仍然看不到新内容，再尝试重启 Codex
- Homebrew 安装路径应与最新 GitHub release 保持一致；如果 tap 版本落后，优先更新 `rzhao1116-arch/homebrew-tap`
