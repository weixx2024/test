local GGF = require('GGE.函数')
local GUI = require '界面'
local CLT, RPC = require('GOL.RPCClient')(true)
GUI.RPC = RPC
GUI.CLT = CLT

function CLT:开始连接(回调)
    if self:取状态() == '已经启动' then
        self:断开()
    end

    -- local dlg = GUI.登录层:打开信息('#K正在连接服务器#b...')
    self:连接(self.地址, self.端口, true)

    local 失败次数 = 0
    self._定时 = 引擎:定时(
        100,
        function(time)
            if self:取状态() == '已经启动' then
                coroutine.xpcall(
                    function()
                        if self:确认版本(self.版本) then
                            if 回调 then
                                回调()
                            end
                            -- dlg:置可见(false)
                        else
                            引擎:消息框('', 'R请更新游戏。')
                            -- GUI.登录层:打开信息('#R请更新游戏。')
                        end
                    end
                )
                return 0
            elseif self:取状态() == '已经停止' then
                失败次数 = 失败次数 + 1
                if 失败次数 > 3 then
                    -- if 引擎.是否隐藏 then
                        if 引擎:消息框('', '获取服务器列表失败！') then
                            引擎:关闭()
                        end
                    -- else
                    --     dlg:置可见(false)
                    --     GUI.登录层:打开提示('#R连接服务器失败。')
                    -- end

                    return 0
                end
                self:连接(self.地址, self.端口, true)
                return time
            end
            return time
        end
    )
end

function CLT:确认版本(ver)
    return CLT:验证(ver)
end

function CLT:连接事件()
    
end

function CLT:断开事件(so, ec)
    if so == '关闭' then
        self._定时 = 引擎:定时(
            1,
            function()
                RPC:退出战斗()
                引擎:关闭()
                -- GUI.窗口层:置可见(false)
                -- GUI.界面层:置可见(false)
                -- GUI.地图层:置可见(false)
                -- GUI.登录层:置可见(false)
                -- GUI.登录层:切换界面(GUI.登录层.游戏开始)
                -- __rol = nil
                -- __map = nil
                -- __res:登录音乐()
                -- collectgarbage()
                -- 引擎:置宽高(640, 480)
            end
        )
    end
end


--=======================================================
--接收函数
--=======================================================

function RPC:顶号提示()
    引擎.信息事件 = function()
        引擎:消息框('提示', "你的角色在其它设备登录！")
        self._定时 = 引擎:定时(
            1,
            function()
                RPC:退出战斗()
                GUI.窗口层:置可见(false)
                GUI.界面层:置可见(false)
                GUI.地图层:置可见(false)
                GUI.登录层:置可见(true)
                GUI.登录层:切换界面(GUI.登录层.游戏开始)
                __rol = nil
                __map = nil
                __res:登录音乐()
                collectgarbage()
                引擎:置宽高(640, 480)
            end
        )
    end
end

function RPC:踢出游戏()
    引擎.信息事件 = function()
        引擎:消息框('提示', "断开链接！")
        self._定时 = 引擎:定时(
            1,
            function()
                RPC:退出战斗()
                引擎:关闭()
                -- GUI.窗口层:置可见(false)
                -- GUI.界面层:置可见(false)
                -- GUI.地图层:置可见(false)
                -- GUI.登录层:置可见(true)
                -- GUI.登录层:切换界面(GUI.登录层.游戏开始)
                -- __rol = nil
                -- __map = nil
                -- __res:登录音乐()
                -- collectgarbage()
                -- 引擎:置宽高(640, 480)
            end
        )
    end
end

