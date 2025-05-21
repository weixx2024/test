local 排行榜窗口 = 窗口层:创建我的窗口('排行榜窗口', 0, 0, 550, 406)
do
    function 排行榜窗口:初始化()
        self:置精灵(
            self:取老红木窗口(
                self.宽度,
                self.高度,
                '排行榜',
                function()
                    -- self:取拉伸图像_宽高('gires/main/border.bmp', 100, 380):显示(3, 26)
                    self:取拉伸图像_宽高('ui/lbdk.png', 150, 380):置区域(0, 18, 150, 380):显示(10, 30)
                    self:取拉伸图像_宽高('gires4/jdmh/yjan/tmk2.tcp', 375, 60):显示(162, 30)
                    self:取拉伸图像_宽高('ui/lbdk.png', 378, 300):显示(162, 90)
                    --  __res:getsf('gires4/jdmh/yjan/dxk2.tcp'):显示(33, 476)
                end
            )
        )
        self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
        self.禁止滚动 = true
    end

    function 排行榜窗口:显示(x, y)
    end

    排行榜窗口:创建关闭按钮()
end


local 等级介绍文本 = 排行榜窗口:创建文本("等级介绍文本", 172, 50, 350, 30)

local 等级排行列表 = 排行榜窗口:创建多列列表("等级排行列表", 165, 90 + 22, 372, 300 - 25)
local 财富介绍文本 = 排行榜窗口:创建文本("财富介绍文本", 172, 50, 350, 30)
财富介绍文本:置文本("#Y你的金钱#W:140万#r#Y你目前排行#W:暂时未能上榜,请继续加油")
local 财富排行列表 = 排行榜窗口:创建多列列表("财富排行列表", 165, 90 + 22, 372, 300 - 25)
local 帮派介绍文本 = 排行榜窗口:创建文本("帮派介绍文本", 172, 50, 350, 30)
帮派介绍文本:置文本("#Y你的威望值#W:0#r#Y所在帮派排行#W:暂时未能上榜,请继续加油")
local 帮派排行列表 = 排行榜窗口:创建多列列表("帮派排行列表", 165, 90 + 22, 372, 300 - 25)

do
    function 等级排行列表:初始化()
        self.行高度 = 20
        self:取文字():置大小(20) --350
        self:添加列(20, 3, 25, 20) --名次
        self:添加列(80, 3, 150, 20) --名称
        self:添加列(250, 3, 90, 20) --等级
        self:置选中精灵宽度(350)
    end

    function 财富排行列表:初始化()
        self.行高度 = 20
        self:取文字():置大小(20) --350
        self:添加列(20, 3, 25, 20) --名次
        self:添加列(80, 3, 95, 20) --名称
        self:添加列(175, 3, 60, 20) --等级
        self:添加列(265, 3, 90, 20) --金钱
        self:置选中精灵宽度(350)
    end

    function 帮派排行列表:初始化()
        self.行高度 = 20
        self:取文字():置大小(20) --350
        self:添加列(20, 3, 25, 20) --名次
        self:添加列(80, 3, 90, 20) --帮主
        self:添加列(175, 3, 90, 20) --帮派名
        self:添加列(280, 3, 10, 20) --威望值
        self:置选中精灵宽度(350)
    end







end
local _列表标题 = {
    " #Y名次        昵称                   等级",
    " #Y名次        昵称        等级         金钱",
    " #Y名次        帮主        帮派         等级"


}
local 分类文本 = 排行榜窗口:创建文本("分类文本", 170, 95, 350, 14)
--分类文本:置文本()


local 分类列表 = 排行榜窗口:创建列表("分类列表", 13, 33, 144, 354)
do
    分类列表:置选中精灵宽度(121)
    function 分类列表:初始化()
        self:置文字(__res.F18:置颜色(255, 255, 255))
        self:添加("练级达人榜")
        self:添加("超级富豪榜")
        self:添加("帮派实力榜")
        -- self:添加("水陆积分榜")
    end
    分类列表:创建我的滑块()
    function 分类列表:左键弹起(x, y, i, t)
        等级排行列表:置可见(t.名称 == "练级达人榜")
        等级介绍文本:置可见(t.名称 == "练级达人榜")
        财富排行列表:置可见(t.名称 == "超级富豪榜")
        财富介绍文本:置可见(t.名称 == "超级富豪榜")
        帮派排行列表:置可见(t.名称 == "帮派实力榜")
        帮派介绍文本:置可见(t.名称 == "帮派实力榜")
        分类文本:置文本(_列表标题[i])
        if t.名称 == "练级达人榜" then
            等级排行列表:清空()
            local r, z, nid = __rpc:角色_取等级排行() --{名称,转生,等级,nid},我的转生等级 我的排名
            local pm = 0
            if type(r) == "table" then
                for index, value in ipairs(r) do
                    等级排行列表:添加(index, value.名称, value.转生 .. "转" .. value.等级)
                    if index < 4 then
                        等级排行列表:置项目颜色(index, 255, 255, 0)
                    end
                    if value.nid == nid then
                        pm = index
                    end
                end
            end
            local f = string.format("#Y你的等级#W:%s#r#Y你目前排行#W:%s", z,
                pm == 0 and "暂时未能上榜,请继续加油" or "第" .. pm .. "名") -- 暂时未能上榜,请继续加油
            等级介绍文本:置文本(f)
        elseif t.名称 == "超级富豪榜" then
            财富排行列表:清空()
            local r, yz, nid = __rpc:角色_取财富排行() -- {名称,转生,等级,nid},我的转生等级 我的排名
            local pm = 0
            if type(r) == "table" then
                for index, value in ipairs(r) do
                    财富排行列表:添加(index, value.名称, value.转生 .. "转" .. value.等级, value.银子)
                    if index < 4 then
                        财富排行列表:置项目颜色(index, 255, 255, 0)
                    end
                    if value.nid == nid then
                        pm = index
                    end
                end
            end
            local f = string.format("#Y你的金钱#W:%s#r#Y你目前排行#W:%s", yz,
                pm == 0 and "暂时未能上榜,请继续加油" or "第" .. pm .. "名") --暂时未能上榜,请继续加油
                财富介绍文本:置文本(f)
        elseif t.名称 == "帮派实力榜" then
            帮派排行列表:清空()
            local r, pb= __rpc:角色_取帮派排行() 
            local pm = 0
            local 等级
            if type(r) == "table" then
                for index, value in ipairs(r) do
                    
                    帮派排行列表:添加(index, value.帮主, value.名称, value.等级)
                    if pb == value.名称 then
                        pm = index--所在帮派排名
                        等级=value.等级
                    end 
                end
            end
            local f = string.format("#Y你的帮派#W:%s#r#Y所在帮派排行#W:%s", ( pb and pb~=""  ) and pb  or "你还没有加入帮派" ,
            pm == 0 and "暂时未能上榜,请继续加油" or "第" .. pm .. "名")
            帮派介绍文本:置文本(f)
        end
    end
end












function 窗口层:打开排行榜()
    排行榜窗口:置可见(not 排行榜窗口.是否可见)
    if not 排行榜窗口.是否可见 then
        return
    end
    --  分类列表:置选中(1)
    分类列表:左键弹起(x, y, 1, { 名称 = "练级达人榜" })
end

return 排行榜窗口
