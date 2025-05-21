local 角色 = require('角色')

function 角色:地图_初始化()
    self.是否移动 = false
    self.遇敌时间 = 0
    self.周围 = {}
    self.周围玩家 = {}
    self.临时周围玩家 = {}
    self.周围物品 = {}
    self.周围NPC = {}
    self.周围跳转 = {}
    self.周围怪物 = {}
    self.当前地图 = __地图[self.地图]
    self.当前地图:添加玩家(self)
    self.xy = require('GGE.坐标')(self.x, self.y)
    self.X, self.Y = self.x // 20, (self.当前地图.实际高度 - self.y) // 20
    if not self.rect then
        self.rect = require('GGE.矩形')(self.x, self.y, 800, 600)
        self.rect:置中心(self.rect.w // 2, self.rect.h // 2) --屏幕大小/2
    end
end

function 角色:检查点(x, y)
    return self.rect:检查点(x, y)
end

function 角色:地图_更新()
    if not self.是否战斗 and not self.地图切换 then
        self:地图_刷新对象()
        self:地图_刷新暗雷()
        self.task:地图刷新事件(self.接口, self.当前地图)
    end
end

function 角色:地图_刷新对象()
    -- 3秒没有移动检测
    if self.移动时间 and self.移动时间 + 3 < os.time() then
        self:角色_移动结束(self.x, self.y, self.方向)
    end
    self.rect:置坐标(self.x, self.y)
    for _, v in pairs(self.周围) do
        if not v.所属 or v.所属 == self.名称 then --剧情NPC，只有自己显示
            if not self.当前地图:取对象(v.nid) then -- 不在地图中
                self:地图_删除对象(v)
            elseif not self:检查点(v.x, v.y) then -- 不在范围中
                self:地图_删除对象(v)
            elseif ggetype(v) == '地图NPC' and v.生成时间 ~= v.更新时间 then -- 寻访用
                self:地图_删除对象(v)
            end
        end
    end
    for _, v in self.当前地图:遍历对象() do
        if v ~= self and self:检查点(v.x, v.y) then
            if not self.周围[v.nid] then -- 在周围并且不在列表
                self:地图_添加对象(v)
            end
        end
    end

    --更新NPC头顶
    -- for k, v in pairs(self.周围NPC) do
    --     self.task:NPC更新事件(self.接口, v)
    --     if v.是否删除 then
    --         self.周围[k] = nil
    --         self.周围NPC[k] = nil
    --     end
    -- end
end

function 角色:地图_刷新暗雷()
    if self.当前地图.是否副本 then
        return
    end

    self.task:任务触发暗雷前(self.接口, self.地图)

    if self.当前地图.可遇怪 then
        if self.是否移动 then
            self.遇敌时间 = self.遇敌时间 + math.random(1, 3)
        end
        if self.遇敌时间 > 15 and not self.是否战斗 then
            self.遇敌时间 = 0
            if self.task:摄妖香(self.接口) then
                -- if self.等级 - 10 >= self.当前地图.地图等级 then
                return
                -- end
            end

            if self.task:任务触发暗雷(self.接口) then
                return
            end
            self.是否移动 = false
            coroutine.xpcall(function()
                if math.random(100) < 90 then
                    self.接口:进入战斗('scripts/war/野怪.lua', self.当前地图.id, self.当前地图.地图等级, self.当前地图.地图最高等级)
                else
                    self.接口:进入战斗('scripts/war/野怪boss.lua', self.当前地图.id, self.当前地图.地图等级, self.当前地图.地图最高等级)
                end
            end)
        end
    end
end

function 角色:地图_初始化对象()
    if not self.是否战斗 then
        for _, v in pairs(self.周围) do
            if not v.所属 or v.所属 == self.名称 then --剧情NPC，只有自己显示
                self:地图_添加对象(v)
            end
        end
    end
end

function 角色:地图_添加对象(o)
    if not self.是否战斗 then
        self.周围[o.nid] = o
        local tp = ggetype(o)
        if o.nid then
            if tp == '角色' then
                self.周围玩家[o.nid] = o
                self.临时周围玩家[o.nid] = true
            elseif tp == '地图NPC' then
                self.周围NPC[o.nid] = o
            elseif tp == '地图跳转' then
                self.周围跳转[o.nid] = o
            elseif tp == '地图怪物' then
                self.周围怪物[o.nid] = o
            elseif tp == '地图物品' then
                self.周围物品[o.nid] = o
            end
            self.rpc:地图添加(o:取简要数据())
        end
    end
end

function 角色:地图_删除对象(o)
    --检查交易
    --检查队友
    self.周围[o.nid] = nil
    if o.nid then
        self.周围玩家[o.nid] = nil
    end
    self.周围物品[o.nid] = nil
    self.周围NPC[o.nid] = nil
    self.周围怪物[o.nid] = nil
    self.rpc:地图删除(o.nid)
end

function 角色:能否跳转(map)
    return self.task:切换地图前事件(self.接口, map)
end

function 角色:移动_切换地图(map, x, y)
    self.是否移动 = false
    if not self.是否战斗 and not self.是否摆摊 then
        if not self.是否组队 or self.是否队长 then
            x = math.abs(math.floor(x))
            y = math.abs(math.floor(y))
            if map and map:检查点(x, y) then
                if self.是否组队 and self.是否队长 then
                    for i, v in self:遍历队友() do
                        if v:能否跳转(map) == false then --任务阻止 切换地图前事件
                            self.rpc:提示窗口("#R%s#Y不可切换地图！", v.名称)
                            return
                        end
                    end
                end

                self.地图切换 = { map, x, y }
                self.rpc:切换地图(map.id, x, y)
            else
                print('移动_切换地图 -> 切换地图错误')
            end
        end
    end
end

function 角色:队友_切换地图(map, x, y)
    self.是否移动 = false
    self.地图切换 = { map, x, y }
    self.rpc:切换地图(map.id, x, y)
    if self.是否机器人 or self.是否助战 then
        self:角色_完成跳转()
    end
end

function 角色:角色_完成跳转()
    if self.地图切换 then
        local map, x, y = table.unpack(self.地图切换)

        self.当前地图:删除玩家(self)
        self.当前地图:删除召唤(self.观看召唤)
        self.当前地图:删除宠物(self.观看宠物)

        self.地图 = map.id
        self.x, self.y = x, y
        self:地图_初始化()

        if self.观看召唤 then
            self.观看召唤.是否移动 = false
            self.观看召唤.x = x
            self.观看召唤.y = y
            self.当前地图:添加召唤(self.观看召唤)
        end

        if self.观看宠物 then
            self.观看宠物.是否移动 = false
            self.观看宠物.x = x
            self.观看宠物.y = y
            self.当前地图:添加宠物(self.观看宠物)
        end

        if self.是否队长 then
            for i, v in self:遍历队友() do
                v.队长 = self.nid
                v.队伍位置 = i
                v:队友_切换地图(map, x, y)
            end
        end

        self.地图切换 = nil
        self.task:切换地图后事件(self.接口, map, x, y)
    end
end

function 角色:角色_移动开始(tx, ty, 模式) --当前和目标,两组坐标
    if not self.是否战斗 and not self.是否摆摊 then
        self.是否移动 = { tx, ty }
        self.移动时间 = os.time()
        local 召唤 = self.观看召唤
        local 宠物 = self.观看宠物
        if 召唤 and self.xy:取距离(召唤.x, 召唤.y) > 50 then
            召唤.是否移动 = true
            召唤.x, 召唤.y = self.x + math.random(-20, 20), self.y + math.random(-20, 20)
            self.rpc:召唤移动(召唤.nid, 召唤.x, 召唤.y)
            self.rpn:召唤移动(召唤.nid, 召唤.x, 召唤.y)
        end
        if 宠物 and self.xy:取距离(宠物.x, 宠物.y) > 40 then
            宠物.是否移动 = true
            宠物.x, 宠物.y = self.x + math.random(-40, 40), self.y + math.random(-40, 40)
            self.rpc:宠物移动(宠物.nid, 宠物.x, 宠物.y)
            self.rpn:宠物移动(宠物.nid, 宠物.x, 宠物.y)
        end
        self.task:移动开始(self.接口, x, y, tx, ty, 模式) -- 清明_侍魂_善鬼_人鬼重会 专用
        self.rpn:移动开始(self.nid, tx, ty, 模式) --周围
    end
end

function 角色:角色_移动更新(x, y, d)
    local abc = 0
    if not self.是否战斗 and not self.是否摆摊 then
        -- 检查时间与速度
        self.方向 = d
        self.x, self.y = x, y
        self.X, self.Y = x // 20, (self.当前地图.实际高度 - y) // 20
        self.xy:pack(x, y)
        self.移动时间 = os.time()
        if self.是否队长 then
            for i, v in self:遍历队友() do
                -- print(v.名称)
                -- if v.角色_移动更新 == nil then
                --     print("移动数据错误",v.名称,type(v))
                -- else
                v:角色_移动更新(x, y, d)
                abc = abc + 1
                if abc >= 5 then
                    break
                end
                -- end
            end
        end
    end
end

function 角色:角色_移动结束(x, y, d)
    local abc = 0
    if not self.是否战斗 and not self.是否摆摊 then
        self.方向 = d
        self.x, self.y = x, y
        self.X, self.Y = x // 20, (self.当前地图.实际高度 - y) // 20
        self.xy:pack(x, y)
        self.是否移动 = false
        self.移动时间 = nil
        self.rpn:移动结束(self.nid, x, y, d) --周围
        if self.是否队长 then
            for i, v in self:遍历队友() do ---
                -- if v.角色_移动结束 == nil then
                --     print("移动数据错误",v.名称,type(v))
                -- else
                v:角色_移动结束(x, y, d)
                -- end
                abc = abc + 1
                if abc >= 5 then
                    break
                end
            end
        elseif self.是否组队 then
            self.rpc:移动结束(self.nid, x, y, d) --自己
        end
    end
end

function 角色:角色_切换方向(v)
    if not self.是否战斗 then
        self.方向 = v
        self.rpn:切换方向(self.nid, v)
    end
end

function 角色:角色_自动归队()
    local 队长 = self.队伍[1]
    if 队长 then
        local 走 = self.xy:取距离(队长.xy) < 200
        self.rpc:移动开始(self.nid, 队长.x, 队长.y, 走) --自己
        self.rpn:移动开始(self.nid, 队长.x, 队长.y, 走) --周围
    end
end

--===========================================================================
function 角色:遍历周围玩家()
    return next, self.周围玩家
end

function 角色:遍历周围NPC()
    return next, self.周围NPC
end

--===========================================================================
function 角色:角色_地图跳转(id)
    if coroutine.isyieldable() then
        if not self.是否战斗 and not self.是否摆摊 then
            self.是否移动 = false
            local 跳转 = self.当前地图:取跳转(id)
            if 跳转 then
                self:移动_切换地图(跳转:取目标())
            end
        end
    end
end

function 角色:角色_NPC跳转(info)
    if info then
        local map = __地图[info.tid]
        if map then
            self.地图切换 = { map, info.tx * 20, map.高度 * 20 - info.ty * 20 }
            self.rpc:切换地图(map.id, info.tx * 20, map.高度 * 20 - info.ty * 20)
        end
    end
end

function 角色:角色_地图物品(nid)
    if not self.是否战斗 and self.周围物品[nid] then
        local t = self.周围物品[nid]
        local r = t:触发(self.接口)

        if r == true then
            --   self.周围物品[nid] = nil
            self:地图_删除对象(t)
            t:删除()
        end
        return r
    end
end

function 角色:角色_任我行(mid, x, y)
    local map = __地图[mid]
    if not map then
        return
    end
    local 是否副本地图 = self.接口:取当前地图()
    if map.传送限制 or 是否副本地图.传送限制 then
        self.rpc:提示窗口('#Y当前地图无法传送。')
        return
    end
    local X, Y = x // 20, (map.实际高度 - y) // 20
    local 任我行
    if self.是否组队 then
        if self.是否队长 then
            任我行 = self:物品_获取('任我行·组队')
            if not 任我行 then
                self.rpc:提示窗口('#Y无法传送到目标位置，缺少道具任我行·组队')
                return
            end
        else
            self.rpc:提示窗口('#Y你在队伍中，只有队长可以传送')
            return
        end
    else
        任我行 = self:物品_获取('任我行·单人')
        if not 任我行 then
            self.rpc:提示窗口('#Y无法传送到目标位置，缺少道具任我行·单人')
            return
        end
    end
    for _, b in self:遍历队友() do
        for _, v in b:遍历任务() do
            if v.飞行限制 then
                self.rpc:提示窗口('#G%s#Y身上有限制飞行的任务！', b.名称)
                return
            end
        end
    end
    coroutine.xpcall(
        function()
            self:移动_切换地图(map, x, y)
        end
    )
    任我行:减少(1)
    return true
end

function 角色:角色_任我行1(mid, x, y)
    local map = __地图[mid]
    if not map then
        return
    end

    local 是否副本地图 = self.接口:取当前地图()

    if map.传送限制 or 是否副本地图.传送限制 then
        self.rpc:提示窗口('#Y当前地图无法传送。')
        return
    end

    for _, b in self:遍历队友() do
        for _, v in b:遍历任务() do
            if v.飞行限制 then
                self.rpc:提示窗口('#G%s#Y身上有限制飞行的任务！', b.名称)
                return
            end
        end
    end

    local X, Y = x // 20, (map.实际高度 - y) // 20

    coroutine.xpcall(
        function()
            self:移动_切换地图(map, x, y)
        end
    )
    return true
end

--=============================================================
function 角色:角色_被动NPC对话(nid)
    if not self.是否战斗 and nid then
        local npc = self.周围NPC[nid]
        if npc then
            npc = npc:对话(self)
            if npc then
                self.task:任务NPC对话(self.接口, npc)
                self.对话验证 = math.random(500)
                self.rpc:被动对话(npc.nid, npc.台词, npc.外形, npc.结束, self.对话验证, npc.对话消失)
            end
        end
    end
end

function 角色:角色_NPC对话(nid)
    if not self.是否战斗 and nid then
        local npc = self.周围NPC[nid]
        if npc then
            npc = npc:对话(self)
            if npc then
                self.task:任务NPC对话(self.接口, npc)
                self.对话验证 = math.random(500)
                if npc.队伍对话 and self.是否组队 and self.是否队长 then
                    for i, v in self:遍历队友() do
                        coroutine.xpcall(v.角色_被动NPC对话, v, npc.nid)
                    end
                end
                return npc.台词, npc.头像, npc.结束, self.对话验证, npc.对话消失
            else
                warn('NPC错误')
            end
        end
    end
end

function 角色:角色_被动NPC菜单(nid, opt)
    if not self.是否战斗 and nid then
        local npc = self.周围NPC[nid]
        if npc then
            npc = npc:菜单(self, opt)
            if npc then
                self.task:任务NPC菜单(self.接口, npc, opt)
                self.rpc:被动菜单(npc.台词, npc.外形, npc.结束)
            end
        end
    end
end

function 角色:角色_NPC菜单(nid, opt, sign)
    if not self.是否战斗 and nid then
        local npc = self.周围NPC[nid]
        if npc then
            npc = npc:菜单(self, opt)
            if npc then
                self.task:任务NPC菜单(self.接口, npc, opt)
                if npc.队伍菜单 and self.是否组队 and self.是否队长 then
                    for i, v in self:遍历队友() do
                        coroutine.xpcall(v.角色_被动NPC菜单, v, npc.nid, opt)
                    end
                end
                return npc.台词, npc.头像, npc.结束
            end
        end
    end
end

function 角色:角色_被动NPC给予(nid, cash, items)
    if not self.是否战斗 and nid and type(cash) == 'number' and type(items) == 'table' then
        if nid == self.nid or (not self.周围NPC[nid] and not __玩家[nid]) then
            return
        end
        if self.周围NPC[nid] then
            local npc = self.周围NPC[nid]

            if npc then
                local item
                if items and items[1] then
                    local 名称 = items[1].名称
                    local 数量 = items[1].数量

                    local a = self:物品_获取(名称)
                    if not a then
                        return
                    end
                    if a.数量 < 数量 then
                        return
                    end
                    item = {}
                    item[1] = a:生成提交(数量)
                end
                local t, tc = npc:给予(self, cash, item)
                if not t then
                    t = { nid = npc.nid, 名称 = npc.名称, 头像 = npc.外形, 台词 = "你给我什么东西？" }
                end
                t.台词 = tc
                self.task:任务NPC给予(self.接口, t, cash, item)
                self.rpc:被动给予(nid, t.台词, t.头像, t.结束)
            end
        end
    end
end

function 角色:角色_给予(nid, cash, items)
    if not 验证数字(cash) then
        return
    end
    if not self.是否战斗 and nid and type(cash) == 'number' and type(items) == 'table' then
        if nid == self.nid or (not self.周围NPC[nid] and not __玩家[nid]) then
            return
        end
        if self.周围NPC[nid] then
            for i, v in ipairs(items) do
                if type(v[1]) ~= 'number' or type(v[2]) ~= 'number' then
                    return --位置和数量
                end
                if not self.物品[v[1]] or self.物品[v[1]].数量 < v[2] then
                    return false
                end
                items[i] = self.物品[v[1]]:生成提交(v[2])
            end
            local npc = self.周围NPC[nid]
            if npc then
                local t, tc = npc:给予(self, cash, items)
                t.台词 = tc
                self.task:任务NPC给予(self.接口, t, cash, items)
                if t.队伍给予 and self.是否组队 and self.是否队长 then
                    for i, v in self:遍历队友() do
                        coroutine.xpcall(v.角色_被动NPC给予, v, npc.nid, cash, items)
                    end
                end
                return t.台词, t.头像, t.结束
            end
        elseif __玩家[nid] then --todo
            if self.转生 == 0 and self.等级 < 50 then
                self.rpc:提示窗口('#R对方低于50级无法给予玩家')
                return
            end
            if self.是否摆摊 then
                self.rpc:常规提示("#R清先取消摆摊状态！")
                return
            end
            local P = __玩家[nid]
            if not P then
                self.rpc:常规提示("#R玩家不在你周围")
                return
            end
            if P.设置.接受物品 == false then
                return
            end
            if self.交易锁 then
                return '#Y点开背包解锁，注册用的安全码解锁！'
            end
            if self.禁交易 ~= 0 then
                self.rpc:常规提示("#R你已被管理禁止交易！")
                return
            end
            if P.禁交易 ~= 0 then
                self.rpc:常规提示("#R对方已被管理禁止交易！")
                return
            end
            if P.是否摆摊 then
                self.rpc:常规提示("#R对方正在摆摊 无法接收！")
                return
            end
            if P.转生 == 0 and P.等级 < 50 then
                self.rpc:提示窗口('#R对方低于50级无法出摊')
                return
            end

            if cash < 0 then
                return false
            end

            if cash > self.银子 then
                return false
            end

            if self.是否给予 then
                return
            end
            self.是否给予 = true
            self.银子 = self.银子 - cash
            P.银子 = P.银子 + cash
            if cash > 0 then
                P.rpc:提示窗口(string.format("#G%s(%s)#Y给了你%s两银子。", self.名称, self.id, cash))
                self.rpc:提示窗口(string.format("#Y你给了#G%s(%s)#Y%s两银子。", P.名称, P.id, cash))
                -- __世界:print(string.format('【给予】%s 给 #%s %s两银子', self.名称, P.名称, cash))
                self:日志_交易记录('【给予】我给 #%s(%s) %s两银子 剩余银子:%s', P.名称, P.id, cash, self.银子)
                P:日志_交易记录('【给予】%s(%s) 给我 %s两银子 现有银子:%s', self.名称, self.id, cash, P.银子)
            end
            local 已交易位置 = {}
            for i, v in ipairs(items) do
                if type(v[1]) ~= 'number' or type(v[2]) ~= 'number' then
                    return --位置和数量
                end
                if not self.物品[v[1]] or self.物品[v[1]].数量 < v[2] then
                    return false
                end
                if self.物品[v[1]].禁止交易 then
                    self.rpc:常规提示("#Y这东西不能给别人。")
                    return false
                end
                if 已交易位置[v[1]] then
                    self.rpc:常规提示("#Y重复物品无法交易。")
                    return false
                end
                items[i] = self.物品[v[1]]:开始拆分(v[2])
                已交易位置[v[1]] = true
            end
            if P:物品_检查添加(items) then
                for i, v in ipairs(items) do
                    items[i] = v:结束拆分()
                    P.rpc:提示窗口(string.format("#G%s(%s) #Y给了你%s个%s。", self.名称, self.id, items[i].数量,
                        (items[i].原名 or items[i].名称)))
                    self.rpc:提示窗口(string.format("#Y你给了#G%s(%s) #Y%s个%s。", P.名称, P.id, items[i].数量,
                        (items[i].原名 or items[i].名称)))
                    self:日志_交易记录('【给予】我给 %s(%s)  %s 个%s ', P.名称, P.id, items[i].数量,
                        (items[i].原名 or items[i].名称))
                    P:日志_交易记录('【给予】%s(%s)  给 我 %s 个%s ', self.名称, self.id, items[i].数量,
                        (items[i].原名 or items[i].名称))
                end
                P:物品_添加(items)
            end

            self.是否给予 = false
        end
    end
end

function 角色:角色_地图明雷(nid)
    local P = self.周围怪物[nid]
    if ggetype(P) == '地图怪物' then
        if not P:是否战斗中() then
            self.是否移动 = false
            P:进入战斗(true)
            self.rpc:添加状态(nid, 'vs')
            self.rpn:添加状态(nid, 'vs')
            if P.脚本 then
                coroutine.xpcall(
                    function()
                        self.接口:进入战斗(P.脚本, P)
                        self.rpc:删除状态(nid, 'vs')
                        self.rpn:删除状态(nid, 'vs')
                        P:进入战斗(false)
                    end
                )
            end
        end
    end
end

function 角色:角色_攻击(nid)
    local P = self.周围[nid]
    if ggetype(P) == '地图NPC' then
        local r = self.task:任务攻击事件(self.接口, P)
        if not r then
            if P.事件 then
                if P.事件.攻击事件 then
                    r = P.事件:攻击事件(self.接口, P)
                end
            elseif P.战斗脚本 then
                r = P:攻击事件(self.接口, P)
            end
        end
        if type(r) == "string" then
            return r, P.头像 or P.外形
        end
    elseif ggetype(P) == '角色' then
        if P.是否战斗 and not self.是否观战 then --观战
            self.接口:进入观战(P)
        else
            self.接口:进入PK(P)
        end
    end
end

function 角色:角色_取地图飞行旗(mapId)
    return self:物品_获取地图飞行旗(mapId)
end
