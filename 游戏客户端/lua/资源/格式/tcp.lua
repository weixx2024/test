require('资源/base')
local xy_tcp = require('gxy2.tcp')

local tcp = class('tcp', 'base')
-- https://blog.csdn.net/leexuany/article/details/2504913
-- typedef struct
-- {
--     Uint16 flag;        // 精灵文件标志 SP 0x5053
--     Uint16 len;         // 文件头的长度 默认为 12
--     Uint16 group;       // 精灵图片的组数，即方向数
--     Uint16 frame;       // 每组的图片数，即帧数
--     Uint16 width;       // 精灵动画的宽度，单位像素
--     Uint16 height;      // 精灵动画的高度，单位像素
--     short x;        // 精灵动画的关键位X
--     short y;        // 精灵动画的关键位Y
-- }SP_HEAD;
function tcp:初始化(data)
    local ud, info = xy_tcp(data)

    self.ud = ud
    for k, v in pairs(info) do
        
        self[k] = v
    end
    self.wframe = self.frame --武器帧数
    self.cache = {[0] = {}} --缓存纹理
    self.pal = {} --颜色板
    self.cp = 0 --cur pp

    self.p = 0 --调色方案 FF|FF|FF|FF
    self.i = 0 --方向起始帧（相对偏移）
end
-- typedef struct
-- {
--     int x;          // 图片的关键位X
--     int y;          // 图片的关键位Y
--     Uint32 width;   // 图片的宽度，单位像素
--     Uint32 height;  // 图片的高度，单位像素
-- }SP_INFO;
function tcp:取纹理(id)
    self:更新时间()
    id = id + self.i --取动画_帧偏移
    local p = self.p --取动画_调色
    if self.cache[p][id] then
        return self.cache[p][id]
    end
    if self.cp ~= p and self.pal[p] ~= nil then --防止重复SetPal
        self.cp = p
        self.ud:SetPal(self.pal[p]) --设置颜色板
    end
    local sf, info = self.ud:GetFrame(id)
    
    local tex = require('SDL.纹理')(sf)
    self.cache[p][id] = tex
    if info then
        for k, v in pairs(info) do
            tex[k] = v
        end
    else
        tex.x = 0
        tex.y = 0
    end

    return tex
end

function tcp:取精灵(...)
    local tex = self:取纹理(...)
    return require('SDL.精灵')(tex):置中心(tex.x, tex.y)
end

function tcp:取灰度精灵(...)
    return self:取图像(...):到灰度():到精灵()
end

function tcp:取动画(d)
    assert(d <= self.group, 'message')
    local t =
        setmetatable(
        {
            p = 0,
            i = (d - 1) * self.frame,
            帧数 = self.wframe,
            帧率 = 1 / 8,
            宽度 = self.width,
            高度 = self.height
        },
        {__index = self, __newindex = self}
    )
    -- 动画载入器
    return require 'GGE.动画'(t)
end

function tcp:取图像(id, fun)
    local sf, info = self.ud:GetFrame(id)
    sf = require('SDL.图像')(sf)
    sf:置中心(info.x, info.y)
    for k, v in pairs(info) do
        sf[k] = v
    end
    if type(fun) == 'function' then
        sf:渲染开始()
        fun(sf)
        sf:渲染结束()
    elseif ggetype(fun) == 'SDL图像' then
        sf:渲染开始()
        fun:显示(0, 0)
        sf:渲染结束()
    end
    return sf
end

function tcp:调色(pp, p) --资源/配置/pp
    
    if pp and p and not self.pal[p] then
        if not self.pal[0] then
            self.pal[0x00000000] = self.ud:GetPal() --默认颜色
            -- self.pal[0x01010101] = self.pal[0]
            -- self.pal[0x01000000] = self.pal[0]
        end
        local pid = {(p >> 24) & 0xFF, (p >> 16) & 0xFF, (p >> 8) & 0xFF, p & 0xFF} -- 4个位置
        for i, v in ipairs(pp) do
            local n = pid[i] -- 方案值
            if n and v.a and v.b and v[n] and #v[n] == 9 then -- ab范围
                self.ud:SetPP(v.a, v.b, table.unpack(v[n])) -- 设置分段颜色
            end
        end
        self.cache[p] = {}
        self.pal[p] = self.ud:GetPal()
        self.p = p
        self.cp = p
        return true
    else
        self.p = p
    end
end
return tcp
