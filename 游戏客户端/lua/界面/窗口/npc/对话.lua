local 对话 = 窗口层:创建我的窗口('对话', 0, 0, 534, 768)
local _yz

do
    function 对话:消息结束()
        return true --模态
    end

    function 对话:检查透明(x, y)
        return self.头像控件:检查透明(x, y) or self.窗体控件:检查透明(x, y)
    end

    function 对话:左键弹起(x, y)
        if not 对话.是否有选项 then
            self:置可见(false)
            if 对话.是否结束 == false then
                对话.是否结束 = nil
                _发送对话()
            end
        end
        if 对话.剧情 == 10086 then
            对话.剧情 = nil
            _解析('闯荡三界可不是一件容易的事情#83，听说游侠盟最近一直招纳三界英豪，请少侠先加入游侠盟，结交更多的伙伴，一起勇闯江湖！#110')
        end
    end

    function 对话:右键弹起(x, y)
        self:左键弹起(x, y)
        __res:界面音效('sound/addon/close.wav')
    end
end



local 头像 = 对话:创建控件('头像控件', 0, 0, 534, 350)
do
    function 头像:置头像(id)
        if id and id ~= 0 then
            local spr = __res:getspr('photo/npc/%04d.tga', id)
            if not spr then
                spr = __res:getspr('photo/hero/%d.tga', id)
            end
            if spr then
                spr:置中心(0, spr.高度 - 350)
                self:置精灵(spr)
            else
                self:置精灵(nil)
            end
        else
            self:置精灵(nil)
        end
    end

    function 头像:鼠标消息()
        return false
    end
end

local 窗体 = 对话:创建控件('窗体控件', 0, 350, 534, 143)
do
    function 窗体:初始化()
        self:置精灵(__res:getspr('gires2/dialog/npcchat.tcp'))
    end

    function 窗体:鼠标消息()
        return false
    end

    function 窗体:置文本(t)
        local w, h = 窗体.文本:置文本(t)

        窗体.列表:置坐标(10, h + 10)
        窗体.列表:清空() --清空按钮
        return h
    end

    local 文本 = 窗体:创建我的文本('文本', 10, 10, 500, 100)

    local 列表 = 窗体:创建多列列表('列表', 0, 0, 500, 500)
    列表.行高度 = 18
    列表.选中精灵 = nil
    列表.焦点精灵 = nil
    列表:添加列(0, 1, 275, 28)
    列表:添加列(275, 1, 275, 28)

    function 列表:鼠标消息()
        return false
    end
end
对话:创建关闭按钮(0, 350)
--=================================================================
local function sign()
    local bbkk = os.time()
    local lala = (bbkk + 9527) // 4
    return lala
end

local zhh = {
    "dv", "sa", "dfs", "gfd", "hgf", "fd", "dfs", "dfdd", "fds", "fds", "fds", "ed",


}

function _发送对话()
    对话:置可见(false)
    local 台词, 外形, 结束 = __rpc:角色_NPC对话(对话.nid)
    对话.是否结束 = 结束
    if type(台词) == 'string' then
        对话:置可见(true)
        _解析(台词)
        if 外形 then
            头像:置头像(外形)
        end
    end
end

function _发送选项(opt)
    对话:置可见(false)
    local bazahei = sign()
    local 台词, 外形, 结束 = __rpc:角色_NPC菜单(对话.nid, opt) --, 对话.yz
    对话.是否结束 = 结束
    if type(台词) == 'string' then
        对话:置可见(true)
        _解析(台词)
        if 外形 then
            头像:置头像(外形)
        end
    end
end

function _被动菜单(台词, 头像, 结束)
    对话:置可见(false)
    对话.是否结束 = 结束
    if type(台词) == 'string' then
        对话:置可见(true)
        _解析(台词)
        if 外形 then
            头像:置头像(外形)
        end
    end
end

function _添加按钮(控件, flag, txt)
    txt = txt == '' and flag or txt

    local 按钮 = 控件:创建NPC文字按钮('按钮', 0, 0, txt)

    function 按钮.左键弹起()
        if 对话.co then
            对话:置可见(false)
            coroutine.resume(对话.co, flag)
        else
            _发送选项(flag)
        end
    end

    按钮:置可见(true)
end

function _解析(t)
    对话.是否有选项 = false
    if t:find('\n?menu\n') ~= nil then
        local a, b = t:match('(.*)\n?menu\n(.*)') --(所有)\n存在menu\n(所有)

        local h = 窗体:置文本(a:gsub('\n', '#r'))

        local menu = GGF.split(b, '\n')
        对话.是否有选项 = #menu > 0
        local zg = #menu * 18 + 20 + h

        if zg > 143 then
            窗体:置精灵(窗体:取拉伸精灵_高度('gires2/dialog/npcchat.tcp', zg), true)
        else
            窗体:置精灵(窗体:取拉伸精灵_高度('gires2/dialog/npcchat.tcp', 143), true)
        end

        if b then
            for i, v in ipairs(menu) do
                if v ~= '' then
                    local 左, 右 = v:match('([^%s]+)%s*(.*)') --(非空格)空格*(所有)
                    local 行 = 窗体.列表:添加()
                    _添加按钮(行[1], 左:match('([^|]+)|?(.*)')) --(非|)|存在(所有)
                    if 右 ~= '' then
                        _添加按钮(行[2], 右:match('([^|]+)|?(.*)')) --(非|)|存在(所有)
                    end
                end
            end
        end
    else
        窗体:置文本(t)
        窗体:置精灵(窗体:取拉伸精灵_高度('gires2/dialog/npcchat.tcp', 143), true)
    end
