local 系统公告 = 登录层:创建控件('系统公告')

function 系统公告:初始化()
    self:置宽高(引擎.宽度, 引擎.高度)
    self:置精灵(__res:getspr('gires2/0x27689D65.tcp'))
end

local 文本 = 系统公告:创建我的文本('公告文本', 35, 70, 476, 361)

function 系统公告:可见事件(v)
    if v then
        local r = __rpc:获取公告()
        if type(r) == 'string' then
            文本:置文本(r)
        else
            文本:置文本('#R获取公告失败')
        end
        -- r = __rpc:获取活动()
        -- if type(r) == 'table' then
        --     self.活动数据 = r
        --     self.活动图标 = {}
        --     if self.活动数据 ~= nil and #self.活动数据 >= 1 then
        --         for i = 1, #self.活动数据 do
        --             self.活动图标[i] = __res:getspr('ui/'..self.活动数据[i].图标..'.png')
        --         end
        --     end
        -- end
    end
end

local 上翻按钮 = 系统公告:创建按钮('上翻按钮', 316, 429)
do
    function 上翻按钮:初始化()
        self:设置按钮精灵('gires2/0xF9838BCA.tcp')
    end
    function 上翻按钮:左键弹起()
        文本:向上滚动()
    end
end
local 下翻按钮 = 系统公告:创建按钮('下翻按钮', 374, 429)
do
    function 下翻按钮:初始化()
        self:设置按钮精灵('gires2/0x3390864B.tcp')
    end
    function 下翻按钮:左键弹起()
        文本:向下滚动()
    end
end
local 下一步按钮 = 系统公告:创建按钮('下一步按钮', 432, 429)
do
    function 下一步按钮:初始化()
        self:设置按钮精灵('gires2/0x703FA361.tcp')
    end
    function 下一步按钮:左键弹起()
        登录层:切换界面(登录层.选择区服)
    end

    function 下一步按钮:键盘弹起(键码, 功能)
        if 键码 == SDL.KEY_RETURN or 键码 == SDL.KEY_KP_ENTER then
            self:左键弹起()
        elseif 键码 == SDL.KEY_ESCAPE then
            登录层:切换界面(登录层.游戏开始)
        end
    end
end

return 系统公告
