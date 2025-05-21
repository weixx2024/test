local 角色 = require('角色')
function 角色:管理_初始化()
    self.管理日志 = {}
end

function 角色:角色_GM_移动地图(mid, x, y)
    if self.管理 > 0 or gge.isdebug or self.其它.无限飞 == 1 then
        local map
        if self.当前地图.是否副本 and self.当前地图.rid == mid then
            mid = self.当前地图.id
            map = __副本地图[mid]
        else
            map = __地图[mid]
        end
        if map.是否帮战 then
            return
        end
        if map then
            self:移动_切换地图(map, x, y)
        else
            print('地图不存在')
        end
    end
end

function 角色:角色_寻路移动地图(mid, x, y)
    local map = __地图[mid]
    if map then
        self:移动_切换地图(map, x, y)
    else
        print('地图不存在', mid, x, y)
    end
end

-- function 角色:IP验证()
--     for i,v in ipairs(__config配置) do
--         if self.ip == v then
--             return true
--         end
--     end
--     return false
-- end

---------------------------------------------账号管理

-- function 角色:角色_取管理权限(num)
--     if num then
--         return self.管理 >= num and self:IP验证() and self.管理 or 0
--     else
--         return self.管理 and self:IP验证() and self.管理 or 0
--     end
--     return 0
-- end

function 角色:角色_取管理权限()
    return self.管理
end

function 角色:角色_GM_按账号查询(账号)
    if self.管理 <= 0 then
        return "#Y你没有该权限"
    end
    local user = __存档.查询账号(账号)
    if user then
        if self.管理 < 2 then
            if user.体验 ~= self.标签 then
                return "#Y无法查询其它标签账号信息"
            end
        end
        return user, __存档.角色列表(user.id)
    end
    return "#Y账号不存在"
end

function 角色:角色_GM_按名称查询(名称)
    if self.管理 <= 0 then
        return "#Y你没有该权限"
    end
    local 角色 = __存档.按名称查询角色(名称)
    if 角色 and 角色.uid then
        local user = __存档.按uid查询账号(角色.uid)
        if user and user.账号 then
            return self:角色_GM_按账号查询(user.账号)
        end
    end
    return "#Y角色不存在"
end

function 角色:角色_GM_按ID查询(id)
    if self.管理 <= 0 then
        return "#Y你没有该权限"
    end
    local 角色 = __存档.按ID查询角色(id)
    if 角色 and 角色.uid then
        local user = __存档.按uid查询账号(角色.uid)
        if user and user.账号 then
            return self:角色_GM_按账号查询(user.账号)
        end
    end
    return "#YID不存在"
end

function 角色:GM_账号角色下线(账号)
    local user = __存档.查询账号(账号)
    if user then
        local t = __存档.角色列表(user.id)
        if t then
            for i, v in ipairs(t) do
                if __玩家[v.nid] then
                    __玩家[v.nid]:踢下线()
                end
            end
        end
    end
end

function 角色:角色_GM_修改账号(旧账号, 新账号)
    if self.管理 < 2 then
        return "#Y你没有该权限"
    end
    local r = __存档.修改账号(旧账号, 新账号)
    if r then
        self:GM_账号角色下线(新账号)
        self.rpc:常规提示("#Y修改成功")
        self:GM_输入日志("#R【账号修改】 #W代理#G%s #W将 #Y账号%s #W修改为 #Y%s", self.账号, 旧账号, 新账号)
        return true
    else
        return "#Y账号不存在或者新账号已经存"
    end
end

function 角色:角色_GM_修改安全码(账号, 安全码)
    if self.管理 < 2 then
        return "#Y你没有该权限"
    end
    local r = __存档.修改安全码(账号, 安全码)
    if r then
        self:GM_账号角色下线(账号)
        self.rpc:常规提示("#Y修改成功")
        self:GM_输入日志("#R【安全码修改】 #W代理#G%s #W将 #Y账号%s #W安全码修改为 #Y%s", self.账号, 账号, 安全码)
        return true
    else
        return "#Y账号不存"
    end
