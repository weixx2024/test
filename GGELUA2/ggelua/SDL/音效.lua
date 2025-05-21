-- @Author              : GGELUA
-- @Date                : 2022-03-07 18:52:00
-- @Last Modified by    : baidwwy
-- @Last Modified time  : 2022-10-27 14:02:22

local SDL = require('SDL')
local ggetype = ggetype
local MIX = SDL.MIX_Init()

local SDL音效 = class 'SDL音效'

function SDL音效:SDL音效(file)
    local tp = ggetype(file)
    if tp == 'string' then
        self._wav = MIX.LoadWAV(file)
    elseif tp == 'SDL读写' then
        self._wav = MIX.LoadWAV_RW(file:取对象())
    elseif tp == 'SDL_RWops' then
        self._wav = MIX.LoadWAV_RW(file)
    end

    if self._wav then
        SDL._mixs[self] = self._wav
    else
        print('播放失败')
        warn(SDL.GetError())
    end
end

-- function SDL音效:__close() --即时释放
--     if self._wav then
--         self._wav:__close()
--         self._wav = nil
--     end
-- end

-- SDL音效.__gc = SDL音效.__close

function SDL音效:播放(loop, ms)
    if self:是否播放() then
        return self
    end
    if self:是否暂停() then
        self:恢复()
        return self
    end
    if self._wav then
        if ms then
            if type(loop) == 'number' then
                self._id = self._wav:FadeInChannel(-1, loop, ms)
            else
                self._id = self._wav:FadeInChannel(-1, loop and -1 or 0, ms)
            end
        else
            if type(loop) == 'number' then
                self._id = self._wav:PlayChannel(-1, loop)
            else
                self._id = self._wav:PlayChannel(-1, loop and -1 or 0)
            end
        end
    end
    return self
end

function SDL音效:停止()
    if self._id then
        self._wav:HaltChannel(self._id)
        self._id = nil
    end
    return self
end

function SDL音效:暂停()
    if self._id then
        self._wav:Pause(self._id)
    end
    return self
end

function SDL音效:恢复()
    if self._id then
        self._wav:Resume(self._id)
    end
    return self
end

function SDL音效:是否暂停()
    if self._id then
        return self._wav:Paused(self._id)
    end
end

function SDL音效:是否停止()
    if self._id then
        return not self._wav:Playing(self._id)
    end
end

function SDL音效:是否播放()
    if self._id then
        return self._wav:Playing(self._id)
    end
end

-- function SDL音效:渐变播放(loop, ms)
--     if self._wav then
--         if type(loop) == 'number' then
--             self._id = self._wav:FadeInChannel(-1, loop, ms)
--         else
--             self._id = self._wav:FadeInChannel(-1, loop and -1 or 0, ms)
--         end
--     end
--     return self
-- end

function SDL音效:取渐变状态()
    if self._id then
        return self._wav:FadingChannel(self._id)
    end
end

function SDL音效:置音量(v, all)
    if self._wav and self._id then
        self._wav:Volume(all and -1 or self._id, v)
        self._wav:VolumeChunk(v)
    end
    return self
end

function SDL音效:取音量()
    if self._wav then
        if self._id then
            return self._wav:Volume(self._id, -1)
        end
        return self._wav:VolumeChunk(-1)
    end
    return 0
end

return SDL音效
