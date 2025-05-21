local NPC = {}
local 对话 = [[
在我这里可以报名参加水陆大会，只要你达到3转100级以上，找我报名即可。如果你没有队伍也可以找我，我可以帮你查找跟你等级差不多的朋友，不过报名费需要一次三万才行哦，阁下是否报名呢？
menu
1|我想要报名参加
2|我要进场
98|我要兑换奖励
99|我只是路过看看
]]
-- 3|查询未组队的玩家
-- 4|查询水陆大会轮次
-- 5|我想看看水陆大会规则
function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        -- if 玩家:取队伍人数() ~= 5 then
        --     return '低于5人无法报名'
        -- end
        return 玩家:水陆报名()
    elseif i == '2' then
        local t = {}
        for _, v in 玩家:遍历队伍() do
            if v.转生 and v.转生 < 1 then
                table.insert(t, v.名称)
            end
        end
        if #t > 0 then
            --  玩家:常规提示('#Y' .. table.concat(t, '、 ') .. '#W低于10级,无法进入')
            return table.concat(t, '、 ') .. '#W低于1转,无法进入'
        end
        for _, v in 玩家:遍历队伍() do
            table.insert(t, { nid = v.nid, 名称 = v.名称 })
        end
        return 玩家:进入水陆地图(t)


    elseif i == '98' then
        玩家:购买窗口('scripts/shop/积分_水陆.lua', '水陆积分')
    end
end

function NPC:NPC给予(玩家, cash, items)
    return '你给我什么东西？'
end

return NPC
