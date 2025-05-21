local 角色 = require('角色')

function 角色:角色_取钱庄数据(n)
    return self.银子, self.存银
end

function 角色:角色_钱庄取出(n)
    if type(n) ~= 'number' or math.abs(n) ~= n or math.floor(n) ~= n then
        return self.银子, self.存银
    end
    if self.存银 < n then
        self.rpc:提示窗口("#Y你没有那么多的存款")
        return self.银子, self.存银
    end
    self.存银 = self.存银 - n
    self.银子 = self.银子 + n
    self.rpc:提示窗口("#Y你取出了#G%s#Y两银子！", n)
    return self.银子, self.存银
end

function 角色:角色_钱庄存入(n) --在哪存钱 就是这里
    if type(n) ~= 'number' or math.abs(n) ~= n or math.floor(n) ~= n then
        return self.银子, self.存银
    end
    if self.银子 < n then
        self.rpc:提示窗口("#Y你没有那么多的银两")
        return self.银子, self.存银
    end
    self.存银 = self.存银 + n
    self.银子 = self.银子 - n
    self.rpc:提示窗口("#Y你存入了#G%s#Y两银子！", n)
    return self.银子, self.存银
end

function 角色:角色_扣除银子(n, 来源, 师贡, 数量, 物品, wts)
    if type(n) ~= 'number' or math.abs(n) ~= n or math.floor(n) ~= n then
        return
    end
    if n == 0 then
        return self.银子
    end
    local sg = 0
    local yl = 0
    if 师贡 then
        yl = self.师贡 >= n and 0 or n - self.师贡
        sg = yl == 0 and n or self.师贡
    else
        yl = n
    end


    if self.银子 < yl or self.师贡 < sg then
        return false
    end
    self.师贡 = self.师贡 - sg
    self.银子 = self.银子 - yl


    来源 = 来源 and 来源 or "默认"

    if not wts then
        if sg == 0 then
            self.rpc:提示窗口("#Y你扣除了%s两银子", yl)
            self:日志_银子记录('【扣除银子】扣除%s银子 来源:%s 现有银子:%s', yl, 来源, self.银子)
        elseif yl == 0 then
            self.rpc:提示窗口("#Y你扣除了%s点师贡", sg)
            self:日志_银子记录('【扣除银子】扣除%s师贡 来源:%s 现有师贡:%s', sg, 来源, self.师贡)
        else
            self.rpc:提示窗口("#Y你扣除了%s点师贡和%s两银子", sg, yl)
            self:日志_银子记录('【扣除银子】扣除%s银子 %s师贡 来源:%s 现有银子:%s', yl, sg, 来源,
                self.银子)
        end
    end

    self.刷新的属性.师贡 = true
    self.刷新的属性.银子 = true

    if 数量 and 物品 then
        self:日志_银子记录('【扣除银子】扣除%s银子 %s师贡 来源:%s 现有银子:%s 购买%s个 %s', yl, sg, 来源, self.银子, 数量, 物品.名称)
    end

    return self.银子
end

function 角色:角色_扣除师贡(n, 来源, 银子, wts)
    if type(n) ~= 'number' or math.abs(n) ~= n or math.floor(n) ~= n then
        return
    end
    if n == 0 then
        return self.师贡
    end
    local 扣除师贡 = 0
    local 扣除银子 = 0

    if 银子 then
        扣除师贡 = self.师贡 >= n and n or self.师贡
        扣除银子 = 扣除师贡 == n and 0 or n - self.师贡
    else
        扣除师贡 = n
    end

    if self.银子 < 扣除银子 or self.师贡 < 扣除师贡 then
        return false
    end

    self.师贡 = self.师贡 - 扣除师贡
    self.银子 = self.银子 - 扣除银子


    来源 = 来源 and 来源 or "默认"

    if not wts then
        if 扣除师贡 == 0 then
            self.rpc:提示窗口("#Y你扣除了%s两银子", 扣除银子)
            self:日志_银子记录('【扣除银子】扣除%s银子 来源:%s 现有银子:%s', 扣除银子, 来源, self.银子)
        elseif 扣除银子 == 0 then
            self.rpc:提示窗口("#Y你扣除了%s点师贡", 扣除师贡)
            self:日志_银子记录('【扣除银子】扣除%s师贡 来源:%s 现有师贡:%s', 扣除师贡, 来源, self.师贡)
        else
            self.rpc:提示窗口("#Y你扣除了%s点师贡和%s两银子", 扣除师贡, 扣除银子)
            self:日志_银子记录('【扣除银子】扣除%s银子 %s师贡 来源:%s 现有银子:%s', 扣除银子, 扣除师贡, 来源,
                self.银子)
        end
    end

    self.刷新的属性.师贡 = true
    self.刷新的属性.银子 = true

    return self.师贡
end

function 角色:添加水陆积分(n)
    self.其它.水陆积分 = self.其它.水陆积分 + n
    self.其它.水陆总积分 = self.其它.水陆总积分 + n

    self.rpc:提示窗口('#Y你获得了#R' .. n .. '#Y点水陆积分')
end

function 角色:角色_扣除水陆积分(n)
    if type(n) ~= 'number' or math.abs(n) ~= n or math.floor(n) ~= n then
        return
    end
    if n == 0 then
        return self.其它.水陆积分
    end
    if self.其它.水陆积分 < n then
        return false
    end
    self.其它.水陆积分 = self.其它.水陆积分 - n
    self.rpc:提示窗口("#Y你扣除了%s点水陆积分", n)
    return self.其它.水陆积分
end

function 角色:角色_扣除成就(n)
    if type(n) ~= 'number' or math.abs(n) ~= n or math.floor(n) ~= n then
        return
    end
    if self.帮派成就 < n then
        return
    end
    self.帮派成就 = self.帮派成就 - n
    self.rpc:提示窗口("#Y你扣除了%s点帮派成就", n)
    if self.帮派对象 then
        self.帮派对象:同步成员成就(self.nid, self.帮派成就)
    end
    return self.帮派成就
end

function 角色:角色_扣除体力(n)
    if type(n) ~= 'number' or math.abs(n) ~= n or math.floor(n) ~= n then
        return
    end
    if self.体力 < n then
        self.rpc:提示窗口("#Y体力不足，无法继续！", n)
        return false
    end
    self.体力 = self.体力 - n
    self.体力更新 = true
    self.rpc:提示窗口("#Y你扣除了%s点体力", n)

    return self.体力
end
