local NPC = {}
local 对话 = [[
玄阴之气充满玄阴宝鉴，时空之门就会立刻开启，届时大闹天宫就会开启。
menu
99|等活动开启了我再来吧
]]

local 对话2 = [[
玄阴宝鉴已吸牧足够的玄阴之气,事不宜迟现在可以通过时空之门回到500年前。《可以带装备入场)
menu
98|回到500年前
99|路过……
]]
-- 玄阴宝鉴已吸牧足够的玄阴之气,事不宜迟现在可以通过时空之门回到500年前。《可以带装备入场)
-- 回到500年前
-- 路过……


function NPC:NPC对话(玩家, i)
    -- if 能否进场_大闹天宫() then
    --     return 对话2
    -- end
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '98' then

        local n = 玩家:取队伍人数()
        local 阵营 = 阵营分配_大闹天宫(n)
        local r

        for k, v in 玩家:遍历队伍() do
            r = 生成任务 { 名称 = '大闹天宫', 积分 = 0, 阵营 = 阵营 }
            if not v:取任务('大闹天宫') then
                v:添加任务(r)
                v:置刷新属性("称谓",(阵营 == 1 and "花果山" or "天庭"))
               -- v.rpc:切换称谓(v.nid, (阵营 == 1 and "花果山" or "天庭"))
            end
        end
        if 阵营 == 1 then
            玩家:切换地图(101385, 402, 43) --花果山 402 43
        else
            玩家:切换地图(101385, 69, 254) --天庭 69 254
        end



        -- 玩家:切换地图(101385, 69, 254) --天庭 69 254

    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
