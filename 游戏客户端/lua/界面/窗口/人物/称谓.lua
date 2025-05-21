


local 人物称谓 = 窗口层:创建我的窗口('人物称谓', 0, 0, 281, 403)
function 人物称谓:初始化()
    self:置精灵(
        生成精灵(
            281,
            403,
            function()
                __res:getsf('gires/0x998C9040.tcp'):显示(0, 0)
            end
        )
    )

    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
    self.选中 = 0
end

人物称谓:创建文本('当前称谓文本', 129, 48, 110, 15)

local 称谓列表 = 人物称谓:创建列表('称谓列表', 32, 104, 196, 126)
function 称谓列表:初始化()
    __res.F14:置颜色(128, 192, 255)
    self:置文字(__res.F14)
    __res.F14:置颜色(255, 255, 255)
end

function 称谓列表:添加称谓(i, t)
    local r = self:添加(t)
    r:置高度(18)
end

function 称谓列表:左键弹起(x, y, i, t)
    人物称谓.选中 = i
end

function 人物称谓:可见事件(v)
    if v == false then
        __rpc:角色_关闭称谓窗口()
    end
end

function 人物称谓:刷新称谓(r)
    if type(r) == 'table' then
        人物称谓.选中 = 0
        称谓列表:清空()
        local 当前称谓 = ''
        _数据 = {}
        if r[1] ~= nil and r[1] ~= 'nil' then
            当前称谓 = r[1]
        end
        for k, v in pairs(r) do
            if k > 1 then
                称谓列表:添加称谓(k - 1, v)
                table.insert(_数据, v)
            end
        end
        if 窗口层.人物.是否可见 == true then
            窗口层.人物:刷新称谓(当前称谓)
        end
        人物称谓.当前称谓文本:置文本('#c80C0FF' .. 当前称谓)
    end
end

人物称谓:创建关闭按钮(0, 1)

local 列表上按钮 = 人物称谓:创建按钮('列表上按钮', 230, 104)
function 列表上按钮:初始化()
    self:设置按钮精灵('gires/0x287AF2DA.tcp')
end

function 列表上按钮:左键弹起()
    称谓列表:向上滚动()
    称谓列表:自动滚动(false)
end

local 列表下按钮 = 人物称谓:创建按钮('列表下按钮', 230, 210)
function 列表下按钮:初始化()
    self:设置按钮精灵('gires/0x03539D9C.tcp')
end

function 列表下按钮:左键弹起()
    if not 称谓列表:向下滚动() then
        称谓列表:自动滚动(true)
    end
end

local 更改称谓按钮 = 人物称谓:创建中按钮('更改称谓按钮', 165, 320, '更改称谓', 85)
function 更改称谓按钮:左键弹起()
    if 人物称谓.选中 ~= 0 then
        local r = __rpc:角色_更换称谓(人物称谓.选中)
        人物称谓:刷新称谓(r)
    end
end

local 隐藏称谓按钮 = 人物称谓:创建中按钮('隐藏称谓按钮', 165, 350, '隐藏称谓', 85)
function 隐藏称谓按钮:左键弹起()
    local r = __rpc:角色_隐藏称谓()
    人物称谓:刷新称谓(r)
end

local 删除称谓按钮 = 人物称谓:创建小按钮('删除称谓按钮', 30, 350, '删除')
function 删除称谓按钮:左键弹起()
    if 人物称谓.选中 ~= 0 then
        local r = __rpc:角色_删除称谓(_数据[人物称谓.选中])
        人物称谓:刷新称谓(r)
    end
end

function 窗口层:打开人物称谓()
    人物称谓:置可见(not 人物称谓.是否可见)
    if not 人物称谓.是否可见 then
        return
    end
    local r = __rpc:角色_打开称谓窗口()
    人物称谓:刷新称谓(r)
end

return 人物称谓
