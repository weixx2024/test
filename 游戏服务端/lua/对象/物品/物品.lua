local _装备库 = require('数据库/装备库')
-- local _物品库 = require('数据库/物品库')
local _存档表 = require('数据库/存档属性_物品')
local function _get(s, name)
    local 脚本 = __脚本[s] or __脚本['item/默认.lua']
    if type(脚本) == 'table' then
        return 脚本[name]
    end
    return nil -- value expected ?空参数
end

local 装备 = require('对象/物品/装备')
local 装备孩子 = require('对象/物品/装备_孩子')
local 物品 = class('物品', 装备, 装备孩子)

function 物品:初始化(t)
    self:加载存档(t)
    if not self.nid then
        self.nid = __生成ID()
    end
    __物品[self.nid] = self
    self.接口 = require('对象/物品/接口')(self)
    if not self.是否装备 then
        self.脚本 = __物品库[self.名称] and __物品库[self.名称].脚本
        if self.脚本 then
            self.叠加 = tonumber(_get(self.脚本, '叠加')) or 0
        else
            self.叠加 = __物品库[self.名称] and __物品库[self.名称].叠加 or 0
        end
        self.是否叠加 = self.叠加 > 0
    end
end

function 物品:__index(k)
    local 脚本 = rawget(self, '脚本')
    if 脚本 then
        local r = _get(脚本, k)
        if r ~= nil then
            return r
        end
    end

    local 数据 = rawget(self, '数据')
    if 数据 and 数据[k] ~= nil then
        return 数据[k]
    end

    return _存档表[k]
end

function 物品:__newindex(k, v)
    if _存档表[k] ~= nil then
        self.数据[k] = v
        return
    end
    rawset(self, k, v)
end

-- function 物品:__gc()
--     print('物品:__gc', self.名称)
-- end
function 物品:取回收价格(T)
    local func = _get(self.脚本, '取回收价格')
    if type(func) == 'function' then
        local r, err = ggexpcall(func, self.接口, T)
        if r == gge.FALSE then
            return '#R崩了#15'
        elseif type(r) == "number" then
            return r
        end
    end
end

function 物品:使用(...)
    if self.任务物品 then
        return "#R任务道具禁止使用！"
    end
    local func = _get(self.脚本, '使用')
    if type(func) == 'function' then
        local r, err = ggexpcall(func, self.接口, ...)
        if r == gge.FALSE then
            return '#R崩了#15'
        elseif type(r) == 'string' then
            return r
        end

        if self.数量 <= 0 then
            self:删除()
            return true
        end
    end
end

function 物品:使用变身卡(T)
    local func = _get('scripts/item/角色/变身卡.lua', '使用')
    if type(func) == 'function' then
        local r, err = ggexpcall(func, self.接口, T)
        if r == gge.FALSE then
            return '#R崩了#15'
        elseif type(r) == 'string' then
            return r
        end
        if self.数量 <= 0 then
            self:删除()
            return true
        end
    end
end

function 物品:使用符文(T)
    local func = _get('scripts/item/角色/符文.lua', '使用')
    if type(func) == 'function' then
        local r, err = ggexpcall(func, self.接口, T)
        if r == gge.FALSE then
            return '#R崩了#15'
        elseif type(r) == 'string' then
            return r
        end
        if self.数量 <= 0 then
            self:删除()
            return true
        end
    end
end

function 物品:使用引导道具(T)
    local func = _get('scripts/item/孩子/引导道具.lua', '使用')
    if type(func) == 'function' then
        local r, err = ggexpcall(func, self.接口, T)
        if r == gge.FALSE then
            return '#R崩了#15'
        elseif type(r) == 'string' then
            return r
        end
        if self.数量 <= 0 then
            self:删除()
            return true
        end
    end
end

function 物品:减少(N)
    if self.是否叠加 then
        if type(N) == 'number' and N > 0 then
            if self.数量 > N then
                self.数量 = self.数量 - N
                self:刷新()
            else
                self.数量 = 0
                self:删除()
            end
        end
    elseif self.数量 >= N then
        self.数量 = 0
        self:删除()
    end
end

function 物品:增加(N)
    if self.是否叠加 and type(N) == 'number' and N > 0 and self.数量 + N < self.叠加 then
        self.数量 = self.数量 + N
        self:刷新()
        return true
    end
