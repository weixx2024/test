local 摆摊盘点 = 窗口层:创建我的窗口('摆摊盘点', 0, 0, 663, 516) --391
local _收购库 = require("数据/回收库")
local _回收列表 = {
    { 名称 = "不限制属性物品", 类型 = "我的收购" },
    { 名称 = "最近收购列表", 类型 = "我的收购" },
    { 名称 = "原料", 类型 = "作坊" },
    { 名称 = "培养物品", 类型 = "召唤兽" },
    { 名称 = "合成物品", 类型 = "召唤兽" },
    { 名称 = "矿石", 类型 = "打造" },
    { 名称 = "高级培养", 类型 = "打造" },
    { 名称 = "百分比药", 类型 = "药品" },
    { 名称 = "双加药", 类型 = "药品" },
    { 名称 = "生育用品", 类型 = "养育系统" },
    { 名称 = "引导物品", 类型 = "养育系统" },
    { 名称 = "培养用品", 类型 = "养育系统" },
    { 名称 = "学习用品", 类型 = "养育系统" },
    { 名称 = "挖宝", 类型 = "其他" },
    { 名称 = "变身卡", 类型 = "其他" },
    { 名称 = "属性卡", 类型 = "其他" },
}
function 摆摊盘点:初始化()
    self:置精灵(__res:getspr('ui/pantan1.png'))
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
    self.禁止滚动 = true
end

--摆摊盘点:创建关闭按钮()

local 按钮 = 摆摊盘点:创建按钮('关闭按钮', 391 - 25, 0)
function 按钮:初始化(v)
    local tcp = __res:get('gires/0xF11233BB.tcp')
    self:置正常精灵(tcp:取精灵(1))
    self:置按下精灵(tcp:取精灵(2))
    self:置经过精灵(tcp:取精灵(3))
end

function 按钮:左键弹起()
    self.父控件:置可见(false)
end

local 头像按钮 = 摆摊盘点:创建人物头像按钮('人物头像按钮', 22, 34)
function 头像按钮:左键弹起()

end

function 头像按钮:置头像(id)
    local tcp = __res:getspr('photo/facesmall/%s.tga', id)
    if tcp then
        self:置正常精灵(tcp)
    end
end

local 摊位名称输入 = 摆摊盘点:创建文本输入('摊位名称输入', 72, 49, 173, 14)
摊位名称输入:置颜色(255, 255, 255, 255)
摊位名称输入:置限制字数(6)

local 改名按钮 = 摆摊盘点:创建按钮('改名按钮', 245, 47)
function 改名按钮:初始化()
    self:置正常精灵(取按钮精灵2('ui/xx1.png', '更改'))
    self:置按下精灵(取按钮精灵2('ui/xx3.png', '更改', 1, 1))
    self:置经过精灵(取按钮精灵2('ui/xx2.png', '更改'))
end

function 改名按钮:左键弹起()
    local r = 摊位名称输入:取文本()
    if r and r ~= '' then
        if require("数据/敏感词库")(r, 1) then
            窗口层:提示窗口("#Y你的摊位名称包含敏感词汇！")
            return
        end
        __rpc:角色_摆摊改名(摊位名称输入:取文本())
    end
end

local 收摊按钮 = 摆摊盘点:创建小按钮('收摊按钮', 300, 44, '收摊')
function 收摊按钮:左键弹起()
    __rpc:角色_摆摊收摊()
    摆摊盘点:置可见(false)
end

local 展开按钮 = 摆摊盘点:创建按钮('展开按钮', 376, 220)
function 展开按钮:初始化(v)
    self:置正常精灵(取按钮精灵('gires/0x56F796BC.tcp', 1, '>'))
    self:置按下精灵(取按钮精灵('gires/0x56F796BC.tcp', 2, '>', 1, 1))
    self:置经过精灵(取按钮精灵('gires/0x56F796BC.tcp', 3, '>'))
end

function 展开按钮:左键弹起()
    记录区域:置可见(not 记录区域.是否可见)
end

local 标签控件 = 摆摊盘点:创建标签('标签控件', 0, 0, 391, 516)
local 出售按钮 = 标签控件:创建小标签按钮('出售按钮', 18, 90, '出售')

