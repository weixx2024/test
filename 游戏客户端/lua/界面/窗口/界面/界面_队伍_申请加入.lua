local 申请加入队伍 = 窗口层:创建我的窗口('申请加入队伍窗口', 0, 0, 329, 276)

local _申请列表 = {}

function 申请加入队伍:初始化()
    self:置精灵(__res:getspr('gires/0x8FCD5E87.tcp'))
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
end

申请加入队伍:创建关闭按钮(0, -277)

local 申请列表 = 申请加入队伍:创建多列列表('申请列表', 20, 64, 289, 142)
function 申请列表:初始化()
    self.行高度 = 20
    self:取文字():置大小(16)
    self:添加列(0, 2, 105, 20) --名称
    self:添加列(130, 2, 65, 20) --等级
    self:添加列(200, 2, 50, 20) --种族
    self:添加列(250, 2, 50, 20) --性别
end

local 允许按钮 = 申请加入队伍:创建小按钮('允许按钮', 50, 228, '允许')
function 允许按钮:左键弹起()
    local 选中行 = 申请列表.选中行
    if 选中行 > 0 then
        local 玩家 = _申请列表[选中行]
        if 玩家 then
            local r = __rpc:角色_允许加入队伍(玩家.nid)
            if r then
                申请列表:删除选中()
                table.remove(_申请列表, 选中行)
            end
            申请加入队伍:置可见(申请列表:取行数() ~= 0)
            if type(r) == 'string' then
                窗口层:提示窗口(r)
            end
        end
    end
end

local 拒绝按钮 = 申请加入队伍:创建小按钮('拒绝按钮', 140, 228, '拒绝')
function 拒绝按钮:左键弹起()
    local 选中行 = 申请列表.选中行
    if 选中行 > 0 then
        local 玩家 = _申请列表[选中行]
        if 玩家 then
            local r = __rpc:角色_拒绝加入队伍(玩家.nid)
            if r then
                申请列表:删除选中()
                table.remove(_申请列表, 选中行)
            end
            申请加入队伍:置可见(申请列表:取行数() ~= 0)
        end
    end
end

local 清空按钮 = 申请加入队伍:创建小按钮('清空按钮', 230, 228, '清空')
function 清空按钮:左键弹起()
    local r = __rpc:角色_清空申请队伍()
    if r then
        _申请列表 = {}
    end
    申请加入队伍:置可见(false)
end

function 窗口层:获取申请加入队伍()
    local r = __rpc:角色_打开队伍申请窗口()
    申请列表:清空()
    if type(r) == 'table' then
        _申请列表 = r -- 存内存
        for _, v in pairs(r) do
            申请列表:添加(v.名称, v.等级, _种族[v.种族], _性别[v.性别])
        end
        申请列表:置选中(1)
    end
end

function 窗口层:打开申请加入队伍()
    申请加入队伍:置可见(not 申请加入队伍.是否可见)
    if not 申请加入队伍.是否可见 then
        return
    end
    self:获取申请加入队伍()
end

function 窗口层:关闭申请加入队伍()
    申请加入队伍:置可见(false)
end

function 窗口层:申请加入队伍(nid)
    local r = __rpc:角色_申请加入队伍(nid)
    if type(r) == 'string' then
        窗口层:提示窗口(r)
    else
        窗口层:提示窗口('#R错误')
    end
end
return 申请加入队伍
