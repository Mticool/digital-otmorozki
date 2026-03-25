# 🤖 Цифровые Отморозки — AI-команда для предпринимателя

> 6 AI-сотрудников в Telegram. Контент, аналитика, стратегия, дизайн, видео — из одной системы. Построено на [OpenClaw](https://openclaw.ai).

---

## Состав команды

| # | Агент | Роль | Основные скиллы |
|---|-------|------|-----------------|
| 1 | ⚙️ **Решала** | **Главный. Принимает задачи, раздаёт команде** | selling-meanings, prompt-engineer |
| 2 | 🧠 **Синсей** | Стратег — смыслы, распаковка, стратегия | selling-meanings, personal-unpacking |
| 3 | ✍️ **Алёна** | Копирайтер — посты, тексты, статьи | copywriting, editing, headlines, storytelling |
| 4 | 🔍 **Критик** | Редактор — проверяет всё перед выдачей | editing, shared-learnings |
| 5 | 🎨 **Маша** | Дизайнер — карусели, обложки, картинки | carousel, nano-banana, heygen |
| 6 | 📊 **Максим** | Аналитик — тренды, конкуренты, SwipeFile | swipefile, competitor-analysis, news-summary |
| 7 | 🎬 **Алекс** | Видео продюсер — Reels, YouTube, монтаж | reels, youtube, video-editor, veo-video |

---

## Как работает команда

```
Ты → Решала → Синсей (стратегия)
            → Алёна (текст) → Критик → тебе
            → Маша (дизайн)
            → Максим (аналитика)
            → Алекс (видео)
```

**Решала** — единая точка входа. Ты пишешь ему — он сам решает кому делегировать.
Все тексты автоматически проходят через Критика перед выдачей.

---

## Структура репозитория

```
agents/
  01-sinsei-strategist/    🧠 Стратег
    SOUL.md                  — личность, миссия, правила
    BOOTSTRAP.md             — что читать при старте
    HEARTBEAT.md             — что делать при пингах
    AGENTS.md                — протокол памяти
    SKILLS.md                — какие скиллы устанавливать
  02-alena-copywriter/     ✍️ Копирайтер
  03-critic/               🔍 Критик
  04-masha-designer/       🎨 Дизайнер
  05-maxim-analyst/        📊 Аналитик
  06-alex-videoproducer/   🎬 Видео продюсер
  07-reshala-crm/          ⚙️ CRM-бот

shared/
  brand/                   — профиль, голос, аудитория (настроить под себя)
  skills-list/             — полный список скиллов с командами

docs/
  INSTALL.md               — установка с нуля (шаг за шагом)
  CUSTOMIZE.md             — настройка под свой бизнес
```

---

## Быстрый старт

```bash
# 1. Установи OpenClaw
npm install -g openclaw

# 2. Клонируй репо
git clone https://github.com/Mticool/digital-otmorozki.git
cd digital-otmorozki

# 3. Следуй инструкции
cat docs/INSTALL.md
```

Полная инструкция: **[docs/INSTALL.md](docs/INSTALL.md)**
Настройка под себя: **[docs/CUSTOMIZE.md](docs/CUSTOMIZE.md)**

---

## Требования

- VPS или сервер (Ubuntu 20.04+, от 2GB RAM) — Hetzner CX22 ~€4/мес
- Node.js 18+
- 7 Telegram-ботов (создать в @BotFather — бесплатно)
- API-ключ Anthropic (claude.ai/api)

---

## Связь

- OpenClaw docs: [docs.openclaw.ai](https://docs.openclaw.ai)
- ClawHub (скиллы): [clawhub.com](https://clawhub.com)
