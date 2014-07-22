--- ======================================================================================================
---
---                                                 [ Launchpad Module ]
--- mode super class
---
--- this class should some-how define how every module should behave
--- which should make creating modes easier
---
--- A mode is a mix of modules

-- todo rename me to module
class "LaunchpadModule"

function LaunchpadModule:__init()
    self.is_active     = false
    self.is_not_active = true
    self.first_run     = true   -- is this the first run
end

function LaunchpadModule:activate()
    self.is_active = true
    self.is_not_active = false
    self:_activate()
    self.first_run = false
end

--- to deactivate this Module
-- everything that is active now should be roled back
-- clear matrix etc. But don't unregsiter yourself or something.
--
-- The Module should be able to activate afterwards
function LaunchpadModule:deactivate()
    self.is_active = false
    self.is_not_active = true
    self:_deactivate()
end

function LaunchpadModule:__tostring()
  return ("LaunchpadModule : %s"):format(self.is_active)
end
