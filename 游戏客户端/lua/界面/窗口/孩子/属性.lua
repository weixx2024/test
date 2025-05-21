local 技能描述 = require('数据/孩子').技能描述
local 整数范围 = require('数据/孩子').整数范围
local 取孩子技能几率 = require('数据/孩子').取孩子技能几率

local 孩子 = 窗口层:创建我的窗口('孩子', 0, 0, 396, 479)
do
    function 孩子:初始化()
        self:置精灵(
            生成精灵(
                396,
                479,
                function()
                    __res:getsf('ui/haizi.png'):显示(0, 0)
                    __res.F14:置颜色(1, 254, 3)
                    __res.F14:取图像("气质"):显示(18, 38)
                    __res.F14:取图像("悟性"):显示(18, 61)
                    __res.F14:取图像("智力"):显示(18, 84)
                    __res.F14:取图像("耐力"):显示(18, 106)
                    __res.F14:取图像("内力"):显示(18, 130)

                    __res.F14:取图像("亲密"):显示(95, 38)
                    __res.F14:取图像("孝心"):显示(95, 61)
                    __res.F14:取图像("疲劳"):显示(95, 84)
                    __res.F14:取图像("温饱"):显示(95, 106)
                    __res.F14:取图像("评价"):显示(95, 130)


                    __res.F14:置颜色(235, 242, 25)
                    __res.F14:取图像("乳名:"):显示(105, 165)
                    __res.F14:置颜色(255, 255, 255)
                end
            )
        )
        self:置坐标(10, (引擎.高度 - 515) // 2)
    end

    function 孩子:更新(dt)
        if self.动画 then
            self.动画:更新(dt)
        end
    end

    function 孩子:前显示(x, y)
        if self.动画 then
            self.动画:显示(x + 240 + 100, y + 180)
        end
    end

    function 孩子:置模型(t)
        self.动画 = require('对象/基类/动作') { 外形 = t.外形, 染色 = t.染色, 模型 = 'stand' }
        self.动画:置循环(true)
    end

    function 孩子:消息开始(v)
        if not 鼠标层.是否正常 then
            return true --拦截
        end
    end

    孩子:创建关闭按钮(0, 1)
end


do
    for i, v in ipairs {

        { name = '气质', x = 55, y = 38, k = 35, g = 15 },
        { name = '悟性', x = 55, y = 61, k = 35, g = 15 },
        { name = '智力', x = 55, y = 84, k = 35, g = 15 },
        { name = '耐力', x = 55, y = 106, k = 35, g = 15 },
        { name = '内力', x = 55, y = 130, k = 35, g = 15 },

        { name = '亲密', x = 140, y = 38, k = 35, g = 15 },
        { name = '孝心', x = 140, y = 61, k = 35, g = 15 },
        { name = '疲劳', x = 140, y = 81, k = 35, g = 15 },
        { name = '温饱', x = 140, y = 106, k = 35, g = 15 },
        { name = '评价', x = 140, y = 130, k = 35, g = 15 }

    } do
        local 文本 = 孩子:创建文本(v.name .. '文本', v.x, v.y, v.k, v.g)
        文本:置文字(__res.F14)
    end
end

local 名称输入 = 孩子:创建文本输入('孩子名称', 145, 165, 100, 18)
do
    名称输入:置文字(__res.F14:置颜色(255, 255, 255))
    名称输入:置颜色(0, 255, 0, 255)
    名称输入:置限制字数(14)
end

do
    local _状态转换 = { "婴儿", '儿童', '青年', '成年' }
    function 孩子:刷新属性(t)
        if type(t) == 'table' then
            for i, v in ipairs { '气质', '悟性', '智力', '耐力', '内力', '亲密', '孝心', '疲劳', '温饱', '评价', } do
                self[v .. '文本']:置文本("#G" .. t[v])
            end
            名称输入:置文本(t.名称)
            _数据 = t
            self:置模型(t)
        end
    end
end

--=======================================================================================
for k, v in pairs { '天资一', '天资二', '天资三' } do
    local 按钮 = 孩子:创建中按钮(v .. '按钮', 12, 165 + (k - 1) * 28, v, 85)
    function 按钮:左键弹起()
        if _数据 then
            if _数据.天资 then
                local 数值 = 取孩子技能几率(_数据.评价, _数据.亲密, _数据.孝心, _数据.天资[k])
                local 文本 = 技能描述[_数据.天资[k]]
                if _数据.天资[k] ~= '天真' and _数据.天资[k] ~= '淘气' and _数据.天资[k] ~= '好奇' then
                    if 整数范围[_数据.天资[k]] then
                        文本 = string.format(文本, math.floor(数值))
                    else
                        文本 = string.format(文本, string.format("%.2f", 数值))
                    end
                end
                窗口层:打开天资(文本)
            end
        end
    end
end

--=======================================================================================
local 装备网格 = 孩子:创建网格('装备网格', 248, 32, 135, 185)
do
    function 装备网格:初始化()
        self:添加格子(10, 10, 50, 50) --1帽子
        self:添加格子(10, 70, 50, 50) --2衣服
        self:添加格子(10, 126, 50, 50) --3鞋子
        self:添加格子(73, 10, 50, 50) --4武器
        self.数据 = {}
        self.记录格子 = 0
    end

    function 装备网格:子显示(x, y, i)
        if self.数据[i] then
            self.数据[i]:显示(x, y)
        end
    end

    function 装备网格:清空()
        for k, v in pairs(self.数据) do
            self.数据[k] = nil
        end
    end

    function 装备网格:获得鼠标(x, y, i)
        if self.记录格子 ~= i then
            self:清空请求记录(self.记录格子)
        end
        if not 鼠标层.附加 and self.数据 and self.数据[i] then
            if self.数据[i].nid then
                self:物品提示(x + 50, y + 50, self.数据[i]) --先显示缓存.
                if not self.数据[i].已请求 then
                    local r = __rpc:取物品描述(self.数据[i].nid)
                    if r and self.数据[i] then
                        self.数据[i].刷新显示 = true
                        self.数据[i].属性 = r
                        self:物品提示(x + 50, y + 50, self.数据[i])
                    end
                    self.数据[i].已请求 = true
                end
            elseif self.数据[i].名称 then --本地
                self:物品提示(x + 50, y + 50, self.数据[i])
            end
        end
        self.记录格子 = i
    end

    function 装备网格:清空请求记录(i)
        if self.数据 and self.数据[i] then
            self.数据[i].已请求 = nil
        end
    end

    function 装备网格:右键弹起(x, y, i)
        if self.数据[i] then
            if __rpc:孩子_脱下装备(_数据.nid, i) then
                self.数据[i] = nil
                孩子.道具网格:刷新道具()
            else
                窗口层:提示窗口('#R没有多余的空位。')
            end
        end
    end

    function 装备网格:左键弹起(x, y, i)
        if gge.platform ~= 'Windows' then
            self:右键弹起(x, y, i)
        end
    end
end

--=======================================================================================
local 孩子列表 = 孩子:创建列表('孩子列表', 173, 40, 60, 105)
do
    孩子列表:置选中精灵宽度(117)
    function 孩子列表:初始化()
        self:置文字(__res.F18:置颜色(255, 255, 255))
    end

    function 孩子列表:添加孩子(i, t)
        local 名称 = t.名称
        local r = self:添加(名称)
        r.nid = t.nid
        r.原名 = t.名称
    end

    function 孩子列表:左键弹起(x, y, i, t)
        local r = __rpc:孩子_取窗口属性(t.nid)
        if type(r) == 'table' then
            装备网格:清空()
            孩子:刷新属性(r)

            孩子.参战按钮:置选中(r.是否参战)

            if type(r.装备) == 'table' then
                for k, v in pairs(r.装备) do
                    require('界面/数据/物品')(v):到装备(装备网格.数据, k)
                end
            end
        end
    end
end

local 道具网格 = 孩子:创建物品网格2('道具网格', 34, 255, 305, 203)
do
    local 禁止精灵 = require('SDL.精灵')(0, 0, 0, 49, 49):置颜色(0, 0, 0, 180)
    function 道具网格:前显示2(x, y, i)
        if self.数据[i] and not self.数据[i].孩子是否可用 then
            禁止精灵:显示(x, y)
        end
    end

    function 道具网格:获取道具(p)
        return __rpc:角色_物品列表(p, true)
    end

    function 道具网格:右键弹起(x, y, i)
        local m = self.数据[i]
        if m and m.孩子是否可用 and _数据 then
            self:物品提示()
            local r, v = __rpc:孩子_物品使用(_数据.nid, m.I)
            if r == 1 and type(v) == 'table' then --更新
                m:刷新(v)
            elseif r == 2 then                    --删除
                m:删除()
                self.当前选中 = nil
            elseif r == 3 and type(v) == 'number' then --装备
                m:到装备(装备网格.数据, v)
            elseif type(r) == 'string' then
                窗口层:提示窗口(r)
            elseif type(v) == 'string' then
                窗口层:提示窗口(v)
            else
                窗口层:提示窗口('#R该物品无法使用。')
            end
        end
    end
end

local 参战按钮 = 孩子:创建我的多选按钮2('参战按钮', 100, 220, '参战', '休息')
do
    function 参战按钮:左键弹起()
        if _数据 then
            coroutine.xpcall(
                function()
                    local r = __rpc:孩子_参战(_数据.nid, not self.是否选中)

                    if type(r) == 'string' then
                        窗口层:提示窗口(r)
                        参战按钮:置选中(false)
                    elseif r == true then
                        for k, v in 孩子列表:遍历项目() do
                            孩子列表:置项目颜色(k, 255, 255, 255)
                        end
                        孩子列表:置项目颜色(孩子列表.选中行, 187, 165, 75)
                    end
                end
            )
        end
        return false
    end
end

local 使用按钮 = 孩子:创建小按钮('使用按钮', 100, 190, '使用', 85)
do
    function 使用按钮:左键弹起()
        道具网格:右键弹起(x, y, 道具网格.当前选中)
    end
end

local 更改名称按钮 = 孩子:创建中按钮('更改名称按钮', 150, 190, '更改乳名', 85)
do
    function 更改名称按钮:左键弹起()
        local 名称 = 名称输入:取文本()
        if not 名称 or not _数据 then
            return
        end

        if _数据.名称 == 名称 then
            窗口层:提示窗口('#Y我现在就叫这个名字呀')
            return
        end

        if require("数据/敏感词库")(名称, 1) then
            窗口层:提示窗口("#Y你的输入的名称包含敏感词汇！")
            return
        end

        if string.find(名称, "#") then
            窗口层:提示窗口("#Y你的输入的名称包含特殊符号！")
            return
        end

        local r = __rpc:孩子_更改乳名(_数据.nid, 名称)
        if type(r) == 'string' then
            窗口层:提示窗口(r)
        elseif r == true then
            窗口层:提示窗口('#Y改名成功！')
            孩子列表:置文本(孩子列表.选中行, 名称)
        end
    end
end

function 窗口层:打开孩子()
    孩子:置可见(not 孩子.是否可见)
    if not 孩子.是否可见 then
        return
    end
    道具网格:打开()
    self:重新打开孩子()
end

function 窗口层:重新打开孩子(nid)
    if nid then
        local t = __rpc:孩子_取窗口属性(nid)
        if t then
            孩子:刷新属性(t)
        end
        return
    end
    _数据 = nil
    名称输入:置文本('')
    孩子.动画 = nil
    孩子.参战按钮:置选中(false)
    孩子列表:清空()
    装备网格:清空()

    local list = __rpc:角色_打开孩子窗口()

    if type(list) ~= 'table' then
        return
    end
    时间排序(list)
    for i, v in ipairs(list) do
        孩子列表:添加孩子(i, v)
        if v.是否参战 then
            孩子列表:置项目颜色(i, 187, 165, 75)
            孩子列表:置选中(i)
        end
    end
end

function RPC:请求刷新孩子(nid)
    if 窗口层.孩子.是否可见 then
        窗口层:重新打开孩子(nid)
    end
end

return 孩子
