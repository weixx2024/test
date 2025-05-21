local NPC = {}
local 对话 = [[
近来镇压修罗界的碑文有所松动，且有小妖出逃。天帝命我将灵兽蛋赠与有缘之人，望孵出的小灵兽能助我等惩恶除奸! 此外，灵兽可找我进行蜕变仪式，”蜕变后的灵兽可还原为相应的灵兽蛋重新孵化。
menu
1|我想将我的坐骑蜕变成灵兽蛋
2|我想对坐骑进行点化仪式
99|我到处参观参观再说吧]]


local 对话2 = [[
确定要把当前坐骑蜕变成灵兽蛋么？    
menu
1|我想将我的坐骑蜕变成灵兽蛋
99|我再想想吧
]]





--2|自动修罗(每次消耗组队任我行*1)
function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        local 确定 = 玩家:选择窗口(对话2)
        if 确定 ~= "1" then
            return
        end
        local r = 玩家:取乘骑坐骑()
        if not r then
            return "请先把需要蜕变的坐骑设置乘骑状态！"
        end
        if r:取管制数量() ~= 0 then
            return "请先取消管制的召唤兽！"
        end
        if 玩家:添加物品({ 生成物品 { 名称 = "灵兽蛋", 数量 = 1, 参数 = r.几座, 种族 = 玩家.种族,
            场次 = 0 } }) then
            r:放生()
        else
            return "你的包裹栏已经满了！"
        end
    elseif i == '2' then

    end
end

return NPC
