local NPC = {}
local 对话 = {
    [[找我有何事？
menu
1|向掌门请教
4|我想学习技能
99|没事随便逛逛
]],
    [[找我有何事？
menu
2|交付师门任务
5|快捷完成(消耗师贡)
3|取消任务
99|没事随便逛逛
]],
    [[你不是本门弟子
menu
]],
    [[找我有何事？
menu
11|我要修炼蛇蝎美人
12|我要修炼追魂迷香
13|我要修炼断肠烈散
14|我要修炼鹤顶红粉
15|我要修炼万毒攻心
99|没事随便逛逛
]]
}
local _smjn = { '蛇蝎美人', '追魂迷香', '断肠烈散', '鹤顶红粉', '万毒攻心' }
local _消耗 = {
    2000,
    6000,
    12500,
    20000,
    60000
}
function NPC:NPC对话(玩家, i)
    -- print(玩家.种族,玩家.性别)
    if 玩家.种族 == 1 and 玩家.性别 == 2 then
        local r = 玩家:取任务('日常_师门任务')
        if r and r.门派 == 'nr' then
            return 对话[2]
        end
        return 对话[1]
    end
    return 对话[3]
end

function NPC:技能选项(玩家)
    for k, v in ipairs(_smjn) do
        if not 玩家:取技能是否存在(v) then
            return v
        end
    end
end

function NPC:NPC菜单(玩家, i)
    if i == "1" then
        local r = 玩家:选择窗口2(对话[4], self.外形)
        if r and r ~= "99" then
            local n = tonumber(r)
            if n then
                n = n - 10
                local xh = _消耗[n] or 999999999999
                local jn = _smjn[n]
                if 玩家:取技能是否满熟练(jn) then
                    return "该技能熟练度已满！"
                end
                if 玩家:扣除师贡(xh, '师门修炼', true) then
                    return self:领取师门任务(玩家, _smjn[n], n + 0)
                else
                    return "修炼该技能需要" .. xh .. "师贡"
                end
            end
        end
    elseif i == "2" then
        local r = 玩家:取任务('日常_师门任务')
        if r and r.分类 > 2 then
            玩家:打开给予窗口(self.nid)
        end
    elseif i == "3" then
        local r = 玩家:取任务('日常_师门任务')
        if r then
            r:任务取消(玩家)
            r:删除(玩家)
        end
    elseif i == "4" then
        for _, v in ipairs(_smjn) do
            if not 玩家:取技能是否存在(v) then
                玩家:添加技能(v, 1)
                玩家:常规提示(string.format("#Y你学会了#G%s", v))
            end
        end
    elseif i == "5" then
        local r = 玩家:取任务('日常_师门任务')
        if r and r.快捷消耗 then
            local rr = 玩家:选择窗口2("确定花费#R" .. r.快捷消耗 .. "两师贡完成任务么？\nmenu\n1|我要快点完成\n2|我再想想"
            , self.外形)
            if rr == "1" then
                if 玩家:扣除师贡(r.快捷消耗, '师门修炼', true) then
                    r:完成(玩家)
                else
                    return "你没有那么多师贡#24别来哄我！"
                end
            end
        end
    end
end

local _最后对话 = {
    '最近师门附近不甚太平总有些宵小之徒藏于暗处,今天该你巡逻,招子放亮点遇到他们不用手下留情,在#Y%s#W附近巡逻,铲除师门附近的#G密探。',
    '你进入门派也有一些日子了,师傅想看下你所学如何,去#Y%s#W附近和门派弟子切磋,没赢得话你也不用回来了#54。',
    '师门仓库最近#G%s#W存量较少了很多,你去找来交给师傅。',
    '师门仓库最近#G%s#W存量较少了很多,你去找来交给师傅。',
    '师门仓库最近#G%s#W存量较少了很多,你去找来交给师傅。',
    '师门仓库最近#G%s#W存量较少了很多,你去找来交给师傅。',
    '师门仓库最近#G%s#W存量较少了很多,你去找来交给师傅。',
    '你身上有尚未完成的任务！'
}
function NPC:领取师门任务(玩家, jn, 序号)
    if 玩家:取任务('日常_师门任务') then
        return _最后对话[8]
    end
    local 分类 = math.random(7)
    if 序号 < 4 then
        if 分类 == 5 then
            分类 = math.random(7) == 5 and math.random(4) or 分类
        end
    end
    local r = 生成任务 { 名称 = '日常_师门任务', 分类 = 分类, 技能 = jn, 序号 = 序号, 门派 = 'nr' }
    if r and r:添加任务(玩家) then
        return string.format(_最后对话[分类], r.位置)
    end
end

function NPC:NPC给予(玩家, cash, items)
    local r = 玩家:取任务('日常_师门任务')
    if r and r.门派 == 'nr' and items[1] then --
        if r.分类 == 3 and items[1].炼妖石 then
            if r.序号 > 3 and items[1].参数 > 8 then
                r:完成(玩家)
                if items[1].数量 >= 1 then
                    items[1]:接受(1)
                end
            elseif r.序号 < 4 and items[1].参数 > 3 then
                r:完成(玩家)
                if items[1].数量 >= 1 then
                    items[1]:接受(1)
                end
            end
        elseif r.分类 == 4 and items[1].是否宝石 then
            if r.序号 > 3 and items[1].等级 > 7 then
                r:完成(玩家)
                if items[1].数量 >= 1 then
                    items[1]:接受(1)
                end
            elseif r.序号 < 4 and items[1].等级 > 3 then
                r:完成(玩家)
                if items[1].数量 >= 1 then
                    items[1]:接受(1)
                end
            end
        elseif r.分类 == 5 and items[1].是否装备 then
            if r.序号 > 3 and items[1].级别 > 10 then
                r:完成(玩家)
                if items[1].数量 >= 1 then
                    items[1]:接受(1)
                end
            elseif r.序号 < 4 and items[1].级别 > 7 then
                r:完成(玩家)
                if items[1].数量 >= 1 then
                    items[1]:接受(1)
                end
            end
        elseif r.分类 == 6 or r.分类 == 7 then
            if items[1].名称 == r.位置 then
                r:完成(玩家)
                if items[1].数量 >= 1 then
                    items[1]:接受(1)
                end
            end
        end
        return
    end
    return '你给我什么东西？'
end

return NPC
