

local SDL = require 'SDL'

-- local callback = setmetatable({}, {__mode = 'v'})
-- local ue = --userevent
--     SDL.RegisterUserEvent(
--     function(code, ...)
--         code = code & 0xFFFFFFFF --转无符号
--         if callback[code] then
--             callback[code]:线程(...)
--         end
--     end
-- )

local map = class('map')

function map:初始化(path)
    -- local code = require('gxy2.hash')(tostring(self))
    -- callback[code] = self
   -- print(path)
    local ud, info = require('gxy2.map')(path, ue, code)

    self.ud = ud
    for k, v in pairs(info) do
        --  rownum;//行
        --  colnum;//列
        --  mapnum;//图块数量
        --  masknum;//遮罩数量
        --  width;//地图宽度
        --  height;//地图高度
        self[k] = v
    end
    self.mapco = {}
    self.maskco = {}
    self.mask = {}
end


function map:取遮罩(t)
    return self.ud:GetMask(t)
end
function map:线程(id, 地表)
    local sf = __res.th:取地表(id)
    local mask = {}
    地表[id] = { 精灵 = require('SDL.精灵')(sf), 遮罩 = mask }
    local maskinfo = self.ud:GetMaskInfo(id)
    for k, v in pairs(maskinfo) do
        local mid = v.x .. '_' .. v.y
        if not self.mask[mid] then
            v.sf = __res.th:取遮罩(v)
            mask[k] = require('地图/遮罩')(v)
            self.mask[mid] = mask[k]
        else
            mask[k] = self.mask[mid]
        end
    end
end
function map:取障碍()
    return self.ud:GetCell()
end

function map:取精灵(id)
    local sf = self.ud:GetMap(id)
    local maskinfo = self.ud:GetMaskInfo(id)
    local mask = {}
    for k, v in pairs(maskinfo) do
        local mid = v.x .. '_' .. v.y
        if not self.mask[mid] then
            v.sf = self.ud:GetMask(v)
            mask[k] = require('地图/遮罩')(v)
            self.mask[mid] = mask[k]
        else
            mask[k] = self.mask[mid]
        end
    end
    return {
        精灵 = require('SDL.精灵')(sf),
        遮罩 = mask
    }
end
-- function map:取精灵(id)
--     local co, main = coroutine.running()
--     if co and not main then
--         self.ud:GetMap(id, true)
--         self.mapco[id] = co
--         return coroutine.yield()
--     end
-- end
function map:取地表(id)
    return self.ud:GetMap(id)
end
function map:取精灵2(id)
    local sf, mask = self.ud:GetMap(id)
    return require('SDL.精灵')(sf)
end

function map:清空缓存()
    self.ud:Clear()
end

function map:不缓存()
    self.ud:SetMode(0x9527)
    return self
end
return map