function 出售按钮:选中事件(v)
    if v then
        摆摊盘点:置精灵(__res:getspr('ui/pantan1.png'))
        出售区域:打开()
    end
end

local 收购按钮 = 标签控件:创建小标签按钮('收购按钮', 66, 90, '收购')



function 收购按钮:选中事件(v)
    if v then
        摆摊盘点:置精灵(__res:getspr('ui/sgsz.png'))
        收购区域:打开()
    end
end

出售区域 = 标签控件:创建区域(出售按钮, 0, 0, 391, 516)
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

    数量文本 = 出售区域:创建文本('数量文本', 23, 472, 49, 14)
    for k, v in pairs { '总价文本', '现金文本' } do
        _ENV[v] = 出售区域:创建文本(v, 129, 443 + k * 26 - 26, 156, 14)
    end


    单价输入 = 出售区域:创建金额输入('单价输入', 129, 417, 156, 14)
    单价输入:置颜色(255, 255, 255, 255)
    function 单价输入:输入数值(v)
        _单价 = v
        总价文本:置文本(银两颜色(_单价 * _数量))
    end

    道具网格 = 出售区域:创建物品网格2('道具网格', 21, 118, 309, 207)
    function 道具网格:左键弹起(x, y, i)
        local t = self.数据[i]
        if t then
            if t.单价 then
                单价输入:置文本(t.单价)
                _单价 = t.单价
            end
            上架按钮:置选中(t.单价 ~= nil, false)
            更新按钮:置禁止(t.单价 == nil)

            选中对象.对象 = t
            数量文本:置文本(t.数量)
            选中对象:置物品图(t.id)

            _数量 = t.数量
            总价文本:置文本(银两颜色(_单价 * _数量))
        end
    end

    召唤网格 = 出售区域:创建网格('召唤网格', 21, 351, 338, 51)
    do
        local sellmark = __res:getspr('gires2/main/sellmark.tcp')
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
                an.单价 = v.单价
                function an:前显示(x, y)
                    if self.单价 then
                        sellmark:显示(x, y)
                    end
                end

                function an:上架(单价)
                    self.单价 = 单价
                    v.单价 = 单价
                end

                function an:下架()
                    self.单价 = nil
                    v.单价 = nil
                end

                function an:左键弹起()
                    if self.单价 then
                        单价输入:置文本(self.单价)
                        _单价 = self.单价
                    end
                    上架按钮:置选中(self.单价 ~= nil, false)
                    更新按钮:置禁止(self.单价 == nil)
                    选中对象.对象 = self
                    选中对象:置召唤图(v.原形 or v.外形)
                    数量文本:置文本('1')
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

        function 召唤网格:打开()
            self.列表 = {}
            local list = __rpc:角色_召唤列表()
            if type(list) == 'table' then
                self.列表 = {}
                时间排序(list)

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
    end

    function 出售区域:打开()
        道具网格:打开()
        召唤网格:打开()
        现金文本:置文本(银两颜色(_现金))
    end

    上架按钮 = 出售区域:创建我的多选按钮3('上架按钮', 300, 412, '上架', '下架')
    function 上架按钮:选中事件(v)
        if not _单价 or _单价 == 0 then
            -- 窗口层:提示窗口('#Y商品单价必须大于0并且总价不能超过999亿。')
            -- self:置选中(false, false)
            return  false
        end
        -- if 选中对象.对象 then
        --     local nid = 选中对象.对象.nid
        --     if v then
        --         if __rpc:角色_摆摊上架(nid, _单价) then
        --             选中对象.对象:上架(_单价)
        --             更新按钮:置禁止(false)
        --         else
        --             self:置选中(false, false)
        --         end
        --     else
        --         if __rpc:角色_摆摊下架(nid) then
        --             选中对象.对象:下架()
        --             更新按钮:置禁止(true)
        --         else
        --             self:置选中(true, false)
        --         end
        --     end
        -- end
    end


    function 上架按钮:左键弹起()
        if 选中对象.对象 then
            local nid = 选中对象.对象.nid
            if not self.是否选中 then
                if __rpc:角色_摆摊上架(nid, _单价) then
                    选中对象.对象:上架(_单价)
                    更新按钮:置禁止(false)
                else
                    self:置选中(false, false)
                end
            else
                if __rpc:角色_摆摊下架(nid) then
                    选中对象.对象:下架()
                    更新按钮:置禁止(true)
                else
                    self:置选中(true, false)
                end
            end
        end
    end

    更新按钮 = 出售区域:创建小按钮('更新按钮', 300, 438, '更新')
    function 更新按钮:左键弹起()
        上架按钮:选中事件(true)
    end

    local 预览按钮 = 出售区域:创建小按钮('预览按钮', 300, 464, '预览')
    function 预览按钮:左键弹起()
        窗口层:打开查看购买(__rol)
    end
