local 寄售窗口 = 窗口层:创建我的窗口('寄售窗口', 0, 0, 600, 530)
do
    function 寄售窗口:初始化()
        self:置精灵(
            self:取老红木窗口(
                self.宽度,
                self.高度,
                '寄  售',
                function()
                    self:取拉伸图像_宽高('ui/lbdk.png', 560, 380):显示(20, 80)
                    __res.JMZ:取图像('订单编号'):显示(50, 82)
                    __res.JMZ:取图像('名称'):显示(50 + 120, 82)
                    __res.JMZ:取图像('数额'):显示(50 + 240, 82)
                    __res.JMZ:取图像('价格'):显示(50 + 360, 82)
                end
            )
        )
        self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
        self.禁止滚动 = true
    end

    function 寄售窗口:显示(x, y)
    end

    寄售窗口:创建关闭按钮()
end

local 注文本 = 寄售窗口:创建我的文本('注文本', 200, 40, 550, 30)
注文本:置文本("#R注:订单成交后系统将扣除卖方该笔订单5%的收益所得#r最多可同时上架1笔订单")
local 标签控件 = 寄售窗口:创建标签('标签控件', 0, 0, 600, 530)
local 银子按钮 = 标签控件:创建自定义小标签按钮('银子按钮', 21, 56, '银两', 80, 25)
local 积分按钮 = 标签控件:创建自定义小标签按钮('积分按钮', 21 + 85, 56, '积分', 80, 25)
local 银子区域 = 标签控件:创建区域(银子按钮, 20, 97, 560, 365)




