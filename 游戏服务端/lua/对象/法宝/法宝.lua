local _存档表 = require('数据库/存档属性_法宝')
local _法宝库 = require('数据库/法宝库')
local 经验库 = require('数据库/经验库').法宝经验库









local function _get(s, name)
    local 脚本 = __脚本[s] or __脚本['item/默认.lua']
    if type(脚本) == 'table' then
        return 脚本[name]
    end
    return nil --value expected ?空参数
end

local 法宝 = class('法宝')
function 法宝:初始化(t)
    self:加载存档(t)

    if not self.nid then
        self.nid = __生成ID()
    end
    __法宝[self.nid] = self
    self.接口 = require('对象/法宝/接口')(self)
    self.脚本 = 'scripts/item/法宝/' .. self.名称 .. '.lua'
    self.技能脚本 = 'scripts/skill/法宝/' .. self.名称 .. '.lua'
end

function 法宝:__index(k)
    local 数据 = rawget(self, '数据')
    if 数据 and 数据[k] ~= nil then
        return 数据[k]
    end
    return _存档表[k]
end

function 法宝:__newindex(k, v)
    if _存档表[k] ~= nil then
        self.数据[k] = v
        return
    end
    rawset(self, k, v)
end

function 法宝:取存档数据(P)
    local r = {
        rid = P.id,
        nid = self.nid,
    }

    for _, k in pairs { '名称', '阴阳', '等级', '灵气', '最大灵气', '道行', '升级道行', '佩戴',
        '获得时间', '丢弃时间' } do
        r[k] = self[k]
    end
    r.数据 = {}
    for k, v in pairs(_存档表) do
        if type(v) ~= 'table' and self[k] ~= v then
            r.数据[k] = self[k]
        end
    end
    return r
end

function 法宝:取简要信息()
    return {
        nid = self.nid,
        名称 = self.名称,
        阴阳 = self.阴阳,
        等级 = self.等级,
        获得时间 = self.获得时间,
    }
end

local 道行转换 = function(n)
    local 年 = 0
    local 天 = 0
    local 时 = 0
    年 = math.modf(n / 4380)
    local 余 = math.fmod(n, 4380)
    天 = math.modf(余 / 12)
    时 = math.fmod(余, 12)
    return 年 .. "年" .. 天 .. "天" .. 时 .. "时辰"
end

function 法宝:取等级上限()
    return self.等级 >= 200
end

function 法宝:添加经验(n)
    if self.等级 >= 200 then
        return
    end
    self.道行 = self.道行 + math.floor(n)
    while self.道行 >= self.升级道行 and self.等级 < 200 do
        self.道行 = self.道行 - self.升级道行
        self.等级 = self.等级 + 1
        self.最大灵气 = 500 + self.等级 * 30
        self.升级道行 = self.等级 * self.等级 * self.等级
    end
    return "你的炼丹炉内的" .. self.名称 .. "吸取了" .. 道行转换(math.floor(n)) .. "道行"
end

function 法宝:取描述()
    local 属性
    local list = {}
    table.insert(list, string.format("#cFEFF72属 性：%s", self.阴阳==0 and "阴" or "阳"))
    table.insert(list, string.format("#cFEFF72等 级：%s级", self.等级))
    table.insert(list, string.format("#cFEFF72灵 气：%s/%s", self.灵气, self.最大灵气))
    table.insert(list, string.format("#cFEFF72道 行：%s", 道行转换(self.道行)))
    table.insert(list, string.format("#cFEFF72升级道行：%s", 道行转换(self.升级道行)))
    local func = _get(self.技能脚本, '取描述')
    if type(func) == 'function' then
        local r = ggexpcall(func, self.接口) --脚本
        if r then
            table.insert(list, string.format("#cFEFF72%s", r))
        end
    end
    属性 = table.concat(list, '\n')
    return 属性
end

function 法宝:加载存档(t) --加载存档的表
    if type(t.数据) == 'table' then
        rawset(self, '数据', t.数据)
        t.数据 = nil
        for k, v in pairs(t) do
            self[k] = v
        end
        if _法宝库[self.名称] then
            setmetatable(self.数据, { __index = _法宝库[self.名称] })
        end

    else

        if not t.等级 then
            t.等级 = 1
        end
        t.灵气 = 500 + t.等级 * 30
        t.最大灵气 = 500 + t.等级 * 30
        t.升级道行 = 经验库[t.等级 + 1] or 9999999
        rawset(self, '数据', t)
    end
end

return 法宝
