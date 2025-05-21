local 角色 = require('角色')

function 角色:界面_初始化()
    self.上次发言 = 0
end

local function _get(s, name)
    local 脚本 = __脚本[s]
    if type(脚本) == 'table' then
        if name then
            return 脚本[name]
        end
        return 脚本
    end
end

--[[
[0]={0,255,0--0, 63, 0,}
[1]={228,108,78--63, 29, 21,}
[2]={48,238,255--12, 59, 63,}
[3]={199,40,41--59, 9, 9,}


16711935
3832303359
820969471
3341298175

]]
local function debug(self, str)
    if str == '1' then

        local r = self.接口:取参战召唤兽()
        if r then
            r:添加领悟技能('高级分裂攻击')
        end
        return

    elseif str == '2' then

        local 题戏三界 = __事件['题戏三界']
        题戏三界:刷出题目()
        local 是否开启 = 题戏三界:是否在开启()
        print(题戏三界.答案, 题戏三界.接收答题, 是否开启)
        return

    elseif str == '3' then
        local r = self:任务_获取('称谓13_偷吃人参果')
        if r then
            r:删除()
        end
        return
    elseif str == '4' then
        self.作坊 = {
            { 名称 = "步摇坊", 熟练度 = 999, 段位 = 0, 等级 = 150, 成就 = 8888 },
            { 名称 = "湛卢坊", 熟练度 = 999, 段位 = 0, 等级 = 150, 成就 = 8888 },
            { 名称 = "七巧坊", 熟练度 = 999, 段位 = 0, 等级 = 150, 成就 = 8888 },
            { 名称 = "生莲坊", 熟练度 = 999, 段位 = 0, 等级 = 150, 成就 = 8888 },
            { 名称 = "同心坊", 熟练度 = 999, 段位 = 0, 等级 = 150, 成就 = 8888 },
            { 名称 = "炼器坊", 熟练度 = 999, 段位 = 0, 等级 = 150, 成就 = 8888 },
        }
        return
    elseif str == '5' then
        self.接口:添加任务(__沙盒.生成任务 { 名称 = '称谓9_抹杀孙悟空', 进度 = 0, 对话进度 = 0 })
        return
    elseif str == '6' then
        self.接口:进入战斗('scripts/war/测试.lua')
        return
    elseif str == '7' then
        self:清空技能()
        self.接口:添加指定种族全部技能(1, 25000)
        return
    elseif str == '8' then
        return
    elseif str == '9' then
        return
    end
end

local _称谓表 = {
    { '武林新丁', '江湖小虾', '后起之秀', '武林高手', '风尘奇侠', '无双隐士', '世外高人', '江湖侠隐', '无敌圣者', '三界贤君', '夕阳武士', '神通广大', '变化无穷', '火眼金睛' },
    { '古灵精怪', '魅力精灵', '魔幻使者', '妖之奇葩', '天神煞星', '万兽妖灵', '混世魔王', '三界妖仙', '魔神至尊', '齐天妖王', '夕阳武士', '神通广大', '变化无穷', '火眼金睛' },
    { '仙灵小童', '逍遥之仙', '陆地飞仙', '无极天师', '神机真人', '降魔金仙', '金身尊者', '天外飞仙', '万圣天尊', '九天圣佛', '夕阳武士', '神通广大', '变化无穷', '火眼金睛' },
    { '阴曹小鬼', '飘渺之魂', '幽冥鬼士', '勾魂使者', '催命判官', '阴阳无常', '阎罗鬼王', '冥灵鬼仙', '九幽神君', '阴都大帝', '夕阳武士', '神通广大', '变化无穷', '火眼金睛' }
}


