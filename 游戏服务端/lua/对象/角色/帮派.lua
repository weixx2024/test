local 角色 = require('角色')
-----------------------------------------------基础




function 角色:帮派_初始化()
    if self.帮派 and self.帮派 ~= "" then
        if not __帮派[self.帮派] then
            self.rpc:提示窗口("#Y帮派已经解散！")
            self:删除帮派称谓(self.帮派)
            self.帮派 = "" --提示帮派解散
            --扣除成就 贡献
        else
            self.帮派对象 = __帮派[self.帮派].接口
            if not self.帮派对象.响应成功 then
                self.帮派对象 = nil
                return
            end
            --是否响应成功
            local r = self.帮派对象:取成员(self.nid)
            if not r then
                self.rpc:提示窗口("#Y你已经被移出帮派帮派！")
                self:删除帮派称谓(self.帮派)
                self.帮派贡献 = self.帮派贡献 > 5000000 and self.帮派贡献 - 5000000 or 0
                self.帮派对象 = nil
                self.帮派 = ""
                --扣除成就 贡献
            else
                --验证职务
                local a = self:取帮派职务(self.帮派)
                if r.职务 ~= a then
                    self:删除帮派称谓(self.帮派)
                    self:添加称谓_无提示(self.帮派 .. r.职务)
                end
                self.帮派对象:成员上线(self)
            end
        end
    end
end

function 角色:角色_帮派创建(v, z)
    --  self.帮派=nil
    --响应 24小时 没完  创建失败
    if self.帮派 and self.帮派 ~= '' then
        return "你已经加入了帮派，请先退出现在的帮派！"
    end
    if __帮派[v] then
        return "帮派名称已经存在！还是再想个别的名称吧"
    end
    local 帮派 = require('对象/帮派/帮派')({
        名称 = v,
        宗旨 = z,
        响应 = 1,
        帮主 = self.名称,
        创始人 = self.名称,
        创建时间 = os.time()
    })
    帮派:添加响应(self, '帮主')
    -- 帮派:成员添加(self, '帮主')
    -- 帮派:成员上线(self)
    return true
end

function 角色:添加帮派对象(v)
    self.帮派对象 = v
end

function 角色:角色_同意帮派申请加入(v) --没用
    if not __帮派[v] then
        return
    end
    local 帮派 = __帮派[v]
    self.帮派 = 帮派.名称
    帮派:成员添加(self, '帮众')
    帮派:成员上线(self)
    --__帮派[v]:申请加入(self)
end

function 角色:角色_帮派申请加入(v)
    if self.转生 == 0 and self.等级 < 70 then
        return "达到70级才可以加入帮派"
    end
    if not __帮派[v] then
        return "该帮派已经解散！"
    end
    if self.帮派 and self.帮派 ~= '' then
        return "你已经加入了帮派，请先退出现在的帮派！"
    end

    local 帮派 = __帮派[v]
    return 帮派:申请加入(self)
end

function 角色:角色_响应帮派(v)
    if not __帮派[v] then
        return "该帮派已经解散！"
    end
    if self.帮派 and self.帮派 ~= '' then
        if self.帮派 == v and __帮派[v].帮主 == self.名称 then
            return "你已经申请创立帮派，等待他人响应。"
        end
        return "你已经加入了帮派，请先退出现在的帮派！"
    end
    local 帮派 = __帮派[v]
    return 帮派:响应帮派(self)
end

function 角色:角色_帮派进入地图(name)
    if name and __帮派[name] then
        local 帮派 = __帮派[name]
        if not 帮派.响应成功 then
            return "帮派正在响应中"
        end
        帮派:进入地图(self)
    end

    return "帮派不存在"
end

function 角色:帮派被接受(v)
    if not __帮派[v] then
        return "#Y当前帮派已经被解散"
    end
    local 帮派 = __帮派[v]
    if self.帮派 and self.帮派 ~= '' then
        return 帮派:删除申请人(self.nid), "#Y该玩家已经加入别的帮派"
    end
    self.帮派 = 帮派.名称
    帮派:成员添加(self, '帮众')
    帮派:成员上线(self)
    帮派:删除申请人(self.nid)
    return 帮派:取申请列表(), 帮派:取成员列表()
