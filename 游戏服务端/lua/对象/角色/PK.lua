--[[
Author: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
Date: 2025-03-03 23:08:19
LastEditors: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
LastEditTime: 2025-03-12 17:09:32
FilePath: \服务端1\lua\对象\角色\PK.lua
Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
--]]
local 角色 = require('角色')





local _安全区域 = {
    [1001] = true,
    [1002] = true,
    [1003] = true,
    [1236] = true,
}


function 角色:PK条件检查(P)
    local map = self.当前地图.接口
    if self:是否队友(P) then
        return false
    end
    if map.是否帮战 then
        if P.攻击城门 or P.操控大炮 or P.操作火塔 or P.操作冰塔 or P.攻击塔 then
            self.rpc:常规提示("#Y对方正在操控建筑，请点击建筑进入战斗")
            return
        end
        if not __帮战:能否PK() then
            self.rpc:常规提示("#Y现在处于准备时间")
            return
        end
        if self.帮派 == P.帮派 then
            self.rpc:常规提示("同帮派玩家不能这么操作")
            return
        end
        if not P.战场状态 then
            self.rpc:常规提示("对方处于帮派领地内")
            return
        end
        if P.复活标记 then
            self.rpc:常规提示("对方处于保护期内")
            return
        end
        return 3
    elseif map.是否副本 then
        return
    else
        local r = self.接口:取任务("杀人香")
        if r then
            if not map.地图等级 then
                self.rpc:常规提示("安全区域内无法强行PK")
                return
            end
            P.rpc:常规提示("被ID%s%s偷袭", self.id + 10000, self.名称)
            return 5
        end
        if not P.设置.切磋开关 then
            self.rpc:常规提示("对方没有打开切磋开关")
            return
        end
        if not self.当前地图.可遇怪 then --安全区只能切磋
            if self.其它.皇宫挑战 and type(self.其它.皇宫挑战) == "table" then
                if self.其它.皇宫挑战.接受 == true and P.其它.皇宫挑战.接受 == true then
                    if (self.其它.皇宫挑战.挑战对象nid == P.其它.皇宫挑战.挑战对象nid) then
                        return 6
                    else
                        self.rpc:常规提示("#YPK对方id不对")
                        return
                    end
                else
                    self.rpc:常规提示("#Y对方没有接受战书")
                    return
                end
            else
                self.rpc:常规提示("#Y安全区域内无法PK")
                return
            end
        end
        return 2
    end
end

function 角色:进入PK(P, ...)
    if P and not self.是否战斗 and not self.是否摆摊 then
        if not P.是否战斗 and not P.是否摆摊 and not P.是否掉线 then
            local r = self:PK条件检查(P)
            if type(r) == "number" then
                self:进入PK战斗(P, r, ...)
            end
        end
    end
end

function 角色:进入PK战斗(P, r, ...) --2切磋3帮战4水陆5杀人香
    if not self.是否战斗 then
        if ggetype(P) == '角色' then
            return self:战斗_初始化_PK(P, r, ...)
        else
            warn('战斗脚本错误')
        end
    end
end

function 角色:可否水陆匹配(id)
    if self.当前地图.id ~= id then
        return
    end
    if self.是否战斗 or not self.是否队长 or self.接口:取队伍人数() ~= 5 then
        return
    end
    return true
end
