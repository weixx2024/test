-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-03 15:56:58
-- @Last Modified time  : 2022-07-04 10:34:53
local 物品 = {
    名称 = '风灯',
    叠加 = 0,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false,
    禁止交易 = true,
}



local _地图 = {
    1193, 1110, 1092



}

local _任务组 = {
    '清明_侍魂_恶鬼',
    '清明_侍魂_善鬼_插柳',
    '清明_侍魂_恶鬼',
    '清明_侍魂_善鬼_人鬼重会',
    '清明_侍魂_恶鬼',
    '清明_侍魂_善鬼_榆柳之火',
    '清明_侍魂_恶鬼',
    '清明_侍魂_无名',
    '清明_侍魂_恶鬼',


}


function 物品:使用(对象)
    if not 对象.是否组队 or not 对象.是否队长 then
        对象:常规提示("#Y必要组队大于3人切由队长使用")
        return
    end
    if 对象:取队伍人数() < 3 then
        对象:常规提示("#Y必要组队大于3人切由队长使用")
        return
    end
    local fh = false
    for i, v in ipairs(_地图) do
        if 对象.地图 == v then
            fh = true
            break
        end
    end
    if not fh then
        对象:常规提示("#Y请在长安东、大唐境内、傲来国使用")
        return
    end
    if self.冷却 then
        if os.time() - self.冷却 < 10 then
            对象:常规提示("#Y每次使用间隔10秒，过一会再试试吧")
            return
        end
    end
    local rw
    for _, v in ipairs(_任务组) do
        rw = 对象:取任务(v)
        if rw then
            对象:常规提示("#Y你身上尚未完成的任务")
            return
        end
    end

    local t = {}
    for _, v in ipairs(_任务组) do
        for _, p in 对象:遍历队伍() do
            if p:取任务(v) then
                table.insert(t, p.名称)
            end
        end
    end

    if #t > 0 then
        对象:常规提示('#Y' .. table.concat(t, '、 ') .. '已有此任务,无法重复领取')
        return
    end
    local r = 生成任务 { 名称 = _任务组[math.random(#_任务组)] }
    if r and r:添加任务(对象) then
        self.冷却 = os.time()
    end
    self.参数 = self.参数 - 1
    if self.参数 <= 0 then
        self.数量 = self.数量 - 1
    end
end

return 物品
