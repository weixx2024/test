﻿local 物品 = {
    名称 = '游侠盟锦囊',
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    禁止交易 = true,
    不可丢弃 = true,
    绑定 = true
}
function 物品:初始化()
    self.等级 = { 10, 0 }
    self.次数 = 1
end

--法术熟练度 有阶段指定阶段 没有阶段就是所有
local _奖励 = {
    [1] = {
        { 名称 = "师贡", 参数 = 1000000, 禁止交易 = true },
		{ 名称 = "大话币", 参数 = 100000, 禁止交易 = true },
        { 名称 = "法术熟练度", 参数 = 1000, 禁止交易 = true },
        { 名称 = "灵翼天香", 数量 = 200, 禁止交易 = true },
        { 名称 = "风水混元丹", 数量 = 200, 禁止交易 = true },
		{ 名称 = "守护自选卡", 数量 = 1, 禁止交易 = true },
        等级 = 10, 转生 = 0
    },

    [2] = {
        { 名称 = "师贡", 参数 = 1000000, 禁止交易 = true },
		{ 名称 = "大话币", 参数 = 100000, 禁止交易 = true },
        { 名称 = "法术熟练度", 参数 = 1000, 禁止交易 = true },
        { 名称 = "疏筋理气丸", 数量 = 1, 禁止交易 = true },
        { 名称 = "摄妖香", 数量 = 50, 禁止交易 = true },
        { 名称 = "藏宝图", 数量 = 1, 禁止交易 = true },
        等级 = 30, 转生 = 0
    },

    [3] = {
        { 名称 = "师贡", 参数 = 1000000, 禁止交易 = true },
        { 名称 = "法术熟练度", 参数 = 2000, 禁止交易 = true },
        { 名称 = "灵翼天香", 数量 = 200, 禁止交易 = true },
        { 名称 = "风水混元丹", 数量 = 200, 禁止交易 = true },
        { 名称 = "疏筋理气丸", 数量 = 1, 禁止交易 = true },
        等级 = 50, 转生 = 0
    },

    [4] = {
        { 名称 = "师贡", 参数 = 1000000, 禁止交易 = true },
        { 名称 = "法术熟练度", 参数 = 2000, 禁止交易 = true },
        { 名称 = "灵翼天香", 数量 = 200, 禁止交易 = true },
        { 名称 = "风水混元丹", 数量 = 200, 禁止交易 = true },
        { 名称 = "高级金柳露", 数量 = 1, 禁止交易 = true },
        等级 = 70, 转生 = 0
    },
    [5] = {
        { 名称 = "师贡", 参数 = 1000000, 禁止交易 = true },
        { 名称 = "法术熟练度", 参数 = 2000, 禁止交易 = true },
        { 名称 = "疏筋理气丸", 数量 = 1, 禁止交易 = true },
        { 名称 = "红雪散", 数量 = 20, 禁止交易 = true },
        { 名称 = "亲密丹", 数量 = 1, 参数 = 100000, 禁止交易 = true },
        { 名称 = "帮派成就册", 参数 = 1000, 数量 = 1, 禁止交易 = true },
        等级 = 102, 转生 = 0
    },
    [6] = {
        { 名称 = "师贡", 参数 = 2000000, 禁止交易 = true },
        { 名称 = "法术熟练度", 参数 = 1000, 禁止交易 = true },
        { 名称 = "血烟石", 数量 = 99, 禁止交易 = true },
        { 名称 = "千年灵花", 数量 = 99, 禁止交易 = true },
        { 名称 = "千年寒铁", 数量 = 1, 禁止交易 = true },
        { 名称 = "高级藏宝图", 数量 = 1, 禁止交易 = true },
        等级 = 20, 转生 = 1
    },
    [7] = {
        { 名称 = "师贡", 参数 = 2000000, 禁止交易 = true },
        { 名称 = "法术熟练度", 参数 = 1000, 禁止交易 = true },
        { 名称 = "血烟石", 数量 = 99, 禁止交易 = true },
        { 名称 = "天外飞石", 数量 = 1, 禁止交易 = true },
        { 名称 = "混元丹", 数量 = 1, 禁止交易 = true },
        等级 = 50, 转生 = 1
    },
    [8] = {
        { 名称 = "师贡", 参数 = 2000000, 禁止交易 = true },
        { 名称 = "法术熟练度", 参数 = 1000, 禁止交易 = true },
        { 名称 = "千年灵花", 数量 = 99, 禁止交易 = true },
        { 名称 = "盘古精铁", 数量 = 1, 禁止交易 = true },
        { 名称 = "九转易筋丸", 数量 = 1, 禁止交易 = true },
        等级 = 70, 转生 = 1
    },
    [9] = {
        { 名称 = "师贡", 参数 = 2000000, 禁止交易 = true },
        { 名称 = "法术熟练度", 参数 = 2000, 禁止交易 = true },
        { 名称 = "血烟石", 数量 = 99, 禁止交易 = true },
        { 名称 = "补天神石", 数量 = 1, 禁止交易 = true },
        { 名称 = "超级星梦石", 数量 = 1, 禁止交易 = true },
        等级 = 90, 转生 = 1
    },
    [10] = {
        { 名称 = "师贡", 参数 = 2000000, 禁止交易 = true },
        { 名称 = "法术熟练度", 参数 = 2000, 禁止交易 = true },
        { 名称 = "血烟石", 数量 = 99, 禁止交易 = true },
        { 名称 = "高级藏宝图", 数量 = 1, 禁止交易 = true },
        { 名称 = "亲密丹", 数量 = 1, 参数 = 100000, 禁止交易 = true },
        等级 = 110, 转生 = 1
    },

    [11] = {
        { 名称 = "师贡", 参数 = 2000000, 禁止交易 = true },
        { 名称 = "法术熟练度", 参数 = 1000, 禁止交易 = true },
        { 名称 = "血烟石", 数量 = 99, 禁止交易 = true },
        { 名称 = "补天神石", 数量 = 1, 禁止交易 = true },
        { 名称 = "亲密丹", 数量 = 2, 参数 = 100000, 禁止交易 = true },
        等级 = 122, 转生 = 1
    },

    [12] = {
        { 名称 = "师贡", 参数 = 2000000, 禁止交易 = true },
        { 名称 = "法术熟练度", 参数 = 1000, 禁止交易 = true },
        { 名称 = "青月灵草", 数量 = 99, 禁止交易 = true },
        { 名称 = "龙之心屑", 数量 = 99, 禁止交易 = true },
        { 名称 = "随机天书召唤兽", 数量 = 1, 禁止交易 = true },
        等级 = 50, 转生 = 2
    },
    [13] = {
        { 名称 = "师贡", 参数 = 2000000, 禁止交易 = true },
        { 名称 = "法术熟练度", 参数 = 1000, 禁止交易 = true },
        { 名称 = "青月灵草", 数量 = 99, 禁止交易 = true },
        { 名称 = "龙之心屑", 数量 = 99, 禁止交易 = true },
        { 名称 = "混元丹", 数量 = 1, 禁止交易 = true },
        等级 = 70, 转生 = 2
    },
    [14] = {
        { 名称 = "师贡", 参数 = 2000000, 禁止交易 = true },
        { 名称 = "法术熟练度", 参数 = 1000, 禁止交易 = true },
        { 名称 = "青月灵草", 数量 = 99, 禁止交易 = true },
        { 名称 = "龙之心屑", 数量 = 99, 禁止交易 = true },
        { 名称 = "超级星梦石", 数量 = 1, 禁止交易 = true },
        等级 = 90, 转生 = 2
    },
    [15] = {
        { 名称 = "法术熟练度", 参数 = 1000, 禁止交易 = true },
        { 名称 = "大话币", 参数 = 5000000, 禁止交易 = true },
        { 名称 = "青月灵草", 数量 = 99, 禁止交易 = true },
        { 名称 = "龙之心屑", 数量 = 99, 禁止交易 = true },
        { 名称 = "千年寒铁", 数量 = 2, 禁止交易 = true },
        等级 = 110, 转生 = 2
    },
    [16] = {
        { 名称 = "法术熟练度", 参数 = 1000, 禁止交易 = true },
        { 名称 = "大话币", 参数 = 5000000, 禁止交易 = true },
        { 名称 = "九玄仙玉", 数量 = 20, 禁止交易 = true },
        { 名称 = "青月灵草", 数量 = 99, 禁止交易 = true },
        { 名称 = "盘古精铁", 数量 = 2, 禁止交易 = true },
        等级 = 120, 转生 = 2
    },
    [17] = {
        { 名称 = "法术熟练度", 参数 = 1000, 禁止交易 = true },
        { 名称 = "大话币", 参数 = 5000000, 禁止交易 = true },
        { 名称 = "落魂砂", 参数 = 125, 数量 = 20, 禁止交易 = true },
        { 名称 = "超级星梦石", 数量 = 1, 禁止交易 = true },
        { 名称 = "补天神石", 数量 = 2, 禁止交易 = true },
        等级 = 130, 转生 = 2
    },
    [18] = {
        { 名称 = "法术熟练度", 参数 = 1000, 禁止交易 = true },
        { 名称 = "大话币", 参数 = 5000000, 禁止交易 = true },
        { 名称 = "清盈果", 数量 = 1, 参数 = 1000, 禁止交易 = true },
        { 名称 = "龙之心屑", 数量 = 99, 禁止交易 = true },
        { 名称 = "亲密丹", 数量 = 3, 参数 = 100000, 禁止交易 = true },
        等级 = 140, 转生 = 2
    },
    [19] = {
        { 名称 = "法术熟练度", 参数 = 1000, 禁止交易 = true },
        { 名称 = "大话币", 参数 = 5000000, 禁止交易 = true },
        { 名称 = "九花玉露丸", 数量 = 99, 禁止交易 = true },
        { 名称 = "无常丹", 数量 = 99, 禁止交易 = true },
        { 名称 = "高级藏宝图", 数量 = 1, 禁止交易 = true },
        等级 = 70, 转生 = 3
    },
    [20] = {
        { 名称 = "法术熟练度", 参数 = 1000, 禁止交易 = true },
        { 名称 = "大话币", 参数 = 5000000, 禁止交易 = true },
        { 名称 = "九花玉露丸", 数量 = 99, 禁止交易 = true },
        { 名称 = "无常丹", 数量 = 99, 禁止交易 = true },
        { 名称 = "高级藏宝图", 数量 = 1, 禁止交易 = true },
        等级 = 80, 转生 = 3
    },
    [21] = {
        { 名称 = "法术熟练度", 参数 = 1000, 禁止交易 = true },
        { 名称 = "大话币", 参数 = 5000000, 禁止交易 = true },
        { 名称 = "九花玉露丸", 数量 = 99, 禁止交易 = true },
        { 名称 = "无常丹", 数量 = 99, 禁止交易 = true },
        { 名称 = "高级藏宝图", 数量 = 1, 禁止交易 = true },
        等级 = 90, 转生 = 3
    },

    [22] = {
        { 名称 = "法术熟练度", 参数 = 1000, 禁止交易 = true },
        { 名称 = "大话币", 参数 = 5000000, 禁止交易 = true },
        { 名称 = "九花玉露丸", 数量 = 99, 禁止交易 = true },
        { 名称 = "无常丹", 数量 = 99, 禁止交易 = true },
        { 名称 = "筋骨提气丸", 数量 = 1, 禁止交易 = true },
        等级 = 100, 转生 = 3
    },

    [23] = {
        { 名称 = "法术熟练度", 参数 = 1000, 禁止交易 = true },
        { 名称 = "大话币", 参数 = 5000000, 禁止交易 = true },
        { 名称 = "二十一味清目丸", 数量 = 99, 禁止交易 = true },
        { 名称 = "超级金柳露", 数量 = 1, 禁止交易 = true },
        { 名称 = "六脉化神丸", 数量 = 1, 禁止交易 = true },
        等级 = 110, 转生 = 3
    },
    [24] = {
        { 名称 = "神兵礼盒", 参数 = 1, 数量 = 1, 禁止交易 = true },
        { 名称 = "大话币", 参数 = 5000000, 禁止交易 = true },
        { 名称 = "亲密丹", 参数 = 100000, 数量 = 5, 禁止交易 = true },
        { 名称 = "玉枢返虚丸", 数量 = 1, 禁止交易 = true },
        { 名称 = "超级星梦石", 数量 = 1, 禁止交易 = true },
        等级 = 150, 转生 = 3
    },
    [25] = {
        { 名称 = "大话币", 参数 = 5000000, 禁止交易 = true },
        { 名称 = "随机神兽宝盒", 数量 = 1, 禁止交易 = true },
        { 名称 = "超级藏宝图", 数量 = 1, 禁止交易 = true },
        { 名称 = "玉枢反虚丸", 数量 = 1, 禁止交易 = true },
        等级 = 170, 转生 = 3
    },


}

