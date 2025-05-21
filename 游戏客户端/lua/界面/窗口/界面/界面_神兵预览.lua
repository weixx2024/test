local 神兵预览窗口 = 窗口层:创建我的窗口('神兵预览窗口', 0, 0, 600, 500)
local 物品库 = require("数据/物品库")
local function 取图标(name)
    if 物品库[name] then
        return 物品库[name].id, 物品库[name].desc
    end
    return 15774, "未知物品"
end

do
    function 神兵预览窗口:初始化()
        self:置精灵(
            self:取老红木窗口(
                self.宽度,
                self.高度,
                '神兵预览',
                function()
                    -- __res.JMZ:取图像('今日积分'):显示(30, 40)
                    self:取拉伸图像_宽高('ui/lbdk.png', 120, 450):显示(20, 40)
                    __res.JMZ:取图像('神兵名称'):显示(30, 42)
                    self:取拉伸图像_宽高('ui/lbdk.png', 120, 450):显示(150, 40)
                    __res.JMZ:取图像('属性列表'):显示(160, 42)
                    self:取拉伸图像_宽高('gires4/jdmh/yjan/tmk2.tcp', 310, 350):显示(280, 40)



                end
            )
        )
        self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
        self.禁止滚动 = true
    end

    function 神兵预览窗口:置图标(name)
        _神兵 = nil
        _属性 = nil
        self.提示文本:置文本("")
        self.图标 = nil
        if name then
            local id, desc = 取图标(name)
            self.图标 = __res:getspr('item/item120/%04d.png', id)
            if self.图标 then
                self.图标:置过滤(true)
            end
            local txt = string.format('#Y#F名称19:%s#r#W#F默认13:%s#r', name, desc)
            self.提示文本:置文本(txt)
        end

    end

    function 神兵预览窗口:显示(x, y)
        if self.图标 then
            self.图标:显示(x + 300, y + 70)
        end
    end

    神兵预览窗口:创建关闭按钮()
end



for i, v in ipairs {
    { name = "兑换1", txt = "兑换1级", x = 283, y = 405 },
    { name = "兑换2", txt = "兑换2级", x = 394, y = 405 },
    { name = "兑换3", txt = "兑换3级", x = 503, y = 405 },
    { name = "兑换4", txt = "兑换4级", x = 283, y = 450 },
    { name = "兑换5", txt = "兑换5级", x = 394, y = 450 },
    { name = "兑换6", txt = "兑换6级", x = 503, y = 450 },
} do
    local 按钮 = 神兵预览窗口:创建中按钮(v.name, v.x, v.y, v.txt, 85)

    function 按钮:左键弹起()
        if _神兵 and _属性 then

            coroutine.xpcall(
                function()
                    if 窗口层:确认窗口('你确定兑换#G%s#W级#R%s#W的该条属性么？#R请认真确认,兑换后无法更改！'
                        , i, _神兵) then
                        local r = __rpc:角色_兑换神兵(_神兵, _属性, i)
                        if type(r) == "string" then
                            窗口层:提示窗口(r)
                        elseif r == true then
                            self.父控件:置可见(false)
                        end
                    end
                end
            )


        else
            窗口层:提示窗口("#Y请先选中要兑换的神兵与对应属性")
        end



    end


end














local 提示文本 = 神兵预览窗口:创建文本('提示文本', 430, 55, 155, 330)
do
    提示文本.行间距 = 2
    提示文本:添加文字('名称', __res:getfont('simsun.ttc', 19, true):置颜色(255, 255, 115):置样式(SDL.TTF_STYLE_BOLD))
end




