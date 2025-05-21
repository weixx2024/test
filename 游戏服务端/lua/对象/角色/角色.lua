local 角色 = class('角色')
--用gge.require，不会被缓存
gge.require('对象/角色/摆摊')
gge.require('对象/角色/帮派')
gge.require('对象/角色/仓库')
gge.require('对象/角色/仓库_召唤兽')
gge.require('对象/角色/货币')
gge.require('对象/角色/称谓')
gge.require('对象/角色/宠物')
gge.require('对象/角色/地图')
gge.require('对象/角色/队伍')
gge.require('对象/角色/管理')
gge.require('对象/角色/技能')
gge.require('对象/角色/交易')
gge.require('对象/角色/商城')
gge.require('对象/角色/月卡')
gge.require('对象/角色/寄售')
--角色

--接口
gge.require('对象/角色/界面')
gge.require('对象/角色/任务')
gge.require('对象/角色/属性')
gge.require('对象/角色/数据')
gge.require('对象/角色/算法')
gge.require('对象/角色/通信')
gge.require('对象/角色/物品')
gge.require('对象/角色/战斗')
gge.require('对象/角色/召唤')
gge.require('对象/角色/孩子')
gge.require('对象/角色/法宝')
gge.require('对象/角色/作坊')
gge.require('对象/角色/坐骑')
gge.require('对象/角色/观战')
gge.require('对象/角色/合成')
gge.require('对象/角色/日志')
gge.require('对象/角色/自动任务')
gge.require('对象/角色/变身卡')
gge.require('对象/角色/物品兑换')
gge.require('对象/角色/装备')
gge.require('对象/角色/好友')
gge.require('对象/角色/PK')
gge.require('对象/角色/活动')
gge.require('对象/角色/礼包')
gge.require('对象/角色/机器人')
gge.require('对象/角色/助战')
gge.require('对象/角色/帮战')
gge.require('对象/角色/特技')

function 角色:初始化(t)
    local t = self:地图处理(t)
    self:加载存档(t)
    self.登录地址 = self.ip
    if not self.原形 or self.原形 == 0 then
        self.原形 = self.外形
    end
    if string.find(self.名称, "#") then
        self.名称 = self.名称:gsub("#", "")
    end
    self:特技_初始化()
    self:物品_初始化()
    self:召唤_初始化()
    self:孩子_初始化()
    self:宠物_初始化()
    self:通信_初始化()
    self:地图_初始化()
    self:队伍_初始化()
    self:任务_初始化()
    self:技能_初始化()
    self:界面_初始化()
    self:坐骑_初始化() --在召唤后
    self:管理_初始化()
    self:日志_初始化()
    self:帮派_初始化()
    self:好友_初始化()
    self:寄售_初始化()
    self:法宝_初始化()




    self:属性_初始化() --最后
    self.状态 = {} --头顶
    self.窗口 = {}
    self.脚本对话检查 = 0
    self.脚本寻路检查 = 0
    self.接口 = require('对象/角色/接口')(self)
    self:角色_取名称颜色()
    self.在线时间 = os.time()
    if not self.新手剧情 then
        self.新手剧情 = true
        self:任务_添加(__沙盒.生成任务 { 名称 = '新手剧情', up = true })
        self:任务_添加(__沙盒.生成任务 { 名称 = '引导_升级检测' })
        self:任务_添加(__沙盒.生成任务 { 名称 = '引导_称谓剧情' })
    end
end

function 角色:__index(k) --取值
    if k == '仙玉' then
        return __仙玉[self.uid]
    end
    local 数据 = rawget(self, '数据')
    if 数据 then
        return 数据[k]
    end
end

local _存档表 = require('数据库/存档属性_角色')
function 角色:__newindex(k, v) --改值
    if k == '仙玉' then
        __仙玉[self.uid] = v
        return
    end
    if _存档表[k] ~= nil then
        if self.可刷新 and self.刷新的属性 and k ~= 'x' and k ~= 'y' then
            self.刷新的属性[k] = v
        end
        self.数据[k] = v
        return
    end
    rawset(self, k, v)
