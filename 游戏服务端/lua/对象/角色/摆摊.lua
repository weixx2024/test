local function 银两颜色(v)
    v = tostring(v)
    if #v < 5 then
        return '#W' .. GGF.格式化货币(v)
    elseif #v < 6 then
        return '#c25da77' .. GGF.格式化货币(v)
    elseif #v < 7 then
        return '#cfc45dc' .. GGF.格式化货币(v)
    elseif #v < 8 then
        return '#cfbd833' .. GGF.格式化货币(v)
    elseif #v < 9 then
        return '#c04fdf4' .. GGF.格式化货币(v)
    elseif #v < 10 then
        return '#c0afd04' .. GGF.格式化货币(v)
    else
        return '#cad1010' .. GGF.格式化货币(v)
    end
end

local function _刷新摊名(self)
    self.rpc:置摆摊(self.nid, table.unpack(self.是否摆摊))
    self.rpn:置摆摊(self.nid, table.unpack(self.是否摆摊))
end

local function _添加摆摊记录(t, v)
    table.insert(t, 1, v)
    if t[101] then
        table.remove(t, 101)
    end
end

local 角色 = require('角色')

function 角色:角色_摆摊查看出售(nid)
    if self.是否战斗 then
        return
    end
    local P = nid == self.nid and self or self.周围玩家[nid]
    if P and P.是否摆摊 then
        local item = {}
        for i, v in P:物品_遍历物品() do
            if v.单价 then
                local t = v:取简要数据()
                t.价格, t.单价 = t.单价, t.价格
                table.insert(item, t)
            end
        end
        local sum = {}
        for i, v in P:遍历召唤() do
            if v.单价 then
                local t = {
                    nid = v.nid,
                    名称 = v.名称,
                    外形 = v.外形,
                    原形 = v.原形,
                    价格 = v.单价
                }
                table.insert(sum, t)
            end
        end
        return P.外形, P.摆摊摊名, self.银子, item, sum, P.摆摊广告
    end
end

function 角色:角色_摆摊购买(p, nid, 数量, 单价)
    if self.是否战斗 then
        return
    end
    if self.禁交易 ~= 0 then
        self.rpc:提示窗口('#R你已被管理禁止交易！')
        return
    end
    if self.交易锁 then
        self.rpc:提示窗口('#Y点开背包解锁，注册用的安全码解锁！')
        return
    end


    local P = self.周围玩家[p]
    local t = __对象[nid]

    if P and P.是否摆摊 and t and type(数量) == 'number' and 数量 > 0 then
        if (t.数量 and 数量 > t.数量) or t.rid ~= P.id or 单价 ~= t.单价 then
            self.rpc:提示窗口('#Y商品已经更新')
            return
        end
        if self.银子 < 数量 * 单价 then
            self.rpc:提示窗口('#Y现金不足')
            return
        end
        --购买召唤兽 与物品 检测自己身上可否有位置
        if ggetype(t) == '召唤' and not self:召唤_检查添加({ t }) then
            self.rpc:提示窗口('#Y召唤兽携带数量达到上限')
            return
        elseif ggetype(t) == '物品' and not self:物品_检查添加({ t }) then
            self.rpc:提示窗口('#Y包裹栏已经满了！')
            return
        end


        --货架上这个物品的价格已经改变。
        local 总价 = 数量 * 单价
        self.银子 = self.银子 - 总价
        P.银子 = P.银子 + 总价
        P.rpc:提示窗口('#R%s*%d#Y被买走了，你获得了%s#Y两银子。', t.名称, 数量, 银两颜色(总价))
        if ggetype(t) == '物品' then
            local r = t:拆分(数量)
            if r then
                r.单价 = nil
                self:物品_添加 { r }

                table.insert(P.摆摊记录, 1, {
                    类型 = 1,
                    总价 = 总价,
                    玩家 = self.id,
                    数量 = 数量,
                    名称 = t.名称
                })

                if P.摆摊记录[101] then
                    table.remove(P.摆摊记录, 101)
                end

                P:角色_刷新摆摊记录()
                self:日志_交易记录('【摆摊物品】我花了%s银子向%s(%s)购买了%s个%s 剩余银子:%s', 总价, P.名称, P.id, 数量, t.名称, self.银子) --我购买了谁
                P:日志_交易记录('【摆摊物品】%s(%s)花了%s银子向我购买了%s个%s 现有银子:%s', self.名称, self.id, 总价, 数量, t.名称, P.银子) --P卖给了谁
            end
        elseif ggetype(t) == '召唤' then
            P.召唤[nid] = nil
            t.单价 = nil
            t.亲密 = 0
            t:刷新属性()
            self:召唤_添加(t)
            table.insert(P.摆摊记录, 1, {
                类型 = 1,
                总价 = 总价,
                玩家 = self.id,
                数量 = 数量,
                名称 = t
                    .名称
            })
            if P.摆摊记录[101] then
                table.remove(P.摆摊记录, 101)
            end
            P:角色_刷新摆摊记录()
            self:日志_交易记录('【摆摊召唤】我花了%s银子向%s(%s)购买了%s 剩余银子:', 总价, P.名称, P.id, t.原名, self.银子) --我购买了谁
            P:日志_交易记录('【摆摊召唤】%s(%s) 花了%s银子向我购买了%s 现有银子:%s', self.名称, self.id, 总价, t.原名, P.银子) --P卖给了谁
        end
        return true
    end
