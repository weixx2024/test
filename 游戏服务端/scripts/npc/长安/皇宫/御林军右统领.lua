-- local NPC = {}
-- local 对话 = [[
-- 曾经我做过一份差事，后来没了。所以我现在一直很清闲......
-- ]]

-- function NPC:NPC对话(玩家, i)
--     return 对话
-- end

-- function NPC:NPC菜单(玩家, i)
--     if i == '1' then
--     elseif i == '2' then
--     elseif i == '3' then
--     elseif i == '4' then
--     end
-- end

-- return NPC

local NPC = {}
local 对话 = [[
今天下太平，国泰民安!圣上特于此百姓节庆之日，请来西天十六罗汉为我等诵经念佛，以勉一年辛勤之作!然罗汉们却有言在先:有缘得见，无缘莫念。施主可找齐3人以上同伙去往#G化生寺#W和#G皇宫#W寻找罗汉。若有幸得见，可别忘了抄得几份#Y经文#W，可得佛主保佑。#Y施主若实在找不到回来找我帮忙也是可以的。
menu
1|好，咱们快去找光头啰
2|抄佛经有什么用？
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
    end
end

return NPC
