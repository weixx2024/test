local NPC = {}
local 对话 = [[
万众归心，天下大统。唯我大唐盛世！
menu
1|合成狮蝎-天书残卷1、2、4、5
2|合成罗刹鬼姬-天书残卷1、2、4、6
3|合成雷兽-天书残卷2、3、4、5
4|合成哥俩好-天书残卷2、3、4、6
5|合成剑精灵-天书残卷3、4、5、6    
6|合成精卫-天书残卷4、5、6、6、7、8
7|合成冥灵妃子-天书残卷3、5、6、6、8、9
8|合成迦楼罗王-天书残卷3、4、6、6、7、9
9|合成当康-天书残卷1、3、4、7、7、10
10|合成苍凛-天书残卷1、1、6、7、8、10
11|合成赭炎-天书残卷1、2、7、8、9、10
12|合成如意娃娃-天书残卷2、5、7、8、8、9
13|合成松鼠-天书残卷7、7、7、8、8、8
14|合成佳音小使-天书残卷2、3、6、7、8、8
15|合成粽小仙-天书残卷4、5、6、7、9、10
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

--   第一 二 四 六卷可拼《寒冰封印之书》-罗刹鬼姬
-- 　第二 三 四 六卷可拼《狂力封印之书》-哥俩好
-- 　第三 四 五 六卷可拼《御剑封印之书》-剑精灵
-- 　第二 三 四 五卷可拼《天雷封印之书》-雷兽
-- 　第一 二 四 五卷可拼《剧毒封印之书》-狮蝎
-- 　第四 五 六 六 七 八卷拼《玲珑古卷》-精卫        
-- 　第三 五 六 六 八 九卷拼《冥灵古卷》-冥灵妃子     
-- 　第三 四 六 六 七 九卷拼《巨翼古卷》-迦楼罗王   
-- 　第一 三 四 七 七 十卷拼《当康古卷》-当康    
-- 　第一 一 六 七 八 十卷拼《苍凛古卷》-苍凛   
-- 　第一 二 七 八 九 十卷拼《赭炎古卷》-赭炎   
-- 　第一 三 四 六 九 十卷拼《葫芦古卷》-葫芦娃娃     暂无
-- 　第二 五 七 八 八 九卷拼《如意古卷》-如意娃娃  
-- 　第七 七 七 八 八 八卷拼《松鼠古卷》-松鼠  
-- 　第二 三 六 七 九 九卷拼《佳音古卷》-佳音小使   
-- 　第四 五 六 七 九 十卷拼《粽仙古卷》-粽小仙

local _材料 = {
    { 物品 = '剧毒封印之书', 需求 = { "天书残卷第一卷", "天书残卷第二卷", "天书残卷第四卷","天书残卷第五卷" } },
    { 物品 = '寒冰封印之书', 需求 = { "天书残卷第一卷", "天书残卷第二卷", "天书残卷第四卷","天书残卷第六卷" } },
    { 物品 = '天雷封印之书', 需求 = { "天书残卷第二卷", "天书残卷第三卷", "天书残卷第四卷","天书残卷第五卷" } },
    { 物品 = '狂力封印之书', 需求 = { "天书残卷第二卷", "天书残卷第三卷", "天书残卷第四卷","天书残卷第六卷" } },
    { 物品 = '御剑封印之书', 需求 = {  "天书残卷第三卷", "天书残卷第四卷","天书残卷第五卷","天书残卷第六卷" } },
    { 物品 = '玲珑古卷', 需求 = {  "天书残卷第四卷", "天书残卷第五卷","天书残卷第六卷","天书残卷第六卷","天书残卷第七卷","天书残卷第八卷" } },
    { 物品 = '冥灵古卷', 需求 = {  "天书残卷第三卷", "天书残卷第五卷","天书残卷第六卷","天书残卷第六卷","天书残卷第八卷","天书残卷第九卷" } },
    { 物品 = '巨翼古卷', 需求 = {  "天书残卷第三卷", "天书残卷第四卷","天书残卷第六卷","天书残卷第六卷","天书残卷第七卷","天书残卷第九卷" } },
    { 物品 = '当康古卷', 需求 = {  "天书残卷第一卷", "天书残卷第三卷","天书残卷第四卷","天书残卷第七卷","天书残卷第七卷","天书残卷第十卷" } },
    { 物品 = '苍凛古卷', 需求 = {  "天书残卷第一卷", "天书残卷第一卷","天书残卷第六卷","天书残卷第七卷","天书残卷第八卷","天书残卷第十卷" } },
    { 物品 = '赭炎古卷', 需求 = {  "天书残卷第一卷", "天书残卷第二卷","天书残卷第七卷","天书残卷第八卷","天书残卷第九卷","天书残卷第十卷" } },
    { 物品 = '如意古卷', 需求 = {  "天书残卷第二卷", "天书残卷第五卷","天书残卷第七卷","天书残卷第八卷","天书残卷第八卷","天书残卷第九卷" } },
    { 物品 = '松鼠古卷', 需求 = {  "天书残卷第七卷", "天书残卷第七卷","天书残卷第七卷","天书残卷第八卷","天书残卷第八卷","天书残卷第八卷" } },
    { 物品 = '佳音古卷', 需求 = {  "天书残卷第二卷", "天书残卷第三卷","天书残卷第六卷","天书残卷第七卷","天书残卷第八卷","天书残卷第八卷" } },
    { 物品 = '粽仙古卷', 需求 = {  "天书残卷第四卷", "天书残卷第五卷","天书残卷第六卷","天书残卷第七卷","天书残卷第九卷","天书残卷第十卷" } },


}


function NPC:NPC菜单(玩家, i)
    if i == '1' or i == '2' or i == '3' or i == '4' or i == '5' or i == '6' or i == '7' or i == '8' or i == '9' or i == '10' or i == '11'  or i == '12'  or i == '13'  or i == '14'  or i == '15' then
        local t = _材料[i+0]
        local list = {}
        local 通过 = true
        for k, v in ipairs (t.需求) do
            local r = 玩家:取物品是否存在(v)
            if r then
                table.insert(list, r)
            else
                通过 = false
                break
            end
        end
        if not 通过 then
            return "你还是收集到需要的天书残卷再来找我吧#24"
        end
        if 玩家:添加物品({ 生成物品 { 名称 = t.物品, 数量 = 1 } }) then
            for _, v in ipairs(list) do
                v:减少(1)
            end
        else
            return "你的包裹已经满了#24"
        end
    end
end

return NPC
