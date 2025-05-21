local NPC = {}
local 对话 = [[
被神仙捉去以后，第一天他们打我，我没有说，第二天他们还打我，我还是没有说，第三天他们送来个漂亮的仙女mm。我说了，第四天我还想说，可是他们把我给砍了，现在我只好在这里当个可怜的鬼怪。
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
