local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '以退为进',
    id = 304,

}

function 法术:计算_召唤(P)
    P.抗性.抗鬼火 = P.抗性.抗鬼火 - 15
    P.抗性.抗风 = P.抗性.抗风 - 15
    P.抗性.抗火 = P.抗性.抗火 - 15
    P.抗性.抗水 = P.抗性.抗水 - 15
    P.抗性.抗雷 = P.抗性.抗雷 - 15
    P.抗性.反震率 = P.抗性.反震率 + 15
    P.抗性.反震程度 = P.抗性.反震程度 + 15
end

function 法术:法术取描述(P)
    return "以退为进，掩人耳目。#r#W【技能介绍】#r#G降低自身仙法鬼火抗性，提高15%反震率与反震程度。"
end

return 法术
