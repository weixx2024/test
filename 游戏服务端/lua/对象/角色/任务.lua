local 角色 = require('角色')

function 角色:任务_初始化()
    local 存档任务 = self.任务
    local _任务表 = {}

    self.任务 =
        setmetatable(
            {},
            {
                __newindex = function(t, k, v)
                    if v then
                        v.rid = self.id
                        v:更新来源(self.任务)
                        if v.获得时间 == 0 then
                            v.获得时间 = os.time()
                        end
                    else
                        local T = _任务表[k]
                        if T then
                            __垃圾[k] = T
                            __垃圾[k].rid = -1
                            if T.是否BUFF then
                                self.rpc:删除BUFF(k)
                            end
                        end
                    end
                    _任务表[k] = v
                    self.刷新的任务 = true
                end,
                __index = function(t, k)
                    return _任务表[k]
                end,
                __pairs = function(...)
                    return next, _任务表
                end
            }
        )

    if type(存档任务) == 'table' then
        for nid, v in pairs(存档任务) do
            if not __任务[nid] or __任务[nid].rid == v.rid then
                self.任务[nid] = require('对象/任务/任务')(v)
            end
        end
    end

    do -- task
        local kname
        local function task(_, ...)
            for i, v in pairs(self.任务) do

                local fun = v[kname]
                if type(fun) == 'function' then
                    local r = { coroutine.xpcall(fun, v.接口, ...) }
                    if r[1] ~= coroutine.FALSE and r[1] ~= nil then
                        return table.unpack(r)
                    end
                end
            end
        end

        self.task =
            setmetatable(
                {},
                {
                    __index = function(_, k)
                        kname = k
                        return task
                    end
                }
            )
    end
end

function 角色:任务_更新(sec)
    self.task:任务更新(sec, self.接口)
    if self.刷新的任务 then
        self.刷新的任务 = nil
        coroutine.xpcall(
            function()
                self.rpc:请求刷新任务列表()
                self.rpc:刷新任务追踪()
                --  lock = true
            end
        )
    end
    for i, v in pairs(self.任务) do
        if v.up then
            v.up = nil
            coroutine.xpcall(
                function()
                    v.最后操作时间 = os.time()
                    self.rpc:刷新任务追踪()
                end
            )
            if v.nid == self.窗口.任务 then
                coroutine.xpcall(
                    function()
                        self.rpc:刷新任务详情(v:取详情(self.接口))
                    end
                )
            end
            break
        end
    end
end

function 角色:遍历任务()
    return pairs(self.任务)
end

function 角色:任务_添加(T)
    if ggetype(T) == '任务接口' then
        T = T[0x4253]
    end
    if ggetype(T) == '任务' and not self:任务_获取(T.名称) then
        if T.来源 then
            T = T:镜像()
        end

        self.任务[T.nid] = T
        if T.是否BUFF then
            self.rpc:添加BUFF({ nid = T.nid, 名称 = T.名称, 图标 = T.图标 })
        end
        return T
    end
end

function 角色:任务_获取(名称)
    for _, v in self:遍历任务() do
        if v.名称 == 名称 then
            return v
        end
    end
end

function 角色:任务_取BUFF列表()
    local list = {}
    for _, v in self:遍历任务() do
        if v.是否BUFF then
            table.insert(
                list,
                {
                    nid = v.nid,
                    名称 = v.名称,
                    图标 = v.图标,
                    获得时间 = v.获得时间
                }
            )
        end
    end
    return list
end

function 角色:角色_打开任务窗口()
    local list = {}
    for k, v in self:遍历任务() do
        if not v.是否BUFF and not v.是否隐藏 then
            table.insert(
                list,
                {
                    nid = v.nid,
                    类型 = v.类型,
                    名称 = v.别名 or v.名称,
                    获得时间 = v.获得时间,
                    是否追踪 = v.是否追踪,
                    是否可取消 = v.是否可取消
                }
            )
        end
    end
    self.rpc:刷新任务追踪()
    return list
end

