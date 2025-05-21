local 动作 = require('对象/基类/动作')
local 控制 = require('对象/基类/战斗控制')
local 状态 = require('对象/基类/状态')

local 数据 = require('战斗/基类/数据')
local 战斗对象 = class('战斗对象', 动作, 控制, 状态, 数据)
战斗对象.模型表 = { 'guard', 'attack', 'defend', 'die', 'hit', 'magic', 'rush',"rush_appear","rush_disappear" ,'attackc1-1','attackc1-2','attackc1-3','attackc1-4','attackc1-5', 'attackc2-1','attackc2-2','attackc2-3','attackc2-4','attackc2-5', 'attackc3-1','attackc3-2','attackc3-3','attackc3-4','attackc3-5',"attackb"}

function 战斗对象:初始化(t)
    for k, v in pairs(t) do
        self[k] = v
    end
    self:置隐身效果(self.隐身)
    if not t.名称颜色 or t.名称颜色 == 0 then
        self.名称颜色c = 16711935
        self:置名称颜色(0, 255, 0, 255)
    end
    self:动作_防备()
    if self.nid == __rol.nid then
        界面层:置人物气血(self.气血, self.最大气血)
    elseif 战场层.sum and self.nid == 战场层.sum.nid then
        界面层:置召唤气血(self.气血, self.最大气血)
    end
    if t.宝宝 then
        self.孩子 = require('战斗/孩子')(t.宝宝)
    end
    self.战斗标注 = __res:getani('mapani/change_point.tcp'):播放(true):置帧率(1 / 20) ---助战操作   
end

function 战斗对象:更新(dt)
    self[动作]:更新(dt)
    self[控制]:更新(dt)
    self[状态]:更新(dt)
    self[数据]:更新(dt)
    if self.孩子 then
        self.孩子:更新(dt)
    end
    if self.nid and 战场层.操作目标 and self.nid == 战场层.操作目标.nid then
        self.战斗标注:更新(dt)
    end
end

function 战斗对象:置隐身效果(v)
    if v then
        self[动作]:置颜色(30,60,60,60)
    else
        self[动作]:置颜色(250,nil,nil,nil)
    end
end

function 战斗对象:显示(xy)
    xy = self.xy
    self[状态]:显示底层(xy)
    self[数据]:显示底层(xy)
    self[动作]:显示(xy)
    self[动作]:特殊显示(self.tsxy)
    self[状态]:显示名称(xy)
    self[状态]:显示(xy)
    self[数据]:显示(xy)
    if self.孩子 then
        self.孩子:显示(xy)
    end
    if self.nid and 战场层.操作目标 and self.nid == 战场层.操作目标.nid then
        self.战斗标注:显示(xy)
    end
end

function 战斗对象:显示顶层(xy)
    xy = self.xy
    self[状态]:显示顶层(xy)
    self[数据]:显示顶层(xy)
end

function 战斗对象:取排序点()
    return self.xy.y
end

function 战斗对象:消息事件(t)
    if not t.鼠标 then
        return
    end
    for _, v in ipairs(t.鼠标) do
        if v.type == SDL.MOUSE_MOTION then
            local c = self:检查透明(v.x, v.y)
            if c then
                v.type = nil
                self:置高亮(true)
                self:置名称颜色(255, 0, 0, 255)
            elseif self.是否高亮 then
                self:置高亮(false)
                self:置名称颜色()
            end

            if 鼠标层.是否正常 or 鼠标层.是否攻击 then
                if c then
                    if 窗口层.人物菜单.是否可见 then
                        鼠标层:攻击形状(self.nid ~= 战场层.rol.nid)
                    elseif 窗口层.召唤菜单.是否可见 then
                        鼠标层:攻击形状((战场层.操作目标 and 战场层.操作目标.nid ~= self.nid) or (战场层.sum and self.nid ~= 战场层.sum.nid)) ---
                    end
                else
                    鼠标层:正常形状()
                end
            elseif 鼠标层.是否保护 then
                鼠标层:保护形状(self.是否己方 and c)
            elseif 鼠标层.是否捕捉 then
                鼠标层:捕捉形状(self.是否敌方 and c)
            elseif 鼠标层.是否道具 and 鼠标层.道具 then
                local m = 鼠标层.道具
                if not m.战斗是否可用 then
                    return
                end
                if c then
                    if self.是否敌方 and m.敌方是否可用 then
                        鼠标层:道具形状(true)
                    elseif not self.是否敌方 and m.己方是否可用 then
                        鼠标层:道具形状(true)
                    end
                else
                    鼠标层:道具形状()
                end
            elseif 鼠标层.是否法术 and 鼠标层.法术 then
                local m = 鼠标层.法术
                -- if not m.战斗是否可用 then
                --     return
                -- end
                if c then
                    if self.是否敌方 and m.敌方是否可用 then
                        鼠标层:法术形状(true)
                    elseif not self.是否敌方 and m.己方是否可用 then
                        鼠标层:法术形状(true)
                    end
                else
                    鼠标层:法术形状()
                end
            end
        elseif v.type == SDL.MOUSE_DOWN then
            if self:检查透明(v.x, v.y) then
                v.type = nil
            end
        elseif v.type == SDL.MOUSE_UP then
            if self:检查透明(v.x, v.y) and v.button == SDL.BUTTON_LEFT then
                v.type = nil
                if not 鼠标层.是否禁止 and 鼠标层.选择目标 then
                    鼠标层.选择目标(self)
                end
            end
        end
    end
end

return 战斗对象
