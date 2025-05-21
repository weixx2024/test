
local 法宝界面 = 窗口层:创建我的窗口('法宝界面', 0, 0, 412, 468)
do
    function 法宝界面:初始化()
        self:置精灵(
            生成精灵(
                412,
                468,
                function()
                    __res:getsf('ui/fabao.png'):显示(0, 0)
                    __res:getsf('gires/skin/jdmu/qt/fbl.tcp'):显示(24, 24)
                    --__res:getsf('gires4/经典红木/其他/法宝炉.tcp'):显示(24, 24)
                    -- gires4\经典红木\其他
                end
            )
        )
        self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
    end

    function 法宝界面:置动画(v)
        self.左上 = nil
        self.右上 = nil
        self.下 = nil
        if v then
            local 右上, 左上, 下 = self.佩戴网格:取特效()
            self.右上 = __res:getani('gires4/fbl/%4d.tcp', 右上):播放(true)
            self.右上:置中心(-142, -106)
            self.左上 = __res:getani('gires4/fbl/%4d.tcp', 左上):播放(true)
            self.左上:置中心(-73, -106)
            self.下 = __res:getani('gires4/fbl/%4d.tcp', 下):播放(true)
            self.下:置中心(-89, -155)
        end
    end

    function 法宝界面:更新(dt)
        if self.左上 then
            self.左上:更新(dt)
        end
        if self.右上 then
            self.右上:更新(dt)
        end
        if self.下 then
            self.下:更新(dt)
        end
    end

    function 法宝界面:显示(x, y)
        if self.右上 then
            self.右上:显示(x, y)
        end
        if self.左上 then
            self.左上:显示(x, y)
        end
        if self.下 then
            self.下:显示(x, y)
        end
    end
end


法宝界面:创建关闭按钮()
local 文本 = 法宝界面:创建文本('介绍文本', 243, 46, 146, 149)
local high_light_frame = __res:getspr('gires2/dialog/high_light_frame.tcp')
local selectframe = __res:getspr('gires2/dialog/selectframe.tcp')
local yin = __res:getani('gires4/fbl/0.tcp'):播放(true)
local yang = __res:getani('gires4/fbl/1.tcp'):播放(true)
yin:置中心(8, 2)
yang:置中心(8, 2)
local 佩戴网格 = 法宝界面:创建网格('佩戴网格', 37, 66, 169, 118)

do
    function 佩戴网格:初始化()
        self:添加格子(72, 2 + 15, 33, 33)
        self:添加格子(126, 75, 33, 33)
        self:添加格子(20, 75, 33, 33)

        self.数据 = {}
        self.记录格子 = 0
    end

    function 佩戴网格:取特效()
        local a, b, c = self.数据[1].阴阳, self.数据[2].阴阳, self.数据[3].阴阳
        local 左上 = 31 .. c .. a
        local 右上 = 12 .. a .. b
        local 下 = 23 .. c .. b
        return 右上, 左上, 下
    end

    function 佩戴网格:取卦象()
        local a, b, c = self.数据[1].阴阳, self.数据[2].阴阳, self.数据[3].阴阳
        local lv = 0
        for i = 1, 3, 1 do
            if self.数据[i] then
                lv = lv + self.数据[i].等级
            end
        end


        return a .. b .. c, lv
    end

    function 佩戴网格:更新(dt)
        if _特效 then
            yin:更新(dt)
            yang:更新(dt)
        end
    end

    function 佩戴网格:子显示(x, y, i)
        if self.数据[i] then
            self.数据[i]:显示(x, y)
        end
    end

    function 佩戴网格:子前显示(x, y, i)
        if _特效 then
            if self.数据[i].阴阳 == 0 then
                yin:显示(x, y)
            else
                yang:显示(x, y)
            end
        end

    end

    function 佩戴网格:清空()
        self.当前选中 = 0
        self.获得焦点 = 0
        self.记录格子 = 0
        for k, v in pairs(self.数据) do
            self.数据[k] = nil
        end
    end

    function 佩戴网格:添加法宝(i, v)
        if type(v) == 'table' then
            v.i = i --物品所在位置
            v.类别 = 5
            v.缩小 = 35
            if ggetype(v) == '物品' then
                self.数据[i] = v
            else
                self.数据[i] = require('界面/数据/物品')(v)
            end
            return self.数据[i]
        end
        self.数据[i] = nil

    end

    function 佩戴网格:获得鼠标(x, y, i)
        if self.获得焦点 ~= i then
            self:清空请求记录(self.获得焦点)
        end
        if not 鼠标层.附加 and self.数据 and self.数据[i] then
            self.获得焦点 = i
            if self.数据[i].nid then
                self:物品提示(x + 50, y + 50, self.数据[i]) --先显示缓存
                if not self.数据[i].已请求 then
                    self.数据[i].已请求 = true
                    local r = __rpc:取法宝描述(self.数据[i].nid)
                    if self.数据[i] and r then
                        self.数据[i].刷新显示 = true
                        self.数据[i].属性 = r
                        self:物品提示(x + 50, y + 50, self.数据[i])
                    end
                end
            elseif self.数据[i].名称 then --本地
                self:物品提示(x, y, self.数据[i])
            end
        end
    end

    function 佩戴网格:清空请求记录(i)
        if self.数据 and self.数据[i] then
            self.数据[i].已请求 = nil
        end
    end

    function 佩戴网格:失去鼠标(x, y, i)
        self.获得焦点 = false
    end

    function 佩戴网格:左键按下(x, y, i, t)
        佩戴网格:物品提示()
        self[i]:置中心(-1, -1)

    end

    function 佩戴网格:左键弹起(x, y, i, t)
        self[i]:置中心(0, 0)
        if gge.platform ~= 'Windows' then
            self:右键弹起(x, y, i, t)
        end
    end

    function 佩戴网格:右键弹起(x, y, i, t)
        if self.数据 and self.数据[i] then
            local r = __rpc:角色_脱下法宝(self.数据[i].nid)
            if type(r) == "string" then
                窗口层:提示窗口(r)
            elseif r then
                法宝界面:刷新佩戴()
                法宝界面:刷新法宝列表()
                self.数据[i] = nil
            end
        end
    end
