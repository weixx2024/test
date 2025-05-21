local 角色 = require('角色')
local 帮战积分 = __脚本["scripts/make/帮战积分.lua"]
function 角色:龙神帮战_更新(sec)
    -- self.复活标记 = nil
    if self.复活标记 then
        if self.复活标记 - os.time() <= 0 then
            self.复活标记 = nil
        end
    end
    --攻击城门
    if self.攻击城门 then
        if not self.攻击城门计时 then
            self.攻击城门计时 = 0
        end
        self.攻击城门计时 = self.攻击城门计时 + 1
        if self.攻击城门计时 >= 5 then
            self.攻击城门计时 = 0
            self.接口:添加指定积分(帮战积分.点城门无对战 or 1, "帮战积分")
            local 对手 = __帮派[self.帮派].帮战信息.敌对帮派
            if 对手 then
                __帮派[对手].帮战信息.显示信息.耐久 = __帮派[对手].帮战信息.显示信息.耐久 - 20     --对方城门掉血
                self.rpc:常规提示('#R攻击成功,敌方城门耐久-5')
                if __帮派[对手].帮战信息.显示信息.耐久 <= 0 then
                    __帮派[对手].帮战信息.显示信息.耐久 = 0
                end

                for k, v in self.当前地图:遍历玩家() do
                    v.rpc:更新信息(__帮派[对手].帮战信息.显示信息)
                end

                if __帮派[对手].帮战信息.显示信息.耐久 <= 0 then
                    __帮战:帮战结算(__帮派[self.帮派], __帮派[对手]) --胜者在前
                    self.rpc:设置禁止移动(false)
                    local 目标 = self.当前地图:取NPC(self.攻击城门)
                    if 目标 and 目标._数据.攻击者.nid then
                        if __玩家[目标._数据.攻击者.nid] then
                            __玩家[目标._数据.攻击者.nid].接口:设置取消攻击城门(目标._数据.攻击者.nid)
                        end
                        目标._数据.攻击者 = {}
                    end
                elseif __帮派[对手].帮战信息.显示信息.耐久 <= 1500 then
                    self:角色_能量塔切换动作('破损', self.攻击城门)
                end
            end
        end
    elseif self.攻击城门计时 then
        self.攻击城门计时 = nil
    end
    --操控大炮
    if self.操控大炮 then
        if not self.大炮计时 then
            self.大炮计时 = 0
        end
        self.大炮计时 = self.大炮计时 + 1
        if self.大炮计时 >= 60 then --大炮开炮间隔时间
            -- self:角色_开炮(self.操控大炮)
            --这里暂时无法获取城门的nid,放弃加特效
            -- for k,v in self.当前地图:遍历玩家() do
            --     v.rpc:添加特效(self.操控大炮 , '爆炸')
            -- end
            __帮派[self.帮派].帮战信息.显示信息.龙神大炮开炮次数 = __帮派[self.帮派].帮战信息.显示信息.龙神大炮开炮次数 + 1
            local 对手 = __帮派[self.帮派].帮战信息.敌对帮派
            if 对手 then
                __帮派[对手].帮战信息.显示信息.耐久 = __帮派[对手].帮战信息.显示信息.耐久 - 180     -- 这里 帮战的一炮伤害，改这里
                if __帮派[对手].帮战信息.显示信息.耐久 <= 0 then
                    __帮派[对手].帮战信息.显示信息.耐久 = 0
                end
                for k, v in self.当前地图:遍历玩家() do
                    v.rpc:更新信息(__帮派[对手].帮战信息.显示信息)
                end

                for k, v in __帮派[self.帮派]:遍历成员() do
                    if __玩家[k] then
                        __玩家[k].rpc:聊天框提示('#R我方操控龙神大炮命中敌方城门,耐久减少180')
                    end
                end
                for k, v in __帮派[对手]:遍历成员() do
                    if __玩家[k] then
                        __玩家[k].rpc:聊天框提示('#R我方城门被龙神大炮命中,耐久减少180')
                    end
                end

                if __帮派[对手].帮战信息.显示信息.耐久 <= 0 then
                    __帮战:帮战结算(__帮派[self.帮派], __帮派[对手]) --胜者在前
                end
            end
            local 目标 = self.当前地图:取NPC(self.操控大炮)
            if 目标 then
                目标._数据.操控者 = ''
            end
            self.接口:添加指定积分(帮战积分.操控大炮无对战 or 1, "帮战积分")
            self:角色_大炮攻击(self.操控大炮)
            self.大炮计时 = nil
            self.操控大炮 = nil
            self.rpc:设置禁止移动(false)
        end
    elseif self.大炮计时 then
        self.大炮计时 = nil
    end
    --火塔攻击
    if self.操作火塔 then
        if not self.火塔计时 then
            self.火塔计时 = 0
        end
        self.火塔计时 = self.火塔计时 + 1
        if self.火塔计时 >= 60 then
            self.火塔计时 = 0
            local 敌对列表 = {}
            for k, v in self.当前地图:遍历玩家() do
                if v.帮派 ~= self.帮派 and v.战场状态 and not v.是否战斗 and not v.操作火塔 and not v.操作冰塔 and not v.操控大炮 then
                    table.insert(敌对列表, v.nid)
                end
            end
            self.接口:添加指定积分(帮战积分.点塔无对战 or 1, "帮战积分")
            if #敌对列表 >= 1 then
                __帮派[self.帮派].帮战信息.显示信息.能量塔发动攻击数 = __帮派[self.帮派].帮战信息.显示信息.能量塔发动攻击数 + 1
                local 临时目标 = 敌对列表[math.random(1, #敌对列表)]
                for k, v in self.当前地图:遍历玩家() do
                    v.rpc:添加特效(临时目标, '爆炸')
                end
                if __玩家[临时目标] then
                    for _, v in __玩家[临时目标]:遍历队伍() do
                        v.复活标记 = os.time() + 120
                        v.rpc:提示窗口('#Y你不幸被火塔击中...')
                        v.战场状态 = nil
                    end
                    local map = __帮派[__玩家[临时目标].帮派].帮战信息.帮战地图
                    if map then
                        local 大本营 = __帮派[__玩家[临时目标].帮派].帮战信息.大本营
                        local 大本营坐标 = {
                            { x = math.floor(9 * 20), y = math.floor((map.高度 - 8) * 20) },
                            { x = math.floor(105 * 20), y = math.floor((map.高度 - 91) * 20) },
                        }
                        __玩家[临时目标]:移动_切换地图(map, 大本营坐标[大本营].x, 大本营坐标[大本营].y)
                    end
                end
            end
        end
    elseif self.火塔计时 then
        self.火塔计时 = nil
    end
    --冰塔攻击
    if self.操作冰塔 then --如果当前玩家处于操作冰塔状态
        if not self.冰塔计时 then
            self.冰塔计时 = 0
        end
        self.冰塔计时 = self.冰塔计时 + 1
        if self.冰塔计时 >= 30 then
            self.冰塔计时 = 0
            local 敌对列表 = {}
            for k, v in self.当前地图:遍历玩家() do
                if v.帮派 ~= self.帮派 and v.战场状态 and not v.是否战斗 and not v.操作火塔 and not v.操作冰塔 then
                    table.insert(敌对列表, v.nid)
                end
            end
            self.接口:添加指定积分(帮战积分.点塔无对战 or 1, "帮战积分")
            if #敌对列表 >= 1 then
                __帮派[self.帮派].帮战信息.显示信息.能量塔发动攻击数 = __帮派[self.帮派].帮战信息.显示信息.能量塔发动攻击数 + 1
                local 临时目标 = 敌对列表[math.random(1, #敌对列表)]
                for k, v in self.当前地图:遍历玩家() do
                    v.rpc:冻结玩家(临时目标, true)
                end
                if __玩家[临时目标] then
                    __玩家[临时目标].冰冻状态 = os.time()
                end
            end
        end
    elseif self.冰塔计时 then
        self.冰塔计时 = nil
    end
  
    if self.冰冻状态 then
        if os.time() - self.冰冻状态 >= 10 then
            self.冰冻状态 = nil
            for k, v in self.当前地图:遍历玩家() do
                v.rpc:冻结玩家(self.nid, false)
            end
        end
    end
    if self.攻击塔 then
        local 目标 = self.当前地图:取对象(self.攻击塔)
        if 目标 then
            if not self.攻击塔计时 then
                self.攻击塔计时 = 0
            end
            self.攻击塔计时 = self.攻击塔计时 + 1
            if self.攻击塔计时 >= 5 then
                self.攻击塔计时 = 0
                if 目标._数据.耐久 then
                    self.接口:添加指定积分(帮战积分.点塔无对战 or 1, "帮战积分")
                    目标._数据.耐久 = 目标._数据.耐久 - 2
                    for k, v in self.当前地图:遍历玩家() do
                        v.rpc:添加特效(self.攻击塔, '攻击特效')
                    end
                    self.rpc:提示窗口('#Y攻击成功,能量塔耐久-2,剩余耐久' .. 目标._数据.耐久)
                    if 目标._数据.耐久 <= 0 then
                        self.攻击塔 = nil
                        self.攻击塔计时 = nil
                        self.rpc:设置禁止移动(false)

                        if 目标._数据.守护者.nid then
                            if __玩家[目标._数据.守护者.nid] then
                                __玩家[目标._数据.守护者.nid].接口:设置取消操作冰塔(目标._数据.守护者.nid)
                            end
                        end
                        if 目标._数据.攻击者.nid then
                            if __玩家[目标._数据.攻击者.nid] then
                                __玩家[目标._数据.攻击者.nid].接口:设置取消攻击塔(目标._数据.攻击者.nid)
                            end
                        end
                        目标._数据.攻击者 = {}
                        目标._数据.守护者 = {}
                    elseif 目标._数据.耐久 <= 200 then
                        self:角色_能量塔切换动作('破损', self.攻击塔)
                    end
                end
            end
        end
    elseif self.攻击塔计时 then
        self.攻击塔计时 = nil
    end
end
--触发PK 就不分 点塔 还是自己互殴 了？ 现在没有区分 因为点他 切磋还是 直接切磋 PK 胜败算
function 角色:帮战进入战斗(nid)
    local 玩家 = __玩家[nid]
    if 玩家 then
        coroutine.xpcall(
            function()
                self:进入PK战斗(玩家, 3)
            end
        )
    end
end

function 角色:帮战进入挑战(nid)
    local 玩家 = __玩家[nid]
    if 玩家 then
        coroutine.xpcall(
            function()
                self:进入PK战斗(玩家, 3.1)
            end
        )
    end
end

function 角色:角色_取帮战状况()
    if self.帮派 and __帮派[self.帮派] and __帮派[self.帮派].帮战信息 then
        local 我方信息 = __帮派[self.帮派].帮战信息.显示信息
        local 本人杀敌 = 我方信息.个人杀敌[self.nid] or 0
        我方信息.本人杀敌 = 本人杀敌
        local 最多杀敌 = ''
        local 最多杀敌数 = 0
        for k, v in pairs(我方信息.个人杀敌) do
            if v > 最多杀敌数 then
                最多杀敌数 = v
                最多杀敌 = k
            end
        end
        if __玩家[最多杀敌] then
            最多杀敌 = __玩家[最多杀敌].名称
        end
        if 最多杀敌 == '' then
            我方信息.本帮杀敌最高成员 = ''
        else
            我方信息.本帮杀敌最高成员 = 最多杀敌 .. '(' .. 最多杀敌数 .. '场)'
        end
        local 人数 = 0
        for k, v in self.当前地图:遍历玩家() do
            if v.帮派 == self.帮派 then
                人数 = 人数 + 1
            end
        end
        我方信息.帮派目前参战成员 = 人数
        local 对手 = __帮派[self.帮派].帮战信息.敌对帮派
        local 敌方信息 = __帮派[对手].帮战信息.显示信息
        local 本人杀敌 = 0
        敌方信息.本人杀敌 = 本人杀敌
        local 最多杀敌 = ''
        local 最多杀敌数 = 0
        for k, v in pairs(敌方信息.个人杀敌) do
            if v > 最多杀敌数 then
                最多杀敌数 = v
                最多杀敌 = k
            end
        end
        if __玩家[最多杀敌] then
            最多杀敌 = __玩家[最多杀敌].名称
        end
        if 最多杀敌 == '' then
            敌方信息.本帮杀敌最高成员 = ''
        else
            敌方信息.本帮杀敌最高成员 = 最多杀敌 .. '(' .. 最多杀敌数 .. ')'
        end
        local 人数 = 0
        for k, v in self.当前地图:遍历玩家() do
            if v.帮派 ~= self.帮派 then
                人数 = 人数 + 1
            end
        end
        敌方信息.帮派目前参战成员 = 人数

        return 我方信息, 敌方信息
    end
end

function 角色:角色_还原龙神大炮(nid, tnid)
    local npc = self.周围NPC[nid]
    if npc then
        for _, P in self.当前地图:遍历玩家() do
            if P then
                P.rpc:修改动作(nid, 'stand')
            end
        end
    end
    if __玩家[tnid] then
        __玩家[tnid].操控大炮 = nil
        __玩家[tnid].rpc:设置禁止移动(false)
    end
end

function 角色:角色_上方开炮(nid)
    local npc = self.周围NPC[nid]
    
    if npc then
        for _, P in self.当前地图:遍历玩家() do
            if P then
                P.rpc:修改动作(nid, '上移动')
            end
        end
    end
end

function 角色:角色_开炮(nid)
    local npc = self.周围NPC[nid]
    if npc then
        for _, P in self.当前地图:遍历玩家() do
            if P then
                P.rpc:修改动作(nid, '开炮')
            end
        end
    end
end

function 角色:角色_下方开炮(nid)
    local npc = self.周围NPC[nid]
    if npc then
        for _, P in self.当前地图:遍历玩家() do
            if P then
                P.rpc:修改动作(nid, '下移动')
            end
        end
    end
end



function 角色:角色_大炮攻击(nid)
    local 大本营 = __帮派[self.帮派].帮战信息.大本营
    local 动作 = '下开炮'
    if 大本营 == 1 then
        动作 = '上开炮'
    end
    local npc = self.周围NPC[nid]
    if npc then
        for _, P in self.当前地图:遍历玩家() do
            if P then
                P.rpc:修改动作(nid, 动作)
            end
        end
    end
end

function 角色:角色_能量塔切换动作(动作, nid)
    local npc = self.周围NPC[nid]
    if npc then
        for _, P in self.当前地图:遍历玩家() do
            if P then
                P.rpc:修改动作(nid, 动作)
            end
        end
    end
end

function 角色:点亮冰塔(nid, r)
    local npc = self.周围NPC[nid]
    if npc then
        for _, P in self.当前地图:遍历玩家() do
            if P then
                P.rpc:点亮冰塔(nid, r)
            end
        end
        self.rpc:设置禁止移动(r)
        return self.rpc:点亮冰塔(nid, r)
    end
end

function 角色:点亮火塔(nid, r)
    local npc = self.周围NPC[nid]
    if npc then
        for _, P in self.当前地图:遍历玩家() do
            if P then
                P.rpc:点亮火塔(nid, r)
            end
        end
        self.rpc:设置禁止移动(r)
        return self.rpc:点亮火塔(nid, r)
    end
end

function 角色:战斗_结束_帮战()
    if self.帮派 and __帮派[self.帮派] and __帮派[self.帮派].帮战信息.显示信息 then
        if self.战斗.是否死亡 or self.战斗.是否逃跑 then --如果是死亡或逃跑状态离开战斗
            self.接口:设置战场状态(false)
            self.复活标记 = os.time() + 60   -- 复活标记时间  分钟
            self.接口:添加指定积分(帮战积分.对战死亡 or 1, "帮战积分")
            --组队下成员死亡离队,因为要回到大本营
            if self.是否队长 then
                if not __帮派[self.帮派].帮战信息.显示信息.连胜记录[self.nid] then
                    __帮派[self.帮派].帮战信息.显示信息.连胜记录[self.nid] = {}
                end
                __帮派[self.帮派].帮战信息.显示信息.连胜记录[self.nid][#__帮派[self.帮派].帮战信息.显示信息.连胜记录[self.nid] + 1] = '负'
                self:角色_解散队伍()
            elseif self.是否组队 then
                self:角色_离开队伍()
            end
            local map = __帮派[self.帮派].帮战信息.帮战地图
            if map then
                local 大本营 = __帮派[self.帮派].帮战信息.大本营
                local 大本营坐标 = {
                    { x = math.floor(9 * 20), y = math.floor((map.高度 - 8) * 20) },
                    { x = math.floor(105 * 20), y = math.floor((map.高度 - 91) * 20) },
                }
                self:移动_切换地图(map, 大本营坐标[大本营].x, 大本营坐标[大本营].y)
                self.战场状态 = nil
            end
        else
            --跟助战也没关系看起来
            self.接口:添加指定积分(帮战积分.对战存活 or 1, "帮战积分")
            if self.是否组队 then
                if self.是否队长 then
                    __帮派[self.帮派].帮战信息.显示信息.帮派成员胜利场次 = __帮派[self.帮派].帮战信息.显示信息.帮派成员胜利场次 + 1
                    if not __帮派[self.帮派].帮战信息.显示信息.连胜记录[self.nid] then
                        __帮派[self.帮派].帮战信息.显示信息.连胜记录[self.nid] = {}
                    end
                    __帮派[self.帮派].帮战信息.显示信息.连胜记录[self.nid][#__帮派[self.帮派].帮战信息.显示信息.连胜记录[self.nid] + 1] = '胜'
                    local 是否连胜, 次数 = true, 0
                    for i = 1, #__帮派[self.帮派].帮战信息.显示信息.连胜记录[self.nid] do
                        if __帮派[self.帮派].帮战信息.显示信息.连胜记录[self.nid][i] == '负' then
                            是否连胜 = false
                        end
                        次数 = 次数 + 1
                    end
                    local 对手 = __帮派[self.帮派].帮战信息.敌对帮派
                    if 是否连胜 and 次数 >= 3 then
                        if 对手 then
                            for k, v in __帮派[self.帮派]:遍历成员() do
                                if __玩家[k] then
                                    __玩家[k].rpc:聊天框提示('#Y我帮由#G' .. self.名称 .. '#Y率领的队伍,以摧枯拉朽之势完成了#R' .. 次数 .. '#Y连杀,可喜可贺！')
                                end
                            end
                            for k, v in __帮派[对手]:遍历成员() do
                                if __玩家[k] then
                                    __玩家[k].rpc:聊天框提示('#Y敌方帮派由#G' .. self.名称 .. '#Y率领的队伍,以摧枯拉朽之势完成了#R' .. 次数 .. '#Y连杀,谁来阻止他！')
                                end
                            end
                        end
                    end
                end
                for k, v in self:遍历队伍() do
                    if not __帮派[self.帮派].帮战信息.显示信息.个人杀敌[v.nid] then
                        __帮派[self.帮派].帮战信息.显示信息.个人杀敌[v.nid] = 0
                    end
                    __帮派[self.帮派].帮战信息.显示信息.个人杀敌[v.nid] = __帮派[self.帮派].帮战信息.显示信息.个人杀敌[v.nid] + 1
                end
            else
                __帮派[self.帮派].帮战信息.显示信息.帮派成员胜利场次 = __帮派[self.帮派].帮战信息.显示信息.帮派成员胜利场次 + 1
                if not __帮派[self.帮派].帮战信息.显示信息.个人杀敌[self.nid] then
                    __帮派[self.帮派].帮战信息.显示信息.个人杀敌[self.nid] = 0
                end
                __帮派[self.帮派].帮战信息.显示信息.个人杀敌[self.nid] = __帮派[self.帮派].帮战信息.显示信息.个人杀敌[self.nid] + 1
            end
        end
    end
end


function 角色:战斗_结束_帮战挑战()
    if self.帮派 and __帮派[self.帮派] and __帮派[self.帮派].帮战信息.显示信息 then
        if self.战斗.是否死亡 or self.战斗.是否逃跑 then --如果是死亡或逃跑状态离开战斗
            self.接口:设置战场状态(false)
            self.复活标记 = os.time() + 60   -- 复活标记时间  分钟
            self.接口:添加指定积分(帮战积分.挑战失败 or 1, "帮战积分")
            --组队下成员死亡离队,因为要回到大本营
            if self.是否队长 then
                if not __帮派[self.帮派].帮战信息.显示信息.连胜记录[self.nid] then
                    __帮派[self.帮派].帮战信息.显示信息.连胜记录[self.nid] = {}
                end
                __帮派[self.帮派].帮战信息.显示信息.连胜记录[self.nid][#__帮派[self.帮派].帮战信息.显示信息.连胜记录[self.nid] + 1] = '负'
                self:角色_解散队伍()
            elseif self.是否组队 then
                self:角色_离开队伍()
            end
            local map = __帮派[self.帮派].帮战信息.帮战地图
            if map then
                local 大本营 = __帮派[self.帮派].帮战信息.大本营
                local 大本营坐标 = {
                    { x = math.floor(9 * 20), y = math.floor((map.高度 - 8) * 20) },
                    { x = math.floor(105 * 20), y = math.floor((map.高度 - 91) * 20) },
                }
                self:移动_切换地图(map, 大本营坐标[大本营].x, 大本营坐标[大本营].y)
                self.战场状态 = nil
            end
        else
            --跟助战也没关系看起来
            self.接口:添加指定积分(帮战积分.挑战胜利 or 1, "帮战积分")
            if self.是否组队 then
                if self.是否队长 then
                    __帮派[self.帮派].帮战信息.显示信息.帮派成员胜利场次 = __帮派[self.帮派].帮战信息.显示信息.帮派成员胜利场次 + 1
                    if not __帮派[self.帮派].帮战信息.显示信息.连胜记录[self.nid] then
                        __帮派[self.帮派].帮战信息.显示信息.连胜记录[self.nid] = {}
                    end
                    __帮派[self.帮派].帮战信息.显示信息.连胜记录[self.nid][#__帮派[self.帮派].帮战信息.显示信息.连胜记录[self.nid] + 1] = '胜'
                    local 是否连胜, 次数 = true, 0
                    for i = 1, #__帮派[self.帮派].帮战信息.显示信息.连胜记录[self.nid] do
                        if __帮派[self.帮派].帮战信息.显示信息.连胜记录[self.nid][i] == '负' then
                            是否连胜 = false
                        end
                        次数 = 次数 + 1
                    end
                    local 对手 = __帮派[self.帮派].帮战信息.敌对帮派
                    if 是否连胜 and 次数 >= 3 then
                        if 对手 then
                            for k, v in __帮派[self.帮派]:遍历成员() do
                                if __玩家[k] then
                                    __玩家[k].rpc:聊天框提示('#Y我帮由#G' .. self.名称 .. '#Y率领的队伍,以摧枯拉朽之势完成了#R' .. 次数 .. '#Y连杀,可喜可贺！')
                                end
                            end
                            for k, v in __帮派[对手]:遍历成员() do
                                if __玩家[k] then
                                    __玩家[k].rpc:聊天框提示('#Y敌方帮派由#G' .. self.名称 .. '#Y率领的队伍,以摧枯拉朽之势完成了#R' .. 次数 .. '#Y连杀,谁来阻止他！')
                                end
                            end
                        end
                    end
                end
                for k, v in self:遍历队伍() do
                    if not __帮派[self.帮派].帮战信息.显示信息.个人杀敌[v.nid] then
                        __帮派[self.帮派].帮战信息.显示信息.个人杀敌[v.nid] = 0
                    end
                    __帮派[self.帮派].帮战信息.显示信息.个人杀敌[v.nid] = __帮派[self.帮派].帮战信息.显示信息.个人杀敌[v.nid] + 1
                end
            else
                __帮派[self.帮派].帮战信息.显示信息.帮派成员胜利场次 = __帮派[self.帮派].帮战信息.显示信息.帮派成员胜利场次 + 1
                if not __帮派[self.帮派].帮战信息.显示信息.个人杀敌[self.nid] then
                    __帮派[self.帮派].帮战信息.显示信息.个人杀敌[self.nid] = 0
                end
                __帮派[self.帮派].帮战信息.显示信息.个人杀敌[self.nid] = __帮派[self.帮派].帮战信息.显示信息.个人杀敌[self.nid] + 1
            end
        end
    end
end