end

function 角色:角色_取收购信息()
    local list = {}
    for k, v in pairs(self.收购) do
        table.insert(list, v)
    end
    return list
end

function 角色:角色_摆摊查看收购(nid)
    local P = nid == self.nid and self or self.周围玩家[nid]
    if P and P.是否摆摊 then
        local list = {}
        for k, v in pairs(P.收购) do
            table.insert(list, v)
        end
        return P.外形, P.摆摊摊名, list, P.摆摊广告
    end
end

local _限制范围 = {
    [1001] = {
        { x = 141, x2 = 153, y = 121, y2 = 100 },
        { x = 132, x2 = 140, y = 120, y2 = 113 },
        { x = 132, x2 = 140, y = 108, y2 = 98 },
        { x = 127, x2 = 133, y = 127, y2 = 94 },
        { x = 119, x2 = 127, y = 101, y2 = 91 },
        { x = 155, x2 = 163, y = 117, y2 = 94 },
        { x = 163, x2 = 167, y = 115, y2 = 90 },
        { x = 167, x2 = 172, y = 112, y2 = 90 },
        { x = 172, x2 = 178, y = 109, y2 = 89 },
        { x = 178, x2 = 184, y = 106, y2 = 83 },
        { x = 184, x2 = 191, y = 102, y2 = 65 },
        { x = 174, x2 = 184, y = 78,  y2 = 64 },
        { x = 166, x2 = 174, y = 69,  y2 = 55 },
        { x = 155, x2 = 166, y = 65,  y2 = 58 },
        { x = 188, x2 = 205, y = 93,  y2 = 82 },
        { x = 205, x2 = 213, y = 94,  y2 = 88 },
    },
    [1236] = {
        { x = 6128, x2 = 6622, y = 4006, y2 = 3640 },
        { x = 6622, x2 = 7288, y = 4316, y2 = 3580 },
        { x = 7288, x2 = 8364, y = 4322, y2 = 3560 },
        { x = 7036, x2 = 7718, y = 3630, y2 = 3062 },
        { x = 6472, x2 = 7088, y = 3600, y2 = 3014 },
    }

}

local function 取范围(x, y, t)
    if x >= t.x and x <= t.x2 and y >= t.y2 and y <= t.y then
        return true
    end
end

function 角色:角色_摆摊出摊()
    if not self.是否摆摊 and not self.是否战斗 then
        if self.当前坐骑 then
            return '#R请先取消乘骑状态'
        elseif self.是否组队 then
            return '#R请先取消组队状态'
        end
        if self.禁交易 ~= 0 then
            return '#R你已被管理禁止交易！'
        end
        if self.交易锁 then
            return '#Y点开背包解锁，注册用的安全码解锁！'
        end
        if self.转生 == 0 and self.等级 < 50 then
            return '#R低于50级无法出摊'
        end





        if self.地图 ~= 1001 and self.地图 ~= 1236 then
            return '#R这里不准摆摊'
        end
        local t = _限制范围[self.地图]
        local 通过 = false
        if self.地图 == 1001 then
            for i, v in ipairs(t) do
                if 取范围(self.X, self.Y, v) then
                    通过 = true
                    break
                end
            end
        else
            for i, v in ipairs(t) do
                if 取范围(self.x, self.y, v) then
                    通过 = true
                    break
                end
            end
        end

        if not 通过 then
            return '#R这里不准摆摊'
        end


        self.是否摆摊 = { self.摆摊摊名 or '商店' }
        self.摆摊摊名 = '商店'
        self.收购 = {}
        self.最近收购 = {} --是否要做存档--或者存在客户端
        self.摆摊召唤 = {}
        self.摆摊记录 = {}
        self.摆摊广告 = '该玩家很懒，什么都没留下'
        for i, v in self:物品_遍历物品() do
            if v.单价2 then
                v.单价 = v.单价2
                v.单价2 = nil
                v:刷新()
            end
        end
        _刷新摊名(self)
        return true
    end
    return '#Y摆摊失败'
