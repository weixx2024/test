


local 支援列表 = 窗口层:创建我的窗口('支援列表', 0, 0, 243, 368)
function 支援列表:初始化()
    self:置精灵(
        生成精灵(
            243,
            368,
            function()
                __res:getsf('ui/zylb.png'):显示(0, 0)
            end
        )
    )

    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
    self.选中 = 0
end

支援列表:创建关闭按钮(0, 0)



local 称谓列表 = 支援列表:创建列表('称谓列表', 25, 64, 166, 196)
function 称谓列表:初始化()
    __res.F14:置颜色(128, 192, 255)
    self:置文字(__res.F14)
    __res.F14:置颜色(255, 255, 255)
end

function 称谓列表:添加称谓(i, t)
    local r = self:添加(t)
    
end

function 称谓列表:左键弹起(x, y, i, t)
    支援列表.选中 = t.t
end

function 支援列表:刷新列表(t,i)
    if type(t) == 'table' then
        支援列表.选中 = 0
        local r = 称谓列表:添加("")
        r:置高度(25)
        r.t = t
        r.nid = r.nid
        r:置精灵(
            生成精灵(
                170,
                25,
                function ()
                    __res:getsf('gires4/jdmh/yjan/xan.tcp'):置拉伸(15, 15):显示(3, 3)
                    __res.F12:置颜色(255, 255, 255):取图像(i):显示(7,4)
                    __res.F14:置颜色(255, 255, 255):取图像(t.名称):显示(25,3)
                    __res.F14:置颜色(255, 255, 255):取图像(t.转生.."转"..t.等级.."级"):显示(100,3)
                end
            )
        )
    end
end



local 列表上按钮 = 支援列表:创建按钮('列表上按钮', 200, 57)
function 列表上按钮:初始化()
    self:设置按钮精灵('gires/0x287AF2DA.tcp')
end

function 列表上按钮:左键弹起()
    称谓列表:向上滚动()
    称谓列表:自动滚动(false)
end

local 列表下按钮 = 支援列表:创建按钮('列表下按钮', 200, 248)
function 列表下按钮:初始化()
    self:设置按钮精灵('gires/0x03539D9C.tcp')
end

function 列表下按钮:左键弹起()
    if not 称谓列表:向下滚动() then
        称谓列表:自动滚动(true)
    end
end


local 上移 = 支援列表:创建红木小按钮('上移按钮', 40, 280, '上 移', 51)
function 上移:左键弹起()
    if 支援列表.选中 and 支援列表.选中 ~= 0 then
        if __rpc:角色_支援上移(支援列表.选中.nid) then
            窗口层:刷新支援列表()
        end
    end
end

local 下移 = 支援列表:创建红木小按钮('下移按钮', 120, 280, '下 移', 51)
function 下移:左键弹起()
    if __rpc:角色_支援下移(支援列表.选中.nid) then
        窗口层:刷新支援列表()
    end
end

local 提示文本 = 支援列表:创建文本('提示文本', 45, 314, 87, 15)
提示文本:置文本("锁定首发召唤兽")
local 锁定首发 = 支援列表:创建我的多选按钮("锁定首发", 25, 315)
function 锁定首发:初始化()
    local tcp = __res:get('gires4/smsj/yjan/dxk.tcp')
    self:置正常精灵(tcp:取精灵(1):置中心(0, 0))
    self:置选中正常精灵(tcp:取精灵(2):置中心(0, 0))
end

function 锁定首发:左键弹起()
    local 锁定 = __rpc:角色_锁定首发召唤兽()
    if 锁定 then
        self:置选中(true)
    else
        self:置选中(false)
    end
end

function 窗口层:打开支援列表()
    支援列表:置可见(not 支援列表.是否可见)
    if not 支援列表.是否可见 then
        return
    end
    窗口层:刷新支援列表()
end

function 窗口层:刷新支援列表()
    local r,锁定 = __rpc:角色_打开支援列表()
    称谓列表:清空()
    if type(r) == "table" then
        for i=1,#r do
            支援列表:刷新列表(r[i],i)
        end
    end
    if 锁定 then
        锁定首发:置选中(true)
    else
        锁定首发:置选中(false)
    end
end

return 支援列表
