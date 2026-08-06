# zyx-qx-rules

zyx 的 QuantumultX 自主规则仓库。所有资源镜像自上游(防删库跑路),GitHub Actions 每周自动同步活上游。

- `config/quantumult.conf` — 成品配置,导入 QX 用这个
- `scripts/` — resource-parser.js / IP_bili_cn.js
- `filters/` — 分流规则(按来源分子目录)
- `rewrites/` — 重写
- `icons/` — 策略组图标
- `docs/小白说明书.md` — 小白说明书
- `tools/` — 同步与改造脚本
- `.github/workflows/sync.yml` — 每周自动同步

详见 `zyx-handoff` 仓库 `docs/qx-migration-design.md`。
