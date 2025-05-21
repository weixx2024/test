local 召唤菜单 = 窗口层:创建窗口('召唤菜单', 0, 0, 55, 84)

for k, v in pairs {
    { name = '法术按钮', txt = '法术', zy = 'gires/button/magic.tca', kjj = SDL.KEY_W },
    { name = '道具按钮', txt = '道具', zy = 'gires/button/useitem.tca', kjj = SDL.KEY_E },
    { name = '防御按钮', txt = '防御', zy = 'gires/button/defend.tca', kjj = SDL.KEY_D },
    { name = '保护按钮', txt = '保护', zy = 'gires/button/protect.tca', kjj = SDL.KEY_T }
} do
    local 按钮 = 召唤菜单:创建按钮(v.name, 0, k * 21 - 21)
    function 按钮:初始化()
        self:设置按钮精灵(v.zy)
    end

    function 按钮:左键弹起()
        if v.name == '法术按钮' then
            local r = 窗口层:打开召唤法术界面(战场层.操作目标.nid)
            _法术 = r
        elseif v.name == '道具按钮' then
            local r = 窗口层:打开战斗道具(战场层.操作目标.fnid)
            _道具 = r
        elseif v.name == '防御按钮' then
            if 战场层.操作目标 then
                战场层.操作目标:添加动画('defense')
            elseif 战场层.sum then
                战场层.sum:添加动画('defense')
            end
            
            回复操作('防御')
        elseif v.name == '保护按钮' then
            鼠标层:保护形状()
        end
    end

    function 按钮:键盘弹起(key, mod)
        if mod & SDL.KMOD_ALT ~= 0 then
            if key == v.kjj then
                self:左键弹起()
            end
        end
    end
end

function 召唤菜单:键盘弹起(key, mod)
    if mod & SDL.KMOD_ALT ~= 0 then
        if key == SDL.KEY_S then
            if 鼠标层.召唤法术 then
                窗口层:关闭法术界面()
                鼠标层:法术形状()
                鼠标层.法术 = 鼠标层.召唤法术
            end
        elseif key == SDL.KEY_A then
            回复操作('物理')
        end
    end
end

function 召唤菜单:置操作目标(nid,fnid)
    if 战场层.对象 then
        for i,v in pairs(战场层.对象) do
            if v.nid == nid then
                战场层.操作目标=v
                战场层.操作目标.fnid=fnid
                break
            end
        end
    end
end

function 回复操作(指令,目标,选择)
    鼠标层.选择目标 = nil
    召唤菜单:置可见(false)
    local 召唤指令 = { 指令 = 指令, 目标 = 目标, 选择 = 选择 ,nid = 战场层.操作目标.nid}
    __rpc:角色_战斗操作返回(人物指令, 召唤指令)
end


-- function 回复操作(...)
--     if not 召唤菜单.co then
--         return
--     end
--     coroutine.resume(召唤菜单.co, ...)
--     鼠标层.选择目标 = nil
--     召唤菜单:置可见(false)
--     战场层.操作目标 = nil
--     召唤菜单.co = nil
--     -- 鼠标层.选择目标 = nil
--     -- 召唤菜单:置可见(false)
--     -- local 人物指令 = 召唤菜单.人物指令
--     -- local 召唤指令 = { 指令 = 指令, 目标 = 目标, 选择 = 选择 }
--     -- __rpc:角色_战斗操作返回(人物指令, 召唤指令)
--     -- 召唤菜单.人物指令 = nil
-- end

function 选择目标(P)
    if 鼠标层.是否攻击 then
        回复操作('物理', P.位置)
    elseif 鼠标层.是否保护 then
        if P.是否敌方 then
            return
        end
        回复操作('保护', P.位置)
        鼠标层:正常形状()
    elseif 鼠标层.是否道具 then
        回复操作('道具', P.位置, _道具)
        鼠标层:正常形状()
    elseif 鼠标层.是否法术 then
        回复操作('法术', P.位置, _法术)
        鼠标层:正常形状()
    end
end

function 窗口层:打开召唤菜单(nid,fnid)
    召唤菜单:置操作目标(nid,fnid)
    召唤菜单:置可见(true)
    召唤菜单:置坐标((引擎.宽度 - 召唤菜单.宽度 - 40), (引擎.高度 - 召唤菜单.高度) // 2)
    鼠标层.选择目标 = 选择目标
end


-- function 窗口层:打开召唤菜单(nid,fnid)
--     召唤菜单:置操作目标(nid,fnid)
--     召唤菜单:置可见(true)
--     召唤菜单:置坐标((引擎.宽度 - 召唤菜单.宽度 - 40), (引擎.高度 - 召唤菜单.高度) // 2)
--     -- 召唤菜单.人物指令 = 人物指令
--     召唤菜单.co = coroutine.running()
--     鼠标层.选择目标 = 选择目标
--     return coroutine.yield()
-- end

function 窗口层:关闭召唤菜单()
    召唤菜单:置可见(false)
    战场层.操作目标 = nil
    召唤菜单.co = nil
end

function RPC:助战关闭召唤战斗菜单()
    召唤菜单:置可见(false)
end

return 召唤菜单
