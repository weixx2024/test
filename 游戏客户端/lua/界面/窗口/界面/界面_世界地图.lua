

local 世界地图 = 窗口层:创建我的窗口('世界地图', 0, 0)
function 世界地图:初始化()
    self:置精灵(
        生成精灵(
            650,
            515,
            function()
                local 卷轴棒棒 = __res:getsf('gires/sjdtk.tcp')
                卷轴棒棒:显示(0, 0)
                __res:getsf('gires/sjdt.tcp'):置区域(0, 0, 606, 478):显示(22, 19)
                卷轴棒棒:显示(628, 0)
            end
        )
    )
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
end

-- ===============================================================================================

local 地图区域 = 世界地图:创建控件('地图区域', 22, 19, 606, 478)
local 地图区域2 = 地图区域:创建控件('地图区域2', 0, 0, 850, 478)
do
    地图区域2.绝对坐标 = true
    function 地图区域2:初始化()
        self.地图 = __res:getspr('gires/sjdt.tcp')
        self.当前位置 = __res:getani('gires3/worldmap/dqwz.tcp'):播放(true)
    end

    function 地图区域2:更新(dt)
        self.当前位置:更新(dt)
        if self.移动开关 ~= nil then
            if self.移动开关 and self.x <= 0 then
                self.x = self.x - 5
                if self.x <= -244 then
                    self.x = -244
                    self.移动开关 = nil
                end
            else
                self.x = self.x + 5
                if self.x >= 0 then
                    self.x = 0
                    self.移动开关 = nil
                end
            end
        end
    end

    function 地图区域2:显示(x, y)
        self.地图:显示(x, y)
        self.当前位置:显示(x, y)
    end

    function 地图区域2:置当前位置(name)
        if self[name] then
            local w, h = self[name]:取宽高()
            self.当前位置:置中心(-(self[name].x + w // 2), -(self[name].y + h // 2))
        end
    end
    --===============================================================================================
    for i, v in ipairs {
        {name = '方寸后山', id = 1136, x = 29, y = 159},
        {name = '广寒宫', id = 101474, x = 41, y = 49},
        {name = '瑶池', id = 1201, x = 51, y = 89},
        {name = '天宫', id = 1111, x = 81, y = 112},
        {name = '方寸山', id = 1135, x = 57, y = 184},
        {name = '长寿村', id = 1070, x = 63, y = 214},
        {name = '长寿村外', id = 1091, x = 41, y = 264},
        {name = '普陀山', id = 1140, x = 33, y = 383},
        {name = '蟠桃园', id = 1198, x = 104, y = 41},
        {name = '御马监', id = 1199, x = 126, y = 91},
        {name = '宝象国', id = 101529, x = 156, y = 251},
        {name = '平顶山', id = 101537, x = 139, y = 291},
        {name = '火云戈壁', id = 101538, x = 113, y = 331},
        {name = '女儿国', id = 101550, x = 113, y = 354},
        {name = '狮驼岭', id = 1131, x = 171, y = 394},
        {name = '大唐边境', id = 1173, x = 181, y = 364},
        {name = '四圣庄', id = 101295, x = 201, y = 331},
        {name = '万寿山', id = 101299, x = 213, y = 299},
        {name = '蟠桃园后', id = 1217, x = 110, y = 61},
        {name = '白骨山', id = 101300, x = 230, y = 271},
        {name = '北俱芦洲', id = 1174, x = 296, y = 98},
        {name = '凤巢', id = 1186, x = 272, y = 77},
        {name = '灵兽村', id = 101349, x = 301, y = 55},
        {name = '修罗古城', id = 101381, x = 331, y = 36},
        {name = '龙窟', id = 1177, x = 371, y = 67},
        {name = '五庄观', id = 1146, x = 293, y = 301},
        {name = '斧头帮', id = 1203, x = 272, y = 336},
        {name = '五指山', id = 1194, x = 270, y = 362},
        {name = '洛阳城', id = 1236, x = 346, y = 407},
        {name = '大唐境内', id = 1110, x = 340, y = 368},
        {name = '长安城', id = 1001, x = 376, y = 301},
        {name = '大雁塔', id = 1004, x = 355, y = 276},
        {name = '化生寺', id = 1002, x = 400, y = 251},
        {name = '皇宫', id = 1003, x = 440, y = 279},
        {name = '长安东', id = 1193, x = 470, y = 346},
        {name = '轮回司', id = 1125, x = 439, y = 432},
        {name = '地府', id = 1122, x = 485, y = 458},
        {name = '地狱迷宫', id = 1129, x = 505, y = 423},
        {name = '兰若寺', id = 101395, x = 553, y = 456},
        {name = '海岛洞窟', id = 1214, x = 541, y = 384},
        {name = '珊瑚海岛', id = 1213, x = 534, y = 349},
        {name = '东海渔村', id = 1208, x = 525, y = 319},
        {name = '海底迷宫', id = 1118, x = 518, y = 267},
        {name = '龙宫', id = 1116, x = 516, y = 237},
        {name = '傲来国', id = 1092, x = 496, y = 149},
        {name = '女儿村', id = 1142, x = 545, y = 116},

    } do
        local 按钮 = 地图区域2:创建按钮(v.name, v.x - 24, v.y - 19)
        do
            function 按钮:初始化()
                self:设置按钮精灵('gires3/worldmap/%s', v.id .. '.tcp')
            end
            按钮.检查透明 = 按钮.检查点

            function 按钮:左键弹起()
                窗口层:打开小地图预览(v.id)
            end
        end
    end
    --===============================================================================================
    for i, v in ipairs {
        {name = '寻路', 路径 = 'xzan.tcp', x = 79, y = 425},
        {name = '寻找npc', 路径 = 'xzan.tcp', x = 191, y = 425}
    } do
        local 按钮 = 世界地图:创建按钮(v.name, v.x, v.y)
        function 按钮:初始化()
            __res.F14:置样式(SDL.TTF_STYLE_BOLD)
            local tcp = __res:get('gires3/worldmap/' .. v.路径)
            local sf = tcp:取图像(1, __res.F14:取图像(v.name):置中心(-30, -30))
            self:置正常精灵(sf:到精灵())
            self:置按下精灵(sf:到精灵():置中心(-1, -1))
            __res.F14:置样式(SDL.TTF_STYLE_NORMAL)
        end

        function 按钮:左键弹起()
        end
    end
end

--===============================================================================================
-- local 按钮 = 世界地图:创建多选按钮('缩进按钮', 633, 240)
-- do
--     function 按钮:初始化()
--         local t = __res:get('gires4/jdmh/yjan/缩进_右.tcp')

--         self:置正常精灵(t:取精灵(1))
--         self:置按下精灵(t:取精灵(2))
--         self:置经过精灵(t:取精灵(3))

--         local t = __res:get('gires4/jdmh/yjan/缩进_左.tcp')

--         self:置选中正常精灵(t:取精灵(1))
--         self:置选中按下精灵(t:取精灵(2))
--         self:置选中经过精灵(t:取精灵(3))

--         self:注册事件(
--             self,
--             {
--                 获得鼠标 = function(_, x, y)
--                     GUI.鼠标层:手指形状()
--                 end
--             }
--         )
--         self:置可见(false)
--     end

--     function 按钮:选中事件(v)
--         地图区域2.移动开关 = v
--     end
-- end
--===============================================================================================
local 按钮 = 世界地图:创建按钮('关闭按钮', -50, 20)
function 按钮:初始化(v)
    local tcp = __res:get('gires3/button/close.tcp')
    self:置正常精灵(tcp:取精灵(1))
    self:置按下精灵(tcp:取精灵(2))
    self:置经过精灵(tcp:取精灵(3))
end

function 按钮:左键弹起()
    self.父控件:置可见(false)
end

--当前地图
function 窗口层:打开世界地图()
    世界地图:置可见(not 世界地图.是否可见, true)
    local t = require('数据/地图库')[__map.id]
    地图区域2:置当前位置(t and t.name or '未知')
end

return 世界地图
