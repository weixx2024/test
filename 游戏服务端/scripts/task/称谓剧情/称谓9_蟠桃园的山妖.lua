local 任务 = {
    名称 = '称谓9_蟠桃园的山妖',
    别名 = '(九称)蟠桃园的山妖',
    类型 = '称谓剧情',
    是否可取消 = false
}

function 任务:任务初始化(玩家, ...)
    self.挑战 = { 山妖 = 0, 山鬼 = 0 }
end

function 任务:任务上线(玩家)
end

function 任务:任务更新(玩家, sec)

end

local _详情 = {
    '你可以完成第九个称谓剧情任务了，任务领取人#Y御马监#W的#G#u#[1199|45|130|$采星仙女#]#u',
    '解决蟠桃园里骚扰的怪物，打败#G#u#[1217|17|178|$野山妖#]#u#W和#G#u#[1217|87|102|$山鬼#]#u#W。#R（ALT+A攻击怪物）',
    '回去找#G#u#[1199|45|130|$采星仙女#]#u#W。'
}
function 任务:任务取详情(玩家)
    return _详情[self.进度 + 1]
end

local _台词 = {
    [1] = { 头像 = 3061, 结束 = false, 台词 = '因为下界妖气太盛，天宫的防护减弱了，蟠桃园里居然来了两只山妖捣乱，把三千年一熟的蟠桃偷吃的干干净净，我不知道如何是好，你能帮忙我去清理这些可恶的怪物吗？我会报答你的。' },
    [2] = { 头像 = 0, 台词 = '好，包在我身上。' },
    --0
    [3] = { 头像 = 3061, 结束 = false, 台词 = '当年的齐天大圣孙悟空也曾经管理过蟠桃园，如果他还在的话，这些小鬼山妖怎么敢来嚣张啊？' },
    [4] = { 头像 = 0, 结束 = false, 台词 = '呵呵，看起来你们还是很想念他的嘛。' },
    [5] = { 头像 = 3061, 台词 = '哎……还是要多谢你清理了蟠桃园，我这有个宝贝就送给你吧。' },
    --2
}

function 任务:取对话(玩家)
    local r = _台词[self.对话进度]
    local 台词, 头像, 结束 = r.台词, r.头像, r.结束
    if 头像 == 0 then
        头像 = 玩家.原形
    end
    return 台词, 头像, 结束
end

function 任务:任务NPC对话(玩家, NPC)
    if not 玩家:剧情称谓是否存在(8) then
        return
    end

    NPC.队伍对话 = true
    if NPC.名称 == '采星仙女' then
        if self.进度 == 0 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 2 then
                self.进度 = 1
            end
        elseif self.进度 == 2 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 5 then
                self:完成(玩家)
            end
        end
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
end

function 任务:完成进度1(玩家, name)
    if self.进度 == 1 then
        if name == "野山妖" and self.挑战.山妖 == 0 then
            self.挑战.山妖 = 1
        elseif name == "山鬼" and self.挑战.山鬼 == 0 then
            self.挑战.山鬼 = 1
        end
        if self.挑战.山妖 == 1 and self.挑战.山鬼 == 1 then
            self.进度 = 2
        end
    end
end

function 任务:完成(玩家)
    玩家:添加声望(7000)
    玩家:添加经验(2520000)
    玩家:常规提示('#Y你帮助孙悟空找到了金箍棒，你在这个世界的声望提升了，你获得了7000点声望。')
    local r = 玩家:取任务('引导_称谓剧情')
    if r then
        r:检测剧情称谓是否完成(玩家, 9, '山妖')
    end
    self:删除()
end

function 任务:任务NPC给予(玩家, NPC, cash, items)
end

function 任务:任务攻击事件(玩家, NPC)
    if NPC.名称 == '野山妖' then
        if self.进度 == 1 and self.挑战.山妖 == 0 then
            玩家:进入战斗('scripts/task/称谓剧情/称谓9_蟠桃园的山妖.lua', 2)
        end
    elseif NPC.名称 == '山鬼' then
        if self.进度 == 1 and self.挑战.山鬼 == 0 then
            玩家:进入战斗('scripts/task/称谓剧情/称谓9_蟠桃园的山妖.lua', 1)
        end
    end
end

local _怪物 = {
    {
        名称 = "山鬼",
        等级 = 110,
        外形 = 2025,
        气血 = 700000,
        魔法 = 120000,
        攻击 = 12000,
        速度 = 250,
        是否消失 = false,
        抗性 = {
            抗混乱 = 50,
            抗封印 = 50,
            抗昏睡 = 50,

        },
        技能 = {
            { 名称 = "雷神怒击", 熟练度 = 900 },
            { 名称 = "谗言相加", 熟练度 = 900 },

        }
    },

    {
        名称 = "野山妖",
        等级 = 110,
        外形 = 2025,
        气血 = 700000,
        魔法 = 120000,
        攻击 = 12000,
        速度 = 250,
        是否消失 = false,
        抗性 = {
            抗混乱 = 50,
            抗封印 = 50,
            抗昏睡 = 50,

        },
        技能 = {
            { 名称 = "雷神怒击", 熟练度 = 900 },
            { 名称 = "谗言相加", 熟练度 = 900 },

        }
    },

    {
        名称 = "神灵",
        等级 = 90,
        外形 = 2068,
        气血 = 350000,
        魔法 = 120000,
        攻击 = 6000,
        速度 = 125,
        是否消失 = false,
        抗性 = {
            抗混乱 = 50,
            抗封印 = 50,
            抗昏睡 = 50,

        },
        技能 = {
            { 名称 = "雷神怒击", 熟练度 = 9000 },

        }
    },




}
function 任务:战斗初始化(玩家, i)
    local r = 生成战斗怪物(_怪物[i])
    self:加入敌方(1, r)
    local n = math.random(2, 8)
    for k = 1, n, 1 do
        r = 生成战斗怪物(_怪物[3])
        self:加入敌方(k + 1, r)
    end
end

function 任务:战斗回合开始(dt)

end

function 任务:战斗结束(s)
    if s then
        local zg = self:取对象(101)
        if zg then
            for k, v in self:遍历我方() do
                if v.是否玩家 then
                    local r = v.对象.接口:取任务("称谓9_蟠桃园的山妖")
                    if r then
                        if r.进度 == 1 then
                            r:完成进度1(v.对象.接口, zg.名称)
                        end
                    end
                end
            end
        end
    end
end

return 任务