end

function 角色:角色_GM_修改密码(账号, 密码)
    if self.管理 < 2 then
        return "#Y你没有该权限"
    end
    local r = __存档.修改密码2(账号, 密码)
    if r then
        self:GM_账号角色下线(账号)
        self.rpc:常规提示("#Y修改成功")
        self:GM_输入日志("#R【密码修改】 #W代理#G%s #W将 #Y账号%s #W密码修改为 #Y%s", self.账号, 账号, 密码)
        return true
    else
        return "#Y账号不存"
    end
end

function 角色:角色_GM_修改权限(账号, 权值)
    if self.管理 < 4 then
        return "#Y你没有该权限"
    end
    local r = __存档.修改权限(账号, 权值)
    if r then
        self.rpc:常规提示("#Y修改成功")
        self:GM_输入日志("#R【权限修改】 #W代理#G%s #W将 #Y账号%s #W权限改为 #Y%s", self.账号, 账号, 权值)
        return true
    end
    return "#Y账号不存"
end

function 角色:角色_GM_修改仙玉(账号, 数值)
    if self.管理 < 4 then
        return "#Y你没有该权限"
    end
    local user = __存档.查询账号(账号)
    if user then
        local 之前 = __仙玉[user.id] or user.仙玉
        local r = __存档.修改仙玉(账号, 数值)
        if r then
            __仙玉[user.id] = 数值
        end
        self.rpc:常规提示("#Y修改成功")
        self:GM_输入日志("#R【仙玉修改】 #W代理#G%s #W将 #Y账号%s #W仙玉 从#Y%s #W改为 #Y%s", self.账号, 账号, 之前, 数值)
        return true
    end
    return "#Y账号不存"
end

function 角色:角色_GM_修改点数(账号, 数值)
    if self.管理 < 4 then
        return "#Y你没有该权限"
    end
    local user = __存档.查询账号(账号)
    if user then
        local r = __存档.修改点数(账号, 数值)
        self.rpc:常规提示("#Y修改成功")
        self:GM_输入日志("#R【点数修改】 #W代理#G%s #W将 #Y账号%s #W点数  #W改为 #Y%s", self.账号, 账号, 数值)
        return true
    end
    return "#Y账号不存"
end

function 角色:角色_是否可操作(账号, 事件, 权限)
    if self.管理 < (权限 or 3) then
        return false, "#Y你没有该权限"
    end
    local user = __存档.查询账号(账号)
    local 标签不符 = user.体验 ~= self.标签 and user.首充 ~= self.标签 or true
    if 事件 == "充值" then
        if self.管理 >= 权限 then
            return true
        end
        if user.首充 == "" then
            标签不符 = false
            __存档.修改首充(账号, self.标签)
            return true, "#Y你成为该账号的首充标签！"
        end
        if 标签不符 then
            return false, "#Y操作账号与你的代理标签不匹配,无法操作"
        end
        return true
    end
end

