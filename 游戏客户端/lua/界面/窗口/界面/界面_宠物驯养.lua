

local 驯养宠物 = 窗口层:创建我的窗口('驯养宠物', 0, 0, 319, 190)
function 驯养宠物:初始化()
    self:置精灵(__res:getspr('gires/0xD44E3F89.tcp'))
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
    self.动画=require('对象/基类/动作') {外形 = 4001, 模型 = 'stand'}--
end

function 驯养宠物:更新(dt)
    if self.动画 then
        self.动画:更新(dt)
    end
end
function 驯养宠物:显示(x, y)
    if self.动画 then
        self.动画:显示(x + 265, y+120)
    end
end

驯养宠物:创建关闭按钮(0, 1)



local 召唤列表 = 驯养宠物:创建列表('召唤列表', 25, 63, 153, 103)
do
    function 召唤列表:初始化()
        self:置文字(__res.F18)
    end

    function 召唤列表:添加召唤(i, t)
        local r = self:添加(t)
        r:取精灵():置中心(0, -2)
        r:置高度(20)
    end

    function 召唤列表:左键弹起(x, y, i, t)

    end
end
召唤列表:创建我的滑块()









function 窗口层:打开驯养宠物()
    驯养宠物:置可见(not 驯养宠物.是否可见)
    if not 驯养宠物.是否可见 then
        return
    end
end

return 驯养宠物
