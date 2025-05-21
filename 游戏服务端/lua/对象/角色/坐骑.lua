local 角色 = require('角色')
function 角色:坐骑_初始化()
    local 存档坐骑 = self.坐骑
    local _坐骑表 = {} -- 真实地址

    self.坐骑 =
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
                    __垃圾[k] = _坐骑表[k]
                    __垃圾[k].rid = -1
                end
                _坐骑表[k] = v
            end,
            __index = function(t, k)
                return _坐骑表[k]
            end,
            __pairs = function(...)
                return next, _坐骑表
            end
        }
    )
    if type(存档坐骑) == 'table' then
        for k, v in pairs(存档坐骑) do
            if not __坐骑[v.nid] or __坐骑[v.nid].rid == v.rid then
                local P = require('对象/坐骑/坐骑')(v)
                self.坐骑[k] = P
                if P.是否乘骑 then
                    self.当前坐骑 = P
                end
            end
        end
    end
end

function 角色:坐骑_更新(sec) --pet
    for _, v in self:遍历坐骑() do
        v:更新(sec)
    end
end

function 角色:坐骑_添加(S) --pet
    if ggetype(S) == '坐骑接口' then
        S = S[0x4253]
    end
    if ggetype(S) == '坐骑' then
        self.坐骑[S.nid] = S
        return S
    end
end

function 角色:角色_打开坐骑窗口()
    local list = {}
    for k, v in self:遍历坐骑() do
        local gz = {}
        for a, b in pairs(v.管制 or {}) do
            table.insert(gz, b.nid)
        end

        table.insert(
            list,
            {
                nid = v.nid,
                名称 = v.名称,
                是否乘骑 = v.是否乘骑,
                几座 = v.几座,
                管制 = gz,
                外形 = 5000 + self.原形 * 10 + v.几座
            }
        )
    end
    local list2 = {}
    for k, v in self:遍历召唤() do
        table.insert(
            list2,
            {
                nid = v.nid,
                名称 = v.名称,
                顺序 = v.顺序,
                获得时间 = v.获得时间
            }
        )
    end
    return list, list2
end

function 角色:遍历坐骑()
    return pairs(self.坐骑)
end

function 角色:清空坐骑()
    for k, v in pairs(self.坐骑) do
        self.坐骑[k] = nil
    end
end
