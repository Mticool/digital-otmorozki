# Настройка под свой бизнес

После установки — настрой команду под себя. Это занимает 15-20 минут.

---

## 1. Расскажи о себе (USER.md)

В каждом workspace замени `USER.md`:

```markdown
- **Name:** Иван Петров
- **What to call them:** Иван
- **Telegram:** @ivan_pro
- **Timezone:** Europe/Moscow
- **Notes:** Предприниматель, e-commerce
```

Скрипт для быстрой замены во всех workspace:
```bash
for agent in strategist copywriter critic designer analyst videoproducer shtab; do
  cat > ~/.openclaw/workspace-$agent/USER.md << 'EOF'
# USER.md
- **Name:** ТВОЁ ИМЯ
- **What to call them:** КАК ОБРАЩАТЬСЯ
- **Telegram:** @ТВОЙ_USERNAME
- **Timezone:** Europe/Moscow
EOF
done
```

---

## 2. Опиши свой бизнес (brand/profile.md)

Это самый важный файл — агенты читают его перед каждым текстом.

```markdown
# brand/profile.md

## О проекте
- Название: [название бизнеса]
- Суть: [что делаешь, для кого]
- Платформы: [Telegram, Instagram, YouTube...]

## Аудитория
- Кто клиенты: [описание]
- Их боли: [список]
- Их желания: [список]

## Продукт/Услуга
- Что продаёшь: [описание]
- УТП: [в чём уникальность]
- Цены: [если нужно]
```

---

## 3. Задай голос (brand/voice-style.md)

```markdown
# brand/voice-style.md

## Тон
- [Формальный/Дружелюбный/Дерзкий/...]
- Обращение: на ты / на вы
- Эмодзи: [часто/редко/никогда]

## Запрещённые слова
- "уникальный"
- "индивидуальный подход"
- [добавь свои]

## Примеры хорошего текста
[вставь 2-3 своих поста которые нравятся]
```

---

## 4. Настрой Решалу (CRM-бот)

Открой `~/.openclaw/workspace-shtab/SOUL.md` и замени:
- Название продукта
- Тарифы
- Контакт для заявок (твой Telegram)
- Описание команды

---

## 5. Обнови agent IDs в SOUL.md каждого агента

В файлах `SOUL.md` есть секция `sessions_send` — там прописаны ID для связи между агентами.

Формат ID: `agent:{agentId}:telegram:direct:{ВАШ_TELEGRAM_ID}`

Например, если твой Telegram ID = `123456789`:
```
agent:copywriter:telegram:direct:123456789
agent:critic:telegram:direct:123456789
```

Замени `250474388` на свой Telegram ID во всех SOUL.md:
```bash
YOUR_TG_ID="123456789"  # замени на свой
for agent in strategist copywriter critic designer analyst videoproducer shtab; do
  sed -i "s/250474388/$YOUR_TG_ID/g" ~/.openclaw/workspace-$agent/SOUL.md
done
```

---

## 6. Первый тест

После настройки напиши Синсею:
```
Привет! Расскажи коротко кто ты и твоя команда.
```

Если всё ок — он представится и опишет команду в твоём стиле.

Потом попробуй:
```
Напиши пост для [платформа] на тему [тема]
```

Синсей делегирует Алёне, та напишет, Критик проверит, результат придёт тебе.
