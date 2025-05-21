local 角色 = require('角色')

function 角色:战斗_初始化(v, ...)
    if ggetype(v) == 'string' then --脚本
        local arg = { self.接口, ... }
        local co = coroutine.running()
        coroutine.xpcall(
            function()
                local 战场 = require('战斗/战场')(v, arg)
                if self.是否组队 then
                    if not self.是否队长 then
                        return
                    end
                end

                for i, P in self:遍历队伍() do
                    战场:加入我方(i, P)
                    if P.参战召唤 and P.参战召唤:取是否可参战() then
                        战场:加入我方(i + 5, P.参战召唤)
                    end

                    if P.参战孩子 then
                        战场:加入我方(i + 10, P.参战孩子)
                    end
                end
                coroutine.xpcall(co, 战场:战斗开始())
            end
        )
        return coroutine.yield()
    end
end

function 角色:战斗_初始化_PK(玩家, 类型, ...)
    if ggetype(玩家) == '角色' then
        local co = coroutine.running()
        coroutine.xpcall(
            function()
                local 战场 = require('战斗/战场')(玩家, 类型)
                if self.是否组队 then
                    if not self.是否队长 then
                        return
                    end
                end

                for i, P in self:遍历队伍() do
                    if not P.是否机器人 then
                        战场:加入我方(i, P)
                        if P.参战召唤 and P.参战召唤:取是否可参战() then
                            战场:加入我方(i + 5, P.参战召唤)
                        end

                        if P.参战孩子 then
                            战场:加入我方(i + 10, P.参战孩子)
                        end
                    end
                end

                for i, P in 玩家:遍历队伍() do
                    if not P.是否机器人 then
                        战场:加入敌方(i, P)
                        if P.参战召唤 and P.参战召唤:取是否可参战() then
                            战场:加入敌方(i + 5, P.参战召唤)
                        end

                        if P.参战孩子 then
                            战场:加入敌方(i + 10, P.参战孩子)
                        end
                    end
                end
                coroutine.xpcall(co, 战场:战斗开始())
            end
        )
        return coroutine.yield()
    end
end

function 角色:退出战斗()
    if self.是否战斗 then
        if self.战斗 and self.战斗.战场 then
            -- 只有脚本战斗可以退出，PK或者其他战斗不可以退出
            if self.战斗.战场.脚本 then
                self.战斗.战场:强制退出战斗()
            end
        end
    end
end

function 角色:战斗_开始(对象)
    self:刷新属性()
    self.task:任务战斗开始(对象, self.接口)
    self.战斗前召唤 = self.参战召唤
    self.是否PK = 对象.战场.是否PK
    self.是否战斗 = true
    self.rpn:添加状态(self.nid, 'vs') --周围
    self.战斗 = 对象
    self.战斗.自动 = self.战斗自动
    self.战斗.菜单指令 = self.战斗指令 or self.存档指令[1]
    self.战斗.菜单目标 = self.战斗目标 or self.存档指令[2]
    self.战斗.菜单选择 = self.战斗选择 or self.存档指令[3]
    if self.是否机器人 then
        self.活跃时间 = os.time()
    end
end

function 角色:置存档命令(a, b, c)
    self.存档指令 = { a, b, c }
    if a == "法术" then
        if self.战斗.法术列表[c] then
            self.存档指令[4] = self.战斗.法术列表[c].名称
        end
    end
    self.战斗.存档指令 = { a, b, c }
end

function 角色:取指定召唤兽(nid)
    return self.召唤[nid]
end

