-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-01 12:16:40
-- @Last Modified time  : 2022-09-07 15:17:32

local 任务 = {
    名称 = '清明_侍魂_善鬼_插柳',
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
    if self.进度 == 1 then
        return string.format("帮%s到%s种一颗柳树吧", self.怪名, self.位置)
    elseif self.进度 >= 2 then
        return string.format("株柳需要#G%s#W来增加养分", self.需求)
    end

end

local _怪物外形 = { 2115, 2113 } --无名之魂
local _怪物名称 = { "李清照之魂", "屈原之魂", "刘伶之魂" }
local _地图 = { 1001 }


function 任务:添加任务(玩家)
    if not self:设置目的坐标(玩家) then
        return
    end

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
    map:添加NPC {
        队伍 = self.队伍,
        人数 = #self.队伍,
        名称 = self.怪名,
        外形 = self.外形,
        脚本 = 'scripts/task/节日活动/清明_侍魂_善鬼_插柳.lua',
        时间 = 30 * 60,
        任务类型 = "清明_侍魂_善鬼_插柳",
        X = X,
        Y = Y,
        来源 = self
    }
    self.MAP = map.id
    self.时间 = os.time() + 30 * 60
    self.最后对话 = string.format("帮我到%s种一颗柳树吧", self.位置)
    return true
end

local _需求 = {
    "金柳露",
    "千年血参",
    "千年灵花",
    "二十一味清目丸",
    "血烟石",
}
function 任务:插柳(玩家)
    local map = 玩家:取当前地图()
    if not map then
        return
    end
    local X, Y = 玩家.X, 玩家.Y
    if not X then
        return
    end
    self.需求 = _需求[math.random(#_需求)]
    self.进度 = 2
    self.NPC2 =
    map:添加NPC {
        名称 = 玩家.名称 .. "的株柳",
        外形 = 2151,
        脚本 = 'scripts/task/节日活动/清明_侍魂_善鬼_插柳.lua',
        时间 = 1800,
        任务类型 = "清明_侍魂_善鬼_插柳",
        X = X,
        Y = Y,
        来源 = self
    }
    self.map2 = map.id
end

local _柳树外形 = {
    --   2151,
    2152,
    2153,

}
function 任务:物品提交(玩家)
    self.进度 = self.进度 + 1
    self.需求 = _需求[math.random(#_需求)]
    local map = 玩家:取地图(self.map2)
    if map then
        local npc = map:取NPC(self.NPC2)
        local wx = _柳树外形[self.进度 - 2]
        if wx then
            npc:切换外形(wx)
        end
    end
    self.最后对话 = "我已经长大了不少，再去帮我找一个" .. self.需求 .. "我会快快长大"
    if self.进度 >= 5 then
        self.最后对话 = "谢谢你的呵护，这些是给你的奖励"
        local r = 玩家:取任务("清明_侍魂_善鬼_插柳")
        for _, v in 玩家:遍历队伍() do
            local rw = v:取任务("清明_侍魂_善鬼_插柳")
            if rw and rw.nid == r.nid then
                rw:完成(v)
            end
        end
    end
    return true
end

function 任务:设置目的坐标(玩家)
    local map = 玩家:取随机地图(_地图)
    if not map then
        return
    end
    local X, Y = map:取随机坐标()
    if not X then
        return
    end
    self.x, self.y = X, Y
    self.mapid = map.id
    self.位置 = string.format('%s(%d,%d)', map.名称, X, Y)
    if 玩家:添加物品({ 生成物品 { 名称 = '株柳', 数量 = 1, x = X, y = Y, mapid = map.id, map = self.位置 } }) then
        return true
    end
    return false
end

function 任务:完成(玩家)
    self:掉落包(玩家)
    self:删除()
    local map = 玩家:取地图(self.MAP)
    if map then
        local NPC = map:取NPC(self.NPC)
        if NPC then
            map:删除NPC(self.NPC)
        end
    end
    map = 玩家:取地图(self.mapid)
    if map then
        local NPC = map:取NPC(self.NPC2)
        if NPC then
            NPC:延迟删除(10)
        end
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
function 任务:掉落包(玩家)
    if 玩家:取活动限制次数('侍魂归') > _次数上限 then
        玩家:常规提示("#Y今日已经完成%s次，无法获得奖励", _次数上限)
        return
    end
    玩家:增加活动限制次数('侍魂归')

    local 银子 = math.floor(50000)
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

function 任务:NPC对话(玩家, NPC)
    if NPC.任务类型 == "清明_侍魂_善鬼_插柳" then
        local r = 玩家:取任务("清明_侍魂_善鬼_插柳")
        if r then
            if r.进度 == 1 then
                if r.NPC == NPC.nid then
                    return r.最后对话
                end
            elseif r.进度 >= 2 then
                if r.NPC2 == NPC.nid then
                    return "我要快点长大,我要吸收营养 帮我找一个" .. r.需求 .. "我会快快长大"
                end
            end
        end
        return "我认识你么？"
    end
end

function 任务:NPC菜单(玩家, i, NPC)

end

function 任务:任务NPC给予(玩家, NPC, cash, items)
    local r = 玩家:取任务("清明_侍魂_善鬼_插柳")
    if r and r.进度 >= 2 then
        if r.NPC2 == NPC.nid then
            if items[1] and items[1].名称 == r.需求 then
                if r.进度 <= 5 then
                    if items[1].数量 >= 1 then
                        if r:物品提交(玩家) then
                            items[1]:接受(1)
                            NPC.结束 = nil
                            NPC.台词 = r.最后对话
                        end
                    end
                else
                    NPC.结束 = nil
                    NPC.台词 = "我已经长大了哟！"
                end

            end
        end
    end
end

return 任务