end

local TGXB = { [1293] = 1, [1294] = 1, [11294] = 1, [21294] = 1, }

function 角色:更新(sec)
    -- print(self.更新时间, sec)
    if self.是否掉线 or self.离线摆摊 then
        return
    end

    if self.是否机器人 then
        self:机器人_更新(sec)
        return
    end

    if self.可刷新 then
        self:属性_更新(sec)
        self:地图_更新(sec)
        self:物品_更新(sec)
        self:任务_更新(sec)
        self:召唤_更新(sec)
        self:宠物_更新(sec)
        self:坐骑_更新(sec)
        self:孩子_更新(sec)
    end

    if self.帮战状态 then
        self:龙神帮战_更新(sec)
    end

    if sec - self.在线时间 > 3600 then
        self.在线时间 = os.time()
        self:添加体力(10)
    end

    if self.保护时间 then
        if sec - self.保护时间 >= 0 then
            self.保护时间 = nil
        end
    end

    -- 缓存玩家数据
    local temp = sec - self.更新时间
    if temp >= 30 then
        -- __世界:INFO('缓存角色数据 -> %s', self.名称)
        self.更新时间 = sec
        local data = self:取存档数据()
        data.存档时间 = os.time()
        __redis:存档角色(self.nid, data)
    end
end

function 角色:符合替身(nid)
    if self.转生 < 1 and not self.是否摆摊 and not self.是否组队 and self.nid ~= nid then
        return true
    end
end

function 角色:上线(id)
    self.cid = id -- 网络
    self.可刷新 = false
    self.rpc:进入游戏(self:取登录数据(), self.设置)
    self.更新时间 = os.time()
    self.可刷新 = true
    self.交易锁 = true
    self.离线摆摊 = nil
    __世界:添加玩家(self)
    if not self.是否机器人 then
        __世界:发送系统('#Y欢迎#R#u%s#u#Y进入游戏！', self.名称)
    else
        self.活跃时间 = os.time()
    end
    if self.观看召唤 then
        self.观看召唤:召唤_观看(true)
    end
    if self.观看宠物 then
        self.观看宠物:宠物_观看(true)
    end

    self.task:任务上线(self.接口)
    self:角色_刷新外形()

    if __副本地图[self.当前地图.接口.id] and self.当前地图.接口.名称 == '龙神比武场' then
        if next(__帮派[self.帮派].帮战信息) ~= nil then
            self.接口:龙神帮战入场()
        else
            self.接口:龙神帮战退场()
            self.rpc:提示窗口('#Y帮战已结束')
        end
    end

    if self.同步sql then
        self.同步sql = false
        __世界:INFO('同步redis存档到sql -> %s', self.名称)
        self:存档()
    end
end

function 角色:角色_取登录数据()
    return self:取登录数据(), self.设置
end

function 角色:处理补偿()
    self.补偿领取 = os.time()
end

function 角色:角色_刷新外形()
    if self.管理 == 1 then
        self.外形 = 38
        return self.外形
    end
    local r = self:任务_获取("移魂换魄简")
    if r then
        self.外形 = r.外形
        return self.外形
    end
    r = self:任务_获取("孔庙祭祀_祭拜")
    if r then
        self.外形 = r.外形
        return self.外形
    end
    r = self:任务_获取("变身卡")
    if r and r.是否变身 and r.外形 then
        self.外形 = r.外形
        return r.外形
    end
    if self.当前坐骑 then
        self.外形 = 5000 + self.原形 * 10 + self.当前坐骑.几座
        return self.外形
    end

    self.外形 = self.原形
end

local _名称颜色 = { 16711935, -- 0, 63, 0,
    3832303359, -- 63, 29, 21,
    820969471, -- 12, 59, 63,
    3341298175, -- 59, 9, 9, 
}