end

function 角色:角色_摆摊盘点()
    if self.是否摆摊 then
        return {
            摊名 = self.摆摊摊名,
            头像 = self.头像,
            银子 = self.银子,
            广告 = self.摆摊广告,
            收购 = self.收购,
            最近收购 = self.最近收购,
            记录 = self.摆摊记录
        }
    end
end

function 角色:角色_查询交易记录(p)
    local P = self.周围玩家[p]
    if P and P.是否摆摊 then
        return P.摆摊记录
    end
end

function 角色:角色_摆摊收摊()
    if self.是否摆摊 then
        self.是否摆摊 = false
        self.收购 = {}
        self.rpc:置摆摊(self.nid)
        self.rpn:置摆摊(self.nid)
        for i, v in self:物品_遍历物品() do
            if v.单价 then
                v.单价2 = v.单价
                v.单价 = nil
                v:刷新()
            end
        end
    end
end

function 角色:角色_摆摊改名(v)
    if self.是否摆摊 and self.摆摊摊名 ~= v and v ~= '' then
        --商店名字太长了 6个中文
        self.摆摊摊名 = v
        self.是否摆摊[1] = v
        _刷新摊名(self)
        return true
    end
end

local _提示 = { --摆摊 不能给予 不能被给予 不能交易 不能被交易
    [1] = "#Y你收购的#G%s#Y上架了，收购单价为%s#Y两。",
    [2] = "#Y你的收购货架满了，不能再设置收购信息了。",
    [3] = "#Y你身上的物品栏空格已经不能满足所有的收购需求。",
    [4] = "#Y对方身上没有那么多银两。",
    [5] = "#Y超出对方收购的数量。",
    [6] = "#Y对方身上没有足够的物品栏。",
}
function 角色:角色_收购上架(名称, 单价, 数量)
    if type(单价) ~= 'number' or type(数量) ~= 'number' or self.银子 < 单价 * 数量 or 单价 <= 0 or 数量 <=
        0 then
        return false
    end
    if #self.收购 >= 12 then
        self.rpc:常规提示(_提示[2])
        return false
    end
    --先遍历收购列表
    --a=判断收购列表中的道具需要多少个格子  需知道 物品可否叠加
    --b=再判断新上架收购物品数量需要多少个格子
    --取角色身上可用空格有多少 <a+b 提示 你身上的物品栏空格已经不能满足所有的收购需求。
    for k, v in pairs(self.收购) do
        if v.名称 == 名称 and v.单价 == 单价 then
            v.数量 = v.数量 + 数量
            self.rpc:常规提示(_提示[1]:format(名称, 银两颜色(单价)))
            return self.收购
        end
    end

    table.insert(self.收购, { 名称 = 名称, 单价 = 单价, 数量 = 数量 })
    self.是否摆摊[2] = true
    _刷新摊名(self)
    self.rpc:常规提示(_提示[1]:format(名称, 银两颜色(单价)))
    for k, v in pairs(self.最近收购) do
        if v == 名称 then
            table.remove(self.最近收购, k)
        end
    end
    table.insert(self.最近收购, 1, 名称)
    if self.最近收购[11] then
        self.最近收购[11] = nil
    end
    return self.收购 --最新收购列表是否刷新
end

function 角色:角色_收购下架(格子, 名称, 单价, 数量)
    local t = self.收购[格子]
    if type(格子) ~= 'number' or not t then
        return false
    end
    if t.名称 == 名称 and t.单价 == 单价 then
        table.remove(self.收购, 格子)
        self.是否摆摊[2] = #self.收购 > 0
        _刷新摊名(self)
    end

    return self.收购
end