end

--=================================================================
function 窗口层:关闭对话()
    if 对话.是否可见 then
        对话:置可见(false)
    end
end

function 窗口层:发送选项(flag)
    _发送选项(flag)
end

function 窗口层:打开对话(nid, 外形)
    对话.co = nil
    local 台词, _外形, 结束, yz, 对话消失 = __rpc:角色_NPC对话(nid)
    对话.默认外形 = 外形
    对话.是否结束 = 结束
    对话.yz = yz
    对话.对话消失 = 对话消失
    if type(台词) == 'string' then
        对话:置可见(true)
        头像:置头像(_外形 ~= 0 and _外形 or 外形)
        对话:置坐标((引擎.宽度 - 对话.宽度) // 2, (引擎.高度 - 对话.高度 - 100) // 2)

        对话.nid = nid
        _解析(台词)
    end
end

function 窗口层:被动对话(nid, 台词, 外形, 结束, yz)
    对话.co = nil
    对话.默认外形 = 外形
    对话.是否结束 = 结束
    对话.yz = yz
    _外形 = 外形
    if type(台词) == 'string' then
        对话:置可见(true)
        头像:置头像(_外形 ~= 0 and _外形 or 外形)
        对话:置坐标((引擎.宽度 - 对话.宽度) // 2, (引擎.高度 - 对话.高度 - 100) // 2)

        对话.nid = nid
        _解析(台词)
    end
end

function 窗口层:打开对话2(mid, nid, 外形) --GM指定地图
    对话:置可见(true)
    头像:置头像(外形)
    对话:置坐标((引擎.宽度 - 对话.宽度) // 2, (引擎.高度 - 对话.高度 - 100) // 2)

    对话.nid = nid
    local txt, id, name = __rpc:GM_NPC对话(mid, nid)
    if type(txt) == 'string' then
        对话:置可见(true)
        对话:初始化(id, name)
        _解析(txt)
    end
end

function 窗口层:给予对话(nid, 外形, 内容)
    if type(内容) == 'string' then
        对话:置可见(true)
        头像:置头像(外形)
        对话:置坐标((引擎.宽度 - 对话.宽度) // 2, (引擎.高度 - 对话.高度 - 100) // 2)
        对话.nid = nid
        _解析(内容)
    end
end

function 窗口层:打开选择(内容, wx)
    if type(内容) == 'string' then
        头像:置头像(wx)
        对话:置可见(true)
        对话:置坐标((引擎.宽度 - 对话.宽度) // 2, (引擎.高度 - 对话.高度 - 100) // 2)

        对话.co = coroutine.running()
        _解析(内容)
        return coroutine.yield()
    end
end

function RPC:被动对话(nid, 台词, 外形, 结束, yz)
    窗口层:被动对话(nid, 台词, 外形, 结束, yz)
end

function RPC:选择窗口(s, ...)
    if select('#', ...) > 0 then
        s = s:format(...)
    end
    return 窗口层:打开选择(s)
end

function RPC:选择窗口2(s, 外形, ...)
    if select('#', ...) > 0 then
        s = s:format(...)
    end
    return 窗口层:打开选择(s, 外形)
end

function RPC:打开对话(r, 外形, 剧情)
    对话.剧情 = 剧情
    对话:置可见(true)
    头像:置头像(外形)
    对话:置坐标((引擎.宽度 - 对话.宽度) // 2, (引擎.高度 - 对话.高度 - 100) // 2)
    对话.nid = nid
    _解析(r)
end

function 窗口层:最后对话(r, 外形, nid, 结束)
    if type(r) == 'string' then
        对话:置可见(true)
        if 外形 then
            头像:置头像(外形)
        end
        对话:置坐标((引擎.宽度 - 对话.宽度) // 2, (引擎.高度 - 对话.高度 - 100) // 2)
        对话.nid = nid
        对话.是否结束 = 结束
        _解析(r)
    end
end

function RPC:最后对话(r, 外形, nid, 结束)
    窗口层:最后对话(r, 外形, nid, 结束)
end

function RPC:被动菜单(台词, 头像, 结束)
    _被动菜单(台词, 头像, 结束)
end

-- 对话:置可见(true)
-- _解析([[
-- 你找我有什么事？
-- menu
-- 1|菜单1   菜单2
-- 没事
-- ]])
return 对话
