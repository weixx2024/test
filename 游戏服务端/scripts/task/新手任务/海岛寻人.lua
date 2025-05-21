local _地图 = { 1213 }
local _怪信息 = {
    { name = '大夫', 外形 = 3002 },
    { name = '郎中', 外形 = 3001 },
    { name = '书生', 外形 = 3022 },
    { name = '大婶', 外形 = 3020 },
    { name = '老板', 外形 = 3004 }
}
local 任务 = {
    名称 = '海岛寻人',
    类型 = '新手任务'
}

function 任务:任务初始化()
end

function 任务:任务取详情(玩家)
    if self.NPC then
        return string.format('#Y任务目的:#r#W去#Y%s#W找#G#u%s#W#u(剩余%d分钟)', self.位置, self.怪名,
            (self.时间 - os.time()) // 60)
    end
    return string.format('由于行动迟缓，#Y%s#W已经逃之夭夭了。\n', self.怪名)
end

function 任务:任务取消(玩家)
    local map = 玩家:取地图(self.MAP)
    if map then
        local NPC = map:取NPC(self.NPC)
        if NPC then
            NPC.人数 = NPC.人数 - 1
            if NPC.人数 <= 0 then
                map:删除NPC(self.NPC)
            end
        end
    end
end

function 任务:任务上线(玩家)
    local map = 玩家:取地图(self.MAP)
    if map then
        local NPC = map:取NPC(self.NPC)
        if not NPC then
            self:删除()
        end
    end
end

function 任务:生成怪物(玩家)
    local map = 玩家:取随机地图(_地图)
    local xz = math.random(#_怪信息)
    if not map then
        return
    end

    self.怪名 = _随机名称(1) .. _怪信息[xz].name
    local X, Y = map:取随机坐标() --真坐标

    if not X then
        return
    end
    self.位置 = string.format('%s(%d,%d)', map.名称, X, Y)
    self.队伍 = {}
    if 玩家.是否组队 then
        for k, v in 玩家:遍历队伍() do
            table.insert(self.队伍, v.nid)
            v:添加任务(self)
        end
    else
        玩家:添加任务(self)
    end
    self.时间 = os.time() + 30 * 60
    self.NPC =
    map:添加NPC {
        队伍 = self.队伍,
        人数 = #self.队伍,
        名称 = self.怪名,
        外形 = _怪信息[xz].外形,
        脚本 = 'scripts/task/新手任务/海岛寻人.lua',
        时间 = self.时间,
        X = X,
        Y = Y,
        来源 = self
    }

    self.MAP = map.id
    return true
end

function 任务:完成(玩家)
    local r = 玩家:取任务('海岛寻人')
    if 玩家.是否组队 then
        if r then
            for _, v in 玩家:遍历队伍() do
                local rr = v:取任务('海岛寻人')
                if rr and r.nid == rr.nid then
                    rr:删除()
                    if v:判断等级是否低于(30, 0) then
                        self:掉落包(v)
                    end
                end
            end
        end
        for _, nid in ipairs(self.队伍) do
            local r = 玩家:取玩家(nid)
            if r then
                local w = 玩家:取任务('海岛寻人')
                if w then
                    w:删除()
                end
            end
        end
    elseif r then
        self:删除()
        if 玩家:判断等级是否低于(30, 0) then --等级, 转生, 飞升
            self:掉落包(玩家)
        end
    end

    local map = 玩家:取地图(self.MAP)
    if map then
        map:删除NPC(self.NPC)
    end
end

function 任务:掉落包(玩家)
    local 经验 = 玩家.等级 * 689
    玩家:添加银子(100)
    玩家:添加任务经验(经验, "海盗寻人")
end

--=========================NPC======================================
local 对话 = [[最近发现珊瑚海岛上有怪物出没，你还尽快回村吧。
menu
]]

function 任务:NPC对话(玩家, i)
    local r = 玩家:取任务('海岛寻人')
    if r and r.nid == self.来源.nid then
        self.来源:完成(玩家)
        玩家:打开对话(对话, 玩家.原形)
        return
    end
    return '我认识你么？#24'
end

function 任务:NPC菜单(玩家, i)
end

--=========================怪物信息======================================
return 任务