local _单笔范围 = {
    [1000] = "单笔礼包100",
    [5000] = "单笔礼包500",
    [10000] = "单笔礼包1000",
    [20000] = "单笔礼包2000",
    [30000] = "单笔礼包3000",
    [50000] = "单笔礼包5000"
}
-- 修改script礼包，这里的领取也要改，前面是累计金额，后面是礼包名称
local _累计范围 = {
    { 3000, "累计礼包30" },
    { 10000, "累计礼包100" },
    { 20000, "累计礼包200" },
    { 50000, "累计礼包500" },
    { 100000, "累计礼包1000" },
    { 200000, "累计礼包2000" },
    { 300000, "累计礼包3000" },
    { 400000, "累计礼包4000" },
    { 500000, "累计礼包5000" },
    { 600000, "累计礼包6000" },
    { 700000, "累计礼包7000" },
    { 800000, "累计礼包8000" },
    { 1000000, "累计礼包10000" },
    { 1500000, "累计礼包15000" },
    { 2000000, "累计礼包20000" },
    { 2500000, "累计礼包25000" },
    { 3000000, "累计礼包30000" },
}
function 角色:角色_GM_仙玉充值(账号, 数值)
    if self.管理 < 1 then
        return "#Y你没有该权限"
    end
    --点数
    local user2 = __存档.查询账号(self.账号)
    if not user2 then
        return "#Y管理账号错误"
    end
    local 点数 = user2.点数
    if 点数 < 数值 + 0 then
        return "#Y你的管理点数不足,请联系上级管理"
    end
    local user = __存档.查询账号(账号)
    if user then
        if self.管理 < 4 then
            if user.体验 ~= self.标签 then
                return "#Y该账号与你的管理标签不符,无法对其操作！"
            end
        end
        local 之前 = __仙玉[user.id] or user.仙玉
        local 现在 = 之前 + 数值
        local 累计 = user.累充 + 数值
        local r = __存档.修改仙玉(账号, 现在)
        if r then
            __仙玉[user.id] = 现在
            点数 = 点数 - 数值 + 0
            __存档.修改累计(账号, 累计)
            __存档.修改点数(self.账号, 点数)
            -- local 单笔礼包 = _单笔范围[数值+0]
            -- if 单笔礼包 then
            --     if not __单笔待领取[user.id] then
            --         __单笔待领取[user.id]={}
            --     end
            --     table.insert( __单笔待领取[user.id], {名称=单笔礼包,时间=os.date('%Y-%m-%d %X', os.time()),领取id=0,领取时间=0} )
            -- end
            if not __累计待领取数据[user.id] then
                __累计待领取数据[user.id] = {}
            end
            for i, v in ipairs(_累计范围) do
                if 累计 >= v[1] then
                    if not __累计待领取数据[user.id][i] then
                        __累计待领取数据[user.id][i] = { 名称 = v[2], 时间 = os.date('%Y-%m-%d %X', os.time()), 领取id = 0, 领取时间 = 0 }
                    end
                end
            end
        end
        self.rpc:常规提示("#Y发放成功")
        self:GM_输入日志("#R【发放仙玉】 #W代理#G%s #W为 #Y账号%s 标签%s #W发放仙玉 #Y%s 点 #W剩余点数#R%s", self.账号, 账号, user.体验, 数值, 点数)
        return true, __仙玉[user.id]
    end
    return "#Y账号不存在"
end

function 角色:角色_GM_封禁账号(账号, 数值)
    if self.管理 < 1 then
        return "#Y你没有该权限"
    end
    local user = __存档.查询账号(账号)
    if user then
        if self.管理 < 2 and user.体验 ~= self.标签 then
            return "#Y你无法操作与你标签不符的账号"
        end
        local r = __存档.封禁账号(账号, 数值)
        if 数值 ~= 0 then
            self:GM_账号角色下线(账号)
        end
        self.rpc:常规提示("#Y修改成功")
        self:GM_输入日志("#R【封禁账号】 #W代理#G%s #W对 账号#Y%s  #R%s", self.账号, 账号, 数值 == 0 and "解封" or "封禁")
        return true
    end
    return "#Y账号不存在"
end

function 角色:角色_GM_修改标签(账号, 标签)
    if self.管理 < 4 then
        return "#Y你没有该权限"
    end
    local r = __存档.修改标签(账号, 标签)
    if r then
        self.rpc:常规提示("#Y修改成功")
        self:GM_输入日志("#R【修改标签】 #W代理#G%s #W将账号#Y%s 标签改为 #R%s", self.账号, 账号, 标签)
        return true
    end
    return "#Y账号不存在"
end

function 角色:角色_GM_封禁角色(账号, nid, 封禁)
    if self.管理 < 1 then
        return "#Y你没有该权限"
    end
    local t = __存档.按nid查询角色(nid)
    if t then
        local r = __存档.封禁角色(nid, 封禁)
        if r then
            if __玩家[nid] then
                __玩家[nid]:踢下线()
            end
            self.rpc:常规提示("#Y操作成功")
            self:GM_输入日志("#R【封禁角色】 #W代理#G%s #W将账号#Y%s #W的角色 #R%s#W封禁", self.账号, 账号, t.名称)
        end
    end