end

function 物品:复制(N)
    local r = self:取数据()
    r.nid = __生成ID()
    if self.是否叠加 and type(N) == 'number' then
        r.数量 = N > self.叠加 and self.叠加 or N
    end
    return 物品(r)
end

function 物品:拆分(N)
    if self.是否叠加 then
        if type(N) == 'number' and N > 0 and N <= self.数量 then
            if self.数量 > N then
                self.数量 = self.数量 - N
                return self:复制(N)
            elseif self.数量 == N then
                self:删除()
                return self
            end
        end
    elseif not N or self.数量 == N then
        self:删除()
        return self
    end
end

function 物品:合并(that)
    if self:检查合并(that) then
        self.数量 = self.数量 + that.数量
        that:删除()
        self:刷新()
        return self
    end
end

function 物品:合并2(that) --合并到叠加上限
    if self:检查合并2(that) then
        that.数量 = that.数量 - (self.叠加 - self.数量)
        self.数量 = self.叠加

        return self
    end
end

function 物品:检查合并(that)
    if that and self.是否叠加 and self.名称 == that.名称 and self.等级 == that.等级 and self.数量 and
        self.数量 + that.数量 <= self.叠加 then
        if (not self.参数 or self.参数 == that.参数) and (not self.价值 or self.价值 == that.价值) and
            self.禁止交易 == that.禁止交易 then
            return true
        end
    end
    return false
end

function 物品:检查合并2(that) --不检查数量
    if that and self.是否叠加 and self.名称 == that.名称 and self.等级 == that.等级 and self.数量 and
        self.数量 ~= self.叠加 then
        if (not self.参数 or self.参数 == that.参数) and (not self.价值 or self.价值 == that.价值) and
            self.禁止交易 == that.禁止交易 then
            return true
        end
    end
    return false
end

function 物品:开始拆分(N)
    if type(N) == 'number' and N > 0 and N <= self.数量 then
        return setmetatable(
            {
                数量 = N,
                结束拆分 = function(this)
                    return self:拆分(this.数量)
                end
            },
            { __index = self, __metatable = self }
        )
    end
end

function 物品:开始交易(N)
    if type(N) == 'number' and N > 0 and N <= self.数量 then
        return setmetatable(
            {
                数量 = N,
                结束交易 = function(this)
                    local r = self:拆分(this.数量)
                    return r
                end
            },
            { __index = self, __metatable = self }
        )
    end
end

function 物品:生成提交(N)
    return require('对象/物品/提交')(self, N)
end

function 物品:丢弃(N)
    if type(N) == 'number' and N > 0 and self.数量 > N then
        self.数量 = self.数量 - N
        return self.数量
    end
    self:删除()
    return 0
end

function 物品:删除(del)
    if self.来源 then
        local B, i = table.unpack(self.来源)
        if B[i] then
            B[i] = nil
            return true
        end
    end
end

function 物品:取简要数据(P, S)
    local r = {
        id = self.id, --文件图标
        nid = self.nid,
        类别 = self.类别, --印章
        禁止交易 = self.禁止交易,
        名称 = self.名称,
        别名 = self.别名,
        数量 = self.数量,
        图标 = self.图标,
        描述 = self.描述,
        单价 = self.单价,
        阶数 = self.阶数,
        是否炼妖 = self.是否炼妖,
    }
    if P then
        if P.是否战斗 then
            r.条件 = self.条件
            r.对象 = self.对象
        elseif P.是否交易 then
            r.禁止交易 = self.禁止交易
        end
    end
    if S then
        r.召唤是否可用 = self.召唤是否可用 == true
        r.孩子是否可用 = self.孩子是否可用 == true
    end

    return r
end

