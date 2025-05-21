local NPC = {}
local 对话 = [[
昔日孙悟空大闹地府，使得地狱中的鬼魂倾巢而出，由于逃出的鬼魂过长时间没有被超度现如今在三界中吸尽了阴气化为鬼王，鬼王的出现严重影响到了大唐子民，为免鬼王的出现扰乱人间秩序，地藏王大人下令招募三界有志之士前往捉拿正在危害人间的鬼王，成功捉拿者将论功行赏。
menu
1|在下愿为三界出一份力！
99|说啥呢！？怎么这么高深呢？！听不懂，闪先
]]

local 招募 = [[
一个人出门在外确实危险，请问你要招募哪个种族的队友呢？
menu
6|我需要人族队友
7|我需要魔族队友
8|我需要仙族队友
99|我喜欢一个人闯荡
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        return self:领取鬼王任务(玩家)
    end
end

function NPC:领取鬼王任务(玩家)
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
        if v:判断等级是否低于(90) then
            table.insert(t, v.名称)
        end
    end
    if #t > 0 then
        玩家:常规提示('#Y' .. table.concat(t, '、 ') .. '#W低于90级,无法领取')
        return
    end

    for _, v in 玩家:遍历队伍() do
        if not v:剧情称谓是否存在(10) then
            table.insert(t, v.名称)
        end
    end
    if #t > 0 then
        玩家:常规提示('#Y' .. table.concat(t, '、 ') .. '没有完成十称，无法领取')
        return
    end

    for _, v in 玩家:遍历队伍() do
        if v:取任务('日常_鬼王任务') then
            table.insert(t, v.名称)
        end
    end
    if #t > 0 then
        玩家:常规提示('#Y' .. table.concat(t, '、 ') .. '已有此任务,无法重复领取')
        return
    end
    local r = 生成任务 { 名称 = '日常_鬼王任务' }
    if r and r:生成怪物(玩家) then
        local ff = string.format(
            '从地府逃出去的#G#u%s#W#u由于长时间没有被超度，现今在#Y%s#W吸取阴气化为鬼王，为免其危害人间，我已下令招募三界有志之士前往捉拿，成功者重重有赏！这事情就有劳阁下了！',
            r.怪名:gsub('王', ''), r.位置)
        for _, v in 玩家:遍历队伍() do
            v:最后对话(ff, self.外形)
        end
    end
end

return NPC