function 角色:修复称谓(cw)
    if cw == 1 then
        self.接口:删除称谓(_称谓表[self.种族][1])

        local r = self:任务_获取('称谓1_教训食婴鬼')
        if r then
            self:角色_取消任务1(r.nid)
        end
        r = self:任务_获取('称谓1_教训飞贼')
        if r then
            self:角色_取消任务1(r.nid)
        end
        r = self:任务_获取('称谓1_教训食婴鬼手下')
        if r then
            self:角色_取消任务1(r.nid)
        end
        r = self:任务_获取('称谓1_失踪的小孩')
        if r then
            self:角色_取消任务1(r.nid)
        end
    elseif cw == 2 then
        self.接口:删除称谓(_称谓表[self.种族][2])
        local r = self:任务_获取('称谓2_般若多罗密心经')
        if r then
            self:角色_取消任务1(r.nid)
        end
        r = self:任务_获取('称谓2_定魂珠')
        if r then
            self:角色_取消任务1(r.nid)
        end
        r = self:任务_获取('称谓2_水陆大会')
        if r then
            self:角色_取消任务1(r.nid)
        end
    elseif cw == 3 then
        self.接口:删除称谓(_称谓表[self.种族][3])
        local r = self:任务_获取('称谓3_春三十娘')
        if r then
            self:角色_取消任务1(r.nid)
        end
        r = self:任务_获取('称谓3_山贼之灵')
        if r then
            self:角色_取消任务1(r.nid)
        end
        r = self:任务_获取('称谓3_羊脂仙露')
        if r then
            self:角色_取消任务1(r.nid)
        end
        r = self:任务_获取('称谓3_夜光珠')
        if r then
            self:角色_取消任务1(r.nid)
        end
    elseif cw == 4 then
        self.接口:删除称谓(_称谓表[self.种族][4])

        local r = self:任务_获取('称谓4_加入天兵')
        if r then
            self:角色_取消任务1(r.nid)
        end
        r = self:任务_获取('称谓4_摄魂鬼')
        if r then
            self:角色_取消任务1(r.nid)
        end
        r = self:任务_获取('称谓4_四琉璃碎片')
        if r then
            self:角色_取消任务1(r.nid)
        end
        r = self:任务_获取('称谓4_滋扰高小姐的妖怪')
        if r then
            self:角色_取消任务1(r.nid)
        end
    elseif cw == 5 then
        self.接口:删除称谓(_称谓表[self.种族][5])

        local r = self:任务_获取('称谓5_天宫名菜')
        if r then
            self:角色_取消任务1(r.nid)
        end
        r = self:任务_获取('称谓5_天宫玉酒')
        if r then
            self:角色_取消任务1(r.nid)
        end
        r = self:任务_获取('称谓5_找到紫霞')
        if r then
            self:角色_取消任务1(r.nid)
        end
    elseif cw == 6 then
        self.接口:删除称谓(_称谓表[self.种族][6])

        local r = self:任务_获取('称谓6_孽缘')
        if r then
            self:角色_取消任务1(r.nid)
        end
        r = self:任务_获取('称谓6_孽缘之海底妖尸')
        if r then
            self:角色_取消任务1(r.nid)
        end
        r = self:任务_获取('称谓6_孽缘之思情')
        if r then
            self:角色_取消任务1(r.nid)
        end
        r = self:任务_获取('称谓6_孽缘之太上老君')
        if r then
            self:角色_取消任务1(r.nid)
        end
    elseif cw == 7 then
        self.接口:删除称谓(_称谓表[self.种族][7])

        local r = self:任务_获取('称谓7_玄天神鞭')
        if r then
            self:角色_取消任务1(r.nid)
        end
        r = self:任务_获取('称谓7_拯救唐僧')
        if r then
            self:角色_取消任务1(r.nid)
        end
    elseif cw == 8 then
        self.接口:删除称谓(_称谓表[self.种族][8])

        local r = self:任务_获取('称谓8_妙法莲华经')
        if r then
            self:角色_取消任务1(r.nid)
        end
        r = self:任务_获取('称谓8_一万三千年之前')
        if r then
            self:角色_取消任务1(r.nid)
        end
    elseif cw == 9 then
        self.接口:删除称谓(_称谓表[self.种族][9])

        local r = self:任务_获取('称谓9_斧头帮的白虎')
        if r then
            self:角色_取消任务1(r.nid)
        end
        r = self:任务_获取('称谓9_抹杀孙悟空')
        if r then
            self:角色_取消任务1(r.nid)
        end
        r = self:任务_获取('称谓9_蟠桃园的山妖')
        if r then
            self:角色_取消任务1(r.nid)
        end
    elseif cw == 10 then
        self.接口:删除称谓(_称谓表[self.种族][10])

        local r = self:任务_获取('称谓10_九生九死')
        if r then
            self:角色_取消任务1(r.nid)
        end
    elseif cw == 11 then
        self.接口:删除称谓(_称谓表[self.种族][11])

        local r = self:任务_获取('称谓11_佛家宝物')
        if r then
            self:角色_取消任务1(r.nid)
        end
        r = self:任务_获取('称谓11_夕阳武士')
        if r then
            self:角色_取消任务1(r.nid)
        end
        r = self:任务_获取('称谓11_紫霞的金铃')
        if r then
            self:角色_取消任务1(r.nid)
        end
    elseif cw == 12 then
        self.接口:删除称谓(_称谓表[self.种族][12])

        local r = self:任务_获取('称谓12_度亡经')
        if r then
            self:角色_取消任务1(r.nid)
        end
        r = self:任务_获取('称谓12_四圣戏禅心')
        if r then
            self:角色_取消任务1(r.nid)
        end
        r = self:任务_获取('称谓12_玄奘身世')
        if r then
            self:角色_取消任务1(r.nid)
        end
    elseif cw == 13 then
        self.接口:删除称谓(_称谓表[self.种族][13])

        local r = self:任务_获取('称谓13_取经路上')
        if r then
            self:角色_取消任务1(r.nid)
        end
        r = self:任务_获取('称谓13_偷吃人参果')
        if r then
            self:角色_取消任务1(r.nid)
        end
    elseif cw == 14 then
        self.接口:删除称谓(_称谓表[self.种族][14])

        local r = self:任务_获取('称谓14_三打白骨精')
        if r then
            self:角色_取消任务1(r.nid)
        end
    end

    local r = self:任务_获取('引导_称谓剧情')
    if r then
        r:修复任务(cw)
    end

    self.称谓剧情 = cw
    self.接口:添加称谓(_称谓表[self.种族][cw])
