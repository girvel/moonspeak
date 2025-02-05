-- types --

--- @alias moonspeak_script (moonspeak_code | moonspeak_lines | moonspeak_options)[]

--- @class moonspeak_code
--- @field type "code"
--- @field description string

--- @class moonspeak_lines
--- @field type "lines"
--- @field lines moonspeak_line[]

--- @class moonspeak_line
--- @field source string
--- @field text string

--- @class moonspeak_options
--- @field type "moonspeak_options"
--- @field options moonspeak_option[]

--- @class moonspeak_option
--- @field text string
--- @field branch moonspeak_script


-- API --

local read

local moonspeak = {}

--- @param content string
--- @return moonspeak_script
moonspeak.read = function(content)
  return read(content, "", 1)
end


-- implementation --

read = function(content, indent, start_index)
  local result = {}
  local nickname_map = {}

  local is_in_header = start_index == 1
  if is_in_header then
    assert(content:sub(1, 4) == "---\n")
    start_index = 5
  end

  while true do
    local end_of_line_i = content:find("\n", start_index)
    if not end_of_line_i then break end
    if end_of_line_i == start_index then
      start_index = start_index + 1
      goto continue
    end

    local line = content:sub(start_index, end_of_line_i - 1)
    start_index = end_of_line_i + 1

    if is_in_header then
      if line == "---" then
        is_in_header = false
      else
        local i, j = line:find(": ")
        nickname_map[line:sub(j + 1)] = line:sub(1, i - 1)
      end
      goto continue
    end

    if line:sub(1, 1) == "!" then
      assert(line:sub(2, 2) == " ")

      local last = result[#result]
      if last and last.type == "code" then
        last.description = last.description .. "\n" .. line:sub(3)
      else
        table.insert(result, {
          type = "code",
          description = line:sub(3)
        })
      end
      goto continue
    end

    ::continue::
  end

  return result
end

return moonspeak