function 角色:角色_取名称颜色()
    if _名称颜色[self.转生 + 1] then
        self.名称颜色 = _名称颜色[self.转生 + 1]
    end
    if self.飞升 == 1 then
        self.名称颜色 = 2265576191
    end
end

function 角色:重新上线(id, t)
    if t then
        self.ip = t.ip
        -- self.管理 = t.管理
        self.账号 = t.账号
    end
    self.交易锁 = true
    self.离线摆摊 = nil
    self.rpc:提示窗口('#R其它地方的登录顶替了你')
    self.rpc:顶号提示()
    self.cid = id
    self.是否掉线 = false
    if self.是否战斗 then
        self.战斗.是否断线 = nil
    end
    self.战斗自动 = false
    self.可刷新 = false
    -- self.状态 = {} --头顶
    self.窗口 = {}
    self:地图_初始化()
    self.rpc:进入游戏(self:取登录数据(), self.设置)
    self:队伍重新上线()
    -- 获取队伍信息
    self.可刷新 = true
    self.更新时间 = os.time()
    self.rpc:刷新任务追踪()
    self:战斗_重连()
    self.是否助战 = nil
    self.接口:顶号进入帮战()
    -- self:摆摊_重连()
end

function 角色:地图处理(t)
    if t.数据.地图 == nil or not __地图[t.数据.地图] or t.数据.地图 == 120001 then
        print(t.数据.地图)
        if __config.新地图 then
            t.数据.地图 = 1208
            t.数据.x = 33*20
            t.数据.y = 14*20
        else
            t.数据.地图 = 1208
            t.数据.x = 935
            t.数据.y = 194 
        end
    elseif not __水陆大会.报名开关 and t.数据.地图 == __水陆大会.地图.id  then
        t.数据.地图 = 1001
        t.数据.x = 6000
        t.数据.y = 5000
    end
    return t
end

function 角色:下线()
    self.可刷新 = false
    self.cid = nil
    if self.是否机器人 then
        self:角色_离开队伍()
        self.当前地图:删除玩家(self)
        __世界:删除玩家(self)
        return
    end

    if self.助战列表 and next(self.助战列表) ~= nil then
        for k, v in pairs(self.助战列表) do
            if v then
                self.助战列表[k] = false
                self:角色_助战下线(k)
            end
        end
    end

    if self.是否战斗 then
        self.是否掉线 = true
        self.战斗.是否断线 = true
    elseif self.是否摆摊 then
        self.离线摆摊 = true
        self.是否掉线 = true
        self:存档()
    else
        self:角色_离开队伍()
        self:日志_下线()
        -- rpc:交易关闭(self)
        self:角色_交易结束()
        -- rpc:摆摊结束(self)
        -- self:好友_下线()
        self.当前地图:删除玩家(self)
        self.当前地图:删除召唤(self.观看召唤)
        self.当前地图:删除宠物(self.观看宠物)

        __世界:删除玩家(self)
        self.登录时间 = 0
        self.task:任务下线(self.接口)
        if self.帮派对象 then
            self.帮派对象:成员下线(self)
        end

        self:存档()
        return true
    end
end

function 角色:踢下线()
    self.rpc:踢出游戏()
    self.可刷新 = false
    self.cid = nil
    if self.是否战斗 then
        self:退出战斗()
    end

    self:角色_离开队伍()
    self:日志_下线()
    -- rpc:交易关闭(self)
    self:角色_交易结束()
    -- rpc:摆摊结束(self)
    -- self:好友_下线()
    self.当前地图:删除玩家(self)
    self.当前地图:删除召唤(self.观看召唤)
    self.当前地图:删除宠物(self.观看宠物)
    __世界:删除玩家(self)
    self.登录时间 = 0
    self.task:任务下线(self.接口)
    if self.帮派对象 then
        self.帮派对象:成员下线(self)
    end

    self:存档()
    return true
