local NPC = {}
local 对话 = [[
新年到,福星到，要把喜事报#41。或许过去的一年有太多的不尽人意,那新的一年我们要芝麻开花节节高#85,听说大话里过年喜事连连,祝福多多,年轻人,要不要跟我一起来过大年呢#47
menu
1|当然来啊
2|过年有什么好玩的,说说看
3|我要取消新年任务
99|一个大侠路过,况且况且况且
]]

local 对话2 = [[
香喷喷的年夜饭就要煮好了,看看你想吃啥#89这是灶王爷的一点意思,新年快乐#98
menu
4|萝卜饺子
5|家宴寿桃
6|年年有鱼
7|年年高升
]]




function NPC:NPC对话(玩家)
    if 玩家:取任务( "元宵_团员年饭") then
        return 对话2
    end
    return 对话
end

local _任务类型 = { "元宵_新春祭祖", "元宵_童心祝福", "元宵_团员年饭",  "元宵_辞旧迎新"-- "元宵_亲友拜年",
   }

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        if os.date('%w', os.time()) ~= '1' then
            return "非活动开启时间"
        end
        for k, v in pairs(_任务类型) do
            if 玩家:取任务(v) then
                return "你身上已经有未完成的任务"
            end
        end
        local name = _任务类型[math.random( 4)]--
        local r = 生成任务 { 名称 = name }
        if r then
            return r:添加任务(玩家)
        end


    elseif i == '2' then
        return "活动详情:#G#uhttps://xy2.163.com/2008/yuanxiao/index1.html"
    elseif i == '3' then
        for k, v in pairs(_任务类型) do
            local r = 玩家:取任务(v)
            if r then
                r:任务取消(玩家)
                r:删除(玩家)
                return "已经帮你取消了任务"
            end
        end


        return "你身上没有任务,不要逗我了#24"


    elseif i == '4' then
        local rw = 玩家:取任务( "元宵_团员年饭") 
        if rw then
            local r = 玩家:取物品是否存在("面粉")
            if r then
                r:减少(1)
                rw:完成(玩家)
            else
                return "想要吃饺子的话,要先给灶王爷准备一些面粉哦！"
            end
        end
    elseif i == '5' then
        local rw = 玩家:取任务( "元宵_团员年饭") 
        if rw then
            local r = 玩家:取物品是否存在("桃子")
            if r then
                r:减少(1)
                rw:完成(玩家)
            else
                return "想要吃寿桃的话,要先给灶王爷准备一些桃子哦！"
            end
        end
    elseif i == '6' then
        local rw = 玩家:取任务( "元宵_团员年饭") 
        if rw then
            local r = 玩家:取物品是否存在("鲫鱼")
            if r then
                r:减少(1)
                rw:完成(玩家)
            else
                return "想要吃鱼的话,要先给灶王爷准备一些鲫鱼哦！"
            end
        end
    elseif i == '7' then
        local rw = 玩家:取任务( "元宵_团员年饭") 
        if rw then
            local r = 玩家:取物品是否存在("糯米")
            if r then
                r:减少(1)
                rw:完成(玩家)
            else
                return "想要吃年糕的话,要先给灶王爷准备一些糯米哦！"
            end
        end

    end
end

return NPC
