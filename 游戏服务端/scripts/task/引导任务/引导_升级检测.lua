local 任务 = {
    名称 = '引导_升级检测',
    是否隐藏 = true
}

function 任务:任务升级事件(玩家)
    local 转生 = 玩家.转生
    local 等级 = 玩家.等级
    if 转生 == 0 then
        if 等级 == 1 then
        elseif 等级 == 5 then
            玩家:添加任务(生成任务 { 名称 = '引导_情花任务', 进度 = 0 })
        elseif 等级 == 30 then
            玩家:添加任务(生成任务 { 名称 = '引导_大理寺答题', 进度 = 0 })
            玩家:添加任务(生成任务 { 名称 = '引导_师门任务', 进度 = 0 })
        elseif 等级 == 60 then
            玩家:添加任务(生成任务 { 名称 = '引导_200环', 进度 = 0 })
            玩家:添加任务(生成任务 { 名称 = '引导_一坐领取', 进度 = 0 })
        elseif 等级 == 70 then
            玩家:添加任务(生成任务 { 名称 = '引导_天庭任务', 进度 = 0 })
        elseif 等级 == 80 then
            玩家:添加任务(生成任务 { 名称 = '引导_大雁塔降魔', 进度 = 0 })
            玩家:添加任务(生成任务 { 名称 = '引导_地宫降魔', 进度 = 0 })
        elseif 等级 == 90 then
            玩家:添加任务(生成任务 { 名称 = '引导_鬼王任务', 进度 = 0 })
            玩家:添加任务(生成任务 { 名称 = '引导_二坐领取', 进度 = 0 })
        elseif 等级 == 102 then
            玩家:添加任务(生成任务 { 名称 = '引导_轮回转世', 进度 = 0 })
            玩家:添加任务(生成任务 { 名称 = '转生任务1', 进度 = 1 })
        end
    elseif 转生 == 1 then
        if 等级 == 60 then
        elseif 等级 == 80 then
            玩家:添加任务(生成任务 { 名称 = '引导_三坐领取', 进度 = 0 })
        elseif 等级 == 110 then
            玩家:添加任务(生成任务 { 名称 = '引导_四坐领取', 进度 = 0 })
            玩家:添加任务(生成任务 { 名称 = '引导_修罗任务', 进度 = 0 })
        elseif 等级 == 120 then
            玩家:添加任务(生成任务 { 名称 = '引导_五坐领取', 进度 = 0 })
        elseif 等级 == 122 then
            玩家:添加任务(生成任务 { 名称 = '转生任务1', 进度 = 1 })
        end
    elseif 转生 == 2 then
        if 等级 == 100 then
            玩家:添加任务(生成任务 { 名称 = '引导_六坐领取', 进度 = 0 })
        elseif 等级 == 142 then
            玩家:添加任务(生成任务 { 名称 = '转生任务3' })
        end
    end
end

return 任务
