local GGF = require('GGE.函数')
local _BUFF库 = require('数据/BUFF库')
local SDL = require 'SDL'

local 状态 = class('状态')

function 状态:初始化(t)
    self:置名称(t.名称)
    self:置名称颜色(t.名称颜色)
    self:置称谓(t.称谓)
    self._addon = {}
    self._topani = {}
    self._downani = {} --bottom

    if type(t.状态) == 'table' then
        for k, v in pairs(t.状态) do
            self:置状态(k)
        end
    end
    if type(t.buf) == 'table' then
        for i, v in ipairs(t.buf) do
            if type(v) == 'number' then
                self:添加BUFF(v)
            elseif v == '隐身' then
                if self.置隐身效果 then
                    self.隐身 = true
                    self:置隐身效果(true)
                end
            end
        end
    end
    if t.是否队长 then
        self:置队长(true)
    elseif t.是否战斗 then
        self:置战斗(true)
    elseif t.是否观战 then
        self:置观战(true)
    elseif type(t.是否摆摊) == 'table' then
        self:置摆摊(table.unpack(t.是否摆摊))
    end
end

function 状态:更新(dt)
    if self._shout then
        self._shout:更新(dt)
    end
    if self._title and self._title.更新 then
        self._title:更新(dt)
    end
    for k, v in pairs(self._addon) do
        v:更新(dt)
    end
    for k, v in pairs(self._topani) do
        if v:更新(dt) then
            self._topani[k] = nil
        end
    end
    for k, v in pairs(self._downani) do
        if v:更新(dt) then
            self._downani[k] = nil
        end
    end
end

function 状态:显示底层(xy)
    for k, v in pairs(self._downani) do
        v:显示(xy)
    end
end

function 状态:显示(xy)
    for k, v in pairs(self._addon) do
        v:显示(xy)
    end
    for k, v in pairs(self._topani) do
        v:显示(xy)
    end
end

function 状态:显示名称(xy)
    if self._title then
        self._title:显示(xy)
    end
    if self._name then
        self._name:显示(xy)
    end
end

function 状态:显示顶层(xy)
    if self.store then --摆摊
        self.store:显示(xy)
    end
    if self._shout then
        self._shout:显示(xy) --喊话
    end
end

function 状态:置名称(v)
    if v then
        if self._namec then
            if type(self._namec) == "table" then
                __res.MCZ:置颜色(table.unpack(self._namec))
            elseif type(self._namec) == "number" then
                __res.MCZ:置颜色(GGF.itof(self._namec))
            end
        else
            __res.MCZ:置颜色(255, 255, 255, 255)
        end
        self._name = __res.MCZ:取投影精灵(v, 0, 0, 0, 120) --:置缩放(0.9)
        if self._title then
            self._name:置中心(self._name.宽度 // 2, -30)
        else
            self._name:置中心(self._name.宽度 // 2, -10)
        end
    end
end

function 状态:置名称颜色(r, g, b, a)
    if not r and not self._namec then
        self._namec = 16711935
        return
    end
    if not g then
        if not r then
            r = self._namec
        else
            self._namec = r
        end
        r, g, b, a = GGF.itof(r)
    end

    if self._name then
        if r == 0 and g == 0 and b == 0 and a== 0 then
            self._name:置颜色(0, 255, 0, 255) 
        else
            self._name:置颜色(r, g, b, a )
        end
        
    end
end

function 状态:置称谓(v)
    if v and v ~= '无' and v ~= '' then
        __res.MCZ:置颜色(128, 192, 255, 255)
        self._title = __res.MCZ:取投影精灵(v, 0, 0, 0, 120)
        self._title:置中心(self._title.宽度 // 2, -10)
        self._name:置中心(self._name.宽度 // 2, -30)
    else
        self._title = nil
        self._name:置中心(self._name.宽度 // 2, -10)
    end
end

function 状态:添加喊话(v, time)
    if not v or v == '' then
        return
    end
    if not self._shout then
        self._shout = require('辅助/精灵_喊话')(self:取高度(), time)
    end
    self._shout:添加(v)
end

function 状态:置状态(k, v)
    if v == false then
        self._addon[k] = nil
        return
    end
    self._addon[k] = __res:getani('addon/%s.tcp', k)
    if self._addon[k] then
        self._addon[k]:播放(true):置帧率(1 / 20):置中心(0, self:取高度())
    end
end

function 状态:添加BUFF(id)
    local r = __res:getani('effect/%04d.tca', id)
    if not r then
        r = __res:getani('effect/%04d.tcp', id)
    end
    if r then
        local 技能 = _BUFF库[id]
        local 帧率 = 20
        if 技能 then
            if 技能.状态层次 == 1 then
                self._downani[id] = r
            else
                self._topani[id] = r
            end
            if 技能.帧率 then
                帧率 = 技能.帧率
            end
        else
            self._topani[id] = r
        end
        __res:动画音效(id)
        r:播放(true)
        r:置帧率(1 / 帧率)
        r:置首帧()
        return r
    end
end

function 状态:置队长(v, 队友)
    self.是否队长 = v
    self:置状态('leader', v)
    if v then
        self.队伍 = {}
    elseif self.队伍 then
        for i, v in ipairs(self.队伍) do
            v.队长 = nil
        end
        self.队伍 = nil
    end
end

function 状态:置队友(list)
    if list and self.是否队长 and self.队伍 then
        for _, v in ipairs(self.队伍) do
            v.队长 = nil
        end
        self.队伍 = {}

        for i, v in ipairs(list) do
            local P = __map:取对象(v)
            if P then
                self.队伍[i] = P
                P.队长 = self.nid
            end
        end
    end
end

function 状态:置战斗(v)
    self.是否战斗 = v
    self:置状态('vs', v)
end

function 状态:置观战(v)
    self.是否观战 = v
    self:置状态('vs', v)
end

function 状态:置摆摊(摊名, 收购)
    self.是否摆摊 = 摊名 and true
    self.store = 摊名 and require('辅助/精灵_摊名')(摊名, 收购, self:取高度())
end

function 状态:添加特效(v)
    local r = __res:getani('addon/%s.tca', v)
    if not r then
        r = __res:getani('addon/%s.tcp', v)
    end
    if r then
        __res:动画音效(v)
        self._topani[r] = r:播放():置帧率(1 / 20)
        --:置中心(0,self:取高度()+10)
        return r
    end
end

function 状态:消息事件(t)
    if self.是否摆摊 and self.store then
        for _, v in ipairs(t.鼠标) do
            if v.type == SDL.MOUSE_MOTION then
                if self.store:检查点(v.x, v.y) then
                    v.type = nil
                    self.store:置高亮(true)
                else
                    self.store:置高亮(false)
                end
            elseif v.type == SDL.MOUSE_UP then
                if v.button == SDL.BUTTON_LEFT then
                    --v.clicks == 2
                    if self.store:检查点(v.x, v.y) then
                        v.type = nil
                        self.store:置灰色()
                        t.摆摊 = self
                    end
                    -- elseif v.button == SDL.BUTTON_RIGHT then
                    --     if self.store:检查点(v.x, v.y) then
                    --         v.type = nil
                    --     end
                end
            end
        end
    end
end

-- 帮战
function 状态:置底部状态(k, v)
    if v == false then
        self._topani[k] = nil
        return
    end
    self._topani[k] = __res:getani('addon/%s.tcp', k)
    if self._topani[k] then
        self._topani[k]:播放(true)
    end
end


return 状态
