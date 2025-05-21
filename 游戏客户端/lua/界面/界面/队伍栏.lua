

local 队伍栏 = 界面层:创建控件('队伍栏', -530, 0, 260, 52)

for i = 1, 5 do
    local 头像控件 = 队伍栏:创建控件('头像控件' .. i, (5 - i) * 46, 0, 46, 46)
    function 头像控件:初始化()
        self:置精灵(
            self:取拉伸精灵_宽高('gires/main/border.bmp', 46, 46)

        )

        self:置可见(false)
    end

    local 头像 = 头像控件:创建按钮('头像' .. i, 3, 3, 40, 40)

    function 头像:获得鼠标(x, y, i)
      --  print("队友头像:获得鼠标")
    end

    function 头像控件:置头像(t)
        local spr = __res:getspr('photo/facesmall/%d.tga', t.头像)--todo 资源没有
        if spr then
            头像:置正常精灵(spr)
            头像:置按下精灵(spr:复制():置中心(-1, -1))
        end
    end

    function 头像:左键弹起()
        if 队伍栏.队伍数据[i] and 队伍栏.队伍数据[i].nid ~= __rol.nid then
            __rpc:助战_切换角色(__rol.id, __rol.nid, 队伍栏.队伍数据[i].id, 队伍栏.队伍数据[i].nid)
        end
    end

end

function 界面层:置队伍(t)
    队伍栏.队伍数据 = t
    if type(t) == 'table' then
        队伍栏:置可见(true)
        for i = 1, 5 do
            if t[i] then
                队伍栏['头像控件' .. i]:置可见(true):置头像(t[i])
            else
                队伍栏['头像控件' .. i]:置可见(false)
            end
        end
    else
        队伍栏:置可见(false)
    end
end

function RPC:界面信息_队伍(t)
    if type(t) ~= 'table' then
        队伍栏:置可见(false)
        return
    end
   
    _R._队伍数据 = t --写到资源
    界面层:置队伍(t)
    __rol.是否组队 = next(t) ~= nil
    if 窗口层.队伍.是否可见 then
        if __rol.是否组队 then
            coroutine.xpcall(窗口层.打开队伍, 窗口层, true)
        else
            窗口层.队伍:置可见(false)
        end
    end
end

return 队伍栏
