local _存档表 = require('数据库/存档属性_任务')

local function _get(s, name)
    local 脚本 = __脚本[s] or __脚本['task/模板.lua']
    if type(脚本) == 'table' then
        if name then
            return 脚本[name]
        end
        return 脚本
    end
end

local 任务 = class('任务')

function 任务:初始化(t)
    self:加载存档(t)

    if not self.nid then
        self.nid = __生成ID()
    end
    __任务[self.nid] = self
    self.接口 = require('对象/任务/接口')(self)
    self.脚本 = __任务[t.名称] and __任务[t.名称].脚本
end

function 任务:__index(k)
    local 数据 = rawget(self, '数据')
    if 数据 and 数据[k] ~= nil then
        return 数据[k]
    end
    local r = _get(rawget(self, '脚本'), k)
    if r ~= nil then
        return r
    end
    return _存档表[k]
end

function 任务:__newindex(k, v)
    if (rawget(self, '数据') and self.数据[k]) or _存档表[k] ~= nil then
        self.数据[k] = v
        return
    end

    rawset(self, k, v) --数据,接口,脚本
end

function 任务:取详情(P)
    local func = _get(self.脚本, '任务取详情')
    if type(func) == 'function' then
        return ggexpcall(func, self.接口, P) --脚本
    end
    return '无详情'
end

function 任务:取消(P)
    local func = _get(self.脚本, '任务取消')
    if type(func) == 'function' then
        local r, err = ggexpcall(func, self.接口, P)
        if r == gge.FALSE then
            --print(err)
        end
    end
end

function 任务:镜像()
    local r = {
        nid = self.nid,
        名称 = self.名称,
        获得时间 = self.获得时间
    }
    r.数据 = self.数据
    return 任务(r)
end

function 任务:更新来源(t)
    self.来源 = t
end

function 任务:删除()
    self.来源[self.nid] = nil
end

function 任务:取存档数据(P)
    local r = {
        rid = P.id,
        nid = self.nid,
        名称 = self.名称,
        获得时间 = self.获得时间
    }
    r.数据 = GGF.复制表(self.数据) -- 任务内地图要忽略复制，所以要复制表
    return r
end

function 任务:加载存档(t)
    if type(t.数据) == 'table' then
        rawset(self, '数据', t.数据)
        if type(t.数据.是否追踪) == 'boolean' then
            self.是否追踪 = t.数据.是否追踪
        else
            self.是否追踪 = true
        end
        t.数据 = nil
        for k, v in pairs(t) do
            self[k] = v
        end

        for k, v in pairs(_存档表) do
            if type(v) == 'table' and type(self[k]) ~= 'table' then
                self[k] = {}
            end
        end
    else
        rawset(self, '数据', t)
    end
end

return 任务
