local 任务 = 窗口层:创建我的窗口('任务', 0, 0, 551, 437)
function 任务:初始化()
    self:置精灵(__res:getspr('ui/rwl.png'))
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
end

任务:创建关闭按钮()

local 标签控件 = 任务:创建标签('标签控件', 0, 0, 551, 437)
local 当前任务 = 标签控件:创建中标签按钮('当前任务', 15, 46, '当前任务')
local 可接任务 = 标签控件:创建中标签按钮('可接任务', 105, 46, '可接任务')
-- local 攻略按钮 = 标签控件:创建中按钮("攻略按钮", 195, 46, '游戏攻略')
-- local 排行按钮 = 标签控件:创建中按钮("排行按钮", 285, 46,  '排 行 榜')
-- function 攻略按钮:左键弹起()
--     窗口层:打开攻略窗口()
-- end

-- function 排行按钮:左键弹起()
--     窗口层:打开排行榜()
-- end

local 任务区域 = 标签控件:创建区域(当前任务, 17, 70, 515, 365)
local 任务列表
local 任务详情
local mapid
local mapx
local mapy
local mapname
do
    任务列表 = 任务区域:创建树形列表('任务列表', 3, 20, 194, 290)

    function 任务列表:初始化()
        self.缩进宽度 = 20
        self.行高度 = 20
        self.分类 = {}
        self.展开 = {}
        self:置颜色(255, 255, 255)
    end

    function 任务列表:任务清空()
        self.分类 = {}
        self:清空()
    end

    function 任务列表:任务添加(t)
        if type(t) == 'table' then
            local 类型 = t.类型 or '其它任务'
            local 分类 = self.分类[类型]
            if not 分类 then
                分类 = self:添加(类型)
                local 收展 = 分类:创建收展按钮(0, 0, 19, 19)
                --  function 收展:初始化()
                收展:置正常精灵(__res:getspr('gires4/jdmh/yjan/jiaan.tcp'):置中心(-5, -5))
                收展:置选中正常精灵(__res:getspr('gires4/jdmh/yjan/jianan.tcp'):置中心(-5
                , -5))
                --   end

                -- function 收展:选中事件(b)
                --     任务列表.展开[类型] = b
                -- end

                local 数量 = 分类:创建文本('数量', 75, 0, 100, 20)

                function 分类:更新()
                    if self.up then
                        self.up = false
                        数量:置文本('[' .. self:取项目数量() .. ']')
                    end
                end

                function 分类:任务添加(t)
                    local r = 分类:添加(t.名称)
                    r.nid = t.nid
                    r.分类 = 分类
                    r.是否可取消 = t.是否可取消
                    r.是否追踪 = t.是否追踪
                    self.up = true
                end

                分类:置展开(任务列表.展开[类型])
                分类:置可见(true, true)
                self.分类[类型] = 分类
            end
            分类:任务添加(t)
            return r
        end
    end

    function 任务列表:左键弹起(x, y, i, item)
        任务列表.选中 = item
        取消任务按钮:置禁止(item.nid == nil)
        追踪按钮:置禁止(item.nid == nil)
        if not item.分类 then
            _当前分类 = item.名称
        end
        if item.nid then
            _当前选中 = item.名称
            取消任务按钮:置禁止(item.是否可取消 == false)
            追踪按钮:置选中(item.是否追踪 == true)
            local r = __rpc:角色_获取任务详情(item.nid)
            if type(r) == 'string' then
                任务详情:置文本(r)
            end
        end
    end

    任务详情 = 任务区域:创建我的文本('任务详情', 228, 20, 264, 290)
    function 任务详情:回调获得鼠标(x, y, v, b)
        local t = GGF.分割文本(v, "|")
        if t[1] and t[2] and t[3] then
            if mapid ~= t[1] or mapx ~= t[2] or mapy ~= t[3] then
                mapid = t[1]
                mapx = t[2]
                mapy = t[3]
                local r = require('数据/地图库')[t[1] + 0]
                if r then
                    mapname = r.name
                end
            end
            self:置提示("#Y" .. mapname .. "(" .. mapx .. "," .. mapy .. ")")
        end
    end

    function 任务详情:回调左键弹起(v)
        local t = GGF.分割文本(v, "|") --1编号 2x 3y 4 npc名称
        -- print(_当前选中)--todo 可以判断类型 开启自动任务
        if t[1] and t[2] and t[3] then
            if _当前选中 == "抓鬼任务" then
                __自动任务:设置任务({ 类型 = "日常_抓鬼任务", id = t[1] + 0, x = t[2] + 0, y = t[3] + 0 })
            elseif _当前选中 == "天庭任务" then
                __自动任务:设置任务({ 类型 = "日常_天庭任务", id = t[1] + 0, x = t[2] + 0, y = t[3] + 0 })
            elseif _当前选中 == "鬼王任务" then
                __自动任务:设置任务({ 类型 = "日常_鬼王任务", id = t[1] + 0, x = t[2] + 0, y = t[3] + 0 })
            elseif _当前选中 == "修罗任务" then
                __rpc:角色_自动任务_天庭自动(t[2] + 0, t[3] + 0)
                __自动任务:设置任务({ 类型 = "日常_修罗任务", id = t[1] + 0, x = t[2] + 0, y = t[3] + 0 })
            end
        else
            if not __rol.是否组队 or __rol.是否队长 then
                界面层.任务栏.任务列表:文本回调左键弹起(v)
            end
        end
        窗口层:打开任务()
    end

    取消任务按钮 = 任务区域:创建中按钮('取消任务', 430, 325)
    function 取消任务按钮:初始化()
        self:置正常精灵(取按钮精灵('gires/0x86D66B9A.tcp', 1, '取消任务'))
        self:置按下精灵(取按钮精灵('gires/0x86D66B9A.tcp', 2, '取消任务'))
        self:置经过精灵(取按钮精灵('gires/0x86D66B9A.tcp', 3, '取消任务'))
        self:置禁止精灵(取按钮图像('gires/0x86D66B9A.tcp', 1, '不可取消'):到灰度():到精灵())
        self:置禁止(true)
    end

    function 取消任务按钮:左键弹起()
        local 选中 = 任务列表.选中
        if 选中 then
            if 窗口层:确认窗口('确定要取消任务吗？') then
                if __rpc:角色_取消任务(选中.nid) then
                    选中.分类:删除(选中.名称)
                    任务详情:清空()
                end
            end
        end
    end

    追踪按钮 = 任务区域:创建我的多选按钮2('追踪按钮', 2, 325, '追  踪', '取消追踪')


    function 追踪按钮:左键弹起()
        local 选中 = 任务列表.选中
        if 选中 then
            coroutine.xpcall(
                function()
                    local r = __rpc:角色_设置任务追踪(选中.nid, not self.是否选中)
                    if type(r) == 'string' then
                        窗口层:提示窗口(r)
                    elseif r == true then
                        选中.是否追踪 = self.是否选中 == true
                        RPC:刷新任务追踪()
                    end
                end
            )
            return true
        end
        return false
    end
