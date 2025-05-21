local NPC = {}
local 对话 = [[
春眠不觉晓，鼾声惊飞鸟。人间鬼太多，钟馗累坏了。#91你们别总当钟馗是个抓鬼的粗人，其实我也投过功名，可惜生地丑，被那皇帝老儿取消了殿试资格#78。
menu
1|我来帮你
99|我只是路过
]]


function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        return self:领取抓鬼任务(玩家)
    end
end

function NPC:领取抓鬼任务(玩家)
    if not 玩家.是否组队 then
        玩家:常规提示('#Y需要3个人以上的组队来帮我！')
        return
    end
    -- if 玩家:取队伍人数() < 3 then
    --     玩家:常规提示('#Y需要3个人以上的组队来帮我！')
    --     return
    -- end

    local t = {}
    -- for _, v in 玩家:遍历队伍() do
    --     if v:判断等级是否低于(30) then
    --         table.insert(t, v.名称)
    --     end
    -- end
    -- if #t > 0 then
    --     玩家:常规提示('#Y' .. table.concat(t, '、 ') .. '#W低于30级,无法领取')
    --     return
    -- end

    for _, v in 玩家:遍历队伍() do
        if v:取任务('日常_抓鬼任务') then
            table.insert(t, v.名称)
        end
    end
    if #t > 0 then
        玩家:常规提示('#Y' .. table.concat(t, '、 ') .. '已有此任务,无法重复领取')
        return
    end
    local r = 生成任务 { 名称 = '日常_抓鬼任务' }
    if r and r:生成怪物(玩家) then
        local ff = string.format('各位且去#Y%s#W找到#G#u%s#W#u,降服超度它吧。', r.位置, r.怪名)
        for _, v in 玩家:遍历队伍() do
            v:最后对话(ff, self.外形)
        end
    end
end

return NPC
