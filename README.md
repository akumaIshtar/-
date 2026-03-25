# 浸罪之书 (Book of Soaked Sin)

一款使用 Godot Engine 开发的 2D 动作游戏。

## 项目简介
《浸罪之书》是一款侧重于战斗体验和 AI 行为树设计的 2D 动作游戏。本项目目前包含了完整的 AI 任务系统、多种攻击模式以及基础的角色控制逻辑。

## 技术栈
- **引擎**: [Godot Engine 4.x   Godot引擎4.x](https://godotengine.org/)
- **语言**: GDScript / ShaderLanguage
- **核心系统**:
  - 基于行为树 (Behavior Tree) 的 AI 逻辑（包含：追击、多种技能攻击、冷却管理等）
  - 自定义 Shader 特效（包含：灵魂球、激光、受击反馈等）
  - 完善的技能树与物品清单系统

## 目录结构
- `ai/`: 存放行为树节点和 AI 相关任务脚本。
- `Resource/   资源/`: 存放所有美术资源、字体、Shader 及自定义 Resource 文件。
- `Scene/   现场/`: 存放游戏场景（角色、地图、UI 等）。
- `Script/   脚本/`: 存放核心业务逻辑脚本。
- `SpecialEffects/`: 存放游戏特效资源。

## 如何运行
1. 下载并安装 [Godot Engine 4.x   Godot引擎4.x](https://godotengine.org/)。
2. 克隆本仓库到本地。
3. 在 Godot 项目管理器中选择 `导入`，并定位到本目录下的 `project.godot` 文件。

