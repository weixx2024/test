local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '闪现',
    id = 304,

}

function 法术:计算_召唤(P)
    --内丹是否存红颜白发
   
    
end

function 法术:法术取描述(P)
    return '#W灵光一闪，不请自来。#r#W【消耗MP】0#r#G有30%几率无需召唤自动加入战斗'
end

return 法术
