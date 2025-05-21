

local 典当 = 窗口层:创建我的窗口('典当', 0, 0, 341, 435)
function 典当:初始化()
    self:置精灵(__res:getspr('gires/0x8101A54C.tcp'))
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
end

function 典当:显示(x, y)
end

典当:创建关闭按钮(0, 1)

local 典当按钮 = 典当:创建小按钮('典当按钮', 165, 390, '典当')
function 典当按钮:左键弹起()
end

function 窗口层:打开典当()
    典当:置可见(not 典当.是否可见)
    if not 典当.是否可见 then
        return
    end
    窗口层:打开赎回()
end

return 典当
