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
echo "AI-команда из 6 агентов. Потребуется ~10 минут."
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

# ---- Создаём структуру ----
echo -e "${YELLOW}[3/6] Создаём workspace команды...${NC}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE="$HOME/otmorozki"

# Общие папки (одни на всю команду)
mkdir -p "$BASE/shared"/{brand,learning,memory}

# Копируем общий бренд
cp -r "$SCRIPT_DIR/shared/brand/"* "$BASE/shared/brand/"

# Пустые файлы памяти
touch "$BASE/shared/learning/corrections.md"
touch "$BASE/shared/learning/patterns.md"
touch "$BASE/shared/learning/anti-patterns.md"
cat > "$BASE/shared/memory/active-context.md" << 'EOF'
# Active Context
_Обновлено: при первом запуске_

## Статус
- Команда установлена
- Заполни brand/ под свой бизнес (docs/CUSTOMIZE.md)
EOF

# USER.md (общий для всех)
cat > "$BASE/shared/USER.md" << EOF
# USER.md
- **Name:** $OWNER_NAME
- **What to call them:** $OWNER_NAME
- **Telegram:** @$OWNER_TG_USERNAME
- **Timezone:** Europe/Moscow
EOF

echo "  ✅ Общие папки: $BASE/shared/"

# Каждый агент — свой workspace + симлинки на общий brand/learning/memory
declare -A AGENTS=(
  [reshala]="07-reshala-crm"
  [sinsei]="01-sinsei-strategist"
  [alena]="02-alena-copywriter"
  [masha]="04-masha-designer"
  [maxim]="05-maxim-analyst"
  [alex]="06-alex-videoproducer"
)

for AGENT_ID in reshala sinsei alena masha maxim alex; do
  AGENT_DIR="${AGENTS[$AGENT_ID]}"
  WS="$BASE/agents/$AGENT_ID"
  mkdir -p "$WS"

  # SOUL.md — уникальный для каждого агента
  cp "$SCRIPT_DIR/agents/$AGENT_DIR/SOUL.md" "$WS/SOUL.md"
  sed -i "s/{OWNER_TG_ID}/$OWNER_TG_ID/g" "$WS/SOUL.md"
  sed -i "s/YOUR_TELEGRAM_ID/$OWNER_TG_ID/g" "$WS/SOUL.md"

  # Общие файлы конфигурации
  cp "$SCRIPT_DIR/agents/$AGENT_DIR/BOOTSTRAP.md" "$WS/BOOTSTRAP.md" 2>/dev/null || \
    cp "$SCRIPT_DIR/agents/01-sinsei-strategist/BOOTSTRAP.md" "$WS/BOOTSTRAP.md"
  cp "$SCRIPT_DIR/agents/$AGENT_DIR/HEARTBEAT.md" "$WS/HEARTBEAT.md" 2>/dev/null || \
    cp "$SCRIPT_DIR/agents/01-sinsei-strategist/HEARTBEAT.md" "$WS/HEARTBEAT.md"
  cp "$SCRIPT_DIR/agents/$AGENT_DIR/AGENTS.md"    "$WS/AGENTS.md" 2>/dev/null || \
    cp "$SCRIPT_DIR/agents/01-sinsei-strategist/AGENTS.md" "$WS/AGENTS.md"

  # Симлинки на общие папки (brand, learning, memory одни на всю команду)
  ln -sf "$BASE/shared/brand"    "$WS/brand"
  ln -sf "$BASE/shared/learning" "$WS/learning"
  ln -sf "$BASE/shared/memory"   "$WS/memory"
  ln -sf "$BASE/shared/USER.md"  "$WS/USER.md"

  echo "  ✅ $AGENT_ID → $WS"
done

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
      { "id": "shtab",         "name": "Решала",  "workspace": "$BASE/agents/reshala" },
      { "id": "strategist",    "name": "Синсей",  "workspace": "$BASE/agents/sinsei" },
      { "id": "copywriter",    "name": "Алёна",   "workspace": "$BASE/agents/alena" },
      { "id": "designer",      "name": "Маша",    "workspace": "$BASE/agents/masha" },
      { "id": "analyst",       "name": "Максим",  "workspace": "$BASE/agents/maxim" },
      { "id": "videoproducer", "name": "Алекс",   "workspace": "$BASE/agents/alex" }
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
echo "Структура:"
echo "  $BASE/shared/   — общий brand/, learning/, memory/"
echo "  $BASE/agents/   — каждый агент со своим SOUL.md"
echo ""
echo "Что дальше:"
echo "  1. Напиши Решале в Telegram — он ответит"
echo "  2. Заполни бизнес: $BASE/shared/brand/"
echo "  3. Статус: openclaw gateway status"
echo "  4. Логи:   openclaw logs --follow"
echo ""
echo -e "${BLUE}Документация: https://docs.openclaw.ai${NC}"
echo ""
