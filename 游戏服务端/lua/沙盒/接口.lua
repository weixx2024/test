local require = require
local setmetatable = setmetatable
local __世界 = __世界
local __脚本 = __脚本
local __地图 = __地图
local __存档 = __存档
local __事件 = __事件
local __帮战 = __帮战
local __复制表 = __复制表
local __取召唤技能数值 = __取召唤技能数值
local __副本地图 = __副本地图
local ggexpcall = ggexpcall
local _装备生成 = require('数据库/装备生成')
local _孩子装备生成 = require('数据库/装备生成_孩子')
local _召唤库 = __召唤库
local _法宝库 = require('数据库/法宝库')
local _孩子库 = require('数据库/孩子信息库').孩子库
local _坐骑库 = require('数据库/坐骑信息库')
-- local __大闹天宫 = __大闹天宫
local _ENV = require('沙盒/沙盒')
_随机名称 = require('数据库/随机名称')
local 随机可食用 = __脚本['scripts/make/随机变色参数.lua'] 
_大理寺题库 = require('数据库/大理寺题库')
_仙器名称表 = require('数据库/装备信息库').仙器名称表
_变身卡库 = __脚本['scripts/make/变身卡库.lua']
_符文属性 = require('数据库/符文属性')
local _机器人生成 = require('数据库/机器人生成')
local _文曲题库 = require('数据库/文曲题目')

