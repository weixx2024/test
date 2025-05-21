local 还愿 = 窗口层:创建我的窗口('还愿', 0, 0, 341, 372)
function 还愿:初始化()
    self:置精灵(__res:getspr('gires/0x3D244210.tcp'))
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
end

function 还愿:显示(x, y)
end

还愿:创建关闭按钮()
local 消耗文本 = 还愿:创建文本('消耗文本', 222, 50, 87, 15)
local 银子文本 = 还愿:创建文本('银子文本', 222, 92, 87, 15)

--===============================================================================================
local 提交按钮 = 还愿:创建中按钮("确定按钮", 223, 120, "还  愿", 85)
提交按钮:置禁止(true)
function 提交按钮:左键弹起()
    local list = {}
    for i, v in ipairs(还愿.提交网格.数据) do
        list[i] = v.nid
    end
    local r = __rpc:角色_装备还愿(list)
    if type(r) == 'table' then
        还愿.道具网格:刷新道具()
        还愿.提交网格:清空()
        self:置禁止(true)
        消耗文本:置文本("")
        银子文本:置文本(银两颜色(r[1]))
        窗口层:提示窗口(r[2])
    elseif type(r) == 'string' then
        窗口层:提示窗口(r)
    end


end

local 提交网格 = 还愿:创建提交网格('提交网格', 35, 61, 158, 65)
do
    function 提交网格:初始化()
        self:添加格子(0, 0, 65, 65)
        self:添加格子(93, 0, 65, 65)
    end

    function 提交网格:右键弹起(x, y, i)
        if self.数据[i] then
            self.数据[i] = nil
            提交按钮:置禁止(true)
        end
    end
end

local 道具网格 = 还愿:创建物品网格2('道具网格', 18, 154, 305, 203)
do
    function 道具网格:左键弹起(x, y, i)
        if self.数据[i] then
            for k, v in pairs(提交网格.数据) do
                if v.nid == self.数据[i].nid then
                    return
                end
            end
            for n = 1, 2 do
                if not 提交网格.数据[n] then
                    提交网格.数据[n] = self.数据[i]
                    self:获取数据()
                    return
                end
            end
        end
    end

    function 道具网格:右键弹起(x, y, i)
        self:左键弹起(x, y, i)
    end

    function 道具网格:获取数据()
        local list = {}
        for i, v in ipairs(提交网格.数据) do
            list[i] = v.nid
        end
        local r = __rpc:角色_提交还愿材料(list)
        if type(r) == 'table' then
            提交按钮:置禁止(false)
            消耗文本:置文本(r[1] or 0)
        elseif type(r) == 'string' then
            窗口层:提示窗口(r)
        end
    end
end


function 窗口层:打开还愿窗口(n)
    
    还愿:置可见(not 还愿.是否可见)
    if not 还愿.是否可见 then
        return
    end
    提交网格:清空()
    道具网格:打开()
    还愿.银子文本:置文本(银两颜色(n))

end

return 还愿
