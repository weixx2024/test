

local 拆分窗口 = GUI:创建模态窗口('拆分窗口')
function 拆分窗口:初始化()
    self:置精灵(
        生成精灵(
            281,
            403,
            function()
                __res:getsf('ui/cf.png'):显示(0, 0)
                __res.JMZ:取图像('请输入拆分数量'):显示(10, 10)
            end
        )
    )
end

function 拆分窗口:可见事件(v)
    if not v then
        coroutine.resume(拆分窗口.co, false)
    end
end

local 输入 = 拆分窗口:创建数字输入('输入', 21, 42, 60, 18)
输入:置颜色(255, 255, 255, 255)
输入.最小值 = 1

local 增加按钮 = 拆分窗口:创建按钮('增加按钮', 100, 40)
do
    function 增加按钮:初始化()
        self:设置按钮精灵('gires/0xB6843921.tcp')
    end

    function 增加按钮:左键弹起()
        输入:置文本(输入:取数值() + 1)
    end
end

local 减少按钮 = 拆分窗口:创建按钮('减少按钮', 81, 40)
do
    function 减少按钮:初始化()
        self:设置按钮精灵('gires/0x8BD9DE87.tcp')
    end

    function 减少按钮:左键弹起()
        if 输入:取数值() > 1 then
            输入:置文本(输入:取数值() - 1)
        end
    end
end

local 确定按钮 = 拆分窗口:创建小按钮('确定按钮', 130, 37, '确定')
function 确定按钮:左键弹起()
    coroutine.resume(拆分窗口.co, 输入:取数值())
    拆分窗口:置可见(false)
end

function 窗口层:打开拆分窗口(n)
    拆分窗口:置可见(true)
    拆分窗口:置坐标((引擎.宽度 - 拆分窗口.宽度) // 2, (引擎.高度 - 拆分窗口.高度) // 2)

    拆分窗口.co = coroutine.running()
    输入:置焦点(true)
    输入.最大值 = n
    输入:清空()
    return coroutine.yield()
end

return 拆分窗口
