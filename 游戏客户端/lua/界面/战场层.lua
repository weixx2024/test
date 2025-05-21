local _战场反转 = false
local _是否观战 = false

function 战场层:初始化()
    self:置宽高(引擎.宽度, 引擎.高度)
end

local _排序函数 = function(a, b)
    return a:取排序点() < b:取排序点()
end

function 战场层:更新(dt, x, y)
    table.sort(self.list, _排序函数) --FIXME 移动再排？
    for i, v in ipairs(self.list) do
        v:更新(dt)
        if v.是否删除 and os.time() > v.是否删除 then
            self:删除对象(v.位置)
            break
        end
    end

    for i, v in ipairs(self.技能) do
        if v:更新(dt) then
            table.remove(self.技能, i)
            break
        end
    end
    if self.转场动画 and gge.platform == 'Windows' then
        self.转场动画 = self.转场动画:更新(dt)
    end
    if self.倒时精灵 then
        self.倒时精灵:更新(dt)
    end
end

function 战场层:显示(x, y)
    self.战斗背景:显示()
    --  hp:显示(0, 0)
    for _, v in ipairs(self.list) do
        v:显示()
    end

    for _, v in ipairs(self.技能) do
        v:显示(x, y)
    end

    for _, v in ipairs(self.list) do
        v:显示顶层()
    end
    self.回合精灵:显示()

    if not _是否观战 then
        self.怨怒精灵:显示(引擎.宽度2, 0)
        if self.倒时精灵 then
            self.倒时精灵:显示(引擎.宽度2, 30)
        end
    end

    if self.转场动画 and gge.platform == 'Windows' then
        self.转场动画:显示()
    end
end

function 战场层:置怨气(v)
    if self.怨怒精灵 then
        self.怨怒精灵:置怨气(v)
    end
end

local 自动按钮 = 战场层:创建小按钮('自动按钮', -50, -150, '自动')
function 自动按钮.左键弹起()
    窗口层:打开战斗自动(__rpc:角色_战斗自动(true))
end

-- local 助战按钮 = 战场层:创建小按钮('助战按钮', -50, -180, '助战')
-- function 助战按钮.左键弹起()
--     窗口层:打开助战()
-- end

local 退出按钮 = 战场层:创建小按钮('退出按钮', -50, -150, '退出')
function 退出按钮.左键弹起()
    __rpc:角色_退出观战()
    RPC:退出战斗()
end

---你整 2边玩家 对战，据说 这个duo

function 战场层:切换按钮()
    if _是否观战 then
        自动按钮:置可见(false)
        退出按钮:置可见(true)
    else
        自动按钮:置可见(true)
        退出按钮:置可见(false)
    end
end

function 战场层:加载(list, 位置, 回合数, 观战, 回合数据)
    _战场反转 = 位置 > 100
    _是否观战 = 观战 or false
    self:切换按钮()

    self.回合数 = 回合数 or 0
    self.回合精灵 = require('辅助/战斗_回合')(self.回合数)
    self.对象 = {}
    self.技能 = {}
    self.list = {}
    self.转场动画 = require('辅助/精灵_转场')()
    self.战斗背景 = require('辅助/战斗_背景')()
    self.倒时精灵 = require('辅助/战斗_倒时')(-1)
    self.怨怒精灵 = require('辅助/战斗_怨怒')()
    -- hp = require('GGE.坐标')(400, 300)

    local 坐标表 = require('战斗/位置')
    for i, v in pairs(list) do
        v.位置 = i

        if _战场反转 then
            v.战斗坐标 = 坐标表.反转坐标[i]:复制()
            v.方向 = i <= 100 and 1 or 3
            v.是否敌方 = i < 100
            v.是否己方 = i > 100
        else
            v.战斗坐标 = 坐标表.正常坐标[i]:复制()
            v.方向 = i <= 100 and 3 or 1
            v.是否敌方 = i > 100
            v.是否己方 = i < 100
        end

        v.x, v.y = v.战斗坐标:unpack()
        v.战斗方向 = v.方向

        local 战斗对象
        if v.是否孩子 then
            战斗对象 = require('战斗/孩子')(v)
        else
            战斗对象 = require('战斗/对象')(v)
        end

        if v.是否死亡 then
            战斗对象:置模型('die')
            战斗对象:置停止事件()
        end
        战斗对象:置操作(true)

        self.对象[i] = 战斗对象
    end

    self.rol = self.对象[位置]
    self.sum = self.对象[位置 + 5]
    self.玩家位置 = 位置
    self.召唤位置 = 位置 + 5
    self:刷新对象()

    if 回合数据 then
        RPC:播放战斗数据(回合数据)
    end
end

function 战场层:刷新对象()
    self.list = {}
    for _, v in pairs(self.对象) do
        table.insert(self.list, v)
    end
end

function 战场层:取对象(i)
    return self.对象[i]
end

function 战场层:添加对象(v)
    local i = v.位置
    local 坐标表 = require('战斗/位置')

    if _战场反转 then
        v.战斗坐标 = 坐标表.反转坐标[i]:复制()
        v.方向 = i <= 100 and 1 or 3
        v.是否敌方 = i < 100
        v.是否己方 = i > 100
    else
        v.战斗坐标 = 坐标表.正常坐标[i]:复制()
        v.方向 = i <= 100 and 3 or 1
        v.是否敌方 = i > 100
        v.是否己方 = i < 100
    end

    v.x, v.y = v.战斗坐标:unpack()
    v.战斗方向 = v.方向
    self.对象[i] = require('战斗/对象')(v)
    if i == self.召唤位置 then
        self.sum = self.对象[i]
        窗口层:提示窗口('#Y' .. v.名称 .. '#W加入战斗')
    end
    self:刷新对象()
