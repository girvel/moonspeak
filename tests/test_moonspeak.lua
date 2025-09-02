local moonspeak = require("init")

local resource = function(path)
  local f = assert(io.open("resources/" .. path, "r"))
  local result = f:read("*a")
  f:close()
  return result
end

it("Parses the sketch file", function()
  local script = moonspeak.read(resource("example.ms"))

  local expected = {
    {type = "code", description = "Первая версия просто разделяет текст и код, позволяя решать две задачи:\n1) Переводить игру на другие языки\n2) Не надо копировать текст в скрипты"},
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
        {type = "literal", text = "123123\n1212"},
      }},

      {text = "Бла-бла?", branch = {
        {type = "lines", lines = {
          {source = "engineer_1", text = "Бла-бла"},
        }},
        {type = "branches", branches = {
          {type = "branch", text = "проверка", branch = {
            {type = "lines", lines = {
              {source = "engineer_1", text = "Бла-бла"},
            }},
          }},
          {type = "branch", text = "иначе", branch = {
            {type = "lines", lines = {
              {source = "engineer_1", text = "Бла-бла"},
            }},
          }},
        }},
      }},

      {text = "*уйти*", branch = {
        {type = "code", description = "конец"},
      }},
    }},
  }

  assert.are_same(expected, script)
end)
