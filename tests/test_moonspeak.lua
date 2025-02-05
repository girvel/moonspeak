local moonspeak = require("init")

it("Parses the sketch file", function()
  local sketch_content
  do
    local f = assert(io.open("resources/sketch.ms", "r"))
    sketch_content = f:read("*a")
    f:close()
  end

  local script = moonspeak.read(sketch_content)
  local expected = {
    {type = "code", description = "Первая версия просто разделяет текст и код, позволяя решать две задачи:\n1. Переводить игру на другие языки\n2. Не надо копировать текст в скрипты"},
    {type = "lines", lines = {
      {source = "narrative", text = "Когда ты подходишь ближе, измазанный сажей полуэльф всё так же не оборачивается."},
      {source = "narrative", text = "Его глаза, не отрываясь, смотрят прямо на приборы."},
      {source = "narrative", text = "Полуповисшая рука мертвой хваткой сжимает газовый ключ."},
    }},

    {type = "options", options = {
      {text = "Какую работу ты выполняешь?", branch = {
        {type = "lines", lines = {
          {source = "engineer_1", text = "Главный инженер, %ГГ%"},
        }},
        {type = "code", description = "крутые спецэффекты"},
        {type = "lines", lines = {
          {source = "engineer_1", text = "Моя работа — наблюдать за приборами"},
          {source = "engineer_1", text = "..."},
        }},
      }},

      {text = "Наблюдал что-то необычное в последнее время?", branch = {
        {type = "lines", lines = {
          {source = "engineer_1", text = "Бла-бла-бла"},
        }},
      }},

      {text = "Бла-бла?", branch = {
        {type = "lines", lines = {
          {source = "engineer_1", text = "Бла-бла"},
        }},
      }},

      {text = "*уйти*", branch = {
        {type = "code", description = "конец"},
      }},
    }},
  }

  assert.are_same(expected, script)
end)
