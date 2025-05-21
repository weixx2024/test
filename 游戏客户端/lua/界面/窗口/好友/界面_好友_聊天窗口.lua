

local 好友聊天窗口 = 窗口层:创建我的窗口('好友聊天窗口', 0, 0, 347, 323)
function 好友聊天窗口:初始化()
    self:置精灵(__res:getspr('gires/0x6DDB44B2.tcp'))
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
    self.记录 = {


    }
end

function 好友聊天窗口:显示(x, y)
end

好友聊天窗口:创建关闭按钮(0, 1)
--=============================================================
local 名称文本 = 好友聊天窗口:创建我的文本('名称文本', 75, 41, 225, 15)
--名称文本:置文本('对方名称')
local 时间文本 = 好友聊天窗口:创建我的文本('时间文本', 75, 71, 225, 15)
--时间文本:置文本(os.date('%Y-%m-%d %X', os.time()))
local 内容文本 = 好友聊天窗口:创建我的文本('内容文本', 30, 123, 268, 142)
--内容文本:置文本('#24厅可呵可呆厅可呵可呆厅可呵可呆厅可呵#R可呆厅可呵可呆#G厅可呵可呆厅可呵可呆厅可呵可呆#G')

--==============================================================
local 回复按钮 = 好友聊天窗口:创建中按钮('回复按钮', 27, 282, '回  复', 85)
function 回复按钮:左键弹起()
    if _P then
        窗口层:打开回复窗口(_P)
    end

end

local 加为好友按钮 = 好友聊天窗口:创建中按钮('加为好友按钮', 220, 282, '加为好友', 85)
function 加为好友按钮:左键弹起()
    if _P then
        coroutine.xpcall(function()
            local r = __rpc:角色_添加好友(_P.nid)
        end)
    end


end

local 搜索按钮 = 好友聊天窗口:创建按钮('搜索按钮', 302, 37)

function 搜索按钮:初始化()
    self:设置按钮精灵('gires/0x391694AB.tcp')
end

function 搜索按钮:左键弹起()
    if _P then
        窗口层:打开好友属性(_P)
    end
end

function 好友聊天窗口:刷新信息(t)
    名称文本:置文本(t.名称)
    if not self.记录[t.nid] then
        self.记录[t.nid] = {}
    end
    时间文本:置文本("")
    内容文本:置文本("")
    _P = t
    self.curid = t.nid
    local r = __rpc:角色_获取指定消息(t.nid)
    if type(r) == "table" then
        table.insert(self.记录[t.nid], 1, { time = r.time, txt = r.txt })
        if _P then
            窗口层:好友_添加聊天记录(_P.名称,t.nid, { time = r.time, txt = r.txt })
        end
    end
    local xx = self.记录[t.nid][1]
    if xx then
        时间文本:置文本(os.date('%Y-%m-%d %X', xx.time))
        内容文本:置文本(xx.txt)
    end
end

function 好友聊天窗口:刷新信息2(nid)
    if not self.记录[nid] then
        self.记录[nid] = {}
    end
    时间文本:置文本("")
    内容文本:置文本("")
    self.curid = nid
    local r = __rpc:角色_获取指定消息(nid)
    if type(r) == "table" then
        table.insert(self.记录[nid], 1, { time = r.time, txt = r.txt })
        if _P then
            窗口层:好友_添加聊天记录(_P.名称,nid, { time = r.time, txt = r.txt })
        end

    end
    local xx = self.记录[nid][1]
    if xx then
        时间文本:置文本(os.date('%Y-%m-%d %X', xx.time))
        内容文本:置文本(xx.txt)
    end
end

function 窗口层:好友_刷新信息2(nid)
    好友聊天窗口:刷新信息2(nid)
end

function 窗口层:打开聊天窗口(t, 列表)
    if 列表 and 好友聊天窗口.是否可见 then
        好友聊天窗口:刷新信息(t)
        return
    end
    好友聊天窗口:置可见(not 好友聊天窗口.是否可见)
    if not 好友聊天窗口.是否可见 then
        return
    end
    好友聊天窗口:刷新信息(t)
end

return 聊天窗口