end

function 角色:角色_GM_解封角色(账号, nid, 封禁)
    if self.管理 < 1 then
        return "#Y你没有该权限"
    end
    local t = __存档.按nid查询角色(nid)
    if t then
        local r = __存档.封禁角色(nid, 封禁)
        if r then
            self.rpc:常规提示("#Y操作成功")
            self:GM_输入日志("#R【封禁角色】 #W代理#G%s #W将账号#Y%s #W的角色 #R%s#W解封", self.账号, 账号, t.名称)
        end
    end
end

function 角色:角色_GM_角色禁言(账号, nid, 封禁)
    if self.管理 < 1 then
        return "#Y你没有该权限"
    end
    local t = __存档.按nid查询角色(nid)
    if t then
        local r = __存档.角色禁言(nid, 封禁)
        if r then
            if __玩家[nid] then
                __玩家[nid]:禁言处理(封禁)
            end
            self.rpc:常规提示("#Y操作成功")
            self:GM_输入日志("#R【角色禁言】 #W代理#G%s #W将账号#Y%s #W的角色 #R%s#W禁言", self.账号, 账号, t.名称)
        end
    end
end

function 角色:角色_GM_解除禁言(账号, nid, 封禁)
    local t = __存档.按nid查询角色(nid)
    if t then
        local r = __存档.角色禁言(nid, 封禁)
        if r then
            if __玩家[nid] then
                __玩家[nid]:禁言处理(封禁)
            end
            self.rpc:常规提示("#Y操作成功")
            self:GM_输入日志("#R【角色禁言】 #W代理#G%s #W将账号#Y%s #W的角色 #R%s#W解除禁言", self.账号, 账号, t.名称)
        end
    end
end

function 角色:角色_GM_角色封禁交易(账号, nid, 封禁)
    if self.管理 < 1 then
        return "#Y你没有该权限"
    end
    local t = __存档.按nid查询角色(nid)
    if t then
        local r = __存档.角色禁交易(nid, 封禁)
        if r then
            if __玩家[nid] then
                __玩家[nid]:禁交易处理(封禁)
            end
            self.rpc:常规提示("#Y操作成功")
            self:GM_输入日志("#R【封禁交易】 #W代理#G%s #W将账号#Y%s #W的角色 #R%s#W封禁交易", self.账号, 账号, t.名称)
        end
    end
end

function 角色:角色_GM_解除封禁交易(账号, nid, 封禁)
    if self.管理 < 1 then
        return "#Y你没有该权限"
    end
    local t = __存档.按nid查询角色(nid)
    if t then
        local r = __存档.角色禁交易(nid, 封禁)
        if r then
            if __玩家[nid] then
                __玩家[nid]:禁交易处理(封禁)
            end
            self.rpc:常规提示("#Y操作成功")
            self:GM_输入日志("#R【封禁交易】 #W代理#G%s #W将账号#Y%s #W的角色 #R%s#W解除封禁交易", self.账号, 账号, t.名称)
        end
    end
end

--------------------------------------------角色管理
function 角色:角色_GM_修改等级(nid, leve)
    if self.管理 < 3 then
        return "#Y你没有该权限"
    end
    local P = __玩家[nid]
    local name
    if P then
        P:修改等级(leve)
        name = P.名称
    else
        name = __存档.修改角色key(nid, "等级", leve)
    end
    self.rpc:常规提示("#Y操作成功")
    self:GM_输入日志("【等级修改】 代理%s 将角色%s等级修改为%s", self.账号, name, leve)
end

