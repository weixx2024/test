local 寄售管理窗口 = 窗口层:创建我的窗口('寄售管理窗口', 0, 0, 600, 380)
do
    function 寄售管理窗口:初始化()
        self:置精灵(
            self:取老红木窗口(
                self.宽度,
                self.高度,
                '寄  售  管  理',
                function()
                    self:取拉伸图像_宽高('ui/lbdk.png', 560, 150):显示(20, 80)
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

    function 寄售管理窗口:显示(x, y)
    end

    寄售管理窗口:创建关闭按钮()
end

local 注文本 = 寄售管理窗口:创建我的文本('注文本', 200, 40, 550, 30)
注文本:置文本("#R注:订单成交后系统将扣除卖方该笔订单5%的收益所得#r最多可同时上架1笔订单")
local 标签控件 = 寄售管理窗口:创建标签('标签控件', 0, 0, 600, 380)
local 银子按钮 = 标签控件:创建自定义小标签按钮('银子按钮', 21, 56, '银两', 80, 25)
local 积分按钮 = 标签控件:创建自定义小标签按钮('积分按钮', 21 + 85, 56, '积分', 80, 25)
local 银子区域 = 标签控件:创建区域(银子按钮, 20, 97, 560, 365)
do
    function 银子区域:初始化()
        self:置精灵(
            生成精灵(
                560,
                365,
                function()

                    local sf = self:取拉伸图像_宽高('gires/main/border.bmp', 130, 20)
                    sf:显示(80, 189)
                    sf:显示(280 + 33, 189)
                    sf:显示(80, 189 + 40)
                    __res.JMZ:取图像('上架数额'):显示(7, 190)
                    __res.JMZ:取图像('上架价格'):显示(240, 190)
                    __res.JMZ:取图像('积分收益'):显示(7, 230)
                end
            )
        )

    end

    local 商品列表 = 银子区域:创建多列列表('商品列表', 6, 10, 551, 345 - 230)
   -- 商品列表:置选中精灵宽度(117)
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
        r.编号 = t.编号
        r.id = t.id
    end

    function 商品列表:左键弹起(x, y, i, t)
        _商品 = { id = t.id, 编号 = t.编号, 类型 = "银两" }

    end

    商品列表:创建我的滑块()
    function 银子区域:可见事件(v)
        if not 银子区域.是否实例 then
            return
        end
        self:请求刷新()
    end

    local 下架按钮 = 银子区域:创建中按钮('下架按钮', 240, 150, "我要下架", 85)
    local 数额输入 = 银子区域:创建数字输入('数额输入', 80 + 3, 191, 120, 15)
    local 价格输入 = 银子区域:创建数字输入('价格输入', 240 + 76, 191, 120, 15)
    local 上架按钮 = 银子区域:创建中按钮('上架按钮', 470, 185, "上架银两", 85)
    local 文本 = 银子区域:创建文本('积分文本', 83, 191 + 40, 120, 15)
    local 取出按钮 = 银子区域:创建中按钮('取出按钮', 240, 150 + 75, "我要取出", 85)
    function 银子区域:请求刷新()
        local r, n = __rpc:角色_获取银子寄售()
        银子区域.商品列表:清空()
        _商品=nil
        if type(r) == "table" then
            self.商品列表:添加商品(r)
        end
        文本:置文本(银两颜色(n))
    end

    do
        function 上架按钮:左键弹起()
            local 数额 = 数额输入:取文本()
            local 价格 = 价格输入:取文本()
            if 数额 == "" or 价格 == "" then
                窗口层:提示窗口('#Y请输入要出售的金额与价额。')
                return
            end
            coroutine.xpcall(
                function()
                    if 窗口层:确认窗口('你确定将%s#W两银子以%s#W积分的价格出售么？#r#R注：订单成交后系统将扣除该笔订单5%%的收益所得'
                        , 银两颜色(数额), 银两颜色(价格)) then

                        数额 = tonumber(数额)
                        价格 = tonumber(价格)
                        local r = __rpc:角色_上架寄售(数额, 价格, 1)
                        if type(r) == "string" then
                            窗口层:提示窗口(r)
                        elseif r == true then
                            银子区域:请求刷新()
                        end
                    end
                end
            )
        end

        function 下架按钮:左键弹起()
            if _商品 and _商品.类型 == "银两" then
                coroutine.xpcall(
                    function()
                        if 窗口层:确认窗口('你确定将#Y%s#W订单下架吗？'
                            , _商品.编号) then
                            local r = __rpc:角色_下架寄售(_商品.id, _商品.编号, _商品.类型)
                            if type(r) == "string" then
                                窗口层:提示窗口(r)
                            elseif r == true then
                                银子区域:请求刷新()
                            end
                        end
                    end
                )
            else
                窗口层:提示窗口("#R请先选中需要下架的商品")
            end

        end

        function 取出按钮:左键弹起()
            coroutine.xpcall(
                function()
                    if 窗口层:确认窗口('你确定要取出收益么？') then
                        local r = __rpc:角色_寄售收益取出("银子")
                        if type(r) == "string" then
                            窗口层:提示窗口(r)
                        elseif r == true then
                            银子区域:请求刷新()
                        end
                    end
                end
            )
        end
    end






end
local 积分区域 = 标签控件:创建区域(积分按钮, 20, 97, 560, 365)
do
    function 积分区域:初始化()
        self:置精灵(
            生成精灵(
                560,
                365,
                function()

                    local sf = self:取拉伸图像_宽高('gires/main/border.bmp', 130, 20)
                    sf:显示(80, 189)
                    sf:显示(280 + 33, 189)
                    sf:显示(80, 189 + 40)
                    __res.JMZ:取图像('上架数额'):显示(7, 190)
                    __res.JMZ:取图像('上架价格'):显示(240, 190)
                    __res.JMZ:取图像('银两收益'):显示(7, 230)
                end
            )
        )

    end

    local 商品列表 = 积分区域:创建多列列表('商品列表', 6, 10, 551, 345 - 230)
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
        local r = self:添加("*********", "积分", t.数额, t.价格)
        r.编号 = t.编号
        r.id = t.id
    end

    function 商品列表:左键弹起(x, y, i, t)
        _商品 = { id = t.id, 编号 = t.编号, 类型 = "积分" }

    end

    商品列表:创建我的滑块()
    function 积分区域:可见事件(v)
        if not 积分区域.是否实例 then
            return
        end
        self:请求刷新()
    end

    local 下架按钮 = 积分区域:创建中按钮('下架按钮', 240, 150, "我要下架", 85)
    local 数额输入 = 积分区域:创建数字输入('数额输入', 80 + 3, 191, 120, 15)
    local 价格输入 = 积分区域:创建数字输入('价格输入', 240 + 76, 191, 120, 15)
    local 上架按钮 = 积分区域:创建中按钮('上架按钮', 470, 185, "上架银两", 85)
    local 文本 = 积分区域:创建文本('积分文本', 83, 191 + 40, 120, 15)
    local 取出按钮 = 积分区域:创建中按钮('取出按钮', 240, 150 + 75, "我要取出", 85)
    function 积分区域:请求刷新()
        local r, n = __rpc:角色_获取积分寄售()
        积分区域.商品列表:清空()
        _商品=nil
        if type(r) == "table" then
            self.商品列表:添加商品(r)
        end
        文本:置文本(银两颜色(n))
    end

    do
        function 上架按钮:左键弹起()
            local 数额 = 数额输入:取文本()
            local 价格 = 价格输入:取文本()
            if 数额 == "" or 价格 == "" then
                窗口层:提示窗口('#Y请输入要出售的金额与价额。')
                return
            end
            coroutine.xpcall(
                function()
                    if 窗口层:确认窗口('你确定将%s#W两积分以%s#W银子的价格出售么？#r#R注：订单成交后系统将扣除该笔订单5%%的收益所得'
                        , 银两颜色(数额), 银两颜色(价格)) then

                        数额 = tonumber(数额)
                        价格 = tonumber(价格)
                        local r = __rpc:角色_上架寄售(数额, 价格, 2)
                        if type(r) == "string" then
                            窗口层:提示窗口(r)
                        elseif r == true then
                            积分区域:请求刷新()
                        end
                    end
                end
            )
        end

        function 下架按钮:左键弹起()
            if _商品 and _商品.类型 == "积分" then
                coroutine.xpcall(
                    function()
                        if 窗口层:确认窗口('你确定将#Y%s#W订单下架吗？'
                            , _商品.编号) then
                            local r = __rpc:角色_下架寄售(_商品.id, _商品.编号, _商品.类型)
                            if type(r) == "string" then
                                窗口层:提示窗口(r)
                            elseif r == true then
                                积分区域:请求刷新()
                            end
                        end
                    end
                )
            else
                窗口层:提示窗口("#R请先选中需要下架的商品")
            end

        end

        function 取出按钮:左键弹起()
            coroutine.xpcall(
                function()
                    if 窗口层:确认窗口('你确定要取出收益么？') then
                        local r = __rpc:角色_寄售收益取出("积分")
                        if type(r) == "string" then
                            窗口层:提示窗口(r)
                        elseif r == true then
                            积分区域:请求刷新()
                        end
                    end
                end
            )
        end
    end
end





function 窗口层:打开寄售管理(t)
    寄售管理窗口:置可见(not 寄售管理窗口.是否可见)
    if not 寄售管理窗口.是否可见 then
        return
    end
    银子按钮:置选中(true)








end

return 寄售管理窗口
