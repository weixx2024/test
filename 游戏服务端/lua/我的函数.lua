-- table.print = function(t)
--     -- local info = debug.getinfo(2)
--     -- _print(string.format("%s:%d", string.gsub(info.source, "[%@]", ""), info.linedefined))
--     _print(require('lua.serpent').block(t))
-- end

local _不复制 = {
    地图 = true
}

function __复制表(t)
    local r = {}
    if type(t) == 'table' then
        for k, v in pairs(t) do
            if _不复制[k] then
                goto continue
            end
            local tp = type(v)
            if tp == 'table' then
                r[k] = __复制表(v)
            elseif tp == 'string' or tp == 'number' or tp == 'boolean' then
                r[k] = v
            end
            ::continue::
        end
    end
    return r
end

GGF.复制表 = __复制表

table.print = function(t)
    print(require('lua.serpent').block(t))
end

function __容错表(t)
    if type(t) ~= 'table' then
        t = {}
    end
    return setmetatable(
        t,
        {
            __index = function(t, k)
                return 0
            end
        }
    )
end

function __生成ID()
    return require('nanoid').generate()
end

function __取召唤技能数值(转生, 等级, 亲密, 系数, 基础值, 最大值)
    local 结果 = 0;
    if (转生 == 0) then
        转生 = 0.5;
    end

    local 等级调整系数 = 1 + (等级 / 160) * 0.15;
    while (math.floor(亲密 / 16) > 0) do
        亲密 = 亲密 / 16;
        系数 = 系数 * 1.8;
    end

    系数 = 基础值 + 系数 * (1 + 转生 * 0.1 + 亲密 / 16.0) * 等级调整系数;

    结果 = 系数 - 系数 % 0.01

    if (结果 > 最大值) then
        return 最大值;
    end

    return 结果;
end

function 验证数字(n)
    if type(n) ~= "number" or math.abs(n) ~= n or math.floor(n) ~= n or n < 0 or n > 9999 then
        return false
    end
    return true
end

function SkillXS(v, xs)
    if v <= 0 then
        return 0
    end
    while v / 16 > 0 do
        v = math.floor(v / 16)
        xs = xs * 1.86
    end
    xs = xs * (1 + 0.86 * (v / 16.0))
    -- 使用Lua的标准库进行舍入
    local mult = 100  -- 舍入到小数点后两位
    xs = math.floor(xs * mult + 0.5) / mult
    return xs
end
