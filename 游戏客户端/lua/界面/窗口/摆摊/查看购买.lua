

local 查看购买 = 窗口层:创建我的窗口('查看购买', 0, 0, 663, 516)
function 查看购买:初始化()
    self:置精灵(__res:getspr('ui/ckgm.png'))
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
    self.禁止滚动 = true
end

local 按钮 = 查看购买:创建按钮('关闭按钮', 391 - 25, 0)
function 按钮:初始化(v)
    local tcp = __res:get('gires/0xF11233BB.tcp')
    self:置正常精灵(tcp:取精灵(1))
    self:置按下精灵(tcp:取精灵(2))
    self:置经过精灵(tcp:取精灵(3))
end

function 按钮:左键弹起()
    self.父控件:置可见(false)
end

local 头像按钮 = 查看购买:创建人物头像按钮('人物头像按钮', 22, 34)

function 头像按钮:左键弹起()

end

function 头像按钮:置头像(id)
    local tcp = __res:getspr('photo/facesmall/%s.tga', id)
    if tcp then
        self:置正常精灵(tcp)
    end
end

local 摊位名称 = 查看购买:创建文本('摊位名称本文', 72, 49, 173, 14)

local 标签控件 = 查看购买:创建标签('标签控件', 0, 0, 391, 500)
local 出售按钮 = 标签控件:创建小标签按钮('出售按钮', 18, 90, '出售')
出售按钮.是否选中 = true
function 出售按钮:左键弹起()
    查看购买:置精灵(__res:getspr('ui/ckgm.png'))
    if _P then
        local 外形, 摊名, 现金, 物品, 召唤 = __rpc:角色_摆摊查看出售(_P.nid)
        if 外形 then
            头像按钮:置头像(外形)
            摊位名称:置文本(摊名)
            出售区域.现金文本:置文本(银两颜色(现金))
            出售区域.道具网格:加载道具(物品)
            出售区域.召唤网格:加载召唤(召唤)
            出售区域.物品栏1:置选中(true, false)
        end
    end

end

出售按钮:置选中(true)
local 收购按钮 = 标签控件:创建小标签按钮('收购按钮', 66, 90, '收购')
function 收购按钮:左键弹起()
    查看购买:置精灵(__res:getspr('ui/cksg.png'))
    if _P then
        local 外形, 摊名, 物品 = __rpc:角色_摆摊查看收购(_P.nid)
        if 外形 then
            头像按钮:置头像(外形)
            摊位名称:置文本(摊名)
            收购区域.收购网格:清空()
            for i, v in ipairs(物品) do
                收购区域.收购网格:添加(i, { 名称 = v.名称, 数量 = v.数量, 价格 = v.单价 })
            end
        end
    end
end

local 展开按钮 = 查看购买:创建按钮('展开按钮', 376, 220)
function 展开按钮:初始化(v)
    self:置正常精灵(取按钮精灵('gires/0x56F796BC.tcp', 1, '>'))
    self:置按下精灵(取按钮精灵('gires/0x56F796BC.tcp', 2, '>', 1, 1))
    self:置经过精灵(取按钮精灵('gires/0x56F796BC.tcp', 3, '>'))
end

function 展开按钮:左键弹起()
    记录区域:置可见(not 记录区域.是否可见)
end

