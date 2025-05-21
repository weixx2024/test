local _BUFF库 = require('数据/BUFF库')
local floor = math.floor
local _数字 = class('_数字')

local _伤害类型转换 = {
    "jian", "jia"
}
local _类型转换 = {
    致命 = "zm",
    狂暴 = "kb"
}


do
    function _数字:初始化(xy, n, p, tp,sl)
        self.xy = xy
        local pp = __res:get('gires2/ffs/tcp/00.pp')
        self.spr = {}
        local w = 0
        self.伤害类型 = 1
        n = floor (n)
        for v in string.format("%+d", n):reverse():gmatch('.') do
            if v == '-' or v == '+' then
                if v == '-' then
                    self.伤害类型 = 1
                else
                    self.伤害类型 = 2
                end
                v = __res:get('gires2/ffs/tcp/%s.tcp', _伤害类型转换[self.伤害类型])
            elseif #self.spr >= 4 then
                v = __res:get('gires2/ffs/tcp/d%d.tcp', v)
            else
                v = __res:get('gires2/ffs/tcp/x%d.tcp', v)
            end
            v:调色(pp, p)
            v = v:取精灵(1)
            w = w + v.宽度
            local x, y = v:取中心()
            v.x = x + w
            v.y = y + 50 - (sl or 0)*10
            table.insert(self.spr, 1, v)
        end

        if tp then
            local v = __res:get('gires2/ffs/tcp/%s.tcp', _类型转换[tp])
            if v then
                v = v:取精灵(1)
                w = w + v.宽度
                local x, y = v:取中心()
                v.x = x + w
                v.y = y + 50

                table.insert(self.spr, 1, v)
            end
        end
        w = w // 2
        for _, v in ipairs(self.spr) do --居中
            v.x = v.x - w
            v:置中心(v.x, v.y)
        end
        self.shou = true
    end

    function _数字:更新(dt)
        if self.shou then
            dt = dt * 50
            for _, v in ipairs(self.spr) do
                v.y = v.y + dt
                if v.y >= 100 then
                    self.shou = false
                end

                v:置中心(v.x, v.y)
            end
        else
            return true
        end
    end

    function _数字:显示()
        if self.shou then
            for _, v in ipairs(self.spr) do
                v:显示(self.xy)
            end
        end
    end
end





--==============================================================
local _状态条 = class('状态条')
do
    function _状态条:初始化(name)
        self.背景 = __res:getspr('addon/hp_empty.tcp')
        self.spr = __res:getspr('addon/%s.tcp', name)
    end

    function _状态条:置位置(a, b)
        if b then
            self.b = b
        end
        if a > self.b then
            self.spr:置区域(0, 0, 60, 6)
        else
            self.spr:置区域(0, 0, a / self.b * 60, 6)
        end
        return self
    end

    function _状态条:显示(xy)
        self.背景:显示(xy)
        self.spr:显示(xy)
    end

    function _状态条:置中心(x, y)
        self.背景:置中心(x, y)
        self.spr:置中心(x, y)
        return self
    end
end
--==============================================================
local unoperate = __res:getspr('addon/unoperate.tcp')
local 战斗状态 = class('战斗状态')

function 战斗状态:初始化(t)
    self._数字 = {}
    if type(t.buf) == 'table' then
        for i, v in ipairs(t.buf) do
            self:添加BUFF(v)
        end
    end

    -- if t.是否己方 or t.气血显示 then
        if t.气血 and t.最大气血 then
            self._血条 = _状态条('hp_full'):置位置(t.气血, t.最大气血):置中心(30, self:取高度() + 16)
        end
        if t.魔法 and t.最大魔法 and not t.是否机器人 then
            self._蓝条 = _状态条('mp_full'):置位置(t.魔法, t.最大魔法):置中心(30, self:取高度() + 10)
        end
    -- end
end

function 战斗状态:更新(dt)
    for i, v in ipairs(self._数字) do
        if v:更新(dt) then
            table.remove(self._数字, i)
            break
        end
    end
end

