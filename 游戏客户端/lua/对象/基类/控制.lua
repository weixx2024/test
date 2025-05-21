local function _角度算方向8(a)
    local r
    if (a > 157 and a < 203) then
        r = 6 --"左"
    elseif (a > 202 and a < 248) then
        r = 3 --"左上"
    elseif (a > 247 and a < 293) then
        r = 7 --"上"
    elseif (a > 292 and a < 338) then
        r = 4 --"右上"
    elseif (a > 337 or a < 24) then
        r = 8 --"右"
    elseif (a > 23 and a < 69) then
        r = 1 --"右下"
    elseif (a > 68 and a < 114) then
        r = 5 --"下"
    elseif (a > 113) then
        r = 2 --"左下"
    end
    return r, a
end

local 控制 = class('控制')

function 控制:初始化(t)
    self.xy = require('GGE.坐标')(t.x, t.y)
    self._txy = {}
    self.神行xy = {}
    self.移动速度 = 200
    self._co = {}
end

function 控制:更新(dt)
    if self.是否移动 then
        -- 判断神行符是否开启
        if self.神行符 then
            self:神行移动xy()
            -- if self.神行xy and self.神行 then
            --     if self.神行xy[10] then
            --         self.神行[1]:置透明(true, 120)
            --         self.神行[1]:置方向(self.方向)
            --         self.神行[1]:神行移动(self.神行xy[10], self._模式)
            --     end

            --     if self.神行xy[20] then
            --         self.神行[2]:置透明(true, 110)
            --         self.神行[2]:置方向(self.方向)
            --         self.神行[2]:神行移动(self.神行xy[10], self._模式)
            --     end

            --     if self.神行xy[30] then
            --         self.神行[3]:置透明(true, 100)
            --         self.神行[3]:置方向(self.方向)
            --         self.神行[3]:神行移动(self.神行xy[10], self._模式)
            --     end

            --     if self.神行xy[40] then
            --         self.神行[4]:置透明(true, 90)
            --         self.神行[4]:置方向(self.方向)
            --         self.神行[4]:神行移动(self.神行xy[10], self._模式)
            --     end

            --     if self.神行xy[50] then
            --         self.神行[5]:置透明(true, 80)
            --         self.神行[5]:置方向(self.方向)
            --         self.神行[5]:神行移动(self.神行xy[10], self._模式)
            --     end
            -- end
        end

        if self.队伍 then
            for i, v in pairs(self.队伍) do
                if self.xy:取距离(v.xy) > i * 30 then
                    v:队友移动(self.xy:取距离坐标(i * 30, self.xy:取弧度(v.xy)), self._模式)
                    v:置方向(self.方向)
                end
            end
        end

        local 移动速度 = self.移动速度 * dt
        if self._txy and self.xy:取距离(self._txy) > 移动速度 then
            self.xy:移动(移动速度, self._txy)
        elseif self._route and self._route:下一点() then -- 寻路
            self:开始移动(self._route:下一点(self.xy), self._模式)
        elseif self._txy and not self._wait then
            self.xy = self._txy:复制():floor()
            self._txy = nil
            self._route = nil
            self.是否移动 = false
            if self._next then
                self:置模型(self._next)
                self._next = nil
            end
            local co = self._co
            self._co = {}
            -- 调用的时候可能会添加，所以先清空
            for k, v in pairs(co) do
                coroutine.xpcall(v)
            end

            self:清空神行()
        else
            self.是否移动 = false
        end

        if self.队伍 and not self.是否移动 then
            for i, v in pairs(self.队伍) do
                v:开始移动(self.xy:取距离坐标(i * 15, self.xy:取弧度(v.xy)))
            end
        end
    else
        if self.模型 ~= 'stand' and self.模型 ~= 'up' and self.模型 ~= 'upkp' and self.模型 ~= 'upyd' and self.模型 ~= 'down' and self.模型 ~= 'downkp' and self.模型 ~= 'downyd' then
            self:置模型('stand')
        end
    end
end

function 控制:是否飞行()
    return false
end

function 控制:置坐标(x, y)
    if ggetype(x) == 'GGE坐标' then
        self.xy = x:复制():floor()
    else
        self.xy:pack(x, y)
    end
    self:停止移动()
    self.是否移动 = true
end

local _相邻方向 = {
    [1] = { [8] = true, [5] = true },
    [2] = { [5] = true, [6] = true },
    [3] = { [6] = true, [7] = true },
    [4] = { [7] = true, [8] = true },
    [5] = { [1] = true, [2] = true },
    [6] = { [2] = true, [3] = true },
    [7] = { [3] = true, [4] = true },
    [8] = { [4] = true, [1] = true },
}

function 控制:开始移动(txy, 模式) --被继承
    local 角度 = self.xy:取角度(txy)
    if self.方向 ~= _角度算方向8(角度) and _相邻方向[self.方向] and not _相邻方向[self.方向][_角度算方向8(角度)] then
        self:清空神行()
    end

    self:置方向(_角度算方向8(角度))

    self._txy = txy
    self._模式 = 模式

    local 模型
    if 模式 then
        模型 = 'walk'
        self.移动速度 = 95
    else
        模型 = 'run'
        self.移动速度 = 200
    end

    if self.神行符 then
        self.移动速度 = 300
    end
    -- if self.外形 > 5000 and self.外形 < 6000 then
    --     if 模型 == 'run' then
    --         模型 = "walk"
    --     end
    -- end
    -- print(v)
    if self.模型 ~= 模型 then
        self:置模型(模型)
    end
    self.是否移动 = true
    self._next = 'stand'
