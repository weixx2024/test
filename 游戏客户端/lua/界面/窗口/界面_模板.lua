

local 模板窗口 = 窗口层:创建我的窗口('模板窗口', 0, 0, 500, 500)
function 模板窗口:初始化()
    self:置精灵(
        self:取经典红木窗口(
            self.宽度,
            self.高度,
            '模板窗口',
            function()
                __res:getsf('gires4/jdmh/yjan/dxk2.tcp'):显示(33, 476)
            end
        )
    )
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

