local 战斗自动 = 窗口层:创建窗口('战斗自动', 0, 0, 150, 95)

function 战斗自动:初始化()
    self:置精灵(self:取拉伸精灵_宽高('gires/main/border.bmp', 150, 95))
end

function 战斗自动:可见事件(v)
    if v == false then
        __rpc:角色_战斗自动(false)
    end
end

local 文本 = 战斗自动:创建文本('文本', 15, 15, 130, 65)
文本.行间距 = 4
local 取消按钮 = 战斗自动:创建文字按钮('取消按钮', 30, 70, '取消')

function 取消按钮.左键弹起()
    战斗自动:置可见(false)
    __rpc:角色_战斗自动(false)
end

local 自动按钮 = 战斗自动:创建文字按钮('自动按钮', 90, 70, '自动')
function 自动按钮.左键弹起()
    if __rol.是否战斗 then
        窗口层:打开战斗自动(__rpc:角色_战斗自动(true))
    end
end

local _名称 = {
    物理 = '物理攻击',
    法术 = '法术攻击',
}
function 窗口层:打开战斗自动(回合, 人物, 召唤) --按钮反馈
    战斗自动:置可见(true)
    战斗自动:置坐标(引擎.宽度2 - 75, 引擎.高度 - 150)
    文本:置文本('自动还剩余#R %s #W回合#r人  物    #Y%s#r#W召唤兽    #Y%s', 回合, _名称[人物] or
        人物, _名称[召唤] or 召唤 or '无')
end

function RPC:助战切换战斗自动(回合, 人物, 召唤)
    战斗自动:置可见(true)
    战斗自动:置坐标(引擎.宽度2 - 75, 引擎.高度 - 150)
    文本:置文本('自动还剩余#R %s #W回合#r人  物    #Y%s#r#W召唤兽    #Y%s', 回合, _名称[人物] or
        人物, _名称[召唤] or 召唤 or '无')
end

function RPC:助战关闭战斗自动(回合, 人物, 召唤)
    战斗自动:置可见(false)
end

function 窗口层:打开战斗自动2(回合, 人物, 召唤) --执行反馈
    窗口层:打开战斗自动(回合, 人物, 召唤)
    if 人物 == '防御' and 窗口层.人物菜单.是否可见 then
        战场层.rol:添加动画('defense')
    end
    if 召唤 == '防御' and 战场层.sum then --and 窗口层.召唤菜单.是否可见
        战场层.sum:添加动画('defense')
    end
end

return 战斗自动
