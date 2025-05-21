local NPC = {}
local 对话 = [[
赠人玫瑰，手有余香，愿天下所有有情人终成眷属。
menu
1|我们领取种情花任务
2|我只是路过看看
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        return self:领取情花任务(玩家)
    end
end
function NPC:领取情花任务(玩家)
    if not 玩家.是否组队 then
        玩家:常规提示('#Y需要2个人以上切有异性角色的组队来帮我！')
        return
    end
    -- if 玩家:取队伍人数() < 3 then
    --     玩家:常规提示('#Y需要3个人以上的组队来帮我！')
    --     return
    -- end
    local t = {}
    -- for _, v in 玩家:遍历队伍() do
    --     if v:判断等级是否低于(70) then
    --         table.insert(t, v.名称)
    --     end
    -- end

    if #t > 0 then
        玩家:常规提示('#Y' .. table.concat(t, '、 ') .. '#W低于3转143级,无法领取')
        return
    end
    for _, v in 玩家:遍历队伍() do
        if v:取任务('日常_情花任务') then
            table.insert(t, v.名称)
        end
    end
    if #t > 0 then
        玩家:常规提示('#Y' .. table.concat(t, '、 ') .. '已有此任务,无法重复领取')
        return
    end

    local 分类 = math.random(6)

    local r = 生成任务 {名称 = '日常_情花任务',进度=1}

    if r and r:添加任务(玩家) then
        local ff = string.format('情花种在了#G%s#W请速去呵护情花长大。', r.位置)
        if 玩家.是否组队 then
            for _, v in 玩家:遍历队友() do
                v:最后对话(ff, self.外形)
            end
            return ff
        end
    end
end


return NPC
