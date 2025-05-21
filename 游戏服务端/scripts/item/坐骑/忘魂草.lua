local 物品 = {
    名称 = '忘魂草',
    叠加 = 999,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}
function 物品:计算选项(jn)
    local t = ""
    for i, v in ipairs(jn) do
        t = t .. v.名称 .. "\n"
    end
    return t
end

local 学习对话 = [[
 坐骑技能根据属性的不同提升的能力也不同，选择对应的技能给对应的坐骑使用能力也会有显著的提高，你的坐骑要学习那个技能
menu
追魂夺命 天雷怒火
破釜沉舟 金身不坏
后发制人 心如止水
万劫不复 天神护体
兴风作浪 我再想想
]]
function 物品:使用(对象)
    local r = 对象:取乘骑坐骑()
    if not r then
        对象:常规提示("#Y清先将要坐骑设置为乘骑状态！")
        return
    end
    local t = r:取技能()
    if not next(t) then
        对象:常规提示("#Y你的坐骑还没有学会任何技能")
        return
    end
    local jn = 对象:选择窗口('请选择你要替换的技能？\nmenu\n%s', self:计算选项(t))
    if jn then
        local jn2 = 对象:选择窗口(学习对话)
        if jn2 then
            if r:替换技能(jn, jn2) then
                self.数量 = self.数量 - 1
            end
        end
    end
end

return 物品
