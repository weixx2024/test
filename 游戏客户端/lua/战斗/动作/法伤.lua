

local 数据 = {}

function 数据:初始化()
end

function 数据:播放战斗(data, 自己, 来源)
    local t = table.remove(data, 1)
    local co, tco = (coroutine.running())
    if t.法伤转增加 then
        自己:添加绿数字(t.数值, t.类型)
    else
        自己:添加红数字(t.数值, t.类型)
    end
    
    if t.tx then
        自己:添加M动画(t.tx)
    end
    if t.怨气  then
        自己:置怨气(t.怨气)
    end

    if t.反震 then
        if 来源 then
            来源:播放战斗(t.反震)
        else
            __rpc:上报BUG("法伤来源空")
        end
    end
    if t.死亡 then
        自己:动作_死亡()
        if t.消失 then
            自己.是否删除 = os.time() + 2
        end
    else
        自己:动作_受击()
        自己:置帧率(1 / 14)
    end
    自己.是否死亡 = t.死亡
end

function 数据:显示(x, y)
end

return 数据
