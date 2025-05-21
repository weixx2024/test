

local GUI控件 = require('GUI.控件')

local 提示控件 = GUI:创建提示控件('提示控件', 0, 0)

local 文本 = 提示控件:创建我的文本('提示文本', 5, 5, 300, 300)

local function 鼠标提示(self, x, y, t)
    local w, h = 文本:置文本(t)
    提示控件:置精灵(self:取拉伸精灵_宽高('gires4/jdmh/yjan/tmk2.tcp', w + 10, h + 10), true) --替换宽高
    if x + 提示控件.宽度 > 引擎.宽度 then
        x = 引擎.宽度 - 提示控件.宽度
    end
    if y - h - 10 < 0 then
        y = h + 10
    end
    提示控件:置坐标(x, y - h - 10)
    提示控件:置可见(true)
end

function GUI控件:置提示(txt, ...)
    if select('#', ...) > 0 then
        txt = txt:format(...)
    end
    self:注册事件(
        self,
        {
            获得鼠标 = function(_, x, y)
                鼠标提示(self, x, y, txt)
                if ggetype(self) == 'GUI按钮' then
                    鼠标层:手指形状()
                end
            end
        }
    )
end
return 提示控件
