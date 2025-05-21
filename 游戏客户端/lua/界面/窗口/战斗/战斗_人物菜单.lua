local 人物菜单 = 窗口层:创建窗口('人物菜单', 0, 0, 55, 168)

for k, v in pairs {
    { name = '法术按钮', txt = '法术', zy = 'gires/button/magic.tca', kjj = SDL.KEY_W },
    { name = '道具按钮', txt = '道具', zy = 'gires/button/useitem.tca', kjj = SDL.KEY_E },
    { name = '防御按钮', txt = '防御', zy = 'gires/button/defend.tca', kjj = SDL.KEY_D },
    { name = '保护按钮', txt = '保护', zy = 'gires/button/protect.tca', kjj = SDL.KEY_T },
    { name = '召唤按钮', txt = '召唤', zy = 'gires/button/call.tca' },
    { name = '召还按钮', txt = '召还', zy = 'gires/button/uncall.tca' },
    { name = '捕捉按钮', txt = '捕捉', zy = 'gires/button/catch.tca', kjj = SDL.KEY_B },
    { name = '逃跑按钮', txt = '逃跑', zy = 'gires/button/runaway.tca' }
} do
    local 按钮 = 人物菜单:创建按钮(v.name, 0, k * 21 - 21)
    function 按钮:初始化()
        self:设置按钮精灵(v.zy)
        --self:置禁止(true)
    end

    function 按钮:左键弹起()
        if 战场层.操作目标 then
            if v.name == '法术按钮' then
                _法术 = 窗口层:打开人物法术界面(战场层.操作目标.nid)
            elseif v.name == '道具按钮' then
                _道具 = 窗口层:打开战斗道具(战场层.操作目标.nid)
            elseif v.name == '防御按钮' then
                战场层.操作目标:添加动画('defense')
                回复操作('防御')
            elseif v.name == '保护按钮' then
                鼠标层:保护形状()
            elseif v.name == '召唤按钮' then
                _召唤 = 窗口层:打开战斗召唤界面(战场层.操作目标.nid)
                回复操作('召唤', _召唤)
            elseif v.name == '召还按钮' then
                回复操作('召还')
            elseif v.name == '捕捉按钮' then
                鼠标层:捕捉形状()
            elseif v.name == '逃跑按钮' then
                回复操作('逃跑')
            end
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

function 人物菜单:键盘弹起(key, mod)
    if mod & SDL.KMOD_ALT ~= 0 then
        if key == SDL.KEY_S then
            --回复操作('法术')
            if 鼠标层.角色法术 then
                窗口层:关闭法术界面()
                鼠标层:法术形状()
                鼠标层.法术 = 鼠标层.角色法术
            end
        elseif key == SDL.KEY_A then
            回复操作('物理')
        end
    end
end

function 人物菜单:置操作目标(nid,怨气)
    for i,v in pairs(战场层.对象) do
        if v.nid == nid then
            战场层:置怨气(v.怨气 or 怨气 or 149) -- 
            战场层.操作目标=v
            break
        end
    end
end

function 回复操作(指令,目标,选择)
    鼠标层.选择目标 = nil
    人物菜单:置可见(false)
    local 人物指令 = { 指令 = 指令, 目标 = 目标, 选择 = 选择 ,nid = 战场层.操作目标.nid}
    __rpc:角色_战斗操作返回(人物指令)
end

-- function 回复操作(...)
--     if not 人物菜单.co then
--         return
--     end
--     coroutine.resume(人物菜单.co, ...)
--     鼠标层.选择目标 = nil
--     人物菜单:置可见(false)
--     战场层.操作目标 = nil
--     人物菜单.召唤菜单 = nil
--     人物菜单.co = nil
--     -- 鼠标层.选择目标 = nil
--     -- 人物菜单:置可见(false)
--     -- local 人物指令 = { 指令 = 指令, 目标 = 目标, 选择 = 选择 }
--     -- if 人物菜单.召唤菜单 then
--     --     窗口层:打开召唤菜单(人物指令)
--     -- else
--     --     __rpc:角色_战斗操作返回(人物指令)
--     -- end
--     -- 人物菜单.召唤菜单 = nil
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
    elseif 鼠标层.是否捕捉 then
        if P.是否己方 then
            return
        end
        回复操作('捕捉', P.位置)
        鼠标层:正常形状()
    elseif 鼠标层.是否道具 then
        回复操作('道具', P.位置, _道具)
        鼠标层:正常形状()
    elseif 鼠标层.是否法术 then
        回复操作('法术', P.位置, _法术)
        鼠标层:正常形状()
    end
end

function 窗口层:打开人物菜单(召唤菜单,nid,怨气)
    人物菜单:置操作目标(nid,怨气)
    人物菜单:置可见(true)
    人物菜单:置坐标((引擎.宽度 - 人物菜单.宽度 - 40), (引擎.高度 - 人物菜单.高度) // 2)
    人物菜单.召还按钮:置禁止(召唤菜单)
    鼠标层.选择目标 = 选择目标
end


-- function 窗口层:打开人物菜单(召唤菜单,nid,怨气)
--     人物菜单:置操作目标(nid,怨气)
--     人物菜单:置可见(true)
--     人物菜单:置坐标((引擎.宽度 - 人物菜单.宽度 - 40), (引擎.高度 - 人物菜单.高度) // 2)
--     -- 人物菜单.召唤菜单 = 召唤菜单
--     人物菜单.召还按钮:置禁止(召唤菜单)
--     人物菜单.co = coroutine.running()
--     鼠标层.选择目标 = 选择目标
--     return coroutine.yield()
-- end

function 窗口层:关闭人物菜单()
    人物菜单:置可见(false)
    战场层.操作目标 = nil
    人物菜单.co = nil
end


function RPC:助战关闭人物战斗菜单()
    人物菜单:置可见(false)
end

return 人物菜单
