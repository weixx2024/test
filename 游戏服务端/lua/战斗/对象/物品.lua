
local 战斗物品 = class('战斗物品')

function 战斗物品:初始化(物品)
    self.物品 = 物品
    self.脚本 = 物品.脚本
end

function 战斗物品:__index(k)
    local t = rawget(self, '道具')
    if t then
        return t[k]
    end
end

function 战斗物品:使用(dst)
end

return 战斗物品
