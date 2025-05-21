

local 神兵精炼窗口 = 窗口层:创建我的窗口('神兵精炼窗口', 0, 0, 341, 372)
function 神兵精炼窗口:初始化()
    self:置精灵(__res:getspr('gires/0x3D244210.tcp'))
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
end

function 神兵精炼窗口:显示(x, y)
end

神兵精炼窗口:创建关闭按钮()
local 消耗文本 = 神兵精炼窗口:创建文本('消耗文本', 222, 50, 87, 15)
local 银子文本 = 神兵精炼窗口:创建文本('银子文本', 222, 92, 87, 15)
local 保留文本 = 神兵精炼窗口:创建文本('保留文本', 45, 134, 80, 15)
保留文本:置文字(__res.F12)
保留文本:置文本("保留属性")
local 保留按钮 = 神兵精炼窗口:创建我的多选按钮("保留按钮", 25, 133)
function 保留按钮:初始化()
    local tcp = __res:get('gires4/smsj/yjan/dxk.tcp')
    self:置正常精灵(tcp:取精灵(1):置中心(0, 0))
    self:置选中正常精灵(tcp:取精灵(2):置中心(0, 0))
end

function 保留按钮:选中事件(x)
    _保留属性 = x
end
--===============================================================================================
local 提交按钮 = 神兵精炼窗口:创建中按钮("确定按钮", 223, 120, "精  炼", 85)
提交按钮:置禁止(true)
function 提交按钮:左键弹起()
    local list = {}
    for i, v in ipairs(神兵精炼窗口.提交网格.数据) do
        list[i] = v.nid
    end
    local 来源,r, 银子,  原属性 = __rpc:角色_神兵精炼(list,_保留属性)
    if type(r) == 'table' then
        if _保留属性 and 原属性 then
            窗口层:关闭保留炼化窗口()
            窗口层:打开保留炼化窗口( 来源,原属性,r)
        else--普通炼化
            窗口层:关闭普通炼化窗口()
            窗口层:打开普通炼化窗口(来源,r)
        end
        银子文本:置文本(银两颜色(银子) )
    elseif type(来源) == 'string' then
        窗口层:提示窗口(来源)
    end


end

local 提交网格 = 神兵精炼窗口:创建提交网格('提交网格', 35, 61, 158, 65)
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

local 道具网格 = 神兵精炼窗口:创建物品网格2('道具网格', 18, 154, 305, 203)
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
        local r = __rpc:角色_提交神兵精炼材料(list)
        if type(r) == 'table' then
            提交按钮:置禁止(false)
            消耗文本:置文本(r[1] or 0)
        elseif type(r) == 'string' then
            窗口层:提示窗口(r)
        end
    end
end






function 窗口层:打开神兵精炼窗口(n)
    神兵精炼窗口:置可见(not 神兵精炼窗口.是否可见)
    if not 神兵精炼窗口.是否可见 then
        return
    end
    提交网格:清空()
    道具网格:打开()

    神兵精炼窗口.银子文本:置文本(银两颜色(n))




end

function RPC:神兵精炼窗口(n)
    窗口层:打开神兵精炼窗口(n)
end
function 窗口层:再次神兵精炼()
    提交按钮:左键弹起()
end
return 神兵精炼窗口
