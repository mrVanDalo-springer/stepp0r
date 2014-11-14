--- transforms key number to volume
-- number must be 1-8
function xToVolume(number)
    if number < 2 or number > 8 then return 255 end
    return 16 * (9 - number ) - 1
end

function Effect:set_volume(volume)
    self.volume = volume
    self:matrix_refresh()
    -- trigger callbacks
    local percent = xToVolume(self.volume)
    for _, callback in ipairs(self.callbacks_set_volume) do
        callback(percent)
    end
end

function Effect:matrix_update_volume()
    local on  = self:mode_color()
    local off = self.color.off
    for i = 1, 8 do
        local color = off
        if (self.volume <= i) then color = on end
        self.pad:set_matrix(i,self.row,color)
    end
end
