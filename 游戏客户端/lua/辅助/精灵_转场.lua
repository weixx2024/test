
local _w, _h = 引擎.宽度, 引擎.高度
local _w2, _h2 = 引擎.宽度2, 引擎.高度2
local tex

local 精灵转场 = class("精灵转场")

function 精灵转场:初始化()
    _w, _h = 引擎.宽度, 引擎.高度
    _w2, _h2 = 引擎.宽度2, 引擎.高度2
    tex = 引擎:截图到纹理(tex)
    self.mode = math.random(4)
    self.play = true
    self.spr = {}
    if self.mode == 1 then --切条随机向下
        local n = 1
        for x = 0, _w, 5 do
            self.spr[n]      = require("SDL.精灵")(tex, x, 0, 5, _h)
            self.spr[n].xy   = require("GGE.坐标")(x, 0)
            self.spr[n].toxy = require("GGE.坐标")(x, _h + 50)
            self.spr[n].dt   = math.random(40, 80) * 10
            n                = n + 1
        end
    elseif self.mode == 2 then --向右下角缩小
        self.spr[1] = require("SDL.精灵")(tex)
        self.spr[1].s = 1
    elseif self.mode == 3 then --透明渐变
        self.spr[1] = require("SDL.精灵")(tex)
        self.spr[1].a = 255
    elseif self.mode == 4 then --左右线横条移动
        for i = 1, _h do
            local y = i - 1
            self.spr[i] = require("SDL.精灵")(tex, 0, y, _w, 1)
            self.spr[i].xy = require("GGE.坐标")(0, y)
            self.spr[i].toxy = require("GGE.坐标")(i % 2 == 1 and -_w or _w, y)
        end
    end
end

function 精灵转场:更新(dt)
    if self.play then
        if self.mode == 1 then
            for _, v in ipairs(self.spr) do
                v.xy:移动(dt * v.dt, v.toxy)
            end
            for _, v in ipairs(self.spr) do
                if v.xy.y < _h then
                    return self
                end
            end
            self.play = false
        elseif self.mode == 2 then
            local spr = self.spr[1]
            spr.s = spr.s - dt
            spr:置缩放(spr.s)
            -- spr:置坐标(_w - spr.区域宽度, _h - spr.区域高度)
            self.play = spr.s > 0
        elseif self.mode == 3 then
            local spr = self.spr[1]
            spr.a = spr.a - dt * 500
            spr:置透明(spr.a)
            self.play = spr.a > 0
        elseif self.mode == 4 then
            for i, v in ipairs(self.spr) do
                v.xy:移动(dt * _w, v.toxy)
            end
            self.play = self.spr[1].xy.x > -_w
        elseif self.mode == 5 then

        end
        return self
    end
end

function 精灵转场:显示()
    if self.play then
        for i, v in ipairs(self.spr) do
            v:显示(v.xy)
        end
    end
end

return 精灵转场