end


-- local 补充灵气按钮 = 法宝界面:创建中按钮('补充灵气按钮', 270, 205, '补充灵气')
-- function 补充灵气按钮:左键弹起()
-- end

local 道具网格 = 法宝界面:创建网格('道具网格', 42, 241, 309, 207)
do
    function 道具网格:初始化()
        self:创建格子(50, 50, 1, 1, 4, 6)
        self.数据 = {}
        self.记录格子 = 0
    end

    function 道具网格:添加法宝(i, v)
        if type(v) == 'table' then
            v.i = i --物品所在位置
            v.类别 = 5
            if ggetype(v) == '物品' then
                self.数据[i] = v
            else
                self.数据[i] = require('界面/数据/物品')(v)
            end
            return self.数据[i]
        end
        self.数据[i] = nil
    end

    function 道具网格:清空()
        self.当前选中 = 0
        self.获得焦点 = 0
        self.记录格子 = 0
        for k, v in pairs(self.数据) do
            self.数据[k] = nil
        end
    end

    function 道具网格:子显示(x, y, i)
        if self.数据[i] then
            self.数据[i]:显示(x, y)
        end
    end

    function 道具网格:子前显示(x, y, i)
        if self.当前选中 == i then
            selectframe:显示(x, y)
        end
        if self.获得焦点 == i then
            high_light_frame:显示(x, y)
        end
        if self.前显示2 then
            self:前显示2(x, y, i)
        end
    end

    function 道具网格:获得鼠标(x, y, i)
        if self.获得焦点 ~= i then
            self:清空请求记录(self.获得焦点)
        end
        if not 鼠标层.附加 and self.数据 and self.数据[i] then
            self.获得焦点 = i
            if self.数据[i].nid then
                self:物品提示(x + 50, y + 50, self.数据[i]) --先显示缓存
                if not self.数据[i].已请求 then
                    self.数据[i].已请求 = true
                    local r = __rpc:取法宝描述(self.数据[i].nid)
                    if self.数据[i] and r then
                        self.数据[i].刷新显示 = true
                        self.数据[i].属性 = r
                        self:物品提示(x + 50, y + 50, self.数据[i])
                    end
                end
            elseif self.数据[i].名称 then --本地
                self:物品提示(x, y, self.数据[i])
            end
        end
    end

    function 道具网格:清空请求记录(i)
        if self.数据 and self.数据[i] then
            self.数据[i].已请求 = nil
        end
    end

    function 道具网格:失去鼠标(x, y, i)
        self.获得焦点 = false
    end

    function 道具网格:置选中(i)
        if self.数据[i] then
            self.当前选中 = i
        end
    end

    function 道具网格:左键按下(x, y, i, t)
        道具网格:物品提示()
        self[i]:置中心(-1, -1)

    end

    function 道具网格:左键弹起(x, y, i, t)
        self:置选中(i)
        self[i]:置中心(0, 0)
        if gge.platform ~= 'Windows' then
            self:右键弹起(x, y, i, t)
        end
    end

    function 道具网格:右键弹起(x, y, i, t)
        if self.数据 and self.数据[i] then
            local r = __rpc:角色_佩戴法宝(self.数据[i].nid)
            if type(r) == "string" then
                窗口层:提示窗口(r)
            elseif r then
                法宝界面:刷新佩戴()
                self.数据[i] = nil
            end
        end

    end









end

local _卦象 = {
    ["111"] = { "乾为天", "封印" },
    ["000"] = { "坤为地", "混乱" },
    ["001"] = { "震为雷", "雷系" },
    ["110"] = { "巽为风", "风系" },
    ["100"] = { "艮为山", "昏睡" },
    ["011"] = { "兑为泽", "毒系" },
    ["010"] = { "坎为水", "水系" },
    ["101"] = { "离为火", "火系" },
}

function 法宝界面:刷新佩戴()
    佩戴网格:清空()
    文本:置文本("")
    _特效 = false
    local t = __rpc:角色_获取法宝佩戴列表()
    if type(t) == "table" then
        local n = 0
        for i, v in pairs(t) do
            n = n + 1
            佩戴网格:添加法宝(i, v)
        end
        _特效 = n == 3
        法宝界面:置动画(_特效)
        if _特效 then
            local k, lv = 佩戴网格:取卦象()
            local t = _卦象[k]
            if t then

                local n = math.floor(lv * 0.4) * 0.1


                文本:置文本(string.format("天地人三才定位构成乾坤。%s，你的%s抗性增加了%s", t[1
                    ],
                    t[2], n))
            end
        end
    end
end

function 法宝界面:刷新法宝列表()
    道具网格:清空()
    local t = __rpc:角色_获取法宝列表()
    if type(t) == "table" then
        for i, v in ipairs(t) do
            道具网格:添加法宝(i, v)
        end
    end
end

function 窗口层:打开法宝界面()
    法宝界面:置可见(not 法宝界面.是否可见)
    if not 法宝界面.是否可见 then
        return
    end
    local t = __rpc:角色_获取法宝列表()
    道具网格:清空()
    if type(t) == "table" then
        for i, v in ipairs(t) do
            道具网格:添加法宝(i, v)
        end
    end
    法宝界面:刷新佩戴()
end

return 法宝界面