do

    local 商品列表 = 银子区域:创建多列列表('商品列表', 6, 10, 551, 345)
    商品列表:置选中精灵宽度(117)
    function 商品列表:初始化()
        self.行高度 = 20
        self:取文字():置大小(20) --350
        self:添加列(10, 3, 120, 20) --nid
        self:添加列(150, 3, 200, 20) --名字
        self:添加列(260, 3, 300, 20) --数额
        self:添加列(390, 3, 500, 20) --价额
        self:置选中精灵宽度(520)
    end

    function 商品列表:添加商品(t)
        local r = self:添加("***********", "银两", t.数额, t.价格)
        r.id = t.id
        r.编号 = t.编号
        r.数额 = t.数额
        r.价格 = t.价格
    end

    function 商品列表:左键弹起(x, y, i, t)
        _商品 = { id = t.id, 编号 = t.编号, 数额 = t.数额, 价格 = t.价格 }
    end

    function 商品列表:刷新当前商品()
        self:清空()
        local 起始 = _银子当前页 * 17 - 16
        local 借宿 = _银子当前页 * 17
        for i = 起始, 借宿, 1 do
            if _商品列表[i] then
                商品列表:添加商品(_商品列表[i], i)
            end

        end

    end

    local 滚动条 = 商品列表:创建滚动条(商品列表.宽度 - 23, 0, 23, 商品列表.高度 + 2)
    local 滑块按钮 = 滚动条:创建滚动按钮(2, 20, 18, 滚动条.高度 - 36)
    local 减少按钮 = 滚动条:创建减少按钮(2, 0)
    local 增加按钮 = 滚动条:创建增加按钮(2, -20)
    do
        function 减少按钮:初始化(v)
            self:设置按钮精灵('gires/0x287AF2DA.tcp')
        end

        function 减少按钮:左键弹起(v)
            if _银子当前页 > 1 then
                _银子当前页 = _银子当前页 - 1
                商品列表:刷新当前商品()
            end
        end

        function 增加按钮:初始化(v)
            self:设置按钮精灵('gires/0x03539D9C.tcp')
        end

        function 增加按钮:左键弹起(v)
            if _银子当前页 < _银子最大页 then
                _银子当前页 = _银子当前页 + 1
                商品列表:刷新当前商品()
            end
        end
    end

    function 银子区域:可见事件(v)
        if not 银子区域.是否实例 then
            return
        end
        self:获取银子商品列表()
    end

    function 银子区域:获取银子商品列表()
        local t = __rpc:角色_获取银子商品列表(_银子当前页)
        商品列表:清空()
        local t2 = {}
        if type(t) == "table" then
            for _, v in pairs(t) do
                if not t.成交 then
                    table.insert(t2, { id = v.id, 获得时间 = v.获得时间, 价格 = v.价格, 编号 = v.编号,
                        数额 = v.数额 })
                end

            end
            时间排序(t2)
            _银子当前页 = 1
            _银子最大页 = math.ceil(#t2 / 17)
            _商品列表 = t2
            for i = 1, 17, 1 do
                if t2[i] then
                    商品列表:添加商品(t2[i], i)
                end

            end
        end

    end
end
local 积分区域 = 标签控件:创建区域(积分按钮, 20, 97, 560, 365)
do
    local 商品列表 = 积分区域:创建多列列表('商品列表', 6, 10, 551, 345)
    商品列表:置选中精灵宽度(117)
    function 商品列表:初始化()
        self.行高度 = 20
        self:取文字():置大小(20) --350
        self:添加列(10, 3, 120, 20) --nid
        self:添加列(150, 3, 200, 20) --名字
        self:添加列(260, 3, 300, 20) --数额
        self:添加列(390, 3, 500, 20) --价额
        self:置选中精灵宽度(520)

    end

    function 商品列表:添加商品(t)
        local r = self:添加("***********", "积分", t.数额, t.价格)
        r.id = t.id
        r.编号 = t.编号
        r.数额 = t.数额
        r.价格 = t.价格
    end

    function 商品列表:左键弹起(x, y, i, t)
        _商品 = { id = t.id, 编号 = t.编号, 数额 = t.数额, 价格 = t.价格 }
    end

    function 商品列表:刷新当前商品()
        self:清空()
        local 起始 = _积分当前页 * 17 - 16
        local 借宿 = _积分当前页 * 17
        for i = 起始, 借宿, 1 do
            if _商品列表[i] then
                商品列表:添加商品(_商品列表[i], i)
            end

        end

    end

    local 滚动条 = 商品列表:创建滚动条(商品列表.宽度 - 23, 0, 23, 商品列表.高度 + 2)
    local 滑块按钮 = 滚动条:创建滚动按钮(2, 20, 18, 滚动条.高度 - 36)
    local 减少按钮 = 滚动条:创建减少按钮(2, 0)
    local 增加按钮 = 滚动条:创建增加按钮(2, -20)
    do
        function 减少按钮:初始化(v)
            self:设置按钮精灵('gires/0x287AF2DA.tcp')
        end

        function 减少按钮:左键弹起(v)
            if _积分当前页 > 1 then
                _积分当前页 = _积分当前页 - 1
                商品列表:刷新当前商品()
            end
        end

        function 增加按钮:初始化(v)
            self:设置按钮精灵('gires/0x03539D9C.tcp')
        end

        function 增加按钮:左键弹起(v)
            if _积分当前页 < _积分最大页 then
                _积分当前页 = _积分当前页 + 1
                商品列表:刷新当前商品()
            end
        end
    end
    function 积分区域:可见事件(v)
        if not 积分区域.是否实例 then
            return
        end
        self:获取积分商品列表()

    end

    function 积分区域:获取积分商品列表()
        local t = __rpc:角色_获取积分商品列表()
        商品列表:清空()
        local t2 = {}
        if type(t) == "table" then
            for _, v in pairs(t) do
                if not t.成交 then
                    table.insert(t2, { id = v.id, 获得时间 = v.获得时间, 价格 = v.价格, 编号 = v.编号,
                        数额 = v.数额 })
                end

            end
            时间排序(t2)
            _积分当前页 = 1
            _积分最大页 = math.ceil(#t2 / 17)
            _商品列表 = t2
            for i = 1, 17, 1 do
                if t2[i] then
                    商品列表:添加商品(t2[i], i)
                end

            end
        end

    end

end

local 刷新按钮 = 寄售窗口:创建小按钮('刷新按钮', 531, 55, "刷新", 85)
local 寄售按钮 = 寄售窗口:创建中按钮('寄售按钮', 150, 475, "寄售管理", 85)
local 购买按钮 = 寄售窗口:创建中按钮('购买按钮', 320, 475, "购  买", 85)
do
    function 刷新按钮:左键弹起()
        local 刷新类型 = 银子按钮.是否选中 and "银子" or "积分"
        if 刷新类型 == "银子" then
            银子区域:获取银子商品列表()
        else
            积分区域:获取积分商品列表()
        end

    end

    function 购买按钮:左键弹起()
        local 购买类型 = 银子按钮.是否选中 and "银子" or "积分"
        if _商品 then
            coroutine.xpcall(
                function()
                    if 窗口层:确认窗口('你确定以 %s #W的价格购买 %s #G%s#W么？'
                        , 银两颜色(_商品.价格), 银两颜色(_商品.数额), 购买类型) then

                        local r = __rpc:角色_寄售购买(_商品.id, _商品.编号, 购买类型)
                        if type(r) == "string" then
                            窗口层:提示窗口(r)
                        elseif r == true then
                            if 购买类型 == "银子" then
                                银子区域:获取银子商品列表()
                            else
                                积分区域:获取积分商品列表()
                            end
                        end
                    end
                end
            )







        else
            窗口层:提示窗口('#Y清先选中要购买的商品。')
        end
        --积分区域.商品列表.选中行

    end

    function 寄售按钮:左键弹起()

        窗口层:打开寄售管理()
    end


end


function 窗口层:打开寄售(t)
    寄售窗口:置可见(not 寄售窗口.是否可见)
    if not 寄售窗口.是否可见 then
        return
    end
    _银子当前页 = 1
    _银子最大页 = 1
    _积分当前页 = 1
    _积分最大页 = 1
    银子按钮:置选中(true)

end

return 寄售窗口
