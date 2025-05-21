

local 选择频道 = 窗口层:创建我的窗口('选择频道', 0, 0, 251, 281)
function 选择频道:初始化()
    self:置精灵(
        生成精灵(
            251,
            281,
            function()
                __res:getsf('ui/xzpd.png'):显示(0, 0)
                local t = __res.HYF:置颜色(187, 165, 75):取图像('选择频道')
                t:显示((self.宽度 - t.宽度) // 2, 3)
                __res.J18:取图像('当前'):显示(27, 57)
                __res.J18:取图像('帮派'):显示(27, 97)
                __res.J18:取图像('战斗'):显示(27, 137)
                -- __res.J18:取图像('弹幕'):显示(27, 177)

                __res.J18:取图像('队伍'):显示(145, 57)
                __res.J18:取图像('信息'):显示(145, 97)
                __res.J18:取图像('世界'):显示(145, 137)
                -- __res.J18:取图像('联盟'):显示(145, 177)
            end
        )
    )
end

选择频道:创建关闭按钮()

local 频道列表 = {}
for i, v in ipairs {
    {name = '当前开关', id = '66', x = 72, y = 53},
    {name = '帮派开关', id = '67', x = 72, y = 93},
    {name = '战斗开关', id = '115', x = 72, y = 133},
    --{name = '弹幕开关',id='', x = 72, y = 173},
    {name = '队伍开关', id = '65', x = 190, y = 53},
    {name = '信息开关', id = '114', x = 190, y = 93},
    {name = '世界开关', id = '69', x = 190, y = 133}
    --{name = '联盟开关',id='', x = 190, y = 173}
} do
    local 开关 = 选择频道:创建我的多选按钮(v.id, v.x, v.y)
    function 开关:选中事件(vv)
        选中[v.id] = vv
    end
    table.insert(频道列表, 开关)
end

local 保存按钮 = 选择频道:创建中按钮('保存按钮', 83, 230, '保存设置', 85)

function 保存按钮:左键弹起()
    选择频道:置可见(false)
    coroutine.resume(co, 选中)
end

function 窗口层:打开选择频道(t)
    选择频道:置可见(true)
    选择频道:置坐标((引擎.宽度 - 选择频道.宽度) // 2, (引擎.高度 - 选择频道.高度) // 2)


    选中 = {}
    for k, v in pairs(频道列表) do
        v:置选中(t == nil)
    end

    if t then
        for k, v in pairs(t) do
            选择频道[k]:置选中(v)
        end
    end
    co = coroutine.running()
    return coroutine.yield()
end

return 选择频道