local 整数范围 = require('数据库/装备属性_共用')._整数范围
function 物品:取仙器描述()
    local 属性
    local t, n, l = {}, 1, nil
    l = self.等级需求
    if l then
        t[n] = '#cFEFF72等级要求 ' .. (l[2] and (l[2] .. '转' .. l[1]) or l[1] .. "级")
        n = n + 1
    end
    l = self.属性要求
    if l then
        if l[2] and l[2] > 0 then
            t[n] = '#cFEFF72' .. l[1] .. '要求 ' .. l[2]
            n = n + 1
        end
    end
    if self.基本属性 then
        for _, v in ipairs(self.基本属性) do
            if 整数范围[v[1]] then
                table.insert(t, string.format('#cFEFF72%s %+.0f', v[1], v[2]))
            else
                table.insert(t, string.format('#cFEFF72%s %+.1f%%', v[1], v[2]))
            end
        end
    end
    table.insert(t, string.format("#cFEFF72耐久 %s", self.耐久 .. '/' .. self.最大耐久))
    if self.炼化属性 then
        for _, v in ipairs(self.炼化属性) do
            if 整数范围[v[1]] then
                table.insert(t, string.format('#C%s %+.0f', v[1], v[2]))
            else
                table.insert(t, string.format('#C%s %+.1f%%', v[1], v[2]))
            end
        end
    end

    if self.开光 then
        table.insert(t, string.format("#r#cFEFF72【炼器】#C开光次数%s", self.开光))
    end
    if self.炼器属性 then
        table.insert(t, "#cA39BB2【炼器属性】")
        for _, v in ipairs(self.炼器属性) do
            if 整数范围[v[1]] then
                table.insert(t, string.format('#G%s %+.0f', v[1], v[2]))
            else
                table.insert(t, string.format('#G%s %+.1f%%', v[1], v[2]))
            end
        end
    end

    if self.高级宝石属性 then
        for _, v in ipairs(self.高级宝石属性) do
            table.insert(t, string.format('#c996305%s级 %s %+.0f', v[4], v[1], v[2]))
        end
    end

    if self.特技 then
        table.insert(t, string.format("#r#cFEFF72 特技 #C%s", self.特技))
    elseif self.祈福值 and self.祈福值 > 0 then
        table.insert(t, string.format("#r#cFEFF72祈运 #C%s/1500", self.祈福值))
    end

    table.insert(t, string.format("#cFEFF72编号为 %s", self.编号))
    属性 = table.concat(t, '\n')
    return 属性
end

function 物品:取神兵描述()
    local 属性
    local t, n, l = {}, 1, nil
    l = self.属性要求
    if l then
        if self.装备类别 == "武器" and l[2] > 0 then
            if l[2] and l[2] > 0 then
                t[n] = '#cFEFF72' .. l[1] .. '要求 ' .. l[2]
                n = n + 1
            end
        end
    end

    if self.基本属性 then
        for _, v in ipairs(self.基本属性) do
            if 整数范围[v[1]] then
                table.insert(t, string.format('#cFEFF72%s %+.0f', v[1], v[2]))
            else
                table.insert(t, string.format('#cFEFF72%s %+.1f%%', v[1], v[2]))
            end
        end
    end
    if self.精炼属性 then
        for _, v in ipairs(self.精炼属性) do
            if 整数范围[v[1]] then
                table.insert(t, string.format('#C%s %+.0f', v[1], v[2]))
            else
                table.insert(t, string.format('#C%s %+.1f%%', v[1], v[2]))
            end
        end
    end
    table.insert(t, string.format("#cFEFF72灵气 %s", (self.耐久 or 0) .. '/' .. (self.最大耐久 or 0)))
    table.insert(t, string.format("#cFEFF72等级 %s", self.等级))

    if self.炼化属性 then
        for _, v in ipairs(self.炼化属性) do
            if 整数范围[v[1]] then
                table.insert(t, string.format('#cDCA770%s %+.0f', v[1], v[2]))
            else
                table.insert(t, string.format('#cDCA770%s %+.1f%%', v[1], v[2]))
            end
        end
    end

    if self.开光 then
        table.insert(t, string.format("#r#cFEFF72【炼器】#C开光次数%s", self.开光))
    end
    if self.炼器属性 then
        table.insert(t, "#cA39BB2【炼器属性】")

        for _, v in ipairs(self.炼器属性) do
            if 整数范围[v[1]] then
                table.insert(t, string.format('#G%s %+.0f', v[1], v[2]))
            else
                table.insert(t, string.format('#G%s %+.1f%%', v[1], v[2]))
            end
        end
    end
    if self.高级宝石属性 then
        for _, v in ipairs(self.高级宝石属性) do
            table.insert(t, string.format('#c996305%s级 %s %+.0f', v[4], v[1], v[2]))
        end
    end

    if self.特技 then
        table.insert(t, string.format("#r#cFEFF72 特技 #C%s", self.特技))
    elseif self.祈福值 and self.祈福值 > 0 then
        table.insert(t, string.format("#r#cFEFF72祈运 #C%s/1500", self.祈福值))
    end

    属性 = table.concat(t, '\n')
    return 属性
