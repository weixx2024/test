local 物品兑换 = 窗口层:创建我的窗口('物品兑换', 0, 0, 457, 450)
local 物品库 = require("数据/物品库")
local _选中
function 物品兑换:初始化()
    self:置精灵(__res:getspr('ui/wpdh.png'))
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
end

物品兑换:创建关闭按钮(0, 0)

local function 取图标(t)
    if t.图标 then
        return t.图标
    end
    if t.名称 and 物品库[t.名称] then
        return 物品库[t.名称].id
    end
    if t.id and 物品库[t.id] then
        return 物品库[t.id].id
    end
    return 15774
end

local function 取描述(t)
    if t.描述 then
        return t.描述
    end
    if t.名称 and 物品库[t.名称] then
        return 物品库[t.名称].desc
    end
    if t.id and 物品库[t.id] then
        return 物品库[t.id].desc
    end
    return '#R' .. t.名称 .. '是个未知物品,请联系管理员！'
end

-- local 兑换列表滑块 = 物品兑换:创建滑块('兑换列表滑块', 156, 150, 215, 18)
-- local 滑块按钮 = 兑换列表滑块:创建滑块按钮(0, 0, 215, 18)
local 消耗文本 = 物品兑换:创建文本('消耗文本', 75, 372, 87, 15)

--=======================================================================================
local 物品兑换列表 = 物品兑换:创建列表('物品兑换列表', 16, 68, 220, 290)
do
    function 物品兑换列表:初始化()
        __res.F16:置颜色(255, 255, 255)
        self:置文字(__res.F16)
        self.行间距 = 3
    end

    function 物品兑换列表:添加物品兑换(t)
        local r = self:添加("")
        r:置高度(55)
        r.t = t
        r:置精灵(
            生成精灵(
                220,
                55,
                function()
                    __res:getsf('item/item120/%04d.png', 取图标(t)):置拉伸(50, 50):显示(5, 2)
                    if t.数量 then
                        __res.F16:取图像(t.名称.."*"..t.数量):显示(70, 20)
                    else
                        __res.F16:取图像(t.名称):显示(70, 20)
                    end
                end
            )
        )
    end

    function 物品兑换列表:左键弹起(x, y, i, t)
        物品兑换.物品兑换要求列表:清空()
        _选中 = i
        for i,v in ipairs(t.t.要求) do
            setmetatable(v, { __index = 物品库[v.名称] })
            v.描述 = v.描述 or 取描述(v)
            物品兑换.物品兑换要求列表:添加物品兑换(v)
        end
        if t.t.要求.银子 then
            消耗文本:置文本(t.t.要求.银子)
        end
    end

    function 物品兑换列表:获得鼠标(x, y, i, t)
        self:物品提示(x, y, t.t)
    end

    local 列表上按钮 = 物品兑换:创建按钮('列表上按钮', 184+59, 66)
    function 列表上按钮:初始化()
        self:设置按钮精灵('gires/0x287AF2DA.tcp')
    end

    function 列表上按钮:左键弹起()
        物品兑换列表:向上滚动()
        物品兑换列表:自动滚动(false)
    end

    local 列表下按钮 = 物品兑换:创建按钮('列表下按钮', 184+59, 337)
    function 列表下按钮:初始化()
        self:设置按钮精灵('gires/0x03539D9C.tcp')
    end

    function 列表下按钮:左键弹起()
        if not 物品兑换列表:向下滚动() then
            物品兑换列表:自动滚动(true)
        end
    end

    

end



local 物品兑换要求列表 = 物品兑换:创建列表('物品兑换要求列表', 270, 68, 145, 290)
do
    function 物品兑换要求列表:初始化()
        __res.F14:置颜色(255, 255, 255)
        self:置文字(__res.F16)
        self.行间距 = 0
    end

    function 物品兑换要求列表:添加物品兑换(t)
        local r = self:添加("")
        r:置高度(45)
        r.t = t
        r:置精灵(
            生成精灵(
                220,
                45,
                function()
                    __res:getsf('item/item120/%04d.png', 取图标(t)):置拉伸(40, 40):显示(2, 2)
                    if t.数量 then
                        __res.F14:取图像(t.名称.."*"..t.数量):显示(45, 20)
                    else
                        __res.F14:取图像(t.名称):显示(45, 20)
                    end
                end
            )
        )
    end
    function 物品兑换要求列表:左键弹起(x, y, i, t)
   
       
    end

    function 物品兑换要求列表:获得鼠标(x, y, i, t)
        self:物品提示(x, y, t.t)
    end
end

local 确定按钮 = 物品兑换:创建中按钮("确定按钮", 300, 370, "确定兑换",85)

function 确定按钮:左键弹起()
    if _选中 then
        local t = __rpc:角色_兑换物品(_选中)
        窗口层:提示窗口(t)
    end
end

function 窗口层:打开物品兑换()
    物品兑换:置可见(not 物品兑换.是否可见)
    if not 物品兑换.是否可见 then
        return
    end
    self:重新打开物品兑换()
end

function 窗口层:重新打开物品兑换()
    local t = __rpc:角色_物品兑换()
    if type(t) == 'table' then
        
        local list={}
        for k, v in ipairs(t) do
            local r = 物品库[v.名称] 
            if r and r.区域 then
                v.排序 = r.区域 * 100 + r.位置
            else
                v.排序=1
            end
            table.insert( list, v )
        end

        table.sort( list, 
                function(a, b)
                    return a.排序 < b.排序
                end)
        物品兑换列表:清空()
        消耗文本:清空()
        物品兑换要求列表:清空()
        _选中 = nil
        for i, v in pairs(list) do
            setmetatable(v, { __index = 物品库[v.名称] })
            v.描述 = v.描述 or 取描述(v)
            物品兑换列表:添加物品兑换(v)
            if _选中 and v.nid == _选中.nid then
                _选中 = v
            end
        end
    end
end

return 物品兑换
