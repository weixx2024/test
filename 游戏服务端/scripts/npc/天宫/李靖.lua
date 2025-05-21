local NPC = {}
local 对话 = [[
经天庭将士用命，终将御马监四大妖王镇压。奈何四大妖王非同一般，仍有无数分身逃逸。是故吾立捉妖榜，发布天庭任务。三界侠士皆可揭榜捉妖，以维护三界和平，兼可获得天庭嘉奖。少侠是否要揭榜捉妖?
menu
1|为民除害，义不容辞！
4|我只是路过看看
]]
local 对话2 = [[
经天庭将士用命，终将御马监四大妖王镇压。奈何四大妖王非同一般，仍有无数分身逃逸。是故吾立捉妖榜，发布天庭任务。界侠士皆可揭榜捉妖，以维护三界和平，兼可获得天庭嘉奖。少侠是否要揭榜捉妖?
menu
1|为民除害，义不容辞！
20|我要领取法宝
4|我只是路过看看
]]

function NPC:NPC对话(玩家)
    if not 玩家:取法宝是否存在("七宝玲珑塔") and 玩家.转生 > 0 then
        return 对话2
    end
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        return self:领取天庭任务(玩家)
    elseif i == '20' then
        if 玩家.转生 < 1 then
            return "1转后再来找我领取哦"
        end
        local r = 玩家:取任务("法宝领取")
        if r then
            return "你身上还有未完成的法宝任务哦"
        end
        local rw = 生成任务 { 名称 = '法宝领取', 法宝 = '七宝玲珑塔' }
        return rw:添加任务(玩家)
    end
end

function NPC:领取天庭任务(玩家)
    local r = 生成任务 { 名称 = '日常_天庭任务' }
    if r and r:添加任务(玩家) then
        local ff = '快去御马监降服妖魔吧'
        for _, v in 玩家:遍历队伍() do
            v:最后对话(ff, self.外形)
        end
        return ff
    end
end

return NPC
