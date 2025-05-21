

local 驯养召唤兽 = 窗口层:创建我的窗口('驯养召唤兽', 0, 0, 403, 406)
function 驯养召唤兽:初始化()
    self:置精灵(__res:getspr('gires/0xC6175332.tcp'))
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
end

function 驯养召唤兽:显示(x, y)
end

驯养召唤兽:创建关闭按钮(0, 1)

function 窗口层:打开驯养召唤兽()
    驯养召唤兽:置可见(not 驯养召唤兽.是否可见)
    if not 驯养召唤兽.是否可见 then
        return
    end
end

return 驯养召唤兽
