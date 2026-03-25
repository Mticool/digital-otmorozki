#!/bin/bash

# ============================================================
# 🤖 Цифровые Отморозки — Автоустановщик
# ============================================================
# Запуск: bash install.sh
# ============================================================

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  🤖 Цифровые Отморозки — Установка        ${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""
echo "AI-команда из 6 агентов в одном workspace."
echo "Потребуется ~10 минут и ответы на несколько вопросов."
echo ""

# ---- Проверка зависимостей ----
echo -e "${YELLOW}[1/6] Проверяем зависимости...${NC}"

if ! command -v node &> /dev/null; then
  echo -e "${RED}❌ Node.js не найден. Установи Node.js 18+: https://nodejs.org${NC}"
  exit 1
fi

NODE_VER=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VER" -lt 18 ]; then
  echo -e "${RED}❌ Нужен Node.js 18+. Текущая версия: $(node -v)${NC}"
  exit 1
fi
echo -e "${GREEN}✅ Node.js $(node -v)${NC}"

if ! command -v openclaw &> /dev/null; then
  echo "Устанавливаем OpenClaw..."
  npm install -g openclaw
fi
echo -e "${GREEN}✅ OpenClaw готов${NC}"

if ! command -v clawhub &> /dev/null; then
  echo "Устанавливаем ClawHub..."
  npm install -g clawhub
fi
echo -e "${GREEN}✅ ClawHub готов${NC}"

echo ""

# ---- Сбор данных ----
echo -e "${YELLOW}[2/6] Настройка — ответь на вопросы:${NC}"
echo ""

read -p "👤 Твоё имя (как к тебе обращаться): " OWNER_NAME
read -p "💬 Твой Telegram username (без @): " OWNER_TG_USERNAME
read -p "🔢 Твой Telegram ID (число, найди через @userinfobot): " OWNER_TG_ID
echo ""
echo -e "${BLUE}🔑 API-ключ Anthropic (claude.ai/api → API Keys):${NC}"
read -p "Ключ (sk-ant-...): " ANTHROPIC_KEY
echo ""
echo -e "${BLUE}🤖 Telegram токены ботов (создать в @BotFather → /newbot):${NC}"
echo ""
read -p "⚙️  Токен Решалы (главный бот): " TOKEN_RESHALA
read -p "🧠 Токен Синсея: " TOKEN_SINSEI
read -p "✍️  Токен Алёны: " TOKEN_ALENA
read -p "🎨 Токен Маши: " TOKEN_MASHA
read -p "📊 Токен Максима: " TOKEN_MAXIM
read -p "🎬 Токен Алекса: " TOKEN_ALEX

echo ""
echo -e "${YELLOW}[3/6] Создаём единый workspace команды...${NC}"

WORKSPACE="$HOME/otmorozki"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Один workspace для всей команды
mkdir -p "$WORKSPACE"/{brand,learning,memory}

# Копируем SOUL.md каждого агента в workspace
cp "$SCRIPT_DIR/agents/07-reshala-crm/SOUL.md"        "$WORKSPACE/SOUL-reshala.md"
cp "$SCRIPT_DIR/agents/01-sinsei-strategist/SOUL.md"   "$WORKSPACE/SOUL-sinsei.md"
cp "$SCRIPT_DIR/agents/02-alena-copywriter/SOUL.md"    "$WORKSPACE/SOUL-alena.md"
cp "$SCRIPT_DIR/agents/04-masha-designer/SOUL.md"      "$WORKSPACE/SOUL-masha.md"
cp "$SCRIPT_DIR/agents/05-maxim-analyst/SOUL.md"       "$WORKSPACE/SOUL-maxim.md"
cp "$SCRIPT_DIR/agents/06-alex-videoproducer/SOUL.md"  "$WORKSPACE/SOUL-alex.md"

# Копируем общие файлы
cp "$SCRIPT_DIR/agents/01-sinsei-strategist/BOOTSTRAP.md" "$WORKSPACE/BOOTSTRAP.md"
cp "$SCRIPT_DIR/agents/01-sinsei-strategist/HEARTBEAT.md" "$WORKSPACE/HEARTBEAT.md"
cp "$SCRIPT_DIR/agents/01-sinsei-strategist/AGENTS.md"    "$WORKSPACE/AGENTS.md"
cp -r "$SCRIPT_DIR/shared/brand/"*                        "$WORKSPACE/brand/"

# Подставляем TG ID владельца во все SOUL.md
for f in "$WORKSPACE"/SOUL-*.md; do
  sed -i "s/{OWNER_TG_ID}/$OWNER_TG_ID/g" "$f"
  sed -i "s/YOUR_TELEGRAM_ID/$OWNER_TG_ID/g" "$f"
done

# Создаём USER.md
cat > "$WORKSPACE/USER.md" << EOF
# USER.md
- **Name:** $OWNER_NAME
- **What to call them:** $OWNER_NAME
- **Telegram:** @$OWNER_TG_USERNAME
- **Timezone:** Europe/Moscow
EOF

# Создаём пустые файлы памяти
touch "$WORKSPACE/learning/corrections.md"
touch "$WORKSPACE/learning/patterns.md"
touch "$WORKSPACE/learning/anti-patterns.md"

cat > "$WORKSPACE/memory/active-context.md" << 'EOF'
# Active Context
_Обновлено: при первом запуске_

## Статус
- Команда только что установлена
- Заполни brand/ под свой бизнес (см. docs/CUSTOMIZE.md)
EOF

echo "  ✅ Workspace: $WORKSPACE"

echo ""
echo -e "${YELLOW}[4/6] Настраиваем openclaw.json...${NC}"

cat > ~/.openclaw/openclaw.json << EOF
{
  "agents": {
    "defaults": {
      "model": {
        "primary": "anthropic/claude-sonnet-4-6"
      }
    },
    "list": [
      { "id": "shtab",         "name": "Решала",  "workspace": "$WORKSPACE" },
      { "id": "strategist",    "name": "Синсей",  "workspace": "$WORKSPACE" },
      { "id": "copywriter",    "name": "Алёна",   "workspace": "$WORKSPACE" },
      { "id": "designer",      "name": "Маша",    "workspace": "$WORKSPACE" },
      { "id": "analyst",       "name": "Максим",  "workspace": "$WORKSPACE" },
      { "id": "videoproducer", "name": "Алекс",   "workspace": "$WORKSPACE" }
    ]
  },
  "auth": {
    "profiles": {
      "anthropic:default": {
        "provider": "anthropic",
        "mode": "token",
        "token": "$ANTHROPIC_KEY"
      }
    }
  },
  "session": {
    "dmScope": "per-channel-peer"
  },
  "channels": {
    "telegram": {
      "enabled": true,
      "dmPolicy": "allowlist",
      "allowFrom": ["$OWNER_TG_ID"],
      "accounts": {
        "shtab": {
          "botToken": "$TOKEN_RESHALA",
          "dmPolicy": "open",
          "allowFrom": ["*"]
        },
        "strategist": {
          "botToken": "$TOKEN_SINSEI",
          "dmPolicy": "allowlist",
          "allowFrom": [$OWNER_TG_ID]
        },
        "copywriter": {
          "botToken": "$TOKEN_ALENA",
          "dmPolicy": "allowlist",
          "allowFrom": [$OWNER_TG_ID]
        },
        "designer": {
          "botToken": "$TOKEN_MASHA",
          "dmPolicy": "allowlist",
          "allowFrom": [$OWNER_TG_ID]
        },
        "analyst": {
          "botToken": "$TOKEN_MAXIM",
          "dmPolicy": "allowlist",
          "allowFrom": [$OWNER_TG_ID]
        },
        "videoproducer": {
          "botToken": "$TOKEN_ALEX",
          "dmPolicy": "allowlist",
          "allowFrom": [$OWNER_TG_ID]
        }
      }
    }
  },
  "bindings": [
    { "agentId": "shtab",         "match": { "channel": "telegram", "accountId": "shtab" } },
    { "agentId": "strategist",    "match": { "channel": "telegram", "accountId": "strategist" } },
    { "agentId": "copywriter",    "match": { "channel": "telegram", "accountId": "copywriter" } },
    { "agentId": "designer",      "match": { "channel": "telegram", "accountId": "designer" } },
    { "agentId": "analyst",       "match": { "channel": "telegram", "accountId": "analyst" } },
    { "agentId": "videoproducer", "match": { "channel": "telegram", "accountId": "videoproducer" } }
  ]
}
EOF

echo "  ✅ openclaw.json создан"
echo "  ✅ Workspace: $WORKSPACE (один для всей команды)"

echo ""
echo -e "${YELLOW}[5/6] Устанавливаем скиллы...${NC}"

clawhub install copywriting editing headlines storytelling selling-meanings \
  telegram threads seo-blog-writer shared-learnings ai-humanizer content-repurposer \
  personal-unpacking customer-research swipefile competitor-analysis \
  carousel nano-banana apify-ultimate-scraper instagram-research news-summary \
  reels youtube video-editor calendar productivity 2>/dev/null || true

echo -e "${GREEN}  ✅ Скиллы установлены${NC}"

echo ""
echo -e "${YELLOW}[6/6] Запускаем OpenClaw...${NC}"

openclaw gateway start

echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  ✅ Готово! Команда запущена.              ${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo "Workspace команды: $WORKSPACE"
echo ""
echo "Что дальше:"
echo "  1. Напиши Решале в Telegram — он ответит"
echo "  2. Заполни brand/ под свой бизнес: $WORKSPACE/brand/"
echo "  3. Статус: openclaw gateway status"
echo "  4. Логи:   openclaw logs --follow"
echo ""
echo -e "${BLUE}Документация: https://docs.openclaw.ai${NC}"
echo -e "${BLUE}Скиллы:       https://clawhub.com${NC}"
echo ""
