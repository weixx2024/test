local 任务 = {
    名称 = '称谓1_教训飞贼',
    别名 = '(一称)教训飞贼',
    类型 = '称谓剧情',
    是否可取消 = false 
}

function 任务:任务初始化(玩家, ...)
end

function 任务:任务上线(玩家)
end

function 任务:任务更新(玩家, sec)
end

local _详情 = {
    '前往#Y长安#W找#G#u#[1001|202|196|$杜老板#]#u#W聊一聊！',
    '去#Y大唐境内#W的山路上看看，教训那群#G#u#[1110|311|87|$抢药的飞贼#]#u#W。#R（ALT+A攻击飞贼）',
    '你成功的击杀了飞贼，快回去找#G#u#[1001|202|196|$杜老板#]#u#W复命吧。'
}

function 任务:任务取详情(玩家)
    return _详情[self.进度 + 1]
end

local _台词 = {
    [1] = { 头像 = 3002, 台词 = '该死的强盗，每次来我这里拿药都不付钱。要是你能帮我去教训他一顿的话我一定会报答你的!那些强盗一般经常在#R长安西#w的山路上出现。' },
    --0
    [2] = { 头像 = 3002, 结束 = false, 台词 = '太好了，这下可出了一口恶气!作为报答，我送你1000两银子!' },
    [3] = { 头像 = 0, 台词 = '哈哈，这个老板还是挺慷慨的嘛!' },
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
    NPC.队伍对话 = true
    if NPC.名称 == '杜老板' then
        if self.进度 == 0 then
            self.进度 = 1
            self.对话进度 = 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
        elseif self.进度 == 2 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 3 then
                self:完成(玩家)
            end
        end
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
end

function 任务:击杀飞贼(玩家)
    self.进度 = 2
    玩家:常规提示('#Y你成功击杀了飞贼')
end

function 任务:完成(玩家)
    玩家:添加师贡(1000)
    local r = 玩家:取任务('引导_称谓剧情')
    if r then
        r:检测剧情称谓是否完成(玩家, 1, '飞贼')
    end
    self:删除()
end

function 任务:任务NPC给予(玩家, NPC, cash, items)
end

function 任务:任务攻击事件(玩家, NPC)
    if self.进度 == 1 then
        if NPC.名称 == '抢药的飞贼' then
            玩家:进入战斗('scripts/task/称谓剧情/称谓1_教训飞贼.lua')
        end
    end
end

local _怪物 = {
    {
        名称 = "飞贼",
        外形 = 2045,
        气血 = 800,
        魔法 = 1500,
        攻击 = 500,
        速度 = 10,
        抗性 = {
        },
        技能 = {
            { 名称 = '龙卷雨击', 熟练度 = 1000 },
            { 名称 = '龙腾水溅', 熟练度 = 1000 },
        }
    },
}

function 任务:战斗初始化(玩家)
    local r = 生成战斗怪物(_怪物[1])
    self:加入敌方(1, r)
end

function 任务:战斗回合开始(dt)
end

function 任务:战斗结束(s)
    if s then
        for k, v in self:遍历我方() do
            if v.是否玩家 then
                local r = v.对象.接口:取任务("称谓1_教训飞贼")
                if r and r.进度 == 1 then
                    r:击杀飞贼(v.对象.接口)
                end
            end
        end
    end
end

return 任务