local _可接任务 = {
    ['夺镖任务'] = '#Y【夺镖任务】\n#W押运贪官镖银的车队正在路过#Y长安城东、大唐境内、五指山、大唐边境、长寿村外、傲来国#W，请各位有志之士火速前往，夺取镖银。\n\n',
    ['城东魅影'] = '#Y【斩妖除魔】\n#W大量成年的树妖，终于修道得到，羽化为木魁，前来作怪。请各位侠士前往#Y长安城东#W前去除妖。\n\n',
    ['盛世华夏'] = '#Y【盛世华夏】\n#W唐王梦里见千百年来倭寇不死贼心反复肆意侵扰。醒来，深感倭寇之心昭然若揭，需大举歼灭方能攘外安内以绝后患。于是下旨：倭寇犯境我#Y五指山、长安东、大唐边境#W。人人得以诛之，诛灭者必当重赏。\n\n',
    ['金玉满堂'] = '#Y【金玉满堂】\n#W晴娘出现在#Y五指山、北俱芦洲、傲来国、长寿村#W，想知道一会是晴天还是阴天的朋友不如赶紧去找晴娘请教请教。\n\n',
    ['天元盛典'] = '#Y【天元盛典】\n#W天庭举办天界盛典竟有妖怪混入，诸君可以三人及以上组队，速速前往#Y长安城东、五指山、大唐境内、长寿村外、北俱芦洲#W，寻找天庭的万仙方阵捉拿妖怪。\n\n',
    ['城东保卫战'] = '#Y【城东保卫战】\n#W日寇在#Y长安东#W向#Y长安城#W发起进攻，唐王下令全体军民誓死抵御来犯之敌#W犯我中华者虽远必诛！\n\n',
    ['地煞星'] = '#Y【挑战地煞星】\n#W天下太平，国泰民安！#G地煞星#W慕名下凡，现身于各地角落，想与各英雄豪杰一较高下，奖励丰厚，机不可失，大家有胆的就上呀。\n\n',
    ['天罡星'] = '#Y【挑战天罡星】\n#W天下太平，国泰民安！#G地煞星#W慕名下凡，现身于各地角落，想与各英雄豪杰一较高下，奖励丰厚，机不可失，大家有胆的就上呀。\n\n',
    ['天宫寻宝'] = '#Y【天宫寻宝】\n#W天地豪杰勇气令人称赞，为示嘉奖，玉帝特命#G天赎星君#W带路，引导群豪入天宫宝库恣意搜寻。现天宫宝库已经开放，请各路豪杰抓紧时间入库寻宝。\n\n',
    ['梨园庙会'] = '#Y【梨园庙会】\n#W暮春之时，万物生发。为祈祷风调雨顺古物丰收，慰劳我大唐辛勤的子民们，唐王授意举办这热闹的梨园庙会，特邀请我大唐子民前去庙会游玩，欣赏那世代相传的民间曲艺以及玩乐风俗。\n\n',
    ['万仙方阵'] = '#Y【万仙方阵】\n#W天庭举办天界盛典竟有妖怪混入，诸君可以三人及以上组队，速速前往#Y%s，#G寻找天庭的万仙方阵捉拿妖怪。\n\n',
    ['为爱逆天'] = '#Y【为爱逆天】\n#W奎木狼，水德星君，火德星君，天王李靖，诸君可以三人及以上组队，速速前往#Y%s。\n\n',
    ['天降祥瑞'] = '#Y【天降祥瑞】\n#W承平天下，为了庆祝这场盛世华诞，天上的祥瑞之神纷纷下落凡间，他们各自带着礼物无数，在#Y%s#G等待各路英雄前去挑战。\n\n',
    ['五灵同贺'] = '#Y【五灵同贺】\n#W麟凤五灵，王者之嘉瑞也。五灵，分别为：麒麟、凤凰、龟、龙、白虎。为贺盛世华诞，天庭特派五灵下凡，驻守人间不同角落等待英雄的挑战。\n\n',
    ['花灯报吉_灯灵'] = '#Y【花灯报吉_灯灵】\n#W王母娘娘让代表着祥和与安康的灯灵下凡人间为人们送去祝福，不料有些灯灵却被妖怪感化与妖怪一起祸害人间，各位侠士可组队前往#W%s#G这个六个地方寻找灯灵并降服。\n\n',
    ['花灯报吉_天官'] = '#Y【花灯报吉_天官】\n#W玉帝见诸位不辞劳苦，特派天官下凡来#W东海渔村、长安城东#G犒劳各位，只要能找到天官并通过考验就能成功得到丰厚奖励哦#97\n\n',
    ['混沌小妖'] = '#Y【混沌小妖】\n#W修罗之祸愈演愈烈，魑魅魍魉横行三界，常常神出鬼没，伏击路人。还需侠客义士出手相救，前往#G%s#R扶危济难。\n\n',
    ['齐力擎天'] = '#Y【齐力擎天】\n#W风云变色，人心鼓舞，天降珍奇，落在力挫穷奇。\n\n',
    ['千里婵娟'] = '#Y【千里婵娟】\n#W红拂女，狐美人，虎头怪，龙战将，燕山雪，剑侠客流落人间，还需侠客义士出手相救。\n\n',
    ['年年有余_灶神'] = '#Y【送灶神】#G原是灶神不满年关供奉，将金鲤王掳走。灶神现逃窜在#W长安城内#G，速将其捉拿，解救金鲤王!\n\n',
    ['年年有余_鲤鱼'] = '#Y五洲贺喜，四海皆福#47#C金鲤王自怀里掏出个#G#m(%s)[%s]#m#n塞到#R%s#C手里，神秘兮兮地说，嘘--我等正在密谋逃跑呢，一边玩去。\n\n',
    
}

