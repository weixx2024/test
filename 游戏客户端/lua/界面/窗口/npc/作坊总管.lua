
local 作坊总管窗口 = 窗口层:创建我的窗口('作坊总管窗口', 0, 0, 456, 511)
local _次数 = 1
local _作坊部位 = { 步摇坊 = "帽子", 炼器坊 = "", 湛卢坊 = "武器", 七巧坊 = "衣服", 生莲坊 = "鞋子",
    同心坊 = "项链" }
local _选中作坊 = 1
local _按钮底部位 = { 'djmz.png', 'djwq.png', 'djyf.png', 'djxz.png',
    'djxl.png', 'djwq.png', }
local _作坊列表 = { "步摇坊", "湛卢坊", "七巧坊", "生莲坊", "同心坊", "炼器坊" }
function 作坊总管窗口:初始化()
    self:置精灵(__res:getspr('ui/zfzg.png'))
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
end

function 作坊总管窗口:显示(x, y)
end

作坊总管窗口:创建关闭按钮()


do --作坊区域
    for k, v in pairs { "步摇坊", "湛卢坊", "七巧坊", "生莲坊", "同心坊", "炼器坊" } do
        local l = 57 + 67 * k - 67
        if v == "炼器坊" then
            l = 407
        end
        local an = 作坊总管窗口:创建单选按钮(v .. '按钮', 23, l)
        function an:初始化()
            local tcp = 生成精灵(
                192,
                67,
                function()
                    __res:getsf('ui/zfan1.png'):显示(0, 0)
                    __res.JMZ:取图像(v .. "(" .. _作坊部位[v] .. ")"):显示(74, 7)
                    __res:getsf('gires4/ty/' .. _按钮底部位[k]):显示(9, 7)
                end
            )
            self:置正常精灵(tcp)
            self:置经过精灵(tcp)
            self:置选中正常精灵(
                生成精灵(
                    187,
                    61,
                    function()
                        __res:getsf('ui/zfan2.png'):显示(0, 0)
                        __res.JMZ:取图像(v .. "(" .. _作坊部位[v] .. ")"):显示(74, 7)
                        __res:getsf('gires4/ty/' .. _按钮底部位[k]):显示(9, 7)
                    end
                )
            )
        end

        local 段位文本 = an:创建文本("段位文本", 71, 26, 60, 14)
        段位文本:置文字(__res.F12)
        段位文本:置文本("#cbba54b段位:0")
        local 等级文本 = an:创建文本("等级文本", 71, 44, 60, 14)
        等级文本:置文字(__res.F12)
        等级文本:置文本("#cbba54b等级:0")

        -- local 加入按钮  = an:创建按钮('加入按钮', 72, 30)
        -- function 加入按钮:初始化()
        --     self:置正常精灵(取按钮精灵2('ui/小小按钮1.png', '加入'))
        --     self:置按下精灵(取按钮精灵2('ui/小小按钮3.png', '加入', 1, 1))
        --     self:置经过精灵(取按钮精灵2('ui/小小按钮2.png', '加入'))
        -- end

        -- function 加入按钮:左键弹起()

        -- end
        function an:左键弹起(x, y, i)
            _选中作坊 = k
            作坊总管窗口.可炼化文本:置文本("")
            if v ~= "炼器坊" then
                作坊总管窗口.可炼化文本:置文本(string.format('(可炼化%s)', _作坊部位[v]))
            end
            作坊总管窗口.选中作坊文本:置文本('#cffcc00' .. v)
            作坊总管窗口:刷新数据()
        end

    end
end

