
local _背景音乐, _战斗音乐
_战斗文件 = { 1016, 1017, 1018, 1019, 1020, 1021, 1022, 1023, 1024, 1025, 1026, 1027 }
local _战斗缓存 = {}

local random = math.random

local 声音 = class('资源声音')

function 声音:初始化声音()
    self.音乐音量 = self.配置.音乐音量 or 0
    self.音效音量 = self.配置.音效音量 or 0
end

function 声音:登录音乐()
    self:地图音乐('if')
end

function 声音:地图音乐(id)
    if self.背景id == id then
        return
    end
    if _背景音乐 then
        _背景音乐:停止()
    end
    if not id then
        return
    end
    _背景音乐 = self:getmusic('music/%s.mp3', id)
    self.背景id = id
    if _背景音乐 then
        _背景音乐:播放(true)
        if self.音乐音量 == 0 or self.是否暂停 then
            _背景音乐:暂停()
        end
        _背景音乐:置音量(self.音乐音量)
    end
end

function 声音:进入战斗()
    if _背景音乐 then
        _背景音乐:暂停()
    end
    if _战斗音乐 then
        _战斗音乐:停止()
    end
    _战斗音乐 = self:getmusic('music/%d.mp3', _战斗文件[random(#_战斗文件)])
    if _战斗音乐 then
        _战斗音乐:播放(true)
        if self.音乐音量 == 0 or self.是否暂停 then
            _战斗音乐:暂停()
        end
        _战斗音乐:置音量(self.音乐音量)
    end
end

function 声音:退出战斗()
    if _战斗音乐 then
        _战斗音乐:停止()
        _战斗音乐 = nil
    end
    if self.音乐音量 > 0 then
        if _背景音乐 and not self.是否暂停 then
            _背景音乐:恢复()
        end
    end
end

function 声音:动作音效(id, act)
    if self.是否暂停 then
        return
    end
    local snd = self:getsound('sound/char/%04d/%s.wav', id, act)
    if snd then
        snd:停止()
        snd:播放():置音量(self.音效音量)
    end
    return snd
end

function 声音:动画音效(name) --addon,waddon
    if self.是否暂停 then
        return
    end
    local snd = self:getsound('sound/addon/%s.wav', name) --addon.fsb

    if snd then
        snd:停止()
        snd:播放():置音量(self.音效音量)
    end
    return snd
end

function 声音:界面音效(file, ...)
    if self.是否暂停 then
        return
    end
    local snd = self:getsound(file, ...)
    if snd then
        snd:停止()
        snd:播放():置音量(self.音效音量)
    end
end

function 声音:技能音效(id, name)
    if self.是否暂停 then
        return
    end
    local snd = self:getsound('sound/effect/%04d.wav', id)
    if not snd and name then --TODO
        --snd = self:getsound("sound/output/magic/%s.fsb|%s.wav",name ,id)
    end
    if snd then
        snd:停止()
        snd:播放():置音量(self.音效音量)
    end
    return snd
end

function 声音:置音乐音量(v)
    if type(v) == 'number' then
        self.配置.音乐音量 = v
    else
        return
    end
    self.音乐音量 = self.配置.音乐音量

    if _战斗音乐 then
        if self.音乐音量 == 0 then
            _战斗音乐:暂停()
        else
            _战斗音乐:恢复()
            _战斗音乐:置音量(self.音乐音量)
        end
    elseif _背景音乐 then
        if self.音乐音量 == 0 then
            _背景音乐:暂停()
        else
            _背景音乐:恢复()
            _背景音乐:置音量(self.音乐音量)
        end
    end
end

function 声音:置音效音量(v)
    if type(v) == 'number' then
        self.配置.音效音量 = v
    else
        return
    end
    self.音效音量 = self.配置.音效音量
end

function 声音:置音量(v)
    self:置音乐音量(v)
    self:置音效音量(v)
end

function 声音:暂停声音()
    self.是否暂停 = true
    if _背景音乐 then
        _背景音乐:暂停()
    end
    if _战斗音乐 then
        _战斗音乐:暂停()
    end
end

function 声音:恢复声音()
    self.是否暂停 = false
    if self.音乐音量 > 0 then
        if _战斗音乐 then
            _战斗音乐:恢复()
        elseif _背景音乐 then
            _背景音乐:恢复()
        end
    end
end

return 声音
