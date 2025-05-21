local 召唤 = require('召唤')

function 召唤:战斗_开始(对象)
    self:刷新属性() -- 战斗开始刷新属性
    self.战斗已上场 = true -- 已上场
    for k, v in self:遍历内丹() do
        v:增减元气(-1)
    end
    self.战斗 = 对象
    self.战斗.菜单指令 = self.主人.战斗召唤指令 or self.存档指令[1]
    self.战斗.菜单目标 = self.主人.战斗召唤目标 or self.存档指令[2]
    self.战斗.菜单选择 = self.主人.战斗召唤选择 or self.存档指令[3]
    self.主人.战斗召唤 = 对象
end

function 召唤:取默认自动(位置)
    if 位置 > 10 then
        return 1
    end
    return 11
end

function 召唤:置存档命令(a,b,c)
    self.存档指令 = {a,b,c}
    if a == "法术" then
        if self.战斗.法术列表[c] then
            self.存档指令[4] = self.战斗.法术列表[c].名称
        end
    end
    self.战斗.存档指令 = {a,b,c}
end


function 召唤:取是否可参战()
    if self.主人.转生 == 0 and self.等级 > self.主人.等级 + 30 then
        return false
    elseif self:取技能是否存在("矢志不渝") and self.忠诚 and self.忠诚 >= 30 then
        return true
    end
    return true
end

function 召唤:死亡处理()
    -- if not self:取技能是否存在("忠肝义胆") then
    --     self.忠诚 = self.忠诚 - 15
    -- end
    -- self.亲密 = self.亲密 - 50
    -- if self.忠诚 <= 0 then
    --     self.忠诚 = 0
    -- end
    -- if self.亲密 <= 0 then
    --     self.亲密 = 0
    -- end
end

-- function

function 召唤:战斗_结束()
    if self.战斗 then
        if self.战斗.战场.是否结束 == 1 then
            self:添加亲密度(5)
        end
        if self.战斗.增加亲密 > 0 then
            self:添加亲密度(self.战斗.增加亲密)
        end
        
        self.气血 = self.战斗.气血 <= self.最大气血 and self.战斗.气血 or self.最大气血
        self.魔法 = self.战斗.魔法 <= self.最大魔法 and self.战斗.魔法 or self.最大魔法

        if self.战斗.是否死亡 then
            self.气血 = math.floor(self.最大气血 * 0.1)
            self.魔法 = math.floor(self.最大魔法 * 0.1)
        end

        if self.主人.其它.回血 > 0 then
            self.气血 = self.最大气血
            self.魔法 = self.最大魔法
        end

        if self.主人.是否机器人 then
            self.忠诚 = 100
            self.气血 = self.最大气血
            self.魔法 = self.最大魔法
        end

        self.主人.task:恢复血法(self.接口)
    end
    self.战斗 = nil

    
end

function 召唤:战斗结束触发领悟()
    if math.random(100) <= 1 then
        self:添加战斗领悟技能()
    end
end


function 召唤:召唤_战斗属性() --战斗召唤窗口
    local r = {}
    for _, v in pairs {
        'nid',
        '名称',
        '等级',
        '染色',
        '忠诚',
        '亲密',
        '转生',
        '飞升',
        '外形',
        '气血',
        '最大气血',
        '魔法',
        '最大魔法',
        '攻击',
        '速度',
        '经验',
        --法术
    } do
        r[v] = self[v]
    end

    local list = {}
    for _, v in ipairs(self.内丹) do
        table.insert(list, {
            名称 = v.技能,
            等级 = v.等级,
            转生 = v.转生,
            点化 = v.点化,
        })
    end
    r.内丹 = list
    return r
end

function 召唤:召唤_战斗技能列表(nid)
    if self.战斗 then
        if nid then
            for n, _ in self.战斗.战场:遍历对象() do
                if _.nid == nid then
                    local list = {}
                    for _, v in pairs(_.法术列表) do
                        if v.是否主动 then --主动
                            table.insert(list, {
                                nid = v.nid,
                                名称 = v.名称,
                                熟练度 = 1,
                                是否内丹 = ggetype(v) == '内丹',
                                消耗 = v:法术取消耗(_)
                            })
                        end
                    end
                    return list, _.魔法, _.气血
                end
            end
        else
            local list = {}
            for _, v in pairs(self.战斗.法术列表) do
                if v.是否主动 then --主动
                    table.insert(list, {
                        nid = v.nid,
                        名称 = v.名称,
                        熟练度 = 1,
                        是否内丹 = ggetype(v) == '内丹',
                        消耗 = v:法术取消耗(self.战斗)
                    })
                end
            end
            return list, self.战斗.魔法, self.战斗.气血
        end
    end
end

function 召唤:召唤_战斗技能描述(nid)
    if self.战斗 then
        local 法术 = self.战斗.法术列表[nid]
        if 法术 then
            return 法术:法术取描述(self.战斗)
        end
    end
end
