---
narrative: О
engineer_1: Н
player: П
---

Вторая версия также решает две базовые задачи:
1) Переводить игру на другие языки
2) Не надо копировать текст в скрипты

По сравнению с первой, есть следующие изменения:
1) Описания не требуют ! в начале
2) Есть условные ветки -- они начинаются с ! и содержат в себе контент
3) С помощью кавычек можно хранить сырые значения для таких штук как уведомления

О: Когда ты подходишь ближе, измазанный сажей полуэльф всё так же не оборачивается.
О: Его глаза, не отрываясь, смотрят прямо на приборы.
О: Полуповисшая рука мертвой хваткой сжимает газовый ключ.

1. Какую работу ты выполняешь?
  Н: Главный инженер, %ГГ%

  крутые спецэффекты

  Н: Моя работа — наблюдать за приборами
  Н: ...

2. Наблюдал что-то необычное в последнее время?
  Н: Бла-бла-бла

  !проверка мудрости
    Уведомление
    "Хватит его слушать"

3. Бла-бла?
  Н: Бла-бла

4. *уйти*
  конец
