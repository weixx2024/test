local 物品 = {
    名称 = '乱舞狂刀技能书',
    叠加 = 99,
    类别 = 8,
    类型 = 0,
    对象 = 2,
    条件 = 2,
    召唤兽 = '浪淘沙',
    技能 = '乱舞狂刀',
    绑定 = true,
    
}
function 物品:初始化(t)
end

function 物品:使用(对象)
    if 对象.原名 ~= self.召唤兽 then
        对象:提示窗口("#Y召唤兽类型错误！")
        return
    end

    if 对象:添加后天技能(self.技能) then
        对象:提示窗口("#Y召唤兽成功领悟%s！", self.技能)
        self.数量 = self.数量 - 1
    end
end

function 物品:取描述()
    if self.技能 then
        return string.format("#Y召唤兽：%s\n#Y技能：%s", self.召唤兽, self.技能)
    end
end

return 物品
