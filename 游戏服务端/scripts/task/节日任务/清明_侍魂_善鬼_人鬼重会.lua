-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-01 12:16:40
-- @Last Modified time  : 2022-09-07 15:17:32

local 任务 = {
    名称 = '清明_侍魂_善鬼_人鬼重会',
    别名 = '明火侍魂归',
    类型 = '节日任务',
    飞行限制 = true
}

function 任务:任务初始化(玩家, ...)
    self.进度 = 1
end

function 任务:任务上线(玩家)
    if self.时间 < os.time() then
        self:删除()
    end
end

function 任务:任务更新(sec)
    if self.时间 < sec then
        self:删除()
    end
end

function 任务:任务取消(玩家)

end

function 任务:任务取详情(玩家)
    return string.format("护送%s前往#Y%s#W见#G%s", self.怪名, self.位置, self.寻路)
end

local _怪物外形 = { 2115, 2113 } --无名之魂
local _怪物名称 = { "李清照之魂", "屈原之魂", "刘伶之魂" }
local _地图 = { 1001 }
function 任务:设置交付人(玩家)
    local map = 玩家:取随机地图(_地图)
    if not map then
        return
    end
    local t = map:取随机NPC()
    if not t then
        return
    end
    self.交付人 = { 名称 = t[1], nid = t[2], id = map.id, x = t[3], y = t[4] }
    self.位置 = string.format('%s(%d,%d)', map.名称, t[3], t[4])
    self.寻路 = string.format('#u#[%s|%s|%s|$%s#]#u', map.id, t[3], t[4], t[1])
end

