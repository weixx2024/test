

local 加入帮派 = 窗口层:创建我的窗口('加入帮派', 0, 0, 329, 425)
function 加入帮派:初始化()
    self:置精灵(__res:getspr('gires/0xF5164156.tcp'))
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
end

function 加入帮派:显示(x, y)
end
local 文本 = 加入帮派:创建我的文本('宗旨文本', 30, 237, 249, 142)
文本:创建我的文本('宗旨文本', 30, 237, 249, 142)
文本:创建我的滑块()
--======================================================================
local 帮派列表 = 加入帮派:创建多列列表('帮派列表', 30, 56, 249+23, 142)
do
    function 帮派列表:初始化()
        self.行高度 = 20
        self:取文字():置大小(20)
        self:添加列(0, 3, 100, 20) --帮派名称
        self:添加列(107, 3, 35, 20) --人数
        self:添加列(175, 3, 74, 20) --帮主名称
        self:置选中精灵宽度(249)
        -- for i = 1, 5 do
        --     self:添加('帮派名称' .. i, 0, '帮主名称')
        -- end
    end
    

    function 帮派列表:添加帮派(i, t)
        local r = self:添加(t.名称, t.人数, t.帮主)
        r.帮派名称 = t.名称
        r.宗旨 = t.宗旨
    end

    function 帮派列表:左键弹起(x, y, i, t)
        _加入帮派 = t.帮派名称
        文本:置文本(t.宗旨)
    end









    帮派列表:创建我的滑块()  
end


--======================================================================
加入帮派:创建关闭按钮(0, 1)


--======================================================================
local 加入按钮 = 加入帮派:创建小按钮('加入按钮', 143, 393, '加入')

function 加入按钮:左键弹起()
    if _加入帮派 then
        local r = __rpc:角色_帮派申请加入(_加入帮派)
        if type(r)=="string" then
            窗口层:最后对话(r, 3011)
        end
        self.父控件:置可见(false)
    end
end

function 窗口层:打开加入帮派(t)
    加入帮派:置可见(not 加入帮派.是否可见)
    if not 加入帮派.是否可见 then
        return
    end
    帮派列表:清空()
    _加入帮派=nil
    if type(t) ~= "table" then
        return
    end
    for k, v in pairs(t) do
        帮派列表:添加帮派(k, v)
    end








end
function RPC:申请帮派窗口(t)

    窗口层:打开加入帮派(t)

end

--窗口层:打开加入帮派()
return 加入帮派
