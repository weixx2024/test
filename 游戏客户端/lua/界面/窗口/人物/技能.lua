

local 技能 = 窗口层:创建我的窗口('技能', 0, 0, 437, 393)
function 技能:初始化()
    self:置精灵(__res:getspr('gires/0x44CD19AE.tcp'))
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
end

技能:创建关闭按钮(0, 1)

--=======================================================================================
local 技能列表 = 技能:创建多列列表('技能列表', 26, 62, 156, 308)
do
    function 技能列表:初始化()
        __res.F16:置颜色(255, 255, 255)
        self:置文字(__res.F16)
        self:添加列(0, 3, 100, 20) --名称
        self:添加列(100, 3, 56, 20) --熟练度
    end

    function 技能列表:添加技能(t)
        local r = self:添加(t.名称, t.熟练度)
        r:置高度(20)
        r.t = t

    end

    function 技能列表:左键弹起(x, y, i, t)
        _选中 = t.t
        技能说明:刷新(_选中)
    end

    local 列表上按钮 = 技能:创建按钮('列表上按钮', 184, 62)
    function 列表上按钮:初始化()
        self:设置按钮精灵('gires/0x287AF2DA.tcp')
    end

    function 列表上按钮:左键弹起()
        技能列表:向上滚动()
        技能列表:自动滚动(false)
    end

    local 列表下按钮 = 技能:创建按钮('列表下按钮', 184, -42)
    function 列表下按钮:初始化()
        self:设置按钮精灵('gires/0x03539D9C.tcp')
    end

    function 列表下按钮:左键弹起()
        if not 技能列表:向下滚动() then
            技能列表:自动滚动(true)
        end
    end
end

技能说明 = 技能:创建文本('技能说明', 237, 64, 154, 306)
技能说明:置文字(__res.F16)

function 技能说明:刷新(t)
    if not t or not t.nid then
        return
    end
    local 描述, 消耗 = __rpc:角色_技能描述(t.nid)
    local txt = ''
    if 消耗 then
        txt = string.format('【门派】%s#r【师傅】%s#r【法术系】%s#r【熟练度】%s#r【消耗MP】%s#r#G%s'
            , t.门派, t.师傅, t.法系, t.熟练度, 消耗.消耗MP, 描述)
    end
    self:置文本(txt)
end

function 窗口层:打开技能()
    技能:置可见(not 技能.是否可见)
    if not 技能.是否可见 then
        return
    end

    self:重新打开技能()
end

function 窗口层:重新打开技能()
    local t = __rpc:角色_打开技能窗口()
    if type(t) == 'table' then
        local 技能库 = require('数据/技能库')
        local list={}
        for k, v in pairs(t) do
            local r = 技能库[v.名称] 
            if r and r.区域 then
                v.排序 = r.区域 * 100 + r.位置
            else
                v.排序=1
            end
            table.insert( list, v )
        end

        table.sort( list, 
                function(a, b)
                    return a.排序 < b.排序
                end)
        技能列表:清空()
        for i, v in pairs(list) do
            setmetatable(v, { __index = 技能库[v.名称] })
            技能列表:添加技能(v)
            if _选中 and v.nid == _选中.nid then
                _选中 = v
            end
        end

        技能说明:置文本('')
        技能说明:刷新(_选中)
    end
end

return 技能