function 角色:角色_GM_修改转生(nid, leve)
    if self.管理 < 3 then
        return "#Y你没有该权限"
    end
    local P = __玩家[nid]
    local name
    if P then
        P:修改转生(leve)
        name = P.名称
    else
        name = __存档.修改角色key(nid, "转生", leve)
    end
    self.rpc:常规提示("#Y操作成功")
    self:GM_输入日志("【转生修改】 代理%s 将角色%s 转生修改为%s", self.账号, name, leve)
end

function 角色:角色_GM_修改银子(nid, leve)
    if self.管理 < 3 then
        return "#Y你没有该权限"
    end
    local P = __玩家[nid]
    local name
    if P then
        P:修改银子(leve)
        name = P.名称
    else
        name = __存档.修改角色key(nid, "银子", leve)
    end
    self.rpc:常规提示("#Y操作成功")
    self:GM_输入日志("【银子修改】 代理%s 将角色%s 银子修改为%s", self.账号, name, leve)
end

function 角色:角色_GM_修改VIP等级(nid, leve)
    if self.管理 < 3 then
        return "#Y你没有该权限"
    end
    local P = __玩家[nid]
    local name
    if P then
        P:修改VIP(leve)
        name = P.名称
    else
        name = __存档.修改角色key(nid, "VIP", leve)
    end
    self.rpc:常规提示("#Y操作成功")
    self:GM_输入日志("【VIP修改】 代理%s 将角色%s VIP等级修改为%s", self.账号, name, leve)
end

function 角色:角色_GM_修改名称(nid, leve)
    if self.管理 < 3 then
        return "#Y你没有该权限"
    end
    if __存档.检测名称(leve) then
        return '名称已存在'
    end
    local P = __玩家[nid]
    local name
    if P then
        P:修改名称(leve)
        name = P.名称
    else
        name = __存档.修改角色key(nid, "名称", leve)
    end
    self.rpc:常规提示("#Y操作成功")
    self:GM_输入日志("【名称修改】 代理%s 将角色%s 名称修改为%s", self.账号, name, leve)
end

function 角色:角色_GM_修复称谓(nid, cw)
    if self.管理 < 3 then
        return "#Y你没有该权限"
    end
    local P = __玩家[nid]
    local name
    if P then
        P:修复称谓(cw)
    end
    self.rpc:常规提示("#Y操作成功")
    self:GM_输入日志("【名称修改】 代理%s 将角色%s 称谓%s修复", self.账号, P.名称, cw)
end

function 角色:角色_GM_踢出战斗(nid)
    if self.管理 < 1 then
        return "#Y你没有该权限"
    end
    local P = __玩家[nid]
    if P then
        if P.是否战斗 then
            P:退出战斗()
            self.rpc:常规提示("#Y操作成功")
        else
            self.rpc:常规提示("#Y该角色不在战斗中")
        end
    else
        self.rpc:常规提示("#Y该角色不在线")
    end
end

function 角色:角色_GM_回出生地(nid)
    if self.管理 < 1 then
        return "#Y你没有该权限"
    end
    local P = __玩家[nid]
    if P then
        P.接口:切换地图(1208, 41, 119)
        self.rpc:常规提示("#Y操作成功")
    else
        self.rpc:常规提示("#Y该角色不在线")
    end
end

function 角色:角色_GM_强制下线(nid)
    if self.管理 < 1 then
        return "#Y你没有该权限"
    end
    local P = __玩家[nid]
    if P then
        P:踢下线()
    else
        self.rpc:常规提示("#Y该角色不在线")
    end
end

function 角色:角色_取管理数据(nid)
    if __玩家[nid] then --在线
        return __玩家[nid]:取角色管理数据()
    end
    local t = __存档.按nid查询角色(nid)
    if t then
        return t
    end
    return "角色不存在"
end

--------------------------------------------道具管理

local _可发动 = {
    VIP1礼包 = true,
    VIP2礼包 = true,
    VIP3礼包 = true,
    VIP4礼包 = true,
    VIP5礼包 = true,
    VIP6礼包 = true,
    VIP7礼包 = true,
    VIP1等级礼包 = true,
    VIP2等级礼包 = true,
    VIP3等级礼包 = true,
    VIP4等级礼包 = true,
}

