local _ENV = require('界面/窗口/作坊/作坊')
local 公式数据 = {
    { 名称 = '公式查询', '装备\n\n武器', "?", "?", "?", "?", "?" },
    { 名称 = '炼化', '装备\n\n武器', '内丹\n\n精华', '血玲珑', '九彩\n云龙\n珠', '九彩\n云龙\n珠', '九彩\n云龙\n珠', },
    { 名称 = '1-10级装备生产锻造', '装备\n\n武器', '补天\n\n神石', '--', '--', '--', '--', },
    { 名称 = '11级装备生产锻造', '装备\n\n武器', '千年\n\n寒铁', '血玲珑', '巫铸\n\n材料', '--', '--', },
    { 名称 = '12级装备生产锻造', '11级\n\n武器', '天外\n\n飞石', '血玲珑', '巫铸\n\n材料', '--', '--', },
    { 名称 = '13级装备生产锻造', '12级\n\n武器', '盘古\n\n精铁', '血玲珑', '巫铸\n\n材料', '--', '--', },
    { 名称 = '14级装备生产锻造', '13级\n\n武器', '补天\n\n神石', '血玲珑', '巫铸\n\n材料', '--', '--', },
    -- { 名称 = '15级装备生产锻造', '14级\n\n武器', '六魂\n\n之玉', '血玲珑', '巫铸\n\n材料', '--', '--', },
    -- { 名称 = '16级装备生产锻造', '15级\n\n武器', '无量\n\n琉璃', '血玲珑', '巫铸\n\n材料', '--', '--', }
}

local _作坊部位 = {
    步摇坊 = "(帽子)",
    湛卢坊 = "(武器)",
    七巧坊 = "(衣服)",
    生莲坊 = "(鞋子)",
    同心坊 = "(项链)"
}
local _可生产 = {
    步摇坊 = "11~14级帽子",
    湛卢坊 = "11~14级武器",
    七巧坊 = "11~14级衣服",
    生莲坊 = "11~14级鞋子",
    同心坊 = "11~14级项链"
}


炼化装备区域 = 标签控件:创建区域(炼化装备按钮, 0, 0, 531, 541)
_保留属性 = false
local 作坊列表 = 炼化装备区域:创建多列列表('作坊列表', 22, 84, 157, 200)
do
    function 作坊列表:初始化()
        self:添加列(0, 2, 98, 20) --名称
        self:添加列(98, 1, 58, 20) --熟练度
    end

    function 作坊列表:添加作坊(t)
        local r = self:添加(t.名称 .. _作坊部位[t.名称], t.熟练度)
        r:置高度(20)
        r.t = t
    end

    function 作坊列表:左键弹起(x, y, i, t)
        t = t.t
        for k, v in pairs(t) do
            if ggetype(炼化装备区域[k]) == 'GUI文本' then
                炼化装备区域[k]:置文本(v)
            end
        end
        if _可生产[t.名称] then
            炼化装备区域.可生产:置文本(_可生产[t.名称])
        end
    end
end

for i, v in ipairs { '作坊主', '段位', '等级', '可生产', '熟练度', '成就' } do
    local 文本 = 炼化装备区域:创建文本(v, 83, 310 + i * 32 - 32, 96, 14)
end


for i, v in ipairs {
    { "现金", 248, 227, 96, 14 },
    { "体力", 248, 248, 96, 14 },
    { "好心值", 248, 268, 96, 14 },
    { "消耗金钱", 411, 227, 80, 14 },
    { "消耗体力", 411, 248, 80, 14 },
    { "消耗好心值", 424, 270, 66, 14 }
} do
    local 文本 = 炼化装备区域:创建文本(v[1] .. '标题', v[2] - __res.F14:取宽度(v[1]) - 5,
        table.unpack(v, 3))
    文本:置文本(v[1])
    文本:置宽度(80)
    local 文本 = 炼化装备区域:创建文本(table.unpack(v))
end
local 价值 = 炼化装备区域:创建文本('价值', 425, 190, 60, 20)
--价值:置文本('#Y价值:#W000')

local 提交按钮 = 炼化装备区域:创建小按钮("提交按钮", 430, 142, "?")
提交按钮:置禁止(true)
function 提交按钮:左键弹起()
    local list = {}
    for i, v in ipairs(炼化装备区域.提交网格.数据) do
        list[i] = v.nid
    end
    if self.文本 == "打造" then
        local r = __rpc:角色_高级装备打造(作坊列表.选中行, list, _nid)
        if type(r) == 'string' then
            窗口层:提示窗口(r)
        elseif type(r) == 'table' then
            _nid = nil
            炼化装备区域.道具网格:刷新道具()
            炼化装备区域.提交网格:清空()
            self:置禁止(true)
            炼化装备区域.现金:置文本(银两颜色(r[1]))
            炼化装备区域.体力:置文本(r[2])
            窗口层:提示窗口(r[3])
        end
    elseif self.文本 == "重铸" then
        local r = __rpc:角色_高级装备重铸(作坊列表.选中行, list, _nid)
        if type(r) == 'string' then
            窗口层:提示窗口(r)
        elseif type(r) == 'table' then
            _nid = nil
            炼化装备区域.道具网格:刷新道具()
            炼化装备区域.提交网格:清空()
            self:置禁止(true)
            炼化装备区域.现金:置文本(银两颜色(r[1]))
            炼化装备区域.体力:置文本(r[2])
            窗口层:提示窗口(r[3])
        end
    elseif self.文本 == "炼化" then
        local 来源, r, 银子, 体力, 原属性, 熟练度, 剩余次数, 提示 = __rpc:角色_装备炼化(作坊列表
            .选中行, list, _保留属性, _nid)
        --r新属性

        if not r and type(来源) == 'string' then
            窗口层:提示窗口(来源)
        elseif type(r) == 'table' then
            _nid = nil
            if _保留属性 and 原属性 then
                窗口层:关闭保留炼化窗口()
                窗口层:打开保留炼化窗口(来源, 原属性, r, 剩余次数)
            else --普通炼化
                窗口层:关闭普通炼化窗口()
                窗口层:打开普通炼化窗口(来源, r, 剩余次数)
            end
            炼化装备区域.道具网格:刷新道具()
            窗口层:提示窗口(提示)
            炼化装备区域.体力:置文本(体力)
            炼化装备区域.现金:置文本(银两颜色(银子))
            if 剩余次数 == 0 then
                炼化装备区域.提交网格:清空()
            end
        end
    end
