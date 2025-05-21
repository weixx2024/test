local 帮派 = require('帮派')
local _管理权限 = {
    帮主 = 8,
    副帮主 = 7,
    左护法 = 6,
    右护法 = 5,
    长老 = 4,
    堂主 = 3,
    香主 = 2,
    精英 = 1,
    帮众 = 0,
}
function 帮派:成员添加(P, 职务)
    if not self.成员列表[P.nid] then
        P.帮派 = self.名称
        self.成员列表[P.nid] = {
            名字 = P.名称,
            nid = P.nid,
            等级 = P.等级,
            转生 = P.转生,
            外形 = P.原形,
            性别 = P.性别,
            称谓 = P.称谓,
            种族 = P.种族,
            帮派成就 = P.帮派成就, --
            帮派贡献 = P.帮派贡献, --
            离线时间 = 0,
            职务 = 职务,
            权限 = _管理权限[职务] or 0,
            状态 = '在线',
        }
        self.成员数量 = self.成员数量 + 1
        P:角色_添加称谓(self.名称 .. 职务)
        P:添加帮派对象(self.接口)
        --帮派信息
        self:帮派信息("[帮派总管]#Y恭喜新的朋友#G%s#Y加入大家庭！", P.名称)
        return true
    end
end

function 帮派:添加响应(P, 职务)
    if not self.响应列表[P.nid] then
        P.帮派 = self.名称
        self.响应列表[P.nid] = {
            名字 = P.名称,
            nid = P.nid,
            等级 = P.等级,
            转生 = P.转生,
            外形 = P.原形,
            性别 = P.性别,
            称谓 = P.称谓,
            种族 = P.种族,
            帮派成就 = P.帮派成就, --
            帮派贡献 = P.帮派贡献, --
            离线时间 = 0,
            职务 = 职务,
            权限 = _管理权限[职务] or 0,
            状态 = '在线',
        }
        -- self.成员数量 = self.成员数量 + 1
        -- P:角色_添加称谓(self.名称 .. 职务)
        --P:添加帮派对象(self.接口)
        --帮派信息
        self:帮派响应成功(P)
        return true
    end
end

local _管理数量 = {
    帮主 = 1,
    副帮主 = 1,
    左护法 = 1,
    右护法 = 1,
    长老 = 4,
    堂主 = 6,
    香主 = 6,
    精英 = 24,
}

function 帮派:帮战报名(nid)
    if not __帮战:能否报名() then
        return "当前非报名时间"
    end
    local 操作人 = self.成员列表[nid]
    if not 操作人 then
        return "#Y你不是该帮派成员"
    elseif 操作人.权限 < 7 then
        return "#Y只有帮主和副帮主才可以报名！"
    end
    if __帮战:是否已报名(self.名称) then
        return "#Y你的帮派已经报过名了！"
    end
    __帮战:帮派报名(self.名称)
    return true
end

function 帮派:帮战胜利奖励()
    for nid, v in self:遍历成员() do
        if self.成员列表[nid].帮战进场 then
            self.成员列表[nid].帮战奖励 = 1
            if __玩家[nid] then
                self.成员列表[nid].帮战奖励 = nil
                self.成员列表[nid].帮战进场 = nil
                __帮战:胜利奖励(__玩家[nid].接口)
            end
        end
    end
    self:清除帮战地图()
end

function 帮派:帮战失败奖励()
    for nid, v in self:遍历成员() do
        if self.成员列表[nid].帮战进场 then
            self.成员列表[nid].帮战奖励 = 2
            if __玩家[nid] then
                self.成员列表[nid].帮战奖励 = nil
                self.成员列表[nid].帮战进场 = nil
                __帮战:失败奖励(__玩家[nid].接口)
            end
        end
    end
    self:清除帮战地图()
end

function 帮派:任命成员(nid, P, 职务)
    local 操作人 = self.成员列表[nid]
    local 被操作人 = self.成员列表[P]
    if not 操作人 then
        return "#Y你不是该帮派成员"
    elseif 操作人.权限 ~= 8 then
        return "#Y只有帮主才可以任命职务！"
    elseif not 被操作人 then
        return "#Y对方不是该帮派成员"
    elseif 被操作人.职务 == 职务 then
        return "#Y对方已经再这个职位上了！"
    elseif nid == P then
        return "#Y你不可以任命自己！"
    end
    local n = 0
    if 职务 ~= "帮众" then
        n = self:取官职数量(职务)
        if n >= _管理数量[职务] then
            return "#Y该职务数量已经达到上限,请先取消占有这个职务的成员"
        end
    end
    local PP = __玩家[P]
    if PP then
        PP:删除帮派称谓(self.名称)
        PP:添加称谓_无提示(self.名称 .. 职务)
        PP.rpc:提示窗口("#Y你在帮派内的职务发生了变化！")
    end
    self.成员列表[P].职务 = 职务
    self.成员列表[P].权限 = _管理权限[职务] or 0
    return true
end

function 帮派:逐出成员(nid, P)
    local 操作人 = self.成员列表[nid]
    local 被操作人 = self.成员列表[P]
    if not 操作人 then
        return "#Y你不是该帮派成员"
    elseif not 被操作人 then
        return "#Y对方不是该帮派成员"
    elseif 操作人.权限 < 7 then
        return "#Y只有帮主和副帮主才可以逐出成员！"
    elseif nid == P then
        return "#Y你不可以对自己进行该操作！"
    elseif 被操作人.权限 == 8 then
        return "#Y你不可以对帮主进行该操作！"
    end

    local PP = __玩家[P]
    if PP then
        PP:逐出帮派(self.名称, self.成员列表[P].帮派贡献)
    end
    self.成员列表[P] = nil
    self.成员数量 = self.成员数量 - 1
    return self:取成员列表()
end

function 帮派:删除申请人(nid)
    if self.申请列表[nid] then
        self.申请列表[nid] = nil
    end
    return self:取申请列表()
end

function 帮派:帮派捐款(nid, n)
    if self.成员列表[nid] then
        self.成员列表[nid].帮派贡献 = self.成员列表[nid].帮派贡献 + math.floor(n)
    end
end

function 帮派:解散帮派()
    for k, v in self:遍历成员() do
        if __玩家[v.nid] then
            __玩家[v.nid]:退出帮派("#Y帮派解散了！")
        end
    end
    self:删除()
end
