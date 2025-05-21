local 角色 = require('角色')

function 角色:取简要数据() --地图对象
    local 称谓 = self.称谓
    if self.当前地图.是否帮战 then
        称谓 = string.format("%s成员", self.帮派)
    end
    if self.当前地图.是否大闹 then
        local r = self:任务_获取("大闹天宫")
        if r then
            称谓 = string.format("%s", r.阵营 == 1 and "花果山" or "天庭")
        end
    end
    return {
        type = 'play',
        nid = self.nid,
        名称 = self.名称,
        名称颜色 = self.名称颜色,
        称谓 = 称谓,
        头像 = self.头像,
        外形 = self.外形,
        x = self.x,
        y = self.y,
        方向 = self.方向,
        是否战斗 = self.是否战斗,
        是否观战 = self.是否观战,
        是否交易 = self.是否交易,
        是否队长 = self.是否队长,
        是否移动 = self.是否移动,
        是否摆摊 = self.是否摆摊,
        状态 = self.状态, --头顶
        队长 = self.队长,
        队友 = self.队友,
        队伍位置 = self.队伍位置,
        神行符 = self.神行符
    }
end

function 角色:取登录数据()
    local r = {
        nid = self.nid,
        id = self.id,
        名称 = self.名称,
        名称颜色 = self.名称颜色,
        称谓 = self.称谓,
        头像 = self.头像,
        原形 = self.头像,
        外形 = self.外形,
        x = self.x,
        y = self.y,
        地图 = self.地图,
        方向 = self.方向,
        气血 = self.气血,
        魔法 = self.魔法,
        经验 = self.经验,
        最大气血 = self.最大气血,
        最大魔法 = self.最大魔法,
        最大经验 = self.最大经验,
        是否战斗 = self.是否战斗,
        是否观战 = self.是否观战,
        是否交易 = self.是否交易,
        是否队长 = self.是否队长,
        是否组队 = self.是否组队,
        是否摆摊 = self.是否摆摊,
        状态 = self.状态, --头顶
        队长 = self.队长,
        队友 = self.队友,
        队伍位置 = self.队伍位置,
        神行符 = self.神行符
    }
    if self.参战召唤 then
        r.召唤 = self.参战召唤:取界面数据()
    end
    r.BUFF = self:任务_取BUFF列表()
    --todo取队伍数据
    return r
end

function 角色:取人物状态数据()
    return {
        头像 = self.头像,
        气血 = self.气血,
        最大气血 = self.最大气血,
        魔法 = self.魔法,
        最大魔法 = self.最大魔法,
        经验 = self.经验,
        最大经验 = self
            .最大经验
    }
end

function 角色:取抗性数据()
    local r = {}
    for _, k in pairs(require('数据库/抗性库')) do
        if self.抗性[k] ~= 0 then
            r[k] = self.抗性[k]
        end
    end
    return r
end

function 角色:角色_取今生属性()
    local r = {
        名称 = self.名称,
        头像 = self.头像,
        性别 = self.性别,
        种族 = self.种族,
        根骨 = self.根骨,
        灵性 = self.灵性,
        力量 = self.力量,
        敏捷 = self.敏捷,
        转生 = self.转生,
        转生记录 = self.转生记录
    }
    return r
end

function 角色:角色_取战斗模型()
    -- if self.管理 == 1 then
    --     return 38
    -- end
    local r = self:任务_获取("变身卡")
    if r and r.是否变身 and r.外形 then
        return r.外形
    end
    if self.武器 and self.武器 ~= 0 then
        return self.武器
    end
    return self.原形
end

function 角色:角色_取转生()
    return self.转生
end

function 角色:角色_取仙玉()
    return self.仙玉
end

function 角色:角色_取银子()
    return self.银子
end

function 角色:角色_取师贡()
    return tonumber(self.师贡) or 0
end

function 角色:取角色管理数据()
    return {
        id = self.id,
        登录地址 = self.登录地址,
        封禁 = self.封禁,
        禁言 = self.禁言,
        禁交易 = self.禁交易,
        VIP = self.VIP,
        存银 = self.存银,
        银子 =
            self.银子,
        转生 = self.转生,
        等级 = self.等级,
        名称 = self.名称,
        创建时间 = self.创建时间,
    }
end

function 角色:角色_取等级排行()
    return __等级排行, self.转生 .. "转" .. self.等级 .. "级", self.nid
end

function 角色:角色_取财富排行()
    return __财富排行, self.银子, self.nid
end

function 角色:角色_取VIP等级()
    return self.VIP
end

function 角色:角色_下战书(对象名称, 银子)
    local P
    if not 对象名称 then return "#Y请输入要决斗的角色名称" end

    local 角色 = __存档.按名称查询角色(对象名称)
    if 角色 and 角色.nid then
        P = __玩家[角色.nid]
    end
    if not P then
        return "#Y角色不在线"
    end
    -- self.其它.皇宫挑战 = nil
    -- P.其它.皇宫挑战 = nil

    self:角色_扣除银子(100000)
    if type(银子) == "number" and 银子 > 0 then
        self:角色_扣除银子(银子)
    end
    local txt = self.名称 .. "在皇宫挑战你" .. "，" .. 银子 .. "银子，接受挑战吗？"
    self.其它.皇宫挑战 = { 发起者名称 = self.名称, 发起者nid = self.nid, 银子 = 银子, 挑战名称 = 对象名称, 挑战对象nid = 角色.nid, 接受 = true }
    P.其它.皇宫挑战 = { 发起者名称 = self.名称, 发起者nid = self.nid, 银子 = 银子, 挑战名称 = P.名称, 挑战对象nid = P.nid, 接受 = false }
    self:角色_发送好友信息({ 角色.nid, txt })
    local txt1 = self.名称 .. "在皇宫挑战" .. P.名称 .. "大家快来观看！~"
    __世界:发送公告(txt1)
    return true
