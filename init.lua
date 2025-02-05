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


local moonspeak = {}

--- @param content string
--- @return moonspeak_script
moonspeak.read = function(content)
  return {}
end

return moonspeak
