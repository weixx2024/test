local NPC = {}
local 对话 = [[
南无阿弥陀佛
]]
local 对话 = [[
当年三族旷世大战，致使战劫后三族均败退隐退。老朽受天神旨意显化人间，为三族血脉子嗣延续寻找机缘，希望寻得三界侠士的帮忙。
menu
1|我要领取元气蛋
99|我只是路过看看
]]

function NPC:NPC对话(玩家, i)
    if os.date('%w', os.time()) == '0' then
        return 对话1
    else
        return 对话
    end
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        if 玩家:取活动限制次数("孵蛋") >= 2 then
            return "今天你已经完成2次该任务了,请明天再来"
        end


        if 玩家:判断等级是否低于(50, 1) then
            return "达到1转50级才可以领取该任务！"
        end
        local r = 玩家:取任务("春节_元气蛋")
        if r then
            return "你身上已经存在该任务"
        end
        r = 生成任务 { 名称 = '春节_元气蛋', 进度 = 0 }
        if r then
            local s = r:添加任务(玩家)
            if type(s) == "string" then
                return s
            elseif s == true then
                return "恭喜你得到一个“元气蛋”,快带着它去北俱芦洲吸纳元气吧!"
            end
        end
    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
