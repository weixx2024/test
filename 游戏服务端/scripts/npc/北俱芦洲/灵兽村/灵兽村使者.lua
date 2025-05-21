local NPC = {}
local 对话 = [[
近来修罗频繁越境，更幻化假身四处作乱，虽然我法力强，无赖最近从抓来的越境修罗口里得知，有一个修罗族很厉害的头头也要越境，所以我不得不在这里守着，片刻不能离开。
menu
1|闲来无事，要我帮忙吗
99|离开
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        return self:领取修罗任务(玩家)
    end
end

function NPC:领取修罗任务(玩家)
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
        if v:判断等级是否低于(110) then
            table.insert(t, v.名称)
        end
    end
    if #t > 0 then
        玩家:常规提示('#Y' .. table.concat(t, '、 ') .. '#W低于110级,无法领取')
        return
    end

    for _, v in 玩家:遍历队伍() do
        if v:取任务('日常_修罗任务') then
            table.insert(t, v.名称)
        end
    end
    if #t > 0 then
        玩家:常规提示('#Y' .. table.concat(t, '、 ') .. '已有此任务,无法重复领取')
        return
    end

    local r = 生成任务 { 名称 = '日常_修罗任务' }

    if r and r:生成怪物(玩家) then
        local ff = string.format('请速去#Y%s#W#处消灭#G#u%s#u#W，阻止他为非作歹。！', r.位置, r.怪名)
        for _, v in 玩家:遍历队伍() do
            v:最后对话(ff, self.外形)
        end
    end
end

return NPC
