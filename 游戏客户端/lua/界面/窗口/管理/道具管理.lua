local _ENV = require('界面/窗口/管理/管理_1')
道具管理区域 = 标签控件:创建区域(道具管理按钮, 0, 0, 580, 300)
local _nid=''
do
    function 道具管理区域:初始化()
        self:置精灵(
            生成精灵(
                580,
                300,
                function()
                    local sf = __res:getsf('ui/zhswp.png'):置区域(19, 40, 330, 210) -- self:取拉伸图像_宽高('ui/zhswp.png', 130, 20)
                    sf:显示(10, 25)
                    __res.JMZ:取图像("道具列表"):显示(130, 2)
                    __res.JMZ:取图像("道具名称"):显示(490, 25)
                    __res.JMZ:取图像("道具数量"):显示(490, 75)
                    __res.JMZ:取图像("道具参数"):显示(490, 125)
                    __res.JMZ:取图像("能否交易"):显示(490, 175)
                    local sf2 = self:取拉伸图像_宽高('gires/main/border.bmp', 130, 20):显示(350, 25):显示(350
                        , 75):显示(350, 125)


                end
            )
        )
    end

    local _能否交易 = true
    local 绑定按钮 = 道具管理区域:创建多选按钮('绑定按钮', 470, 175)
---------------------------------------------------
-- 道具管理 = 标签控件:创建区域(道具管理按钮, 0, 0, 736, 485)
-- do
--     local 标签控件 = 道具管理:创建标签('标签控件', 0, 0, 736, 485)
--     do
        local 道具网格 = 道具管理区域:创建物品网格('道具网格', 11, 26, 305, 203)
        do

        end

        for i = 1, 5 do
            local 按钮 = 道具管理区域:创建单选按钮('物品栏' .. i, 320, 15 + i * 35 - 20)
            function 按钮:初始化()
                self:设置按钮精灵2('gires/0xC3622E6B.tcp')
                -- self:设置按钮精灵2('gires2/0x00000149.tcp')
            end

            function 按钮:左键弹起()
                --local m = 选中道具
            end

            function 按钮:选中事件(v)
                if v then
                    道具管理区域:刷新道具(i, _nid)
                end
            end
        end

        function 道具管理区域:刷新道具(p, nid)
            local kk = 道具网格:管理取刷新道具(p, nid)
            if kk == 1 then
                return 窗口层:提示窗口('玩家不在线')
            end
        end


--     end
-- end




-------------------------------------------------------
    function 绑定按钮:初始化()
        local tcp = __res:get('gires4/smsj/yjan/dxk.tcp')
        self:置正常精灵(tcp:取精灵(1))
        self:置选中正常精灵(tcp:取精灵(2))
        --    self:置提示('绑定按钮')
        self:置选中(_能否交易)
    end

    function 绑定按钮:选中事件(b)
        _能否交易 = b
    end

    local 名称输入 = 道具管理区域:创建文本输入('道具名称输入', 353, 27, 130, 14)
    local 数量输入 = 道具管理区域:创建数字输入('道具数量输入', 353, 77, 130, 14)
    local 参数输入 = 道具管理区域:创建文本输入('道具参数输入', 353, 127, 130, 14)
    名称输入:置颜色(255, 255, 255, 255)
    数量输入:置颜色(255, 255, 255, 255)
    参数输入:置颜色(255, 255, 255, 255)
    local 发放按钮 = 道具管理区域:创建中按钮("发放按钮", 375, 200, "发放道具")
    function 发放按钮:左键弹起()
        if _选中角色 then
            local name = 名称输入:取文本()
            local 数量 = 数量输入:取文本()
            local 参数 = 参数输入:取文本()
            if name == "" or 数量 == "" then
                窗口层:提示窗口('#Y请输入道具名称跟数量')
                return
            end
            数量 = tonumber(数量)
            local cas
            if tonumber(参数) then
                cas = tonumber(参数)
            else
                cas = 参数
            end
            数量 = tonumber(数量)
            local r = __rpc:角色_GM_发放道具(_当前账号, _选中角色, { 名称 = name, 数量 = 数量,
                参数 = cas,
                禁止交易 = not _能否交易 })
            if type(r) == "string" then
                窗口层:提示窗口(r)
                return
            end
        else
            窗口层:提示窗口('#Y请先选中操作角色')
        end
    end
end













function 道具管理区域:刷新角色信息(nid)
   
    if type(nid) ~= "string" then
        return
    end
    _nid=nid
end




function 道具管理区域:可见事件(v)
    if v then
        if not _选中角色 then
        else
            --todo 获取身上道具
            --  道具网格:打开2(_选中角色)
        end
    end
end
