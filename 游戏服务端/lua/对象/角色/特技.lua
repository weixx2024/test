--[[
Author: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
Date: 2025-03-03 23:08:19
LastEditors: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
LastEditTime: 2025-03-07 20:17:42
FilePath: \服务端1\lua\对象\角色\特技.lua
Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
--]]
local 角色 = require('角色')
local 特技库 = require('数据库/特技库')

function 角色:特技_初始化()
    self.特技 = {}
end

function 角色:遍历特技()
    return next, self.特技
end

function 角色:清空特技()
    for k, v in pairs(self.特技) do
        v.rid = -1
        __垃圾[k] = v
    end
    self.特技 = {}
end

function 角色:删除特技(name)
    for k, v in ipairs(self.特技) do
        if v.名称 == name then
            if v.等级 > 1 then
                v.等级 = v.等级 - 1
            else
                table.remove(self.特技, k)
                v.rid = -1
                __垃圾[k] = v
            end
            return
        end
    end
end

function 角色:取特技是否存在(name)
    for k, v in ipairs(self.特技) do
        if v.名称 == name then
            return true
        end
    end
end

function 角色:添加特技(name)
    local 特技数据 = 特技库[name]
    if 特技数据 then
        local _
        for i, v in self:遍历特技() do
            if v.名称 == name then
                _ = i
                break
            end
        end
        if _ then
            if 特技数据.叠加 then
                self.特技[_].等级 = self.特技[_].等级 + 1
            else
                return
            end
        else
            local r = require('对象/法术/技能') {
                类别 = '特技',
                名称 = name,
                等级 = 1
            }
            self.特技[#self.特技 + 1] = r
        end
    end
    return true
end
