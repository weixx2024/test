local NPC = {}
local 对话 = [[
今年花开特别迟。人都说东君袖手容风雪，春事凭谁做主张。其实这关我什么事#52花神们都被抓的抓贬的贬，赶快来个人去把他们救出来吧，555555.
menu
1|你在说啥，我听不懂。
2|别哭了，怜香惜玉的风流侠士们来帮你救人了。
3|我要拿积分换奖励
4|我要查看我的积分
]]





function NPC:NPC对话(玩家)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then


    elseif i == '2' then
        if not 玩家.是否组队 then
            玩家:常规提示('#Y需要3个人以上的组队来帮我！')
            return
        end
        if 玩家:取队伍人数() < 3 then
            玩家:常规提示('#Y需要3个人以上的组队来帮我！')
            return
        end

        local t = {}
        for _, v in 玩家:遍历队伍() do
            if v:判断等级是否低于(69) then
                table.insert(t, v.名称)
            end
        end
        if #t > 0 then
            玩家:常规提示('#Y' .. table.concat(t, '、 ') .. '#W低于70级,无法领取')
            return
        end

        local r = 玩家:取任务('日常_寻芳挑战')
        if r then
            r:进场(玩家)
            return
        end
        r = 生成任务 { 名称 = '日常_寻芳挑战' }
        if r then
            return r:添加任务(玩家)
        end
    elseif i == '3' then
        玩家:购买窗口('scripts/shop/积分_寻芳.lua', '寻芳积分')
    end
end

return NPC
