local 角色 = require('角色')

function 角色:寄售_初始化()
    if __银两寄售数据[self.nid] and __银两寄售数据[self.nid].成交 then
        local t = __银两寄售数据[self.nid]
        if t then
            local 积分 = math.floor(t.价格 * 0.95)
            self.其它.寄售收益积分 = self.其它.寄售收益积分 + 积分
            self.rpc:提示窗口('#Y你寄售的银子已被购买,收益已发放,请再寄售管理界面取出')
            self:日志_寄售记录("%s(%s) 用 %s 仙玉购买我寄售的 %s 银子", t.买家名称, t.买家id, t.价格
                ,
                t.数额)
            __银两寄售数据[self.nid] = nil
        end

    end
    if __积分寄售数据[self.nid] and __积分寄售数据[self.nid].成交 then
        local t = __积分寄售数据[self.nid]
        if t then
            local 银子 = math.floor(t.价格 * 0.95)
            self.其它.寄售收益银子 = self.其它.寄售收益银子 + 银子
            self.rpc:提示窗口('#Y你寄售的积分已被购买,收益已发放,请再寄售管理界面取出')
            self:日志_寄售记录("%s(%s) 用 %s 银子购买我寄售的 %s 仙玉", t.买家名称, t.买家id, t.价格
                ,
                t.数额)
            __积分寄售数据[self.nid] = nil
        end

    end
end

function 角色:角色_上架寄售(数额, 价格, 类型)
    if type(数额) ~= 'number' or math.abs(数额) ~= 数额 or math.floor(数额) ~= 数额 or 数额 <= 0 then
        return "#R上架数额异常"
    end
    if type(价格) ~= 'number' or math.abs(价格) ~= 价格 or math.floor(价格) ~= 价格 or 价格 <= 0 then
        return "#R上架价格异常"
    end
    if 类型 ~= 1 and 类型 ~= 2 then
        return "#R上架类型异常"
    end
    if 类型 == 1 then
        if __银两寄售数据[self.nid] then
            return "#Y还有订单尚未成交"
        end
        if 数额 < 10000000 then
            return "#Y最低上架金额1000W银两！"
        end
        if self.银子 < 数额 then
            return "#Y你没有多银两"
        end
        __银两寄售数据[self.nid] = {
            编号 = __生成ID(),
            id = self.nid,
            rid = self.id,
            角色名称 = self.名称,
            价格 = 价格,
            数额 = 数额,
            获得时间 = os.time(),
            成交 = false
        }
        self.银子 = self.银子 - 数额
        return true
    else
        if __积分寄售数据[self.nid] then
            return "#Y还有订单尚未成交"
        end
        if 数额 < 20 then
            return "#Y最低上架金额20积分！"
        end
        if self.仙玉 < 数额 then
            return '#Y你没有那么多积分'
        end
        __积分寄售数据[self.nid] = {
            编号 = __生成ID(),
            id = self.nid,
            rid = self.id,
            角色名称 = self.名称,
            价格 = 价格,
            数额 = 数额,
            获得时间 = os.time(),
            成交 = false
        }
        self.仙玉 = self.仙玉 - 数额
        return true
    end




end

function 角色:角色_下架寄售(nid, 编号, 类型)
    if nid ~= self.nid then
        return "#R商品角色验证异常"
    end
    if 类型 == "银两" then
        if not __银两寄售数据[self.nid] then
            return "#R该订单不存在"
        end
        if __银两寄售数据[self.nid].编号 ~= 编号 then
            return "#R该订单不存在"
        end
        if __银两寄售数据[self.nid].成交 then
            return "#R该订单已成交"
        end
        self.银子 = self.银子 + __银两寄售数据[self.nid].数额
        __银两寄售数据[self.nid] = nil
        return true
    else
        if not __积分寄售数据[self.nid] then
            return "#R该订单不存在"
        end
        if __积分寄售数据[self.nid].编号 ~= 编号 then
            return "#R该订单不存在"
        end
        if __积分寄售数据[self.nid].成交 then
            return "#R该订单已成交"
        end
        self.仙玉 = self.仙玉 + __积分寄售数据[self.nid].数额
        __积分寄售数据[self.nid] = nil
        return true
    end



end

function 角色:角色_获取银子寄售()
    if __银两寄售数据[self.nid] then
        return __银两寄售数据[self.nid], self.其它.寄售收益积分
    end
    return nil, self.其它.寄售收益积分