function 角色:角色_GM_发放道具(账号, nid, t)
    if self.管理 < 3 then
        return "#Y你没有该权限"
    end
    if __玩家[nid] then
        local wp = __沙盒.生成物品(t, __玩家[nid].接口)
        if wp then
            if __玩家[nid]:物品_添加 { wp } then
                self.rpc:常规提示("#Y操作成功")
                self:GM_输入日志("#R【道具发放】 #W代理#G%s #W给账号#Y%s #W的角色 #R%s#W发放#R%s#W道具 名称：%s 数量：%s 参数：%s "
                , self.账号, 账号, __玩家[nid].名称, wp.禁止交易 and "不可交易" or "可交易", wp.名称
                , wp.数量, wp.参数 or "nil")
                return true
            end
            return "#Y对方包裹满了,发送失败"
        end
        return "#Y物品生成失败"
    end
    return "#Y角色不在线"
end

function 角色:角色_GM_发放装备(账号, nid, t)
    if self.管理 < 3 then
        return "#Y你没有该权限"
    end
    if __玩家[nid] then
        local zb = __沙盒.生成装备 { 名称 = t.名称, 等级 = t.等级, 序号 = t.序号 }
        if zb then
            zb.禁止交易 = t.禁止交易
            local ms = {}
            if #t.基本属性 > 0 then
                table.insert(t, "#R基本属性#W")
                zb.基本属性 = t.基本属性
                for _, v in ipairs(zb.基本属性) do
                    table.insert(t, string.format('%s %+.1f', v[1], v[2]))
                end
            end
            if #t.炼化属性 > 0 then
                table.insert(t, "#R炼化属性#W")
                zb.炼化属性 = t.炼化属性
                for _, v in ipairs(zb.炼化属性) do
                    table.insert(t, string.format('%s %+.1f', v[1], v[2]))
                end
            end
            if #t.炼器属性 > 0 then
                zb.开光 = #t.炼器属性 > 5 and 5 or #t.炼器属性
                zb.炼器属性 = t.炼器属性
                table.insert(t, "#R炼器属性#W")
                for _, v in ipairs(zb.炼器属性) do
                    table.insert(t, string.format('%s %+.1f', v[1], v[2]))
                end
            end
            if __玩家[nid]:物品_添加 { zb } then
                self.rpc:常规提示("#Y操作成功")
                local sx = "无修改"
                if #t > 0 then
                    sx = table.concat(t, '，')
                end
                self:GM_输入日志("#R【装备发放】 #W代理#G%s #W给账号#Y%s #W的角色 #R%s#W发放#R%s#W装备 名称：%s 属性:%s "
                , self.账号, 账号, __玩家[nid].名称, zb.禁止交易 and "不可交易" or "可交易", zb.名称
                , sx)
                return true
            end
            return "#Y对方包裹满了,发送失败"
        else
            return "#Y物品生成失败"
        end
    else
    end
    return "#Y你没有该权限"
end

function 角色:角色_GM_发放召唤兽(账号, nid, t)
    if self.管理 < 3 then
        return "#Y你没有该权限"
    end
    if __玩家[nid] then
        local zh = __沙盒.生成召唤 { 名称 = t.名称, 等级 = t.等级, 宝宝 = t.宝宝, 禁止交易 = t.禁止交易 }
        if zh then
            if __玩家[nid]:召唤_添加(zh) then
                self.rpc:常规提示("#Y操作成功")
                self:GM_输入日志("#R【召唤兽发放】 #W代理#G%s #W给账号#Y%s #W的角色 #R%s#W发放#R%s#W召唤兽 名称：%s  "
                , self.账号, 账号, __玩家[nid].名称, zh.禁止交易 and "不可交易" or "可交易", zh.名称)


                return true
            end
            return "#Y对方召唤兽栏已经满了"
        end
        return "#Y召唤兽生成失败,请检查名称是否正确！"
    end
    return "#Y角色不在线"
