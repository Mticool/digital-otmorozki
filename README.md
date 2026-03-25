# 🤖 Цифровые Отморозки — AI-команда для предпринимателя

> 6 AI-сотрудников в Telegram. Контент, аналитика, стратегия, дизайн, видео — из одной системы. Построено на [OpenClaw](https://openclaw.ai).

---

## Состав команды

| # | Агент | Роль | Скиллы |
|---|-------|------|--------|
| ⚙️ **Решала** | **Главный координатор** — принимает задачи, раздаёт команде | calendar, productivity |
| 🧠 **Синсей** | Стратег — смыслы, распаковка, анализ рынка | selling-meanings, personal-unpacking, swipefile, competitor-analysis |
| ✍️ **Алёна** | Копирайтер + Редактор — пишет, проверяет, финализирует | copywriting, editing, headlines, storytelling, ai-humanizer, content-repurposer |
| 🎨 **Маша** | Дизайнер — карусели, картинки, аватары | carousel, nano-banana, heygen, openai-image-gen |
| 📊 **Максим** | Аналитик — тренды, конкуренты, данные | swipefile, competitor-analysis, apify-ultimate-scraper, instagram-research |
| 🎬 **Алекс** | Видео продюсер — Reels, YouTube, монтаж | reels, youtube, video-editor, veo-video |

---

## Как работает команда

```
Ты → Решала → Синсей (стратегия / смыслы)
            → Алёна  (текст + редактура)
            → Маша   (дизайн)
            → Максим (аналитика)
            → Алекс  (видео)
```

**Решала** — единая точка входа. Пишешь ему — он сам решает кому делегировать.
**Алёна** совмещает написание и редактуру — отдельный Критик не нужен.

---

## Структура репозитория

```
agents/
  01-sinsei-strategist/    🧠 Стратег
  02-alena-copywriter/     ✍️ Копирайтер + Редактор
  03-critic/               🔍 (устарел, не используется)
  04-masha-designer/       🎨 Дизайнер
  05-maxim-analyst/        📊 Аналитик
  06-alex-videoproducer/   🎬 Видео продюсер
  07-reshala-crm/          ⚙️ Главный координатор

shared/
  brand/                   — профиль, голос, аудитория (настроить под себя)
  skills-list/             — полный список скиллов

docs/
  INSTALL.md               — установка с нуля
  CUSTOMIZE.md             — настройка под свой бизнес
```

> Папка `03-critic` оставлена для обратной совместимости. Если хочешь — можешь установить Критика как отдельного агента, но в базовой конфигурации он не нужен.

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

---

## Требования

- VPS или сервер (Ubuntu 20.04+, от 2GB RAM) — Hetzner CX22 ~€4/мес
- Node.js 18+
- 6 Telegram-ботов (создать в @BotFather — бесплатно)
- API-ключ Anthropic (claude.ai/api)

---

## Ссылки

- OpenClaw docs: [docs.openclaw.ai](https://docs.openclaw.ai)
- ClawHub (скиллы): [clawhub.com](https://clawhub.com)
