local gears = require("gears")

local M = {}

M.assets_dir = gears.filesystem.get_configuration_dir().."/widgets/assets"

return M
