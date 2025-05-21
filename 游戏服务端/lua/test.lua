-- 运行方法
-- ctrl + p
-- 选ggerun 是本地运行，
-- 选ggebuild 是打包

-- 召唤转生 = 3
-- 召唤等级 = 160
-- 内丹转生 = 3
-- 内丹等级 = 160
-- 召唤亲密 = 300000
-- 召唤最大魔法 = 50000

-- 挨打方最大魔法 = 100000

-- function 内丹系数调整(zhs_zscs, nd_zscs)
--     if (zhs_zscs * nd_zscs == 1) then
--         return 1.04;
--     elseif (zhs_zscs * nd_zscs == 4) then
--         return 1.071;
--     elseif (zhs_zscs * nd_zscs == 6) then
--         return 1.073;
--     elseif (zhs_zscs * nd_zscs == 9) then
--         return 1.09;
--     else
--         return 1;
--     end
-- end

-- function 取内丹()
--     local ndjl =
--         math.floor(
--             (math.pow(召唤等级 * 内丹等级 * 0.04, 1 / 2) * (1 + 0.25 * 内丹转生) +
--                 (math.pow(召唤亲密, 1 / 6) * 内丹系数调整(召唤转生, 内丹转生) * 内丹等级) / 50) *
--             1000
--         ) * 0.000005;

--     local ndcd =
--         math.floor(((召唤等级 * 召唤等级 * 0.2) / (召唤最大魔法 * 1 + 1) + ndjl) * 10000) /
--         10000;
--     ndjl = math.ceil(ndjl * 10000) / 100
--     ndcd = math.ceil(ndcd * 10000) / 100
--     return ndjl, ndcd
-- end

-- local ndjl, ndcd = 取内丹()
-- 伤害 = math.floor(挨打方最大魔法 * ndcd * 0.01)

-- print('测试浩然伤害', 伤害)


mid = require('map')


-- 就这代码生成的 放进去 .map文件 运行后 自动生成 cell文件  就这几个新地图 你直接搞好  你自己复制map进去 就这几个新的

-- for file in GGF.遍历文件([[E:\xgge2\新地图cell]]) do
--     if file:sub(-3) == 'map' then
--         local map, info = require('gxy2.map')(file)
--         id = tonumber(GGF.取文件名(file, true))
--         cell = map:GetCell()
--         cell = string.pack('<I4I4', info.colnum*16, info.rownum*12) .. cell
--         GGF.写出文件(string.format('E:/xgge2/新地图cell/%04d.cell', id+1000), cell)
--     end
-- end