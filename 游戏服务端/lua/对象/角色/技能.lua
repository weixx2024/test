local 角色 = require('角色')
local _门派技能 = require('数据库/角色').门派技能
local _熟练度上限 = { 10000, 15000, 20000, 25000 }
function 角色:技能_初始化()
    if type(self.技能) == 'table' then
        for nid, v in pairs(self.技能) do
            if not __技能[nid] or __技能[nid].rid == v.rid then
                -- todo zdz 可能有未知错误
                if not v.类别 then
                    v.类别 = '门派'
                end
                self.技能[nid] = require('对象/法术/技能')(v)
                self.技能[nid]:刷新熟练度上限(self)
            else
                self.技能[nid] = nil
            end
        end
    else
        self.技能 = {}
    end
    if self.存档指令[4] then
        for nid, v in pairs(self.技能) do
            if v.名称 == self.存档指令[4] then
                self.存档指令[3] = nid
                break
            end
        end
    end
end

function 角色:角色_打开技能窗口()
    local list = {}
    for k, v in self:遍历技能() do
        list[k] = {
            nid = v.nid,
            名称 = v.名称,
            阶段 = v.阶段,
            熟练度 = v.熟练度
        }
    end
    return list
end

function 角色:角色_技能描述(id)
    if self.技能[id] then
        local 描述, 消耗

        描述 = self.技能[id]:取描述()
        消耗 = self.技能[id]:取消耗()

        return 描述, 消耗
    end
end

function 角色:角色_召唤兽技能描述(nid,jnnid)
    local o = __对象[nid]
    if o then
        for _, v in o:遍历技能() do
            if v.nid == jnnid then -- 战斗
                local 描述, 消耗
                描述 = v:取描述()
                消耗 = v:取消耗()
                return 描述, 消耗
            end
        end
    end
end


function 角色:遍历技能()
    return next, self.技能
end

function 角色:清空技能()
    for k, v in pairs(self.技能) do
        v.rid = -1
        __垃圾[k] = v
    end
    self.技能 = {}
end

function 角色:删除技能(name)
    for k, v in pairs(self.技能) do
        if v.名称 == name then
            self.技能[k] = nil
            v.rid = -1
            __垃圾[k] = v
            return
        end
    end
end

local 五法 = {
    { "四面楚歌", "万毒攻心", "失心狂乱", "百日眠" },
    { "阎罗追命", "魔神附身", "含情脉脉", "乾坤借速" },
    { "袖里乾坤", "九阴纯火", "天诛地灭", "九龙冰封" },
    { "倩女幽魂", "血海深仇", "吸星大法", "孟婆汤" },

}
function 角色:转生技能检测()
    for _, v in self:遍历技能() do
        for _, b in pairs(五法[self.种族]) do
            if v.名称 == b and v.熟练度 >= v.熟练度上限 then
                return true
            end
        end
    end


    -- local 门派 = require('数据库/角色').基本信息[self.原形].门派
    -- local _门派技能 = require('数据库/角色').门派技能
    -- local list = {}
    -- for i, mp in ipairs(门派) do
    --     local t = _门派技能[mp]
    --     list[i] = {}
    --     for _, jn in ipairs(t) do
    --         if self.接口:取技能是否满熟练(jn) then
    --             table.insert(list[i], true)
    --         end
    --     end
    -- end
    -- local 通过
    -- for i, v in ipairs(list) do
    --     if #v == 5 then
    --         通过 = true
    --     end
    -- end
    -- return 通过


    -- for _, v in self:遍历技能() do
    --     if v.熟练度 < v.熟练度上限 then
    --         return
    --     end
    -- end

    -- return true
end


function 角色:飞升技能检测()
    for _, v in self:遍历技能() do
        if v.类别 == "门派" and v.熟练度 and v.熟练度 < v.熟练度上限 then
            -- print(v.名称)
            return false
        end
    end
    return true
end

function 角色:添加技能(name, sl)
    for _, v in self:遍历技能() do
        if v.名称 == name then
            return false
        end
    end
    local r = require('对象/法术/技能') {
        rid = self.id,
        类别 = '门派',
        名称 = name,
        熟练度 = sl
    }
    r:刷新熟练度上限(self)
    self.技能[r.nid] = r
    self.刷新的属性.技能 = true
    -- self.rpc:常规提示("恭喜你！学会了#R"..name.."#W。")
    return true
end

function 角色:添加技能熟练度(数额, i)
    local 熟练 = math.floor(数额)
    if i == nil then
        for _, v in self:遍历技能() do
            v:添加熟练度(熟练)
        end
    else
        if self.技能[i] then
            self.技能[i]:添加熟练度(熟练)
        end
    end
    return self.技能
end

function 角色:取修正系数(mp, zs)
    local sl = {}
    local t = _门派技能[mp]
    if not t then
        print("错误的门派", mp)
        return 0
    end
    local ss = 0
    for i, v in ipairs(t) do
        ss = 0
        for _, s in self:遍历技能() do
            if v == s.名称 then
                ss = s.熟练度
            end
        end
        table.insert(sl, ss)
    end
    local a = math.floor((sl[1] + sl[2] * 1.2 + sl[3] * 1.5 + sl[4] * 2 + sl[5] * 2.5) / (_熟练度上限[zs + 1] * 8.2
    ) * 100) * 0.01
    if a > 1 then
        a = 1
    end
    return a
end

function 角色:角色_取今世修正系数()
    local 旧门派 = require('数据库/角色').基本信息[self.原形].门派
    local xs = {}
    for _, mp in pairs(旧门派) do
        xs[mp] = self:取修正系数(mp, self.转生)
    end
    return xs
end

-- local _取门派多抗性 = {
--     物理吸收 = "抗震慑",
--     抗毒伤害 = "抗中毒",
-- }
-- function 接口:转生处理(种族, 性别, 外形)
--     if 接口.转生条件检测(self) then
--         return
--     end
--     local 旧门派 = require('数据库/角色').基本信息[self.原形].门派
--     local t = require('数据库/角色').基本信息[外形]

--     if not t then
--         return
--     end
--     local jl = { 种族 = self.种族 * 1000 + self.性别 }
--     local kx
--     local xzxs
--     for _, mp in pairs(旧门派) do
--         kx = _取门派抗性[mp]
--         xzxs = self:取修正系数(mp, self.转生)
--         jl[kx] = xzxs
--         if _取门派多抗性[kx] then
--             jl[_取门派多抗性[kx]] = xzxs
--         end
--     end
