
local 数据 = {}

function 数据:初始化()
end

function 数据:播放战斗(data, 自己)
    local t = table.remove(data, 1)
    local co = (coroutine.running())
    
    self.动画 = __res:getani('magic/1207.tca')
    if not self.动画 then
        return
    end
    战场层:添加技能(self)
    self.动画:播放():置帧率(1 / 20)
    local x, y = 战场层:取全屏位置(0)
    self.动画:置中心(-x - 50, -y)
    self._定时 = 引擎:定时(
        10,
        function()
            if not self.动画.是否播放 then
                coroutine.xpcall(co)
                return
            end
            return 10
        end
    )
    coroutine.yield()
    local 目标 = 战场层:取对象(t.目标)
    if not 目标 then
        窗口层:提示窗口('#Y该目标无法捕捉。')
        return 
    end
    if t.结果 then
        窗口层:提示窗口('#Y恭喜你获得了%s作为你的召唤曾，可要好好养它噢！', 目标.名称)
        战场层:删除对象(t.目标)
    else
        窗口层:提示窗口('#Y%s十分机灵地逃脱了你的捕捉法宝', 目标.名称)
    end
end

function 数据:更新(dt)
    self.动画:更新(dt)
    return not self.动画.是否播放
end

function 数据:显示(x, y)
    self.动画:显示(0, 0)
end

return 数据
