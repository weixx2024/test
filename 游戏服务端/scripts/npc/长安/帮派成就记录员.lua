local NPC = {}
local 对话 = [[
帮派者，家也，大凡英雄好汉，都少不了兄弟相帮。长安人来人往，我虽为小吏一员，但是世事洞明，凡事都逃不过我的眼睛!谁为帮派尽心尽职，谁为帮派成就之首!您可以找我帮您记录帮派成就，每记录一次,收取手续费300000两。?
menu
1|我要撰写帮派成就册
99|我去做帮派任务了,再会
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        if not 玩家.帮派 or 玩家.帮派 == "" then
            return "你还没有加入任何帮派"
        end
        if 玩家.转生 < 1 then
            return "1转再来吧"
        end

        local r = 玩家:数值输入窗口("", "请输入你要记录帮派成就！")
        if r then
            if r < 2000 and r > 100000 then
                return "请输入2000至100000之间"
            end
            if 玩家.帮派成就 < r then
                return "你没有那么多帮派成就哦！"
            end
            if 玩家.银子 < 300000 then
                return "你没有那么多银两！"
            end
            local wp = 生成物品 { 名称 = "帮派成就册", 数量 = 1, 参数 = r }
            if 玩家:添加物品({ wp }) then
                玩家:扣除帮派成就(r)
                玩家:扣除银子(300000)
                return "我已经帮您记录帮派成就"
            end
        end
    end
end

return NPC
