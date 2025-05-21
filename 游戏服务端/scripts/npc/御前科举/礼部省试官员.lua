-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-06-10 04:16:13
-- @Last Modified time  : 2022-07-19 06:33:17

local NPC = {}
local 对话 = [[
奉唐王命令在此监考科举省试，通过了乡试的考生都可以来我这进行省试
menu
1|开始考试
2|我还没有准备好
]]

function NPC:NPC对话(玩家, i)
    if 科举是否开启殿试() then
        return "省试已经结束"
    elseif 科举是否开启报名() then
        local r = 玩家:取任务("乡试_文试") or 玩家:取任务("乡试_武试")
        if r then
            if r.进度 ~= self.序列 then
                if r.进度 < 21 then
                    return "请找乡试考官" .. r.进度 .. "号答题"
                elseif r.进度 == 21 then
                    return 对话
                end
            end
        end
    end
end

function NPC:NPC菜单(玩家, i)
    if i == "1" then
        local r = 玩家:取任务('乡试_武试') or 玩家:取任务('乡试_文试')
        if r.进度 == 21 then
            if r.名称 == '乡试_武试' then
                if r.交付人 then
                    return r.寻人对话
                end
                if r:置寻人目标(玩家) then
                    return r.寻人对话
                end
            else
                ::连续::
                if r.省试进度 <= 15 then
                    local t = _取科举题目()
                    local 答案 = t[4]
                    local list = {}
                    for n = 2, 4, 1 do
                        table.insert(list, { t[n], math.random(99999) })
                    end
                    table.sort(list, function(a, b) return a[2] > b[2] end)
                    local xsda = {}
                    for _, dn in ipairs(list) do
                        table.insert(xsda, dn[1])
                    end
                    local txt = string.format(t[1] .. "\nmenu\n%s\n%s\n%s", xsda[1], xsda[2], xsda[3])
                    local xzdn = 玩家:选择窗口(txt)
                    if xzdn == 答案 then
                        r:回答正确_省试(玩家)
                    else
                        r:回答错误_省试(玩家)
                    end
                    goto 连续

                else
                    return "省试结束"
                end
            end
        end
    end
end

function NPC:NPC给予(玩家, cash, items)
    return '你给我什么东西？'
end

return NPC
