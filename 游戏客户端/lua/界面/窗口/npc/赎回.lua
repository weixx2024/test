

local 赎回 = 窗口层:创建我的窗口('赎回', 0, 0, 341, 435)
function 赎回:初始化()
    self:置精灵(__res:getspr('gires/0x536F2D77.tcp'))
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
end

function 赎回:显示(x, y)
end

赎回:创建关闭按钮(0, 1)

local 赎回按钮 = 赎回:创建小按钮('赎回按钮', 165, 390, '赎回')
function 赎回按钮:左键弹起()
end

function 窗口层:打开赎回()
    赎回:置可见(not 赎回.是否可见)
    if not 赎回.是否可见 then
        return
    end
end

return 赎回
