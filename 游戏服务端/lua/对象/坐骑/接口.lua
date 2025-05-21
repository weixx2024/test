local 接口 = {
    名称 = true,
    等级 = true,
    技能 = true,
    种族 = true,
    灵性 = true,
    根骨 = true,
    力量 = true,
    nid = true,
    rid = true,
    几座 = true
}

function 接口:学习技能(name)
    if #self.技能 >= 2 then
        return "只能学习两种技能！"
    end
    for _, v in self:遍历技能() do
        if v.名称 == name then
            return "不能学习已有技能"
        end
    end
    local r = require('对象/法术/坐骑')({ 名称 = name, 类别 = '坐骑' })
    table.insert(self.技能, r)
    self.刷新的属性.技能 = true
end
function 接口:取管制数量()
    local n = 0
    for k, v in pairs(self.管制) do
        n=n+1
    end
    return n
end
function 接口:管制属性计算(对象)
    self:管制属性计算(对象)
end

function 接口:添加经验(n)
    return self:获得经验(n)
end

function 接口:添加技能熟练度(n)
    return self:添加技能熟练度(n)
end

function 接口:取技能数量()
    local n = 0
    for k, v in self:遍历技能() do
        n = n + 1
    end
    return n
end

function 接口:取技能未满熟练数量()
    local n = 0
    for k, v in self:遍历技能() do
        if v.熟练度 < 100000 then
            n = n + 1
        end
    end
    return n
end

function 接口:取技能()
    local t = {}
    for k, v in self:遍历技能() do
        table.insert(t, { 名称 = v.名称 })
    end
    return t
end

function 接口:筋骨提气丸()
    local 上限 = 3
    local ll = self:取坐骑初值上限(self.种族, self.几座)
    if self.初灵 < ll.灵性 + 上限 or self.初力 < ll.力量 + 上限 or self.初根 < ll.根骨 + 上限 then
        if self.初灵 < ll.灵性 + 上限 then
            self.初灵 = self.初灵 + 1
        end

        if self.初力 < ll.力量 + 上限 then
            self.初力 = self.初力 + 1
        end

        if self.初根 < ll.根骨 + 上限 then
            self.初根 = self.初根 + 1
        end
        self:刷新属性()
        return true
    end
    return "#Y你的坐骑初值已满！"
end
function 接口:是否满级()
    
    return self.等级>=100
end
function 接口:洗初值()

    local t = self:取坐骑初值信息(self.种族, self.几座)

    self.初灵 = t.灵性
    self.初力 = t.力量
    self.初根 = t.根骨
    self:刷新属性()
end

function 接口:替换技能(jn, jn2)
    if not self:坐骑_取技能是否存在(jn) then
        self.主人.rpc:常规提示("#Y技能不存在")
        return
    end
    if self:坐骑_取技能是否存在(jn2) then
        self.主人.rpc:常规提示("#Y不能学习已有技能")
        return
    end
    for _, v in self:遍历技能() do
        if v.名称 == jn then
            v.名称 = jn2
            v:转换(jn2)
            break
        end
    end
    self:刷新属性()
    return true
end

function 接口:放生()
    if self.主人.是否战斗 or self.主人.是否摆摊 then
        return '#Y当前状态下无法进行此操作'
    end
    if self.主人.当前坐骑 then --取消乘骑
        self.主人.当前坐骑.是否乘骑 = false
        self.主人.当前坐骑 = nil
        self.主人.外形 = self.主人.原形
    end
    --取消管制
    for _, v in pairs(self.管制) do
        v.被管制 = nil
        v:刷新属性()
    end
    self:删除()
    return true
end

--===============================================================================
if not package.loaded.坐骑接口_private then
    package.loaded.坐骑接口_private = setmetatable({}, { __mode = 'k' })
end
local _pri = require('坐骑接口_private')

local 坐骑接口 = class('坐骑接口')

function 坐骑接口:初始化(P)
    _pri[self] = P
    self.是否坐骑 = true
end

function 坐骑接口:__index(k)
    if k == 0x4253 then
        return _pri[self]
    end
    local r = 接口[k]
    local P = _pri[self]
    if r == true then
        return P[k]
    elseif r then
        return function(_, ...)
            return r(P, ...)
        end
    end
end

return 坐骑接口