local _可接任务次数 = {
    ['夺镖任务'] = 60,
    ['城东魅影'] = 60,
    ['盛世华夏'] = 60,
    ['金玉满堂'] = 60,
    ['天元盛典'] = 60,
    ['城东保卫战'] = 60,
    ['地煞星'] = 25,
    ['天罡星'] = 10,
    ['天宫寻宝'] = 10,
    ['梨园庙会'] = 60,
    ['万仙方阵'] = 60,
    ['为爱逆天'] = 1,
    ['天降祥瑞'] = 60,
    ['五灵同贺'] = 1,
    ['花灯报吉_灯灵'] = 60,
    ['花灯报吉_天官'] = 10,
    ['混沌小妖'] = 60,
    ['年年有余_灶神'] = 60,
    ['年年有余_鲤鱼'] = 60,
    ['齐力擎天'] = 1,
    ['千里婵娟'] = 1,
}

function 角色:角色_获取任务详情(nid)
    -- 兼容可接任务
    if type(_可接任务[nid]) == 'string' then
        return _可接任务[nid] .. '次数：' .. self.接口:取活动限制次数(nid) .. ' / ' .. _可接任务次数[nid]
    end

    local r = self.任务[nid]
    if r then
        self.窗口.任务 = nid
        return r:取详情(self.接口)
    end
    return '任务不存在'
end

function 角色:角色_取消任务(nid)
    local T = self.任务[nid]
    if T and T.是否可取消 ~= false then
        if T.任务取消 then
            T:任务取消(self.接口)
        end
        self.任务[nid] = nil
        return true
    end
end

function 角色:角色_取消任务1(nid)
    local T = self.任务[nid]
    if T then
        if T.任务取消 then
            T:任务取消(self.接口)
        end
        self.任务[nid] = nil
        return true
    end
end

function 角色:角色_获取可接任务()
    local list = {}
    for k, v in pairs(__事件) do
        if v._是否开始 and v.是否可接任务 then
            table.insert(
                list,
                {
                    nid = v.名称,
                    类型 = v.类型,
                    名称 = v.别名 or v.名称,
                    获得时间 = os.time(),
                    是否追踪 = false,
                    是否可取消 = false
                }
            )
        end
    end
    return list
end

function 角色:角色_获取可接任务详情(nid)
    local r = self.任务[nid]
    if r then
        self.窗口.任务 = nid
        return r:取详情(self.接口)
    end
    return '任务不存在'
end

function 角色:角色_设置任务追踪(nid, v)
    local r = self.任务[nid]
    if r then
        r.是否追踪 = v == true
        return true
    end
end

function 角色:角色_获取任务追踪列表()
    local list = {}
    for k, v in self:遍历任务() do
        if not v.是否BUFF and not v.是否隐藏 and v.是否追踪 then
            local 详情
            local r = self.任务[v.nid]
            if r then
                详情 = r:取详情(self.接口)
            end
            table.insert(
                list,
                {
                    nid = v.nid,
                    名称 = v.别名 or v.名称,
                    是否追踪 = v.是否追踪,
                    获得时间 = v.最后操作时间 or v.获得时间,
                    详情 = 详情
                }
            )
        end
    end

    -- table.sort(list, function(a, b)
    --     return a.获得时间 > b.获得时间
    -- end)

    return list
end
