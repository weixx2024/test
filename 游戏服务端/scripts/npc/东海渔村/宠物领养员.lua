local NPC = {}
local 对话 = [[
来挑选一个你喜欢的宠物吧,宠物能帮你在战斗中捕捉到召唤兽的哦。
menu
1|我要领养宠物
2|告诉我关于驯养召唤兽和宠物的技巧
99|我什么都不想做]]


function NPC:NPC对话(玩家, i)
    local r = 玩家:取任务('新手剧情')
    if r and r.进度 == 2 then
        return (对话:gsub('1|','4|'))
    end
    return 对话
end

local dh = {
    [[1.宠物随主人的#Y在线时间#W增长而升级；
2.召唤兽通过在战斗中选择#G捕捉#W指令获得,捕捉需满足一定的称谓和等级，捕捉后在战斗中可通过#G召唤#W指令将之释放出来；
3.某些召唤兽能使用魔法,成长到一定等级后将自动掌握；
4.从0级开始培养的高级召唤兽其威力可是很惊人的；
5.长安城等地中有#G超级巫医#W可以给召唤兽恢复状态哦；]],

}

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        local p = 玩家:打开宠物领养窗口()
        local r = 玩家:领养时间宠(p)
        -- if r == 1 then
        --     玩家:打开对话(dh[1], self.外形)
        --     玩家:提示窗口('#Y领养成功！')
        -- elseif r == 2 then
        --     玩家:提示窗口('#Y替换成功！')
        -- end
    elseif i == '2' then
        return dh[1]
    end
end

return NPC
