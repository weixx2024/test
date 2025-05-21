
local NPC = {}
local 对话 = [[你看那些花儿，乘着流水漂漂而去，是谁在.上面留下了爱的伤味?孤单的他(她)是否像孤单的我，呆呆的看着孤单的花儿，期盼着将心意告诉他(她)你不懂我的心情,你不懂。你来找我是要去灞桥的吧，我可以送你过去。
menu
灞桥 
我什么都不想做
]]

--其它对话
function NPC:NPC对话(玩家,i)
    return 对话
end


function NPC:NPC菜单(玩家,i)
    if i=='灞桥' then
        玩家:切换地图(1193, 144, 144)
    end
end



return NPC