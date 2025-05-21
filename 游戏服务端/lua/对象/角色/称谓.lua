local 角色 = require('角色')
local _种族称谓 = require('数据库/角色').种族称谓

function 角色:称谓_初始化()
    self.称谓列表 = {}
end

function 角色:角色_打开称谓窗口()
    local r = self:角色_取称谓列表()
    return r
end

function 角色:角色_更换称谓(i)
    if self.帮战状态 then
        self.rpc:提示窗口("#Y帮战中不得更改称谓")
        return
    end

    if not self.称谓列表[i] then
        return false
    end
    self.称谓 = self.称谓列表[i]
    local r = self:角色_取称谓列表()
    self.rpc:切换称谓(self.nid, self.称谓)
    self.rpn:切换称谓(self.nid, self.称谓)
    return r
end

function 角色:角色_隐藏称谓()
    if self.帮战状态 then
        self.rpc:提示窗口("#Y帮战中不得隐藏称谓")
        return
    end

    self.称谓 = ''
    local r = self:角色_取称谓列表()
    self.rpc:切换称谓(self.nid, self.称谓)
    self.rpn:切换称谓(self.nid, self.称谓)

    return r
end

function 角色:角色_删除称谓(t)
    if self.帮战状态 then
        self.rpc:提示窗口("#Y帮战中不得删除称谓")
        return
    end

    for k, v in pairs(self.称谓列表) do
        if v == t then
            table.remove(self.称谓列表, k)
        end
    end
    if self.称谓 == t then
        self.称谓 = ''
        self.rpc:切换称谓(self.nid, self.称谓)
        self.rpn:切换称谓(self.nid, self.称谓)
    end
    local r = self:角色_取称谓列表()
    return r
end

function 角色:添加称谓_无提示(t)
    for k, v in pairs(self.称谓列表) do
        if v == t then
            return false
        end
    end
    self.称谓 = t
    table.insert(self.称谓列表, t)
    return true
end

function 角色:删除帮派称谓(name)
    for k, v in pairs(self.称谓列表) do
        if string.find(v, name) then
            table.remove(self.称谓列表, k)
            if self.称谓 == v then
                self.称谓 = ''
                self.rpc:切换称谓(self.nid, self.称谓)
                self.rpn:切换称谓(self.nid, self.称谓)
            end
        end
    end
end

function 角色:取帮派职务(name)
    for k, v in pairs(self.称谓列表) do
        if string.find(v, name) then
            local t = GGF.分割文本(v, name)
            if t and t[2] then
                return t[2]
            end
        end
    end
end

function 角色:角色_添加称谓(t)
    for k, v in pairs(self.称谓列表) do
        if v == t then
            return false
        end
    end
    self.称谓 = t
    table.insert(self.称谓列表, t)
    self.rpc:提示窗口("#Y恭喜你获得了一个新的称谓：" .. t)
    return true
end


function 角色:添加称谓(t)
    for k, v in pairs(self.称谓列表) do
        if v == t then
            return false
        end
    end
    self.称谓 = t
    table.insert(self.称谓列表, t)
    self.rpc:提示窗口("#Y恭喜你获得了一个新的称谓：" .. t)
    return true
end

function 角色:角色_取称谓列表()
    if not self.是否战斗 then
        local r = { self.称谓 }

        for k, v in self:遍历称谓() do
            r[k + 1] = v
        end
        return r
    end
end

function 角色:遍历称谓()
    return next, self.称谓列表
end

function 角色:取称谓是否存在(r)
    for _, v in self:遍历称谓() do
        if v == r then
            return true
        end
    end
    return false
end

function 角色:剧情称谓转换(z, xz)
    local r = _种族称谓[z] --旧
    local t = _种族称谓[xz] --新
    local n = 0
    for i = 1, 14, 1 do
        if self:剧情称谓是否存在(i) then
            n = i
        end
    end
    if n > 0 then
        for i = 1, n, 1 do
            self:角色_删除称谓(r[i])
            self:角色_添加称谓(t[i])
        end
    end
end

function 角色:清空剧情称谓()
    local t = _种族称谓[self.种族] --旧
    for i, v in ipairs(t) do
        self:角色_删除称谓(v)
    end
end

function 角色:剧情称谓是否存在(n)
    if not n or type(n) ~= "number" then
        return false
    end
    if n == 0 then
        return true
    end
    local t = _种族称谓[self.种族]
    if t then
        local cw = t[n]
        if cw then
            return self:取称谓是否存在(cw)
        end
    end
    return false
end

function 角色:添加剧情称谓(n)
    if not n or type(n) ~= "number" then
        return false
    end
    if n == 0 then
        return true
    end
    local t = _种族称谓[self.种族]
    if t then
        local cw = t[n]
        if cw then
            return self:角色_添加称谓(cw)
        end
    end
    return false
end
