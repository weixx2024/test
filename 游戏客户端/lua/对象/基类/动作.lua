--控制对象各个动作

local 动作 = class('动作')
动作.模型表 = { 'stand', 'guard', 'run', 'attack', 'magic' } --'guard',--防御--attack攻击--魔法

function 动作:初始化(t)
    self.外形 = t.外形
    self.原形 = t.原形
    self.模型 = t.模型 or t.动作 or self.模型表[1]
    self.染色 = t.染色
    self.染色方案 = t.染色方案
    self.方向 = t.方向 or 1
    self:置外形(self.外形)
    self:置调色(self.染色)
    if t.是否死亡 then --是否已经死亡
        self:置模型('die')
        self:置尾帧()
    else
        self:置模型(self.模型)
    end
    self.rect = self:取精灵():取矩形()
end

function 动作:更新(dt)
    if self.cur_addon2 then
        self.cur_addon2:更新(dt, x, y)
    end
    if self.cur_addon then
        self.cur_addon:更新(dt, x, y)
    end
    if self.cur_action then
        self.cur_action:更新(dt, x, y)
    end
    if self.cur_attack then
        for i,v in pairs(self.cur_attack) do
            if v then
                v:更新(dt, x, y)
            end
        end
    end

    -- if self.cur_ride then
    --     self.cur_ride:更新(dt)
    -- end
end

function 动作:特殊显示(x, y)
    if self.cur_attack then
        for i,v in pairs(self.cur_attack) do
            if v then
                v:显示(x[i], y)
            end
        end
    end
end

function 动作:显示(x, y)
    -- if self.cur_ride then
    --     self.cur_ride:显示(x, y)
    -- end

    if self.cur_action then
        self.cur_action:显示(x, y)
        self.rect = self.cur_action:取精灵():取矩形()
    end
    if self.cur_addon then
        self.cur_addon:显示(x, y)
    end
    if self.cur_addon2 then
        self.cur_addon2:显示(x, y)
    end
end

local function loadtcp(tab, path, 外形, act)
    if tab[act] then
        return tab[act]
    end
    local tcp = __res:get(path, 外形, act)
    if tcp then
        tab[act] = require('对象/基类/动画')(tcp)
        return tab[act]
        -- else
        --     tcp = __res:get(path, 37, act)
        --     if tcp then
        --         tab[act] = require('对象/基类/动画')(tcp)
        --         return tab[act]
        --     end
    end
end

local function loadchar(list, tab, path, 外形) 
    for _, v in ipairs(list) do
        if loadtcp(tab, path, 外形, v) then
            if v == 'stand' or v == 'guard' or v == 'walk' or v == 'run' then
                tab[v]:置循环(true)
                if v == 'run' then
                    tab[v]:置帧率(1 / 13)
                end
            elseif v == 'die' then
                tab[v]:置往返(true)
            -- elseif v =='up' or v == 'upyd' or v == 'upkp' or v == 'down' or v == 'downyd' or v == 'downkp' then
            --     tab[v]:置循环(true)
            end
        elseif v == 'guard' then
            tab[v] = loadtcp(tab, path, 外形, 'stand')
            tab[v]:置循环(true)
        elseif v == 'magic' then
            tab[v] = loadtcp(tab, path, 外形, 'attack')
        elseif v == 'run' then
            if loadtcp(tab, path, 外形, 'rush') then
                tab[v] = tab['rush']
            elseif loadtcp(tab, path, 外形, 'walk') then
                tab[v] = tab['walk']
            end
            if tab[v] then
                tab[v]:置循环(true)
            end
        elseif v == 'die' then
            tab[v] = loadtcp(tab, path, 37, 'die')
        end
    end
end

function 动作:置外形(id)
    self.外形 = __res:getshapeid(id)
    -- zqtcp2( self.外形, self.模型)
    if not __res:check('shape/char/%04d/%s.tcp', self.外形, self.模型) and
        not __res:check('shape/char/%04d/stand.tcp', self.外形) then
        self.外形 = 37
    end
    if not self.原形 then
        self.原形 = self.外形
    end

    self.actions = {}
    self.addons = {}
    self.addons2 = {}
    loadchar(self.模型表, self.actions, 'shape/char/%04d/%s.tcp', self.外形)
    --  loadtcp(self.addons, 'shape/char/%04d/00/%s.tcp', self.外形, 'stand')
    if loadtcp(self.addons, 'shape/char/%04d/00/%s.tcp', self.外形, 'stand') then -- 分体模型
        loadchar(self.模型表, self.addons, 'shape/char/%04d/00/%s.tcp', self.外形)
    end
    if loadtcp(self.addons2, 'shape/char/%04d/01/%s.tcp', self.外形, 'stand') then -- 分体模型
        loadchar(self.模型表, self.addons2, 'shape/char/%04d/01/%s.tcp', self.外形)
    end
    -- if loadtcp(self.addons, 'shape/char/%04d/01/%s.tcp', self.外形, 'stand') then -- 分体模型
    --     loadchar(self.模型表, self.addons, 'shape/char/%04d/01/%s.tcp', self.外形)
    -- end
    self:置模型(self.模型)
    self:置方向(self.方向)
    self:置调色(self.染色, self.染色方案)
    return self
end

function 动作:置模型(v,原形) --换动作
    -- if self.外形 > 5000 and self.外形 < 6000 then
    --     if v == 'run' then
    --         v = "walk"
    --     end
    -- end
    if self.actions[v] then
        self.模型 = v
        self.cur_action = self.actions[v]
        self.cur_addon = self.addons[v]
        self.cur_addon2 = self.addons2[v]
        self:帧同步()
    end
