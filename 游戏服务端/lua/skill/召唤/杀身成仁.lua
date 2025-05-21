local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '杀身成仁',
    是否被动 = true,
}
-- 以宝宝损失的血量，按照25%转换为攻击。

local BUFF
function 法术:进入战斗(自己)
    自己.攻击 = 计算攻击加成(自己)
    local b = 自己:进入战斗添加BUFF(BUFF)
    b.回合 = 150
end

BUFF = {
    法术 = '杀身成仁',
    名称 = '杀身成仁',
}
法术.BUFF = BUFF

function BUFF:BUFF被物理攻击后(攻击方, 挨打方)
    挨打方.攻击 = 计算攻击加成(挨打方)
end

function BUFF:BUFF被法术攻击后(攻击方, 挨打方)
    挨打方.攻击 = 计算攻击加成(挨打方)
end

function BUFF:被使用道具后(自己)
    自己.攻击 = 计算攻击加成(自己)
end

function 计算攻击加成(自己)
    自己.杀身成仁 = 自己.杀身成仁 or 0
    自己.攻击 = 自己.攻击 - 自己.杀身成仁
    自己.杀身成仁 = 0
    local 损失气血 = 自己.最大气血 - 自己.气血

    if 损失气血 > 0 then
        自己.杀身成仁 = math.floor(损失气血 * 0.25)
    end

    if 自己.杀身成仁 < 1 then
        自己.杀身成仁 = 0
    end

    return 自己.攻击 + 自己.杀身成仁
end

return 法术