end

function 控制:停止移动()
    if self.模型 ~= 'stand' then
        self:置模型('stand')
    end
    self.是否移动 = false
    self._route = nil
    self._next = nil
    self._txy = nil
    self._co = {}
end

function 控制:路径移动(route, 模式) --寻路
    self._route = route
    self._模式 = 模式
    self:开始移动(route:下一点(self.xy), 模式)
end

function 控制:队友移动(txy, 模式)
    self._txy = txy

    local 模型
    if 模式 then
        模型 = 'walk'
        self.移动速度 = 95
    else
        模型 = 'run'
        self.移动速度 = 200
    end
    -- if self.外形 > 5000 and self.外形 < 6000 then
    --     if 模型 == 'run' then
    --         模型 = "walk"
    --     end
    -- end
    if not self:是否飞行() and self.模型 ~= 模型 then
        self:置模型(模型)
    end

    self.是否移动 = true
end

function 控制:神行移动xy(xy)
    if #self.神行xy >= 50 then
        table.remove(self.神行xy, 1)
    end

    table.insert(self.神行xy, self.xy)
end

function 控制:神行移动(txy, 模式)
    self._txy = txy

    local 模型
    if 模式 then
        模型 = 'walk'
    else
        模型 = 'run'
    end

    self.移动速度 = 300
    -- if self.外形 > 5000 and self.外形 < 6000 then
    --     if 模型 == 'run' then
    --         模型 = "walk"
    --     end
    -- end
    if not self:是否飞行() and self.模型 ~= 模型 then
        self:置模型(模型)
    end

    self.是否移动 = true
end

function 控制:清空神行()
    self.神行xy = {}
    if self.神行 then
        for i, v in pairs(self.神行) do
            v:置透明(true, 0)
            v:置坐标(self.xy.x, self.xy.y)
        end
    end
end

function 控制:动作_移动(txy, co)
    self._txy = txy
    local 角度 = self.xy:取角度(txy)
    self:置方向(_角度算方向8(角度))
    self:置模型('run')
    self.是否移动 = true
    self._next = 'stand'
    if type(co) == 'thread' then
        self._co[co] = co
        coroutine.yield()
    end
    return self
end

function 控制:动作_击退移动(txy, co) -- 不改变模型和方向
    self._txy = txy
    self.是否移动 = true
    if type(co) == 'thread' then
        self._co[co] = co
        coroutine.yield()
    end
end

function 控制:动作_快速移动(txy, co)
    self._txy = txy
    local 角度 = self.xy:取角度(txy)
    self:置方向(_角度算方向8(角度))
    self:置模型('rush')
    self.是否移动 = true
    self._next = 'guard'
    if type(co) == 'thread' then
        self._co[co] = co
        coroutine.yield()
    end
    return self
end



function 控制:动作_站立()
    self:置模型('stand')
    return self
end

-- function 控制:动作_站立2()
--     self:置模型('stand2')
--     self:置停止事件(
--         function()
--             self:置模型('stand')
--         end
--     )
--     return self
-- end

function 控制:动作_跑步()
    self:置模型('run')
    return self
end


function 控制:动作_物理攻击(func)
    self:置模型('attack')
    self._snd = __res:动作音效(self.原形, 'attack')
    if ggetype(self) == '战斗对象' then
        self:置停止事件(
            function()
                self:置模型('guard')
            end
        )
    end
    if func then
        self:置帧事件(func)
    end
    return self
end

function 控制:动作_法术攻击(func)
    self:置模型('magic')
    self._snd = __res:动作音效(self.原形, 'magic')

    if ggetype(self) == '战斗对象' then
        self:置停止事件(
            function()
                self:置模型('guard')
            end
        )
    end
    if func then
        self:置帧事件(func)
    end
    return self
end

function 控制:动作_死亡()
    self:置模型('die')
    self._snd = __res:动作音效(self.原形, 'die')
    self:置停止事件()
    self.是否死亡 = true
    return self
end

function 控制:动作_复活()
    self:置模型('guard')
    self.是否死亡 = nil
    return self
end

function 控制:动作_受击()
    self:置模型('hit')
    self._snd = __res:动作音效(self.原形, 'hit')
    if ggetype(self) == '战斗对象' then
        self:置停止事件(
            function()
                self:置模型('guard')
            end
        )
    end
    return self
end

function 控制:动作_防御()
    self:置模型('defend')
    self._snd = __res:动作音效(self.原形, 'defend')
    if ggetype(self) == '战斗对象' then
        self:置停止事件(
            function()
                self:置模型('guard')
            end
        )
    end
    return self
end

function 控制:动作_防备()
    self:置模型('guard')
    -- self._snd = __res:动作音效(self.原形,'guard')
    return self
end

function 控制:动作_逃跑(方向)
    self:置模型('run')
    -- :置帧率(1/30)
    self:置方向(方向 == 1 and 3 or 1)

    return self
end

return 控制