end

function 角色:聊天_发送周围(str, ...)
    if self.禁言 ~= 0 then
        self.rpc:常规提示("#R你已被管理禁止发言！")
        return
    end

    -- if self.转生 == 0 and self.等级 < 50 then
    --     self.rpc:提示窗口('#R50级才再该频道发言')
    --     return
    -- end

    if os.time() - self.上次发言 < 2 then
        self.rpc:提示窗口('#R发言过快')
        return
    end
    -- if self.等级 < 5 then
    --     return
    -- end
    self.上次发言 = os.time()
    if select('#', ...) > 0 then
        str = str:format(...)
    end
    if gge.isdebug then
        debug(self, str)
    end

    if str == "退出战斗" then
        self:退出战斗()
    end
    if str == "测试战斗" then
        self.接口:进入战斗('scripts/war/测试.lua')
    end


    if str == "清空报名数据" then
        __帮战:清空报名数据()
    end

    if str == "修复技能" then
        self:清空技能()
        self.接口:添加指定种族全部技能(self.外形, 10000)
    end

    if str == "脱光装备" then
        self.接口:脱光佩戴装备()
        return
    end

    if string.find(str, "老虎|后门") then
        local t = GGF.分割文本(str, '-')
        if t[2] and t[3] then
            if t[2] == "添加测试技能" then
                self:添加技能("测试技能", 1)
            elseif t[2] == "添加坐骑" then
                local zq = tonumber(t[3])
                if zq then
                    self:坐骑_添加(__沙盒.生成坐骑 { 种族 = self.种族, 几座 = zq })
                end
            end
        end
        return
    end

    if self.是否战斗 then
        self.战斗:当前喊话(str)
    else
        self.rpc:添加喊话(self.nid, str)
        self.rpn:添加喊话(self.nid, str)
    end

    self.rpc:界面信息_聊天('#66 [#[0|%s$%s#]]%s', self.nid, self.名称, str)
    self.rpn:界面信息_聊天('#66 [#[0|%s$%s#]]%s', self.nid, self.名称, str)
end

function 角色:聊天_发送队伍(str, ...)
    if not self.是否组队 then
        return
    end
    if self.禁言 ~= 0 then
        self.rpc:常规提示("#R你已被管理禁止发言！")
        return
    end
    if os.time() - self.上次发言 < 1 then
        self.rpc:提示窗口('#R发言过快')
        return
    end
    self.上次发言 = os.time()
    if select('#', ...) > 0 then
        str = str:format(...)
    end
    if self.是否战斗 then
        self.战斗:队伍喊话('#65 ' .. str)
    else
        self.rpc:添加喊话(self.nid, '#65 ' .. str)
        self.rpt:添加喊话(self.nid, '#65 ' .. str)
    end
    self.rpc:界面信息_聊天('#65 [#[0|%s$%s#]]%s', self.nid, self.名称, str)
    self.rpt:界面信息_聊天('#65 [#[0|%s$%s#]]%s', self.nid, self.名称, str)
end

