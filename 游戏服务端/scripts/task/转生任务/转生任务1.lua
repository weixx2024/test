local 任务 = {
    名称 = '转生任务1',
    别名 = '转生重来',
    类型 = '转生任务',
    是否可取消 = false,
}

function 任务:任务初始化()
    if not self.进度 then
        self.进度 = 1
    end
end

local _描述 = {
    "#W你感到周身圆满，修为再难寸进，隐约有一丝阴霾缠绕心头，去找#G孟婆#W谈谈吧",
    "#G悟道通玄#r#W只有达到悟道通玄的境界，灵魂渡过忘川后才能与肉体紧密结合，否则是会影响来世修为的，在转世前先将#G法术熟练度#W修满，完成未完成的任务",
    "#W忘川水苦涩难咽，孟婆嘱咐你去寻来#G冥钞#W，#G千年血参#W，#G二十一味清目丸#W，用以熬制孟婆汤。#r1.	#R击败地狱三层的#Y金银铜铁鬼#W可获得一张冥钞，或给他200万银两可获得一张#G冥钞#W。#r2.#G千年血参#W，#G二十一味清目丸#R在洛阳集市的药店有售。",


}


function 任务:任务取详情()
    return _描述[self.进度]
end

local _台词 = {
    "孩子，你来了。世间生灵皆有#G清浊#W，自三 族降生后，原本纯净的#G清元#W和#G浊元#W会逐渐产生杂质，这种杂质便是业，也就是缠绕你心头的那一丝阴霾。若缠绕的业太多，生灵便会死亡，失去修为和记忆转世重生。但若你历劫成功，便可使#G清元#W与#G浊元#W的丹体不破，保留前生修为和记忆。待你经历诸般劫难后，再来找我吧。",
    [[
人生一世，草木一春。孩子，你可以选择重新来过。要投胎转世么?
#R注意:转生完毕请立即重新进入游戏。
menu
1|好的，我做好准备了
99|不，我还有心愿未了
]],
    "好孩子，忘川水苦涩难咽，你去找来#G冥钞#W，#G千年血参#W，#G二十一味清目丸#W，婆婆给你做碗好喝的汤。"

}

function 任务:任务NPC对话(玩家, NPC)
    if NPC.名称 == "孟婆" then
        if self.进度 == 1 then
            NPC.台词 = _台词[1]
            self.进度 = 2
            self.别名 = "了却前尘"
        elseif self.进度 == 2 then
            r = 玩家:转生条件检测()
            if r then
                NPC.台词 = r
                return
            end
            NPC.台词 = _台词[2]
        elseif self.进度 == 3 then
            NPC.台词 = _台词[2]
        end
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
    if NPC.名称 == "孟婆" then
        if self.进度 == 2 then
            if i == "1" then
                self.进度 = 3
                NPC.台词 = _台词[3]
            end
        elseif self.进度 == 3 then
            if i == "1" then
                local r = 玩家:转生条件检测()
                if r then
                    NPC.台词 = r
                    return
                end
                local d, e, f =
                    玩家:取物品是否存在("冥钞"),
                    玩家:取物品是否存在("千年血参"),
                    玩家:取物品是否存在("二十一味清目丸")
                if d and e and f then
                else
                    NPC.台词 = "我要的东西呢？"
                    return
                end

                local 种族, 性别, 外形 = 玩家:转生窗口()
                if 种族 then
                    r = 玩家:转生条件检测(性别)
                    if r then
                        return r
                    end
                    local a, b, c =
                    玩家:取物品是否存在("冥钞"),
                    玩家:取物品是否存在("千年血参"),
                    玩家:取物品是否存在("二十一味清目丸")
                    if a and b and c then
                        a:减少(1)
                        b:减少(1)
                        c:减少(1)
                        玩家:转生处理(种族, 性别, 外形)
                        玩家:最后对话("转生成功")
                        self:删除()
                    end
                end
            end
        end
    end
end

return 任务