end

-----------------------------------------------服务器管理
function 角色:角色_GM_发送公告(txt)
    if self.管理 < 3 then
        self.rpc:常规提示("#Y你没有该权限")
        return
    end
    __世界:发送公告(txt)
    self.rpc:常规提示("#Y操作成功")
end

function 角色:角色_GM_保存数据()
    if self.管理 < 3 then
        self.rpc:常规提示("#Y你没有该权限")
        return
    end
    __世界:保存数据()
    self.rpc:常规提示("#Y操作成功")
end

function 角色:角色_GM_关闭服务器()
    if self.管理 < 3 then
        self.rpc:常规提示("#Y你没有该权限")
        return
    end
    __世界:关闭服务器()
    self.rpc:常规提示("#Y操作成功")
end

function 角色:角色_GM_重置日常()
    if self.管理 < 3 then
        self.rpc:常规提示("#Y你没有该权限")
        return
    end
    __世界:重置日常()
end

function 角色:角色_GM_重置双倍()
    if self.管理 < 3 then
        self.rpc:常规提示("#Y你没有该权限")
        return
    end
    __世界:重置双倍()
    self.rpc:常规提示("#Y操作成功")
end

function 角色:角色_GM_查询人数()
    if self.管理 < 3 then
        self.rpc:常规提示("#Y你没有该权限")
        return
    end
    local n, d, bt, wz = __世界:取玩家总数()
    self.rpc:常规提示("#Y当前人数:#G%s#Y掉线人数:#G%s#Y摆摊人数:#G%s#Y其它人数:#G%s"
    , n, d, bt, wz)
end

function 角色:角色_GM_查询IP账号(ip)
    if self.管理 < 3 then
        self.rpc:常规提示("#Y你没有该权限")
        return
    end
    local t = __存档.查询IP账号(ip)
    if t then
        return t
    end
    self.rpc:常规提示("#Y没有查询结果！")
end

function 角色:角色_GM_查询邀请数据(key)
    if self.管理 < 3 then
        self.rpc:常规提示("#Y你没有该权限")
        return
    end
    local t = __存档.查询邀请账号(key)
    local sl = 0
    local jssl = 0
    local uid
    if t then
        for i, v in pairs(t) do
            uid = v.id
            sl = sl + 1
            local tab = __存档.角色列表(uid)
            if tab then
                for _, x in pairs(tab) do
                    jssl = jssl + 1
                end
            end
        end
    end
    self.rpc:常规提示("#Y%s推荐码下共计创建过%s个账号%s个角色", key, sl, jssl)
end

function 角色:角色_GM_封禁IP(ip, n)
    if self.管理 < 3 then
        self.rpc:常规提示("#Y你没有该权限")
        return
    end
    if n == 1 then
        if ip then
            __封禁IP[ip] = true
            __redis:存档数据('封禁IP', __封禁IP)
            local t = __存档.查询IP账号(ip)
            if t then
                for _, v in ipairs(t) do
                    self:角色_GM_封禁账号2(v.账号, 1)
                end
            end
            self:GM_输入日志("【IP封禁】 代理%s 封禁IP%s", self.账号, ip)
            return "#Y封禁成功"
        end
    else
        if ip then
            __封禁IP[ip] = nil
            __redis:存档数据('封禁IP', __封禁IP)
            local t = __存档.查询IP账号(ip)
            if t then
                for _, v in ipairs(t) do
                    self:角色_GM_封禁账号2(v.账号, 0)
                end
            end
            self:GM_输入日志("【IP解封】 代理%s 解封IP%s", self.账号, ip)
            return "#Y封禁成功"
        end
    end
end

function 角色:角色_GM_封禁IP2(ip)
    if self.管理 < 3 then
        self.rpc:常规提示("#Y你没有该权限")
        return
    end

    if ip then
        __封禁IP[ip] = true
        __redis:存档数据('封禁IP', __封禁IP)
        local t = __存档.查询IP账号(ip)
        if t then
            for _, v in ipairs(t) do
                self:角色_GM_封禁账号2(v.账号, 1)
            end
        end
        self:GM_输入日志("【IP封禁】 代理%s 封禁IP%s", self.账号, ip)
        return t
    end
