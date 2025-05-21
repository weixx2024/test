local 角色 = require('角色')

function 角色:角色_获取助战列表()

end

-- 助战链接id = 助战角色id + 10000000
-- 主号nid
function 角色:助战上线(助战链接id, 主号nid)
    local 主号 = __玩家[主号nid]
    -- self.cid = id --网络
    self.可刷新 = false
    self.是否助战 = true
    -- self.rpc:进入游戏(self:取登录数据(), self.设置)
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

    if 主号 then
        if not 主号.助战列表 then
            主号.助战列表 = {}
        end

        主号.助战列表[self.nid] = true
        主号:队伍_添加助战(self)
    end
end

function 角色:角色_助战下线(助战nid)
    if self.nid == 助战nid then
        return
    end
    local 助战 = __玩家[助战nid]
    if 助战 then
        助战.可刷新 = false
        助战.cid = nil
        if 助战.是否战斗 then
            助战:退出战斗()
        end

        助战:角色_离开队伍()
        助战:日志_下线()
        助战.当前地图:删除玩家(助战)
        助战.当前地图:删除召唤(助战.观看召唤)
        助战.当前地图:删除宠物(助战.观看宠物)
        __世界:删除玩家(助战)
        助战.登录时间 = 0
        助战.task:任务下线(助战.接口)
        if 助战.帮派对象 then
            助战.帮派对象:成员下线(助战)
        end

        助战:存档()
    end
end

