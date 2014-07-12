--
-- User: palo
-- Date: 7/7/14
--

require 'Experimental/Observable'

class "PlaybackPositionObserver"

function PlaybackPositionObserver:__init()
    self.observer   = Observer()
end

--
-- register a function that gets the value
function PlaybackPositionObserver:register(f)
    self.observer:add_notifier(f,"renoise.song().transport.playback_pos")
end

function PlaybackPositionObserver:unregister(f)
    self.observer:remove_notifier(f)
end
