local 物品 = {
    名称 = '角色转移卡',
    叠加 = 999,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}

function 物品:使用(对象)
    if 对象.是否玩家 then
        local 账号 = 对象:输入窗口("", "请输入将要转入的账号！")
        local 密码
        local 安全码
        if 账号 then
            密码 = 对象:输入窗口("", "请输入将要转入的账号的密码！")
            if 密码 then
                安全码 = 对象:输入窗口("", "请输入将要转入的账号的安全码！")
            end
        end
        if 账号 and 密码 and 安全码 then
            local r = 对象:确认窗口("确定将角色#G%s#W转移至账号#Y%s下么?#r#R注:转移后累充 安全码 体验码 都以账号#Y%s#R为准！请谨慎操作！"
                , 对象.名称, 账号, 账号)
            if r then
                local rr = 对象:角色转移(账号, 密码, 安全码)
                if rr == true then
                    self.数量 = self.数量 - 1
                    对象:踢下线()
                else
                    return rr
                end
            end
        end
    end
end

return 物品
