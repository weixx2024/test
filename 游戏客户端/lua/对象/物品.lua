

-- local SDL = require 'SDL'
-- local 鼠标 = require('鼠标')
--local 动作 = require('对象/基类/动作')


 local 物品 = class('地图物品')
-- 物品.模型表 = {'stand'}

function 物品:初始化(t)
    self.xy = require('GGE.坐标')(t.x, t.y)
    for k, v in pairs(t) do
        self[k] = v
    end
  --  os.remove(...)
    if t.外形  then
        self.动画 = __res:getani('goods/%4d.tca',t.外形):播放(true)
    end
    self.xy = require('GGE.坐标')(t.x, t.y)
    self.xy2 = require('GGE.坐标')(t.x - 50, t.y - 25)
    self.rect = require('SDL.矩形')(t.x - 50, t.y - 25, 100, 50)
end

function 物品:更新(dt)
    if self.动画 then
        self.动画:更新(dt)
    end
   -- self[动作]:更新(dt)
end

function 物品:显示(xy)
    if self.动画 then
        self.动画:显示(self.xy - xy)
    end
    -- if gge.isdebug then
    --     self.rect:显示(self.xy2 - xy)
    -- end
end

function 物品:取排序点()
    return self.xy.y
end
function 物品:检查透明(x, y)
    if self.动画 then
        return self.动画:检查透明(x, y)
    end
     -- self.rect
end
function 物品:消息事件(t)
    for _, v in ipairs(t.鼠标) do
        if v.type == SDL.MOUSE_DOWN then
            if self:检查透明(v.x, v.y) then
                v.type = nil
            end
        elseif v.type == SDL.MOUSE_UP then
            if self:检查透明(v.x, v.y) and v.button == SDL.BUTTON_LEFT then
                v.type = nil
                if 鼠标层.是否正常 then
                    coroutine.xpcall(function()
                        local r = __rpc:角色_地图物品(self.nid)
                    end)
                end
            end
        end
    end
end

return 物品