end

function 角色:禁言处理(封禁)
    self.禁言 = 封禁 + 0
    if self.禁言 == 0 then
        self.rpc:提示窗口("#R你已被管理员禁止发言")
    else
        self.rpc:提示窗口("#G你已被管理员接触禁止发言")
    end
end

function 角色:角色禁交易(封禁)
    self.禁交易 = 封禁 + 0
    if self.禁交易 == 0 then
        self.rpc:提示窗口("#R你已被管理员禁止交易")
    else
        self.rpc:提示窗口("#G你已被管理员接触禁止交易")
    end
end

function 角色:掉线() --玩家依旧存在世界中
    if self.是否组队 and not self.是否战斗 then
        self:角色_离开队伍()
    end
    self.cid = nil
    self.是否掉线 = true
end

function 角色:存档()
    if self.是否机器人 then
        return
    end
    -- print("玩家开始执行存档",self.名称)
    require('数据库/存档').角色存档(self:取存档数据())
end

--===========================================================================
--地图
--===========================================================================

function 角色:时辰刷新(时辰)
    if 时辰 == 5 or 时辰 == 11 then --白天黑夜
        -- for k,v in pairs(self.周围) do
        --     if v.type ==2 then--NPC
        --         self:地图_删除对象(v)
        --     end
        -- end
    end
end

function 角色:角色_月卡数据()
    local 剩余天数 = 0
    local 是否领取 = false
    if self.月卡数据.时效 and os.time() < self.月卡数据.时效 then
        剩余天数 = math.ceil((self.月卡数据.时效 - os.time())/86400)
    end
    local 领取日期 = self.月卡数据.领取
    local 当日 = os.date("%Y%m%d")
    if 领取日期  ==  当日 then
        是否领取 = true
        剩余天数 = 剩余天数 - 1
        if 剩余天数 <= 0 then 剩余天数 = 0 end
    end
    return 剩余天数,是否领取
end

function 角色:角色_月卡奖励() 
    if self.月卡数据.时效 == nil or os.time() > self.月卡数据.时效 then
        return "#Y你还没有激活月卡或者已经失效"
    end
    local 领取日期 = self.月卡数据.领取
    local 当日 = os.date("%Y%m%d")
    if 领取日期  ==  当日 then
        return "#Y今日已经领取过了"
    end
    if self.接口:取活动限制次数('月卡') >= 1 then
        return "#Y今日已经领取过了"
    end
    self.月卡数据.领取 = os.date("%Y%m%d")
    self.接口:增加活动限制次数('月卡')
    self:物品_添加({ __沙盒.生成物品 { 名称 = '积分卡', 参数=300, 数量 = 1, 禁止交易 = true } })
    self:物品_添加({ __沙盒.生成物品 { 名称 = "师贡礼包", 参数 = 10000000, 数量 = 1, 禁止交易 = true } })
    self:物品_添加({ __沙盒.生成物品 { 名称 = '银票', 参数=10000000, 数量 = 1, 禁止交易 = true } })
    self:物品_添加({ __沙盒.生成物品 { 名称 = '帮派成就册', 参数=10000, 数量 = 1, 禁止交易 = true } })
    self:物品_添加({ __沙盒.生成物品 { 名称 = '清盈果', 参数=1000, 数量 = 1, 禁止交易 = true } })
    self:物品_添加({ __沙盒.生成物品 { 名称 = '炼化大礼包', 数量 = 1, 禁止交易 = true } })
    self:物品_添加({ __沙盒.生成物品 { 名称 = '神兵石', 数量 = 30, 禁止交易 = true } })
    self:物品_添加({ __沙盒.生成物品 { 名称 = '亲密丹', 参数 = 10000, 数量 = 30, 禁止交易 = true } })
    return '#Y领取今日月卡奖励成功',true
end

return 角色
