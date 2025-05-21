local 任务开关 = 界面层:创建按钮('任务开关', 0, 125)
function 任务开关:初始化()
    self:设置按钮精灵('gires4/jdmh/yjan/yjan.tcp')
end

function 任务开关:左键弹起()
    界面层.任务栏:置可见(true)
end

local 任务栏 = 界面层:创建控件('任务栏', 0, 125, 165, 197)
function 任务栏:初始化()
    self:置精灵(__res:getspr('gires4/jdmh/qt/rwzz.tcp'):置中心(0, 0))
    self.文字 = __res.HYF:置颜色(187, 165, 75):取精灵('任务追踪')
end

function 任务栏:显示(x, y)
    self.文字:显示(x + 45, y + 4)
end

local 任务列表 = 任务栏:创建列表('任务列表', 0, 30, 160, 155)
function 任务列表:初始化()
    self.选中精灵 = nil
    self.焦点精灵 = nil
    self.行间距 = 4
end

function 任务列表:回调获得鼠标(x, y, v, b)
    local t = GGF.分割文本(v, "|")
    if t[1] and t[2] and t[3] then
        if mapid ~= t[1] or mapx ~= t[2] or mapy ~= t[3] then
            mapid = t[1]
            mapx = t[2]
            mapy = t[3]
            local r = require('数据/地图库')[t[1] + 0]
            if r then
                mapname = r.name
            end
        end
        self:置提示("#Y" .. mapname .. "(" .. mapx .. "," .. mapy .. ")")
    end
end

function 任务列表:文本回调左键弹起(v)
    local t = GGF.分割文本(v, "|")
    界面层.任务栏.目标 = v
    if t[1] and t[2] and t[3] then
        if self.名称 == "抓鬼任务" then
            __自动任务:设置任务({ 类型 = "日常_抓鬼任务", id = t[1] + 0, x = t[2] + 0, y = t[3] + 0 })
        elseif self.名称 == "天庭任务" then
            __自动任务:设置任务({ 类型 = "日常_天庭任务", id = t[1] + 0, x = t[2] + 0, y = t[3] + 0 })
        elseif self.名称 == "鬼王任务" then
            __自动任务:设置任务({ 类型 = "日常_鬼王任务", id = t[1] + 0, x = t[2] + 0, y = t[3] + 0 })
        elseif self.名称 == "修罗任务" then
            __rpc:角色_自动任务_天庭自动(t[2] + 0, t[3] + 0)
            __自动任务:设置任务({ 类型 = "日常_修罗任务", id = t[1] + 0, x = t[2] + 0, y = t[3] + 0 })
        elseif tonumber(t[1]) == __map.id then -- 同地图
            任务列表.模糊路线 = nil
            local _xy = require('GGE.坐标')(t[2] * 20, __map.高度 - t[3] * 20)
            if #__map:寻路(__rol.xy, _xy) > 0 then
                __rol:路径移动(__map)
            end
        else -- 跨地图
            local 路径 = 查找路线(__map.id, tonumber(t[1]))
            if 路径 and #路径 > 0 then
                _G.__自动寻路 = true
                任务列表.模糊路线 = 路径
                local 目标路线x = 任务列表.模糊路线[1].x * 20
                local 目标路线y = __map.高度 - 任务列表.模糊路线[1].y * 20
                local _xy = require('GGE.坐标')(目标路线x, 目标路线y)
                if #__map:寻路(__rol.xy, _xy) > 0 then
                    __rol:路径移动(__map)
                end

                界面层.任务栏._定时_NPC跳转 = 引擎:定时(
                    2500,
                    function(ms)
                        if 任务列表.模糊路线 and __rol and (取两点距离(__rol.xy.x // 20, (__map.高度 - __rol.xy.y) // 20, 任务列表.模糊路线[1].x, 任务列表.模糊路线[1].y) < 3) then
                            __rpc:角色_NPC跳转(任务列表.模糊路线[1])
                            if 界面层.任务栏._定时_NPC跳转 then
                                界面层.任务栏._定时_NPC跳转:删除()
                                界面层.任务栏._定时_NPC跳转 = nil
                            end
                            return 0
                        end
                        return 2500
                    end
                )
            end
        end
    end
end

function 任务列表:任务添加(t, 名称)
    local r = self:添加(t):置精灵()
    local 文本 = r:创建我的文本('任务文本', 5, 5, 150, 500)
    文本.名称 = 名称
    文本.回调获得鼠标 = 任务列表.回调获得鼠标
    文本.回调左键弹起 = 任务列表.文本回调左键弹起
    local w, h = 文本:置文本(t)
    文本:置高度(h + 5)
    r:置高度(h + 5)
    r:置可见(true, true)
end

local 任务开关 = 任务栏:创建按钮('任务开关', -19, 2)
function 任务开关:初始化()
    self:设置按钮精灵('gires4/jdmh/yjan/zjan.tcp')
end

function 任务开关:左键弹起()
    任务栏:置可见(false)
end

function 界面层:置任务追踪(t)
    任务列表:清空()
    if t and #t ~= 0 then
        for i, v in ipairs(t) do
            任务列表:任务添加(tostring(v.名称 .. '#r' .. v.详情), v.名称)
        end
    end
end

function RPC:刷新任务追踪()
    local r = __rpc:角色_获取任务追踪列表()
    if type(r) == 'table' then
        时间排序2(r)
        界面层:置任务追踪(r)
    end
end

return 任务栏
