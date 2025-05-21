local 物品 = {
    名称 = '神兽自选卡',
    叠加 = 0,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false,
}

function 物品:初始化()

end


local _五常神兽范围 = { '颜如玉', '五叶', '浪淘沙', '范式之魂', '垂云叟' }
local _老版神兽范围 = {'超级海龟','超级蝙蝠','超级毒蛇','超级蜘蛛','超级蟾蜍','超级飞鱼'}
local _人形神兽范围 = {'泾河龙王','龙太子','青霞仙子','白晶晶','至尊小宝','春三十娘','牛魔王','紫霞仙子'}
local _对话 = [[
请选择你想要的召唤兽类型！ 
menu
1|我想要五常神兽
2|我想要老版神兽
3|我想要人性神兽
99|我再想想

]]

local _对话1= [[
请选择你想要的召唤兽！ 
menu
1|颜如玉
2|五叶
3|浪淘沙
4|范式之魂
5|垂云叟
99|我再想想  
]]

local _对话2 = [[
请选择你想要的召唤兽！ 
menu
1|超级海龟
2|超级蝙蝠
3|超级毒蛇
4|超级蜘蛛
5|超级蟾蜍
6|超级飞鱼
99|我再想想  
]]

local _对话3 = [[
请选择你想要的召唤兽！ 
menu
1|泾河龙王
2|龙太子
3|青霞仙子
4|白晶晶
5|至尊小宝
6|春三十娘
7|牛魔王
8|紫霞仙子
99|我再想想  
]]






function 物品:使用(对象)
    local r = 对象:选择窗口(_对话)
    if r == '1' then
        local rr = 对象:选择窗口(_对话1)
        if rr then
            local name=""
            for i,v in ipairs(_五常神兽范围) do
                if rr==tostring(i) then
                    name=v
                end
            end
            if name~= "" and 对象:添加召唤(生成召唤 { 名称 =name }) then
                self.数量=self.数量-1
            end
        end
    elseif r == '2' then
        local rr = 对象:选择窗口(_对话2)
        if rr then
            local name=""
            for i,v in ipairs(_老版神兽范围) do
                if rr==tostring(i) then
                    name=v
                end
            end
            if name~= "" and 对象:添加召唤(生成召唤 { 名称 =name }) then
                self.数量=self.数量-1
            end
        end
    elseif r == '3' then
        local rr = 对象:选择窗口(_对话3)
        if rr then
            local name=""
            for i,v in ipairs(_人形神兽范围) do
                if rr==tostring(i) then
                    name=v
                end
            end
            if name~= "" and 对象:添加召唤(生成召唤 { 名称 =name }) then
                self.数量=self.数量-1
            end
        end
    end
end



return 物品