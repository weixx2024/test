

local 帮派管理 = 窗口层:创建我的窗口('帮派管理', 0, 0, 437, 450)
function 帮派管理:初始化()
    self:置精灵(__res:getspr('gires/0xA5F0181F.tcp'))
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
    --  self.头像 = __res:getspr('photo/facelarge/%d.tga', 1)
end

function 帮派管理:显示(x, y)
    if self.头像 then
        self.头像:显示(x + 287, y + 42)
    end
end

帮派管理:创建关闭按钮(0, 1)

local 成员列表 = 帮派管理:创建多列列表('成员列表22', 29, 58, 153 + 23, 208)
do
    function 成员列表:初始化()
        self.行高度 = 20
        self:取文字():置大小(20)
        self:添加列(0, 3, 95, 20) --名称
        self:添加列(95, 3, 58, 20) --职务
        -- for i = 1, 5 do
        --     self:添加('成员名称' .. i, '帮众')
        -- end
        self:置选中精灵宽度(153)
    end

    function 成员列表:添加成员(i, t)
        local r = self:添加(t.名字, t.职务)
        r.nid = t.nid
        if r.状态 == "离线" then
            self:置项目颜色(i, 74, 77, 76)
        end
    end

    function 成员列表:左键弹起(x, y, i, t)
        if t.nid then
            _选中成员 = t.nid
            local r = __rpc:角色_取帮派成员数据(t.nid)
            if type(r) == "table" then
                帮派管理:刷新成员信息(r)
                if 窗口层.帮派任命.是否可见 then
                    窗口层:刷新帮派任命nid(_选中成员)
                end
            else
                窗口层:提示窗口("#Y该成员不存在！请重新打开界面刷新成员列表")
            end
        end
    end

    成员列表:创建我的滑块()
end

function 窗口层:帮派任命刷新(v)
    成员列表:置文本2(成员列表.选中行, 2, v)
end

local 申请列表 = 帮派管理:创建多列列表('申请列表', 29, 309, 153 + 23, 116)

do
    function 申请列表:初始化()
        self.行高度 = 20
        self:取文字():置大小(20)
        self:添加列(0, 3, 95, 20) --名称
        self:添加列(95, 3, 58, 20) --等级
        self:置选中精灵宽度(153)
    end

    function 申请列表:添加成员(t)
        local r = self:添加(t.名字, t.转生 .. "转" .. t.等级)
        r.nid = t.nid
    end

    function 申请列表:左键弹起(x, y, i, t)
        if t.nid then
            _选中申请 = t.nid
        end
    end

    申请列表:创建我的滑块()
end




local yy
for k, v in pairs {
    '等级文本',
    '称谓文本',
    '种族文本',
    '性别文本',
    '成就文本',
    '贡献文本',
    '离线时间文本'
} do
    yy = 169 + k * 25 - 25
    if k >= 3 then
        yy = yy - (k - 2)
    end
    帮派管理:创建文本(v, 310, yy, 96, 15)
end

for k, v in pairs {
    '任命',
    '接收',
    '拒收',
    '逐出'
} do
    local 按钮 = 帮派管理:创建小按钮(v .. '按钮', 215 + k * 55 - 55, 355, v)
    if v == "接收" or v == "拒收" or v == "逐出" or v == "任命" then
        按钮:置禁止(true)
    end
    function 按钮:左键弹起()
        if v == "任命" then
            if _选中成员 then
                窗口层:打开帮派任命(_选中成员)
            else
                窗口层:提示窗口("#Y请先选中需要任命的成员")
            end
        elseif v == "接收" then
            if _选中申请 then
                local r, b = __rpc:角色_接收成员(_选中申请)
                if type(r) == "table" then --申请列表
                    申请列表:清空()
                    _选中申请 = nil
                    for key, value in pairs(r) do
                        申请列表:添加成员(value)
                    end
                elseif type(r) == "string" then
                    窗口层:提示窗口(r)
                end

                if type(b) == "table" then --成员列表
                    成员列表:清空()
                    _选中成员 = nil
                    for key, value in ipairs(b) do
                        成员列表:添加成员(key, value)
                    end
                elseif type(b) == "string" then
                    窗口层:提示窗口(b)
                end

            else
                窗口层:提示窗口("#Y请先选中需要接收的成员")
            end
        elseif v == "拒收" then
            local r = __rpc:角色_拒收成员()
            if type(r) == "table" then --申请列表
                申请列表:清空()
                _选中申请 = nil
                for key, value in ipairs(r) do
                    申请列表:添加成员(value)
                end
            elseif type(r) == "string" then
                窗口层:提示窗口(r)
            end

        elseif v == "逐出" then
            if _选中成员 then
                local r = __rpc:角色_逐出成员(_选中成员)
                if type(r) == "table" then
                    成员列表:清空()
                    _选中成员 = nil
                    for key, value in ipairs(r) do
                        成员列表:添加成员(key, value)
                    end
                else
                    窗口层:提示窗口(r)
                end
            else
                窗口层:提示窗口("#Y请先选中需要逐出的成员")
            end
        end
    end
end
local 脱离按钮 = 帮派管理:创建中按钮('脱离按钮', 342, 400, '脱离帮派')
function 脱离按钮:左键弹起()
    local r = __rpc:角色_脱离帮派()
    if type(r) == "string" then
        窗口层:提示窗口(r)
    else
        self.父控件:置可见(false)
    end
end

function 帮派管理:刷新成员信息(t)
    self.头像 = __res:getspr('photo/facelarge/%d.tga', t.外形)
    self.等级文本:置文本(t.转生 .. "转" .. t.等级)
    self.种族文本:置文本(_种族[t.种族] or "魔")
    self.称谓文本:置文本(t.称谓)
    self.性别文本:置文本(_性别[t.性别] or "女")

    self.贡献文本:置文本(t.帮派贡献 or 0)
    self.成就文本:置文本(t.帮派成就 or 0)
    self.离线时间文本:置文本("")
    if t.离线时间 ~= 0 then
        self.离线时间文本:置文本(os.date("%Y年%m月%d", t.离线时间))
    end


end

function 帮派管理:清空信息()
    for k, v in pairs {
        '等级文本',
        '称谓文本',
        '种族文本',
        '性别文本',
        '成就文本',
        '贡献文本',
        '离线时间文本'
    } do
        self[v]:置文本("")
    end
    self.头像 = nil
end

local _管理权限 = {
    帮主 = 8,
    副帮主 = 7,
    左护法 = 6,
    右护法 = 5,
    长老 = 4,
    堂主 = 3,
    香主 = 2,
    精英 = 1,
    帮众 = 0,
}
function 帮派管理:权限按钮()
    self.接收按钮:置禁止(_权限 < 2)
    self.拒收按钮:置禁止(_权限 < 2)
    self.逐出按钮:置禁止(_权限 < 7)
    self.任命按钮:置禁止(_权限 < 8)
end

function 窗口层:打开帮派管理()
    帮派管理:置可见(not 帮派管理.是否可见)
    if not 帮派管理.是否可见 then
        return
    end
    local a, b, c = __rpc:角色_打开帮派管理()
    _权限 = c
    _选中申请 = nil
    _选中成员 = nil
    帮派管理:权限按钮()
    帮派管理:清空信息()
    成员列表:清空()
    for key, value in ipairs(a) do
        成员列表:添加成员(key, value)
    end
    申请列表:清空()
    for key, value in pairs(b) do
        申请列表:添加成员(value)
    end


end

return 帮派管理
