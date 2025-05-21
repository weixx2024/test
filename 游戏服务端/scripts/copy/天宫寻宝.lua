local 副本 = {
    名称 = '天宫寻宝',
    类型 = 1, --1全服
    是否打开 = false,
}
function 副本:副本初始化()
    self.活动时 = "07"
    self.活动分 = "30"
    self.活动时长 = 0

end

function 副本:更新(sec) --统一控制  开启  报名 进场 活动

end
-- 13:00 广播 天地豪杰勇气令人称赞，为示嘉奖，玉帝特将天宫宝库开放。各路豪杰可以进入宝库恣意搜寻。天宫宝库将在15：00开放，请各路豪杰抓紧时间准备入库寻宝。
-- 天地豪杰勇气令人称赞，为示嘉奖，玉帝特命天赎星君带路，引导群豪入天宫宝库恣意搜寻。现天宫宝库已经开放，请各路豪杰抓紧时间入库寻宝。
-- 14:00 进场 天宫宝库开放之后，在活动开放期间玩家可以和位于东海渔村（50，118）的天赎星君对话进入宝库。
function 副本:是否开启(sec)
    return self.是否打开
end

function 副本:进场(sec)
    self.是否打开 = true
    发送系统("#Y天地豪杰勇气令人称赞，为示嘉奖，玉帝特命天赎星君带路，现天宫宝库已经开放，请各路豪杰抓紧时间入库寻宝。")
    -- 发送公告("#Y天地豪杰勇气令人称赞，为示嘉奖，玉帝特命天赎星君带路，现天宫宝库已经开放，请各路豪杰抓紧时间入库寻宝。")
    self.层数 = 1
    self.剩余宝箱 = 0
    self.宝箱 = false
    self.开启时间 = os.time()


    self.配置 = {
        { 守护体力 = 10, 最大体力 = 10, 守财奴 = 20, 宝箱 = 100 },
        { 守护体力 = 10, 最大体力 = 10, 守财奴 = 20, 宝箱 = 100 },
        { 守护体力 = 10, 最大体力 = 10, 守财奴 = 20, 宝箱 = 100 },
        { 守护体力 = 10, 最大体力 = 10, 守财奴 = 20, 宝箱 = 100 },

    }

    self:刷出守财奴()




end

local _地图 = {
    021197,
    001293,
    011293,
    001294,
}
--self.地图 = __沙盒.生成地图(1226)
function 副本:刷出守财奴()
    for n = 1, 4, 1 do
        local map = 取地图(_地图[n])
        map:清空怪物()
        for i = 1, self.配置[n].守财奴, 1 do
            local X, Y = map:取随机坐标()
            map:添加怪物 {
                名称 = "守财奴",
                外形 = 2277,
                击杀消失 = false,
                等级 = 80,
                脚本 = 'scripts/war/宝库_守财奴.lua',
                X = X,
                Y = Y,
                副本 = self
            }
        end
    end


end

function 副本:刷出宝箱()
    self.宝箱 = true
    self.剩余宝箱 = self.配置[self.层数].宝箱
    local map = 取地图(_地图[self.层数])
    for i = 1, self.剩余宝箱, 1 do
        local X, Y = map:取随机坐标()
        map:添加NPC {
            名称 = "宝箱",
            外形 = 6617,
            击杀消失 = false,
            等级 = 80,
            脚本 = 'scripts/npc/限时活动/天宫寻宝_宝箱.lua',
            X = X,
            Y = Y,
            副本 = self
        }
    end
end

function 副本:取当前层(n)
    return self.层数
end

function 副本:击杀守卫(n)
    self.配置[n].守护体力 = self.配置[n].守护体力 - 1
    if self.配置[n].守护体力 < 0 then
        self.配置[n].守护体力 = 0
    end
    if self.配置[n].守护体力 == 0 and not self.宝箱 then
        --广播
        self:刷出宝箱()
    end
end

function 副本:开启下一层()
    self.剩余宝箱 = 0
    self.宝箱 = false
    self.配置[self.层数].守护体力 = self.配置[self.层数].最大体力
    --“广播”

end

function 副本:击杀贪婪怪()
    if self.宝箱 then
        self.剩余宝箱 = self.剩余宝箱 - 1
        if self.剩余宝箱 <= 0 then
            self.层数 = self.层数 + 1 > 4 and 1 or self.层数 + 1
            self:开启下一层()
        end
    end
end

function 副本:传送下一层(n)
    if self.层数 == 4 and n == 1 then
        if not self.宝箱 then
            return "请击杀本守卫"
        end
        if self.剩余宝箱 > 0 then
            return "本层还有" .. self.剩余宝箱 .. "个宝箱"
        end
        return true
    end

    if n <= self.层数 then
        return true
    end
    if not self.宝箱 then
        return "请击杀本守卫"
    end
    return "本层还有" .. self.剩余宝箱 .. "个宝箱"
end

return 副本
