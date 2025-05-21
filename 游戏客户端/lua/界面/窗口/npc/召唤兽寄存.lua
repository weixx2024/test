

local 召唤兽寄存 = 窗口层:创建我的窗口('召唤兽寄存', 0, 0, 511, 395)
local _消耗银子 = 0
function 召唤兽寄存:初始化()
    self:置精灵(__res:getspr('ui/zhsjc.png'))
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
end

function 召唤兽寄存:显示(x, y)
end

召唤兽寄存:创建关闭按钮()


local 银子文本 = 召唤兽寄存:创建文本('银子文本', 341, 108, 100, 15)
local 消耗文本 = 召唤兽寄存:创建文本('消耗文本', 143, 108, 100, 15)
local 召唤列表 = 召唤兽寄存:创建多列列表('召唤列表', 295, 162, 151, 145)
do
    function 召唤列表:初始化()
        self:置文字(self:取文字():置颜色(255, 255, 255, 255):置大小(16))
        self:添加列(0, 0, 85, 20) --召唤兽名称
        self:添加列(85, 0, 65, 20) --召唤兽等级
    end

    function 召唤列表:添加召唤(i, t)
        local r = self:添加(t.名称, t.转生 .. "转" .. t.等级 .. "级")
        r.nid = t.nid
    end

    function 召唤列表:左键弹起(x, y, i, t)
        _选择存入数据 = t
        local n = __rpc:角色_召唤仓库消耗(_选择存入数据.nid)
        if n then
          --  银子文本:置文本(银两颜色(yz or 0))
            消耗文本:置文本(银两颜色(n))
        end

    end

    召唤列表:创建我的滑块()
end



local 仓库列表 = 召唤兽寄存:创建多列列表('仓库列表', 44, 162, 151, 145)
do
    function 仓库列表:初始化()
        self:置文字(self:取文字():置颜色(255, 255, 255, 255):置大小(16))
        self:添加列(0, 0, 85, 20) --召唤兽名称
        self:添加列(85, 0, 65, 20) --召唤兽等级
    end

    function 仓库列表:添加召唤(i, t)
        local r = self:添加(t.名称, t.转生 .. "转" .. t.等级 .. "级")
        r.nid = t.nid
    end

    function 仓库列表:左键弹起(x, y, i, t)
        _选择取出数据 = t
    end

    仓库列表:创建我的滑块()
end




do
    local 取出按钮 = 召唤兽寄存:创建中按钮("取出按钮", 83, 325, "取  出", 85)



    function 取出按钮:左键弹起()
        if _选择取出数据 then
            local r = __rpc:角色_召唤仓库取出(_选择取出数据.nid)
            if r then
                召唤兽寄存:刷新列表()
            end
        end

    end

    local 存入按钮 = 召唤兽寄存:创建中按钮("存入按钮", 344, 325, "存  入", 85)



    function 存入按钮:左键弹起()
        if _选择存入数据 then
            local r = __rpc:角色_召唤仓库存入(_选择存入数据.nid)
            if r then
                召唤兽寄存:刷新列表()
            end
        end
    end

    local 交换按钮 = 召唤兽寄存:创建小按钮("交换按钮", 235, 265, "交换", 85)



    function 交换按钮:左键弹起()
        if _选择存入数据 and _选择取出数据 then
            local r = __rpc:角色_召唤仓库交换(_选择存入数据.nid, _选择取出数据.nid)
            if r then
                召唤兽寄存:刷新列表()
            end
        end
    end


end


function 召唤兽寄存:刷新列表()
    local list, list2, yz = __rpc:角色_召唤仓库列表()
    if type(list) ~= 'table' or type(list2) ~= 'table' then
        return
    end
    召唤列表:清空()
    仓库列表:清空()
    银子文本:置文本(银两颜色(yz or 0))
    消耗文本:置文本(银两颜色(0))
    时间排序(list2)
    时间排序(list)
    for i, v in ipairs(list2) do
        召唤列表:添加召唤(i, v)
    end
    for i, v in ipairs(list) do
        仓库列表:添加召唤(i, v)
    end



end

function 窗口层:打开召唤兽寄存()
    召唤兽寄存:置可见(not 召唤兽寄存.是否可见)
    if not 召唤兽寄存.是否可见 then
        return
    end


    local list, list2, yz = __rpc:角色_召唤仓库列表()
    if type(list) ~= 'table' or type(list2) ~= 'table' then
        return
    end
    银子文本:置文本(银两颜色(yz or 0))
    消耗文本:置文本(银两颜色(0))
    _消耗银子 = 0
    召唤列表:清空()
    仓库列表:清空()
    时间排序(list2)
    时间排序(list)
    -- table.print(list2)

    --  召唤数据 = list2
    for i, v in ipairs(list2) do
        召唤列表:添加召唤(i, v)
    end
    for i, v in ipairs(list) do
        仓库列表:添加召唤(i, v)
    end



end

--窗口层:打开召唤兽寄存()
return 召唤兽寄存
