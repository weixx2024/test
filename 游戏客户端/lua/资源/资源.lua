local SDL = require 'SDL'
local SDF = require('SDL.函数')
local GGF = require('GGE.函数')

local res_tcp = require('资源/格式/tcp')
local res_map = require('资源/格式/map')
local res_snd = require('资源/格式/snd')
local res_wdf = require('资源/格式/wdf')

local 资源基类 = require 'GGE.资源'
local 资源声音 = require '资源/声音'
local 资源配置 = require '资源/配置'
local _内部路径
local 资源 = class('资源', 资源配置, 资源声音, 资源基类)

function 资源:初始化()
    self.xxz = 0

    self.cache = {}
    self.font = {}
    self.mcache = setmetatable({}, { __mode = 'v' })
    self.index = require('资源/index') -- 动画处理[有些动画重复使用]

    self:读取配置()
    if gge.platform == 'iOS' then
        self:添加路径('assets/assets')
    else
        self:添加路径('assets')
    end
    if gge.platform == 'Windows' then
        --self:读取配置()
        self:添加路径('data')
        if gge.isdebug then
            self:添加加载器(res_wdf('E:/大话西游2经典版'))
            self:添加路径('E:/大话西游2经典版')
        end
    else
        self:添加路径(SDF.取内部存储路径(), 1) -- 优先插入到搜索列表第1位置
        --self:添加路径(SDF.取外部存储路径(),2)
    end

    self.th = require("SDL.线程")('资源/线程')
    self.FAC = self:getfont('simsun.ttc', 12, true, 0):置对齐(SDL.TTF_WRAPPED_ALIGN_CENTER)
    self.F12 = self:getfont('simsun.ttc', 12, true, 0)
    self.F12B = self:getfont('simsun.ttc', 12, true, 0):置样式(SDL.TTF_STYLE_BOLD)
    self.F13 = self:getfont('simsun.ttc', 13, true, 0)
    self.F14 = self:getfont('simsun.ttc', 14)
    self.F14B = self:getfont('simsun.ttc', 14):置样式(SDL.TTF_STYLE_BOLD)
    self.F15 = self:getfont('simsun.ttc', 15, true, 0)
    self.F15B = self:getfont('simsun.ttc', 14):置颜色(187, 165, 75):置样式(SDL.TTF_STYLE_BOLD)
    self.F16 = self:getfont('simsun.ttc', 16)
    self.MCZ = self:getfont('simsun.ttc', 16):置样式(SDL.TTF_STYLE_BOLD)
    self.F16B = self:getfont('simsun.ttc', 16):置样式(SDL.TTF_STYLE_BOLD)
    self.F18 = self:getfont('simsun.ttc', 18, true, 0)
    self.F18B = self:getfont('simsun.ttc', 18, true, 0):置样式(SDL.TTF_STYLE_BOLD)
    self.HYI = self:getfont('hyi1gjm.ttf'):置大小(16)
    self.HYF = self:getfont('HYF2GJM.ttf'):置大小(18):置样式(SDL.TTF_STYLE_BOLD)
    self.HHZ = self:getfont('hyi1gjm.ttf'):置大小(24) -- 回合字
    self.HHZ2 = self:getfont('simsun.ttc', 22)
    self.HYF16 = self:getfont('HYF2GJM.ttf'):置大小(16)
    self.HYF16B = self:getfont('HYF2GJM.ttf', 16, true, 0):置样式(SDL.TTF_STYLE_BOLD)
    self.JMZ = self:getfont('HYF2GJM.ttf', 16, true, 0):置颜色(187, 165, 75):置样式(SDL.TTF_STYLE_BOLD) --界面字
    self.J18 = self:getfont('HYF2GJM.ttf', 18, true, 0):置颜色(187, 165, 75):置样式(SDL.TTF_STYLE_BOLD)
    self.HY24B = self:getfont('HYF2GJM.ttf', 24, true, 0):置样式(SDL.TTF_STYLE_BOLD)
    self.HYC = self:getfont('HYC1GJM.ttf'):置大小(16):置样式(SDL.TTF_STYLE_BOLD)
    self.汉仪小隶书简16号粗 = self:getfont('HYF2GJM.ttf', 16, true, 0):置样式(SDL.TTF_STYLE_BOLD):置抗锯齿(true)
    self.汉仪小隶书简18号 = self:getfont('HYF2GJM.ttf', 18, true, 0):置抗锯齿(true)
    self.汉仪小隶书简20号 = self:getfont('HYF2GJM.ttf', 20, true, 0):置抗锯齿(true)
    self:初始化声音()
    引擎:置图标(self:getsf('xy.png'))

    引擎:注册事件(self, self) --更新事件
end

function 资源:更新事件()
    local time = os.time()
    for k, v in pairs(self.cache) do
        if type(v) and v.检查时间 and v:检查时间(time) then --超时就转成弱缓存
            self.mcache[k] = self.cache[k]
            self.cache[k] = nil
        end
    end
