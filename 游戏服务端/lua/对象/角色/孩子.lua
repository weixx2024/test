local 角色 = require('角色')

function 角色:孩子_初始化()
    local 存档孩子 = self.孩子
    local _孩子表 = {} -- 真实地址
    self.孩子 =
        setmetatable(
            {},
            {
                __newindex = function(t, k, v)
                    if v then
                        v.rid = self.id
                        v.主人 = self
                        if v.获得时间 == 0 then
                            v.获得时间 = os.time()
                        end
                    else
                        __垃圾[k] = _孩子表[k]
                        __垃圾[k].rid = -1
                    end
                    _孩子表[k] = v
                end,
                __index = function(t, k)
                    return _孩子表[k]
                end,
                __pairs = function(...)
                    return next, _孩子表
                end
            }
        )
    if type(存档孩子) == 'table' then
        for k, v in pairs(存档孩子) do
            if not __孩子[v.nid] or __孩子[v.nid].rid == v.rid then --交易
                local S = require('对象/孩子/孩子')(v)
                self.孩子[v.nid] = S
                if S.是否参战 then
                    if self.参战孩子 then
                        S.是否参战 = false
                    else
                        self.参战孩子 = S
                    end
                end
            end
        end
    end
end

function 角色:孩子_更新()
    for k, v in self:遍历孩子() do
        v:更新()
    end
end

function 角色:取孩子数量()
    local n = 0
    for k, v in self:遍历孩子() do
        n = n + 1
    end
    return n
end

function 角色:孩子_添加(S)
    if ggetype(S) == '孩子接口' then
        S = S[0x4253]
    end
    if self:取孩子数量() >= 4 then
        return
    end

    if ggetype(S) == '孩子' then
        self.孩子[S.nid] = S
        self.刷新的属性.孩子列表 = true
        return S
    end
end

function 角色:孩子_出家()
    if self.参战孩子 then
        self.参战孩子.是否参战 = false
        self.参战孩子:删除()
        self.参战孩子 = nil
    end

    return '孩子皈依佛门，与世再无牵挂，从此与你尘缘尽无，再不回来!'
end

function 角色:孩子_清空()
    for k, v in self:遍历孩子() do
        self.孩子[v.nid] = nil
    end
end

function 角色:角色_打开孩子窗口()
    local list = {}
    for k, v in self:遍历孩子() do
        table.insert(
            list,
            {
                nid = v.nid,
                名称 = v.名称,
                性别 = v.性别,
                外形 = v.外形,
                --  性别 = v.性别,
                是否参战 = v.是否参战,
                获得时间 = v.获得时间
            }
        )
    end
    return list, krd
end

function 角色:遍历孩子()
    return pairs(self.孩子)
end

function 角色:角色_孩子物品使用(i, 孩子)
    if not self.是否战斗 and not self.是否摆摊 and not self.是否交易 then
        local item = self.物品[i]
        if item then
            if item.孩子是否可用 and item.是否孩子装备 then
                local r = item:检查孩子装备要求(孩子)

                if r == true then
                    local n = item.部位
                    if 孩子.装备[n] then
                        孩子.装备[n]:脱下孩子装备(孩子)
                    end
                    item:穿上孩子装备(孩子)

                    self.物品[i] = 孩子.装备[n]
                    孩子.装备[n] = item

                    孩子:刷新属性()
                    return 3, n
                end
                return r
            elseif item.孩子是否可用 and item.是否引导道具 then
                local r = item:使用引导道具(孩子.接口)

                if type(r) == 'string' then
                    return 0, r
                elseif self.物品[i] == nil then --删除
                    return 2
                end
                return 1, item:取简要数据(self.接口, 孩子.接口)
            elseif item.孩子是否可用 then
                local r = item:使用(孩子.接口)

                if type(r) == 'string' then
                    return 0, r
                elseif self.物品[i] == nil then --删除
                    return 2
                end
                return 1, item:取简要数据(self.接口, 孩子.接口)
            end
        end
    end
end