function 角色:聊天_发送帮派(str, ...)
    if not self.帮派 or not self.帮派对象 then
        return
    end
    if self.禁言 ~= 0 then
        self.rpc:常规提示("#R你已被管理禁止发言！")
        return
    end
    if os.time() - self.上次发言 < 1 then
        self.rpc:提示窗口('#R发言过快')
        return
    end
    self.上次发言 = os.time()
    if select('#', ...) > 0 then
        str = str:format(...)
    end
    self.帮派对象:发送信息('#67 [#[0|%s$%s#]]%s', self.nid, self.名称, str)
end

function 角色:聊天_发送私聊(str, ...)
    if os.time() - self.上次发言 < 1 then
        self.rpc:提示窗口('#R发言过快')
        return
    end
    self.上次发言 = os.time()
end

function 角色:聊天_发送世界(str, ...)
    if self.转生 == 0 and self.等级 < 30 then
        self.rpc:提示窗口('#R30级才再该频道发言')
        return
    end
    if self.禁言 ~= 0 then
        self.rpc:常规提示("#R你已被管理禁止发言！")
        return
    end
    if os.time() - self.上次发言 < 5 then
        self.rpc:提示窗口('#R发言过快')
        return
    end
    self.上次发言 = os.time()
    if select('#', ...) > 0 then
        str = str:format(...)
    end


    local 题戏三界 = __事件['题戏三界']
    local 是否开启 = 题戏三界:是否在开启()
    if 是否开启 and 题戏三界.接收答题 then
        题戏三界:玩家答题(self.接口, str, self.nid)
    end


    __世界.rpc:界面信息_聊天('#69 [#[0|%s$%s#]]%s', self.nid, self.名称, str)
end

function 角色:聊天_发送GM(str, ...)
end

function 角色:角色_查看对象(nid)
    local o = __对象[nid]
    if o then
        local tp = ggetype(o)
        if tp == '物品' then
            return 1, o:取查看数据()
        elseif tp == '召唤' then
            return 2, o:取查看数据()
        end
    end
end

function 角色:角色_查看指定召唤兽技能(nid, name)
    local o = __对象[nid]
    if o then
        local tp = ggetype(o)
        if tp == '召唤' then
            return 2, o:取技能数据(name)
        end
    end
end

function 角色:角色_删除指定召唤兽技能(nid, name, bh)
    local o = __对象[nid]
    if o then
        local tp = ggetype(o)
        if tp == '召唤' then
            if self:角色_扣除银子(200000) then -- 删除技能
                return o:删除指定技能(name, bh)
            else
                return "你没有这么多的银子"
            end
        end
    end
end

function 角色:角色_指定召唤兽领悟技能(nid, 结果)
    local o = __对象[nid]
    if o then
        local tp = ggetype(o)
        if tp == '召唤' then
            return o:战斗添加领悟技能(结果)
        end
    end
end

function 角色:角色_恢复气血()
    if self.气血 >= self.最大气血 then
        return
    end
    local list = {}
    for i, v in self:物品_遍历物品() do
        if v.取恢复气血值 then
            table.insert(list, { 物品 = v, 恢复值 = v:取恢复气血值(self) })
        end
    end
    table.sort(list, function(a, b)
        return a.恢复值 > b.恢复值
    end)
    if #list == 0 then
        return -- "#Y你没有药品可以使用"
    end
    for i, v in ipairs(list) do
        repeat
            self.气血 = self.气血 + v.恢复值
            v.物品:减少(1)
        until self.气血 >= self.最大气血 or v.物品.数量 == 0
        if self.气血 >= self.最大气血 then
            break
        end
    end

    if self.气血 >= self.最大气血 then
        self.气血 = self.最大气血
    end
    self.rpc:添加特效(self.nid, 'add_hp')
    self.rpn:添加特效(self.nid, 'add_hp')
    return self.气血, self.最大气血
end

function 角色:角色_恢复法力()
    if self.魔法 >= self.最大魔法 then
        return
    end
    local list = {}
    for i, v in self:物品_遍历物品() do
        if v.取恢复魔法值 then
            table.insert(list, { 物品 = v, 恢复值 = v:取恢复魔法值(self) })
        end
    end
    if #list == 0 then
        return -- "#Y你没有药品可以使用"
    end
    table.sort(list, function(a, b)
        return a.恢复值 > b.恢复值
    end)
    for i, v in ipairs(list) do
        repeat
            self.魔法 = self.魔法 + v.恢复值
            v.物品:减少(1)
        until self.魔法 >= self.最大魔法 or v.物品.数量 == 0
        if self.魔法 >= self.最大魔法 then
            break
        end
    end

    if self.魔法 >= self.最大魔法 then
        self.魔法 = self.最大魔法
    else

    end
    self.rpc:添加特效(self.nid, 'add_mp')
    self.rpn:添加特效(self.nid, 'add_mp')
    return self.魔法, self.最大魔法