function RPC:打开窗口(name, ...)
    if name == "召唤兽寄存" then
        GUI.窗口层:打开召唤兽寄存()
    elseif name == "取款" or name == "存款" then
        GUI.窗口层:打开取款(name)
    elseif name == "合成炼妖石" then
        GUI.窗口层:打开炼妖石合成(...)
    elseif name == "变身卡商店" then
        GUI.窗口层:打开变身卡商店(...)
    elseif name == "宝石合成" then --OK
        GUI.窗口层:打开宝石合成(...)
    elseif name == "宝石鉴定" then
        GUI.窗口层:打开宝石鉴定(...)
    elseif name == "宝石摘除" then
        GUI.窗口层:打开宝石摘除(...)
    elseif name == "宝石重铸" then
        GUI.窗口层:打开宝石重铸(...)
    elseif name == "装备镶嵌" then
        GUI.窗口层:打开装备镶嵌窗口(...)    
    elseif name == "装备镶嵌高级" then
        GUI.窗口层:打开装备镶嵌高级窗口(...)    
    elseif name == "神兵兑换" then
        GUI.窗口层:打开神兵预览()
    elseif name == "供奉香火" then
        GUI.窗口层:打开香火窗口(...)   
    elseif name == "还愿" then
        GUI.窗口层:打开还愿窗口(...)       
    elseif name == "物品兑换" then
        GUI.窗口层:打开物品兑换(...)   
    end
end

function RPC:自动任务_数据(v)
    __自动任务:设置任务(v)
end

function RPC:自动任务_战斗结束(v)
    __自动任务:战斗结束(v)
end

function RPC:切换地图(id, x, y)
    local co = coroutine.running()
    引擎.切换地图回调 = function()
        __rol:置坐标(x, y)

        GUI.地图层:切换地图(id)
        GUI.界面层:置坐标(x, y)

        __rpc:角色_完成跳转()
        -- collectgarbage()
        coroutine.resume(co)
    end
    coroutine.yield()
end

-- function RPC:界面音效(v)
--     __res:界面音效(v)
-- end

--=======================================================
--地图对象
--=======================================================
function RPC:移动开始(nid, x, y, 模式)
    local r = __map:取对象(nid)
    if r and x and y then
        r:开始移动(require('GGE.坐标')(x, y), 模式)
    end
end

function RPC:移动更新(nid, x, y, v)
    local r = __map:取对象(nid)
    if r and x and y then
    end
end

function RPC:移动结束(nid, x, y)
    local r = __map:取对象(nid)
    if r and x and y then
        r:停止移动()
    end
end

function RPC:宠物移动(nid, x, y)
    local r = __map:取对象(nid)
    if r and x and y then
        r:开始移动(require('GGE.坐标')(x, y))
    end
end

function RPC:召唤移动(nid, x, y)
    local r = __map:取对象(nid)
    if r and x and y then
        r:开始移动(require('GGE.坐标')(x, y))
    end
end

function RPC:NPC移动(nid, x, y, 模式)
    local r = __map:取对象(nid)
    if r and x and y then
        r:开始移动(require('GGE.坐标')(x, y), 模式)
    end
end

function RPC:NPC停止移动(nid, x, y)
    local r = __map:取对象(nid)
    if r and x and y then
        r:开始移动(require('GGE.坐标')(x, y))
    end
end

function RPC:切换方向(nid, v)
    local r = __map:取对象(nid)
    if r and v then
        r:置方向(v)
    end
end

-- function RPC:切换动作(nid, v)
--     local r = __map:取对象(nid)
--     if r and v then
--         r:置模型(v)
--     end
-- end

-- function RPC:切换武器(nid, 武器, 外形)
--     local r = __map:取对象(nid)
--     if r and 武器 and 外形 then
--         r:置外形(外形)
--         r:置武器(武器)
--     end
-- end

function RPC:切换外形(nid, 外形)
    local r = __map:取对象(nid)
    if r and 外形 then
        r:置外形(外形)
    end
end

function RPC:切换名称(nid, 名称, 颜色)
    local r = __map:取对象(nid)
    if r then
        r:置名称(名称)
    end
end

function RPC:切换名称颜色(nid, 颜色)
    local r = __map:取对象(nid)
    if r then
        r:置名称颜色(颜色)
    end
end

function RPC:切换称谓(nid, 称谓)
    local r = __map:取对象(nid)
    if r then
        r:置称谓(称谓)
    end
end

function RPC:置摆摊(nid, 摊名, 收购)
    local r = __map:取对象(nid)
    if r then
        r:置摆摊(摊名, 收购)
    end
end

function RPC:添加特效(nid, v)
    local r = __map:取对象(nid)
    if r and v then
        r:添加特效(v)
    end
end

function RPC:添加喊话(nid, v)
    local r = __map:取对象(nid)
    if r and v then
        r:添加喊话(v)
    end
end