function 角色:战斗_结束()
    if self.是否战斗 then
        self.是否PK = false
        self.是否观战 = false
        self.是否战斗 = false
        if self.战斗 then
            if self.战斗._定时 then
                self.战斗._定时:删除()
            end
            self.rpn:删除状态(self.nid, 'vs') --周围
            -- 离队处理
            if (self.战斗.是否死亡 and self.战斗.是否惩罚) or self.战斗.是否逃跑 or self.是否掉线 then
                if self.是否队长 then
                    self:角色_解散队伍()
                elseif self.是否组队 then
                    self:角色_离开队伍()
                end
            end

            -- 死亡处理
            if self.战斗.是否死亡 then
                if self.战斗.战场.是否惩罚 then
                    local map = __地图[1125]
                    self:移动_切换地图(map, 800, 800)

                    -- 经验惩罚
                    local 损失经验 = math.floor(self.经验 * 0.2)
                    self.经验 = self.经验 - 损失经验
                    if self.经验 < 0 then
                        self.经验 = 0
                    end
                    if 损失经验 > 0 then
                        self.rpc:提示窗口('#R你因为战斗死亡损失了%s点经验。', 损失经验)
                    end
                end
            end

            --PK处理
            if self.战斗.战场.是否PK then
                self:PK胜负处理(self.战斗.战场.战斗类型, self.战斗.队伍)
            end

            -- 气血处理
            if self.其它.回血 == 1 then
                self.气血 = self.最大气血
                self.魔法 = self.最大魔法
            elseif self.task:恢复血法(self.接口) then
            elseif self.战斗.是否死亡 then
                self.气血 = math.floor(self.最大气血 * 0.1)
                self.魔法 = math.floor(self.最大魔法 * 0.1)
            else
                self.气血 = self.战斗.气血 > self.最大气血 and self.最大气血 or self.战斗.气血
                self.魔法 = self.战斗.魔法 > self.最大魔法 and self.最大魔法 or self.战斗.魔法
            end

            -- 机器人自动回满
            if self.是否机器人 then
                self.气血 = self.最大气血
                self.魔法 = self.最大魔法
            end

            self.task:任务战斗结束(self.接口, self.战斗.战场.是否结束, self.战斗.战场.战斗类型)
            self.item:道具战斗结束(self.接口, self.战斗.战场.是否结束, self.战斗.战场.战斗类型)

            -- 春节 孵蛋任务
            local r = self.接口:取任务("春节_元气蛋")
            if r and self.战斗.战场.是否结束 == 1 then
                r:添加元气(self.接口)
            end
        end

        self.战斗 = nil

        if self.支援列表.锁定 then
            if self.参战召唤 then
                self.参战召唤.是否参战 = false
            end
            if self.战斗前召唤 then
                self.战斗前召唤.是否参战 = true
                local t = self.战斗前召唤:取界面数据()
                self.rpc:界面信息_召唤(t)
                self.参战召唤 = self.战斗前召唤
            end
        else
            if self.战斗前召唤 then
                self.战斗前召唤.是否参战 = false
            end
            if self.参战召唤 then
                self.参战召唤.是否参战 = true
                local t = self.参战召唤:取界面数据()
                self.rpc:界面信息_召唤(t)
            end
        end
        if self.是否机器人 then
            self.活跃时间 = os.time()
        elseif self.是否掉线 then
            self:下线()
        end
    end
end

function 角色:战斗_重连()
    if self.是否战斗 then
        local data = self.战斗.战场:取数据(self.战斗.位置)
        self.rpc:进入战斗(data, self.战斗.位置, self.战斗.战场.回合数)
        self.战斗:自动战斗(false)
        self.战斗.战场:战斗重连(self.战斗.位置)
    end
end

function 角色:角色_战斗操作返回(人物, 召唤)
    if self.是否战斗 then
        self.战斗.战场:战斗操作返回(self.战斗.位置, 人物, 召唤)
    end
end

function 角色:角色_战斗菜单回传(人物, 召唤)
    if self.是否战斗 then
        self.战斗:战斗菜单回传(self.战斗.位置, 人物, 召唤)
    end
end

function 角色:角色_战斗数据返回(来源)
    if self.是否战斗 then
        self.战斗.战场:战斗数据返回(self.战斗.位置, 来源)
    end
end

function 角色:角色_播放动作返回(动作id)
    if self.是否战斗 then
        self.战斗.战场:播放动作返回(动作id)
    end
end

function 角色:角色_战斗自动(b)
    if self.是否战斗 then
        return self.战斗:自动战斗(b)
    else
        self.战斗自动 = false
    end
end

