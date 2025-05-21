local SDL = require 'SDL'
local 窗口 =
引擎:创建窗口 {
    标题 = '大话西游2',
    宽度 = 370,
    高度 = 80,
    帧率 = 30,
    隐藏 = false,
    渲染器 = false,
    任务栏 = false
}

-- local loading = 窗口:创建图像(require('SDL.读写')(data, #data))
local _txt, _sf1, _sf2
if 窗口:渲染开始(240, 240, 240) then
    窗口:渲染结束()
end

function 窗口:置按钮(sf1, sf2)
    _sf1, _sf2 = sf1, sf2
    _sf1:置窗口(窗口)
end

function 窗口:置文本(sf)
    _txt = sf:置窗口(窗口)
    if 窗口:渲染开始(240, 240, 240) then
        sf:置颜色(0, 0, 0)
        _txt:显示((370 - sf.宽度) // 2, 20)
        if _sf1 then
            _sf1:显示((370 - _sf1.宽度) // 2, 50)
        end
        窗口:渲染结束()
    end
end

function 窗口:鼠标事件(msg, x, y)
    if msg == SDL.MOUSE_UP and _sf1 then
        if _sf1:检查点(x, y) then
            引擎:关闭()
        end
    end
end

return 窗口
