

local 炼妖窗口 = 窗口层:创建我的窗口('炼妖窗口', 0, 0, 480, 480)
function 炼妖窗口:初始化()
    self:置精灵(__res:getspr('gires/0xC0BCEC29.tcp'))
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
end

function 炼妖窗口:更新(dt)
    if self.动画 then
        self.动画:更新(dt)
    end
    if self.动画2 then
        self.动画2:更新(dt)
    end
end

function 炼妖窗口:前显示(x, y)
    if self.动画 then
        self.动画:显示(x + 90, y + 200)
    end
    if self.动画2 then
        self.动画2:显示(x + 380, y + 200)
    end
end

炼妖窗口:创建关闭按钮(0, 1)


local 提交网格 = 炼妖窗口:创建提交网格('提交网格', 213, 72, 56, 56)
do
    function 提交网格:初始化()
        self:添加格子(2, 2, 51, 51)
    end

    function 提交网格:右键弹起(x, y, i)
        if self.数据[i] then
            self.数据[i] = nil
            --道具网格:获取数据()
        end
    end
end

local 召唤兽网格_左 = 炼妖窗口:创建网格('召唤兽网格_左', 22, 43, 137, 195)
do
    function 召唤兽网格_左:初始化()
        self:添加格子(0, 0, 137, 195)

    end

    function 召唤兽网格_左:置动画(t)
        self._召唤 = t
        炼妖窗口.动画 = require('对象/基类/动作') { 外形 = t.外形, 染色 = t.染色, 模型 = 'attack' }
        炼妖窗口.动画:置循环(true)
    end

    function 召唤兽网格_左:右键弹起(x, y, i)
        self._召唤 = nil
        炼妖窗口.动画 = nil
    end
end

local 召唤兽网格_右 = 炼妖窗口:创建网格('召唤兽网格_右', 325, 43, 137, 195)
do
    function 召唤兽网格_右:初始化()
        self:添加格子(0, 0, 137, 195)
        self.数据 = {}
    end

    function 召唤兽网格_右:置动画(t)
        self._召唤 = t
        炼妖窗口.动画2 = require('对象/基类/动作') { 外形 = t.外形, 染色 = t.染色, 模型 = 'attack' }
        炼妖窗口.动画2:置循环(true)
    end

    function 召唤兽网格_右:右键弹起(x, y, i)
        self._召唤 = nil
        炼妖窗口.动画2 = nil
    end
end

local 道具网格 = 炼妖窗口:创建物品网格2('道具网格', 154, 255, 309, 207)
local 禁止精灵 = require('SDL.精灵')(0, 0, 0, 50, 50):置颜色(0, 0, 0, 180)
do
    function 道具网格:前显示2(x, y, i)
        if self.数据[i] and not self.数据[i].是否炼妖 then
            禁止精灵:显示(x, y)
        end
    end

    function 道具网格:获取道具(p)
        return __rpc:角色_物品列表(p, true)
    end

    function 道具网格:左键弹起(x, y, i)
        if self.数据[i] then
            提交网格.数据[1] = self.数据[i]:镜像()
            提交网格.数据[1].格子 = i
        end
    end

end
--=======================================================================================
local 召唤列表 = 炼妖窗口:创建列表('召唤列表', 20, 273, 96, 185)
do
    function 召唤列表:初始化()
        self:置文字(__res.F18)
    end

    function 召唤列表:添加召唤(i, t)
        if type(t) ~= "table" then
            return
        end
        local r = self:添加(t.名称)
        r.nid = t.nid
        r.外形 = t.外形
        r.染色 = t.染色
    end

    function 召唤列表:取重复(nid)
        if 召唤兽网格_左._召唤 and 召唤兽网格_左._召唤.nid == nid then
            return true
        end
        if 召唤兽网格_右._召唤 and 召唤兽网格_右._召唤.nid == nid then
            return true
        end
    end

    function 召唤列表:左键弹起(x, y, i, t)
        if 引擎:取功能键状态(SDL.KMOD_SHIFT) then --聊天框
            界面层:输入对象(t)
            return
        end

        if self:取重复(t.nid) then
            return
        end
        if 召唤兽网格_左._召唤 then
            召唤兽网格_右:置动画 { nid = t.nid, 外形 = t.外形, 染色 = t.染色 }
        else
            召唤兽网格_左:置动画 { nid = t.nid, 外形 = t.外形, 染色 = t.染色 }
        end
    end
end
召唤列表:创建我的滑块()
function 炼妖窗口:刷新数据()
    道具网格:刷新道具(道具网格.当前页 or 1)
    召唤兽网格_右:右键弹起()
    召唤兽网格_右:右键弹起()
    提交网格:清空()
    召唤列表:清空()
    local list = __rpc:角色_召唤列表()
    时间排序(list)
    for i, v in ipairs(list) do
        召唤列表:添加召唤(i, v)
    end
end

local 炼妖按钮 = 炼妖窗口:创建小按钮('炼妖按钮', 217, 185, '炼妖')
do
    function 炼妖按钮:左键弹起()
        if 召唤兽网格_左._召唤 and 提交网格.数据[1] and 召唤兽网格_右._召唤 then
            窗口层:提示窗口("不可以这么操作")
            return
        end
        if 召唤兽网格_左._召唤 then
            if 提交网格.数据[1] then --炼妖石
                local r = __rpc:角色_炼妖(提交网格.数据[1].nid, 召唤兽网格_左._召唤.nid)
                if type(r) == "string" then
                    窗口层:提示窗口("#Y" .. r)
                elseif r == true then
                    炼妖窗口:刷新数据()
                end
            elseif 召唤兽网格_右._召唤 then --合宠物
                local r = __rpc:角色_合宠(召唤兽网格_左._召唤.nid, 召唤兽网格_右._召唤.nid)
                if type(r) == "string" then
                    窗口层:提示窗口("#Y" .. r)
                elseif r == true then
                    炼妖窗口:刷新数据()
                end
            end
        end
    end
end


function 窗口层:打开炼妖窗口()
    炼妖窗口:置可见(not 炼妖窗口.是否可见)
    if not 炼妖窗口.是否可见 then
        return
    end
    提交网格:清空()
    召唤列表:清空()
    道具网格:打开()
    local list = __rpc:角色_召唤列表()
    时间排序(list)
    for i, v in ipairs(list) do
        召唤列表:添加召唤(i, v)
    end
end

return 炼妖窗口