end

function 角色:战斗_结束_皇宫挑战(玩家, 胜利)
    if 胜利 == 2 then --胜利
        if 玩家.是否组队 and 玩家.是否队长 then
            if 玩家.其它.皇宫挑战 and type(玩家.其它.皇宫挑战) == "table" and 玩家.其它.皇宫挑战.银子 > 0 then
                玩家.接口:添加银子(玩家.其它.皇宫挑战.银子 * 2)
            end
        else
            if 玩家.其它.皇宫挑战 and type(玩家.其它.皇宫挑战) == "table" and 玩家.其它.皇宫挑战.银子 > 0 then
                玩家.接口:添加银子(玩家.其它.皇宫挑战.银子 * 2)
            end
        end
    elseif 胜利 == 1 then --失败
        if 玩家.是否组队 and 玩家.是否队长 then
            玩家.接口:扣除经验(math.floor(玩家.经验 * 0.1))
            -- for _, v in self:遍历队友() do
            --     v.接口:扣除经验(math.floor(self.经验 * 0.3))
            -- end
        else
            玩家.接口:扣除经验(math.floor(玩家.经验 * 0.1))
        end
    end
end

function 角色:角色_取无限飞()
    return self.其它.无限飞
end

function 角色:修改等级(n)
    if type(n) ~= 'number' or math.abs(n) ~= n or math.floor(n) ~= n or n <= 0 then
        return
    end
    self.等级 = n
    self:刷新属性(1)
end

function 角色:修改转生(n)
    if type(n) ~= 'number' or math.abs(n) ~= n or math.floor(n) ~= n or n <= 0 then
        return
    end
    self.转生 = n > 3 and 3 or n
    self:刷新属性(1)
end

function 角色:修改银子(n)
    if type(n) ~= 'number' or math.abs(n) ~= n or math.floor(n) ~= n or n <= 0 then
        return
    end
    self.银子 = n
end

function 角色:修改VIP(n)
    if type(n) ~= 'number' or math.abs(n) ~= n or math.floor(n) ~= n or n <= 0 then
        return
    end
    self.VIP = n
end

function 角色:修改名称(v)
    self.名称 = v
    self.rpc:切换名称(self.nid, v)
    self.rpn:切换名称(self.nid, v)
    return true
end

function 角色:角色_取帮派排行()
    return __帮派排行, self.帮派
end

local _存档表 = require('数据库/存档属性_角色')
function 角色:取存档数据()
    local r = {}
    for _, k in ipairs { 'id', 'uid', 'nid', 'xid', '创建时间', '登录时间', '登出时间', '删除时间',
        '登录地址', '名称', '外形', '头像', '原形', '等级', '转生', '飞行', '性别', '种族', '帮派',
        '声望', '最大声望', '战绩', '最大战绩', '杀人数', '银子', '存银', 'VIP', '封禁', '禁言',
        '师贡',
        '禁交易' } do
        r[k] = self[k]
    end
    r.数据 = self.数据
    for _, k in ipairs { '宠物', '技能', '任务', '物品', '召唤', '孩子', '坐骑', '法宝' } do
        local t = {}
        for _, v in pairs(self[k]) do
            t[v.nid] = v:取存档数据(self)
        end
        r[k] = t
    end

    for _, v in pairs(self.装备) do
        local t = v:取存档数据(self)
        t.位置 = t.位置 | 256
        r.物品[v.nid] = t
    end

    for _, v in pairs(self.仓库) do
        local t = v:取存档数据(self)
        t.位置 = t.位置 | 512
        r.物品[v.nid] = t
    end

    for _, v in pairs(self.召唤仓库) do
        local t = v:取存档数据(self)
        t.数据.存放 = true
        r.召唤[v.nid] = t
    end
    for _, v in ipairs(self.法宝佩戴) do
        local t = v:取存档数据(self)
        r.法宝[v.nid] = t
    end
    for _, v in self:遍历孩子() do
        for i, v in pairs(v.装备) do
            local t = v:取存档数据(self)
            t.位置 = t.位置 | 1024
            r.物品[v.nid] = t
        end
    end
    return r
end

function 角色:加载存档(t) --加载存档的表
    rawset(self, '数据', t.数据)
    t.数据 = nil
    for k, v in pairs(t) do
        self[k] = v
    end

    for k, v in pairs(_存档表) do
        if type(v) == 'table' and type(self[k]) ~= 'table' then
            self[k] = {}
        end
    end
    self.其它 = __容错表(self.其它)
    if self.转生 == 0 then
        self.其它.卡集容量 = 30
    elseif self.转生 == 1 then
        self.其它.卡集容量 = 40
    else
        self.其它.卡集容量 = 50
    end
    setmetatable(self.数据, { __index = _存档表 })
    if not next(self.作坊) then
        self.作坊 = {
            { 名称 = "步摇坊", 熟练度 = 0, 段位 = 0, 等级 = 0, 成就 = 0 },
            { 名称 = "湛卢坊", 熟练度 = 0, 段位 = 0, 等级 = 0, 成就 = 0 },
            { 名称 = "七巧坊", 熟练度 = 0, 段位 = 0, 等级 = 0, 成就 = 0 },
            { 名称 = "生莲坊", 熟练度 = 0, 段位 = 0, 等级 = 0, 成就 = 0 },
            { 名称 = "同心坊", 熟练度 = 0, 段位 = 0, 等级 = 0, 成就 = 0 },
            { 名称 = "炼器坊", 熟练度 = 0, 段位 = 0, 等级 = 0, 成就 = 0 },
        }
    end

    return t
end
