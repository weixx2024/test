local 角色 = require('角色')

function 角色:角色_解交易锁(s)
    if self.安全码 == s then
        self.交易锁 = not self.交易锁
        if self.交易锁 then
            self.rpc:常规提示("#Y你成功锁定交易锁")
        else
            self.rpc:常规提示("#Y你成功解除交易锁")
        end
    else
        self.rpc:常规提示("#Y安全码错误！")
    end
end

function 角色:交易_取召唤()
    local list = {}
    for k, v in self:遍历召唤() do
        table.insert(list, {
            nid = v.nid,
            名称 = v.名称,
            --外形 = v.外形,
            禁止交易 = v.禁止交易 or v.是否参战 or v.是否观看 or v.被管制
        })
    end
    return list
end

function 角色:禁交易处理(封禁)
    self.禁交易 = 封禁 + 0
end

function 角色:角色_交易开始(nid)
    if self.禁交易 ~= 0 then
        self.rpc:提示窗口('#R你已被管理禁止交易！')
        return
    end
    if self.交易锁 then
        self.rpc:提示窗口('#Y点开背包解锁，注册用的安全码解锁！')
        return
    end
    if self.转生 == 0 and self.等级 < 50 then
        self.rpc:提示窗口('#R低于50级无法交易')
        return
    end

    if self.是否交易 then
        return
    end

    local P = self.周围玩家[nid]
    if not P then
        self.rpc:提示窗口('#R玩家离你距离太远')
        return
    end
    if P and P.禁交易 ~= 0 then
        self.rpc:提示窗口('#R对方已被管理禁止交易！')
        return
    end
    if P.交易锁 then
        self.rpc:提示窗口('#R对方没有解除安全锁！')
        return
    end
    if P.转生 == 0 and P.等级 < 50 then
        self.rpc:提示窗口('#R对方低于50级无法交易')
        return
    end
    if not self.是否交易 and not self.是否战斗 and not self.是否摆摊 and P and (not P.是否交易 or
            P.交易对象 == self) and not P.是否战斗 and not P.是否摆摊 then
        self.是否交易 = true
        self.交易对象 = P
        self.rpc:交易窗口(P.名称, self.银子, self:交易_取召唤())

        if not P.交易对象 then
            P:角色_交易开始(self.nid)
        end
    end
end

function 角色:角色_交易结束()
    if self.是否交易 then
        local 交易对象 = self.交易对象
        self.交易对象 = nil
        self.是否交易 = false
        self.交易确认 = false
        self.交易确定 = false
        self.rpc:交易窗口()

        if 交易对象 and 交易对象.是否交易 then
            交易对象:角色_交易结束()
        end
    end
end

function 角色:角色_交易确认(银两, 召唤, 物品)
    if self.是否交易 and not self.交易确认 and
        type(银两) == 'number' and 银两 >= 0 and 银两 <= self.银子 and
        type(召唤) == 'table' and type(物品) == 'table' then
        self.交易确认 = true
        self.交易银两 = 银两
        self.交易召唤 = {}
        self.交易物品 = {}

        for i, nid in ipairs(召唤) do --唯一检测
            if not self.召唤[nid] then
                return '召唤不存在'
            end
            if self.召唤[nid].rid ~= self.id then
                return '召唤不存在'
            end
            self.交易召唤[i] = self.召唤[nid]
            召唤[i] = { nid = self.召唤[nid].nid, 名称 = self.召唤[nid].名称 }
        end

        for i, t in ipairs(物品) do
            if not self.物品[t.id] then
                return '物品不存在'
            end
            if self.物品[t.id].rid ~= self.id then
                return '物品不存在'
            end
            self.交易物品[i] = self.物品[t.id]:开始交易(t.数量)
            if not self.交易物品[i] then
                return '物品错误'
            end
            物品[i] = self.交易物品[i]:取简要数据()
        end
        self.交易对象.rpc:交易确认(银两, 召唤, 物品)
    end
end

