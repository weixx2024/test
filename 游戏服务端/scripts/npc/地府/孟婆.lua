local NPC = {}
local 对话 = [[
人生一世，草木一春。孩子，你可以重新来过。需要投胎转世么？
menu
1|我要领取转生任务
2|我要领取飞升任务
3|我什么都不想做]]

local _转生等级需求 = { 102, 122, 142, 180 }
function NPC:转生任务添加(玩家)
    local r = 玩家:取任务("转生任务1")
    local rr = 玩家:取任务("转生任务3")
    if r or rr then
        return "你身上已经有转生任务了"
    end
    if 玩家.等级 < _转生等级需求[玩家.转生 + 1] then
        return "等级没有达到转生需求"
    end
    for _, v in 玩家:遍历任务() do
        if v.禁止转生 then
            return "请先完成任务栏任务！"
        end
    end
    if 玩家.是否组队 then
        return "请先离队！"
    end
    if not 玩家:剧情称谓是否存在(10) then
        return "请先获得10级别剧情称谓"
    end
    if 玩家.转生 == 2 then
        local rw = 生成任务 { 名称 = '转生任务3', 进度 = 1 }
        玩家:添加任务(rw)
    else
        local rw = 生成任务 { 名称 = '转生任务1', 进度 = 1 }
        玩家:添加任务(rw)
    end
end

function NPC:飞升任务添加(玩家)
    local r = 玩家:取任务("正果正身")
    if r or rr then
        return "你身上已经有飞升任务了"
    end

    if 玩家.等级 < 180 or 玩家.转生 < 3 then
        return "等级没有达到飞升需求"
    end
    if 玩家.飞升 == 1 then
        return "你已经飞升过了！"
    end
    if 玩家.是否组队 then
        return "请先离队！"
    end
    if not 玩家:飞升条件检测() then
        return "飞升要求满技能满熟练度"
    end
    local rw = 生成任务 { 名称 = '正果正身'}
    玩家:添加任务(rw)
end


function NPC:NPC对话(玩家, i)
    return 对话
end



function NPC:NPC菜单(玩家, i)
    if i == '1' then
        local dh = self:转生任务添加(玩家)
        if dh then
            return dh
        end
    elseif i == '2' then
        local dh = self:飞升任务添加(玩家)
        if dh then
            return dh
        end
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
