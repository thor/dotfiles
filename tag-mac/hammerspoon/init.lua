stackline = require "stackline"
stackline:init({
  paths = {
    yabai = "/run/current-system/sw/bin/yabai"
  },
  features = {
    fzyFrameDetect = {
      enabled = true,
      fuzzFactor = 30,
    },
    clickToFocus = true,
    hsBugWorkaround = true,
    winTitles = true,
    dynamicLuminosity = true,
  }
}
)
