local 任务 = {
    名称 = '正果正身',
    别名 = '正果正身',
    类型 = '天地劫',
    是否可取消 = false
}

function 任务:任务初始化()
    if not self.进度 then
        self.进度 = 1
    end
end

local _描述 = {
    "#W你已经悟透了天道，若想飞升，便需逆天而行。或许#G#u#[1137|19|11|$菩提祖师#]#u#W能够给一丝明悟。",
    "#W通过三灾考验#r#Y风灾       %s#r#Y水灾       %s#r#Y火灾       %s",
    "#W带上#R抗雷符(长安杂货店购买)#W找#G#u#[1137|19|11|$菩提祖师#]#u#W挑战天地劫",
    "#W找#G#u#[1137|19|11|$孟婆#]#u#W准备飞升",

}


function 任务:任务取详情(玩家)
    if self.进度 == 2 then
        local a = 玩家.其它.九天巽风 == 0 and "未通过" or "已通过"
        local b = 玩家.其它.忘川水 == 0 and "未通过" or "已通过"
        local c = 玩家.其它.南明离火 == 0 and "未通过" or "已通过"
        return string.format(_描述[self.进度], a, b, c)
    end
    return _描述[self.进度]
end

local _台词 = {


    -- local 对话 = [[
    --     在我这里存放物品，绝对安全，童叟无欺。只不过，不过...客官在本店每次取回物品，小的将会收取您25两作为劳力费#17
    --     menu
    --     1|我想看看我当铺里有什么东西
    --     2|给我当铺增加物品栏（1000000两）
    --     3|你是干嘛的？
    --     4|离开
    --     ]]
}

function 任务:任务NPC对话(玩家, NPC)
    if self.进度 == 1 then
        if NPC.名称 == "菩提祖师" then
            NPC.台词 = "这里有些考验(风灾、水灾和火灾),完成后方可挑战天地劫\nmenu\n1|我接受考验\n2|我再考虑下吧"
        end
    elseif self.进度 == 3 then
        if NPC.名称 == "菩提祖师" then
            NPC.台词 = "携带抗雷符抵抗雷劫。准备完毕便来挑战天地劫吧！\nmenu\n21|我接受考验\n2|我再考虑下吧"
        end
    elseif self.进度 == 4 then
        if NPC.名称 == "孟婆" then
            NPC.台词 = "小友欲飞升否？\nmenu\n22|我要飞升！我要变强！\n2|恐怕我还没做好飞升的准备"
        end
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
    if self.进度 == 1 then
        if NPC.名称 == "菩提祖师" then
            if i == "1" then
                self.进度 = 2
                if not 玩家:取任务('南明离火') or 玩家.其它.南明离火 == nil or 玩家.其它.南明离火 == 0 then
                    玩家:添加任务('南明离火')
                    玩家.其它.南明离火 = 0
                end
                if not 玩家:取任务('忘川水') or 玩家.其它.忘川水 == nil  or 玩家.其它.忘川水 == 0 then
                    玩家:添加任务('忘川水')
                    玩家.其它.忘川水 = 0
                end
                if not 玩家:取任务('九天巽风') or 玩家.其它.九天巽风 == nil or 玩家.其它.九天巽风 == 0 then
                    玩家:添加任务('九天巽风')
                    玩家.其它.九天巽风 = 0
                end
                玩家:常规提示("#Y根据人物飞升指引，开始你的考验征程吧")
            end
        end
    elseif self.进度 == 3 then
        if NPC.名称 == "菩提祖师" then
            local r = 玩家:取物品是否存在("抗雷符")
            if not r then
                玩家:常规提示("#Y没有抗雷符 你是抗不过九天神雷的 去长安杂货店购买一张抗雷符再来找我吧")
                return
            end
            r:减少(1)
            self.进度 = 4
            玩家:常规提示("#R你成功的渡过了天劫 准备准备飞升吧")
        end
    elseif self.进度 == 4 then
        local 种族, 性别, 外形 = 玩家:飞升窗口()
        if 种族 then
            r = 玩家:飞升条件检测(性别)
            if r then
                玩家:常规提示(r)
                return
            end
            local r = 玩家:飞升处理(种族, 性别, 外形)
            if r then
                玩家:发送系统("天空一声巨响,神仙闪亮登场！#G%s#W渡劫成功，得以飞升！", 玩家.名称)
                self:删除()
            end
        end
    end
end

function 任务:完成试炼(玩家, NPC)
    if self.进度 == 2 then
        self.进度 = 3
    end
end

return 任务
