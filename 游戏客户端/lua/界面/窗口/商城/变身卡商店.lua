local 变身卡商店 = 窗口层:创建我的窗口('变身卡商店', 0, 0, 520, 402)
local _变身卡库 = require("数据/变身卡库")
local _变身卡库1 = {} --require('数据/变身卡库')


local _不可售 = {
    -- 五叶卡 = true,
    -- 垂云叟卡 = true,
    -- 颜如玉卡 = true,
    -- 浪淘沙卡 = true,
    -- 范式之魂卡 = true,
    -- 精卫卡 = true,
    -- 迦楼罗王卡 = true,
    -- 冥灵妃子卡 = true,
    -- 年卡 = true,
    -- 画中仙卡 = true,
    -- 龙马卡 = true,
    -- 吉祥果卡 = true,
    -- 金不换卡 = true,
    -- 画皮娘子卡 = true,  
    松鼠卡 = true,
    -- 当康卡 = true,
    -- 赭炎卡 = true,
    -- 孔雀明王卡 = true,
    -- 剑精灵卡 = true,
    -- 狮蝎卡 = true,
    -- 小牛魔王卡 = true,
    -- 哥俩好卡 = true,
}



for key, value in pairs(_变身卡库) do
    if not _不可售[key] then
        table.insert(_变身卡库1, value)
    end

end
table.sort(_变身卡库1, function(a, b)
    return a[1].等级 < b[1].等级
end)
--{ id = 9122, name = '五叶卡', desc = '稀有变身卡#r【功效】变换造型' },

do


    _选中分类 = "抗性"
    _选中卡 = ""
    _购买数量 = 1
    _单价 = 0
    function 变身卡商店:初始化()
        self:置精灵(
            self:取老红木窗口(
                self.宽度,
                self.高度,
                '变身卡',
                function()
                    self:取拉伸图像_宽高('gires/main/border.bmp', 155, 185):显示(350, 43)
                    self:取拉伸图像_宽高('gires/main/border.bmp', 50, 50):显示(350, 240)
                    self:取拉伸图像_宽高('gires/main/border.bmp', 36, 18):显示(470, 244):显示(470, 264)
                    self:取拉伸图像_宽高('gires/main/border.bmp', 120, 18):显示(388, 296):显示(388, 316):显示(388
                        , 336)
                    self:取拉伸图像_宽高('gires/main/border.bmp', 133, 20):显示(50, 35)
                    self:取拉伸图像_宽高('gires/main/border.bmp', 100, 20):显示(243, 60)
                    self:取拉伸图像_宽高('ui/lbdk.png', 330, 300):显示(17, 82)

                    __res.JMZ:置大小(14)
                    __res.JMZ:取图像("卡名"):显示(15, 35):显示(40, 85)
                    __res.JMZ:取图像("类型"):显示(15, 62)

                    __res.JMZ:取图像("抗性"):显示(70, 62)
                    __res.JMZ:取图像("物理"):显示(120, 62)
                    __res.JMZ:取图像("强法"):显示(170, 62)
                    __res.JMZ:取图像("筛选"):显示(210, 61)
                    __res.JMZ:取图像("卡集空位"):显示(404, 245)
                    __res.JMZ:取图像("购买数量"):显示(404, 265)
                    __res.JMZ:取图像("单价"):显示(352, 296)
                    __res.JMZ:取图像("总额"):显示(352, 316)
                    __res.JMZ:取图像("现金"):显示(352, 336)

                    __res.JMZ:取图像("种类"):显示(115, 85)
                    __res.JMZ:取图像("亲和度"):显示(160, 85)
                    __res.JMZ:取图像("价格"):显示(220, 85)

                    __res.JMZ:置大小(16)
                end
            )
        )
        self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
        self.禁止滚动 = true
    end

    local _遮挡 = __res:getspr('card/misc/bframe.tcp'):置缩放(0.2)
    function 变身卡商店:显示(x, y)
        if self.动画 then
            self.动画:显示(x + 358, y + 241)
            _遮挡:显示(x + 358, y + 241)
        end
    end

    function 变身卡商店:置动画(id)
        self.动画 = nil
        if id then
            self.动画 = __res:getspr('card/%4d.tcp', id)
            if self.动画 then
                self.动画:置过滤(true)
                self.动画:置缩放(0.2) --置拉伸(50, 50, true)
            end
        end

    end

    变身卡商店:创建关闭按钮()
