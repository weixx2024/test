
local 角色 = require('角色')

function 角色:召唤_初始化()
    local 存档召唤 = self.召唤
    local _召唤表 = {} -- 真实地址

    self.召唤 =
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
                    __垃圾[k] = _召唤表[k]
                    if __垃圾[k] then
                        __垃圾[k].rid = -1
                    end
                end
                _召唤表[k] = v
            end,
            __index = function(t, k)
                return _召唤表[k]
            end,
            __pairs = function(...)
                return next, _召唤表
            end
        }
    )

    do
        local _召唤仓库表 = {} -- 真实地址
        self.召唤仓库 =
        setmetatable(
            {},
            {
                __newindex = function(t, k, v)
                    if v then
                        v.rid = self.id
                        v.主人 = self
                        v.存放 = true
                        if v.获得时间 == 0 then
                            v.获得时间 = os.time()
                        end
                    else
                        __垃圾[k] = _召唤仓库表[k]
                        __垃圾[k].rid = -1
                    end
                    _召唤仓库表[k] = v
                end,
                __index = function(t, k)
                    return _召唤仓库表[k]
                end,
                __pairs = function(...)
                    return next, _召唤仓库表
                end
            }
        )









    end





    if type(存档召唤) == 'table' then
        for k, v in pairs(存档召唤) do
            if not __召唤[v.nid] or __召唤[v.nid].rid == v.rid then --交易
                local S = require('对象/召唤/召唤')(v)
                if S.存放 then
                    self.召唤仓库[v.nid] = S
                else
                    self.召唤[v.nid] = S
                end


                if S.是否观看 then
                    if self.观看召唤 then
                        S.是否观看 = false
                    else
                        self.观看召唤 = S
                    end
                end
                if S.是否参战 then
                    if self.参战召唤 then
                        S.是否参战 = false
                    else
                        self.参战召唤 = S
                    end
                end
            end
        end
    end

end

function 角色:召唤_更新()
    for k, v in self:遍历召唤() do
        v:更新()
    end
end

function 角色:取召唤兽数量()
    local n = 0
    for k, v in self:遍历召唤() do
        n = n + 1
    end
    if gge.isdebug then
        n = 0
    end
    return n
end

function 角色:取指定召唤兽(nid)
    for k, v in self:遍历召唤() do
        if v.nid == nid then
            return v
        end
    end
    return nil
end


function 角色:召唤_检查添加(t)
    local n = self:取召唤兽数量()
    for k, v in pairs(t) do
        n = n + 1
    end
    if gge.isdebug then
        n = 0
    end
    return self.召唤兽携带上限 >= n
end

function 角色:召唤_添加(S)
    if ggetype(S) == '召唤接口' then
        S = S[0x4253]
    end

    if self:取召唤兽数量() >= self.召唤兽携带上限 then
        return
    end
    if ggetype(S) == '召唤' then
        --召唤数量已达上限。
        self.召唤[S.nid] = S
        self.刷新的属性.召唤列表 = true
        return S
    end
end

function 角色:角色_召唤列表()
    local r = {}
    for k, v in self:遍历召唤() do
        table.insert(
            r,
            {
                nid = v.nid,
                名称 = v.名称,
                外形 = v.外形,
                染色 = v.染色,
                原形 = v.原形,
                获得时间 = v.获得时间,
                单价 = v.单价
            }
        )
    end
    return r
end

function 角色:角色_打开召唤窗口()
    local krd
    local r = self:任务_获取("枯荣丹")
    if r then
        krd = r.对象id
    end
    local list = {}
    for k, v in self:遍历召唤() do
        table.insert(
            list,
            {
                nid = v.nid,
                名称 = v.名称,
                顺序 = v.顺序,
                染色 = v.染色,
                是否参战 = v.是否参战,
                是否观看 = v.是否观看,
                获得时间 = v.获得时间
            }
        )
    end
    return list, krd
end

local function 没有支援(this,k)
    for i,v in pairs(this.支援列表) do
        if v == k then
            return true
        end
    end
end
function 角色:角色_打开支援列表()
    if not next(self.支援列表) then
        for k, v in self:遍历召唤() do
            self.支援列表[#self.支援列表+1] = k
        end
    end
    for k, v in self:遍历召唤() do
        if not 没有支援(self,k) then
            self.支援列表[#self.支援列表+1] = k
        end
    end
    local list = {}
    for i=#self.支援列表,1,-1 do
        local 召唤 = self.召唤[self.支援列表[i]]
        if not 召唤 then
            table.remove(self.支援列表,i)
        end
    end
    for i,v in ipairs(self.支援列表) do
        local 召唤 = self.召唤[v]
        table.insert(
            list,
            {
                nid = 召唤.nid,
                名称 = 召唤.名称,
                等级 = 召唤.等级 or 0,
                转生 = 召唤.转生 or 0,
            }
        )
    end
    return list, self.支援列表.锁定
end

function 角色:角色_锁定首发召唤兽(nid)
    self.支援列表.锁定 = not  self.支援列表.锁定
    return self.支援列表.锁定
end


function 角色:角色_支援上移(nid)
    for i,v in ipairs(self.支援列表) do
        if v == nid and i ~= 1 then
            local a = v
            local b = self.支援列表[i-1]
            self.支援列表[i-1] = a
            self.支援列表[i] = b
            break
        end
    end
    return true
end



function 角色:角色_支援下移(nid)
    for i,v in ipairs(self.支援列表) do
        if v == nid and i ~= #self.支援列表 then
            local a = v
            local b = self.支援列表[i+1]
            self.支援列表[i+1] = a
            self.支援列表[i] = b
            break
        end
    end
    return true
end



function 角色:遍历召唤()
    return pairs(self.召唤)
end

local _炼妖分类 = {

    金柳露 = 1,
    高级金柳露 = 1,
    超级金柳露 = 1,
    沧海珠 = 2,
    蓝田玉 = 2,
    烈焰砂 = 2,
    灵犀角 = 2,
    盘古石 = 2,
    五溪散 = 2,
    武帝袍 = 2,
    霄汉鼎 = 2,
    雪蟾蜍 = 2,
    云罗帐 = 2,

}


function 角色:角色_炼妖(物品, 召唤)
    local zhs = self.召唤[召唤]
    if not zhs then
        return '#R召唤不存在'
    end
    local wp = __物品[物品]
    if wp and wp.rid == self.id then
    else
        return '#R物品不存在'
    end
    return wp:使用(zhs.接口)
end

function 角色:角色_合宠(主, 副)

end
