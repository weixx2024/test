local 物品 = {
    名称 = '夜明珠',
    叠加 = 1,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}

function 物品:使用(对象)
    if 对象.是否玩家 then
        if 对象.地图 == 1116 then
            if 对象:取物品是否存在('避水珠') then
                return
            end
            local 任务 = 对象:取任务('坐骑1_信字当头')
            if 任务 then
                local r = 对象:进入战斗('scripts/war/坐骑剧情/坐骑1_鱼怪.lua')
                if r and math.random(100) <= 60 then
                    local 添加物品 = 对象:添加物品({生成物品 {名称 = '避水珠', 数量 = 1, 禁止交易 = true}})
                    if 添加物品 then
                        任务:更新避水珠()
                    end
                end
            end
        else
            对象:提示窗口('#Y 当前地图无法使用夜明珠')
        end
    end
end

return 物品
