local 作坊窗口 = 窗口层:创建我的窗口('作坊窗口', 0, 0, 531, 541)
function 作坊窗口:初始化()
    self:置精灵(__res:getspr('ui/zf1.png'))
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
end

作坊窗口:创建关闭按钮()


标签控件 = 作坊窗口:创建标签('标签控件', 0, 0, 531, 541)

炼化装备按钮 = 标签控件:创建自定义小标签按钮('炼化装备按钮', 30, 35, '炼化装备', 90, 30)
function 炼化装备按钮:左键弹起()
    作坊窗口:置精灵(__res:getspr('ui/zf1.png'))
end

炼器按钮 = 标签控件:创建自定义小标签按钮('炼器按钮', 30 + 95, 35, '炼器', 90, 30)
function 炼器按钮:左键弹起()
    作坊窗口:置精灵(__res:getspr('ui/zf2.png'))
end


if __几种族 == 3.1 or __几种族 == 4.1 then
    炼化佩饰按钮 = 标签控件:创建自定义小标签按钮('炼化佩饰按钮', 30 + 95 * 2, 35, '炼化佩饰', 90, 30)
    function 炼化佩饰按钮:左键弹起()
        作坊窗口:置精灵(__res:getspr('ui/zf1.png'))
    end
end

function 窗口层:打开作坊窗口(nid, t)
    作坊窗口:置可见(not 作坊窗口.是否可见)
    if not 作坊窗口.是否可见 then
        return
    end
    _nid = nid
    _秘籍 = t
    炼化装备按钮:置选中(true)
    炼化装备按钮:左键弹起()
    -- 炼化装备区域:打开()
end

function RPC:作坊窗口(nid, t)
    窗口层:打开作坊窗口(nid, t)
end

return _ENV
