-- types --

--- @alias moonspeak moonspeak_element[]

--- @alias moonspeak_element moonspeak_code | moonspeak_lines | moonspeak_options | moonspeak_branches | moonspeak_literal

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
--- @field type "options"
--- @field options moonspeak_branch[]

--- @class moonspeak_branches
--- @field type "branches"
--- @field branches moonspeak_branch[]

--- @class moonspeak_branch
--- @field type "branch"
--- @field text string
--- @field branch moonspeak

--- @class moonspeak_literal
--- @field type "literal"
--- @field text string


-- API --

local read

local moonspeak = {}

--- @param content string
--- @return moonspeak
moonspeak.read = function(content)
  local result = read(content, "", 1, {}, 0)
  return result
end


-- implementation --


local starts_with = function(str, substr, offset)
  return str:sub(offset, offset + #substr - 1) == substr
end

--- @param content string
--- @param indent string
read = function(content, indent, offset, nickname_map, line_i)
  local result = {}

  local is_in_header = offset == 1
  if is_in_header then
    assert(
      content:sub(1, 4) == "---\n",
      ("Moonscript file should start with \"---\\n\", got %q instead"):format(content:sub(1, 4))
    )
    offset = 5
    line_i = line_i + 1
  end

  local is_in_literal = false
  while offset ~= #content do
    if starts_with(content, "\n", offset) then
      offset = offset + 1
      line_i = line_i + 1
      goto continue
    elseif starts_with(content, indent, offset) then
      offset = offset + #indent
    else
      break
    end
    line_i = line_i + 1

    local end_of_line_i = content:find("\n", offset)

    local line
    if end_of_line_i then
      line = content:sub(offset, end_of_line_i - 1)
      offset = end_of_line_i + 1
    elseif offset >= #content then
      break
    else
      line = content:sub(offset)
      offset = #content
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

    local last = result[#result]

    if is_in_literal then
      if line == '"""' then
        is_in_literal = false
      else
        if last.text then
          last.text = last.text .. "\n" .. line
        else
          last.text = line
        end
      end
      goto continue
    end

    if line == '"""' then
      is_in_literal = true
      table.insert(result, {type = "literal"})
      goto continue
    end

    if line:sub(1, 1) == "!" then
      local branch
      branch, offset, line_i = read(content, indent .. "  ", offset, nickname_map, line_i)

      if not last or last.type ~= "branches" then
        table.insert(result, {type = "branches", branches = {}})
      end

      table.insert(result[#result].branches, {type = "branch", text = line:sub(2), branch = branch})
      goto continue
    end

    local i, j, n = line:find("(%d+)%. ")
    if i then
      local branch
      branch, offset, line_i = read(content, indent .. "  ", offset, nickname_map, line_i)

      if not last or last.type ~= "options" then
        table.insert(result, {type = "options", options = {}})
      end

      result[#result].options[tonumber(n)] = {
        text = line:sub(j + 1),
        branch = branch,
      }

      goto continue
    end

    i, j = line:find(": ")
    if i then
      if not last or last.type ~= "lines" then
        table.insert(result, {
          type = "lines",
          lines = {}
        })
      end

      table.insert(result[#result].lines, {
        source = nickname_map[line:sub(1, i - 1)],
        text = line:sub(j + 1):gsub(" %-%- ", " — "),
      })
      goto continue
    end

    if last and last.type == "code" then
      last.description = last.description .. "\n" .. line
    else
      table.insert(result, {
        type = "code",
        description = line
      })
    end

    ::continue::
  end

  return result, offset, line_i
end

return moonspeak
