# Инструкция по установке — Цифровые Отморозки

## Что нужно

- VPS или сервер (Ubuntu 20.04+, минимум 2GB RAM) — рекомендуем Hetzner CX22 (~€4/мес)
- Node.js 18+
- 7 Telegram-ботов (создать в @BotFather)
- API-ключ Anthropic (claude.ai/api)

---

## Шаг 1 — Установи OpenClaw

```bash
npm install -g openclaw
```

Проверь установку:
```bash
openclaw --version
```

---

## Шаг 2 — Создай 7 Telegram-ботов

Открой [@BotFather](https://t.me/BotFather) и создай по одному:

| Бот | Назначение |
|-----|-----------|
| `@твой_sinsei_bot` | Стратег / Синсей |
| `@твой_alena_bot` | Алёна / Копирайтер |
| `@твой_critic_bot` | Критик |
| `@твой_masha_bot` | Маша / Дизайнер |
| `@твой_maxim_bot` | Максим / Аналитик |
| `@твой_alex_bot` | Алекс / Видео продюсер |
| `@твой_reshala_bot` | Решала (публичный CRM-бот) |

Для каждого бота: `/newbot` → назови → сохрани токен.

---

## Шаг 3 — Клонируй репозиторий

```bash
git clone https://github.com/YOUR/otmorozki.git ~/otmorozki
cd ~/otmorozki
```

---

## Шаг 4 — Создай workspace для каждого агента

```bash
# Создай папки
mkdir -p ~/.openclaw/workspace-strategist
mkdir -p ~/.openclaw/workspace-copywriter
mkdir -p ~/.openclaw/workspace-critic
mkdir -p ~/.openclaw/workspace-designer
mkdir -p ~/.openclaw/workspace-analyst
mkdir -p ~/.openclaw/workspace-videoproducer
mkdir -p ~/.openclaw/workspace-shtab

# Скопируй файлы агентов
cp -r agents/sinsei/* ~/.openclaw/workspace-strategist/
cp -r agents/alena/* ~/.openclaw/workspace-copywriter/
cp -r agents/critic/* ~/.openclaw/workspace-critic/
cp -r agents/masha/* ~/.openclaw/workspace-designer/
cp -r agents/maxim/* ~/.openclaw/workspace-analyst/
cp -r agents/alex/* ~/.openclaw/workspace-videoproducer/
cp -r agents/reshala/* ~/.openclaw/workspace-shtab/

# Создай общую папку brand/ для каждого агента
for agent in strategist copywriter critic designer analyst videoproducer shtab; do
  mkdir -p ~/.openclaw/workspace-$agent/brand
  mkdir -p ~/.openclaw/workspace-$agent/learning
  mkdir -p ~/.openclaw/workspace-$agent/memory
  cp -r shared/brand/* ~/.openclaw/workspace-$agent/brand/
done
```

---

## Шаг 5 — Настрой openclaw.json

Создай или отредактируй `~/.openclaw/openclaw.json`:

```json5
{
  "agents": {
    "list": [
      {
        "id": "strategist",
        "name": "Синсей",
        "workspace": "~/.openclaw/workspace-strategist"
      },
      {
        "id": "copywriter",
        "name": "Алёна",
        "workspace": "~/.openclaw/workspace-copywriter"
      },
      {
        "id": "critic",
        "name": "Критик",
        "workspace": "~/.openclaw/workspace-critic"
      },
      {
        "id": "designer",
        "name": "Маша",
        "workspace": "~/.openclaw/workspace-designer"
      },
      {
        "id": "analyst",
        "name": "Максим",
        "workspace": "~/.openclaw/workspace-analyst"
      },
      {
        "id": "videoproducer",
        "name": "Алекс",
        "workspace": "~/.openclaw/workspace-videoproducer"
      },
      {
        "id": "shtab",
        "name": "Решала",
        "workspace": "~/.openclaw/workspace-shtab"
      }
    ]
  },
  "channels": {
    "telegram": {
      "enabled": true,
      "dmPolicy": "allowlist",
      "allowFrom": ["ВАШ_TELEGRAM_ID"],
      "accounts": {
        "strategist": {
          "botToken": "ТОКЕН_SINSEI_БОТА",
          "dmPolicy": "allowlist",
          "allowFrom": ["ВАШ_TELEGRAM_ID"]
        },
        "copywriter": {
          "botToken": "ТОКЕН_ALENA_БОТА",
          "dmPolicy": "allowlist",
          "allowFrom": ["ВАШ_TELEGRAM_ID"]
        },
        "critic": {
          "botToken": "ТОКЕН_CRITIC_БОТА",
          "dmPolicy": "allowlist",
          "allowFrom": ["ВАШ_TELEGRAM_ID"]
        },
        "designer": {
          "botToken": "ТОКЕН_MASHA_БОТА",
          "dmPolicy": "allowlist",
          "allowFrom": ["ВАШ_TELEGRAM_ID"]
        },
        "analyst": {
          "botToken": "ТОКЕН_MAXIM_БОТА",
          "dmPolicy": "allowlist",
          "allowFrom": ["ВАШ_TELEGRAM_ID"]
        },
        "videoproducer": {
          "botToken": "ТОКЕН_ALEX_БОТА",
          "dmPolicy": "allowlist",
          "allowFrom": ["ВАШ_TELEGRAM_ID"]
        },
        "shtab": {
          "botToken": "ТОКЕН_RESHALA_БОТА",
          "dmPolicy": "open",
          "allowFrom": ["*"]
        }
      }
    }
  },
  "bindings": [
    { "agentId": "strategist", "match": { "channel": "telegram", "accountId": "strategist" } },
    { "agentId": "copywriter", "match": { "channel": "telegram", "accountId": "copywriter" } },
    { "agentId": "critic", "match": { "channel": "telegram", "accountId": "critic" } },
    { "agentId": "designer", "match": { "channel": "telegram", "accountId": "designer" } },
    { "agentId": "analyst", "match": { "channel": "telegram", "accountId": "analyst" } },
    { "agentId": "videoproducer", "match": { "channel": "telegram", "accountId": "videoproducer" } },
    { "agentId": "shtab", "match": { "channel": "telegram", "accountId": "shtab" } }
  ],
  "auth": {
    "profiles": {
      "anthropic:default": {
        "provider": "anthropic",
        "mode": "token",
        "token": "ВАШ_ANTHROPIC_API_KEY"
      }
    }
  }
}
```

> **Где найти свой Telegram ID?** Напиши любому боту и запусти `openclaw logs --follow` — в логах найди `from.id`.

---

## Шаг 6 — Установи скиллы

```bash
# Основные скиллы для команды
clawhub install copywriting
clawhub install editing
clawhub install headlines
clawhub install storytelling
clawhub install selling-meanings
clawhub install carousel
clawhub install nano-banana
clawhub install swipefile
clawhub install competitor-analysis
clawhub install reels
clawhub install youtube
clawhub install telegram
clawhub install seo-blog-writer
clawhub install shared-learnings
```

---

## Шаг 7 — Настрой USER.md и brand/

В каждом workspace замени данные в `USER.md`:

```markdown
# USER.md
- **Name:** Твоё имя
- **Telegram:** @твой_username
- **Timezone:** Europe/Moscow
```

И заполни `brand/profile.md` — расскажи агентам о своём бизнесе (см. `docs/CUSTOMIZE.md`).

---

## Шаг 8 — Запусти

```bash
openclaw gateway start
```

Проверь статус:
```bash
openclaw gateway status
```

Напиши любому боту — должен ответить!

---

## Шаг 9 — Проверь связь между агентами

Напиши Синсею: `Привет, расскажи кто в твоей команде`

Он должен перечислить всех агентов и их роли.

---

## Troubleshooting

**Бот не отвечает:**
```bash
openclaw logs --follow
openclaw doctor
```

**Агенты не видят друг друга:**
- Проверь что agent IDs совпадают в `openclaw.json` и в `SOUL.md` каждого агента
- ID для `sessions_send` должны быть: `agent:strategist:telegram:direct:ВАШ_TG_ID`

**Ошибка авторизации Anthropic:**
- Проверь API-ключ в `openclaw.json`
- Убедись что ключ активен на claude.ai/api