function 战斗状态:显示(xy)
    if self.是否敌方 and self._downani[2137] == nil and self._topani[2137] == nil then
        return
    end
    if self._血条 then
        self._血条:显示(xy)
        if self._等待 then
            local x, y = self._血条.spr:取中心()
            unoperate:显示(xy.x + -x - 14, xy.y + -y)
        end
    end
    if self._蓝条 then
        self._蓝条:显示(xy)
    end
end

function 战斗状态:显示顶层(xy)
    for i, v in ipairs(self._数字) do
        v:显示()
    end
end

function 战斗状态:添加红数字(v, 类型)
    v = math.abs(v)
    table.insert(self._数字, _数字(self.xy, -v, 0x01010101, 类型,#self._数字))
    if self._血条 then
        self.气血 = self.气血 - v
        if self.气血 < 0 then
            self.气血 = 0
        end
        self._血条:置位置(self.气血)
        if self.nid == __rol.nid then
            界面层:置人物气血(self.气血, self.最大气血)
        elseif 战场层.sum and self.nid == 战场层.sum.nid then
            界面层:置召唤气血(self.气血, self.最大气血)
        end
    end
end

function 战斗状态:添加绿数字(v, 类型)
    v = math.abs(v)
    table.insert(self._数字, _数字(self.xy, v, 0x02020202, 类型))
    if self._血条 then
        self.气血 = self.气血 + v
        if self.气血 > self.最大气血 then
            self.气血 = self.最大气血
        end
        self._血条:置位置(self.气血)

        if self.nid == __rol.nid then
            界面层:置人物气血(self.气血, self.最大气血)
        elseif 战场层.sum and self.nid == 战场层.sum.nid then
            界面层:置召唤气血(self.气血, self.最大气血)
        end
    end
end

function 战斗状态:增减蓝条(v, 类型)
    if 类型 == 2 then
        引擎:定时(
            200,
            function(ms)
                if v < 0 then
                    v = math.abs(v)
                    table.insert(self._数字, _数字(self.xy, -v, 0x03030303))
                    return
                else
                    v = math.abs(v)
                    table.insert(self._数字, _数字(self.xy, v, 0x03030303))
                    return
                end
            end
        )
    end
    if self._蓝条 then
        self.魔法 = self.魔法 + v
        if self.魔法 < 0 then
            self.魔法 = 0
        elseif self.魔法 > self.最大魔法 then
            self.魔法 = self.最大魔法
        end
        self._蓝条:置位置(self.魔法)
        if self.nid == __rol.nid then
            界面层:置人物魔法(self.魔法, self.最大魔法)
        elseif 战场层.sum and self.nid == 战场层.sum.nid then
            界面层:置召唤魔法(self.魔法, self.最大魔法)
        end
    end
end

function 战斗状态:增加蓝条(v, 类型)

end

function 战斗状态:减少蓝条(v, 类型)

end

function 战斗状态:置怨气(v)
    if self.nid == __rol.nid then
        战场层:置怨气(v)
    end
end

function 战斗状态:添加动画(v)
    local r = __res:getani('addon/%s.tca', v)
    if not r then
        r = __res:getani('addon/%s.tcp', v)
    end
    if r then
        __res:动画音效(v)
        self._topani[r] = r:播放():置帧率(1 / 20)
        return r
    end
end

function 战斗状态:添加M动画(v)
    local r = __res:getani('magic/%s.tca', v)
    if not r then
        r = __res:getani('magic/%s.tcp', v)
    end
    if r then
        __res:动画音效(v)
        self._topani[r] = r:播放():置帧率(1 / 20)
        return r
    end
end

function 战斗状态:删除动画(id)
    self._topani[id] = nil
end

function 战斗状态:添加BUFF(id)
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

function 战斗状态:删除BUFF(id)
    self._downani[id] = nil
    self._topani[id] = nil
end

function 战斗状态:置操作(v)
    self._等待 = v
end

function 战斗状态:孩子施法(v)
    self:置模型('magic')
    self._snd = __res:动作音效(self.原形, 'magic')
    if ggetype(self) == '战斗对象' then
        self:置停止事件(
            function()
                self:置模型('guard')
            end
        )
    end
end

return 战斗状态