end

local 描述文本 = 变身卡商店:创建文本("描述文本", 355, 47, 148, 177)
local 商品列表 = 变身卡商店:创建多列列表("商品列表", 22, 103, 322, 274)

do
    function 商品列表:初始化()
        self.行高度 = 20
        self:取文字():置大小(20) --350
        self:添加列(5, 3, 90, 20) --卡名
        self:添加列(95, 3, 20, 20) --种类
        self:添加列(155, 3, 20, 20) --亲和度
        self:添加列(200, 3, 90, 20) --价格
        self:置选中精灵宽度(300)
    end

    function 商品列表:添加商品(t, i, 类型)
        local r = self:添加(t.name .. 类型, t.种类, t.亲和力, t.价格)
        r.商品编号 = i
        r.价格 = t.价格
        r.商品名称 = t.name .. "卡"
        r.name = t.name
        r.商品数据 = t
        r.皮肤 = t.皮肤
        r.商品类型 = 类型 == "卡" and 1 or 2
        r.描述 = string.format("等级:%s,亲和力%s,种类%s", t.等级, t.亲和力, t.种类)
        local list = {}
        for index, value in ipairs(t.属性) do
            table.insert(list, string.format('%s:%s%%', value[1], value[2]))
        end
        for index, value in ipairs { "金", "木", "水", "火", "土" } do
            table.insert(list, string.format('%s:%s', value, t.五行[index]))
        end
        r.描述 = r.描述 .. table.concat(list, ',')
    end

    function 商品列表:刷新商品()
        商品列表:清空()
        for k, v in pairs(_变身卡库1) do
            for i, t in ipairs(v) do
                if t.分类 == _选中分类 then
                    self:添加商品(t, i, "卡")
                    --   self:添加商品(t, i, "属性卡")
                end
            end
        end
    end

    function 商品列表:查询商品(s)
        商品列表:清空()
        for k, v in pairs(_变身卡库1) do
            for i, t in ipairs(v) do
                if string.find(t.name, s) then
                    self:添加商品(t, i, "卡")
                    --    self:添加商品(t, i, "属性卡")
                end
            end
        end
    end

    function 商品列表:筛选商品(s)
        商品列表:清空()
        for k, v in pairs(_变身卡库1) do
            for i, t in ipairs(v) do
                for index, value in ipairs(t.属性) do
                    if value[1] == s then
                        self:添加商品(t, i, "卡")
                        --     self:添加商品(t, i, "属性卡")
                    end
                end

            end
        end
    end

    function 商品列表:左键弹起(x, y, i, t)
        if _选中卡 ~= t.商品名称 then
            _选中卡 = t.商品名称
            变身卡商店:置动画(t.皮肤)
        end
        _购买数量 = 1
        _单价 = t.价格


        _购买数据 = { 名称 = t.商品名称, 单价 = t.价格, 属性编号 = t.商品编号, name = t.name,
            类型 = t.商品类型 }
        变身卡商店.数量输入:置文本(1)
        变身卡商店.单价文本:置文本(银两颜色(t.价格))
        变身卡商店.总额文本:置文本(银两颜色(t.价格))

        local txt = string.format('#Y#F名称19:%s#r#W#F默认14:%s#r', t.商品名称, "#C" .. t.描述)
        描述文本:置文本(txt)
    end



    商品列表:创建我的滑块2()
 


end