function 任务:添加任务(玩家)
    local map = 玩家:取当前地图()

    if not map then
        return
    end
    local X, Y = 玩家.X, 玩家.Y
    if not X then
        return
    end
    self.怪名 = _怪物名称[math.random(#_怪物名称)]
    self.外形 = _怪物外形[math.random(#_怪物外形)]



    self.队伍 = {}
    for k, v in 玩家:遍历队伍() do
        table.insert(self.队伍, v.nid)
        v:添加任务(self)
    end
    self.NPC =
    map:添加NPC2 {
        队伍 = self.队伍,
        人数 = #self.队伍,
        名称 = self.怪名,
        外形 = self.外形,
        脚本 = 'scripts/task/节日活动/清明_侍魂_善鬼_人鬼重会.lua',
        时间 = 1800,
        任务类型 = "清明_侍魂_善鬼_人鬼重会",
        X = X,
        Y = Y,
        来源 = self
    }
    self.NPC.不复制 = true
    self:设置交付人(玩家)
    self.时间 = os.time() + 30 * 60
    --  self.提示 = math.random(#_寻人对话)
    self.遇敌时间 = 0
    self.跟随 = 玩家.nid

    self.最后对话 = string.format("我别无他求#15只愿能到%s与%s再见一面", self.位置, self.交付人.名称)
    return true
end

function 任务:完成(玩家)
    if self.NPC then
        self.NPC:删除()
    end
    self:掉落包(玩家)
    self:删除()
end

function 任务:移动开始(玩家)
    if self.NPC and self.跟随 == 玩家.nid then
        self.NPC.x, self.NPC.y = 玩家.x + math.random(-40, 40), 玩家.y + math.random(-40, 40)
        self.NPC.X, self.NPC.Y = self.NPC.x // 20, self.NPC.y // 20
        玩家:NPC移动(self.NPC.nid, self.NPC.x, self.NPC.y)
        -- 玩家:NPC移动(self.NPC.nid, self.NPC.x, self.NPC.y)
    end
end

function 任务:切换地图后事件(玩家, map, x, y)
    if self.NPC and self.跟随 == 玩家.nid then
        map:删除NPC(self.NPC.nid)
        self.NPC:删除()
        self.NPC =
        map:添加NPC {
            队伍 = self.队伍,
            人数 = #self.队伍,
            名称 = self.怪名,
            外形 = self.外形,
            脚本 = 'scripts/task/节日活动/清明_侍魂_善鬼_人鬼重会.lua',
            时间 = 1800,
            任务类型 = "清明_侍魂_善鬼_人鬼重会",
            X = 玩家.X,
            Y = 玩家.Y,
            来源 = self
        }
        self.NPC.不复制=true
    end

end

local _掉落 = {
    { 几率 = 200, 名称 = '九彩云龙珠', 数量 = 1, 参数 = 130 },
    { 几率 = 200, 名称 = '内丹精华', 数量 = 1 },
    { 几率 = 200, 名称 = '血玲珑', 数量 = 1, 参数 = 125 },
    { 几率 = 300, 名称 = '千年寒铁', 数量 = 1, 广播 = '#C%s#c00FFFF在侍魂任务中表现出色，赐予#G#m(%s)[%s]#m#n#c00FFFF以示鼓励!' },
    { 几率 = 300, 名称 = '天外飞石', 数量 = 1, 广播 = '#C%s#c00FFFF在侍魂任务中表现出色，赐予#G#m(%s)[%s]#m#n#c00FFFF以示鼓励!' },
    { 几率 = 310, 名称 = "帮派成就册", 参数 = 1000, 数量 = 1,
        广播 = '#C%s#c00FFFF在侍魂任务中表现出色，赐予#G#m(%s)[%s]#m#n#c00FFFF以示鼓励!' },
    { 几率 = 320, 名称 = '盘古精铁', 数量 = 1, 广播 = '#C%s#c00FFFF在侍魂任务中表现出色，赐予#G#m(%s)[%s]#m#n#c00FFFF以示鼓励!' },
    --{ 几率 = 55,名称 = "高级藏宝图",  数量 = 1, 广播 = '#C%s#c00FFFF在天宫寻宝中表现出色，赐予#G#m(%s)[%s]#m#n#c00FFFF以示鼓励!'},
    { 几率 = 5, 名称 = "修正卡", 数量 = 1, },
    { 几率 = 50, 名称 = "更名卡", 数量 = 1, },
    { 几率 = 100, 名称 = "刮刮乐", 数量 = 1, },

    --{ 几率 = 3,名称 = "神兵石",  数量 = 1,广播 = '#C%s#c00FFFF在天宫寻宝中表现出色，赐予#G#m(%s)[%s]#m#n#c00FFFF以示鼓励!' },
    { 几率 = 10, 名称 = "超级星梦石", 数量 = 1, },
    { 几率 = 3, 名称 = "筋骨提气丸", 数量 = 1, 广播 = '#C%s#c00FFFF在侍魂任务中表现出色，赐予#G#m(%s)[%s]#m#n#c00FFFF以示鼓励!' },
    { 几率 = 10, 名称 = "九转易筋丸", 数量 = 1, 广播 = '#C%s#c00FFFF在侍魂任务中表现出色，赐予#G#m(%s)[%s]#m#n#c00FFFF以示鼓励!' },
    { 几率 = 10, 名称 = "伐骨洗髓丹", 数量 = 1, 广播 = '#C%s#c00FFFF在侍魂任务中表现出色，赐予#G#m(%s)[%s]#m#n#c00FFFF以示鼓励!' },
    { 几率 = 15, 名称 = "高级金柳露", 数量 = 1, 广播 = '#C%s#c00FFFF在侍魂任务中表现出色，赐予#G#m(%s)[%s]#m#n#c00FFFF以示鼓励!' },
    { 几率 = 15, 名称 = "混元丹", 数量 = 1, 广播 = '#C%s#c00FFFF在侍魂任务中表现出色，赐予#G#m(%s)[%s]#m#n#c00FFFF以示鼓励!' },
    { 几率 = 4, 名称 = "超级金柳露", 数量 = 1, 广播 = '#C%s#c00FFFF在侍魂任务中表现出色，赐予#G#m(%s)[%s]#m#n#c00FFFF以示鼓励!' },
    { 几率 = 4, 名称 = "龙之骨", 数量 = 1, 广播 = '#C%s#c00FFFF在侍魂任务中表现出色，赐予#G#m(%s)[%s]#m#n#c00FFFF以示鼓励!' },
    -- { 几率 = 15,名称 = "武帝袍", 参数 = 11,  数量 = 1,广播 = '#C%s#c00FFFF在天宫寻宝中表现出色，赐予#G#m(%s)[%s]#m#n#c00FFFF以示鼓励!'},
    -- { 几率 = 15,名称 = "灵犀角", 参数 = 11,  数量 = 1,  广播 = '#C%s#c00FFFF在天宫寻宝中表现出色，赐予#G#m(%s)[%s]#m#n#c00FFFF以示鼓励!'},
    -- { 几率 = 15,名称 = "云罗帐", 参数 = 11,  数量 = 1, 广播 = '#C%s#c00FFFF在天宫寻宝中表现出色，赐予#G#m(%s)[%s]#m#n#c00FFFF以示鼓励!'},
    --  { 几率 = 15,名称 = "盘古石", 参数 = 11,  数量 = 1,广播 = '#C%s#c00FFFF在天宫寻宝中表现出色，赐予#G#m(%s)[%s]#m#n#c00FFFF以示鼓励!' },
    { 几率 = 200, 名称 = "武帝袍", 参数 = 9, 数量 = 1 },
    { 几率 = 200, 名称 = "灵犀角", 参数 = 9, 数量 = 1, },
    { 几率 = 200, 名称 = "云罗帐", 参数 = 9, 数量 = 1, },
    { 几率 = 200, 名称 = "盘古石", 参数 = 9, 数量 = 1, },
    { 几率 = 300, 名称 = "神兽丹", 数量 = 1, },
    { 几率 = 300, 名称 = "凝精聚气丹", 数量 = 1, },
    { 几率 = 150, 名称 = "人参果王", 数量 = 1, 广播 = '#C%s#c00FFFF在侍魂任务中表现出色，赐予#G#m(%s)[%s]#m#n#c00FFFF以示鼓励!' },
    { 几率 = 150, 名称 = "蟠桃王", 数量 = 1, 广播 = '#C%s#c00FFFF在侍魂任务中表现出色，赐予#G#m(%s)[%s]#m#n#c00FFFF以示鼓励!' },
    { 几率 = 500, 名称 = "千年寒铁", 数量 = 1, },
    { 几率 = 500, 名称 = "天外飞石", 数量 = 1, },
    { 几率 = 400, 名称 = "盘古精铁", 数量 = 1, },
    { 几率 = 400, 名称 = "补天神石", 数量 = 1, 广播 = '#C%s#c00FFFF在侍魂任务中表现出色，赐予#G#m(%s)[%s]#m#n#c00FFFF以示鼓励!' },
    --{ 几率 = 1,名称 = "神兵礼盒",  数量 = 1,广播 = '#C%s#c00FFFF在天宫寻宝中表现出色，赐予#G#m(%s)[%s]#m#n#c00FFFF以示鼓励!' },
    --{ 几率 = 1,名称 = "守护宝卷",  数量 = 1,广播 = '#C%s#c00FFFF在天宫寻宝中表现出色，赐予#G#m(%s)[%s]#m#n#c00FFFF以示鼓励!' },
    --{ 几率 = 1,名称 = "超级变色丹",  数量 = 1, 广播 = '#C%s#c00FFFF在天宫寻宝中表现出色，赐予#G#m(%s)[%s]#m#n#c00FFFF以示鼓励!'},
    -- { 几率 = 1,名称 = "超级元气丹",  数量 = 1,广播 = '#C%s#c00FFFF在天宫寻宝中表现出色，赐予#G#m(%s)[%s]#m#n#c00FFFF以示鼓励!' },
    { 几率 = 5, 名称 = "轻盈果", 参数 = 500, 数量 = 1,
        广播 = '#C%s#c00FFFF在侍魂任务中表现出色，赐予#G#m(%s)[%s]#m#n#c00FFFF以示鼓励!', },
    { 几率 = 250, 名称 = "天书残卷第一卷", 数量 = 1, },
    { 几率 = 250, 名称 = "天书残卷第二卷", 数量 = 1, },
    { 几率 = 250, 名称 = "天书残卷第三卷", 数量 = 1, },
    { 几率 = 250, 名称 = "天书残卷第四卷", 数量 = 1, },
    { 几率 = 250, 名称 = "天书残卷第五卷", 数量 = 1, },
    { 几率 = 250, 名称 = "天书残卷第六卷", 数量 = 1, },
    { 几率 = 100, 名称 = "见闻录", 数量 = 1, },
    { 几率 = 50, 名称 = "六脉化神丸", 数量 = 1, },
    { 几率 = 150, 名称 = "亲密丹", 数量 = 1, },
    { 几率 = 30, 名称 = "月光宝盒", 数量 = 1, 广播 = '#C%s#c00FFFF在侍魂任务中表现出色，赐予#G#m(%s)[%s]#m#n#c00FFFF以示鼓励!' },
}


local _次数上限 = 100
function 任务:掉落包(玩家, 次数)
    if 玩家:取活动限制次数('侍魂归') > _次数上限 then
        玩家:常规提示("#Y今日已经完成%s次，无法获得奖励", _次数上限)
        return
    end
    玩家:增加活动限制次数('侍魂归')

    local 银子 = math.floor(30000)
    local 经验 = math.floor(984521)
    local 法宝经验 = math.floor(140)
    玩家:添加任务经验(经验, "侍魂归")
    玩家:添加银子(银子, "侍魂归")
    if 玩家:取活动限制次数('侍魂归') % 2 ~= 0 then
        return
    end



    local 总几率 = math.random(1000)
    local 几率=0
    for i, v in ipairs(_掉落) do
        几率=几率+v.几率
        if 总几率 <= 几率 then
            local r = 生成物品 { 名称 = v.名称, 数量 = v.数量, 参数 = v.参数, 禁止交易 = v.禁止交易 }
            if r then
                玩家:添加物品({ r })
                if v.广播 then
                    玩家:发送系统(v.广播, 玩家.名称, r.nid, r.名称)
                end
                break
            end
        end
    end
end

local 对话 = [[雾窗寒对遥天暮，暮天遥对寒窗雾。花落正啼鸦，鸦啼正落花。#48一袖罗垂影瘦，瘦影垂罗袖，风剪一丝红,红丝一剪风。#56
]]

function 任务:NPC对话(玩家, NPC)
    if NPC.任务类型 == "清明_侍魂_善鬼_人鬼重会" then
        local r = 玩家:取任务("清明_侍魂_善鬼_人鬼重会")
        if r and r.NPC == NPC.nid then
            return r.最后对话
        end
        return "我认识你么？"
    end
end

function 任务:NPC菜单(玩家, i, NPC)

end

function 任务:任务NPC对话(玩家, NPC)
    if 玩家.地图 == self.交付人.id and NPC.名称 == self.交付人.名称 then
        local r = 玩家:取任务("清明_侍魂_善鬼_人鬼重会")
        for _, v in 玩家:遍历队伍() do
            local rw = v:取任务("清明_侍魂_善鬼_人鬼重会")
            if rw and rw.nid == r.nid then
                rw:完成(v)
            end
        end
        NPC.台词 = "谢谢让我们能够再见一面！"
    end
end

function 任务:地图刷新事件(玩家)
    if 玩家.是否移动 and not 玩家.是否战斗 then
        self.遇敌时间 = self.遇敌时间 + math.random(1, 3)
        if self.遇敌时间 > 20 and math.random(100) < 30 then
            self.遇敌时间 = 0
            玩家:最后对话("好大的胆子,居然敢在阳间夹带鬼魂跑路，趁早把鬼魂交来!别妨碍我们执行公务#77")
            玩家:进入战斗('scripts/task/节日活动/清明_侍魂_善鬼_人鬼重会.lua')
        end
    end
end

local _外形 = {
    2075,
    3058,
    3073,
    2052,
    2053,

}
local _名称 = {
    "阎王",
    "白无常",
    "黑无常",
    "牛头",
    "马面",

}
function 任务:战斗初始化(玩家)
    local r = 玩家:取任务('清明_侍魂_善鬼_人鬼重会')
    local 等级 = 玩家:取队伍最高等级()
    local 转生 = 玩家:取队伍最高转生()
    if r then
        local 怪物属性
        for i = 1, 5, 1 do
            怪物属性 = {
                外形 = _外形[i],
                名称 = _名称[i],
                等级 = 等级,
                气血 = 40000 + 转生 * 50000 + 等级 * 1000,
                魔法 = 26000,
                攻击 = 1000 + 转生 * 1000 + 等级 * 20,
                速度 = 100 + 转生 * 100 + 等级 * 1,
                抗性 = { 物理吸收 = 20, 抗雷 = -10, 抗火 = -10, 抗风 = -10, 抗震慑 = 8 },
                技能 = {
                    { 名称 = '太乙生风', 熟练度 = 10000 }, { 名称 = '龙啸九天', 熟练度 = 10000 },
                    { 名称 = '三味真火', 熟练度 = 10000 },

                },
                施法几率 = 100,
                是否消失 = false,

            }




            self:加入敌方(i, 生成战斗怪物(怪物属性))
        end


    end
end

function 任务:进场喊话()

end

function 任务:战斗回合开始(dt)


end

function 任务:战斗结束(s)

end

return 任务