end

function 战场层:删除对象(i)
    self.对象[i] = nil
    if i == self.召唤位置 then
        self.sum = nil
    end
    self:刷新对象()
end

function 战场层:添加技能(t)
    table.insert(self.技能, t)
    return t
end

function 战场层:取全屏位置(i)
    if i == 1 then
        return 235, 320
    elseif i == 2 then
        return 595, 345
    else
        -- return 引擎.宽度/2, 引擎.高度/2
        return 400, 300
    end
end

function 战场层:关闭窗口()
    窗口层.人物菜单:置可见(false)
    窗口层.召唤菜单:置可见(false)
    窗口层.法术界面:置可见(false)
    窗口层.道具:置可见(false)
    窗口层.召唤界面:置可见(false)
    鼠标层.附加 = nil
end

function 战场层:播放战斗(data)
    if self.倒时精灵 then
        self.倒时精灵:置数字(-1) ----todo 倒时精灵 nil
    end
    if self.对象 then
        战场层:关闭窗口()
        if type(data) == 'table' then
            for _, v in pairs(data) do
                if self.对象[v.位置] then
                    self.对象[v.位置]:播放战斗(v)
                    if not self.对象[v.位置] and v.位置 == self.rol.位置 then
                        break
                    end
                end
            end
            return true
        end
    end
end

function 战场层:消息事件(msg) --消息事件是协程
    for i, v in pairs(self.list) do
        if v.消息事件 then
            v:消息事件(msg, x, y)
        end
    end
end

--=======================================================

--=======================================================
function RPC:进入战斗(...)
    if 界面层.任务栏.目标 then
        界面层:左键弹起()
    end
    if __rol then
        __rol.是否战斗 = true
    end
    __res:进入战斗()
    窗口层:进入战斗()
    界面层:进入战斗()
    地图层:进入战斗()
    战场层:置可见(true, true)
    战场层:加载(...)
    __rpc:角色_战斗数据返回('进入战斗')
end

function RPC:退出战斗()
    if __rol then
        __rol.是否战斗 = false
    end

    战场层:关闭窗口()
    __res:退出战斗()
    界面层:退出战斗()
    地图层:退出战斗()
    战场层:置可见(false)
    collectgarbage()
end

function RPC:战斗菜单(时间, 召唤菜单)
    if 战场层.倒时精灵 then
        战场层.倒时精灵:置数字(时间)
        窗口层:打开人物菜单(召唤菜单)
    end
end

function RPC:人物菜单(时间, 召唤菜单,nid,怨气)
    if 战场层.倒时精灵 then
        if 时间 then
            战场层.倒时精灵:置数字(时间)
        end
        窗口层:打开人物菜单(召唤菜单,nid,怨气)
        __rpc:角色_战斗菜单回传()
    end
end

function RPC:召唤菜单(nid,fnid)
    窗口层:打开召唤菜单(nid,fnid)
    __rpc:角色_战斗菜单回传()
end


local _播放数据 = function(data, src)
    local co, tco = coroutine.running()
    coroutine.xpcall(
        function()
            tco = coroutine.running()
            战场层:播放战斗(data)
            __rpc:角色_战斗数据返回(src)
            coroutine.resume(co)
        end
    )
    if coroutine.status(tco) ~= 'dead' then
        coroutine.yield()
    end
end

function RPC:孩子喊话(data)
    local src = '孩子喊话'
    _播放数据(data, src)
end

function RPC:回合开始(data)
    local src = '回合开始'
    _播放数据(data, src)
end

function RPC:战斗数据(data)
    local src = '战斗数据'
    if 战场层.对象 then
        for k, v in pairs(战场层.对象) do
            v:置操作(false)
        end
        _播放数据(data, src)
        鼠标层:正常形状()
        战场层.回合数 = 战场层.回合数 + 1
        战场层.回合精灵 = require('辅助/战斗_回合')(战场层.回合数)
    else
        __rpc:角色_战斗数据返回(src)
    end
end

function RPC:播放战斗数据(data)
    local src = '战斗数据'
    _播放数据(data, src)
    鼠标层:正常形状()
end

function RPC:回合结束(data)
    local src = '回合结束'
    if 战场层.对象 then
        for k, v in pairs(战场层.对象) do
            v:置操作(true)
        end
        _播放数据(data, src)
    else
        __rpc:角色_战斗数据返回(src)
    end
end

function RPC:战斗自动(...)
    if 战场层.倒时精灵 then
        窗口层:打开战斗自动2(...)
    end
end

function RPC:战斗操作(i, v)
    if 战场层.对象 and 战场层.对象[i] then
        if 战场层.玩家位置 == i then
            战场层.倒时精灵:置数字(-1)
        end
        战场层.对象[i]:置操作(false)
        if 战场层.对象[i + 10] then
            战场层.对象[i + 10]:置操作(false)
        end
    end
end

function RPC:战斗喊话(i, v, time)
    local r = 战场层.对象[i]
    if r and v then
        r:添加喊话(v, time)
    end
end

function RPC:切换助战位置(位置)
    战场层.rol = 战场层.对象[位置]
    战场层.sum = 战场层.对象[位置 + 5]
    战场层.玩家位置 = 位置
    战场层.召唤位置 = 位置 + 5
end

function RPC:刷新怨气(v)
    战场层:置怨气(v)
end

return 战场层