end

function 角色:角色_获取积分寄售()
    if __积分寄售数据[self.nid] then
        return __积分寄售数据[self.nid], self.其它.寄售收益银子
    end
    return nil, self.其它.寄售收益银子
end

function 角色:角色_寄售收益取出(类型)
    if 类型 == "银子" then
        if self.其它.寄售收益积分 > 0 then
            self.接口:添加仙玉(self.其它.寄售收益积分)
            self.其它.寄售收益积分 = 0
            return true
        else
            return "#R没有可取出收益"
        end
    else
        if self.其它.寄售收益银子 > 0 then
            self.接口:添加银子(self.其它.寄售收益银子)
            self.其它.寄售收益银子 = 0
            return true
        else
            return "#R没有可取出收益"
        end
    end




end

function 角色:角色_获取银子商品列表()
    return __银两寄售数据
end

function 角色:角色_获取积分商品列表()
    return __积分寄售数据
end

function 角色:角色_寄售购买(id, 编号, 类型)
    if id == self.nid then
        return "#R无法购买自己上架的物品"
    end
    if 类型 == "银子" then
        local t = __银两寄售数据[id]
        if not t then
            return "#R该订单状态已变更,请刷新界面!"
        end
        if t.编号 ~= 编号 then
            return "#R该订单状态已变更,请刷新界面!"
        end
        if t.成交 then
            return "#R该订单状态已变更,请刷新界面!"
        end
        if self.仙玉 < t.价格 then
            return "#R你没有那么多积分!"
        end
        __银两寄售数据[id].成交 = true
        __银两寄售数据[id].买家名称 = self.名称
        __银两寄售数据[id].买家id = self.id
        local 银子 = math.floor(t.数额 * 1)
        local 积分 = math.floor(t.价格 * 0.95)
        self.仙玉 = self.仙玉 - t.价格
        self.银子 = self.银子 + 银子
        self.rpc:提示窗口('#Y你获得了#R' .. 银子 .. '#Y两银子')
        self.rpc:提示窗口('#Y你扣除了#R' .. t.价格 .. '#Y点积分')
        self:日志_寄售记录("用 %s 仙玉购买了 %s(%s) 寄售的 %s 银子 当前银子 %s", t.价格, t.角色名称
            , t.rid, t.数额, self.银子)
        local P = __玩家[id]
        if P then
            P.其它.寄售收益积分 = P.其它.寄售收益积分 + 积分
            P.rpc:提示窗口('#Y你寄售的银子已被购买,收益已发放,请再寄售管理界面取出')
            P:日志_寄售记录("%s(%s) 用 %s 仙玉购买我寄售的 %s 银子", self.名称, self.id, t.价格,
                t.数额)
            __银两寄售数据[id] = nil
        end
        return true
    else
        local t = __积分寄售数据[id]
        if not t then
            return "#R该订单状态已变更,请刷新界面!"
        end
        if t.编号 ~= 编号 then
            return "#R该订单状态已变更,请刷新界面!"
        end
        if t.成交 then
            return "#R该订单状态已变更,请刷新界面!"
        end
        if self.银子 < t.价格 then
            return "#R你没有那么多银子!"
        end
        __积分寄售数据[id].成交 = true
        __积分寄售数据[id].买家名称 = self.名称
        __积分寄售数据[id].买家id = self.id
        local 银子 = math.floor(t.价格 * 0.95)
        local 积分 = math.floor(t.数额 * 1)
        self.银子 = self.银子 - t.价格
        self.仙玉 = self.仙玉 + 积分

        self.rpc:提示窗口('#Y你获得了#R' .. 积分 .. '#')
        self.rpc:提示窗口('#Y你扣除了#R' .. t.价格 .. '#Y两银子')
        self:日志_寄售记录("用 %s 银子购买了 %s(%s) 寄售的 %s 仙玉 当前仙玉 %s", t.价格, t.角色名称
            , t.rid, t.数额, self.仙玉)
        local P = __玩家[id]
        if P then
            P.其它.寄售收益银子 = P.其它.寄售收益银子 + 银子
            P.rpc:提示窗口('#Y你寄售的积分已被购买,收益已发放,请再寄售管理界面取出')
            P:日志_寄售记录("%s(%s) 用 %s 银子购买我寄售的 %s 仙玉", self.名称, self.id, t.价格,
                t.数额)
            __积分寄售数据[id] = nil
        end
        return true
    end

end