local 卡片输入 = 变身卡商店:创建文本输入('卡片输入', 52, 37, 120, 14)
local 单价文本 = 变身卡商店:创建文本('单价文本', 392, 296, 120, 14)
local 总额文本 = 变身卡商店:创建文本('总额文本', 392, 316, 120, 14)
local 银子文本 = 变身卡商店:创建文本('银子文本', 392, 336, 120, 14)
local 卡集文本 = 变身卡商店:创建文本('卡集文本', 474, 244, 30, 14)
local 数量输入 = 变身卡商店:创建数字输入('数量输入', 474, 244 + 20, 30, 14)
数量输入:置限制字数(2)
local 查询按钮 = 变身卡商店:创建小按钮("查询按钮", 185, 32, "查询")
local 购买按钮 = 变身卡商店:创建小按钮("购买按钮", 405, 362, "购买")
local 抗性按钮 = 变身卡商店:创建单选按钮('抗性按钮', 50, 62)
local 物理按钮 = 变身卡商店:创建单选按钮('物理按钮', 100, 62)
local 强法按钮 = 变身卡商店:创建单选按钮('强法按钮', 150, 62)
do
    function 抗性按钮:初始化()
        local tcp = __res:get('gires4/jdmh/yjan/dxk.tcp')
        self:置正常精灵(tcp:取精灵(1):置中心(0, 0))
        self:置按下精灵(tcp:取精灵(1):置中心(-1, -1))
        self:置选中正常精灵(tcp:取精灵(2):置中心(0, 0))
    end

    function 抗性按钮:左键弹起()
        _选中分类 = "抗性"
        商品列表:刷新商品()
    end

    function 物理按钮:初始化()
        local tcp = __res:get('gires4/jdmh/yjan/dxk.tcp')
        self:置正常精灵(tcp:取精灵(1):置中心(0, 0))
        self:置按下精灵(tcp:取精灵(1):置中心(-1, -1))
        self:置选中正常精灵(tcp:取精灵(2):置中心(0, 0))
    end

    function 物理按钮:左键弹起()
        _选中分类 = "物理"
        商品列表:刷新商品()
    end

    function 强法按钮:初始化()
        local tcp = __res:get('gires4/jdmh/yjan/dxk.tcp')
        self:置正常精灵(tcp:取精灵(1):置中心(0, 0))
        self:置按下精灵(tcp:取精灵(1):置中心(-1, -1))
        self:置选中正常精灵(tcp:取精灵(2):置中心(0, 0))
    end

    function 强法按钮:左键弹起()
        _选中分类 = "强法"
        商品列表:刷新商品()
    end

    function 查询按钮:左键弹起()
        if 卡片输入:取文本() == "" then
            return
        end
        local r = 卡片输入:取文本()


        商品列表:查询商品(r)

    end

    function 数量输入:输入数值(v)
        _购买数量 = v
        总额文本:置文本(银两颜色(_单价 * _购买数量))
    end

    function 购买按钮:左键弹起()
        if not _购买数据 then
            return
        end

        _购买数据.购买数量 = _购买数量
        local a, b = __rpc:角色_购买变身卡(_购买数据)



    end


end


local 文本组合 = 变身卡商店:创建文本组合("文本组合", 244, 62, 97, 20)

local _筛选表 = { "加强混乱", "加强封印", "加强昏睡", "加强毒", "加强火", "加强风", "加强雷",
    "加强水", "致命几率", "狂暴几率", "连击率", "忽视防御几率" }

for i, v in ipairs(_筛选表) do
    文本组合:添加(v)
end

function 文本组合:选中事件(i)
    商品列表:筛选商品(_筛选表[i])
end

function 窗口层:打开变身卡商店()
    变身卡商店:置可见(not 变身卡商店.是否可见)
    if not 变身卡商店.是否可见 then
        return
    end
    local a, b = __rpc:角色_变身卡商店()
    _银两, _容量 = a, b
    卡集文本:置文本(_容量)
    银子文本:置文本(银两颜色(_银两 or 0))
    抗性按钮:左键弹起()
    --商品列表:刷新商品()




end

return 变身卡商店