function 角色:角色_收购卖出(p, nid, 验证名称, 验证单价, 格子, 数量, 单价)
    if self.禁交易 ~= 0 then
        self.rpc:提示窗口('#R你已被管理禁止交易！')
        return
    end
    local P = self.周围玩家[p]
    local t = __对象[nid]
    if P and t and type(数量) == 'number' and 数量 > 0 then
        local v = P.收购[格子]
        if not v then
            return
        end
        if t.rid ~= self.id then
            return
        end
        if v.名称 ~= 验证名称 or v.单价 ~= 验证单价 then
            self.rpc:提示窗口('#Y商品已经更新')
            return 0
        end
        local 总价 = v.单价 * 数量
        if v.单价 ~= 单价 then
            self.rpc:提示窗口('#Y商品已经更新')
            return
        elseif 总价 > P.银子 then
            self.rpc:常规提示("#Y对方身上没有那么多银两。")
            return
        elseif v.数量 < 数量 then
            self.rpc:常规提示("#Y超出对方收购的数量。")
            return
        elseif t.数量 < 数量 then
            self.rpc:常规提示("#Y你的道具数量没有那么多哦！。")
            return
        end
        if v.名称 ~= t.名称 then
            if v.名称 == "一阶仙器" and (not t.仙器 or t.阶数 ~= 1) then
                return
            elseif v.名称 == "神兵礼盒" and (not t.神兵 or t.等级 ~= 1) then
                return
            elseif v.名称 == "4-8级炼妖石" and (not t.炼妖石 or (t.等级 > 8 or t.等级 < 4)) then
                return
            elseif v.名称 == "9-12级炼妖石" and (not t.炼妖石 or (t.等级 > 12 or t.等级 < 9)) then
                return
            elseif v.名称 == "13级炼妖石" and (not t.炼妖石 or t.等级 ~= 13) then
                return
            elseif v.名称 == "一级宝石" and (not t.宝石 or t.等级 ~= 1) then
                return
            elseif v.名称 == "九彩云龙珠(低)" and (t.名称 ~= "九彩云龙珠" or t.价值 ~= 125) then
                return
            elseif v.名称 == "九彩云龙珠(中)" and (t.名称 ~= "九彩云龙珠" or t.价值 ~= 150) then
                return
            elseif v.名称 == "九彩云龙珠(高)" and (t.名称 ~= "九彩云龙珠" or t.价值 ~= 165) then
                return
            elseif v.名称 == "落魂砂(低)" and (t.名称 ~= "落魂砂" or t.价值 ~= 100) then
                return
            elseif v.名称 == "落魂砂(中)" and (t.名称 ~= "落魂砂" or t.价值 ~= 125) then
                return
            elseif v.名称 == "落魂砂(高)" and (t.名称 ~= "落魂砂" or t.价值 ~= 150) then
                return
            end
        end
        if t.禁止交易 then
            self.rpc:常规提示("#Y禁止交易的物品不可出售。")
            return
        end


        --检测P身上空格   self卖出 P收购
        if ggetype(t) == '物品' then
            local r = t:拆分(数量)
            if not r then
                return
            end
            if P:物品_添加 { r } then
                P.银子 = P.银子 - 总价
                self.银子 = self.银子 + 总价
                self.rpc:提示窗口("#Y你出售了#R%s#Y个#G%s#Y，获得了%s#Y两。", 数量, t.名称, 银两颜色(总价))
                P.收购[格子].数量 = P.收购[格子].数量 - 数量
                --local txt = string.format("#Y店主以%s#Y的价格收购了玩家#R%s的#G%s", 总价, self.名称, t.名称)
                table.insert(P.摆摊记录, 1, {
                    类型 = 2,
                    总价 = 总价,
                    玩家 = self.id,
                    数量 = 数量,
                    名称 = t.名称
                })
                if P.摆摊记录[101] then
                    table.remove(P.摆摊记录, 101)
                end
                P:角色_刷新摆摊记录()
                if P.收购[格子].数量 <= 0 then
                    table.remove(P.收购, 格子)
                    P.是否摆摊[2] = #P.收购 > 0
                    _刷新摊名(P)
                    return 0
                end

                self:日志_记录('【摆摊收购】我把%s个%s已%s两银子卖给了%s现有银两:%s ', 数量,
                    r.名称, 总价, P.名称, self.银子) --我购买了谁
                P:日志_记录('【摆摊收购】我用%s收购%s的%s个%s现有银两:%s ', 总价, self.名称, 数量
                , r.名称, P.银子) --P卖给了谁
            else
                self:物品_添加 { r }
            end
            if r ~= t then
                return t:取简要数据()
            end
            return
        end
    end
end

