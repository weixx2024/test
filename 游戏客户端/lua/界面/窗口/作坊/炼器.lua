local _ENV = require('界面/窗口/作坊/作坊')
local 公式数据 = {
    { 名称 = '公式查询', '装备\n\n武器', "?", "?", "?", "?" },
    { 名称 = '开光', '装备\n\n武器', "九玄\n\n仙玉", "--", "--", "--" },
    { 名称 = '炼器', '装备\n\n武器', "落魂\n\n砂", "--", "--", "神工\n\n笔录", }
}

炼器区域 = 标签控件:创建区域(炼器按钮, 0, 0, 531, 541)

local 作坊列表 = 炼器区域:创建我的文本('作坊列表', 22, 84, 157, 200)
作坊列表:置文字(__res.F14)
作坊列表:置文本('#F默认20:#G炼器坊#r#r#F默认14:#Y可生产：#r#W11~14级装备#r神兵') --#r仙器

for i, v in ipairs { '作坊主', '段位', '等级', '可生产', '熟练度', '成就' } do
    local 文本 = 炼器区域:创建文本(v, 83, 310 + i * 32 - 32, 96, 14)
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
    local 文本 = 炼器区域:创建文本(v[1] .. '标题', v[2] - __res.F14:取宽度(v[1]) - 5,
        table.unpack(v, 3))
    文本:置文本(v[1])
    文本:置宽度(80)
    local 文本 = 炼器区域:创建文本(table.unpack(v))
end

local 价值 = 炼器区域:创建文本('价值', 425, 190, 60, 20)
价值:置文本('#Y价值:')

-- =========提交
local 提交按钮 = 炼器区域:创建小按钮("确定按钮", 430, 142, "?")
提交按钮:置禁止(true)
function 提交按钮:左键弹起()
    local list = {}
    for i, v in ipairs(炼器区域.提交网格.数据) do
        list[i] = v.nid
    end
    if 炼器区域.提交网格.数据[5] then
        table.insert(list, 炼器区域.提交网格.数据[5].nid)
    end



    if self.文本 == "开光" then
        local r = __rpc:角色_装备开光(list)

        if type(r) == 'string' then
            窗口层:提示窗口(r)
        elseif type(r) == 'table' then
            炼化装备区域.道具网格:刷新道具()
            炼器区域.现金:置文本(银两颜色(r[1]))
            炼器区域.体力:置文本(r[2])
            窗口层:提示窗口(r[3])
        end
    elseif self.文本 == "炼器" then
        local 来源, r, 银子, 体力, 原属性 = __rpc:角色_装备炼器(list)
        if type(r) == 'string' then
            窗口层:提示窗口(r)
        elseif type(r) == 'table' then
            if 原属性 then
                窗口层:关闭保留炼化窗口()
                窗口层:打开保留炼化窗口(来源, 原属性, r)
            else --普通炼化
                窗口层:关闭普通炼化窗口()
                窗口层:打开普通炼化窗口(来源, r)
            end
            炼化装备区域.道具网格:刷新道具()
            炼器区域.现金:置文本(银两颜色(银子))
            炼器区域.体力:置文本(体力)
        end
    end
end

local 提交网格 = 炼器区域:创建提交网格('提交网格', 219, 90, 197, 128)
do
    function 提交网格:初始化()
        self:添加格子(6, 6, 53, 51)
        self:添加格子(72, 6, 53, 51)
        self:添加格子(6, 71, 53, 51)
        self:添加格子(72, 71, 53, 51)
        self:添加格子(139, 41, 53, 51)
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


local 道具网格 = 炼器区域:创建物品网格2('道具网格', 190, 296, 309, 207)
function 道具网格:右键弹起(x, y, i)
    if self.数据[i] then
        if 提交网格:取已提交数量(self.数据[i].nid) >= self.数据[i].数量 then
            return
        end
        if self.数据[i].名称 == "神功笔录" then
            if not 提交网格.数据[5] then
                提交网格.数据[5] = self.数据[i]:镜像()
                self:获取数据(true)
                return
            end
        else
            for n = 1, 4 do
                if not 提交网格.数据[n] then
                    提交网格.数据[n] = self.数据[i]:镜像()
                    self:获取数据(true)
                    return
                end
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
    if 提交网格.数据[5] then
        table.insert(list, 提交网格.数据[5].nid)
    end

    local r = __rpc:角色_炼器(list)
    if type(r) == 'table' then
        提交按钮:置禁止(false)
        提交按钮:置文本(r[1]) --'打造'
        炼器区域.价值:置文本("#Y价值:#W" .. (r[2] or 0))
        炼器区域.消耗金钱:置文本(r[3] or 0)
        炼器区域.消耗体力:置文本(r[4] or 0)
    elseif type(r) == 'string' and ts then
        窗口层:提示窗口(r)
    end
end

local 文本组合 = 炼器区域:创建文本组合("文本组合", 343, 68, 150, 20)
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

-- local 屏蔽控件 = 炼器区域:创建控件('屏蔽控件', 190, 65, 310, 440)
-- function 屏蔽控件:初始化()
--     self:置精灵(require('SDL.精灵')(0, 0, 0, 310, 440):置颜色(0,0,0,150))
-- end
-- local 屏蔽文本 = 炼器区域:创建我的文本('屏蔽文本', 220, 145, 235, 100)
-- 屏蔽文本:置文字(__res.F14)
-- 屏蔽文本:置文本('#Y你还没加入炼器坊，#r炼器坊需要一个以上炼化装备作坊#r达到七段后去皇宫#G#u作坊总管#u#Y处学习')


function 炼器区域:可见事件(v)
    if not 炼器区域.是否实例 then
        return
    end
    文本组合:置文本('公式查询')
    文本组合:选中事件(1)
    道具网格:打开()
    local list, 现金, 体力, 好心值 = __rpc:角色_取作坊列表()
    炼器区域.现金:置文本(银两颜色(现金))
    炼器区域.体力:置文本(体力)
    炼器区域.好心值:置文本(好心值)
end

function 窗口层:作坊再次炼器()
    提交按钮:左键弹起()
end