end

function 物品:取佩饰描述()
    local 属性
    local t, n, l = {}, 1, nil
    l = self.等级需求
    if l then
        t[n] = '#cFEFF72等级要求 ' .. (l[2] and (l[2] .. '转' .. l[1]) or l[1] .. "级")
        n = n + 1
    end
    l = self.属性要求
    if l then
        if l[2] and l[2] > 0 then
            t[n] = '#cFEFF72' .. l[1] .. '要求 ' .. l[2]
            n = n + 1
        end
    end
    if self.基本属性 then
        for _, v in ipairs(self.基本属性) do
            if 整数范围[v[1]] then
                table.insert(t, string.format('#cFEFF72%s %+.0f', v[1], v[2]))
            else
                table.insert(t, string.format('#cFEFF72%s %+.1f%%', v[1], v[2]))
            end
        end
    end
    if self.默契值 and self.默契值上限 then
        table.insert(t, string.format("#cFEFF72默契度 %s", self.默契值 .. '/' .. self.默契值上限))
    end
    if self.品质 then
        table.insert(t, string.format("#cFEFF72品质 %s", self.品质 .. '/1000'))
    end
    if self.耐久 then
        table.insert(t, string.format("#cFEFF72耐久 %s", self.耐久 .. '/' .. self.最大耐久))
    end
    if self.附加属性 then
        for _, v in ipairs(self.附加属性) do
            if 整数范围[v[1]] then
                table.insert(t, string.format('#c12ff00%s %+.0f', v[1], v[2]))
            else
                table.insert(t, string.format('#c12ff00%s %+.1f%%', v[1], v[2]))
            end
        end
    end
    if self.高级宝石属性 then
        for _, v in ipairs(self.高级宝石属性) do
            table.insert(t, string.format('#c996305%s级 %s %+.0f', v[4], v[1], v[2]))
        end
    end
    属性 = table.concat(t, '\n')
    return 属性
end

