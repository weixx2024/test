function 界面层:初始化()
    self:置宽高(引擎.宽度, 引擎.高度)
    self.禁止滚动 = true
end

function 界面层:进入战斗()
    界面层.信息栏:置可见(false)
    界面层.队伍栏:置可见(false)
    界面层.任务栏:置可见(false)
    界面层.任务开关:置可见(false)

    界面层.状态栏.召唤控件:置坐标(0, 0)
    界面层.按钮栏.攻击按钮:置禁止(true)
    界面层.按钮栏.给予按钮:置禁止(true)
    界面层.按钮栏.交易按钮:置禁止(true)

    if __map.id == 101392 then
        界面层.帮战信息:置可见(false)
    end
end

function 界面层:退出战斗()
    界面层.信息栏:置可见(true)
    界面层.队伍栏:置可见(true)
    界面层.任务栏:置可见(true)
    界面层.任务开关:置可见(true)

    界面层.状态栏.召唤控件:置坐标(-239, 0)
    界面层.按钮栏.攻击按钮:置禁止(false)
    界面层.按钮栏.给予按钮:置禁止(false)
    界面层.按钮栏.交易按钮:置禁止(false)

    if __map.id == 101392 then
        界面层.帮战信息:置可见(true)
    end
end

function 界面层:左键弹起(cx, cy, x, y)
    if __自动寻路 then
        _G.__自动寻路 = false
        __自动任务:意外中断()
        界面层.任务栏.目标 = nil
        界面层.任务栏.任务列表.模糊路线 = nil
        if 地图层._定时_跳转切图 then
            地图层._定时_跳转切图.删除()
        end
    end
end

function 界面层:右键弹起(cx, cy, x, y)
    if __自动寻路 then
        _G.__自动寻路 = false
        __自动任务:意外中断()
        界面层.任务栏.目标 = nil
        界面层.任务栏.任务列表.模糊路线 = nil
        if 地图层._定时_跳转切图 then
            地图层._定时_跳转切图.删除()
        end
    end
end

return 界面层
