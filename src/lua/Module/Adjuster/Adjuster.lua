--- ======================================================================================================
---
---                                                 [ Adjuster Module ]
---
--- Adjustment module (copy/paste after editing)

class "Adjuster" (Module)

require 'Module/Adjuster/AdjusterBank'
require 'Module/Adjuster/AdjusterBoot'
require 'Module/Adjuster/AdjusterCallbacks'
require 'Module/Adjuster/AdjusterLibrary'
require 'Module/Adjuster/AdjusterPattern'

AdjusterData = {
    note = {
        off   = 120,
        empty = 121,
    },
    instrument = { empty = 255 },
    delay      = { empty = 0 },
    volume     = { empty = 255 },
    panning    = { empty = 255 },
    color = {
        clear = Color.off
    },
    bank = {
        line   = 1,
        pitch  = 2,
        vel    = 3,
        pan    = 4,
        delay  = 5,
        column = 6,
    },
}

--- ======================================================================================================
---
---                                                 [ INIT ]

function Adjuster:__init()
    Module:__init(self)

    -- position
    self.track_idx        = 1
    self.instrument_idx   = 1
    self.track_column_idx = 1 -- the column in the track
    self.pattern_idx      = 1 -- actual pattern

    self.note        = Note.note.c
    self.octave      = 4

    self.delay       = 0
    self.volume      = AdjusterData.instrument.empty
    self.pan         = AdjusterData.instrument.empty

    self.mode        = BankData.mode.copy

    -- ---
    -- navigation
    -- ---

    -- zoom
    self.zoom         = 1 -- influences grid size

    -- pagination
    self.page         = 1 -- page of actual pattern
    self.page_start   = 0  -- line left before first pixel
    self.page_end     = 33 -- line right after last pixel


    self.bank_matrix = {}
    self:_clear_bank()

    -- rendering
    self.__pattern_matrix = {}
    self.color = {
        stepper = Color.green,
        page = {
            active   = Color.yellow,
            inactive = Color.off,
        },
        zoom = {
            active   = Color.yellow,
            inactive = Color.off,
        },
        note = {
            off   = Color.red,
            on    = Color.yellow,
            empty = Color.off,
            selected = {
                off   = Color.flash.green,
                on    = Color.flash.green,
                empty = Color.flash.green,
            }
        },
    }

    -- playback position
    self.playback_position_observer = nil
    self.playback_position_last_x = 1
    self.playback_position_last_y = 1

    -- create listeners
    self:_first_run()
    self:_create_callbacks()
end

function Adjuster:wire_launchpad(pad)
    self.pad = pad
end

function Adjuster:wire_playback_position_observer(playback_position_observer)
    if self.playback_position_observer then
        self:unregister_playback_position_observer()
    end
    self.playback_position_observer = playback_position_observer
end


