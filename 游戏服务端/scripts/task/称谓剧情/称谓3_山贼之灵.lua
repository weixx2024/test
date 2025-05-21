local 任务 = {
    名称 = '称谓3_山贼之灵',
    别名 = '(三称)山贼之灵',
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
    '前往#Y斧头帮#W找#G#u#[1203|66|80|$二当家#]#u#W聊一聊！',
    '为了加入斧头帮，去#Y大雁塔六层(50,56)#W打败#G#u#[1090|51|56|$山贼之灵#]#u#W。#R（ALT+A攻击山贼之灵）',
    '打败山贼之灵了，回去找#G#u#[1203|66|80|$二当家#]#u#W加入斧头帮吧。'
}
function 任务:任务取详情(玩家)
    return _详情[self.进度 + 1]
end

local _台词 = {
    [1] = { 头像 = 3024, 结束 = false, 台词 = '什么你说你想要加入斧头帮，想当一个好山贼？这可不是那么简单地，这可是要经历许多考验地！！你想当个山贼吗？…哎，别推辞了，我知道你想当，当山贼是一份多么有前途的职业呀！！你想当你就说嘛，你不说我怎么知道呢。对不对？好，想当山贼首先就要接受入门级的考验，也就是去#R大雁塔六层#W干掉我们山贼的祖师爷一一#R山贼之灵#W。别害怕，我相信你，你行地！' },
    [2] = { 头像 = 0, 台词 = '有没有搞错啊~不去行不行啊，又是这么老套的任务。' },
    --0
    [3] = { 头像 = 3024, 台词 = '哇，你真的能打败山贼之灵？厉害厉害，连我都打不过…好，从现在开始，你就是我斧头帮的一员了。做一个最好的山贼，继续努力吧！' },
    --1
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
    if not 玩家:剧情称谓是否存在(2) then
        return
    end

    NPC.队伍对话 = true
    if NPC.名称 == '二当家' then
        if self.进度 == 0 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 2 then
                self.进度 = 1
            end
        elseif self.进度 == 2 then
            self.对话进度 = 3
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            self:完成(玩家)
        end
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
end

function 任务:击杀山贼之灵(玩家)
    self.进度 = 2
    玩家:添加经验(15847)
    玩家:添加师贡(4268)
    玩家:常规提示('#R你打败了山贼之灵，获得了15847经验和4268两银子！')
end

function 任务:完成(玩家)
    玩家:添加声望(10)
    玩家:添加称谓('斧头帮小虾米')
    玩家:提示窗口('#Y因为你的勇气可嘉，你在这个世界的声望得到了提升，获得10点声望和和斧头帮小虾米的称号。')
    local r = 玩家:取任务('引导_称谓剧情')
    if r then
        r:检测剧情称谓是否完成(玩家, 3, '山贼')
    end
    self:删除()
end

function 任务:任务NPC给予(玩家, NPC, cash, items)
end

function 任务:任务攻击事件(玩家, NPC)
    if NPC.名称 == '山贼之灵' then
        if self.进度 == 1 then
            玩家:进入战斗('scripts/task/称谓剧情/称谓3_山贼之灵.lua')
        end
    end
end

local _怪物 = {
    {
        名称 = "山贼之灵",
        外形 = 2045,
        气血 = 16000,
        魔法 = 3000,
        攻击 = 2200,
        速度 = 25,
        抗性 = {

        },
        技能 = {

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
                local r = v.对象.接口:取任务("称谓3_山贼之灵")
                if r and r.进度 == 1 then
                    r:击杀山贼之灵(v.对象.接口)
                end
            end
        end
    end
end

return 任务
