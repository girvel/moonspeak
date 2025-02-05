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
  local result, _ = read(content, "", 1)
  return result
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

  while
    start_index ~= #content
    and content:sub(start_index, start_index + #indent - 1) == indent
  do
    start_index = start_index + #indent

    local end_of_line_i = content:find("\n", start_index)
    if end_of_line_i == start_index then
      start_index = start_index + 1
      goto continue
    end

    local line
    if end_of_line_i then
      line = content:sub(start_index, end_of_line_i - 1)
      start_index = end_of_line_i + 1
    else
      line = content:sub(start_index)
      start_index = #content
    end

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

    local i, j, n = line:find("(%d+). ")
    if i then
      local branch
      branch, start_index = read(content, indent .. "  ", start_index)

      if result[#result].type ~= "options" then
        table.insert(result, {type = "options", options = {}})
      end

      result[#result].options[tonumber(n)] = {
        text = line:sub(j + 1),
        branch = branch,
      }
    end

    -- TODO line
    -- TODO unkown format error

    ::continue::
  end

  return result, start_index
end

return moonspeak
