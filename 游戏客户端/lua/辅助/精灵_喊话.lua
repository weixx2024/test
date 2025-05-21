

local GUI = require '界面'
local 资源 = require('界面/资源')

local 冒泡精灵 = class('冒泡精灵')

function 冒泡精灵:初始化(str, dh, id, loop)
    self.文本 = require('GGE.文本')(100, 200)
    self.文本:置文字表(GUI.资源层.fonts)
    self.文本:置精灵表(GUI.资源层.emote)
    local w, h = self.文本:置文本(str)
    self.w = w + 10
  --  id=6
    if id then
         self.h = h + 40
        --  ['gires/common/chat/maopaok/2.tcp'] = { p1 = 20, p2 = 20, p3 = 20, p4 = 20 },
        --  ['gires/common/chat/maopaok/3.tcp'] = { p1 = 20, p2 = 20, p3 = 20, p4 = 20 },
        --  ['gires/common/chat/maopaok/4.tcp'] = { p1 = 20, p2 = 20, p3 = 20, p4 = 20 },
        --  ['gires/common/chat/maopaok/5.tcp'] = { p1 = 20, p2 = 20, p3 = 20, p4 = 20 },
        --  ['gires/common/chat/maopaok/6.tcp'] = { p1 = 20, p2 = 20, p3 = 20, p4 = 20 },
        self._spr = {
            资源.取拉伸精灵_宽高('gires/common/chat/maopaok/'.. id ..'.tcp',self.w+30 ,self.h):置中心(60, 0)--:播放(true):置区域(0, 0, 200, self.h),

        }
        self.文本:置中心((self.w - 30) // 2, -20)
    else
        self.h = h + 10
        self._spr = {资源.取拉伸精灵_宽高('ui/hhk.png', self.w, self.h):置中心(self.w // 2, 0)}
        self.文本:置中心((self.w - 10) // 2, -5)
    end
    self.y = dh
    --self.x = 0
    self.ty = 0
    self.dt = loop or 0
    self.a = 255
    self.up = 0
end

function 冒泡精灵:更新(dt)
    if self.a <= 0 then
        return
    end
    if self._spr[2] then
        for i, v in ipairs(self._spr) do
            v:更新(dt)
        end
    end

    self.文本:更新(dt)

    if self.dt ~= true then
        self.dt = self.dt + dt
        if self.dt > 9 and self.a > 0 then
            self.a = self.a - math.floor(dt * 300)
            if self.a < 0 then
                self.a = 0
            end
            for i, v in ipairs(self._spr) do
                v:置透明(self.a)
            end
            self.文本:置透明(self.a)
        end
    end

    if self.ty > self.y then
        self.up = self.up + dt * 60
        local up = math.floor(self.up)

        if up > 0 then
            self.up = self.up - up
            self.y = self.y + up
            if self.y > self.ty then
                self.y = self.ty
            end
        end
    end
end

function 冒泡精灵:显示(x, y)
    for i, v in ipairs(self._spr) do
        v:显示(x, y - self.y - self.h)
    end
    self.文本:显示(x, y - self.y - self.h)
end
--=====================================================
local 喊话精灵 = class('喊话精灵')

-- time < 9 喊话最多展示9秒  或者传递true 一直展示喊话
function 喊话精灵:初始化(h, time)
    self.h = h
    self.time = time
    self.shout = {}
end

function 喊话精灵:更新(dt)
    if self.shout[1] then
        for _, v in ipairs(self.shout) do
            v:更新(dt)
        end
        if self.shout[1].a == 0 then
            table.remove(self.shout, 1)
        end
    end
end

function 喊话精灵:显示(x, y)
    if not y and ggetype(x) == 'GGE坐标' then
        x, y = x:unpack()
    end

    for _, v in ipairs(self.shout) do
        v:显示(x, y)
    end
end

function 喊话精灵:添加(v, id)
    v = require("数据/敏感词库")(v)
    table.insert(self.shout, 冒泡精灵(v, self.h, id, self.time))
    local h = self.h
    for i = #self.shout, 1, -1 do
        local v = self.shout[i]
        v.ty = h
        h = h + v.h
        if h > 300 then --删除前面的
            v.dt = 9
        end
    end
end

return 喊话精灵