end

收购区域 = 标签控件:创建区域(收购按钮, 0, 0, 391, 516)
do
    local _ENV = setmetatable({}, { __index = _ENV })
    local _单价, _数量, _预支 = 0, 0, 0
    local _总类, _分类 = 0, 0
    local 选中对象 = 收购区域:创建物品召唤按钮('选中对象', 205, 289)
    function 选中对象:右键弹起()

    end

    function 选中对象:获得鼠标(x, y)

        if self.对象 then
            self:物品提示(x, y, self.对象)
        end

    end

    local 收购列表 = 收购区域:创建树形列表('收购列表', 24, 138, 106, 148)
    do
        function 收购列表:初始化()
            self.缩进宽度 = 20
            self.行高度 = 20
            self.分类 = {}
            self:置颜色(255, 255, 255)

            for k, v in pairs(_回收列表) do
                self:列表添加(v)
            end
        end

        function 收购列表:任务清空()
            self.分类 = {}
            self:清空()
        end

        function 收购列表:列表添加(t)
            if type(t) == 'table' then
                local 类型 = t.类型 or '其它'
                local 分类 = self.分类[类型]
                if not 分类 then
                    分类 = self:添加(类型)
                    local 收展 = 分类:创建收展按钮(0, 0, 19, 19)
                    function 收展:初始化()
                        self:置正常精灵(__res:getspr('gires4/jdmh/yjan/jiaan.tcp'):置中心(-5,
                            -5))
                        self:置选中正常精灵(__res:getspr('gires4/jdmh/yjan/jianan.tcp'):置中心(-
                            5, -5))
                    end

                    function 分类:更新()

                    end

                    function 分类:列表添加(t)
                        local r = 分类:添加(t.名称)
                        r.分类 = 分类
                        r.名称 = t.名称
                    end

                    分类:置可见(true, true)
                    self.分类[类型] = 分类
                end
                分类:列表添加(t)
                return r
            end
        end

        function 收购列表:左键弹起(x, y, i, item)
            收购列表.选中 = item
            if item.分类 then
                收购区域.物品列表:清空()
                for k, v in pairs(_收购库[item.分类.名称][item.名称]) do
                    _总类, _分类 = item.分类.名称, item.名称
                    收购区域.物品列表:添加物品(k, v)
                end
            end
        end

        收购列表:创建我的滑块()
    end
    local 物品列表 = 收购区域:创建列表('物品列表', 159, 138, 184, 117)
    do
        function 物品列表:添加物品(i, t)
            local r = self:添加(t)
            r:取精灵():置中心(0, -2)
            r:置高度(20)
            r.名称 = t
        end

        function 物品列表:左键弹起(x, y, i, t)
            local r = require('界面/数据/物品')({ 名称 = t.名称 })
            if r then
                选中对象.对象 = r
                选中对象:置物品图(r.id)
                _数量 = 1
                数量输入:置数值(1)
                总价文本:置文本(银两颜色(_数量 * _单价))
                收购区域.等级文本:置文本("--")
            end
        end
    end
    物品列表:创建我的滑块()
    local 搜索输入 = 收购区域:创建文本输入('搜索输入', 160, 267, 137, 14)
    搜索输入:置颜色(255, 255, 255, 255)

    function 搜索输入:输入事件()
        local t = self:取文本()
        if t == "" then
            if _总类 ~= 0 and _分类 ~= 0 and _收购库[_总类][_分类] then
                收购区域.物品列表:清空()
                for k, v in pairs(_收购库[_总类][_分类]) do
                    收购区域.物品列表:添加物品(k, v)
                end
            end
            return
        end
        收购区域.物品列表:清空()
        for _, v in pairs(_回收列表) do
            if _收购库[v.类型][v.名称] then
                for _, k in pairs(_收购库[v.类型][v.名称]) do
                    if string.find(k, t) then
                        收购区域.物品列表:添加物品(1, k)
                    end
                end
            end
        end
    end

    单价输入 = 收购区域:创建金额输入('单价输入', 67, 303, 126, 14)
    单价输入:置颜色(255, 255, 255, 255)

    function 单价输入:输入数值(v)
        if v * _数量 <= _现金 - _预支 then
            _单价 = v
            总价文本:置文本(银两颜色(_单价 * _数量))
        else
            self:置数值(_单价)
        end
    end

    数量输入 = 收购区域:创建数字输入('数量输入', 208, 349, 50, 14)
    数量输入:置颜色(255, 255, 255, 255)
    function 数量输入:输入数值(v)
        if _单价 * v <= _现金 - _预支 then
            _数量 = v
            总价文本:置文本(银两颜色(_单价 * _数量))
        else
            self:置数值(_数量)
            --窗口层:提示窗口(...)
        end
    end

    for k, v in pairs { '总价文本', '现金文本' } do
        _ENV[v] = 收购区域:创建文本(v, 67, 326 + k * 23 - 23, 126, 14)
    end
    收购区域:创建文本('等级文本', 305, 303, 57, 14)


    local 收购网格 = 收购区域:创建商店网格('收购网格', 24, 375, 338, 107)
    function 收购网格:初始化()
        self:创建格子(55, 51, 5, 2, 2, 6)
        self.数据 = {}
    end

    function 收购网格:左键弹起(x, y, i)
        if self.数据[i] then
            local r = require('界面/数据/物品')({ 名称 = self.数据[i].名称 })
            if r then
                选中对象.对象 = r
                选中对象:置物品图(r.id)
                _单价 = self.数据[i].价格
                _数量 = self.数据[i].数量
                总价文本:置文本(银两颜色(_数量 * _单价))
                单价输入:置文本(银两颜色(_单价))
                数量输入:置文本(_数量)
            end
        end
    end

    function 收购网格:右键弹起(x, y, i)
        if self.数据[i] then
            local r = __rpc:角色_收购下架(i, self.数据[i].名称, self.数据[i].价格, self.数据[i].数量)
            if r then
                收购网格:清空()
                _预支 = 0
                for k, v in ipairs(r) do
                    收购网格:添加(k, { 名称 = v.名称, 数量 = v.数量, 价格 = v.单价 })
                    _预支 = _预支 + v.数量 * v.单价
                end
            end
        end
    end

    local 搜索按钮 = 收购区域:创建小按钮('搜索按钮', 321, 261, '搜索')
    function 搜索按钮:左键弹起()
        local t = 搜索输入:取文本()
        if t == "" then
            return
        end
        收购区域.物品列表:清空()
        for _, v in pairs(_回收列表) do
            if _收购库[v.类型][v.名称] then
                for _, k in pairs(_收购库[v.类型][v.名称]) do
                    if string.find(k, t) then
                        收购区域.物品列表:添加物品(1, k)
                    end
                end
            end
        end
    end

    local 收购按钮 = 收购区域:创建中按钮('收购按钮', 282, 343, '收  购')

    function 收购按钮:左键弹起()
        local t = 选中对象.对象
        if t and _单价 > 0 and _数量 > 0 and _单价 * _数量 <= _现金 - _预支 then

            local r = __rpc:角色_收购上架(t.名称, _单价, _数量)
            if r then
                收购区域:刷新收购信息(r)
            end
        elseif not t then
            窗口层:提示窗口("#Y请先选择要收购的物品。")
        elseif _单价 == 0 then
            窗口层:提示窗口("#Y请先输入收购物品单价！")
        elseif _数量 == 0 then
            窗口层:提示窗口("#Y请先输入收购物品数量！")
        elseif _单价 * _数量 <= _现金 - _预支 then
            窗口层:提示窗口("#Y你身上的现金已经不能满足所有的收购需求。")
        end
    end

    function 收购区域:刷新收购信息(r)
        _预支 = 0
        收购网格:清空()
        for i, v in ipairs(r) do
            _预支 = _预支 + v.数量 * v.单价
            收购网格:添加(i, { 名称 = v.名称, 数量 = v.数量, 价格 = v.单价 })
        end
    end

    function 收购区域:打开()
        _预支 = 0
        _单价 = 0
        _数量 = 0
        现金文本:置文本(银两颜色(_现金))
        总价文本:置文本(0)
        单价输入:置文本("")
        数量输入:置文本("")
        local t = __rpc:角色_取收购信息()
        self:刷新收购信息(t)
    end
