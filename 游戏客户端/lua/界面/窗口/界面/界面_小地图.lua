local 小地图 = 窗口层:创建我的窗口('小地图', 0, 0)
local tcp = __res:get('gires3/button/飞行旗图标.tcp') -- 蓝色
-- local tcp = __res:get('gires3/button/内景飞行旗图标.tcp') -- 黄色
local _选择 = { 全部 = true, 普通 = true, 任务 = true, 商业 = true, 传送 = true }
_NPC = {}
_飞行棋 = {}

function 小地图:初始化()
    self.NPC = {}
end

function 小地图:载入(id)
    if self.id == id then
        return true
    end
    local map = require('数据/地图库')[id]
    local 地图 = __res:getsf('smap/patch_2011/%d.tcp', id % 10000)
    if 地图 then
        self.id = id
        地图:置中心(-26, -26)
        self:置精灵(self:取拉伸精灵_宽高('smap/1001.tcp', 地图.宽度 + 52, 地图.高度 + 52, 地图), true)
        self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
        local r = __rpc:角色_小地图验证(id)
        if r then
            coroutine.xpcall(function()
                local npc = __rpc:角色_副本小地图()
                self.NPC = {}
                if type(npc) == 'table' then
                    for i, v in ipairs(npc) do
                        local xy = require('GGE.坐标')(v.x, v.y) // 地图区域.缩小比例
                        if _选择[v.分类] then
                            if v.分类 == '普通' then
                                __res.F12:置颜色(0, 255, 0)
                            elseif v.分类 == '任务' then
                                __res.F12:置颜色(255, 255, 0)
                            elseif v.分类 == '商业' then
                                __res.F12:置颜色(0, 255, 255)
                            elseif v.分类 == '传送' then
                                table.insert(self.NPC,
                                    {
                                        __res:getspr('gires3/button/yz.tcp'):置中心(-xy.x - 15, -xy.y - 15),
                                        分类 = v.分类
                                    })
                            else
                                __res.F12:置颜色(255, 255, 255)
                            end
                            if v.分类 ~= '传送' then
                                npc = __res.F12:取精灵(v.名称)
                                table.insert(self.NPC, {
                                    精灵 = npc:置中心(-xy.x - 26 + (npc.宽度 // 2),
                                        -xy.y - 26 + 6),
                                    分类 = v.分类
                                })
                            end
                        end
                    end
                end
                self.NPC.id = id
                self:刷新npc显示(id)
            end)
            return true
        end

        if not _NPC[id] or not next(_NPC[id]) then
            _NPC[id] = {}
            coroutine.xpcall(function()
                local npc = __rpc:角色_小地图(id)
                if type(npc) == 'table' then
                    for i, v in ipairs(npc) do
                        local xy = require('GGE.坐标')(v.x, v.y) // 地图区域.缩小比例
                        if _选择[v.分类] then
                            if v.分类 == '普通' then
                                __res.F12:置颜色(0, 255, 0)
                            elseif v.分类 == '任务' then
                                __res.F12:置颜色(255, 255, 0)
                            elseif v.分类 == '商业' then
                                __res.F12:置颜色(0, 255, 255)
                            elseif v.分类 == '传送' then
                                table.insert(_NPC[id], {
                                    精灵 = __res:getspr('gires3/button/yz.tcp'):置中心(-xy.x - 15, -xy.y - 15),
                                    分类 = v.分类
                                })
                            else
                                __res.F12:置颜色(255, 255, 255)
                            end
                            if v.分类 ~= '传送' then
                                local npc = __res.F12:取精灵(v.名称)
                                table.insert(_NPC[id], {
                                    精灵 = npc:置中心(-xy.x - 26 + (npc.宽度 // 2), -xy.y - 26 + 6),
                                    分类 = v.分类
                                })
                            end
                        end
                    end
                end
                self:刷新npc显示(id)
            end)
        else
            self:刷新npc显示(id)
            -- self.NPC = _NPC[id]
        end
        return true
    end
end

function 小地图:刷新npc显示(id)
    if self.NPC.id == id then

    else
        self.NPC = {}
        if _NPC[id] and type(_NPC[id]) == 'table' then
            for k, v in ipairs(_NPC[id]) do
                if _选择[v.分类] then
                    table.insert(self.NPC, v)
                end
            end
        end
    end
end

function 小地图:显示(x, y)
    for i, v in ipairs(self.NPC) do
        v.精灵:显示(x, y)
    end
end

for k, v in pairs { "全部", "传送", "普通", "任务", "商业" } do
    local 文本 = 小地图:创建文本(v .. "文本", 47 + k * 56 - 56, -18, 50, 14)
    文本:置文字(__res.F12)
    文本:置文本(v)
    local 按钮 = 小地图:创建我的多选按钮(v .. "按钮", 27 + k * 56 - 56, -20)
    function 按钮:初始化()
        local tcp = __res:get('gires4/smsj/yjan/dxk.tcp')
        self:置正常精灵(tcp:取精灵(1):置中心(0, 0))
        self:置选中正常精灵(tcp:取精灵(2):置中心(0, 0))
        self:置选中(true)
    end

    function 按钮:选中事件(x)
        _选择[v] = x
        if v == "全部" then
            for k, v in pairs(_选择) do
                _选择[k] = x
                小地图[k .. "按钮"]:置选中(x)
            end
        end
        小地图:刷新npc显示(小地图.id)
    end
end

小地图:创建关闭按钮()
--===============================================================================================
--搜索按钮.tcp
--多选框.tcp
--垂直滑动条底.tcp
--垂直滑动条块.tcp

地图区域 = 小地图:创建控件('地图区域', 26, 26)
do
    function 地图区域:初始化()
        self.主角精灵 = __res:getspr('gires/scene/point.tca'):置中心(5, 5)
        self.目标精灵 = __res:getspr('gires/scene/dida.tcp'):置中心(9, 27)
        self.路径精灵 = require('SDL.精灵')(0, 0, 0, 4, 4):置颜色(255, 0, 0)
    end

    function 地图区域:获得鼠标(x, y)
        local cx, cy = self:取坐标()
        self.xy = require('GGE.坐标')(x - cx, y - cy) * self.缩小比例
        self:置提示('X:%d Y:%d', self.xy.x // 20, (self.地图高度 - self.xy.y) // 20)
    end

    function 地图区域:显示(x, y)
        local xy = __rol.xy // self.缩小比例
        if __rol.是否移动 and self.目的地 then
            for i, v in ipairs(self.路径) do
                self.路径精灵:显示(x + v.x, y + v.y)
            end
            self.目标精灵:显示(x + self.目的地.x, y + self.目的地.y)
        end
        if __map.id == 小地图.id then
            self.主角精灵:显示(x + xy.x, y + xy.y)
        end
    end

    function 地图区域:左键弹起(x, y)
        if gge.platform == 'Android' or gge.platform == 'iOS' then
            self.xy:floor()
            local r = __rpc:角色_取无限飞()

            if not r or tonumber(r) ~= 1 then
                goto jump
            end
            local r = 窗口层:确认窗口('#W是否使用#G任我行#W飞行符传送到目标位置？', 小地图.名称, x, y)
            if r then
                __rpc:角色_任我行1(小地图.id, self.xy.x, self.xy.y)
            end
            -- if __rol.是否组队 and __rol.是否队长 then
            --     local r = 窗口层:确认窗口('#W是否消耗一张#G任我行·组队#W飞行符传送到目标位置？#R（提示：系统设置可关闭右键飞行）', 小地图.名称, x, y)
            --     if r then
            --         __rpc:角色_任我行(小地图.id, self.xy.x, self.xy.y)
            --     end
            -- elseif not __rol.是否组队 then
            --     local r = 窗口层:确认窗口('#W是否消耗一张#G任我行·单人#W飞行符传送到目标位置？#R（提示：系统设置可关闭右键飞行）', 小地图.名称, x, y)
            --     if r then
            --         __rpc:角色_任我行(小地图.id, self.xy.x, self.xy.y)
            --     end
            -- end
        end

        if 引擎:取功能键状态(SDL.KMOD_CTRL) then -- and gge.isdebug
            self.xy:floor()
            local r = __rpc:角色_取无限飞()

            if not r or tonumber(r) ~= 1 then
                goto jump
            end

            if r then
                __rpc:角色_GM_移动地图(小地图.id, self.xy.x, self.xy.y)
            end
        end

        ::jump::
        if __map.id == 小地图.id then
            local 路径 = __map:寻路(__rol.xy, self.xy)
            if #路径 > 0 then
                self.目的地 = self.xy // self.缩小比例
                self.路径 = {}
                for i, v in ipairs(路径) do
                    if i % 10 == 0 then
                        table.insert(self.路径, require('GGE.坐标')(v.x * 20, v.y * 20) // self.缩小比例)
                    end
                end
                __rol:路径移动(__map)
            else
                self.目的地 = nil
            end
        end
    end
end
--===============================================================================================
飞行控件 = 小地图:创建控件('飞行控件', 16, 16)

--世界地图
function 窗口层:打开小地图预览(id)
    local map = require('数据/地图库')[id]

    if map and 小地图:载入(id) then
        小地图:置可见(true, true)
        地图区域.地图高度 = map.h
        地图区域.缩小比例 = require('GGE.坐标')(map.w / (小地图.宽度 - 52), map.h / (小地图.高度 - 52))
        地图区域:置可见(true)
        地图区域:置宽高(小地图.宽度 - 52, 小地图.高度 - 52)

        窗口层:打开小地图飞行(id)
    else
        小地图:置可见(false)
    end
end

--当前地图
function 窗口层:打开小地图当前()
    local 可见 = not 小地图.是否可见
    小地图:置可见(可见, true)
    地图区域:置可见(false)

    if 小地图.是否可见 and 小地图:载入(__map.id) then
        地图区域.地图高度 = __map.高度
        地图区域.缩小比例 = require('GGE.坐标')(__map.宽度 / (小地图.宽度 - 52), __map.高度 / (小地图.高度 - 52))
        地图区域:置可见(true)
        地图区域:置宽高(小地图.宽度 - 52, 小地图.高度 - 52)

        窗口层:打开小地图飞行(__map.id)
    else
        小地图:置可见(false)
    end
end

--飞行旗
function 窗口层:打开小地图飞行(id)
    小地图:删除控件('飞行控件')

    飞行控件 = 小地图:创建控件('飞行控件', 16, 16)

    飞行控件:置宽高(小地图.宽度 - 52, 小地图.高度 - 52)

    local r = __rpc:角色_取地图飞行旗(id)
    if type(r) == 'table' then
        for k, v in pairs(r) do
            if v.X then
                local x = math.floor(v.X * 20)
                local y = math.floor(地图区域.地图高度 - v.Y * 20)
                local xy = require('GGE.坐标')(x, y) // 地图区域.缩小比例

                local 飞行棋按钮 = 飞行控件:创建按钮('飞行棋按钮' .. k .. math.random(100) .. os.time(), 0, 0)
                function 飞行棋按钮:初始化()
                    self:置坐标(xy.x + 4, xy.y - 16)
                    self:置正常精灵(tcp:取精灵(1):置中心(0, 0))
                    self:置按下精灵(tcp:取精灵(1):置中心(-1, -1))
                end

                function 飞行棋按钮:左键弹起()
                    local r, v = __rpc:角色_小地图使用飞行旗(v)
                    小地图:置可见(false, true)
                end
            end
        end

        飞行控件:置可见(true, true)
    end
end

return 小地图