function 角色:角色_战斗技能列表(nid)
    if self.是否战斗 then
        if nid and self.是否组队 then
            local list = {}
            for i, p in self:遍历队伍() do
                if p.nid == nid then
                    for _, v in pairs(p.战斗.法术列表) do
                        if v.是否主动 then --主动
                            table.insert(list, {
                                nid = v.nid,
                                名称 = v.名称,
                                熟练度 = v.熟练度,
                                消耗 = v:法术取消耗(),
                            })
                        end
                    end
                    return list, p.战斗.魔法, p.战斗.气血, p.战斗.怨气
                end
            end
            return list, 0, 0, 0
        else
            local list = {}
            for _, v in pairs(self.战斗.法术列表) do
                if v.是否主动 then --主动
                    table.insert(list, {
                        nid = v.nid,
                        名称 = v.名称,
                        熟练度 = v.熟练度,
                        消耗 = v:法术取消耗()
                    })
                end
            end
            return list, self.战斗.魔法, self.战斗.气血, self.战斗.怨气
        end
        return list, self.战斗.魔法, self.战斗.气血, self.战斗.怨气
    end
end

function 角色:角色_战斗技能描述(nid)
    if self.是否战斗 then
        local 法术 = self.战斗.法术列表[nid]
        if 法术 then
            return 法术:法术取描述(self.战斗)
        end
    end
end

function 角色:角色_战斗召唤列表(nid)
    if nid then
        for i, p in self:遍历队伍() do
            if p.nid == nid then
                local r = {}
                for k, v in p:遍历召唤() do
                    table.insert(
                        r,
                        {
                            nid = v.nid,
                            名称 = v.名称,
                            外形 = v.外形,
                            原形 = v.原形,
                            已上场 = v.战斗已上场,
                            顺序 = v.顺序
                        }
                    )
                end
                return r
            end
        end
        local r = {}
        for k, v in self:遍历召唤() do
            table.insert(
                r,
                {
                    nid = v.nid,
                    名称 = v.名称,
                    外形 = v.外形,
                    原形 = v.原形,
                    已上场 = v.战斗已上场,
                    顺序 = v.顺序
                }
            )
        end
        return r
    else
        local r = {}
        for k, v in self:遍历召唤() do
            table.insert(
                r,
                {
                    nid = v.nid,
                    名称 = v.名称,
                    外形 = v.外形,
                    原形 = v.原形,
                    已上场 = v.战斗已上场,
                    顺序 = v.顺序
                }
            )
        end
        return r
    end
end

function 角色:PK胜负处理(类型, 队伍)
    if 类型 == 3 then --帮战
        self:战斗_结束_帮战()
    elseif 类型 == 3.1 then
        self:战斗_结束_帮战挑战()
    elseif 类型 == 4 then
        if self.战斗.战场.是否结束 == 3 then --平局 重开
            __水陆大会:战斗结束()
            return
        end
        if self.战斗.战场.是否结束 ~= 队伍 then
            if self.是否队长 then
                local map = __地图[1003]
                self:移动_切换地图(map, 2334, 1689)
            end
        end
        __水陆大会:战斗结束(self.接口, self.战斗.战场.是否结束 == 队伍)
    elseif 类型 == 5 then
        if self.战斗.战场.是否结束 ~= 队伍 then
            if self.战斗.位置 > 10 then --掉钱
                self.经验 = self.经验 - math.floor(self.经验 * 0.5)
                self.银子 = self.银子 - math.floor(self.银子 * 0.3)
                local map = __地图[1125]
                self:移动_切换地图(map, 800, 800)
            end
        end
    elseif 类型 == 6 then
        if self.战斗.战场.是否结束 ~= 队伍 then
            if self.是否组队 and self.是否队长 then
                self:战斗_结束_皇宫挑战(self, 1)
            else
                self:战斗_结束_皇宫挑战(self, 1)
            end
        else
            if self.是否组队 and self.是否队长 then
                self:战斗_结束_皇宫挑战(self, 2)
            else
                self:战斗_结束_皇宫挑战(self, 2)
            end
        end
        self.其它.皇宫挑战 = nil
    end
end
