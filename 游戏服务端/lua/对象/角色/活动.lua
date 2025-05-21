local 角色 = require('角色')

local function _get(s, name)
    local 脚本 = __脚本[s]
    if type(脚本) == 'table' then
        return 脚本[name]
    end
    return nil --value expected ?空参数
end

function 角色:水陆报名()
    if not __水陆大会:是否可报名() then
        return "现在不是报名时间"
    end
    local t = {}
    for _, v in self.接口:遍历队伍() do
        if __水陆大会:是否已报名(v.nid) then
            table.insert(t, v.名称)
        end
        if v.是否机器人 then
            return "不可携带伙伴参加水陆大会"
        end
    end
    if #t > 0 then
        self.rpc:常规提示('#Y' .. table.concat(t, '、 ') .. '#W已经报过名了')
        return
    end

    for _, v in self.接口:遍历队伍() do
        if v.转生 < 1 then --or not v:剧情称谓是否存在(8)
            table.insert(t, v.名称)
        end
    end
    if #t > 0 then
        self.rpc:常规提示('#Y' .. table.concat(t, '、 ') .. '#W低于1转,无法报名')
        return
    end
    if self.接口:取队伍人数() ~= 5 then
        return "请组齐5人报名成功"
    end
    __水陆大会:玩家报名(self.接口)
    return "报名成功"
end