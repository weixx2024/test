local 信息栏 = 界面层:创建控件('信息栏', 0, 0, 250, 60)
function 信息栏:初始化()
    -- self:置精灵(
    --     生成精灵(
    --         125,
    --         40,
    --         function()
    --             self:取拉伸图像_宽高('gires/main/border.bmp', 125 - 13, 23):显示(0, 0)
    --             self:取拉伸图像_宽高('gires/main/border.bmp', 125 - 13, 40 - 21):显示(0, 21)
    --             self:取拉伸图像_宽高('gires/main/border.bmp', 15, 40):显示(110, 0)
    --             --self:取拉伸图像_宽高('gires/main/border.bmp', 510 - 41, 25):显示(41, 0)
    --         end
    --     )
    -- )
    self:置精灵(__res:getspr('gires/dtbs.tcp'))
end

local 地图名称控件 = 信息栏:创建控件('地图名称控件', 0, 0, 110, 23)
-- function 地图名称控件:初始化()
--     界面层:置地图(1001)
--     界面层:置坐标(0, 0)
-- end

function 地图名称控件:显示(x, y)
    self.信息:显示(0, 0)
end

local 地图坐标控件 = 信息栏:创建控件('地图坐标控件', 0, 0, 110, 40)
-- function 地图坐标控件:初始化()
--     界面层:置坐标(0, 0)
-- end

function 地图坐标控件:显示(x, y)
    self.信息:显示(0, 0)
end

--================================================================================
function 界面层:置坐标(x, y)
    地图坐标控件.当前坐标 = string.format('X:%s,Y:%s', x // 20, (__map.高度 - y) // 20)
    地图坐标控件.信息 = __res.F13:置颜色(255, 255, 255, 255):取精灵(地图坐标控件.当前坐标)
    地图坐标控件.信息:置中心(-(110 - 地图坐标控件.信息.宽度) // 2, -24)
    地图名称控件.信息 = __res.F13:置颜色(255, 255, 255, 255):取精灵(地图名称控件.地图名称)
    地图名称控件.信息:置中心(-(110 - 地图名称控件.信息.宽度) // 2, -5)
end

function 界面层:置地图(id)

    local t = require('数据/地图库')[id]
    if gge.isdebug then
        地图名称控件.地图名称 = id .. (t.name or '未知')
        return
    end
    地图名称控件.地图名称 = t and t.name or '未知'
end

function 界面层:置时辰(v)
end

function RPC:界面信息_时辰(id)
    界面层:置时辰(id)
end

-- ================================================================================
local 当前地图 = 信息栏:创建按钮('当前地图', 144, 18)
function 当前地图:初始化()
    self:设置按钮精灵('gires/xdtan.tcp')
    self:置提示('当前地图')
end

function 当前地图:左键弹起()

    窗口层:打开小地图当前()
end

-- ================================================================================
local 世界地图 = 信息栏:创建按钮('世界地图', 144, 1)
function 世界地图:初始化()
    self:设置按钮精灵('gires/sjdtan.tcp')
    self:置提示('世界地图')
end

function 世界地图:左键弹起()
    窗口层:打开世界地图()
end

-- ================================================================================
local 快捷键 = 信息栏:创建按钮('快捷键', 128, 5)
function 快捷键:初始化()
    self:设置按钮精灵('gires/kjan.tcp')
    self:置提示('快捷键')
end

function 快捷键:左键弹起()
    local r = __rpc:角色_取管理权限()
    if r > 0 then
        窗口层:打开管理界面1()
    end
end

-- ================================================================================
local 多宝商城 = 信息栏:创建按钮('多宝商城', 160, 0)

function 多宝商城:初始化()
    self:设置按钮精灵('gires/dban.tcp')
    self.dh = __res:getani('gires/dbtx.tcp'):播放(true)
end

function 多宝商城:更新(dt)
    if self.dh then
        self.dh:更新(dt)
    end
end

function 多宝商城:显示(x,y)
    if self.dh then
        self.dh:显示(x-4, y-4)
    end
end

function 多宝商城:获得鼠标()
    self:置提示('游戏商城')
end

function 多宝商城:左键弹起()
    窗口层:打开多宝阁()
end

local 攻略按钮 = 信息栏:创建按钮("攻略按钮", 1, 40)
function 攻略按钮:初始化()
    self:置正常精灵(取按钮精灵2('ui/xx1.png', '引导'))
    self:置按下精灵(取按钮精灵2('ui/xx3.png', '引导', 1, 1))
    self:置经过精灵(取按钮精灵2('ui/xx2.png', '引导'))
end

function 攻略按钮:左键弹起()
    窗口层:打开攻略窗口()
end

local 排行按钮 = 信息栏:创建按钮('排行按钮', 38, 40)
function 排行按钮:初始化()
    self:置正常精灵(取按钮精灵2('ui/xx1.png', '排行'))
    self:置按下精灵(取按钮精灵2('ui/xx3.png', '排行', 1, 1))
    self:置经过精灵(取按钮精灵2('ui/xx2.png', '排行'))
end

function 排行按钮:左键弹起()
    窗口层:打开排行榜()
end

local 伙伴按钮 = 信息栏:创建按钮('伙伴按钮', 75, 40)
function 伙伴按钮:初始化()
    self:置正常精灵(取按钮精灵2('ui/xx1.png', '伙伴'))
    self:置按下精灵(取按钮精灵2('ui/xx3.png', '伙伴', 1, 1))
    self:置经过精灵(取按钮精灵2('ui/xx2.png', '伙伴'))
end

function 伙伴按钮:左键弹起()
    窗口层:打开伙伴()
end

local 助战按钮 = 信息栏:创建按钮('助战按钮', 112, 40)
function 助战按钮:初始化()
    self:置正常精灵(取按钮精灵2('ui/xx1.png', '助手'))
    self:置按下精灵(取按钮精灵2('ui/xx3.png', '助手', 1, 1))
    self:置经过精灵(取按钮精灵2('ui/xx2.png', '助手'))
end

function 助战按钮:左键弹起()
    if __rol.是否队长 then
        窗口层:打开助战()
    else
        if __rpc:角色_创建队伍() then
            __rol.是否组队 = true
            __rol:置队长(true)
            窗口层:提示窗口('#Y组队成功，你现在是队长了。')
            窗口层:打开助战()
        end
    end
end

local 月卡按钮 = 信息栏:创建按钮('月卡按钮', 149, 40)
function 月卡按钮:初始化()
    self:置正常精灵(取按钮精灵2('ui/xx1.png', '月卡'))
    self:置按下精灵(取按钮精灵2('ui/xx3.png', '月卡', 1, 1))
    self:置经过精灵(取按钮精灵2('ui/xx2.png', '月卡'))
end

function 月卡按钮:左键弹起()
    窗口层:打开月卡()
end

return 信息栏
