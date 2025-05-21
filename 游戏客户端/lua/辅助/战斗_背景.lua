

-- local 战斗背景 = class('战斗背景')

-- function 战斗背景:初始化()
--     local map = assert(__res:getmap(__map.背景), '地图不存在')
--     map:不缓存()
--     self.list = {}
--     local i = 0
--     local px, py = (引擎.宽度 - map.width) // 2, (引擎.高度 - map.height) // 2
--     for h = 1, map.rownum do
--         for l = 1, map.colnum do
--             table.insert(self.list, map:取精灵2(i):置坐标((l - 1) * 320 + px, (h - 1) * 240 + py))
--             i = i + 1
--         end
--     end
-- end

-- function 战斗背景:显示(x, y)
--     for i, v in ipairs(self.list) do
--         v:显示()
--     end
-- end

-- return 战斗背景

return function()
    local map = assert(__res:getmap(__map.背景), '地图不存在'..(__map.背景 or "无"))
    map:不缓存()
    local list = {}
    local i = 0

    for h = 1, map.rownum do
        for l = 1, map.colnum do
            table.insert(list, map:取精灵2(i):置坐标((l - 1) * 320, (h - 1) * 240))
            i = i + 1
        end
    end

    local tex = require('SDL.纹理')(800, 600)
    if tex:渲染开始() then
        for _, v in ipairs(list) do
            v:显示()
        end
        tex:渲染结束()
    end
    local spr = tex:到精灵()

   -- if map.width > 引擎.宽度 then
        --local px, py = (引擎.宽度 - map.width) // 2, (引擎.高度 - map.height) // 2
  --  else
        spr:置拉伸(引擎.宽度, 引擎.高度, true)
   -- end
    return spr
end
