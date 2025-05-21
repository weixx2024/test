

local 提示窗口 = GUI:创建弹出控件('提示窗口', 引擎.宽度2 - 160, 引擎.高度2, 320, 引擎.高度)
提示窗口.自动关闭 = false --非焦点按下不会关闭

local 提示列表 = 提示窗口:创建列表('提示列表', 0, 0, 320, 引擎.高度)
do
    提示列表.行间距 = 0
    提示列表.选中精灵 = nil
    提示列表.焦点精灵 = nil
    function 提示列表:更新(dt)
        local ot = os.time()
        for i, v in self:遍历项目() do
            if ot >= v.时间 then
                self:左键弹起(x, y, 1)
                break
            end
        end
    end

    function 提示列表:左键弹起(x, y, i, item)
        self:删除(i)
        提示窗口:置可见(self:取行数() > 0)
        self:居中()
    end
    
    function 提示列表:右键弹起(x, y, i, item)
        -- self:删除(i)
        提示列表:清空()
        提示窗口:置可见(false)
        -- self:居中()
    end

    function 提示列表:居中()
        ::try::
        local all = 0
        for k, v in self:遍历项目() do
            all = all + v.高度
        end
        if all > 引擎.高度 then
            self:删除(1)
            goto try
        end
        提示窗口:置坐标(引擎.宽度2 - 160, (引擎.高度 - all) // 2)
        --因为游戏启动前，宽高 是640*480，所以这里重置一下
        提示窗口:置宽高(320, all)
        提示列表:置宽高(320, 引擎.高度)
    end

    function 提示列表:添加内容(str)
        local 控件 = 提示列表:添加('ggelua')
        控件.时间 = os.time() + 2
        local 文本 = 控件:创建我的文本('提示文本', 15, 20, 300, 150)

        local w, h = 文本:置文本(str or "没有提示")
        if w == nil then
            return
        end
        if w < 290 then
            w = 290
        end
        文本:置高度(h)
        控件:置精灵(self:取拉伸精灵_宽高('gires4/jdmh/yjan/tmk2.tcp', w + 30, h + 40), true)
        控件:置可见(true, true)
        self:居中()
        return 控件
    end
end

function 窗口层:提示窗口(s, ...)
    if select('#', ...) > 0 then
        s = s:format(...)
    end
    提示列表:添加内容(s)
    提示窗口:置可见(true)
    __res:界面音效('sound/addon/sysmsg.wav')
end

function RPC:提示窗口(...)
    窗口层:提示窗口(...)
    界面层:添加聊天(...)
end


function RPC:常规提示(...)
    窗口层:提示窗口(...)
end

function RPC:聊天框提示(...)
    界面层:添加聊天(...)
end
