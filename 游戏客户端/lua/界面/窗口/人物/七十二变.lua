local _变身卡库 = require("数据/变身卡库")

local 七十二变 = 窗口层:创建我的窗口('七十二变', 0, 0, 556, 370)

function 七十二变:初始化()
    self:置精灵(__res:getspr('gires/0xB950DF91.tcp'))
    -- self.卡片 = __res:getspr('card/%d.tcp', 9323)
    self.框 = __res:getspr('card/misc/bframe.tcp')
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
    self.选中 = 0
end

function 七十二变:显示(x, y)
    if self.卡片 then
        self.卡片:显示(x + 199, y + 62)
    end
    self.框:显示(x + 198, y + 61)
end

function 七十二变:刷新界面(r)
    self.卡册列表:清空()
    self.选中 = 0
    self.卡片 = nil
    self.卡片说明:置文本('')
    for i, v in ipairs(r) do
        self.卡册列表:添加卡片(i, v)
    end
end

--=======================================================================================
do
    local 说明上按钮 = 七十二变:创建按钮('说明上按钮', 123, 313)
    function 说明上按钮:初始化()
        self:设置按钮精灵('gires/0x287AF2DA.tcp')
    end

    function 说明上按钮:左键弹起()
    end

    local 说明下按钮 = 七十二变:创建按钮('说明下按钮', 142, 313)
    function 说明下按钮:初始化()
        self:设置按钮精灵('gires/0x03539D9C.tcp')
    end

    function 说明下按钮:左键弹起()
    end

    七十二变:创建关闭按钮()
end
--=======================================================================================
do
    local 卡册列表 = 七十二变:创建多列列表('卡册列表', 394, 53, 124, 279)
    function 卡册列表:初始化()
        self:添加列(0, 2, 100, 20) --类型
        self:添加列(90, 2, 30, 20) --数值
    end

    function 卡册列表:添加卡片(i, t)
        local name = t.取出.属性类型 == 1 and t.取出.key or t.取出.name .. "属性卡"
        local r = self:添加(name, t.取出.数量)
        r.数据 = t.数据
        r:置高度(18)
    end

    function 卡册列表:左键弹起(x, y, i, t)
        七十二变.选中 = i
        七十二变.卡片 = __res:getspr('card/%d.tcp', t.数据.皮肤)
        七十二变.卡片说明:置文本("#C" .. t.数据.介绍)
        --  self:删除(i)
    end

    local 列表上按钮 = 七十二变:创建按钮('列表上按钮', 518 - 37, 313)
    function 列表上按钮:初始化()
        self:设置按钮精灵('gires/0x287AF2DA.tcp')
    end

    function 列表上按钮:左键弹起()
        卡册列表:向上滚动()
        卡册列表:自动滚动(false)
    end

    local 列表下按钮 = 七十二变:创建按钮('列表下按钮', 518 - 18, 313)
    function 列表下按钮:初始化()
        self:设置按钮精灵('gires/0x03539D9C.tcp')
    end

    function 列表下按钮:左键弹起()
        if not 卡册列表:向下滚动() then
            卡册列表:自动滚动(true)
        end
    end
    local 卡片说明 = 七十二变:创建我的文本('卡片说明', 36, 53, 124, 279)
    local 取出按钮 = 七十二变:创建中按钮('取出按钮', 235, 320, '取出卡片', 85)
    function 取出按钮:左键弹起()
        if 七十二变.选中 and 七十二变.选中 ~= 0 then
            local r = __rpc:角色_取出卡片(七十二变.选中)
            if type(r) == "string" then
                窗口层:提示窗口(r)
                return
            end
            if r == 0 then
                卡册列表:删除(七十二变.选中)
            else
                卡册列表:置文本2(卡册列表.选中行, 2, r)
            end
        end
    end
end

function 窗口层:打开七十二变()
    七十二变:置可见(not 七十二变.是否可见)
    if not 七十二变.是否可见 then
        return
    end
    local t = __rpc:角色_打开七十二变()

    local list = {}
    if type(t) == "table" then
        for i, v in ipairs(t) do
            if _变身卡库[v.key] and _变身卡库[v.key][v.属性id] then
                local sj = _变身卡库[v.key][v.属性id]
                table.insert(list, {
                    数据 = sj,
                    取出 = v
                })
            end
        end
    end
    七十二变:刷新界面(list)

end

return 七十二变
