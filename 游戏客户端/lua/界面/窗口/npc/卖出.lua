


local 卖出 = 窗口层:创建我的窗口('卖出', 0, 0, 341, 435)
function 卖出:初始化()
    self:置精灵(__res:getspr('gires/0x4CA59966.tcp'))
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
end

function 卖出:显示(x, y)
end

卖出:创建关闭按钮(0, 1)

local 卖出按钮 = 卖出:创建小按钮('卖出按钮', 165, 390, '卖出')
function 卖出按钮:左键弹起()
end

function 窗口层:打开卖出()
    卖出:置可见(not 卖出.是否可见)
    if not 卖出.是否可见 then
        return
    end
end

return 卖出
