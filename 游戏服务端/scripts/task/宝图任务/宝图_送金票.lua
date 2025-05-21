-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-01 12:16:40
-- @Last Modified time  : 2022-09-07 15:17:32

local 任务 = {
    名称 = '宝图_送金票',
    别名 = '宝图任务',
    类型 = '日常任务',
    飞行限制 = true,
}

function 任务:任务初始化(玩家, ...)
end

local _描述 = '去把酬劳送给长寿铁匠铺的#G#u#[1073|19|13|$木匠师傅#]#u#W，他在长寿村（107.124）附近。今天你已经帮了本客栈%s次。距离本次任务结束时间还有%s分钟，加油！'
function 任务:任务取详情(玩家)
    if self.时间 then
        return string.format(_描述, self.环数, (self.时间 - os.time()) // 60)
    end
end

function 任务:任务取消(玩家)
    玩家.其它.宝图环数 = nil
end

function 任务:任务更新(sec, 玩家)
    if self.时间 - os.time() <= 0 then
        self:删除()
    end
end

function 任务:任务上线(玩家)
    if self.时间 - os.time() <= 0 then
        self:删除()
        玩家.其它.宝图环数 = nil
    end
end

function 任务:任务下线(玩家)
    if self.时间 - os.time() <= 0 then
        self:删除()
        玩家.其它.宝图环数 = nil
    end
end

function 任务:添加任务(玩家) --1寻药
    if 玩家.等级 < 30 then
        return "等级小于30时间宠小于10级的玩家无法领取该任务"
    end
    if 玩家:取时间宠等级() < 10 then
        return "等级小于30时间宠小于10级的玩家无法领取该任务"
    end
    if 玩家.体力 < 20 then
        return "领取该任务需要20点体力"
    end

    local r = 生成物品 { 名称 = "金票", 数量 = 1 }
    if 玩家:添加物品({ r }) then
        玩家:扣除体力(20)

        玩家.其它.宝图环数 = 玩家.其它.宝图环数 > 30 and 1 or 玩家.其它.宝图环数 + 1
        self.环数 = 玩家.其它.宝图环数
        self.时间 = os.time() + 1800
        玩家:添加任务(self)
        return '长寿村的#Y木匠#W上次在我这干完活我忘记付酬劳了，你能跑一趟帮我送下酬劳吗？  '
    end

    return '你身上放不下我要给你的金票'
end

function 任务:掉落包(玩家) --1寻药
    local 经验 = math.floor(59884 * (1 + self.环数 * 0.35)) --1154万经验
    local 银子 = 1000 * (1 + self.环数 * 0.36) --产出197400银两
    local 成就 = 20 * (1 + self.环数 * 0.2) --满次获得2460成就
    玩家:添加任务经验(经验, "宝图任务")
    玩家:添加银子(银子, "宝图任务")
    玩家:增加活动限制次数('宝图任务')
    if self.环数 > 2 then
        if not 玩家:取包裹空位() then
            玩家:提示窗口('#Y 你的包裹已经满了！')
            return
        end

        local r = 生成物品 { 名称 = "藏宝图", 数量 = 1 }
        if 玩家:添加物品({ r }) then
            -- 玩家:发送系统(v.广播, 玩家.名称, r.nid, r.名称)
        end
    end

    self:删除()
end

function 任务:任务NPC给予(玩家, NPC, cash, items)
    if NPC.名称 == "木匠" then
        local r = 玩家:取任务("宝图_送金票")
        if r then
            if items and items[1] then
                if items[1].名称 == "金票" then
                    if items[1].数量 >= 1 then
                        items[1]:接受(1)
                        r:掉落包(玩家)
                        NPC.台词 = nil
                    end
                end
            end
        end
    end
end

return 任务
