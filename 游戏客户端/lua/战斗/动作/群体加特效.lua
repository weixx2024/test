--[[
Author: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
Date: 2025-03-03 23:07:25
LastEditors: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
LastEditTime: 2025-03-05 21:42:55
FilePath: \客户端\lua\战斗\动作\群体加特效.lua
Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
--]]
-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-02 21:21:56
-- @Last Modified time  : 2024-08-23 14:00:07
local 数据 = {}
local 技能库 = require('数据/技能库')
function 数据:初始化()
end

function 数据:播放战斗(data, 自己)
    local t = table.remove(data, 1)
    local co = (coroutine.running())
    if 技能库[t.id] then
        self.动画 = __res:getani('magic/%04d.tca', t.id)
        if self.动画 == nil then
            self.动画 = __res:getani('magic/%04d.tcp', t.id)
        end
    end

    if not self.动画 then
        print('找不到动画')
        return
    end
    战场层:添加技能(self)
    self.动画:播放():置帧率(1 / 20)
    self.目标 = {}
    for i, v in pairs(t.位置) do
        local tg = 战场层:取对象(v)
        self.目标[i] = tg
    end

    self._定时 = 引擎:定时(
        1,
        function()
            if not self.动画.是否播放 then
                coroutine.xpcall(co)
                return
            end
            return 1
        end
    )
    coroutine.yield()
end

function 数据:更新(dt)
    self.动画:更新(dt)
    return not self.动画.是否播放
end

function 数据:显示(x, y)
    for i, v in pairs(self.目标) do
        self.动画:显示(v.x, v.y)
    end
end

return 数据