function _随机可食用(n,k)
    local name = "兔妖"
    if n == 1 then -- 可食用元气丹 变色丹
        name = 随机可食用.可食用召唤兽[math.random(1,#随机可食用.可食用召唤兽)]
    elseif n == 2 then -- 元气丹
        name = 随机可食用.元气蛋唤兽[math.random(1,#随机可食用.元气蛋唤兽)]
    elseif n == 3 then
        return 随机可食用.元气丹成长[k]
    end
    return name
end

function 复制表(t)
    return __复制表(t)
end

function 取事件(名称)
    return __事件[名称]
end

function 取帮战战斗开关()
    return __帮战:能否PK()
end

-- function 阵营分配_大闹天宫(n)
--     return __大闹天宫:阵营分配(n)
-- end

-- function 能否进场_大闹天宫(n)
--     return __大闹天宫:能否进场()
-- end

-- function 扣除箭塔耐久(数值, 路, 阵营)
--     return __大闹天宫:扣除箭塔耐久(数值, 路, 阵营)
-- end

-- function 取箭塔耐久_大闹(阵营, 路)
--     return __大闹天宫:取箭塔耐久(阵营, 路)

-- end

function 按名称查询nid(name)
    return __存档.按名称查询角色(name)
end

function 按ID查询nid(ID)
    return __存档.按ID查询角色(ID)
end

function 是否白天()
    return __世界:是否白天()
end

function 是否黑夜()
    return not __世界:是否白天()
end

function 打印信息(...)
    __世界:print(...)
end

function 发送公告(...)
    __世界:发送公告(...)
end

function 发送系统(...)
    __世界:发送系统(...)
end

function 发送世界(...)
    __世界:发送世界(...)
end

function 检测名称(名称)
    return __存档.检测名称(名称)
end

function 取随机玩家(nid)
    return __世界:取随机玩家(nid)
end

function 遍历帮派(...)
    return __世界:遍历帮派()
end

function 取召唤兽数元气丹据(n, k)
    return _随机可食用(n, k)
end

function 生成变身卡(t, ...)
    if type(t) == 'table' then
        if not _变身卡库[t.key] or not _变身卡库[t.key][t.属性id] then
            return
        end
        t = __复制表(t)
        t.是否变身卡 = true
        -- t.人物是否可用 = true
        local sj = _变身卡库[t.key][t.属性id]
        t.等级 = sj.等级
        t.外形 = sj.外形
        t.亲和力 = sj.亲和力
        t.种类 = sj.种类
        t.五行 = sj.五行
        t.附加 = sj.属性
        t.皮肤 = sj.皮肤
        t.介绍 = sj.介绍
        -- {name='飞鱼',皮肤=9002,外形=2032,分类='抗性',价格=1300,属性={{'法力',-1},{'力量',1},{'抗水',2}},等级=1,亲和力=5,种类='兽',五行={0,40,0,60,0}},
        local r = require('对象/物品/物品')(t)
        return r.接口
    end
end

function 生成符文(t, ...)
    if type(t) == 'table' then
        local 符文 = __复制表(_符文属性[t.名称])
        符文.是否符文 = true
        local r = require('对象/物品/物品')(符文)
        return r.接口
    end
end

function 生成孩子引导道具(t, ...)
    if type(t) == 'table' then
        t = __复制表(t)
        t.是否高级 = t.高级 == true
        local r = require('对象/物品/物品')(t)
        return r.接口
    end
end

-- function 生成宝石(t, ...)
--     if type(t) == 'table' then

--         t = __复制表(t)
--         t.是否变身卡 = true
--         local r = require('对象/物品/物品')(t)
--         local 脚本 = __脚本[r.脚本]
--         if 脚本 and 脚本.初始化 then
--             ggexpcall(脚本.初始化, r.接口, ...)
--         end
--         return r.接口
--     end
-- end

local _是否宝石 = {
    绿宝石 = true,
    神秘石 = true,
    符咒石 = true,
    智慧石 = true,
    月亮石 = true,
    太阳石 = true,
    黑宝石 = true,
    蓝宝石 = true,
    黄宝石 = true,
    红宝石 = true,
    光芒石 = true,
    赤焰石 = true,
    紫烟石 = true,
    孔雀石 = true,
    落星石 = true,
    沐阳石 = true,
    芙蓉石 = true,
    琉璃石 = true,
    寒山石 = true,
}
local _随机宝石 = {
    "绿宝石",
    "神秘石",
    "符咒石",
    "智慧石",
    "月亮石",
    "太阳石",
    "黑宝石",
    "蓝宝石",
    "黄宝石",
    "红宝石",
    "光芒石",
}

local _是否新宝石 = {
    赤焰石  = true,
    紫烟石  = true,
    孔雀石  = true,
    落星石  = true,
    沐阳石  = true,
    芙蓉石  = true,
    琉璃石  = true,
    寒山石  = true,
    奇异石  = true,
}
local _随机新宝石 = {
    '赤焰石',
    '紫烟石',
    '孔雀石',
    '落星石',
    '沐阳石',
    '芙蓉石', 
    '琉璃石',
    '寒山石',
    -- '奇异石',
}
local _随机炼妖石 = {
    "沧海珠",
    "蓝田玉",
    "烈焰砂",
    "灵犀角",
    "五溪散",
    "武帝袍",
    "霄汉鼎",
    "雪蟾蜍",
    "云罗帐",
    "盘古石",
}


function 生成物品(t, 玩家, ...)
    if type(t) == 'table' then
        t = __复制表(t)
        if (t.名称 == "元气丹" or t.名称 == "变色丹") and not t.参数 then
            t.参数 = _随机可食用(1)
        elseif _是否宝石[t.名称] then
            if not t.等级 then
                t.等级 = t.参数 or 1
            end
        elseif t.名称 == "灵兽蛋" and 玩家 then
            if not t.种族 then
                t.种族 = 玩家.种族
            end
            t.场次 = 0
        elseif t.名称 == "随机宝石" then
            t.名称 = _随机宝石[math.random(#_随机宝石)]
            if not t.等级 then
                t.等级 = t.参数 or 1
            end
        elseif t.名称 == "随机新宝石" and 玩家  then
            t.名称 = _随机新宝石[math.random(#_随机新宝石)]
            if not t.等级 then
                t.等级 = tonumber(t.参数) or 1              
            end   
            local 临时宝石 = 玩家:指定新宝石(t.名称,nil,t.等级)
            t.品质 = 临时宝石.品质
            t.宝石属性 = 临时宝石.类型
            t.宝石数值 = 临时宝石.数值
        elseif t.名称 == "随机神兵" then
            if not t.等级 then
                t.等级 = t.参数 or 1
            end
            return 随机神兵(t)
        elseif t.名称 == "随机炼妖" then
            t.名称 = _随机炼妖石[math.random(#_随机炼妖石)]
            if not t.参数 then
                t.参数 = t.等级 or 1
            end
        elseif t.名称 == "灵兽要诀" and t.参数 and t.参数 ~= "" then
            t.技能 = t.参数
        elseif t.孩子是否可用 then
            t.是否高级 = t.高级 == true
        end

        local r = require('对象/物品/物品')(t)
        local 脚本 = __脚本[r.脚本]
        if 脚本 and 脚本.初始化 then
            ggexpcall(脚本.初始化, r.接口, ...)
        end
        return r.接口
    end
end

function 批量生成物品(t, ...)
    if type(t) == 'table' then
        local 物品表 = {}
        for k, v in pairs(t) do
            table.insert(物品表, 生成物品(v))
        end
        return 物品表
    end
end

local _名称转换 = {
    符咒女娲守护 = '符咒女娲',
    火神女娲守护 = '火神女娲',
    复活女娲守护 = '复活女娲',

}
function 生成召唤(t)
    local 技能格子
    if type(t) == 'table' then
        local 原名 = t.名称
        if _名称转换[原名] then
            t.名称 = _名称转换[原名]
        end
        if not _召唤库[原名] then
            print('召唤不存在', 原名)
            return
        end
        if _召唤库[t.名称].类型 > 5 then
            技能格子 = {已开 = 2 , 封印 = 2 , 未开启 = 4 }
        elseif _召唤库[t.名称].类型 == 5 then
            技能格子 = {已开 = 2 , 封印 = 2 , 未开启 = 4 }
        else
            技能格子 = {已开 = 1 , 封印 = 2 , 未开启 = 5 }
        end
        if not t.捕捉 then --获取 1 封印之书
            t = setmetatable({
                原名 = 原名,
                名称 = t.名称,
                染色 = t.染色,
                获取 = t.获取,
                宝宝 = true,
                技能格子 = 技能格子,
                捕捉 = t.捕捉
            }
            , { __index = _召唤库[原名] })
        else
            local 原始 = _召唤库[原名]
            t = setmetatable({
                原名 = 原名,
                名称 = t.名称,
                染色 = t.染色,
                宝宝 = t.宝宝,
                等级 = t.等级 or 0,
                捕捉 = t.捕捉,
                技能格子 = 技能格子,
                成长 = math.floor(原始.成长 * math.random(80 * 10000, 100 * 10000) * 0.001) * 0.001,
                初血 = math.floor(原始.初血 * math.random(800, 1000) * 0.001),
                初法 = math.floor(原始.初法 * math.random(800, 1000) * 0.001),
                初攻 = math.floor(原始.初攻 * math.random(800, 1000) * 0.001),
                初敏 = math.floor(原始.初敏 * math.random(800, 1000) * 0.001),
            }, { __index = _召唤库[原名] })
        end
        return require('对象/召唤/召唤')(t).接口
    end
end

function 生成坐骑(t) --{种族=1,几座=1}
    if type(t) == 'table' then
        if not _坐骑库[t.种族] then
            print('坐骑种族不存在')
            return
        end
        t = setmetatable({}, { __index = _坐骑库[t.种族][t.几座] })
        return require('对象/坐骑/坐骑')(t).接口
    end
end

function 生成孩子(t) --{ 性別 = 1 }
    if type(t) == 'table' then
        if not t.性别 then
            t.性别 = math.random(2)
        end
        t = setmetatable({}, { __index = _孩子库[t.性别] })
        return require('对象/孩子/孩子')(t).接口
    end
end

function 生成法宝(t) --名称 等级
    if type(t) == 'table' then
        if not _法宝库[t.名称] then
            print('法宝不存在', t.名称)
            return
        end
        t = setmetatable({}, { __index = _法宝库[t.名称] })
        return require('对象/法宝/法宝')(t).接口
    end
end

local _武器 = { "金箍棒", "宣花斧", "盘古锤", "枯骨刀", "乾坤无定", "芭蕉扇", "八景灯", "多情环", "生死簿", "赤炼鬼爪", "毁天灭地", "搜魂钩", "混天绫", "索魂幡", "震天戟",
    "缚龙索", "斩妖剑", }
local _衣服 = { "锁子黄金甲", "五彩宝莲衣" }
local _帽子 = { "凤翅瑶仙簪", "紫金七星冠" }
local _项链 = { "混元盘金锁" }
local _鞋子 = { "藕丝步云履", "步定乾坤履" }
function 随机神兵(t)
    local 名称 = "魅影"
    local 几率 = math.random(12)
    if 几率 <= 5 then
        名称 = _武器[math.random(#_武器)]
    elseif 几率 <= 7 then
        名称 = _衣服[math.random(#_衣服)]
    elseif 几率 <= 9 then
        名称 = _帽子[math.random(#_帽子)]
    elseif 几率 <= 10 then
        名称 = _项链[math.random(#_项链)]
    else
        名称 = _鞋子[math.random(#_鞋子)]
    end
    local r = _装备生成.生成装备(名称, t.等级, t.序号)
    if r then
        return require('对象/物品/物品')(r).接口
    end
end

function 生成装备(t)
    if type(t) == 'table' then
        local r = _装备生成.生成装备(t.名称, t.等级, t.序号)
        if r then
            return require('对象/物品/物品')(r).接口
        end
    end
end

function 生成装备_孩子(t)
    if type(t) == 'table' then
        local r = _孩子装备生成.生成装备_孩子(t.名称)
        if r then
            return require('对象/物品/物品')(r).接口
        end
    end
end

function 生成任务(t, ...)
    if type(t) == 'table' then
        local r = require('对象/任务/任务')(t)
        local 脚本 = __脚本[r.脚本]
        if 脚本 and 脚本.任务初始化 then
            ggexpcall(脚本.任务初始化, r.接口, ...)
        end
        return r.接口
    end
end

function 生成战斗怪物(t)
    if type(t) == 'table' then
        t = __复制表(t)
        if not t.魔法 then --标记1
            t.魔法 = 1000
        end
        if not t.攻击 and t.伤害 then
            t.攻击 = t.伤害
            t.伤害 = nil
        end

        if t.等级 and t.初血 and t.初法 and t.初攻 and t.初敏 then
            t.气血 = math.ceil(t.等级 * (0.7 * t.初血 + t.等级) + t.初血)
            t.魔法 = math.ceil(t.等级 * (0.7 * t.初法 + t.等级) + t.初法)
            t.攻击 = math.ceil(t.等级 * (0.7 * t.初攻 + t.等级) * 0.2 + t.初攻)
            t.速度 = math.ceil(t.初敏 + t.等级)
        end
        assert(type(t.气血) == 'number', '气血不存在')
        assert(type(t.魔法) == 'number', '魔法不存在')
        assert(type(t.攻击) == 'number', '攻击不存在')
        assert(type(t.速度) == 'number', '速度不存在')
        return require('战斗/对象/怪物')(t)
    end
end

function 生成地图(id)
    if __地图[id] then
        local map = __地图[id]:生成副本()
        __副本地图[map.id] = map
        return map
    end
end

function 取地图(id)
    local map = __地图[id]
    return map and map.接口
end

function 取随机地图(t)
    if type(t) ~= 'table' then
        return
    end
    local map
    local n = 0
    repeat
        map = __地图[t[math.random(#t)]]
        n = n + 1
    until map or n > 100
    return map and map.接口
end

function 生成机器人(功能, t)
    if 功能 == '抓鬼' then
        local 机器人 = _机器人生成.生成抓鬼机器人(t)
        机器人:上线()
        return 机器人
    end
    if 功能 == '做天' then
        local 机器人 = _机器人生成.生成做天机器人(t)
        机器人:上线()
        return 机器人
    end
    if 功能 == '鬼王' then
        local 机器人 = _机器人生成.生成鬼王机器人(t)
        机器人:上线()
        return 机器人
    end
    if 功能 == '修罗' then
        local 机器人 = _机器人生成.生成修罗机器人(t)
        机器人:上线()
        return 机器人
    end
end

function 生成机器人new(t)
    local 机器人 = _机器人生成.生成通用机器人(t)
    机器人:上线()
    return 机器人
end

function 取默认五行(外形)
    local 五行 = { 金 = 0, 木 = 0, 水 = 0, 火 = 0, 土 = 0 }
    for k, v in pairs(_召唤库) do
        if v.外形 == 外形 then
            for q, w in pairs(五行) do
                五行[q] = v[q]
            end
        end
    end
    return 五行
end

function 取召唤技能数值(...)
    return __取召唤技能数值(...)
end

function 取文曲题目()
    local n = math.random(1, #_文曲题库)
    return _文曲题库[n]
end
