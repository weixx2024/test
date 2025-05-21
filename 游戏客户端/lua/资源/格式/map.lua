-- local SDL = require 'SDL'
local base = require('资源/base')
local map = class('map', base)
-- local mappath  = ''
local _遮罩 = require('地图/遮罩')

function map:初始化(path, len)
    local ud, info = require('gxy2.map')(path, len)
    -- mappath = path
    -- table.print(path)
    -- table.print(ud)
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
    self.mapcache = {}
    self.mskcache = {}
end

function map:更新()
    local r  = {  }

    if gge.platform ~= 'iOS' then
        r  = { self.ud:GetResult() }
    end

    local t = table.remove(r, 1)
    if t == 1 then
        local sf, mask, id = table.unpack(r)
        if self.地图遮罩 then
            for k, v in pairs(mask) do
                local mid = v.x .. '_' .. v.y

                if not self.mask[mid] then
                    local 遮罩 = _遮罩(v)
                    v.遮罩 = 遮罩
                    table.insert(self.maskco, v)
                    mask[k] = 遮罩
                    self.mask[mid] = 遮罩
                else
                    mask[k] = self.mask[mid]
                end
            end
        else
            mask = {}
        end
        coroutine.xpcall(self.mapco[id],
            require('SDL.精灵')(sf),
            mask
        )
        self.mapco[id] = nil
    elseif t == 2 then
        local sf, info = table.unpack(r)
        info.遮罩:置图像(sf)
    end

    if not next(self.mapco) and next(self.maskco) then
        local mask = table.remove(self.maskco, 1)
        self.ud:GetMask(mask, true)
    end
end

function map:取障碍()
    return self.ud:GetCell()
end

function map:取精灵(id, 地图遮罩)
    if self.mapcache[id] then
        return table.unpack(self.mapcache[id])
    end
    local co, main = coroutine.running()
    if not main then
        self.ud:GetMap(id, true)
        self.mapco[id] = co
        self.地图遮罩 = 地图遮罩
        self.mapcache[id] = {
            coroutine.yield()
        }
        return table.unpack(self.mapcache[id])
    end
end

function map:取精灵2(id, 地图遮罩)
    if self.mapcache[id] then
        return table.unpack(self.mapcache[id])
    end
    local sf, mask = self.ud:GetMap(id)
    self.地图遮罩 = 地图遮罩
    if 地图遮罩 and mask then
        for k, v in pairs(mask) do
            local mid = v.x .. '_' .. v.y
            if not self.mask[mid] then
                local 遮罩 = _遮罩(v)
                v.遮罩 = 遮罩
                table.insert(self.maskco, v)
                mask[k] = 遮罩
                self.mask[mid] = 遮罩
            else
                mask[k] = self.mask[mid]
            end
        end
    else
        mask = {}
    end
    if sf then
       
        self.mapcache[id] = {
            require('SDL.精灵')(sf),
            mask,
        }
        return table.unpack(self.mapcache[id])
    end
end

function map:清空缓存()
    self.ud:Clear()
end

function map:不缓存()
    self.ud:SetMode(0x9527)
    return self
end
return map