function 角色:角色_交易确定() --todo 交易日志
    -- for i=1,2 do
    if self.是否交易 and self.交易确认 and not self.交易确定 then
        self.交易确定 = true
        local P = self.交易对象
        if P.交易确认 and P.交易确定 then
            if P.交易银两 > P.银子 then
                self:角色_交易结束()
                return
            elseif P.是否摆摊 then
                self.rpc:提示窗口('#Y对方处于摆摊中无法完成交易！')
                P.rpc:提示窗口('#R%s#Y处于摆摊中无法完成交易！', self.名称)
                self:角色_交易结束()
                return
            elseif self.是否摆摊 then
                P.rpc:提示窗口('#Y对方处于摆摊中无法完成交易！')
                self.rpc:提示窗口('#R%s#Y处于摆摊中无法完成交易！', self.名称)
                self:角色_交易结束()
                return
            elseif self.交易银两 > self.银子 then
                self:角色_交易结束()
                return
            elseif not self:物品_检查添加(P.交易物品) then
                self.rpc:提示窗口('#Y你的物品空间不足，交易失败！')
                P.rpc:提示窗口('#R%s#Y的物品空间不足，交易失败！', self.名称)
                self:角色_交易结束()
                return
            elseif not P:物品_检查添加(self.交易物品) then
                P.rpc:提示窗口('#Y你的物品空间不足，交易失败！')
                self.rpc:提示窗口('#R%s#Y的物品空间不足，交易失败！', P.名称)
                self:角色_交易结束()
                return
            elseif not P:召唤_检查添加(self.交易召唤) then
                P.rpc:提示窗口('#Y你的召唤兽携带数量不足')
                self.rpc:提示窗口('#R%s#Y的召唤兽携带数量不足，交易失败！', P.名称)
                self:角色_交易结束()
                return
            elseif not self:召唤_检查添加(P.交易召唤) then
                self.rpc:提示窗口('#Y你的召唤兽携带数量不足')
                P.rpc:提示窗口('#R%s#Y的召唤兽携带数量不足，交易失败！', self.名称)
                self:角色_交易结束()
                return
            end

            for i, v in ipairs(self.交易物品) do
                if v.禁止交易 then
                    self.rpc:提示窗口('#Y绑定物品不能交易')
                    self:角色_交易结束()
                    return
                elseif v.rid ~= self.id then
                    self:角色_交易结束()
                    return
                end
            end
            for i, v in ipairs(P.交易物品) do
                if v.禁止交易 then
                    P.rpc:提示窗口('#Y绑定物品不能交易')
                    self:角色_交易结束()
                    return
                elseif v.rid ~= P.id then
                    self:角色_交易结束()
                    return
                end
            end
            for i, v in ipairs(self.交易召唤) do
                if v.是否参战 or v.是否观看 or v.禁止交易 or v.被管制 then
                    self.rpc:提示窗口('#Y召唤兽#R%s#Y无法交易！', v.名称)
                    self:角色_交易结束()
                    return
                end
            end
            for i, v in ipairs(P.交易召唤) do
                if v.是否参战 or v.是否观看 or v.禁止交易 or v.被管制 then
                    P.rpc:提示窗口('#Y召唤兽#R%s#Y无法交易！', v.名称)
                    self:角色_交易结束()
                    return
                end
            end

            self.银子 = self.银子 - self.交易银两
            self.银子 = self.银子 + P.交易银两
            P.银子 = P.银子 - P.交易银两
            P.银子 = P.银子 + self.交易银两
            if self.交易银两 > 0 then
                self.rpc:提示窗口('#W【交易】#Y你给了#G%s(%s)#R%s#Y两银子', P.名称, P.id, self.交易银两)
                P.rpc:提示窗口('#W【交易】#G%s(%s)#Y给了你#R%s#Y两银子', self.名称, self.id, self.交易银两)
                self:日志_交易记录('【交易】 你给了%s(%s) %s两银子 剩余银子%s', P.名称, P.id, self.交易银两, self.银子)
                P:日志_交易记录('【交易】 %s(%s)给你了 %s两银子 剩余银子%s', self.名称, self.id, self.交易银两, P.银子)
            end
            if P.交易银两 > 0 then
                P.rpc:提示窗口('#W【交易】#Y你给了#G%s(%s)#R%s#Y两银子', self.名称, self.id, P.交易银两)
                self.rpc:提示窗口('#W【交易】#G%s(%s)#Y给了你#R%s#Y两银子', P.名称, P.id, P.交易银两)
                P:日志_交易记录('【交易】 你给了%s(%s) %s两银子 剩余银子%s', self.名称, self.id, P.交易银两, P.银子)
                self:日志_交易记录('【交易】 %s(%s)给你了 %s两银子 剩余银子%s', P.名称, P.id, P.交易银两, self.银子)
            end

            local 物品 = {}
            for i, v in ipairs(P.交易物品) do
                物品[i] = v:结束交易()
                物品[i].rid = self.rid
                if 物品[i].单价2 then
                    物品[i].单价2 = nil
                end

                self.rpc:提示窗口('#W【交易】#Y%s(%s)给了你#Y%s个%s', P.名称, P.id, 物品[i].数量, (物品[i].原名 or 物品[i].名称))
                self:日志_交易记录('【交易】%s(%s) 给你 %s 个%s ', P.名称, P.id, 物品[i].数量, (物品[i].原名 or 物品[i].名称))
                P.rpc:提示窗口('#W【交易】#Y你给了#G%s(%s)#Y%s个%s', self.名称, self.id, 物品[i].数量, (物品[i].原名 or 物品[i].名称))
                P:日志_交易记录('【交易】 你给%s(%s)  %s 个%s ', self.名称, self.id, 物品[i].数量, (物品[i].原名 or 物品[i].名称))
            end
            self:物品_添加(物品)

            物品 = {}
            for i, v in ipairs(self.交易物品) do
                物品[i] = v:结束交易()
                物品[i].rid = P.rid
                if 物品[i].单价2 then
                    物品[i].单价2 = nil
                end
                self.rpc:提示窗口('#W【交易】#Y你给了#G%s(%s) #Y%s个%s', P.名称, P.id, 物品[i].数量, (物品[i].原名 or 物品[i].名称))
                P.rpc:提示窗口('#W【交易】#Y%s(%s) 给了你#Y%s个%s', self.名称, self.id, 物品[i].数量, (物品[i].原名 or 物品[i].名称))

                self:日志_交易记录('【交易】 你给%s(%s)   %s 个%s ', P.名称, P.id, 物品[i].数量, (物品[i].原名 or 物品[i].名称))
                P:日志_交易记录('【交易】%s(%s)  给你  %s 个%s ', self.名称, self.id, 物品[i].数量, (物品[i].原名 or 物品[i].名称))
            end
            P:物品_添加(物品)

            for i, v in ipairs(P.交易召唤) do
                P.召唤[v.nid] = nil
                v.亲密 = 0
                v:刷新属性()
                self:召唤_添加(v)
                P.rpc:提示窗口('#W【交易】你给了#G%s(%s)#Y%s', self.名称, self.id, v.名称)
                self.rpc:提示窗口('#W【交易】#Y%s(%s)给了你#Y%s', P.名称, P.id, v.名称)
                self:日志_交易记录('【交易】%s(%s) 给你  %s', P.名称, P.id, self.名称, v.原名 or v.名称)
                P:日志_交易记录('【交易】你给 %s(%s)  %s', self.名称, self.id, v.原名 or v.名称)
            end
            for i, v in ipairs(self.交易召唤) do
                self.召唤[v.nid] = nil
                v.亲密 = 0
                v:刷新属性()
                P:召唤_添加(v)
                P.rpc:提示窗口('#W【交易】#Y%s(%s) 给了你#Y%s', self.名称, self.id, v.名称)
                self.rpc:提示窗口('#W【交易】你给了#G%s(%s) #Y%s', P.名称, P.id, v.名称)
                self:日志_交易记录('【交易】你给 %s(%s)  %s', P.名称, P.id, v.原名 or v.名称)
                P:日志_交易记录('【交易】%s(%s) 给你  %s', self.名称, self.id, v.原名 or v.名称)
            end
            self.rpc:交易窗口()
            P.rpc:交易窗口()
        end
    end
    -- end
end
