local 物品 = {
    名称 = '高级悔梦石',
    叠加 = 999,
    类别 = 3,
    类型 = 0,
    对象 = 0,
    条件 = 0,
    绑定 = false,
}
function 物品:初始化()
    if not self.参数 then
        self.参数 = 4
    end
end

function 物品:使用(对象)

end

function 物品:取描述()
    return string.format("#Y可用来对%s阶和%s阶以下的仙器进行高级重铸", self.参数, self.参数)
end

return 物品