end

function 动作:置特殊模型(v,sl)
    if self.actions[v] then --移动
        self.cur_attack = {}
        for i,x in pairs(sl) do
            self.cur_attack[i] = self.actions[v]
        end
    elseif v and sl then
        self.cur_attack = {}
        for i,x in pairs(sl) do
            self.cur_attack[i] = self.actions[v.."-"..i]
        end
        self:帧同步()
    elseif v  then
        self.cur_attack[v] = false
        self:帧同步()
    else
        self.cur_attack = nil
        self:帧同步()
    end
end

function 动作:置隐身(v)
    if v then
        for k, v in pairs(self.actions) do
            v:置颜色(200, 200, 200, 180)
        end
    else
        for k, v in pairs(self.actions) do
            v:置颜色()
        end
    end
end

function 动作:置透明(v, 透明度)
    if v then
        for k, v in pairs(self.actions) do
            v:置颜色(200, 200, 200, 透明度)
        end
    else
        for k, v in pairs(self.actions) do
            v:置颜色()
        end
    end
end

function 动作:置调色(p, 方案)
    if type(p) == 'number' and p > 0 then
        if not self.pp then
            if 方案 then
                self.pp = __res:get('shape/char/00.pp')
            else
                self.pp = __res:get('shape/char/%04d/00.pp', self.外形)
                if not self.pp then
                    self.pp = __res:get('shape/char/00.pp')
                end
            end
        end

        if self.pp then
            for k, v in pairs(self.actions) do
                v:调色(self.pp, p)
            end
            self:帧同步()
        end
    end
end

local function 置当前(self, k, ...)
    if self.cur_action then
        self.cur_action[k](self.cur_action, ...)
    end
    if self.cur_addon then
        self.cur_addon[k](self.cur_addon, ...)
    end
    if self.cur_addon2 then
        self.cur_addon2[k](self.cur_addon2, ...)
    end
    if self.cur_attack then
        for i,v in pairs(self.cur_attack) do
            if v then
                v[k](v, ...)
            end
        end
    end
    -- if self.cur_ride then
    --     self.cur_ride[k](self.cur_ride, ...)
    -- end
end

local function 置所有(self, k, ...)
    for _, v in pairs(self.actions) do
        v[k](v, ...)
    end
    for _, v in pairs(self.addons) do
        v[k](v, ...)
    end
    for _, v in pairs(self.addons2) do
        v[k](v, ...)
    end
    -- if self.rides then
    --     for _, v in pairs(self.rides) do
    --         v[k](v, ...)
    --     end
    -- end
    return self
end

function 动作:置方向(v, a)
    self.方向 = v
    置所有(self, '置方向', v, a)
end

function 动作:取方向()
    return self.方向
end

function 动作:取高亮()
    return self.cur_action and self.cur_action:取高亮()
end

function 动作:置高亮(...)
    self.是否高亮 = ...
    置所有(self, '置高亮', ...)
    return self
end

function 动作:置颜色(...)
    置所有(self, '置颜色', ...)
    return self
end

function 动作:帧同步()
    置当前(self, '置首帧')
    置当前(self, '播放')
    return self
end

function 动作:播放()
    置当前(self, '播放')
    return self
end

function 动作:暂停()
    置当前(self, '暂停')
    return self
end

function 动作:置首帧()
    置当前(self, '置首帧')
    return self
end

function 动作:置尾帧()
    置当前(self, '置尾帧')
    return self
end

function 动作:置循环(...)
    置当前(self, '置循环', ...)
    return self
end

function 动作:置特殊循环(i,cs)
    if self.cur_attack and self.cur_attack[i] then
        self.cur_attack[i]:置循环次数(cs)
    end
    return self
end

function 动作:置帧率(...)
    置当前(self, '置帧率', ...)
    return self
end

function 动作:置帧事件(v)
    if self.cur_action then
        self.cur_action:置帧事件(v)
    end
    return self
end

function 动作:置特殊帧事件(s,n)
    if self.cur_attack and self.cur_attack[n] then
        self.cur_attack[n]:置帧事件(s)
    end
    return self
end

function 动作:置停止事件(v)
    if self.cur_action then
        self.cur_action:置停止事件(v)
    end
    return self
end

function 动作:置特殊停止事件(s)
    if self.cur_attack then
        for i,v in pairs(self.cur_attack) do
            if v then
                v:置停止事件(s)
            end
        end
    end
    return self
end

function 动作:检查点(x, y)
    if self.cur_action and self.cur_action:检查点(x, y) then
        return true
    end
    -- if self.cur_ride and self.cur_ride:检查点(x, y) then
    --     return true
    -- end
end

function 动作:检查透明(x, y)
    local r = false
    if self.cur_action then
        r = self.cur_action:检查透明(x, y)
    end
    if not r and self.cur_addon then
        r = self.cur_addon:检查透明(x, y)
    end
    if not r and self.cur_addon2 then
        r = self.cur_addon2:检查透明(x, y)
    end
    return r
end

function 动作:取高度()
    return self.cur_action and self.cur_action.高度 or 0
end

function 动作:取宽度()
    return self.cur_action and self.cur_action.宽度 or 0
end

-- local function loadtcp(tab, path, 外形, act)
--     if tab[act] then
--         return tab[act]
--     end
--     local tcp = __res:get(path, 外形, act)
--     if tcp then
--         tab[act] = require('对象/基类/动画')(tcp)
--         return tab[act]
--     end
-- end

function 动作:取精灵()
    return self.cur_action and self.cur_action:取精灵() --or
end

return 动作
