local 跳转 = class('跳转')

function 跳转:初始化(t)
    for k, v in pairs(t) do
        self[k] = v
    end

    if t.外形 == nil then
        self.动画 = __res:getani('mapani/change_point.tcp'):播放(true)
    end
    self.xy = require('GGE.坐标')(t.x, t.y)
    self.xy2 = require('GGE.坐标')(t.x - 50, t.y - 25)
    self.rect = require('SDL.矩形')(t.x - 50, t.y - 25, 100, 50)
    --:置中心(50,25)
    self.rect:置颜色(255, 255, 0)
    self.已发送 = true
end

function 跳转:更新(dt)
    if gge.isdebug and 引擎:取按键状态(SDL.KEY_F2) then
        return
    end
    if self.动画 then
        self.动画:更新(dt)
    end
    if __自动寻路 or __自动遇敌 then
        return
    end
    if self.rect:检查点(__rol.xy) then
        if not self.已发送 and (not __rol.是否组队 or __rol.是否队长) then
            __rol:停止移动()
            self.已发送 = true
            coroutine.xpcall(
                function()
                    __rpc:角色_地图跳转(self.nid)
                end
            )
        end
    elseif self.已发送 then
        self.已发送 = false
    end
end

function 跳转:显示(xy)
    if self.动画 then
        self.动画:显示(self.xy - xy)
    end
    if gge.isdebug then
        self.rect:显示(self.xy2 - xy)
    end
end

function 跳转:取排序点()
    return self.xy.y - 25
end

return 跳转
