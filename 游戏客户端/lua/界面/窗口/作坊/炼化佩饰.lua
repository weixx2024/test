local _ENV = require('界面/窗口/作坊/作坊')

_培养次数 = 1
_保留属性 = false

local 公式数据 = {
    { 名称 = '公式查询', '装备\n\n佩饰', "?", "?", "?", "?", "?" },
    -- { 名称 = '孔明灯合成', '需补充\n次数的\n孔明灯', '孔明灯', '孔明灯', '孔明灯', '孔明灯', '孔明灯', },
    { 名称 = '佩饰重炼', '可培养\n\n佩 饰', '六魂\n\n之玉', '血玲珑' , '九彩\n\n云龙珠', '九彩\n\n云龙珠', '九彩\n\n云龙珠' },
    { 名称 = '佩饰培养', '可培养\n\n佩 饰', '炼妖石\n\n宝 石', '--', '--', '--', '--', },
    { 名称 = '佩饰升级', '可培养\n\n佩 饰', '无量\n\n琉璃', '--', '--', '--', '--', },
    { 名称 = '护身符培养', '护身符', '护身符', '--', '--', '--', '--', },
    { 名称 = '护身符升级', '护身符', '无量\n\n琉璃', '血玲珑', '--', '--', '--', },
    { 名称 = '护身符重炼黄字', '护身符', '六魂\n\n之玉', '内丹\n\n精华', '--', '--', '--', },
    { 名称 = '护身符重炼绿字', '护身符', '六魂\n\n之玉', '血玲珑' , '九彩\n\n云龙珠', '九彩\n\n云龙珠', '九彩\n\n云龙珠' },
}

炼化佩饰区域 = 标签控件:创建区域(炼化佩饰按钮, 0, 0, 555, 506)

local 作坊列表 = 炼化佩饰区域:创建我的文本('作坊列表', 22, 84, 157, 200)
作坊列表:置文字(__res.F14)
作坊列表:置文本('#F默认20:#G清越坊#r#r#F默认14:#Y可生产：#r#W孔明灯#r不可培养佩饰#r可培养佩饰') --#r仙器

for i, v in ipairs { '作坊主', '段位', '等级', '可生产', '熟练度', '成就' } do
    local 文本 = 炼化佩饰区域:创建文本(v, 83, 310 + i * 32 - 32, 96, 14)
    文本:置文本("--")
end

for i, v in ipairs {
    { "现金", 248, 227, 96, 14 },
    { "体力", 248, 248, 96, 14 },
    { "好心值", 248, 268, 96, 14 },
    { "消耗金钱", 411, 227, 80, 14 },
    { "消耗体力", 411, 248, 80, 14 },
    { "消耗好心值", 424, 270, 66, 14 }
} do
    local 文本 = 炼化佩饰区域:创建文本(v[1] .. '标题', v[2] - __res.F14:取宽度(v[1]) - 5,
        table.unpack(v, 3))
    文本:置文本(v[1])
    文本:置宽度(80)
    local 文本 = 炼化佩饰区域:创建文本(table.unpack(v))
end

local 提交按钮 = 炼化佩饰区域:创建小按钮("提交按钮", 430, 142, "?", 60)
提交按钮:置禁止(true)
function 提交按钮:左键弹起()
    local list = {}
    for i, v in ipairs(炼化佩饰区域.提交网格.数据) do
        list[i] = v.nid
    end
    if self.文本 == "培养" then
        local r = __rpc:角色_佩饰培养(list, _培养次数)

        if type(r) == 'string' then
            窗口层:提示窗口(r)
        elseif type(r) == 'table' then
            炼化装备区域.道具网格:刷新道具()
            炼化佩饰区域.提交网格:清空()
            炼化佩饰区域.现金:置文本(银两颜色(r[1]))
            窗口层:提示窗口(r[2])
        end
        提交按钮:置禁止(true)
    elseif self.文本 == "升级" then
        local r = __rpc:角色_佩饰升级(list, _培养次数)

        if type(r) == 'string' then
            窗口层:提示窗口(r)
        elseif type(r) == 'table' then
            炼化装备区域.道具网格:刷新道具()
            炼化佩饰区域.提交网格:清空()
            炼化佩饰区域.现金:置文本(银两颜色(r[1]))
            窗口层:提示窗口(r[2])
        end
        提交按钮:置禁止(true)
    elseif self.文本 == "重炼" then
        local r = __rpc:角色_佩饰重炼(list)
        if type(r) == 'string' then
            窗口层:提示窗口(r)
        elseif type(r) == 'table' then
            炼化装备区域.道具网格:刷新道具()
            炼化佩饰区域.提交网格:清空()
            炼化佩饰区域.现金:置文本(银两颜色(r[1]))
            窗口层:提示窗口(r[2])
        end
        提交按钮:置禁止(true)
    end
end

local 提交网格 = 炼化佩饰区域:创建提交网格('提交网格', 224, 95, 197, 128)
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

道具网格 = 炼化佩饰区域:创建物品网格2('道具网格', 190, 296, 309, 207)
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

function 道具网格:获取数据(ts)
    local list = {}
    for i, v in ipairs(提交网格.数据) do
        list[i] = v.nid
    end
    local r = __rpc:角色_打造佩饰提交材料(list, _保留属性)
    if type(r) == 'table' then
        提交按钮:置禁止(false)
        提交按钮:置文本(r[1]) --'打造'
        炼化佩饰区域.消耗金钱:置文本(银两颜色(r[3] or 0))
        炼化佩饰区域.消耗体力:置文本(r[4] or 0)
    elseif type(r) == 'string' and ts then
        窗口层:提示窗口(r)
    end
end

local 文本组合 = 炼化佩饰区域:创建文本组合("文本组合", 343, 68, 150, 20)

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

local 次数文本 = 炼化佩饰区域:创建文本("次数文本", 415, 180, 96, 14)
次数文本:置文本("#Y次数")

local 次数文本组合 = 炼化佩饰区域:创建文本组合("次数文本组合", 445, 180, 50, 20)
for i, v in ipairs { "1次", "5次", "10次", "50次" } do
    次数文本组合:添加(v)
end
local _次数列表 = { 1, 5, 10, 50 }
function 次数文本组合:选中事件(i)
    _培养次数 = _次数列表[i]
end

次数文本组合:置文本('1次')
次数文本组合:选中事件(1)

function 炼化佩饰区域:可见事件(v)
    if not 炼化佩饰区域.是否实例 then
        return
    end
    文本组合:置文本('公式查询')
    文本组合:选中事件(1)

    道具网格:打开()
    local list, 现金, 体力, 好心值 = __rpc:角色_取作坊列表()
    炼化佩饰区域.现金:置文本(银两颜色(现金))
    炼化佩饰区域.体力:置文本(体力)
    炼化佩饰区域.好心值:置文本(好心值)
end

function 窗口层:作坊再次炼化()
    提交按钮:左键弹起()
end
