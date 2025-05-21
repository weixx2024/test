-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2024-05-08 17:38:51
-- @Last Modified time  : 2024-08-20 20:28:42

local map = {}
function map:初始化()

end
local 倒计时 = os.time()

local function 取随机天书()
    local itmes = {'天书残卷第一卷','天书残卷第一卷','天书残卷第一卷','天书残卷第二卷','天书残卷第二卷','天书残卷第二卷','天书残卷第三卷','天书残卷第三卷','天书残卷第三卷','天书残卷第四卷','天书残卷第四卷','天书残卷第四卷','天书残卷第五卷','天书残卷第五卷','天书残卷第六卷','天书残卷第七卷','天书残卷第八卷','天书残卷第九卷'}
    return itmes[math.random(#itmes)]
end

local function 取随机百分比药()
    local itmes = {'千年熊胆','玫瑰仙叶','仙鹿茸','修罗玉','海蓝石','夜叉石'}
    return itmes[math.random(#itmes)]
end

local function 取随机炼化材料()
    local itmes = {'九彩云龙珠','血玲珑','内丹精华','九彩云龙珠','血玲珑','九玄仙玉','落魂砂'}
    return itmes[math.random(#itmes)]
end

local function 获取奖励表(对象,等级,转生)
    if 转生 == 1 and 等级 < 100 then
        等级 = 100
    elseif 转生 == 2 and 等级 < 122 then
        等级 = 122
    elseif 转生 == 3 and 等级 < 142 then
        等级 = 142
    end
    local _地图在线奖励 = 对象.接口:地图在线奖励()
    for k,v in pairs(_地图在线奖励) do
        if k == '物品配置' then
            for i=#v,1,-1 do -- 从后往前循环
                if v[i].等级限制 and v[i].等级限制 > 等级 then
                    table.remove(v, i)
                end
                if v[i].限制数量 and v[i].限制数量 <= 0 then
                    table.remove(v, i)
                end
            end
        end
        if k == 'sun' then
            local 总几率 = 0
            for i=1,#_地图在线奖励.物品配置 do
                if _地图在线奖励.物品配置[i].几率 ~= nil then
                    总几率 = 总几率 + _地图在线奖励.物品配置[i].几率
                end
            end
            _地图在线奖励[k] = 总几率
        end
    end
    return _地图在线奖励
end

local function 是否奖励(对象,等级,转生)
    if 等级 == nil or type(等级) ~= 'number' then 等级 = 0 end
    if 转生 == nil or type(转生) ~= 'number' then 转生 = 0 end
    local 奖励表 = 获取奖励表(对象,等级,转生)
    if 奖励表 == nil then
        return
    end
    local 总概率 = 奖励表.sun --总概率
    local 随机数 = math.random() --是否可以获得道具随机数
    if 总概率 >= 随机数 then --如果总概率大于获得的随机数必定获得奖励
        local 目标权重 = math.random(0, math.floor(总概率 * 10000)) / 10000 --获取一个随机小数
        local 当前权重 = 0 --初始化获得道具概率
        for i=1,#奖励表.物品配置 do
            for k, v in pairs(奖励表.物品配置[i]) do --遍历掉落表
                if k == '几率' then
                    当前权重 = 当前权重 + v --概率重新赋值,概率=概率+随机一项概率的值
                    if 当前权重 >= 目标权重 then --如果道具概率大于等于随机数则返回对应掉落信息
                        local 道具 = 奖励表.物品配置[i]
                        if 道具.道具 == '随机天书' then
                            道具.道具 = 取随机天书()
                        elseif 道具.道具 == '百分比药品' then
                            道具.道具 = 取随机百分比药()
                        elseif 道具.道具 == '炼化材料' then
                            道具.道具 = 取随机炼化材料()
                        end
                        return {道具信息 = 道具,编号=i,广播 = 奖励表.广播}
                    end
                end
            end
        end
    end
    return nil
end

--重启
function map:处理事件(tb)
    local hour = tonumber(os.date('%H', os.time()))--小时
    local minute = tonumber(os.date('%M', os.time()))--分
    local second = tonumber(os.date('%S', os.time()))--秒
    --hour  你要设定几点到几点   晚上8点-10点
    -- 20就是8点 23是11点 是测试用的 正常应该是22   --  后面这个是10 是指的10秒 在这个时间段 每五分钟发个活动公告 跟结束时的一个公告 你写个例子 我在自己改内容公告

    if hour >= 20 and hour <= 22 then -- 14改成 20 3个地图的都改哈 好
        if minute == 0 and  second == 0 then
            tb.接口:发送系统('#Y【天女散花】每晚8点~10点！开启天女散花活动，玩家在长安城,洛阳城，东海渔村地图内，可获得天女散花奖励，奖励丰厚#56')
        end
        if os.time() - 倒计时 >= 600 then --600 改成600
            tb.接口:发送系统('#Y【天女散花】每晚8点~10点！开启天女散花活动，玩家在长安城,洛阳城，东海渔村地图内，可获得天女散花奖励，奖励丰厚#56')  
            倒计时 = os.time()
            local next,data = tb:遍历玩家()
            for i,v in pairs(data) do
                if v.转生 == 3 and v.等级 >= 120 then
                    local 奖励 = 是否奖励(v,v.等级,v.转生)
                    if 奖励 ~= nil and type(奖励) == 'table' then
                        if 奖励.道具信息.模型 then
                            local r = 生成召唤 { 名称 =奖励.道具信息.模型 }
                            if v.接口:添加召唤( r ) then
                                r.染色 = tonumber('0x03010101')
                                if 奖励.道具信息.限制数量 then
                                    奖励.道具信息.限制数量 = 奖励.道具信息.限制数量 - 1
                                end
                                if 奖励.道具信息.是否广播 == 1 and 奖励.广播 ~= nil then
                                    v.接口:发送系统(奖励.广播, v.名称, r.ind, r.名称)
                                end
                            end
                        else
                            local r = 生成物品 { 名称 = 奖励.道具信息.道具, 数量 = 奖励.道具信息.数量, 参数 = 奖励.道具信息.参数 }
                            if r then
                                if 奖励.道具信息.限制数量 then
                                    奖励.道具信息.限制数量 = 奖励.道具信息.限制数量 - 1
                                end
                                v.接口:添加物品({ r })
                                if 奖励.道具信息.是否广播 == 1 and 奖励.广播 ~= nil then
                                    v.接口:发送系统(奖励.广播, v.名称, r.ind, r.名称)
                                end
                            end
                        end
                    end
                    --v.接口:添加仙玉(100)
                    v.接口:添加银子(10000)
                    v.接口:添加经验(50000) --重启
                end
            end
        end
    elseif hour == 23 and minute == 00 and  second == 0 then
        tb.接口:发送系统('#Y【天女散花】活动已结束，感谢每一位玩家的参与！#23')
    end
end


return map