end

记录区域 = 摆摊盘点:创建控件('记录区域', 393, 9, 270, 450)
do
    function 记录区域:初始化()
        self:置精灵(__res:getspr('ui/jyjl.png'))
    end

    记录区域:创建文本("广告文本", 3, 20, 242, 115)
    记录区域.广告文本:置文本("该玩家很懒，什么都没留下。")
    记录区域.广告文本:创建我的滑块()
    记录区域:创建文本("记录文本", 3, 160, 244, 287):创建我的滑块()

    function 记录区域:刷新摆摊记录(t)
        if type(t) ~= "table" then
            return
        end

        local list = {}
        local 交易for = "#Y玩家#R%s#Y花费%s#Y购买了#R%s#Y个#G%s" --玩家id,总价,数量，名称
        local 收购for = "#Y店主以%s#Y的价格收购了玩家#R%s#Y的#R%s#Y个#G%s" --总价，玩家id，数量，名称
        for i, v in ipairs(t) do
            v.玩家 = v.玩家 + 10000000
            local xid = string.gsub(string.reverse(v.玩家), '%d%d%d%d', '****', 1):reverse()
            if v.类型 == 1 then --交易记录
                table.insert(list, 交易for:format(xid, 银两颜色(v.总价), v.数量, v.名称))
            else --收购记录
                table.insert(list, 收购for:format(银两颜色(v.总价), xid, v.数量, v.名称))
            end
        end

        self.记录文本:清空()
        local s = table.concat(list, "#r")
        self.记录文本:置文本(s)
    end

    local 改广告按钮 = 记录区域:创建按钮('改广告按钮', 213, 120)
    function 改广告按钮:初始化()
        self:置正常精灵(取按钮精灵2('ui/xx1.png', '更改'))
        self:置按下精灵(取按钮精灵2('ui/xx3.png', '更改', 1, 1))
        self:置经过精灵(取按钮精灵2('ui/xx2.png', '更改'))
    end

    function 改广告按钮:左键弹起()
        local r = 窗口层:输入窗口('', "请输入摊位说明，请限制在30个中文(60个英文)内。")
        if r then
            -- if require("数据/敏感词库")(r, 1) then
            --     窗口层:提示窗口("#Y你的广告内包含敏感词汇！")
            --     return
            -- end
            r = require("数据/敏感词库")(r)
            local a = __res.F14:取宽度(r) // 7
            if a <= 60 then
                __rpc:角色_更改摆摊广告(r)
                记录区域.广告文本:置文本(r)
            else
                窗口层:提示窗口("#Y请限制在30个中文(60个英文)内。")
            end
        end
    end
end



function 窗口层:刷新摆摊记录(t)
    if not 摆摊盘点.是否可见 then
        return
    end
    记录区域:刷新摆摊记录(t)

end

function RPC:刷新摆摊记录(t)
    窗口层:刷新摆摊记录(t)
end

出售按钮:置选中(true, false)
function 窗口层:打开摆摊盘点()
    local t = __rpc:角色_摆摊盘点()
    if type(t) ~= 'table' then
        return
    end
    摆摊盘点:置可见(true)
    _收购库.我的收购.最近收购列表 = t.最近收购

    for i, v in ipairs(t.收购) do
        收购区域.收购网格:添加(i, { 名称 = v.名称, 数量 = v.数量, 价格 = v.单价 })
    end
    _现金 = t.银子
    摊位名称输入:置文本(t.摊名)
    头像按钮:置头像(t.头像)
    记录区域.广告文本:置文本(t.广告)
    记录区域:刷新摆摊记录(t.记录)
    if 出售按钮.是否选中 then
        出售按钮:置选中(true)
    else
        收购按钮:置选中(true)
    end
end

return 摆摊盘点