function 物品:取描述()
    if self.任务物品 then
        return ''
    end
    local 属性
    if self.是否装备 or self.是否孩子装备 then
        if self.仙器 then
            return self:取仙器描述()
        elseif self.神兵 then
            return self:取神兵描述()
        elseif self.佩饰 then
            return self:取佩饰描述()
        end
        local t, n, l = {}, 1, nil
        l = self.等级需求
        if l then
            t[n] = '#cFEFF72等级需求 ' .. (l[2] and (l[2] .. '转' .. l[1]) or l[1])
            n = n + 1
        end
        l = self.属性要求
        if l then
            t[n] = '#cFEFF72' .. l[1] .. '需求 ' .. l[2]
            n = n + 1
        end
        --[[
        性别要求
        角色要求
         ]]
        if self.基本属性 then
            for _, v in ipairs(self.基本属性) do
                if 整数范围[v[1]] then
                    table.insert(t, string.format('#cFEFF72%s %+.0f', v[1], v[2]))
                else
                    table.insert(t, string.format('#cFEFF72%s %+.1f%%', v[1], v[2]))
                end
            end
        end

        if self.宝石属性 then
            local cs = 0
            for _, v in ipairs(self.宝石属性) do
                if 整数范围[v[1]] then
                    table.insert(t, string.format('#cFEFF72%s %+.0f', v[1], v[2]))
                else
                    table.insert(t, string.format('#cFEFF72%s %+.1f%%', v[1], v[2]))
                end
                cs = cs + 1
            end
            table.insert(t, string.format('#cFEFF72打造次数 %s ', cs))
        end




        -- n = n + 1
        -- t[n] = '#cFEFF72装备耐久 ' .. self.耐久 .. '/' .. self.最大耐久
        -- n = n + 1
        if self.耐久 and self.最大耐久 then
            table.insert(t, string.format('#cFEFF72装备耐久 %s/%s', self.耐久, self.最大耐久))
        end


        if self.禁止交易 then
            table.insert(t, "#R禁止交易")
        end



        if self.精炼属性 then
            for _, v in ipairs(self.精炼属性) do
                if 整数范围[v[1]] then
                    table.insert(t, string.format('#C%s %+.0f', v[1], v[2]))
                else
                    table.insert(t, string.format('#C%s %+.1f%%', v[1], v[2]))
                end
            end
        end
        if self.炼化属性 then
            local ys = '#G'
            if self.神兵 then
                ys = '#cDCA770'
            end
            for _, v in ipairs(self.炼化属性) do
                if 整数范围[v[1]] then
                    table.insert(t, string.format('%s%s %+.0f', ys, v[1], v[2]))
                else
                    table.insert(t, string.format('%s%s %+.1f%%', ys, v[1], v[2]))
                end
            end
        end

        if self.开光 then
            table.insert(t, string.format("#r#cFEFF72【炼器】#C开光次数%s", self.开光))
        end
        if self.高级宝石属性 then
            for _, v in ipairs(self.高级宝石属性) do
                table.insert(t, string.format('#c996305%s级 %s %+.0f', v[4], v[1], v[2]))
            end
        end
        if self.炼器属性 then
            table.insert(t, "#cA39BB2【炼器属性】")
            for _, v in ipairs(self.炼器属性) do
                if 整数范围[v[1]] then
                    table.insert(t, string.format('#G%s %+.0f', v[1], v[2]))
                else
                    table.insert(t, string.format('#G%s %+.1f%%', v[1], v[2]))
                end
            end
        end

        if self.特技 then
            table.insert(t, string.format("#r#cFEFF72 特技 #C%s", self.特技))
        elseif self.祈福值 and self.祈福值 > 0 then
            table.insert(t, string.format("#r#cFEFF72祈运 #C%s/1500", self.祈福值))
        end

        属性 = table.concat(t, '\n')
    elseif self.是否变身卡 then
        local func = _get('scripts/item/角色/变身卡.lua', '取描述')
        if type(func) == 'function' then
            属性 = ggexpcall(func, self.接口) --脚本
        end
    elseif self.是否符文 then
        local func = _get('scripts/item/角色/符文.lua', '取描述')
        if type(func) == 'function' then
            属性 = ggexpcall(func, self.接口) --脚本
        end
    else
        local func = _get(self.脚本, '取描述')
        if type(func) == 'function' then
            属性 = ggexpcall(func, self.接口) --脚本
        end
    end
    return 属性
end

function 物品:添加灵气(js, bh)
    local func = _get(self.脚本, '添加灵气')
    if type(func) == 'function' then
        ggexpcall(func, self.接口, js, bh) --脚本
    end
end

function 物品:取查看数据()
    local r = {
        名称 = self.名称,
        图标 = self.图标,
        描述 = self.描述,
        是否绑定 = self.是否绑定,
        属性 = self:取描述()
    }
    return r
end

function 物品:取数据()
    local t = {
        nid = self.nid,
        名称 = self.名称,
        数量 = self.数量,
        获得时间 = self.获得时间,
        丢弃时间 = self.丢弃时间,
        位置 = self.来源[2] --包位置
    }
    t.数据 = GGF.复制表(self.数据) --FIXME loop
    return t
end

function 物品:刷新()
    if self.来源 and self.来源[1] then
        local B, i = table.unpack(self.来源)
        B[i] = self
    end
end

function 物品:更新来源(t, i)
    self.来源 = { t, i }
end

function 物品:取存档数据(P)
    local t = self:取数据()
    t.rid = P.id
    return t
end

function 物品:加载存档(t) --加载存档的表
    if type(t.数据) == 'table' then
        rawset(self, '数据', t.数据)
        t.数据 = nil
        for k, v in pairs(t) do
            self[k] = v
        end
        local 名称 = self.原名 or self.名称
        if _装备库[名称] then
            setmetatable(self.数据, { __index = _装备库[名称] }) -- 物品库是动态脚本，所以不用设置
            -- elseif __物品库[名称] then
            --     setmetatable(self.数据, { __index = __物品库[名称] })
        end
        return
        -- elseif _装备库[t.名称] then
        --     setmetatable(t, { __index = _装备库[t.名称] })
    end
    rawset(self, '数据', t)
end

return 物品
