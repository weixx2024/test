local 法术 = {
    类别 = '属性',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '被攻击时释放魔神附身',
    是否被动 = true,
}
local BUFF
local BUFF2



function 法术:进入战斗(攻击方)
    local b = 攻击方:进入战斗添加BUFF(BUFF)
    b.回合 = 150
end

function 法术:法术取目标数()
    return self:取目标数(), function(a, b)
        return a.攻击 > b.攻击
    end
end

function 法术:法术取回合()
    return 3
end

BUFF = {
    法术 = '被攻击时释放魔神附身',
    名称 = '被攻击时释放魔神附身',
}
法术.BUFF = BUFF
function BUFF:BUFF被物理攻击后(攻击方, 挨打方)
    if 挨打方 then
        local 触发 = 挨打方.被攻击时释放魔神附身 > 100 and true or math.random(100) <= 挨打方.被攻击时释放魔神附身

        if 触发 then
            local dst = 挨打方:我方属性排序(
                3,
                function(v)
                    if not v.是否死亡 and not v.是否隐身 and not v:取BUFF('封印') then
                        return true
                    end
                end,
                function(a, b)
                    return a.攻击 > b.攻击
                end
            )
            local t = {}
            for k, v in pairs(dst) do
                t[v.位置] = { 位置 = v.位置 }
            end
            挨打方:播放特效(1005, t, t) --, dst
            for k, v in pairs(dst) do
                local b = v:进入战斗添加BUFF(BUFF2)
                if b then
                    b.回合 = 3
                    b.效果 = { 命中率 = 15, 攻击 = math.floor(v.攻击 * 0.36) }
                    v.命中率 = v.命中率 + b.效果.命中率
                    v.攻击 = v.攻击 + b.效果.攻击
                end
            end
        end
    end
end

BUFF2 = {
    法术 = '魔神附身',
    名称 = '攻',
    id = 1006
}


法术.BUFF2 = BUFF2
function BUFF2:BUFF回合结束(单位)
    if self.回合数 >= self.回合 then
        self:删除()
        单位.攻击 = 单位.攻击 - self.效果.攻击
        单位.命中率 = 单位.命中率 - self.效果.命中率
    end
end

return 法术