end

-----------------------------------------取数据
function 角色:角色_打开帮派管理()
    if not self.帮派 or self.帮派 == '' then
        return "#Y你还没有加入任何帮派"
    end
    if not self.帮派对象 then
        return "#Y请等待帮派响应成功"
    end
    return self.帮派对象:打开帮派管理(self.nid)
end

function 角色:角色_取帮派信息()
    if not self.帮派 or self.帮派 == '' then
        return "#Y你还没有加入任何帮派"
    end
    if not self.帮派对象 then
        return "#Y请等待帮派响应成功"
    end
    return self.帮派对象:取现状信息()
end

function 角色:角色_取帮派成员数据(nid)
    if not self.帮派 or self.帮派 == '' then
        return "#Y你还没有加入任何帮派"
    end
    return self.帮派对象:取成员(nid)
end

-----------------------------------------操作



function 角色:角色_任命成员(nid, v)
    if not self.帮派 or self.帮派 == '' then
        return "#Y你还没有加入任何帮派"
    end
    return self.帮派对象:任命成员(self.nid, nid, v)
end

function 角色:角色_逐出成员(nid)
    if not self.帮派 or self.帮派 == '' then
        return "#Y你还没有加入任何帮派"
    end
    return self.帮派对象:逐出成员(self.nid, nid)
end

local _对话 = [[
该玩家已经下线。无法进行此操作，是否将该玩家从申请列表中移出？
menu
1|移出
2|我什么都不想做
]]
function 角色:角色_接收成员(nid)
    if not self.帮派 or self.帮派 == '' then
        return "#Y你还没有加入任何帮派"
    end
    local P = __玩家[nid]
    if not P then
        local r = self.rpc:选择窗口(_对话)
        if r == "1" then
            return self.帮派对象:删除申请人(nid)
        end
        return
    end

    if self.帮派对象:是否满员() then
        return "#Y帮派成员数量已经达到最大数量！"
    end
    return P:帮派被接受(self.帮派)
end

function 角色:角色_拒收成员(nid)
    if not self.帮派 or self.帮派 == '' then
        return "#Y你还没有加入任何帮派"
    end
    return self.帮派对象:删除申请人(nid)
end

local _脱离对话 = [[
你确定要重该帮派退出吗？
menu
1|道不同,不相为谋
2|我什么都不想做
]]
local _帮主脱离对话 = [[
你是帮主,你确定要重该帮派退出吗？#R(退出后该帮派将会解散)
menu
1|我要退出
2|我什么都不想做
]]
function 角色:退出帮派(t)
    self:删除帮派称谓(self.帮派)
    if self.帮派对象 then
        self.帮派贡献 = self.帮派对象:取成员帮派贡献(self.nid)
        self.帮派成就 = self.帮派对象:取成员帮派成就(self.nid)
        self.帮派贡献 = self.帮派贡献 > 5000000 and self.帮派贡献 - 5000000 or 0
        self.帮派对象:删除成员(self.nid)
    end
    self.帮派 = ""
    self.帮派对象 = nil
    if t then
        self.rpc:提示窗口(t)
    end
end

function 角色:逐出帮派(name, n) --被逐出帮派
    self:删除帮派称谓(name)
    if self.帮派 and self.帮派 ~= "" then
        self.帮派 = ""
        --扣除成就 贡献
        self.帮派贡献 = n
        self.帮派贡献 = self.帮派贡献 > 5000000 and self.帮派贡献 - 5000000 or 0
        self.帮派对象 = nil
        self.rpc:提示窗口("#Y你已经被逐出帮派！")
    end
end

function 角色:角色_脱离帮派()
    if not self.帮派 or self.帮派 == '' then
        return "#Y你还没有加入任何帮派"
    end
    local 职务 = self.帮派对象:取成员(self.nid).职务
    local r
    if 职务 == "帮主" then
        r = self.rpc:选择窗口(_帮主脱离对话)
    else
        r = self.rpc:选择窗口(_脱离对话)
    end

    if r == "1" then
        if 职务 == "帮主" then
            self.帮派对象:解散帮派()
        else
            self:退出帮派("#Y你已经退出该帮派！")
        end
    end
end
