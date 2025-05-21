

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

local 控制 = class('战斗控制')

function 控制:初始化(t)
    self.xy = require('GGE.坐标')(t.x, t.y)
    self.tsxy = {}
    self._txy = {}
    self.移动速度 = 200
    self._co = {}
end

function 控制:更新(dt)
    if self.是否移动 then
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
        elseif self._route and self._route:下一点() then --寻路
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
            --调用的时候可能会添加，所以先清空
            for k, v in pairs(co) do
                coroutine.xpcall(v)
            end
        else
            self.是否移动 = false
        end

        if self.队伍 and not self.是否移动 then
            for i, v in pairs(self.队伍) do
                v:开始移动(self.xy:取距离坐标(i * 15, self.xy:取弧度(v.xy)))
            end
        end
    elseif self.是否特殊移动 then
        local 移动速度 = self.移动速度 * dt
        for i,v in ipairs(self.tsxy) do
            if self._tstxy[i] and v:取距离(self._tstxy[i]) > 移动速度 then
                v:移动(移动速度, self._tstxy[i])
            elseif self._route and self._route:下一点() then --寻路
                self:开始移动(self._route:下一点(v), self._模式)
            elseif self._tstxy[i] and not self._wait then
                v = self._tstxy[i]:复制():floor()
                self._tstxy[i] = false
                local tg=true
                for n,_ in ipairs(self._tstxy) do
                    if _ then
                        tg=false
                        break
                    end
                end
                if tg then
                    self._route = nil
                    self.是否特殊移动 = false
                    local co = self._co
                    self._co = {}
                    --调用的时候可能会添加，所以先清空
                    for k, v in pairs(co) do
                        coroutine.xpcall(v)
                    end
                end
            end
        end
    elseif self.是否闪现 then
        if self._next then
             self.xy = self._txy:复制():floor()
             self._txy = nil
             self._route = nil
             self.是否闪现 = false
             self:置模型(self._next)
             self._next = nil
             local co = self._co
             self._co = {}
             --调用的时候可能会添加，所以先清空
             for k, v in pairs(co) do
                 coroutine.xpcall(v)
             end
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

function 控制:开始移动(txy, 模式) --被继承
    local 角度 = self.xy:取角度(txy)
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

    if not self:是否飞行() and self.模型 ~= 模型 then
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
    local 角度 = self.xy:取角度(txy)
    --self:置方向(_角度算方向8(角度))

    local 模型
    if 模式 then
        模型 = 'walk'
        self.移动速度 = 95
    else
        模型 = 'run'
        self.移动速度 = 200
    end

    if not self:是否飞行() and self.模型 ~= 模型 then
        self:置模型(模型)
    end

    self.是否移动 = true
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

function 控制:动作_击退移动(txy, co) --不改变模型和方向
    self._txy = txy
    self.是否移动 = true
    if type(co) == 'thread' then
        self._co[co] = co
        coroutine.yield()
    end
end

function 控制:动作_特殊移动(txy, co ,dz)
    self._txy = txy
    local 角度 = self.xy:取角度(txy)
    self:置方向(_角度算方向8(角度))
    self:置模型('rush_disappear')
    self.是否闪现 = true
    self._next = nil
    self:置停止事件(
        function()
            self:置模型(dz)
            self.xy.x = txy.x
            self.xy.y = txy.y
            self:置帧率(1 / 30)
            self:置停止事件(
                function()
                    self._next ='guard'
                end
            )
        end
    )
    self:置帧率(1 / 30)
    if type(co) == 'thread' then
        self._co[co] = co
        coroutine.yield()
    end
    return self
end

function 控制:动作_闪现移动(txy, co)
    self._txy = txy
    local 角度 = self.xy:取角度(txy)
    self:置方向(_角度算方向8(角度))
    self:置模型('rush')
	self.是否移动 = true
    self.xy.x = txy.x
    self.xy.y = txy.y
    self._next = 'guard'
    if type(co) == 'thread' then
        self._co[co] = co
        coroutine.yield()
    end
    return self
end

function 控制:动作_快速移动(txy, co)
    if self.actions["rush_disappear"] then
        local 动作 = 'guard'
        if self.actions["rush_appear"] then
            动作 = 'rush_appear'
        end
        return self:动作_特殊移动(txy, co ,动作)
    else
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
    end
    return self
end

function 控制:动作_暗影离魂移动(txy, co)
    self._tstxy = txy
    self:置特殊模型('rush',txy)
    self.模型 = "rush"
    for i,v in ipairs(txy) do
        self.tsxy[i] = require('GGE.坐标')(self.xy.x, self.xy.y)
        local 角度 = self.tsxy[i]:取角度(v)
        -- self:置特殊方向(_角度算方向8(角度),i)
    end
    self.是否特殊移动 = true
    if type(co) == 'thread' then
        self._co[co] = co
        coroutine.yield()
    end
    return self
end

function 控制:动作_暗影离魂攻击(位置)
    local sj = math.random(3)
    self:置特殊模型('attackc'..sj,位置)
    self._snd = __res:动作音效(self.原形, 'attack')
    self.模型 = "attack"
    self:置特殊停止事件(
        function()
            self:置模型('guard')
            self:置特殊模型()
            self.模型 = "guard"
            -- self:置特殊模型('attackc2',位置)
            -- self:置特殊停止事件(
            --     function()
            --         self:置特殊模型('attackc3',位置)
            --         self:置特殊停止事件(
            --             function()
            --                 self:置模型('guard')
            --                 self:置特殊模型()
            --                 self.模型 = "guard"
            --             end
            --         )
            --     end
            -- )
        end
    )
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

function 控制:动作_物理攻击(func,mx)
    self:置模型(mx or 'attack',self.原形)
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

function 控制:动作_二段物理攻击(func,mx,mx2)
    self:置模型(mx or 'attack')

    if ggetype(self) == '战斗对象' then
        self:置停止事件(
            function()
                self:置模型(mx2)
                self:置停止事件(
                        function()
                            self:置模型('guard')
                        end
                    )
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
    --self._snd = __res:动作音效(self.原形,'guard')
    return self
end

function 控制:切换造形(id)
    -- self.外形 = id
    -- self.原形 = id
    self:置外形(id)
    self:置模型('guard')
end

function 控制:动作_逃跑(方向)
    self:置模型('run')
    --:置帧率(1/30)
    self:置方向(方向 == 1 and 3 or 1)

    return self
end

return 控制