function RPC:添加状态(nid, k)
    local r = __map:取对象(nid)
    if r and k then
        if k == 'leader' then
            r:置队长(true)
        elseif k == 'trues' then
            r:置战斗(true)
        elseif k == 'ltrues' then
            r:置观战(true)
        elseif k == 'store' then
            --r:置摆摊(true)
        else
            r:置状态(k, true)
        end
    end
end

function RPC:删除状态(nid, k)
    local r = __map:取对象(nid)
    if r and k then
        if k == 'leader' then
            r:置队长(false)
        elseif k == 'falses' then
            r:置战斗(false)
        elseif k == 'lfalses' then
            r:置观战(false)
        elseif k == 'store' then
            r:置摆摊(false)
        else
            r:置状态(k, false)
        end
    end
end

function RPC:置队友(nid, v)
    local r = __map:取对象(nid)
    if r then
        r:置队友(v)
    end
end

-- =======================================================
-- 地图
-- =======================================================
function RPC:地图添加(t)
    if type(t) == 'table' and t.nid then
        -- print('地图添加', t.type, t.名称, t.外形)
        if t.type == 'npc' then
            __map:添加(require('对象/NPC')(t))
        elseif t.type == 'jump' then
            __map:添加(require('对象/跳转')(t))
        elseif t.type == '明雷' then
            __map:添加(require('对象/怪物')(t))
        elseif t.type == 'good' then
            __map:添加(require('对象/物品')(t))
        elseif t.type == 'play' then
            if t.nid == __rol.nid then
                __rol.队长 = t.队长
                __rol.队伍位置 = t.队伍位置
                __map:添加(__rol)
            else
                __map:添加(require('对象/玩家')(t))
            end
        elseif t.type == 'sum' then
            __map:添加(require('对象/召唤')(t))
        elseif t.type == 'pet' then
            __map:添加(require('对象/宠物')(t))
        end
    end
end

function RPC:地图删除(nid)
    if type(nid) == 'string' then
        __map:删除(nid)
    end
end

function RPC:地图对象开关神行符(nid, flag)
    if type(nid) == 'string' then
        __map:对象开关神行符(nid, flag)
    end
end

function RPC:设置关倒时(g, n)
    GUI.资源层:置倒时(g, n)
end

-- =======================================================
-- 帮战
-- =======================================================
function RPC:修改动作(nid, 动作)
    if type(nid) == 'string' then
        __map:修改动作(nid, 动作)
    end
end

function RPC:点亮冰塔(nid, r)
    if type(nid) == 'string' then
        return __map:点亮冰塔(nid, r)
    end
end

function RPC:点亮火塔(nid, r)
    if type(nid) == 'string' then
        return __map:点亮火塔(nid, r)
    end
end

function RPC:冻结玩家(nid, b)
    if type(nid) == 'string' then
        local r = __map:取对象(nid)
        if r then
            r:置底部状态('冰冻', b)
        end
        if nid == __rol.nid then
            __rol.冰冻 = b
        end
    end
end

function RPC:设置禁止移动(r)
    __rol.是否定身 = r
end

--=======================================================
--生成固定不用返回的函数
--=======================================================
CLT.角色_移动开始 = CLT.角色_移动开始
CLT.角色_移动更新 = CLT.角色_移动更新
CLT.角色_移动结束 = CLT.角色_移动结束
CLT.角色_完成跳转 = CLT.角色_完成跳转

--人物
CLT.角色_技能使用 = CLT.角色_技能使用

CLT.角色_自动任务_天庭自动 = CLT.角色_自动任务_天庭自动
CLT.角色_发送好友信息 = CLT.角色_发送好友信息

CLT.战斗_进入战场 = CLT.战斗_进入战场
CLT.角色_战斗_召唤指令 = CLT.角色_战斗_召唤指令
CLT.角色_战斗_人物指令 = CLT.角色_战斗_人物指令
CLT.角色_战斗_播放完成 = CLT.角色_战斗_播放完成
CLT.角色_解交易锁 = CLT.角色_解交易锁

CLT.角色_战斗数据返回 = CLT.角色_战斗数据返回
CLT.角色_战斗操作返回 = CLT.角色_战斗操作返回
CLT.角色_播放动作返回 = CLT.角色_播放动作返回
--队伍

CLT.检测 = CLT.检测
return CLT