--                table.insert(list, v:取简要数据())
function 角色:角色_收购可出售(名称)
    local list = {}
    for i, v in self:物品_遍历物品() do
        if 名称 == v.名称 then
            table.insert(list, v:取简要数据())
        else
            if 名称 == "一阶仙器" and v.仙器 and v.阶数 == 1 then
                table.insert(list, v:取简要数据())
            elseif  名称 == "神兵礼盒" and v.神兵 and v.等级 == 1 then
                table.insert(list, v:取简要数据())                             
            elseif 名称 == "4-8级炼妖石" and v.炼妖石 and v.等级 <= 8 and v.等级 >= 4 then
                table.insert(list, v:取简要数据())
            elseif 名称 == "9-12级炼妖石" and v.炼妖石 and v.等级 <= 12 and v.等级 >= 9 then
                table.insert(list, v:取简要数据())
            elseif 名称 == "13级炼妖石" and v.炼妖石 and v.等级 == 13 then
                table.insert(list, v:取简要数据())
            elseif 名称 == "一级宝石" and v.宝石 and v.等级 == 1 then
                table.insert(list, v:取简要数据())
            elseif 名称 == "九彩云龙珠(低)" and v.名称 == "九彩云龙珠" and v.价值 == 125 then
                table.insert(list, v:取简要数据())
            elseif 名称 == "九彩云龙珠(中)" and v.名称 == "九彩云龙珠" and v.价值 == 150 then
                table.insert(list, v:取简要数据())
            elseif 名称 == "九彩云龙珠(高)" and v.名称 == "九彩云龙珠" and v.价值 == 165 then
                table.insert(list, v:取简要数据())
            elseif 名称 == "落魂砂(低)" and v.名称 == "落魂砂" and v.价值 == 100 then
                table.insert(list, v:取简要数据())
            elseif 名称 == "落魂砂(中)" and v.名称 == "落魂砂" and v.价值 == 125 then
                table.insert(list, v:取简要数据())
            elseif 名称 == "落魂砂(高)" and v.名称 == "落魂砂" and v.价值 == 150 then
                table.insert(list, v:取简要数据())
            end
        end
    end
    return list
end

--#D39270
function 角色:角色_摆摊上架(nid, 单价)
    local t = __对象[nid]
    if t and t.rid == self.id then
        if not (type(单价) == 'number' and 单价 > 0 and 单价 < 99999999999) then
            self.rpc:提示窗口('#Y商品单价必须大于0并且总价不能超过999亿。')
            return
        end

        if ggetype(t) == '物品' then
            if t.禁止交易 then
                self.rpc:提示窗口('#R这件物品不能出售')
                return
            end
            for i, v in self:物品_遍历物品() do
                if v == t then
                    if t.单价 then
                        self.rpc:提示窗口('#Y你把#G%s#Y的单价修改成了%s#Y两', t.名称, 银两颜色(单价))
                    else
                        self.rpc:提示窗口('#Y你把#G%s#Y上架了，单价为%s#Y两', t.名称, 银两颜色(单价))
                    end
                    t.单价 = 单价
                    return true
                end
            end
        elseif ggetype(t) == '召唤' then
            if t.禁止交易 then
                self.rpc:提示窗口('#R这个召唤兽不能出售')
                return
            elseif t.是否观看 then
                self.rpc:提示窗口('#R请先取消观看 状态')
                return
            elseif t.是否参战 then
                self.rpc:提示窗口('#R请先取消参战状态')
                return
            elseif t.被管制 then
                self.rpc:提示窗口('#R请先取消管制状态')
                return
            end
            if self.召唤[nid] == t then
                if t.单价 then
                    self.rpc:提示窗口('#Y你把#G%s#Y的价格修改成了%s#Y两', t.名称, 银两颜色(单价))
                else
                    self.rpc:提示窗口('#Y你把#G%s#Y上架了，价格为%s#Y两', t.名称, 银两颜色(单价))
                end
                t.单价 = 单价
                return true
            end
        end
    end
end

function 角色:角色_摆摊下架(nid)
    local t = __对象[nid]
    if t and t.rid == self.id then
        if ggetype(t) == '物品' then
            for i, v in self:物品_遍历物品() do
                if v == t then
                    t.单价 = nil
                    return true
                end
            end
        elseif ggetype(t) == '召唤' then
            if self.召唤[nid] == t then
                self.召唤[nid].单价 = nil
                return true
            end
        end
    end
end

function 角色:角色_刷新摆摊记录()
    self.rpc:刷新摆摊记录(self.摆摊记录)
end

function 角色:角色_更改摆摊广告(r)
    self.摆摊广告 = r
end

--#Y你要收购的物品#G%s#Y上架了，收购单位为%s#Y两
--#Y店主以%s#Y的价格收购了玩家#R%s的#G%s

--
--输入窗口，请输入摊位说明，请限制在30个中文(60个英文)内。