作坊总管窗口.步摇坊按钮:置选中(true)
do --数据区域
    for k, v in pairs { "当前段位", "当前等级", "当前熟练" } do
        local 文本 = 作坊总管窗口:创建文本(v .. "文本", 288, 93 + k * 22 - 22, 96, 14)
    end

    for k, v in pairs { "熟练所需体力", "熟练所需金钱" } do
        local 文本 = 作坊总管窗口:创建文本(v .. "文本", 288, 214 + k * 22 - 22, 96, 14)
    end

    local 文本组合 = 作坊总管窗口:创建文本组合("文本组合", 288, 189, 100, 20)
    -- 文本组合:创建文本(288, 189, 100, 20)
    for i, v in ipairs { "1次", "5次", "10次", "50次" } do
        文本组合:添加(v)
    end
    local _次数列表 = { 1, 5, 10, 50 }
    function 文本组合:选中事件(i)
        _次数 = _次数列表[i]
        if _数据 then
            作坊总管窗口.熟练所需体力文本:置文本(20 * _次数 .. "/" .. (_数据.体力 or 0))
        end
        作坊总管窗口.熟练所需金钱文本:置文本(银两颜色(100000 * _次数)) --
    end

    文本组合:置文本('1次')
    文本组合:选中事件(1)
    for k, v in pairs { "等级所需熟练", "等级所需金钱" } do
        local 文本 = 作坊总管窗口:创建文本(v .. "文本", 288, 310 + k * 22 - 22, 96, 14)
    end
    for k, v in pairs { "段位所需等级", "段位所需金钱" } do
        local 文本 = 作坊总管窗口:创建文本(v .. "文本", 288, 408 + k * 22 - 22, 96, 14)
    end


    local 选中作坊文本 = 作坊总管窗口:创建我的文本('选中作坊文本', 285, 45, 80, 25)
    选中作坊文本:置文字(__res.HY24B)
    选中作坊文本:置文本('#cffcc00步摇坊')

    local 可炼化文本 = 作坊总管窗口:创建文本('可炼化文本', 290, 70, 80, 14)
    可炼化文本:置文字(__res.F12)
    可炼化文本:置文本('(可炼化帽子)')

    -- local 脱离按钮  = 作坊总管窗口:创建按钮('脱离按钮', 363, 49)
    -- function 脱离按钮:初始化()
    --     self:置正常精灵(取按钮精灵2('ui/小小按钮1.png', '脱离'))
    --     self:置按下精灵(取按钮精灵2('ui/小小按钮3.png', '脱离', 1, 1))
    --     self:置经过精灵(取按钮精灵2('ui/小小按钮2.png', '脱离'))
    -- end

    -- function 脱离按钮:左键弹起()

    -- end


    local 提升熟练按钮 = 作坊总管窗口:创建按钮('提升熟练按钮', 305, 260)
    function 提升熟练按钮:初始化()
        self:置正常精灵(取按钮精灵2('ui/xx531.png', '提升熟练'))
        self:置按下精灵(取按钮精灵2('ui/xx533.png', '提升熟练', 1, 1))
        self:置经过精灵(取按钮精灵2('ui/xx532.png', '提升熟练'))
    end

    function 提升熟练按钮:左键弹起()
        if _数据 then
            local r, a, b = __rpc:角色_提升作坊熟练(_选中作坊, _次数)
            if type(r) == "table" then
                _数据[_选中作坊] = r
                _体力 = a
                作坊总管窗口:刷新数据()
                窗口层:提示窗口(b)
            elseif type(r) == "string" then
                窗口层:提示窗口(r)
            end
        end
    end

    local 提升等级按钮 = 作坊总管窗口:创建按钮('提升等级按钮', 305, 358)
    function 提升等级按钮:初始化()
        self:置正常精灵(取按钮精灵2('ui/xx531.png', '提升等级'))
        self:置按下精灵(取按钮精灵2('ui/xx533.png', '提升等级', 1, 1))
        self:置经过精灵(取按钮精灵2('ui/xx532.png', '提升等级'))
    end

    function 提升等级按钮:左键弹起()
        if _数据 and _数据[_选中作坊] then
            local r, a = __rpc:角色_提升作坊等级(_选中作坊)
            if type(r) == "table" then
                _数据[_选中作坊] = r
                作坊总管窗口[r.名称 .. "按钮"].等级文本:置文本("#cbba54b等级:" .. r.等级)
                作坊总管窗口:刷新数据()
                窗口层:提示窗口(a)
            elseif type(r) == "string" then
                窗口层:提示窗口(r)
            end
        end
    end

    local 提升段位按钮 = 作坊总管窗口:创建按钮('提升段位按钮', 305, 453)
    function 提升段位按钮:初始化()
        self:置正常精灵(取按钮精灵2('ui/xx531.png', '提升段位'))
        self:置按下精灵(取按钮精灵2('ui/xx533.png', '提升段位', 1, 1))
        self:置经过精灵(取按钮精灵2('ui/xx532.png', '提升段位'))
    end

    function 提升段位按钮:左键弹起()
        if _数据 and _数据[_选中作坊] then
            local r, a = __rpc:角色_提升作坊段位(_选中作坊)
            if type(r) == "table" then
                _数据[_选中作坊] = r
                作坊总管窗口[r.名称 .. "按钮"].段位文本:置文本("#cbba54b段位:" .. r.段位)
                作坊总管窗口:刷新数据()
                窗口层:提示窗口(a)
            elseif type(r) == "string" then
                窗口层:提示窗口(r)
            end
        end
    end
end

local _等级需求 = { 8, 24, 40, 56, 72, 88, 104, 999 }

function 作坊总管窗口:刷新数据()
    if _数据 then
        local r = _数据[_选中作坊]
        if r then
            self.当前段位文本:置文本(r.段位)
            self.当前等级文本:置文本(r.等级)
            self.当前熟练文本:置文本(r.熟练度)
            self.熟练所需体力文本:置文本(20 * _次数 .. "/" .. _体力)
            self.熟练所需金钱文本:置文本(银两颜色(100000 * _次数)) --

            self.等级所需熟练文本:置文本((r.等级 + 1) * 2)
            self.等级所需金钱文本:置文本(银两颜色((r.等级 + 1) * 250))

            self.段位所需等级文本:置文本(_等级需求[r.段位 + 1] .. "/" .. r.等级)
            self.段位所需金钱文本:置文本(银两颜色(_等级需求[r.段位 + 1] * 250000))
        end
    end
end

function 窗口层:打开作坊总管窗口()
    作坊总管窗口:置可见(not 作坊总管窗口.是否可见)
    if not 作坊总管窗口.是否可见 then
        return
    end

    _数据, _, _体力 = __rpc:角色_打开作坊总管窗口()
    for k, v in ipairs(_数据) do
        if type(v) == "table" then
            作坊总管窗口[v.名称 .. "按钮"].等级文本:置文本("#cbba54b等级:" .. v.等级)
            作坊总管窗口[v.名称 .. "按钮"].段位文本:置文本("#cbba54b段位:" .. v.段位)
        end
    end
    作坊总管窗口:刷新数据()

end

function RPC:作坊总管窗口()
    窗口层:打开作坊总管窗口()
end

--窗口层:打开作坊总管窗口()
return 作坊总管窗口
