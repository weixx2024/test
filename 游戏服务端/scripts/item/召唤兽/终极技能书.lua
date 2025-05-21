-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2024-08-28 20:28:58
-- @Last Modified time  : 2024-08-28 20:45:44
local 物品 = {
    名称 = '终极技能书',
    叠加 = 999,
    类别 = 8,
    类型 = 0,
    对象 = 2,
    条件 = 2,
    绑定 = false
}

function 物品:使用(对象)
    local t,d = 对象:添加领悟技能(self.技能,"终极技能书")
    if d then
        self.数量 = self.数量 - 1
        对象:提示窗口(t)
    else
        return t
    end
end



function 物品:取描述()
    if  self.技能 then
        return "携带技能：#G"..self.技能
    end
end


return 物品
