local 快速加入队伍 = 窗口层:创建我的窗口('快速加入队伍窗口', 0, 0, 550,350)
local __队伍格子 = require("界面/控件/队伍格子")
function 快速加入队伍:初始化()
    self:置精灵(self:取拉伸精灵_宽高('ui2/ks_jr.png', 516 , 307 ))
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
end

快速加入队伍:创建关闭按钮(-33, 1)

local 申请列表 = 快速加入队伍:创建网格('申请列表', 0, 5, 480, 380)
function 申请列表:初始化()
    self:创建格子(90,290,0,5,1,5)
end

function 申请列表:左键弹起(x, y, a, b, msg)
    if 申请列表.选中 then
        self.子控件[申请列表.选中]._spr.确定 = nil
    end
    if self.子控件[a] and self.子控件[a]._spr and self.子控件[a]._spr.数据 then
        申请列表.选中 = a
        self.子控件[a]._spr.确定 = true
    end
end

function 申请列表:置数据(数据)
    for i = 1,#申请列表.子控件 do
        local lssj = __队伍格子.创建(当前)
        if 数据[i] and 数据[i][1] then
            lssj:置数据(数据[i][1],i,'请求列表')
            申请列表.子控件[i]:置精灵(lssj)
            if 数据[i][1].在线 then
                快速加入队伍['允许按钮'..i]:置禁止(true)
                快速加入队伍['下线按钮'..i]:置禁止(false)
                快速加入队伍['切换按钮'..i]:置禁止(false)
            else
                快速加入队伍['允许按钮'..i]:置禁止(false)
                快速加入队伍['下线按钮'..i]:置禁止(true)
                快速加入队伍['切换按钮'..i]:置禁止(true)
            end
        else
            申请列表.子控件[i]:置精灵(nil)
            快速加入队伍['允许按钮'..i]:置禁止(false)
            快速加入队伍['下线按钮'..i]:置禁止(true)
            快速加入队伍['切换按钮'..i]:置禁止(true)
        end
    end
    self.数据 = 数据
end


for i=1,5 do
    local 允许按钮 = 快速加入队伍:创建红木中按钮('允许按钮'..i, 45+i*95-95, 240, '召唤' , 50)
    function 允许按钮:左键弹起()
        if 快速加入队伍.申请列表.数据[i] then
            if __rpc:离线登录_进入游戏(快速加入队伍.申请列表.数据[i][2]) == true then
                local r = __rpc:角色_快速加入队伍(快速加入队伍.申请列表.数据[i][1].nid)
                if r == true then
                    窗口层:获取快速加入队伍(__rpc:离线角色_快速加入())
                elseif type(r) == 'string' then
                    窗口层:提示窗口(r)
                end
            else
                窗口层:提示窗口("无法加入该角色,请检查是否已经加入助战数量大于4")
            end
        end
    end
end

for i=1,5 do
    local 下线按钮 = 快速加入队伍:创建红木中按钮('下线按钮'..i, 45+i*95-95, 270, '下线' , 50)
    function 下线按钮:左键弹起()
        if 快速加入队伍.申请列表.数据[i] then
            __rpc:角色_踢出队伍NID(快速加入队伍.申请列表.数据[i][1].nid)
            窗口层:获取快速加入队伍(__rpc:离线角色_快速加入())
        end
    end
end

for i=1,5 do
    local 切换按钮 = 快速加入队伍:创建红木中按钮('切换按钮'..i, 45+i*95-95, 30, '切换' , 50)
    function 切换按钮:左键弹起()
        if 快速加入队伍.申请列表.数据[i] then
            __rpc:界面_队伍_快速加入(快速加入队伍.申请列表.数据[i][1].nid)
            窗口层:获取快速加入队伍(__rpc:离线角色_快速加入())
        end
    end
end

function 窗口层:获取快速加入队伍(r)
    local 添加数据 = {}
    if type(r) == 'table' then
        for i, v in ipairs(r) do
            if v[1].nid ~= __rol.nid then
                添加数据[#添加数据+1] = v
            end
        end
        申请列表:置数据(添加数据)
    end
end

function 窗口层:打开快速加入队伍(r)
    快速加入队伍:置可见(not 快速加入队伍.是否可见)
    if not 快速加入队伍.是否可见 then
        return
    end
    快速加入队伍:置坐标((引擎.宽度 - 快速加入队伍.宽度) // 2, (引擎.高度 - 快速加入队伍.高度) // 2)
    self:获取快速加入队伍(r)
end

function 窗口层:关闭快速加入队伍()
    快速加入队伍:置可见(false)
end

function 窗口层:快速加入队伍(P)
    local r = __rpc:角色_快速加入队伍(P.nid)
    if type(r) == 'string' then
        窗口层:提示窗口(r)
    else
        窗口层:提示窗口('#R错误')
    end
end
return 快速加入队伍
