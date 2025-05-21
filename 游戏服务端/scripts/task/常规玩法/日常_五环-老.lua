local 任务 = {
    名称 = '日常_五环',
    别名 = '五环',
    类型 = '常规玩法',
    飞行限制 = true
}

function 任务:任务初始化()
    self.进度 = 1
    self.次数 = 1
end
local _名称 = {'精灵仙的替身','逍遥生的替身','PK狂','虎头怪的替身','惯骗','祭剑魂的替身','食婴鬼手下的手下','舞天姬的替身','盗号贼'}
local _任务描述 = {
    '#G精灵仙的替身#W在大雁塔二层#G(%s,%s)#W,遇到了麻烦,需要一个%s快去帮助她吧。#r#R(剩余#R%d#R分)',
    '#G逍遥生的替身#W在大唐境内#G(%s,%s)#W,遇到了麻烦,快去帮助他吧。#r#R(剩余#R%d#R分)',
    '到#G大唐境内(%s,%s)#W,惩罚欺负新人的#GPK狂#W。#r#R(剩余#R%d#R分)',
    '#G虎头怪的替身#W在大唐边境#G(%s,%s)#W,遇到了麻烦,快去帮助他吧。#r#R(剩余#R%d#R分)',
    '帮虎头怪的替身到#G大唐边境(%s,%s)#W,找#G惯骗#W问个清楚。#r#R(剩余#R%d#R分)',
    '#G祭剑魂的替身#W在长安城东#G(%s,%s)#W,遇到了麻烦,快去帮助他吧。#r#R(剩余#R%d#R分)',
    '帮祭剑魂的替身到#G长安城东(170,212)#W,干掉#G食婴鬼手下的手下#r#R(剩余#R%d#R分)',
    '#G舞天姬的替身#W在龙宫#G(%s,%s)#W,遇到了麻烦,快去帮助她吧。#r#R(剩余#R%d#R分)',
    '到#G龙宫(%s,%s)#W,找#G盗号贼#W替舞天姬讨回公道。#r#R(剩余#R%d#R分)',
}
function 任务:任务取详情(玩家)
    if self.进度 == 1 then
        return string.format(_任务描述[self.进度], self.坐标.x or 0 , self.坐标.y or 0 , self.装备 or '' , (self.时间 - os.time()) // 60)
    elseif self.进度 == 7 then
        return string.format(_任务描述[self.进度], (self.时间 - os.time()) // 60)
    else
        return string.format(_任务描述[self.进度], self.坐标.x or 0 , self.坐标.y or 0 , (self.时间 - os.time()) // 60)
    end
end

local _追踪描述 = '去#G%s(%s,%s)#W寻找#u#G#m({%s,%s,%s})%s#m#u#W[#G%s/5#W]#r#W剩余时间:%s'

function 任务:任务取追踪(玩家)
    local map = 玩家:取地图(self.MAP)
    if map then
        return string.format(_追踪描述,map.名称,self.坐标.x,self.坐标.y,map.名称,self.坐标.x,self.坐标.y,_名称[self.进度],self.次数,os.date("%H:%M:%S", (self.时间 - os.time() // 60 )))--任务.别名,任务.类别,
    end
end

function 任务:任务更新(sec)
    if self.时间 <=sec then
        self:删除()
    end
end

function 任务:任务取消(玩家)
    local map = 玩家:取地图(self.MAP)
    if map then
        local NPC = map:取NPC(self.NPC)
        if NPC then
            map:删除NPC(self.NPC)
        end
    end
    self:删除()
end

function 任务:任务上线(玩家)
    if self.时间 - os.time() <= 0 then
        if self.NPC then
            self:任务取消(玩家)
        end
    end
end

local _装备库 = {'书生巾','玉钗','夜魔披风','丝绸长裙','水晶珠链','神行靴'}

function 任务:添加任务(玩家)
    self.时间 = os.time() + 30 * 60
    local map = 玩家:取地图(1005)
    if not map then
        return
    end
    self.装备 = _装备库[math.random(1, #_装备库)]
    self.坐标 = {}
    self.坐标.x, self.坐标.y = map:取随机坐标()
    if not self.坐标.x then
        return
    end
    self.队伍 = {}
    self.NPC =
        map:添加NPC {
            队伍 = self.队伍,
            名称 = '精灵仙的替身',
            时长 = 1800,
            外形 = 17,
            脚本 = 'scripts/task/日常/日常_五环任务.lua',
            时间 = self.时间,
            X = self.坐标.x,
            Y = self.坐标.y,
            来源 = self
        }
    self.MAP = map.id
    return {名称 = '精灵仙的替身', 地图 = map, 坐标={x=self.坐标.x,y=self.坐标.y}}
end


function 任务:生成怪物(玩家)

end

function 任务:完成(玩家)
    玩家:提示窗口('#Y你完成了本日的五环任务')
    local 双加 = {'千年熊胆','玫瑰仙叶','仙鹿茸','修罗玉','海蓝石','夜叉石'}
    玩家:添加物品({ 生成物品 { 名称 = 双加[math.random(1, #双加)], 数量 = 30 } })
    self:删除()
end

function 任务:更新进度(玩家)
    self.进度 = self.进度 + 1
    local map = 玩家:取地图(self.MAP)
    if map then
        local NPC = map:取NPC(self.NPC)
        if NPC then
            map:删除NPC(self.NPC)
        end
    end
    if self.进度 == 2 then
        local map = 玩家:取地图(1110)
        if not map then
            return
        end
        self.坐标.x, self.坐标.y = map:取随机坐标()
        if not self.坐标.x then
            return
        end
        self.NPC =
            map:添加NPC {
                队伍 = self.队伍,
                名称 = '逍遥生的替身',
                时长 = 1800,
                外形 = 1,
                脚本 = 'scripts/task/日常/日常_五环任务.lua',
                时间 = self.时间,
                X = self.坐标.x,
                Y = self.坐标.y,
                来源 = self
            }
        self.MAP = map.id
    elseif self.进度 == 3 then
        local map = 玩家:取地图(1110)
        if not map then
            return
        end
        self.坐标.x, self.坐标.y = map:取随机坐标()
        if not self.坐标.x then
            return
        end
        self.NPC =
            map:添加NPC {
                队伍 = self.队伍,
                名称 = 'PK狂',
                时长 = 1800,
                外形 = 45,
                脚本 = 'scripts/task/日常/日常_五环任务.lua',
                时间 = self.时间,
                X = self.坐标.x,
                Y = self.坐标.y,
                来源 = self
            }
        self.MAP = map.id
    elseif self.进度 == 4 then
        local map = 玩家:取地图(1173)
        if not map then
            return
        end
        self.坐标.x, self.坐标.y = map:取随机坐标()
        if not self.坐标.x then
            return
        end
        self.NPC =
            map:添加NPC {
                队伍 = self.队伍,
                名称 = '虎头怪的替身',
                时长 = 1800,
                外形 = 9,
                脚本 = 'scripts/task/日常/日常_五环任务.lua',
                时间 = self.时间,
                X = self.坐标.x,
                Y = self.坐标.y,
                来源 = self
            }
        self.MAP = map.id
    elseif self.进度 == 5 then
        local map = 玩家:取地图(1173)
        if not map then
            return
        end
        self.坐标.x, self.坐标.y = map:取随机坐标()
        if not self.坐标.x then
            return
        end
        self.NPC =
            map:添加NPC {
                队伍 = self.队伍,
                名称 = '惯骗',
                时长 = 1800,
                外形 = 43,
                脚本 = 'scripts/task/日常/日常_五环任务.lua',
                时间 = self.时间,
                X = self.坐标.x,
                Y = self.坐标.y,
                来源 = self
            }
        self.MAP = map.id
    elseif self.进度 == 6 then
        local map = 玩家:取地图(1193)
        if not map then
            return
        end
        self.坐标.x, self.坐标.y = map:取随机坐标()
        if not self.坐标.x then
            return
        end
        self.NPC =
            map:添加NPC {
                队伍 = self.队伍,
                名称 = '祭剑魂的替身',
                时长 = 1800,
                外形 = 62,
                脚本 = 'scripts/task/日常/日常_五环任务.lua',
                时间 = self.时间,
                X = self.坐标.x,
                Y = self.坐标.y,
                来源 = self
            }
        self.MAP = map.id
    elseif self.进度 == 7 then--食婴鬼手下的手下
    elseif self.进度 == 8 then
        local map = 玩家:取地图(1116)
        if not map then
            return
        end
        self.坐标.x, self.坐标.y = map:取随机坐标()
        if not self.坐标.x then
            return
        end
        self.NPC =
            map:添加NPC {
                队伍 = self.队伍,
                名称 = '舞天姬的替身',
                时长 = 1800,
                外形 = 16,
                脚本 = 'scripts/task/日常/日常_五环任务.lua',
                时间 = self.时间,
                X = self.坐标.x,
                Y = self.坐标.y,
                来源 = self
            }
        self.MAP = map.id
    elseif self.进度 == 9 then
        local map = 玩家:取地图(1116)
        if not map then
            return
        end
        self.坐标.x, self.坐标.y = map:取随机坐标()
        if not self.坐标.x then
            return
        end
        self.NPC =
            map:添加NPC {
                队伍 = self.队伍,
                名称 = '盗号贼',
                时长 = 1800,
                外形 = 44,
                脚本 = 'scripts/task/日常/日常_五环任务.lua',
                时间 = self.时间,
                X = self.坐标.x,
                Y = self.坐标.y,
                来源 = self
            }
        self.MAP = map.id
    end
end

function 任务:掉落包(玩家)
end

local 对话 = {
[[我在这里练级,打了好久都打不过夜叉和猪怪#54你有没有装备送我一件嘛#17
menu
刚好我这里有,送你啦
等我找到你要的东西再来找你
]],
[[我被人吃香点了#52我正在路上跑着的时候突然有人点了我,以下我就到小白那里去了#52我都没惹人#52那人就在附近,技能不能帮我出这口恶气#55
menu
我帮你出气
我可不敢,万一再点了我呢
]],
[[你就是欺负新人的家伙吧#55跟你没什么好说的,咱们刀下说话#4
menu
看刀
路过
]],
[[我被人骗了,有人骗走了我20万两银子,那可是我所有的钱呀#52大侠以后你一定要小心这种人啊！
menu
实在可恶,我去帮你讨个说法
我会小心的
]],
[[听说你骗走了虎头怪的钱？你可真行啊，20万银子都能看得上。
menu
替天行道
准备准备
]],
[[大侠我想过称#17但是杀不过，死了好几次#15你能不能帮我杀了食婴鬼手下的手下啊！
menu
小事一桩
我也不是对手
]],
[[食婴鬼手下的手下,应该是食婴鬼的孙子辈吧....
menu
打这孙子
准备准备
]],
[[我的号给人洗了#52那人正在世界上喊卖我的装备和石头,你能不能帮我把东西要回来？大侠你一定要小心那些盗号贼，最好绑上将军令啊！
menu
我去帮你教训他
我的号非常安全
]],
[[你身上果然有很多来历不明的东西，看我今天怎么收拾你
menu
教他做人
准备准备
]],
}

function 任务:计算奖励(玩家)
    local 银两 = 200000
    local 师门 = 300000
    local 经验 = 1600000
    local 等级 = 玩家.等级
    local 活力 = 玩家.活力
    if 等级 >= 140 then
        等级 = 140
    end
    银两 = 银两 + (等级 - 80) * 2000
    师门 = 师门 + (等级 - 80) * 3000
    经验 = 经验 + (等级 - 80) * 25000
    local 收益 = 1 - 活力 / 200 / 10
    if 收益 > 1 then
        收益 = 1
    end
    if 收益 < 0.1 then
       收益 = 0.1
    end
    if 活力 >= 1800 then
        收益 = 1
    end
    if 收益 < 1 then
        local 百分比 = 收益 * 10
        玩家:提示窗口('#Y由于你的活力不足1800,当前仅可获得#G'..百分比..'%的金钱收益')
    end
    银两 = math.floor(银两 * 收益)
    return 银两,师门,经验
end

function 任务:NPC对话(玩家)
    if self.来源 then
        if 对话[self.来源.进度] then
            local r = 玩家:取任务('日常_五环任务')
            if r and r.NPC == self.来源.NPC then
                return 对话[self.来源.进度]
            end
            return '我认识你么？'
        end
    end
end

function 任务:NPC菜单(玩家, i)
    local r = 玩家:取任务('日常_五环任务')
    if i == '刚好我这里有,送你啦' then
        玩家:打开给予窗口(self.nid)
    elseif i == '我帮你出气' then
        if r then
            r:更新进度(玩家)
        end
    elseif i == '看刀' then
        local z = 玩家:进入战斗('scripts/task/日常/日常_五环任务.lua',self)
        if z then
            if r then
                local 银两 , 师门 , 经验 = r:计算奖励(玩家)
                玩家:添加银子(银两)
                玩家:添加师贡(师门)
                玩家:添加任务经验(经验,'五环')
                r:更新进度(玩家)
                r.次数 = r.次数 + 1
            end
        end
    elseif i == '实在可恶,我去帮你讨个说法' then
        if r then
            r:更新进度(玩家)
        end
    elseif i == '替天行道' then
        local z = 玩家:进入战斗('scripts/task/日常/日常_五环任务.lua',self)
        if z then
            if r then
                local 银两 , 师门 , 经验 = r:计算奖励(玩家)
                玩家:添加银子(银两)
                玩家:添加师贡(师门)
                玩家:添加任务经验(经验,'五环')
                r:更新进度(玩家)
                r.次数 = r.次数 + 1
            end
        end
    elseif i == '小事一桩' then
        if r then
            r:更新进度(玩家)
        end
    -- elseif i == '打这孙子' then
    --     local z = 玩家:进入战斗('scripts/task/日常/日常_五环任务.lua',self)
    --     if z then
    --         if r then
    --             local 银两 , 师门 , 经验 = r:计算奖励(玩家)
    --             玩家:添加银子(银两)
    --             玩家:添加师贡(师门)
    --             玩家:添加任务经验(经验,'五环')
    --             r:更新进度(玩家)
    --             r.次数 = r.次数 + 1
    --         end
    --     end
    elseif i == '我去帮你教训他' then
        if r then
            r:更新进度(玩家)
        end
    elseif i == '教他做人' then
        local z = 玩家:进入战斗('scripts/task/日常/日常_五环任务.lua',self)
        if z then
            if r then
                local 银两 , 师门 , 经验 = r:计算奖励(玩家)
                玩家:添加银子(银两)
                玩家:添加师贡(师门)
                玩家:添加任务经验(经验,'五环')
                r:更新进度(玩家)
                r:完成(玩家)
                r.次数 = r.次数 + 1
            end
        end
    end
end

function 任务:任务NPC给予(玩家, NPC, cash, items)
    if self.进度 == 1 then
        if items[1] then
            if items[1].名称 == self.装备 then
                if items[1].数量 >= 1 then
                    items[1]:接受(1)
                    local 银两 , 师门 , 经验 = self:计算奖励(玩家)
                    玩家:添加银子(银两)
                    玩家:添加师贡(师门)
                    玩家:添加任务经验(经验,'五环')
                    self:更新进度(玩家)
                end
            end
        end
    end
end

local _怪物 = {
    {},
    {},
    {名称 = 'PK狂' , 外形 = 45 , 血初值 = 1100, 法初值 = 100, 攻初值 = 80, 敏初值 = 100,技能={{名称='天诛地灭',熟练度=6000},{名称='电闪雷鸣',熟练度=6000}},施法几率 = 50},
    {},
    {名称 = '惯骗' , 外形 = 43 , 血初值 = 1100, 法初值 = 100, 攻初值 = 80, 敏初值 = 100,技能={{名称='阎罗追命',熟练度=6000},{名称='销魂蚀骨',熟练度=6000}},施法几率 = 50},
    {},
    {名称 = '食婴鬼手下的手下' , 外形 = 2017 , 血初值 = 1100, 法初值 = 100, 攻初值 = 180, 敏初值 = 100},
    {},
    {名称 = '盗号贼' , 外形 = 44 , 血初值 = 1100, 法初值 = 100, 攻初值 = 80, 敏初值 = 100,技能={{名称='袖里乾坤',熟练度=6000},{名称='风雷涌动',熟练度=6000}},施法几率 = 50},
}


function 任务:战斗初始化(玩家, NPC)
    local r = 玩家:取任务('日常_五环任务')
    if r then
        if _怪物[r.进度] then
            _怪物[r.进度].等级 = 玩家.等级
            self:加入敌方(1, 生成战斗怪物(生成怪物属性(_怪物[r.进度]),'中等'))
        end
    end
end

function 任务:战斗回合开始(dt)
end

function 任务:战斗结束(x, y)
end

return 任务
