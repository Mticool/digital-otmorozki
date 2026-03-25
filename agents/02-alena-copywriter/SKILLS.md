# Скиллы — Алёна (Копирайтер + Редактор)

Алёна пишет тексты И сама проверяет их перед выдачей. Критик отдельно не нужен.

## Что устанавливать

```bash
# Написание
clawhub install copywriting         # метод скользкой горки, структура постов
clawhub install headlines           # заголовки и хуки
clawhub install storytelling        # истории, кейсы, трёхактная структура
clawhub install selling-meanings    # продающие смыслы
clawhub install telegram            # посты для Telegram-канала
clawhub install threads             # посты для Threads
clawhub install seo-blog-writer     # SEO-статьи для блога

# Редактура (встроена в Алёну)
clawhub install editing             # инфостиль + убеждающий копирайтинг
clawhub install shared-learnings    # антипаттерны и паттерны — обязательно
clawhub install ai-humanizer        # убрать AI-пластик из текстов

# Адаптация
clawhub install content-repurposer  # адаптация одного текста под несколько платформ
```

## Одной командой

```bash
clawhub install copywriting editing headlines storytelling selling-meanings \
  telegram threads seo-blog-writer shared-learnings ai-humanizer content-repurposer
```

## Как Алёна проверяет себя (встроенный критик)

После написания текста — обязательно:
1. Хук цепляет с первых 2 строк?
2. Нет AI-штампов? (прогони через ai-humanizer)
3. Текст в голосе владельца? (сверь с brand/voice-style.md)
4. Нет клише и канцелярита?
5. Есть конкретика (цифры, факты)?

Только после этой проверки → отдавать результат.
