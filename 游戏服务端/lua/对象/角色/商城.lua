local 角色 = require('角色')

function 角色:角色_打开商城()
    local 商品列表 = __脚本['scripts/shop/商城.lua']
    local 分类 = {}
    for i, v in ipairs(商品列表) do
        if v.名字 == "GM" then
            if self.管理 > 1 then
                分类[i] = v.名字
            end
        else
            分类[i] = v.名字
        end
    end

    return 分类, self.仙玉
end

function 角色:角色_商城商品列表(n)
    local 商品列表 = __脚本['scripts/shop/商城.lua']
    self.商品检验 = {}
    for i, v in ipairs(商品列表[n]) do
        if v.限时 and not v.结束时间 then
            __脚本['scripts/shop/商城.lua'][n][i].结束时间 = os.time() + v.限时
            商品列表[n][i].结束时间 = os.time() + v.限时
        end

        self.商品检验[i] = tostring(v) --
    end
    return 商品列表[n]
end

function 角色:角色_商城购买(a, b, n)
    if not gge.isdebug then
        if self.交易锁 then
            return '#Y高级操作请先解除安全锁！请不要将安全锁透露给他人。'
        end
    end
    local 商品列表 = __脚本['scripts/shop/商城.lua']
    if 商品列表[a] and 商品列表[a][b] and type(n) == 'number' and n > 0 and n <= 999 then
        if 商品列表[a].名字 == "GM" and not self.管理 then
            return '#Y购买失败，你没有该权限'
        end
        if self.商品检验 and tostring(商品列表[a][b]) == self.商品检验[b] then
            if 商品列表[a].倒数 and 商品列表[a].倒数 > 0 then
                return string.format("#Y该商品还有%s秒后开始抢购", 商品列表[a].倒数)
            end
            local t = GGF.复制表(商品列表[a][b])
            local 总价 = n * t.价格
            -- if gge.isdebug then
            --     总价 = 0
            -- end
            if self.仙玉 < 总价 then
                return '#Y你的积分不足，不能购买！'
            end
            if 商品列表[a].名字 == "限时" then
                if t.结束时间 then
                    if os.time() > t.结束时间 then
                        return '#Y售卖时间已结束'
                    end
                end
                if t.限量 then
                    if t.限量 <= 0 then
                        return '#Y该商品已经销售一空'
                    elseif t.限量 < n then
                        return '#Y超出购买限制数量'
                    end
                end
            end



            t.类别 = nil
            t.价格 = nil
            t.热卖 = nil
            t.属性 = nil
            t.结束时间 = nil
            t.限量 = nil
            t.限时 = nil

            local 物品表 = {}
            local 第一 = __沙盒.生成物品(t)
            if 第一.是否叠加 then
                第一.数量 = n
                table.insert(物品表, 第一)
            else
                for i = 1, n do
                    table.insert(物品表, __沙盒.生成物品(t))
                end
            end

            if self:物品_添加(物品表) then
                if 商品列表[a][b].限量 then
                    __脚本['scripts/shop/商城.lua'][a][b].限量 = __脚本['scripts/shop/商城.lua'][a][b].限量 -
                        n
                end
                self.仙玉 = self.仙玉 - 总价
                self.刷新的属性.仙玉 = self.仙玉
                self.rpc:提示窗口('#Y你购买了%s个#G%s#Y,共花费%s积分。', n, t.名称, 总价)
                self:日志_仙玉记录('你购买了 %s 个 %s 参数的 %s ,共花费%s积分。', n, t.参数 or "无", t.名称, 总价)
                return true
            else
                return '#Y空间不足'
            end
        else
            return '#Y购买失败，请重新刷新'
        end
    end
end
