

local 提示控件 = GUI:创建提示控件('提示控件', 0, 0)

local 文本 = 提示控件:创建我的文本('提示文本', 5, 15, 300, 300)

local function 鼠标提示(self, x, y, t)
    local w, h = 文本:置文本(t)
    提示控件:置精灵(self:取拉伸精灵_宽高('gires/main/border.bmp', 窗口层.法术界面.宽度, h + 30),
        true) --替换宽高
    if x + 提示控件.宽度 > 引擎.宽度 then
        x = 引擎.宽度 - 提示控件.宽度
    end
    if y - h - 30 < 0 then
        y = h + 30
    end
    提示控件:置坐标(x, y - h - 30)
    提示控件:置可见(true)
end

function 鼠标层:技能提示(x, y, txt, ...)
    if not txt then
        return
    end
    if select('#', ...) > 0 then
        txt = txt:format(...)
    end

    鼠标提示(self, x, y, txt)
end

return 提示控件
