

local 寄售 = 窗口层:创建我的窗口('寄售', 0, 0, 341, 435)
function 寄售:初始化()
    self:置精灵(__res:getspr('gires/0x332DFD2A.tcp'))
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
end

function 寄售:显示(x, y)
end

寄售:创建关闭按钮(0, 1)

local 寄售按钮 = 寄售:创建小按钮('寄售按钮', 147, 390, '寄售')
function 寄售按钮:左键弹起()
end

function 窗口层:打开寄售()
    寄售:置可见(not 寄售.是否可见)
    if not 寄售.是否可见 then
        return
    end
end

return 寄售