local 属性列表 = 神兵预览窗口:创建列表('属性列表', 155, 60, 115, 425)
do
    function 属性列表:初始化()
        self:置选中精灵宽度(90)
    end

    function 属性列表:添加属性(i, name)
        local r = self:添加("属性" .. i)
        r.神兵名称 = name
        r.属性序号 = i
    end

    function 属性列表:左键弹起(x, y, i, t)
        local r = __rpc:角色_获取神兵属性(t.神兵名称, t.属性序号)
        提示文本:置文本("")
        if type(r) == "table" then
            local 描述 = ""
            if 物品库[t.神兵名称] then
                描述 = 物品库[t.神兵名称].desc
            end

            if r.角色 and r.角色 ~= "nil" then
                描述 = 描述 .. "#r【装备角色】" .. r.角色
            end
            if r.属性要求 and r.属性要求.力量 and r.属性要求.力量 > 0 then
                描述 = 描述 .. "#r#Y力量要求 " .. r.属性要求.力量
            end
            if r.属性 then
                for i, v in ipairs(r.属性) do
                    描述 = 描述 .. "#r#Y" .. v.类型 .. " +" .. v.数值
                end
            end
            描述 = 描述 .. "#r#r#R注:此为1级基础属性,属性会根据兑换等级提升"
            local txt = string.format('#Y#F名称19:%s#r#W#F默认13:%s#r', t.神兵名称, 描述)
            提示文本:置文本(txt)
            _神兵 = t.神兵名称
            _属性 = t.属性序号
            for i = 1, 6, 1 do
                神兵预览窗口["兑换" .. i]:置禁止(false)
            end
        end
    end

    local 滚动条 = 属性列表:创建滚动条(属性列表.宽度 - 25, 0, 23, 425)

    local 滑块按钮 = 滚动条:创建滚动按钮(2, 20, 18, 425 - 36)
    function 滑块按钮:初始化(v)
        self:置正常精灵(self:取拉伸精灵_高度帧('gires4/jdmh/yjan/sgdk.tcp', 1, 30))
        self:置经过精灵(self:取拉伸精灵_高度帧('gires4/jdmh/yjan/sgdk.tcp', 1, 30))
        self:置按下精灵(self:取拉伸精灵_高度帧('gires4/jdmh/yjan/sgdk.tcp', 1, 30))
    end

    local 减少按钮 = 滚动条:创建减少按钮(2, 0)
    function 减少按钮:初始化(v)
        self:设置按钮精灵('gires/0x287AF2DA.tcp')
    end

    function 减少按钮:左键弹起(v)
        滚动条:置位置(滚动条._位置 - 40)
    end

    local 增加按钮 = 滚动条:创建增加按钮(2, -20)
    function 增加按钮:初始化(v)
        self:设置按钮精灵('gires/0x03539D9C.tcp')
    end

    function 增加按钮:左键弹起(v)
        滚动条:置位置(滚动条._位置 + 40)
    end

end




local 神兵列表 = 神兵预览窗口:创建列表('神兵列表', 25, 60, 90, 430)
do
    function 神兵列表:初始化()
        self:置文字(__res.F18:置颜色(255, 255, 255))

    end

    function 神兵列表:置神兵()
        for i, v in ipairs { '缚龙索', '混天绫', '盘古锤', '斩妖剑', '芭蕉扇', '索魂幡', '乾坤无定',
            '毁天灭地', '金箍棒', '宣花斧', '赤炼鬼爪', '震天戟', '搜魂钩', '多情环',
            '枯骨刀', '混元盘金锁', '锁子黄金甲', '五彩宝莲衣', '紫金七星冠', '凤翅瑶仙簪',
            '步定乾坤履', '藕丝步云履' } do --'八景灯',
            local r = self:添加(v)
            r.神兵名称 = v
        end
    end

    function 神兵列表:左键弹起(x, y, i, t)
        神兵预览窗口:置图标(t.神兵名称)
        for i = 1, 6, 1 do
            神兵预览窗口["兑换" .. i]:置禁止(true)
        end
        local r = __rpc:角色_获取神兵属性数量(t.神兵名称)
        if type(r) == "number" then
            if r > 0 then

                属性列表:清空()
                for i = 1, r, 1 do
                    属性列表:添加属性(i, t.神兵名称)
                end
            end
        end
    end
end




function 窗口层:打开神兵预览()
    神兵预览窗口:置可见(not 神兵预览窗口.是否可见)
    if not 神兵预览窗口.是否可见 then
        return
    end
    提示文本:置文本("")
    神兵预览窗口:置图标()
    属性列表:清空()
    神兵列表:清空()
    神兵列表:置神兵()
    for i = 1, 6, 1 do
        神兵预览窗口["兑换" .. i]:置禁止(true)
    end
end


return 神兵预览窗口
