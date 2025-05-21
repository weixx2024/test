

function 窗口层:初始化()
    self:置宽高(引擎.宽度, 引擎.高度)
end

function 窗口层:重新初始化() --取消
    self:置宽高(引擎.宽度, 引擎.高度)
    -- for k, v in self:遍历控件() do
    --     v:置可见(false)
    -- end
end

function 窗口层:进入战斗() 
    if 窗口层.道具 and 窗口层.道具.是否可见 then
        窗口层.道具.是否可见 = false
        窗口层:打开道具()
    end
end

function 窗口层:退出战斗() 
    if 窗口层.道具.是否可见 then
        
    end
end

function RPC:请求刷新物品()
    return 窗口层.道具.是否可见 -- or 窗口层.交易.是否可见
end

function RPC:请求刷新人物()
    if 窗口层.人物.是否可见 then
        窗口层:重新打开人物()
    end
    if 窗口层.人物抗性.是否可见 then
        窗口层:重新打开人物抗性()
    end
end

function RPC:请求刷新人物技能()
    if 窗口层.技能.是否可见 then
        窗口层:重新打开技能()
    end
end


function RPC:刷新银子()
    if 窗口层.道具.是否可见 then
        窗口层:刷新银子()
    end
end

function RPC:刷新仙玉()
    if 窗口层.多宝阁.是否可见 then
        窗口层:刷新仙玉()
    end
    if 窗口层.确认购买窗口.是否可见 then
        窗口层:刷新仙玉2()
    end
end
function RPC:刷新师贡()
    if 窗口层.道具.是否可见 then
        窗口层:刷新师贡()
    end
end

function RPC:请求刷新召唤列表(nid)
    if 窗口层.召唤.是否可见 then
        窗口层:重新打开召唤(nid)
    end
end

function RPC:请求刷新召唤(nid)
    if 窗口层.召唤.是否可见 then
        窗口层:重新打开召唤(nid)
    end
    if 窗口层.内丹栏.是否可见 then
        窗口层:重新打开内丹栏(nid)
    end
end

function RPC:刷新物品(t)
    for k, v in pairs(t) do
        local p = k // 24
        local i = k % 24

        if i == 0 then
            i = 24
        else
            p = p + 1
        end
        if type(v) == 'table' then
            v.B = _物品[p]
            v.i = i
            v.I = k
            _物品[p][i] = require('界面/数据/物品')(v)
        else
            _物品[p][i] = nil
        end
    end
end

return 窗口层