end

function 资源:置gui(gui)
    GUI = gui
end

function 资源:check(path, ...) --files
    if select('#', ...) > 0 then
        path = path:format(...)
    end
    if self.index[path] then
        path = self.index[path]
    end

    if gge.platform ~= 'Windows' then --安卓assets不能中文
        if path:sub(-3) == 'map' then
            path = string.format('%s', path)
        else
            path = string.format('%08X', gge.hash(path))
        end
    end
    local np,npath = self:是否存在(path)
    if npath and np == false then
        error(npath)
    end
    if gge.isdebug then
        -- do zdz模型展示不读取，需要读取请去test手动读取，为了限制包大小
        if string.find(path, 'shape') then
            goto jump
        end
        if ggetype(np) == 'wdf' then
            if not GGF.判断文件('data/' .. path) then
                GGF.写出文件('data/' .. path, np:取数据(path))
                print('写出', path, np)
            end
        elseif ggetype(np) == 'string' then
            if np:sub(-3) == 'map' and not GGF.判断文件('data/' .. path) then
                GGF.复制文件(np, 'data/' .. path)
            elseif np:sub(1, 4) ~= 'data' then
                --print(path, np)
            end
        else
            --print(path, np)
        end
    end

    ::jump::
    if np then
        return path, np
    end
end

function 资源:get(path, ...)
    if select('#', ...) > 0 then
        path = path:format(...)
    end

    if self.cache[path] then --5分钟缓存
        if self.cache[path].更新时间 then
            self.cache[path]:更新时间()
        end
        return self.cache[path]
    elseif self.mcache[path] then --弱缓存
        self.cache[path] = self.mcache[path]
        if self.cache[path].更新时间 then
            self.cache[path]:更新时间()
        end
        return self.cache[path]
    end

    local f = self:check(path)

    local data

    if f then
        data = self:取数据(f)
    end


    if data then
        -- if __rol  then
        --     引擎:错误事件(f.." path "..path)
        -- end
        local ext = path:sub(-3)
        if ext == 'tcp' or ext == 'tca' then
            self.cache[path] = res_tcp(data)
            return self.cache[path]
        elseif ext == '.pp' then --染色
            self.cache[path] = self:depp(data)
            return self.cache[path]
        elseif ext == 'wav' or ext == 'mp3' then
            self.cache[path] = res_snd(require('SDL.读写')(data, #data))
            return self.cache[path]
        end
    end
    return data
end

-- function 资源:getmap(id)--线程
--     if id > 100000 then
--         id = id % 10000
--         local _, path = self:check('newscene/%d.map', id)
--         if self.th then --线程
--             coroutine.xpcall(function()
--                 self.th:打开地图(path)
--             end)
--         end
--         return res_map(path)
--     end

--     if id > 10000 then --重复地图（两杂货店）
--         id = id % 10000
--     end
--     local _, path = self:check('scene/%d.map', id)
--     if self.th then --线程
--         coroutine.xpcall(function()
--             self.th:打开地图(path)
--         end)
--     end
--     return res_map(path)
-- end

function 资源:getmap(id) --第一版 111111
    local r = require('数据/地图库')[id]
    if id > 100000 then
        id = id % 10000
        local _, path = self:check('newscene/%d.map', id)
        return path and res_map(path)
    end
    if id > 10000 then --重复地图（两杂货店）
        id = id % 10000
    end
    local path1, path = self:check('scene/%d.map', id)
    return path and res_map(path)
end

function 资源:getspr(...)
    local r = self:get(...)
    if ggetype(r) == 'tcp' then
        return r:取精灵(1)
    elseif ggetype(r) == 'string' then
        return require('SDL.读写')(r, #r):取精灵() --require('SDL.精灵')(require('SDL.读写')(r, #r):取精灵())
    end
    --print("getspr",...)
end

function 资源:gettex(...)
    local r = self:get(...)
    if ggetype(r) == 'tcp' then
        return r:取纹理(1)
    elseif ggetype(r) == 'string' then
        return require('SDL.读写')(r, #r):取纹理()
    end
    --print("gettex",...)
end

function 资源:getsf(...)
    local r = self:get(...)
    if ggetype(r) == 'tcp' then
        return r:取图像(1)
    elseif ggetype(r) == 'string' then
        return require('SDL.读写')(r, #r):取图像()
    end
    --print("getsf",...)
end

function 资源:getani(...)
    local r = self:get(...)
    if ggetype(r) == 'tcp' then
        return r:取动画(1)
    end
end

function 资源:getmusic(...)
    return self:get(...)
end

function 资源:getsound(...)
    return self:get(...)
end

function 资源:getfont(name, ...)
    local _, path = self:check('font/%s', name)
    return require('SDL.文字')(path, ...)
end

return 资源
