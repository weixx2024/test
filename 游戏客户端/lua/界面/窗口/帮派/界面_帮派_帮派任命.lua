

local 帮派任命 = 窗口层:创建我的窗口('帮派任命', 0, 0, 119, 331)
function 帮派任命:初始化()
    self:置精灵(__res:getspr('gires/0x9B075A26.tcp'))
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
end

function 帮派任命:显示(x, y)
end

帮派任命:创建关闭按钮(0, 1)

local 按钮
for k, v in pairs { "副帮主", "左护法", "右护法", "长老", "堂主", "香主", "精英", "帮众" } do --"虎栖堂主","虎栖香主",
    按钮 = 帮派任命:创建中按钮(v .. '按钮', 17, 35 + k * 28 - 28, v)
    function 按钮:左键弹起()
        local r = __rpc:角色_任命成员(_P, v)
        if r == true then
            窗口层:帮派任命刷新(v)
            self.父控件:置可见(false)
        else
            窗口层:提示窗口(r)
        end
    end
end

function 窗口层:刷新帮派任命nid(nid)
    _P = nid
end

function 窗口层:打开帮派任命(nid)
    帮派任命:置可见(not 帮派任命.是否可见)
    if not 帮派任命.是否可见 then
        return
    end
    _P = nid
end

return 帮派任命
