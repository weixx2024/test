local NPC = {}
local 对话 = [[
我是帮派大战的场内传送人。你可以通过我进入挑战场挑战对方强队或者进入战场为帮杀敌。
menu
1|我要入场杀敌
2|我要去挑战对方高手
3|我要回长安
4|离开
]]
local 对话1 = [[
我是帮派大战的场内传送人。你可以通过我进入挑战场挑战对方强队或者进入战场为帮杀敌。
menu
3|我要回长安
4|离开
]]


function NPC:NPC对话(玩家, i)
    if 玩家.帮派 == self.帮派.名称 then
        return 对话
    else
        return 对话1
    end
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        if not 取帮战战斗开关() then
            玩家:常规提示('#Y还未到入场时间')
            return
        end
        if 玩家.是否组队 then
            for _, v in 玩家:遍历队伍() do
                if v.复活标记 and v.复活标记 - os.time() <= 0 then
                    v.复活标记 = nil
                end
                if v.复活标记 then
                    local 剩余时间 = v.复活标记 - os.time()
                    玩家:常规提示('#G' .. v.名称 .. '#Y刚刚复活,还需要#R' .. 剩余时间 .. '#Y秒才可以进入')
                    return
                end
            end
        else
            if 玩家.复活标记 and 玩家.复活标记 - os.time() <= 0 then
                玩家.复活标记 = nil
            end
            if 玩家.复活标记 then
                local 剩余时间 = 玩家.复活标记 - os.time()
                玩家:常规提示('#Y你刚刚复活,还需要#R' .. 剩余时间 .. '#Y秒才可以进入')
                return
            end
        end
        local map = self.帮派.帮战信息.帮战地图
        if map then
            玩家:切换地图2(map, 25, 24)
            玩家:设置战场状态(true)
        end
    elseif i == '2' then
        if not 取帮战战斗开关() then
            玩家:常规提示('#Y还未到入场时间')
            return
        end
        if 玩家.是否组队 then
            for _, v in 玩家:遍历队伍() do
                if v.复活标记 and v.复活标记 - os.time() <= 0 then
                    v.复活标记 = nil
                end
                if v.复活标记 then
                    local 剩余时间 = v.复活标记 - os.time()
                    玩家:常规提示('#G' .. v.名称 .. '#Y刚刚复活,还需要#R' .. 剩余时间 .. '#Y秒才可以出城')
                    return
                end
            end
        else
            if 玩家.复活标记 and 玩家.复活标记 - os.time() <= 0 then
                玩家.复活标记 = nil
            end
            if 玩家.复活标记 then
                local 剩余时间 = 玩家.复活标记 - os.time()
                玩家:常规提示('#Y你刚刚复活,还需要#R' .. 剩余时间 .. '#Y秒才可以出城')
                return
            end
        end
        local map = self.帮派.帮战信息.帮战地图
        if map then
            玩家:切换地图2(map, 113, 10)
        end
    elseif i == '3' then
        玩家:龙神帮战退场()
    elseif i == '4' then
    end
end

return NPC
