

require('SDL.音效')
require('资源/base')

local snd = class('snd', 'SDL音效', 'base')

function snd:初始化(...)
    self:SDL音效(...)
end

return snd