local _对话3 = [[

menu
1|送我去找游侠盟主
2|我要打开游侠锦囊
99|我再想想
]]

function 物品:使用(对象)
    local r = 对象:选择窗口(_对话3)
    if r == "1" then
        对象:切换地图(1208, 53, 126)
    elseif r == "2" then
        return self:打开奖励(对象)
    end
end

function 物品:打开奖励(对象)
    if 对象.转生 < self.等级[2] or (对象.转生 <= self.等级[2] and 对象.等级 < self.等级[1]) then
        return string.format("#Y需要%s转%s级以上才能打开！", self.等级[2], self.等级[1])
    end
    local t = _奖励[self.次数] --当前奖励表
    local list = {}
    for _, v in ipairs(t) do
        if v.名称 ~= "法术熟练度" and v.名称 ~= "师贡" and v.名称 ~= "大话币" then
            table.insert(list, 生成物品(v))
        end
    end
    if 对象:添加物品(list) then
        self.次数 = self.次数 + 1
        for i, v in ipairs(t) do
            if v.名称 == "法术熟练度" then
                if v.阶段 then
                    对象:指定阶数技能添加熟练(v.阶段, v.参数)
                else
                    对象:所有技能添加熟练(v.参数)
                end
            elseif v.名称 == "大话币" then
                对象:添加银子(v.参数, "新手礼包")
            elseif v.名称 == "师贡" then
                对象:添加师贡(v.参数, "新手礼包")
            end
        end
        t = _奖励[self.次数] --当前奖励表
        if t then
            self.等级[1] = t.等级 --等级
            self.等级[2] = t.转生 --等级
        else
            self.数量 = self.数量 - 1
        end
    else
        return string.format("#Y需要" .. #list .. "个包裹格子！")
    end
end

function 物品:取描述()
    if not self.等级 then
        self.等级 = { 10, 0 }
        self.次数 = 1
    end
    return string.format("#Y需要%s转%s级以上才能打开！", self.等级[2], self.等级[1])
end

return 物品
