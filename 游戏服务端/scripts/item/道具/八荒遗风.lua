local 物品 = {
    名称 = '八荒遗风',
    类别 = 3,
    类型 = 0,
    对象 = 0,
    条件 = 0,
    绑定 = false,
}
function 物品:初始化()

end
function 物品:添加灵气(js,hb)
    if not self.灵气 then
        self.灵气 = 0
        self.阶数 = js
        self.编号=hb
    end
    self.灵气=self.灵气+1
end

function 物品:取描述()
    if self.灵气 and self.灵气>0 then
        return string.format("#Y%s点灵气,%s阶,编号 %s", self.灵气, self.阶数, self.编号)
    end
end

return 物品
