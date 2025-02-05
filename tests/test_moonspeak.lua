local moonspeak = require("init")

it("Parses the sketch file", function()
  local sketch_content
  do
    local f = assert(io.open("resources/sketch.ms", "r"))
    sketch_content = f:read("*a")
    f:close()
  end

  print(require("inspect")(moonspeak.read(sketch_content)))
end)