end

function 角色:角色_GM_封禁账号2(账号, 数值)
    if self.管理 < 3 then
        return "#Y你没有该权限"
    end
    local user = __存档.查询账号(账号)
    if user then
        __存档.封禁账号(账号, 数值)
        if 数值 ~= 0 then
            self:GM_账号角色下线(账号)
        end
    end
end

function 角色:角色_GM_开启帮战报名(ip)
    if self.管理 < 3 then
        return "#Y你没有该权限"
    end
    __帮战:开启报名()
    self:GM_输入日志("#W代理#G%s #W开启帮战报名", self.账号)
    self.rpc:常规提示("#Y操作成功")
end

function 角色:角色_GM_开启帮战进场(ip)
    if self.管理 < 3 then
        return "#Y你没有该权限"
    end
    __帮战:开启进场()
    self:GM_输入日志("#W代理#G%s #W开启帮战进场", self.账号)
    self.rpc:常规提示("#Y操作成功")
end

function 角色:角色_GM_开启帮战(ip)
    if self.管理 < 3 then
        return "#Y你没有该权限"
    end
    __帮战:开启帮战()
    self:GM_输入日志("#W代理#G%s #W开启帮战", self.账号)
    self.rpc:常规提示("#Y操作成功")
end

function 角色:角色_GM_关闭帮战(ip)
    if self.管理 < 3 then
        return "#Y你没有该权限"
    end
    __帮战:结束活动()
    self:GM_输入日志("#W代理#G%s #W关闭帮战", self.账号)
    self.rpc:常规提示("#Y操作成功")
end

function 角色:角色_GM_开启水陆报名(ip)
    if self.管理 < 3 then
        return "#Y你没有该权限"
    end
    __水陆大会:开启报名()
    self:GM_输入日志("#W代理#G%s #W开启水陆报名", self.账号)
    self.rpc:常规提示("#Y操作成功")
end

function 角色:角色_GM_开启水陆进场(ip)
    if self.管理 < 3 then
        return "#Y你没有该权限"
    end
    __水陆大会:开启进场()
    self:GM_输入日志("#W代理#G%s #W开启水陆进场", self.账号)
    self.rpc:常规提示("#Y操作成功")
end

function 角色:角色_GM_开启水陆(ip)
    if self.管理 < 3 then
        return "#Y你没有该权限"
    end
    __水陆大会:开启水陆()
    self:GM_输入日志("#W代理#G%s #W开启水陆", self.账号)
    self.rpc:常规提示("#Y操作成功")
end

function 角色:角色_GM_关闭水陆(ip)
    if self.管理 < 3 then
        return "#Y你没有该权限"
    end
    __水陆大会:结束活动()
    self:GM_输入日志("#W代理#G%s #W关闭水陆", self.账号)
    self.rpc:常规提示("#Y操作成功")
end

-- function 角色:角色_GM_开启大闹进场()
--     if self.管理 < 3 then
--         return "#Y你没有该权限"
--     end
--     __大闹天宫:开启进场()
--     self.rpc:常规提示("#Y操作成功")
-- end

-- function 角色:角色_GM_开启大闹()
--     if self.管理 < 3 then
--         return "#Y你没有该权限"
--     end
--     __大闹天宫:开启活动()
--     self.rpc:常规提示("#Y操作成功")
-- end

-- function 角色:角色_GM_关闭大闹()
--     if self.管理 < 3 then
--         return "#Y你没有该权限"
--     end
--     __大闹天宫:关闭活动()
--     self.rpc:常规提示("#Y操作成功")
-- end

-- function 角色:GM_输入日志(...)
--     日志:LOG_管理(...)
--     self.rpc:添加管理日志(...)
-- end
