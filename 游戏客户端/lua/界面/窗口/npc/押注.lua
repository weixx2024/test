

local 押注窗口 = 窗口层:创建我的窗口('押注窗口', 0, 0, 263, 237)
function 押注窗口:初始化()
    self:置精灵(__res:getspr('gires/0x5911B3DD.tcp'))
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
end

function 押注窗口:显示(x, y)
end

押注窗口:创建关闭按钮(0, 1)

for k, v in pairs {
    '头彩',
    '七星',
    '双对',
    '三星'
} do
    local 按钮 = 押注窗口:创建小按钮(v .. '按钮', 20 + k * 60 - 60, 80, v)

    function 按钮:左键弹起()
    end
end

local 买定按钮 = 押注窗口:创建中按钮('买定按钮', 20, 185, '买定离手')

function 买定按钮:左键弹起()
end

local 离开按钮 = 押注窗口:创建中按钮('离开按钮', 161, 185, '离  开')

function 离开按钮:左键弹起()
end

function 窗口层:打开押注窗口()
    押注窗口:置可见(not 押注窗口.是否可见)
    if not 押注窗口.是否可见 then
        return
    end
end

return 押注窗口