end

function 当前任务:左键弹起()
    当前任务:置选中(true)
    可接任务:置选中(false)
    取消任务按钮:置可见(true)
    追踪按钮:置可见(true)

    local r = __rpc:角色_打开任务窗口()
    任务列表:任务清空()
    任务详情:清空()

    if type(r) == 'table' then
        时间排序(r)
        for _, v in ipairs(r) do
            任务列表:任务添加(v)
        end
        if _当前选中 and _当前分类 then
            for i, v in 任务列表:遍历项目() do
                if _当前分类 == v.名称 then
                    v:置展开(true)
                    任务列表:左键弹起(x, y, i, v)
                    for index, value in v:遍历项目() do
                        if value.名称 == _当前选中 then
                            任务列表:左键弹起(x, y, i, value)
                        end
                    end
                end
            end
        end
    end
end

function 可接任务:左键弹起()
    可接任务:置选中(true)
    当前任务:置选中(false)
    取消任务按钮:置可见(false)
    追踪按钮:置可见(false)

    local r = __rpc:角色_获取可接任务()
    任务列表:任务清空()
    任务详情:清空()
    if type(r) == 'table' then
        时间排序(r)
        for _, v in ipairs(r) do
            任务列表:任务添加(v)
        end
        if _当前选中 and _当前分类 then
            for i, v in 任务列表:遍历项目() do
                if _当前分类 == v.名称 then
                    v:置展开(true)
                    任务列表:左键弹起(x, y, i, v)
                    for index, value in v:遍历项目() do
                        if value.名称 == _当前选中 then
                            任务列表:左键弹起(x, y, i, value)
                        end
                    end
                end
            end
        end
    end
end

function 窗口层:打开任务()
    任务:置可见(not 任务.是否可见)
    if not 任务.是否可见 then
        return
    end
    当前任务:置选中(true)

    local r = __rpc:角色_打开任务窗口()
    任务列表:任务清空()
    任务详情:清空()
    if type(r) == 'table' then
        时间排序(r)
        for _, v in ipairs(r) do
            任务列表:任务添加(v)
        end
        if _当前选中 and _当前分类 then
            for i, v in 任务列表:遍历项目() do
                if _当前分类 == v.名称 then
                    v:置展开(true)
                    任务列表:左键弹起(x, y, i, v)
                    for index, value in v:遍历项目() do
                        if value.名称 == _当前选中 then
                            任务列表:左键弹起(x, y, i, value)
                        end
                    end
                end
            end
        end
    end
end

function RPC:请求刷新任务列表()
    if 任务.是否可见 then
        任务.是否可见 = false
        窗口层:打开任务()
    end
end

function RPC:刷新任务详情(v)
    if type(v) == 'string' then
        任务详情:置文本(v)
    end
end

return 任务
