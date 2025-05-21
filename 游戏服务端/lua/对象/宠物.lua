local _存档表 = require('数据库/存档属性_宠物')

local 宠物 = class('宠物')

function 宠物:初始化(t)
    self:加载存档(t)

    if not self.nid then
        self.nid = __生成ID()
    end
    __宠物[self.nid] = self
    self.在线时间 = os.time() + 60


end

function 宠物:__index(k)
    local 数据 = rawget(self, '数据')
    if 数据 and 数据[k] ~= nil then
        return 数据[k]
    end
    return _存档表[k]
end

function 宠物:__newindex(k, v)
    if _存档表[k] ~= nil then
        self.数据[k] = v
        return
    end
    rawset(self, k, v)
end

function 宠物:取简要数据() --地图
    return {
        type = 'pet',
        nid = self.nid,
        名称 = self.名称,
        外形 = self.外形,
        x = self.x,
        y = self.y
    }
end

function 宠物:宠物_改名(v) --pet
    if type(v) ~= 'string' then
        return
    end
    self.名称 = v
    if self.是否观看 then
        self.主人.rpc:切换名称(self.nid, v)
        self.主人.rpn:切换名称(self.nid, v)
    end
    return true
end

function 宠物:宠物_观看(v)
    -- if self.主人.观看宠物 then
    --     self.主人.当前地图:删除宠物(self.主人.观看宠物)
    --     self.主人.观看宠物=nil
    -- end
    -- self.是否观看 = v == true

    -- if self.是否观看 then
    --     self.x, self.y = self.主人.x, self.主人.y
    --     self.主人.当前地图:添加宠物(self)
    --     self.主人.观看宠物 = self
    -- end

    return self.是否观看
end

function 宠物:更新(sec)
    if sec - self.在线时间 >= 60 then
        self.在线时间 = sec + 60
        self:添加经验(1)
    end
end

function 宠物:转生()
    self.等级 = 0
    self.经验 = 0
    self.最大经验 = 6

end

function 宠物:添加经验(n)
    if self.等级 >= 100 then
        return
    end
    self.经验 = self.经验 + math.floor(n)
    if self.经验 >= self.最大经验 then
        self:升级()
    end
    return self.等级
end

function 宠物:升级()
    while self.经验 >= self.最大经验 do
        self.经验 = self.经验 - self.最大经验
        self.等级 = self.等级 + 1
        self.最大经验 = self.等级 * self.等级 * 6
        self.最大耐力 = self.等级 * 10
        if self.等级 >= 100 then
            self.经验 = 0
        end
    end
end

function 宠物:取存档数据(P)
    local r = {
        rid = P.id,
        nid = self.nid,
        外形 = self.外形,
        名称 = self.名称,
        等级 = self.等级,
        耐力 = self.耐力,
        经验 = self.经验,
        最大耐力 = self.最大耐力,
        最大经验 = self.最大经验,
    }
    r.数据 = {}
    for k, v in pairs(_存档表) do
        if type(v) ~= 'table' and self[k] ~= v then
            r.数据[k] = self[k]
        end
    end
    return r
end

function 宠物:加载存档(t)
    if type(t.数据) == 'table' then --加载存档的表
        rawset(self, '数据', t.数据)
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
        self.最大经验 = self.等级 * self.等级 * 6
        self.最大耐力 = self.等级 * 10
    end

    --setmetatable(self.数据, { __index = _存档表 })
    self.是否观看 = self.是否观看 == true
    self.是否选中 = self.是否选中 == true
end

return 宠物
