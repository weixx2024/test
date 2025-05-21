-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-06-10 04:16:13
-- @Last Modified time  : 2022-07-19 06:33:17

local NPC = {

}
local 对话 = [[
奉唐王命令在此监考科举乡试，报名了御前科举的考生都可以来我这进行乡试
menu
1|开始考试
2|我还没有准备好
]]


function NPC:NPC对话(玩家, i)
    if 科举是否开启殿试() then
        return "乡试已经结束"
    elseif 科举是否开启报名() then
        local r = 玩家:取任务("乡试_文试") or 玩家:取任务("乡试_武试")
        if r then
            if r.进度 ~= self.序列 then
                if r.进度 < 21 then
                    return "请找乡试考官" .. r.进度 .. "号答题"
                elseif r.进度 == 21 then
                    return "请找礼部省试官员参加省试"
                end
            else
                return 对话
            end
        end
    end
end

local _npcname = {
    "乡试考官1号", "乡试考官2号", "乡试考官3号", "乡试考官4号", "乡试考官5号",
    "乡试考官6号", "乡试考官7号", "乡试考官8号", "乡试考官9号", "乡试考官10号",
    "乡试考官11号", "乡试考官12号", "乡试考官13号", "乡试考官14号", "乡试考官15号",
    "乡试考官16号", "乡试考官17号", "乡试考官18号", "乡试考官19号", "乡试考官20号",
}

function NPC:NPC菜单(玩家, i)
    if i=="1" then
        local r = 玩家:取任务("乡试_文试") or 玩家:取任务("乡试_武试")
        if r then
            if self.名称 == _npcname[r.进度] then
                if i == "1" then
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
                        r:回答正确(玩家)
                    else
                        r:回答错误(玩家)
                    end
                end
            end
        end
    end
end

function NPC:NPC给予(玩家, cash, items)
    return '你给我什么东西？'
end

return NPC
