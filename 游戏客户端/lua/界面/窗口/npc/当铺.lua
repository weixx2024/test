

local 当铺 = 窗口层:创建我的窗口('当铺')
function 当铺:初始化()
    self:置精灵(__res:getspr('ui/dangpu.png'))
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
end

当铺:创建关闭按钮(0, 1)

仓库网格 = 当铺:创建物品网格2('仓库网格', 34, 36, 305, 203)

function 仓库网格:初始化()
    self.数据 = {}
    self.仓库 = {}
end

function 仓库网格:获取页面数()
    return __rpc:角色_仓库页数()
end

function 仓库网格:获取道具(p)
    if not self.仓库[p] then
        self.仓库[p] = {}
    end
    self.数据 = self.仓库[p]
    return __rpc:角色_仓库列表(p)
end

function 仓库网格:右键弹起(x, y, i)
    if self.数据[i] then
        local r, txt = __rpc:角色_仓库取出(self.数据[i].I, 道具网格.当前页 << 8)
        if r == true then
            道具网格:刷新道具()
            self.数据[i] = nil
        elseif type(r) == 'string' then
            窗口层:提示窗口(r)
        end
        if type(txt) == 'string' then
            窗口层:提示窗口(txt)
        end
    end
end


function 仓库网格:左键弹起(x, y, i)
    if gge.platform ~= 'Windows' then
        self:右键弹起(x, y, i)
    end
end





local 整理按钮 = 当铺:创建按钮('整理按钮', 360, 220)
function 整理按钮:初始化()
    self:置正常精灵(取按钮精灵2('ui/xx1.png', '整理'))
    self:置按下精灵(取按钮精灵2('ui/xx3.png', '整理', 1, 1))
    self:置经过精灵(取按钮精灵2('ui/xx2.png', '整理'))
end

function 整理按钮:左键弹起()
    if __rpc:角色_仓库整理(仓库网格.当前页) then
        仓库网格:刷新道具()
    end
end


local 道具网格控件 = 当铺:创建控件('道具区', 0, 0, 391, 481)
道具网格 = 道具网格控件:创建物品网格2('道具网格', 34, 252, 305, 203)

function 道具网格:右键弹起(x, y, i)
    if self.数据[i] then
        local r, txt = __rpc:角色_仓库存入(self.数据[i].I, 仓库网格.当前页 << 8)
        if r == true then
            仓库网格:刷新道具()
            self.数据[i] = nil
        elseif type(r) == 'string' then
            窗口层:提示窗口(r)
        end
        if type(txt) == 'string' then
            窗口层:提示窗口(txt)
        end
    end
end
function 道具网格:左键弹起(x, y, i)
    if gge.platform ~= 'Windows' then
        self:右键弹起(x, y, i)
    end
end
function 窗口层:打开当铺()
    当铺:置可见(true)
    仓库网格:打开()
    道具网格:打开()
end

function RPC:当铺窗口()
    窗口层:打开当铺()
end
return 当铺
