#!/usr/bin/env lua
--
-- ██████╗  ██████╗ ██╗    ██╗███████╗██████╗ ███╗   ███╗███████╗███╗   ██╗██╗   ██╗
-- ██╔══██╗██╔═══██╗██║    ██║██╔════╝██╔══██╗████╗ ████║██╔════╝████╗  ██║██║   ██║
-- ██████╔╝██║   ██║██║ █╗ ██║█████╗  ██████╔╝██╔████╔██║█████╗  ██╔██╗ ██║██║   ██║
-- ██╔═══╝ ██║   ██║██║███╗██║██╔══╝  ██╔══██╗██║╚██╔╝██║██╔══╝  ██║╚██╗██║██║   ██║
-- ██║     ╚██████╔╝╚███╔███╔╝███████╗██║  ██║██║ ╚═╝ ██║███████╗██║ ╚████║╚██████╔╝
-- ╚═╝      ╚═════╝  ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝ ╚═════╝
--
-- ============================================================================
-- PowerMenu for Hyprland 0.55
-- Lua migration from bash script
-- ============================================================================

-- ============================================================================
-- CONFIGURATION
-- ============================================================================

local config = {
  -- Rofi theme paths
  rofi_dir = os.getenv("HOME") .. "/.config/rofi/powermenu/",
  theme = "style",
  confirmation_theme = "confirmation",

  -- User info
  user = os.getenv("USER") or "user",

  -- Menu options (order matters for display)
  options = {
    "Suspend",
    "Lock",
    "Shutdown",
    "Reboot",
    "Hibernate",
    "Logout"
  },

  -- Confirmation options
  yes = "yes",
  no = "no",
}

-- ============================================================================
-- UTILITY FUNCTIONS
-- ============================================================================

--- Execute a command and return its output
-- @param cmd string: Command to execute
-- @return string: Command output (trimmed)
local function exec_cmd(cmd)
  local handle = io.popen(cmd)
  if not handle then
    return ""
  end
  local result = handle:read("*a")
  handle:close()
  return result:match("^%s*(.-)%s*$") -- trim whitespace
end

--- Get system uptime in a formatted string
-- @return string: Formatted uptime (e.g., "2 hrs, 34 mins")
local function get_uptime()
  local uptime = exec_cmd("uptime -p")

  -- Remove "up " prefix
  uptime = uptime:gsub("^up%s+", "")

  -- Replace hour/hours with hr
  uptime = uptime:gsub("hours?", "hr")

  -- Replace minute/minutes with min
  uptime = uptime:gsub("minutes?", "min")

  -- Clean up extra spaces
  uptime = uptime:gsub("%s+", " ")

  return uptime
end

--- Check if a command exists in PATH
-- @param cmd string: Command name to check
-- @return boolean: true if command exists
local function command_exists(cmd)
  local result = os.execute(string.format("command -v %s >/dev/null 2>&1", cmd))
  -- Lua 5.1 returns exit code directly, Lua 5.2+ returns true/nil/exit code
  return result == 0 or result == true
end

-- ============================================================================
-- ROFI FUNCTIONS
-- ============================================================================

--- Display a rofi menu and return the selected option
-- @param prompt string: Prompt text for rofi
-- @param message string: Message to display in rofi
-- @param options string: Newline-separated options
-- @param theme string: Theme filename (relative to rofi_dir)
-- @return string: Selected option (empty if cancelled)
local function run_rofi(prompt, message, options, theme)
  local theme_path = config.rofi_dir .. theme .. ".rasi"
  local cmd = string.format(
    'echo "%s" | rofi -dmenu -p "%s" -mesg "%s" -theme %s',
    options,
    prompt,
    message,
    theme_path
  )

  return exec_cmd(cmd)
end

--- Display the main power menu
-- @return string: Selected option
local function show_main_menu()
  local uptime = get_uptime()
  local options_str = table.concat(config.options, "\n")

  return run_rofi(
    " " .. config.user,
    " Uptime: " .. uptime,
    options_str,
    config.theme
  )
end

--- Display a confirmation dialog
-- @return string: Selected option ("yes" or "no")
local function show_confirmation()
  local options_str = string.format(
    "<span foreground='#a6e3a1'>%s</span>\n<span foreground='#f38ba8'>%s</span>",
    config.yes,
    config.no
  )

  local cmd = string.format(
    'echo -e "%s" | rofi -markup-rows -dmenu -p "Confirmation" -mesg "Are you Sure?" -theme %s',
    options_str,
    config.rofi_dir .. config.confirmation_theme .. ".rasi"
  )

  return exec_cmd(cmd)
end

--- Ask for confirmation before executing an action
-- @return boolean: true if confirmed, false otherwise
local function confirm()
  local selected = show_confirmation()
  -- Check if the selected option contains "yes"
  return selected:find(config.yes) ~= nil
end

-- ============================================================================
-- ACTION FUNCTIONS
-- ============================================================================

--- Shutdown the system
local function shutdown()
  if confirm() then
    os.execute("systemctl poweroff")
  end
end

--- Reboot the system
local function reboot()
  if confirm() then
    os.execute("systemctl reboot")
  end
end

--- Suspend the system
local function suspend()
  -- Add delay to let rofi close
  os.execute("sleep 0.1")

  if confirm() then
    os.execute("systemctl suspend")
  end
end

--- Hibernate the system (currently uses suspend)
local function hibernate()
  if confirm() then
    os.execute("systemctl suspend")
  end
end

--- Lock the screen
local function lock()
  -- Add delay to let rofi close
  os.execute("sleep 0.1")

  -- Try betterlockscreen first, then i3lock, then loginctl
  if command_exists("betterlockscreen") then
    os.execute("betterlockscreen -l")
  elseif command_exists("i3lock") then
    os.execute("i3lock")
  else
    os.execute("loginctl lock-session")
  end
end

--- Logout from Hyprland
local function logout()
  if confirm() then
    os.execute("hyprctl dispatch 'hl.dsp.exit()'")
  end
end

-- ============================================================================
-- MAIN LOGIC
-- ============================================================================

--- Main menu action mapping
local actions = {
  ["Shutdown"] = shutdown,
  ["Reboot"] = reboot,
  ["Suspend"] = suspend,
  ["Hibernate"] = hibernate,
  ["Lock"] = lock,
  ["Logout"] = logout,
}

--- Main entry point
local function main()
  local choice = show_main_menu()

  -- Check if user cancelled or closed the menu
  if choice == "" then
    os.exit(0)
  end

  -- Execute the corresponding action
  if actions[choice] then
    actions[choice]()
  else
    -- Unknown option selected
    os.exit(1)
  end
end

-- Run the main function
main()
