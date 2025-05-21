
local SDL精灵 = require('SDL.精灵')
local 摊名精灵 = class('摊名精灵', SDL精灵)

function 摊名精灵:初始化(摊名, 收购, 高度)
    self.收购 = 收购
    self.摊名高度 = 高度
    self.摊名 = 摊名 --摊名__res.F14:置颜色(187, 165, 75, 255):取图像(摊名)
    self.zt= __res.F14:置颜色(187, 165, 75, 255):取图像(摊名)
   -- self.摊名:置颜色(187, 165, 75)
    local sf
    if self.收购 then
        sf = 取按钮图像('gires2/main/storeframe_buy.tcp', 1,self.zt)
    else
        sf = 取按钮图像('gires2/main/storeframe.tcp', 1, self.zt)
    end
    self:SDL精灵(sf)
    self:置中心(sf.宽度 // 2, self.摊名高度 + 25)
end

function 摊名精灵:置灰色()
    self.zt=__res.F14:置颜色(211, 146, 112, 255):取图像(self.摊名)--:置颜色(211, 146, 112,255 )
    local sf
    if self.收购 then
        sf = 取按钮图像('gires2/main/storeframe_buy.tcp', 1, self.zt)
    else
        sf = 取按钮图像('gires2/main/storeframe.tcp', 1, self.zt)
    end
    self:SDL精灵(sf)
    self:置中心(sf.宽度 // 2, self.摊名高度 + 25)
end

return 摊名精灵
