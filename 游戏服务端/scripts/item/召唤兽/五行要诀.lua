local 物品 = {
    名称 = '五行要诀',
    叠加 = 999,
    类别 = 8,
    类型 = 0,
    对象 = 2,
    条件 = 2,
    绑定 = false
}

function 物品:使用(对象)
    local _高级技能 = { "如人饮水", "枯木逢春", "西天净土", "炊金馔玉", "风火燎原" }
    local list = {}
    for i=#_高级技能,1,-1 do
        if 对象:取技能是否领悟(_高级技能[i]) then
            table.remove(_高级技能, i)
        end
    end
    local name = _高级技能[math.random(#_高级技能)]
    if name then
        local t,d = 对象:添加领悟技能(name)
        if d then
            self.数量 = self.数量 - 1
            对象:提示窗口(t)
            local P = 对象:取主人接口()
            发送系统("#R%s#C的#R%s#C使用五行要诀后灵光一闪，顿时领悟了一个高级技能#G[%s]#50", P.名称, 对象.名称,name)
        else
            return t
        end
    end
end

return 物品
