local 管理界面1 = 窗口层:创建我的窗口('管理界面1', 0, 0, 600, 550)
--1级 只能给对应标签操作  2级 所有标签操作
_记录 = {}
local 选中角色数据


function 管理界面1:初始化()
    self:置精灵(
        self:取老红木窗口(
            self.宽度,
            self.高度,
            '管理界面',
            function()
                __res.JMZ:取图像('操\n作\n记\n录'):显示(25, 60)
                self:取拉伸图像_宽高('gires/main/border.bmp', 120, 22):显示(20, 160):显示(220, 160):显示(420
                    , 160)
                self:取拉伸图像_宽高('gires/main/border.bmp', 500, 115):显示(50, 36)
            end
        )
    )
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
end

function 管理界面1:显示(x, y)

end

管理界面1:创建关闭按钮()

标签控件 = 管理界面1:创建标签('标签控件', 9, 200, 580, 350)

--充值 账号封禁 角色封禁 禁言 禁交易 角色数据修改等
账号管理按钮 = 标签控件:创建自定义小标签按钮('账号管理按钮', 0, 300, '账号管理', 90,
    --道具发放

    30) --权限1
角色管理按钮 = 标签控件:创建自定义小标签按钮('角色管理按钮', 95, 300, '角色管理', 90
    ,
    30) --权限1

道具管理按钮 = 标签控件:创建自定义小标签按钮('道具管理按钮', 190, 300, '道具管理', 90
    , 30) --权限2
--装备发放  装备数据修改
装备管理按钮 = 标签控件:创建自定义小标签按钮('装备管理按钮', 285, 300, '装备管理', 90
    , 30) --权限2
--召唤兽发放 召唤兽数据管理
召唤管理按钮 = 标签控件:创建自定义小标签按钮('召唤管理按钮', 380, 300, '召唤管理', 90
    , 30) --权限2
--获得 服务端参数配置修改
服务器管理按钮 = 标签控件:创建自定义小标签按钮('服务器管理按钮', 380 + 95, 300, '服务器管理'
    , 90, 30) --权限3












--local 道具管理区域 = 标签控件:创建区域(道具管理按钮, 0, 0, 485, 300)

local 记录列表 = 管理界面1:创建列表('记录列表', 55, 40, 425+60, 110)
do --公用区域
    do
        function 记录列表:初始化()
            self.选中精灵 = nil
            self.焦点精灵 = nil
            self.行间距 = 2
            --self:置宽高(内容区域.宽度 - 10, 内容区域.高度 - 10)
            self:自动滚动(true)


            -- for i = 1, 20, 1 do
            --     self:添加内容("操作记录" .. i, s)
            -- end
        end

        function 记录列表:检查消息()
            return false
        end

        function 记录列表:重置内容()
            记录列表:清空()
            for i = 1, 50 do
                table.remove(_记录, 1)
            end
            for index, value in ipairs(_记录) do
                记录列表:添加内容(value, 1)
            end
        end

        function 记录列表:添加内容(t, s)
            if not s then
                table.insert(_记录, t)
                if #_记录 >= 100 then
                    记录列表:重置内容()
                    return
                end
            end
            local r = self:添加(t):置精灵()
            local 文本 = r:创建我的文本('文本', 0, 0, self.宽度, 500)
            local _, h = 文本:置文本(t)
            文本:置高度(h)
            r:置高度(h)
            r:置可见(true, true)
        end
    end

    local 账号输入 = 管理界面1:创建文本输入('账号输入', 20 + 3, 160 + 2, 120, 14)
    账号输入:置颜色(255, 255, 255, 255)
    账号输入:置文本("请输入查询账号")
    local 账号查询按钮 = 管理界面1:创建小按钮("账号查询", 145, 158, "查询")

    function 账号查询按钮:左键弹起()
        local r = 账号输入:取文本()
        if r == "请输入查询账号" or r == "" then
            窗口层:提示窗口('#Y请输入查询账号')
            return
        end
        local t, js = __rpc:角色_GM_按账号查询(r)
        
        if type(t) == "string" then
            窗口层:提示窗口(t)
            return
        end
        -- if type(js)=="table" then 
        --     选中角色数据=js[1]
        -- end
        _选中角色 = nil
        账号管理区域.角色列表:清空()
        if type(t) == "table" then
            账号管理区域:刷新账号信息(t)
        end
        if type(js) == "table" then
            账号管理区域:刷新角色列表信息(js)
            道具管理区域:刷新角色信息(js[1].nid)
            if js[1].nid then 
                道具管理区域:刷新道具(1, js[1].nid)
                end
        end
    end

    local 名称输入 = 管理界面1:创建文本输入('名称输入', 223, 162, 120, 14)
    名称输入:置颜色(255, 255, 255, 255)
    名称输入:置文本("请输入查询名称")

    local 名称查询按钮 = 管理界面1:创建小按钮("名称查询", 345, 158, "查询")
    function 名称查询按钮:左键弹起()
        local r = 名称输入:取文本()
        if r == "请输入查询名称" or r == "" then
            窗口层:提示窗口('#Y请输入查询名称')
            return
        end
        local t, js = __rpc:角色_GM_按名称查询(r)
        if type(t) == "string" then
            窗口层:提示窗口(t)
            return
        end
        _选中角色 = nil
        账号管理区域.角色列表:清空()
        if type(t) == "table" then
            账号管理区域:刷新账号信息(t)
        end
        if type(js) == "table" then
            账号管理区域:刷新角色列表信息(js)
            道具管理区域:刷新角色信息(js[1].nid)
            if js[1].nid then 
                道具管理区域:刷新道具(1, js[1].nid)
                end
        end
    end

    local ID输入 = 管理界面1:创建文本输入('ID输入', 423, 160 + 2, 120, 14)
    ID输入:置颜色(255, 255, 255, 255)
    ID输入:置文本("请输入查询ID")

    local ID查询按钮 = 管理界面1:创建小按钮("ID查询", 545, 158, "查询")

    function ID查询按钮:左键弹起()
        local r = ID输入:取文本()
        if r == "请输入查询ID" or r == "" then
            窗口层:提示窗口('#Y请输入查询ID')
            return
        end
        local t, js = __rpc:角色_GM_按ID查询(r)
        if type(t) == "string" then
            窗口层:提示窗口(t)
            return
        end
        _选中角色 = nil
        账号管理区域.角色列表:清空()
        if type(t) == "table" then
            账号管理区域:刷新账号信息(t)
        end
     
        if type(js) == "table" then
            账号管理区域:刷新角色列表信息(js)
            道具管理区域:刷新角色信息(js[1].nid)
            if js[1].nid then 
            道具管理区域:刷新道具(1, js[1].nid)
            end
        end
    end

end


function 窗口层:添加管理日志(s, ...)
    if select('#', ...) > 0 then
        s = s:format(...)
    end
    记录列表:添加内容(s)


end

function 窗口层:打开管理界面1()
    管理界面1:置可见(not 管理界面1.是否可见)
    if not 管理界面1.是否可见 then
        return
    end
    _选中角色 = nil
    _当前账号 = nil
    账号管理按钮:置选中(true)
    --todo 获取记录
end

function 窗口层:置账号(s)
    管理界面1.账号输入:置文本(r)
end

function RPC:添加管理日志(...)
    窗口层:添加管理日志(...)
end

return _ENV
--return 管理界面1