end

local 保留文本 = 炼化装备区域:创建文本("保留文本", 445, 170, 80, 14)
保留文本:置文字(__res.F12)
--保留文本:置文本("")
--保留文本:置可见(false)

local 保留按钮 = 炼化装备区域:创建我的多选按钮("保留按钮", 425, 170)
function 保留按钮:初始化()
    local tcp = __res:get('gires4/smsj/yjan/dxk.tcp')
    self:置正常精灵(tcp:取精灵(1):置中心(0, 0))
    self:置选中正常精灵(tcp:取精灵(2):置中心(0, 0))
    self:置可见(false)
end

function 保留按钮:选中事件(x)
    _保留属性 = x
end

local 提交网格 = 炼化装备区域:创建提交网格('提交网格', 224, 95, 197, 128)
do
    function 提交网格:初始化()
        self:创建格子(53, 53, 13, 14, 2, 3)
    end

    function 提交网格:右键弹起(x, y, i)
        if self.数据[i] then
            self.数据[i] = nil
            提交按钮:置禁止(true)
            提交按钮:置文本('?')
            道具网格:获取数据()
        end
    end

    function 提交网格:左键弹起(x, y, i)
        if gge.platform ~= 'Windows' then
            self:右键弹起(x, y, i)
        end
    end

    function 提交网格:取已提交数量(nid)
        local n = 0
        for _, v in pairs(提交网格.数据) do
            if v.nid == nid then
                n = n + 1
            end
        end
        return n
    end
end

道具网格 = 炼化装备区域:创建物品网格2('道具网格', 190, 296, 309, 207)
function 道具网格:右键弹起(x, y, i)
    if self.数据[i] then
        if 提交网格:取已提交数量(self.数据[i].nid) >= self.数据[i].数量 then
            return
        end
        for n = 1, 6 do
            if not 提交网格.数据[n] then
                提交网格.数据[n] = self.数据[i]:镜像()
                self:获取数据(true)
                return
            end
        end
    end
end

function 道具网格:左键弹起(x, y, i)
    if gge.platform ~= 'Windows' then
        self:右键弹起(x, y, i)
    end
end

function 道具网格:获取数据()
    local list = {}
    for i, v in ipairs(提交网格.数据) do
        list[i] = v.nid
    end

    local r = __rpc:角色_炼化装备(作坊列表.选中行, list, _保留属性)
    if type(r) == 'table' then
        提交按钮:置禁止(false)
        提交按钮:置文本(r[1] and r[1] or "打造") --'打造'
        炼化装备区域.价值:置文本("#Y价值:#W" .. (r[2] or 0))
        炼化装备区域.消耗金钱:置文本(银两颜色(r[3] or 0))
        炼化装备区域.消耗体力:置文本(r[4] or 0)

        保留文本:置文本("")
        保留按钮:置可见(r[1] == "炼化")
        if r[1] == "炼化" then
            保留文本:置文本("保留属性")
        end
    else
        提交按钮:置禁止(true)
        提交按钮:置文本('?')

        炼化装备区域.价值:置文本("#Y价值:#W" .. 0)
        炼化装备区域.消耗金钱:置文本(银两颜色(0))
        炼化装备区域.消耗体力:置文本(0)

        if type(r) == 'string' then
            窗口层:提示窗口(r)
        end
    end
end

local 文本组合 = 炼化装备区域:创建文本组合("文本组合", 343, 68, 150, 20)

for i, v in ipairs(公式数据) do
    文本组合:添加(v.名称)
end

function 文本组合:选中事件(i)
    提交网格:清空()
    for i, v in ipairs(公式数据[i]) do
        local spr = __res.FAC:置颜色(0x99, 0x99, 0x99):取精灵(v)
        提交网格:置背景(i, spr:置中心(-(53 - spr.宽度) // 2, -(53 - spr.高度) // 2))
    end
end

function 炼化装备区域:可见事件(v)
    if not 炼化装备区域.是否实例 then
        return
    end
    文本组合:置文本('公式查询')
    文本组合:选中事件(1)

    道具网格:打开()
    local list, 现金, 体力, 好心值 = __rpc:角色_取作坊列表()
    炼化装备区域.现金:置文本(银两颜色(现金))
    炼化装备区域.体力:置文本(体力)
    炼化装备区域.好心值:置文本(好心值)
    if type(list) == 'table' then
        作坊列表:清空()
        for k, v in ipairs(list) do
            if v.名称 ~= "炼器坊" then
                作坊列表:添加作坊(v)
            end
        end
        if _秘籍 then
            作坊列表:置选中(_秘籍[1])
            if _可生产[_秘籍[2]] then
                炼化装备区域.可生产:置文本(_可生产[_秘籍[2]])
            end
            for i, v in ipairs { '段位', '等级', '熟练度' } do
                炼化装备区域[v]:置文本(_秘籍[i + 3])
            end
        end
    end
end

function 窗口层:作坊再次炼化()
    提交按钮:左键弹起()
end
