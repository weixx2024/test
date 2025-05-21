local GGF = require('GGE.函数')



-- newscene = {}
-- for file in GGF.遍历文件([[E:\xgge2\新地图cell]]) do
--     if file:sub(-3) == 'map' then
--         id = tonumber(GGF.取文件名(file, true))
--         newscene[id] = true
--     end
-- end
-- scene = {}
-- for file in GGF.遍历文件([[D:\大话西游2\scene]]) do
--     if file:sub(-3) == 'map' then
--         id = tonumber(GGF.取文件名(file, true))
--         scene[id] = true
--     end
-- end

-- list2={}
-- for i, v in ipairs(require('data/jump')) do
--     list2[string.format('%d_%d_%d', v.mid, v.x, v.y)] = v
-- end

-- jump = {}
-- for i, v in ipairs(require('jump')) do

--     if scene[v.mid & 0xFFFF] then
--         v.mid = v.mid | 0x10000
--     elseif newscene[v.mid & 0xFFFF] then
--         v.mid = v.mid & 0xFFFF
--     end

--     if scene[v.tid & 0xFFFF] then
--         v.tid = v.tid | 0x10000
--     elseif newscene[v.tid & 0xFFFF] then
--         v.tid = v.tid & 0xFFFF
--     end

--     if v.屏蔽 then
--         v.外形=false
--     end
--     table.insert(jump, v)
-- end

-- list = {}
-- for i, v in ipairs(jump) do
--     list[string.format('%d_%d_%d', v.mid, v.x, v.y)] = v
-- end


-- function getdesc(t)
--     local m = require('map')
--     local a = m[t.mid] and m[t.mid].name or '未知'
--     local b = m[t.tid] and m[t.tid].name or '未知'
--     return a..' -> '..b
-- end

-- for k, v in pairs(list) do
--     if not list2[k] then
--         print(string.format( "{mid=%d,x=%d,y=%d,tid=%d,tx=%d,ty=%d,外形=%s,desc='%s'};",v.mid,v.x,v.y,v.tid,v.tx,v.ty,v.外形,getdesc(v) ))
--     end
-- end

-- for i,v in ipairs(new) do
--     print(string.format(
--         "{名称='%s',外形=%d,类型=%d,成长=%d,初血=%d,初法=%d,初攻=%d,初敏=%d,金=%d,木=%d,水=%d,火=%d,土=%d,格子=%d,抗性=%s,技能=%s};",
--     v.名称,
--     v.外形 ,
--     v.成长,
--     v.类型,
--     v.初血,
--     v.初法,
--     v.初攻,
--     v.初敏,

--     v.金,
--     v.木,
--     v.水,
--     v.火,
--     v.土,
--     v.格子,
--     require('lua/serpent').line(v.抗性),
--     require('lua/serpent').line(v.技能)
-- )
-- )
-- end

-- local list = require('npc')
-- for i, v in ipairs(list) do
--     local mid = v.mid & 0xFFFF
--     if scene[mid] then
--         mid = mid | 0x10000
--     end
--     v.mid = mid
-- end

-- table.sort(
--     list,
--     function(a, b)
--         return a.mid < b.mid
--     end
-- )
-- 地图名 = {}
-- for i, v in ipairs(list) do
--     local mid = v.mid
--     local name = __地图[mid] and __地图[mid].名称  or mid
--     if not 地图名[name] then
--         地图名[name] = true
--         print('-------------------------------------------------'..name..'-------------------------------------------------')
--     end
--     print(string.format("{mid=0x%08x--[[%04d]],分类='%s',外形=%04d,方向=%d,名称='%s',称谓='%s',x=%d,y=%d,脚本='%s'};", mid, mid & 0xFFFF, v.分类 or '其它', v.外形, v.f, v.名称, v.称谓, v.x, v.y, v.脚本))
-- end