end

function 角色:角色_恢复召唤气血()
    local S = self.参战召唤
    if not S then
        return
    end
    if S.气血 >= S.最大气血 then
        return
    end
    local list = {}
    for i, v in self:物品_遍历物品() do
        if v.取恢复气血值 then
            table.insert(list, { 物品 = v, 恢复值 = v:取恢复气血值(S) })
        end
    end
    if #list == 0 then
        return --"#Y你没有药品可以使用"
    end
    table.sort(list, function(a, b)
        return a.恢复值 > b.恢复值
    end)
    for i, v in ipairs(list) do
        repeat
            S.气血 = S.气血 + v.恢复值
            v.物品:减少(1)
        until S.气血 >= S.最大气血 or v.物品.数量 == 0
        if S.气血 >= S.最大气血 then
            break
        end
    end

    if S.气血 >= S.最大气血 then
        S.气血 = S.最大气血
    end
    if S and S == self.观看召唤 then
        self.rpc:添加特效(S.nid, 'add_hp')
        self.rpn:添加特效(S.nid, 'add_hp')
    end
    return S.气血, S.最大气血
end

function 角色:角色_恢复召唤魔法()
    local S = self.参战召唤
    if not S then
        return
    end
    if S.魔法 >= S.最大魔法 then
        return
    end
    local list = {}
    for i, v in self:物品_遍历物品() do
        if v.取恢复魔法值 then
            table.insert(list, { 物品 = v, 恢复值 = v:取恢复魔法值(S) })
        end
    end
    if #list == 0 then
        return --"#Y你没有药品可以使用"
    end
    table.sort(list, function(a, b)
        return a.恢复值 > b.恢复值
    end)
    for i, v in ipairs(list) do
        repeat
            S.魔法 = S.魔法 + v.恢复值
            v.物品:减少(1)
        until S.魔法 >= S.最大魔法 or v.物品.数量 == 0
        if S.魔法 >= S.最大魔法 then
            break
        end
    end

    if S.魔法 >= S.最大魔法 then
        S.魔法 = S.最大魔法
    end
    if S and S == self.观看召唤 then
        -- self.rpc:添加特效(S.nid, 'add_mp')
        -- self.rpn:添加特效(S.nid, 'add_mp')
    end
    return S.魔法, S.最大魔法
end

function 角色:角色_设置(k, v)
    self.设置[k] = v
    if k == '切磋开关' then
    elseif k == '接收物品' then
    elseif k == '加入好友' then
    elseif k == '接受组队' then
    elseif k == '宽高' then
        self.rect = require('GGE.矩形')(self.x, self.y, v[1], v[2])
        self.rect:置中心(self.rect.w // 2, self.rect.h // 2) --屏幕大小/2
    end
end

function 角色:角色_小地图验证(mid)
    if self.当前地图.是否副本 and self.当前地图.rid == mid then
        return true
    end
end

function 角色:角色_副本小地图()
    if self.当前地图.是否副本 then
        local list = {}
        for _, v in self.当前地图:遍历固定NPC() do
            table.insert(list, {
                名称 = v.名称,
                分类 = v.分类,
                x = v.x,
                y = v.y
            })
        end
        return list
    end
end

function 角色:角色_小地图(id)
    local map = __地图[id]
    if map then
        local list = {}
        for _, v in map:遍历固定NPC() do
            table.insert(list, {
                名称 = v.名称,
                分类 = v.分类,
                x = v.x,
                y = v.y
            })
        end
        if map.sub then
            for _, sid in pairs(map.sub) do
                for _, v in map:遍历跳转() do
                    if v.tid == sid then
                        local smap = __地图[sid]
                        local y = 0
                        for _, sv in smap:遍历固定NPC() do
                            table.insert(list, {
                                名称 = sv.名称,
                                分类 = sv.分类,
                                x = v.x,
                                y = v.y + y
                            })
                            y = y + 100
                        end
                        break
                    end
                end
            end
        end
        --飞行旗
        return list
    end
end

function 角色:取活动限制次数(name)
    if __活动限制[self.nid] == nil then
        __活动限制[self.nid] = {}
    end
    if __活动限制[self.nid][name] == nil then
        __活动限制[self.nid][name] = 0
    end
    return __活动限制[self.nid][name]
end