出售区域 = 标签控件:创建区域(出售按钮, 0, 0, 391, 490)
do
    local _ENV = setmetatable({}, { __index = _ENV })
    local _单价, _数量 = 0, 0
    local 选中对象 = 出售区域:创建物品召唤按钮('选中对象', 22, 413)
    function 选中对象:右键弹起()
        if self.对象 then
            local t, d = __rpc:角色_查看对象(self.对象.nid)
            if t == 1 then --物品
                local r = require('界面/数据/物品')(d)
                窗口层:打开物品提示(r)
            elseif t == 2 then --召唤
                窗口层:打开召唤兽查看(d)
            end
        end
    end

    选中对象.左键弹起 = 选中对象.右键弹起

    for k, v in pairs { '单价文本', '总价文本', '现金文本' } do
        _ENV[v] = 出售区域:创建文本(v, 129, 417 + k * 26 - 26, 156, 14)
    end

    local 数量输入 = 出售区域:创建数字输入('数量输入', 23, 472, 49, 14)
    数量输入:置颜色(255, 255, 255, 255)
    function 数量输入:输入数值(n)
        _数量 = n
        _单价 = _单价 or 999999999
        总价文本:置文本(银两颜色(_单价 * _数量))
    end

    local 道具网格 = 出售区域:创建物品网格2('道具网格', 21, 118, 309, 207)
    function 道具网格:加载道具(list)
        self.列表 = {}
        for i, v in ipairs(list) do
            list[i] = require('界面/数据/物品')(v)
        end
        for i = 1, #list, 24 do
            table.insert(self.列表, { table.unpack(list, i, i + 23) })
        end
        self:刷新道具(1)
    end

    function 道具网格:刷新道具(i)
        self.数据 = {}
        if self.列表[i] then
            for i, v in ipairs(self.列表[i]) do
                self.数据[i] = v
            end
        end
    end

    function 道具网格:左键弹起(x, y, i)
        local t = self.数据[i]
        if t then
            单价文本:置文本(银两颜色(t.价格 or 999999999))
            _单价 = t.价格 or 999999999

            选中对象.对象 = t
            选中对象:置物品图(t.id)

            数量输入.最大值 = t.数量
            if t ~= self.上次选中 then
                self.上次选中 = t
                数量输入:置文本('1')
            elseif 数量输入:取数值() < t.数量 then
                数量输入:置文本(数量输入:取数值() + 1)
            end
            _数量 = 数量输入:取数值()
            总价文本:置文本(银两颜色(_单价 * _数量))
        end
    end

    local 召唤网格 = 出售区域:创建网格('召唤网格', 21, 351, 338, 51)

    function 召唤网格:初始化()
        self:创建格子(56, 51, 1, 1, 1, 6)
        self.p = 1
    end

    function 召唤网格:刷新()
        for i = 1, 6 do
            self[i]:删除控件()
        end
        if not self.列表[self.p] then
            return
        end
        for i, v in ipairs(self.列表[self.p]) do
            local an = self[i]:创建召唤头像按钮('头像按钮', 7, 5):置头像(v.原形 or v.外形)
            an.nid = v.nid

            function an:左键弹起()
                单价文本:置文本(银两颜色(v.价格))
                _单价 = v.价格

                选中对象.对象 = self
                选中对象:置召唤图(v.原形 or v.外形)
                数量输入.最大值 = 1
                数量输入:置文本('1')
                _数量 = 1
                总价文本:置文本(银两颜色(_单价 * _数量))
            end

            function an:右键弹起()
                local t, d = __rpc:角色_查看对象(self.nid)
                if t == 2 then --召唤
                    窗口层:打开召唤兽查看(d)
                end
            end
        end
    end

    function 召唤网格:加载召唤(list)
        self.列表 = {}

        if type(list) == 'table' then
            self.列表 = {}

            for i = 1, #list, 6 do
                table.insert(self.列表, { table.unpack(list, i, i + 5) })
            end
            self.p = 1

            出售区域.上翻按钮:置禁止(true)
            出售区域.下翻按钮:置禁止(#list < 7)
            self:刷新()
        end
    end

    function 召唤网格:下一页()
        if not self.列表[self.p + 1] then
            return
        end
        self.p = self.p + 1
        出售区域.上翻按钮:置禁止(false)
        出售区域.下翻按钮:置禁止(self.列表[self.p + 1] == nil)
        self:刷新()
    end

    function 召唤网格:上一页()
        if not self.列表[self.p - 1] then
            return
        end
        self.p = self.p - 1
        出售区域.上翻按钮:置禁止(self.列表[self.p - 1] == nil)
        出售区域.下翻按钮:置禁止(false)
        self:刷新()
    end

    local 上翻按钮 = 出售区域:创建向上按钮('上翻按钮', 362, 348)
    function 上翻按钮:左键弹起()
        召唤网格:上一页()
    end

    local 下翻按钮 = 出售区域:创建向下按钮('下翻按钮', 362, 385)
    function 下翻按钮:左键弹起()
        召唤网格:下一页()
    end

    local 购买按钮 = 出售区域:创建小按钮('购买按钮', 315, 438, '购买')
    function 购买按钮:左键弹起()
        if _单价 > 0 and _数量 > 0 and 选中对象.对象 then
            local nid = 选中对象.对象.nid
            if __rpc:角色_摆摊购买(_P.nid, nid, _数量, _单价) then
                窗口层:打开查看购买(_P)
            end
        end
    end
end

收购区域 = 标签控件:创建区域(收购按钮, 0, 0, 391, 480)
do
    local _ENV = setmetatable({}, { __index = _ENV })
    local _单价, _数量, _可售数量, _格子, _收购单价, _收购物品 = 0, 0, 0, 0, 0, ""
    local 收购网格 = 收购区域:创建商店网格('收购网格', 22, 153, 338, 107)

    function 收购网格:初始化()
        self:创建格子(55, 51, 5, 2, 2, 6)
        self.数据 = {}
    end

    function 收购网格:左键弹起(x, y, i)
        if self.数据[i] then
            local r = __rpc:角色_收购可出售(self.数据[i].名称)
            if r then
                收购区域.可出售网格:清空()
                for k, v in pairs(r) do
                    收购区域.可出售网格:添加(k,
                        { 名称 = v.名称, 数量 = v.数量, nid = v.nid, id = v.id, 价格 = self.数据[i].价格 })
                end
                _格子 = i
                _收购单价 = self.数据[i].价格
                _收购物品 = self.数据[i].名称
            end

        end
    end

    local 可出售网格 = 收购区域:创建商店网格('可出售网格', 22, 301, 338, 51)
    do
        function 可出售网格:初始化()
            self:创建格子(55, 51, 5, 2, 1, 6)
            self.数据 = {}
        end

        function 可出售网格:左键弹起(x, y, i)
            if self.数据[i] then
                收购区域.选中对象.对象 = self.数据[i]
                收购区域.选中对象:置物品图(self.数据[i].id)
                _数量 = 1
                _单价 = self.数据[i].价格
                _可售数量 = self.数据[i].数量
                收购区域.数量输入:置文本(_数量)
                收购区域.单价文本:置文本(银两颜色(_单价))
                收购区域.总价文本:置文本(银两颜色(_数量 * _单价))
            end
        end
    end

    local 选中对象 = 收购区域:创建物品召唤按钮('选中对象', 66, 382)
    do
        function 选中对象:右键弹起()

        end

        function 选中对象:获得鼠标(x, y)
            if self.对象 then
                self:物品提示(x, y, self.对象)
            end
        end
    end

    local 单价文本 = 收购区域:创建文本('单价文本', 175, 389, 156, 14)
    local 总价文本 = 收购区域:创建文本('总价文本', 175, 415, 156, 14)
    local 数量输入 = 收购区域:创建数字输入('数量输入', 120, 453, 96, 14)
    数量输入:置颜色(255, 255, 255, 255)
    function 数量输入:输入数值(v)
        if v <= _可售数量 then
            _数量 = v
            总价文本:置文本(银两颜色(_单价 * _数量))
        else
            self:置数值(_可售数量)
            _数量 = _可售数量
            总价文本:置文本(银两颜色(_单价 * _数量))
        end
    end

    local 出售按钮2 = 收购区域:创建小按钮('出售按钮', 257, 448, '出售')
    function 出售按钮2:左键弹起()
        local t = 选中对象.对象
        if t and _单价 > 0 and _数量 > 0 and _数量 <= _可售数量 and _格子 ~= 0 then
            local r = __rpc:角色_收购卖出(_P.nid, t.nid, _收购物品, _收购单价, _格子, _数量, _单价)
            local 当前选中 = 收购网格.当前选中
            local 可出售选中 = 可出售网格.当前选中
            窗口层:打开查看购买(_P)
            if r == 0 then
                收购区域.可出售网格:清空()
                _收购物品 = ""
                _收购单价 = 0
                _格子 = 0
                选中对象:清空()
            else
                收购网格:置选中(当前选中)
                收购网格:左键弹起(0, 0, 当前选中)
                可出售网格:置选中(可出售选中)

            end
        elseif not t then
            窗口层:提示窗口("#Y请先选择要出售的物品。")
        elseif _数量 == 0 then
            窗口层:提示窗口("#Y请先输入出售物品数量！")
        elseif _数量 > _可售数量 then
            窗口层:提示窗口("#Y你没有那么多道具！")
        end
    end



end


记录区域 = 查看购买:创建控件('记录区域', 393, 9, 265, 450)
do
    function 记录区域:初始化()
        self:置精灵(__res:getspr('ui/jyjl.png'))
    end

    local 广告文本 = 记录区域:创建文本("广告文本", 3, 20, 242, 115)
    广告文本:置文本("该玩家很懒，什么都没留下。")
    广告文本:创建我的滑块()
    local 记录文本 = 记录区域:创建文本("记录文本", 3, 160, 244, 287)
    记录文本:创建我的滑块()
    local 提示文本 = 记录区域:创建我的文本("提示文本", 6, 120, 244, 16)
    提示文本:置文本(" #71此广告为摊主填写，谨防受骗")
    function 记录区域:刷新摆摊记录(t)
        if type(t) ~= "table" then
            return
        end
        local list = {}
        local 交易for = "#Y玩家#R%s#Y花费%s#Y购买了#R%s#Y个#G%s" --玩家id,总价,数量，名称
        local 收购for = "#Y店主以%s#Y的价格收购了玩家#R%s#Y的#R%s#Y个#G%s" --总价，玩家id，数量，名称
        for i, v in ipairs(t) do
            if i < 101 then
                v.玩家 = v.玩家 + 10000
                local xid = string.gsub(string.reverse(v.玩家), '%d%d%d', '***', 1):reverse()
                if v.类型 == 1 then --交易记录
                    table.insert(list, 交易for:format(xid, 银两颜色(v.总价), v.数量, v.名称))
                else --收购记录
                    table.insert(list, 收购for:format(银两颜色(v.总价), xid, v.数量, v.名称))
                end
            end
        end
        self.记录文本:清空()
        local s = table.concat(list, "#r")
        self.记录文本:置文本(s)

    end

    local 更新按钮 = 记录区域:创建按钮('更新按钮', 213, 430)
    function 更新按钮:初始化()
        self:置正常精灵(取按钮精灵2('ui/xx1.png', '刷新'))
        self:置按下精灵(取按钮精灵2('ui/xx3.png', '刷新', 1, 1))
        self:置经过精灵(取按钮精灵2('ui/xx2.png', '刷新'))
    end

    function 更新按钮:左键弹起()
        if _P then
            local r = __rpc:角色_查询交易记录(_P.nid)
            if r then
                记录区域:刷新摆摊记录(r)
            end
        end

    end

end





function 窗口层:打开查看购买(P)
    if not P.是否摆摊 then
        return
    end
    查看购买:置可见(true)

    _P = P
    if 出售按钮.是否选中 then
        local 外形, 摊名, 现金, 物品, 召唤, 广告 = __rpc:角色_摆摊查看出售(P.nid)
        if 外形 then
            头像按钮:置头像(外形)
            摊位名称:置文本(摊名)
            出售区域.现金文本:置文本(银两颜色(现金))
            出售区域.道具网格:加载道具(物品)
            出售区域.召唤网格:加载召唤(召唤)
            出售区域.物品栏1:置选中(true, false)
            记录区域.广告文本:置文本(广告)
        end
    elseif 收购按钮.是否选中 then
        local 外形, 摊名, 物品, 广告 = __rpc:角色_摆摊查看收购(P.nid)
        if 外形 then
            头像按钮:置头像(外形)
            摊位名称:置文本(摊名)
            收购区域.收购网格:清空()
            for i, v in ipairs(物品) do
                收购区域.收购网格:添加(i, { 名称 = v.名称, 数量 = v.数量, 价格 = v.单价 })
            end
            记录区域.广告文本:置文本(广告)
        end
    end

end

return 查看购买
