local 模板窗口 = 窗口层:创建我的窗口('模板窗口', 0, 0, 403, 406)
function 模板窗口:初始化()
    self:置精灵(__res:getspr('gires/0xC6175332.tcp'))
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
end

function 模板窗口:显示(x, y)
end

模板窗口:创建关闭按钮()

function 窗口层:打开模板窗口()
    模板窗口:置可见(not 模板窗口.是否可见)
    if not 模板窗口.是否可见 then
        return
    end
end

窗口层:打开模板窗口()
return 模板窗口
