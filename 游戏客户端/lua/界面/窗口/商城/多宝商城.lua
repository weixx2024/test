

local 多宝阁 = 窗口层:创建我的窗口('多宝阁', 0, 0, 736, 485)
function 多宝阁:初始化()
    self:置精灵(
        self:取老红木窗口(
            self.宽度,
            self.高度,
            '多宝阁',
            function()
                self:取拉伸图像_宽高('gires/main/border.bmp', 100, 20):显示(100,
                    self.高度 - 52)
                __res.JMZ:取图像('拥有积分'):显示(25, self.高度 - 51)
                self:取拉伸图像_宽度('gires4/jdmh/yjan/jmfk3.tcp', 700):显示(19, 66) -- 仙玉
                self:取拉伸图像_宽高('gires/main/border.bmp', 66, 20):显示(340,
                    435) -- 页数
            end
        )
    )
end

多宝阁:创建关闭按钮()

仙玉文本 = 多宝阁:创建文本("仙玉文本", 104, 435, 92, 14)
提示文本 = 多宝阁:创建文本("提示文本", 21, 82, 600, 20)
页数文本 = 多宝阁:创建文本("页数文本", 362, 436, 58, 14)
页数文本:置文本('-/-')
提示文本:置文本("瞧一瞧看一看，这里有最时尚、最受欢迎的商品!")
--===============================================================================================
标签控件 = 多宝阁:创建标签('标签控件', 0, 0, 736, 485)

local 商品列表 = 多宝阁:创建多列列表('商品列表', 20, 100, 697, 299)
do
    function 商品列表:初始化()
        self.行高度 = 100
        self.选中精灵 = nil
        self.焦点精灵 = nil
        self:添加列(0, 10, 229, 100) --1
        self:添加列(234, 10, 229, 100) --2
        self:添加列(468, 10, 229, 100) --3
        self.商品背景 = self:取拉伸精灵_宽高('gires4/jdmh/ckdt/jdmb3.tcp', 229, 90)
        self.商品格子 = require('SDL.精灵')(0, 0, 0, 72, 72):置颜色(0, 0, 0)
        self.热卖 = __res:getspr('gires/common/sc/rm.tcp')
        self.抢完 = __res:getspr('gires/common/sc/qw.tcp')
    end

    function 商品列表:添加商品(list)
        self:清空()
        local r = self:添加()
        for i, v in ipairs(list) do
            local n = i % 3
            if n == 0 then
                n = 3
            end
            local 商品名称 = __res.F14:取精灵(v.名称)
            r[n].获得鼠标 = function(_, x, y)
                if v:检查点(x, y) then
                    self:物品提示(x + 30, y + 30, v)
                end
            end
            local 卖空 = false
            if v.限量 and v.限量 <= 0 then
                卖空 = true
            end
            if v.结束时间 and os.time() > v.结束时间 then
                卖空 = true
            end
            r.商品编号 = v.名称
            r[n].显示 = function(_, x, y)
                self.商品背景:显示(x, y)
                self.商品格子:显示(x + 10, y + 10)
                商品名称:显示(x + 92, y + 10)
                v:显示(x + 10, y + 10)

            end
            r[n].前显示 = function(_, x, y)
                if v.热卖 then
                    self.热卖:显示(x + 7, y + 3)
                end
                if 卖空 then
                    self.抢完:显示(x + 7, y + 15)
                end
               
            end
            local 文本 = r[n]:创建文本('描述文本', 92, 33, 125, 35)
            文本:置文字(__res.F13)
            文本:置文本('价格:#G%s#W积分', v.价格)
            local an = r[n]:创建小按钮('购买按钮', 93, 55, '购买', 51)
            function an:左键弹起()
                窗口层:打开确认购买窗口(v, _仙玉, _当前页, v.i)
            end
            r[n]:置可见(true, true)
            if i % 3 == 0 then
                r = self:添加()
            end
        end
    end
end

do
    local 首页按钮 = 多宝阁:创建小小按钮('首页按钮', 280, 436, '首页', 34)
    function 首页按钮:左键弹起()
    end

    local 末页按钮 = 多宝阁:创建小小按钮('末页按钮', 430, 436, '末页', 34)
    function 末页按钮:左键弹起()
    end

    local 上一页按钮 = 多宝阁:创建按钮('上一页按钮', 320, 435)
    function 上一页按钮:初始化()
        self:设置按钮精灵('gires4/jdmh/yjan/zjan.tcp')
    end

    function 上一页按钮:左键弹起()
        商品列表:向上滚动()
    end

    local 下一页按钮 = 多宝阁:创建按钮('下一页按钮', 406, 435)
    function 下一页按钮:初始化()
        self:设置按钮精灵('gires4/jdmh/yjan/yjan.tcp')
    end

    function 下一页按钮:左键弹起()
        商品列表:向下滚动()
    end
end

function 多宝阁:创建分类(名称, i)
    local 按钮 = 标签控件:创建商城标签按钮(名称, 42 + i * 72 - 72, 26, 名称, 70)
    按钮:置可见(true)
    function 按钮:选中事件(v)
        if v then
            _当前页 = i
            多宝阁:刷新商品(__rpc:角色_商城商品列表(i))
        end

    end

    return 按钮
end

function 多宝阁:刷新商品(商品)
    if type(商品) ~= 'table' then
        return
    end
    for i, v in ipairs(商品) do
        v.i = i
        商品[i] = require('界面/数据/物品')(v):到商城()
    end
    商品列表:添加商品(商品)
end

function 窗口层:刷新仙玉()
    local n = __rpc:角色_取仙玉()
    仙玉文本:置文本(银两颜色(n))
end

function 窗口层:打开多宝阁()
    多宝阁:置可见(not 多宝阁.是否可见)
    if not 多宝阁.是否可见 then
        return
    end
    多宝阁:置坐标((800 - 多宝阁.宽度) // 2, (600 - 多宝阁.高度) // 2)
    local 分类, 仙玉 = __rpc:角色_打开商城()
    _仙玉 = 仙玉
    if type(分类) == 'table' then
        仙玉文本:置文本(银两颜色(仙玉))
        标签控件:删除控件()

        for i, k in ipairs(分类) do
            多宝阁:创建分类(k, i)
        end

        if 分类[1] then
            标签控件[分类[1]]:置选中(true)
        end
    end
end

return _ENV
