SVR, REG = require('GOL.RPCServer')()
_角色 = setmetatable({}, { __mode = 'v' })
_连接 = {}

require('通信/登录')
require('通信/界面')
require('通信/直达')

--====================连接验证RPC====================
do
    function SVR:连接事件(id, ip, port) --客户端链接
        _连接[id] = { ip = ip }
        return false
    end

    function SVR:断开事件(id, op, err)
        if _角色[id] then
            coroutine.xpcall(function()
                if err == 0 then
                    if not _角色[id]:下线() then
                        warn('下线失败：', _角色[id].名称)
                    end
                else
                    _角色[id]:掉线()
                end
                _角色[id] = nil
            end)
        end
    end

    function SVR:验证事件(id, ver)
        if ver == __版本 then
            return true
        end
        return false
    end

    function REG:上报BUG(id, xt, v)
        __世界:print(id, xt, v)
    end
end

--====================客户端链接地址====================
local ip = __config.ip
local port = __config.port

if SVR:启动(ip, port) then
    __世界:print('\x1b[32;1m服务监听成功\x1b[0m', ip, port)
else
    __世界:print('\x1b[31;1m服务监听失败\x1b[0m', ip, port)
end

--无需返回
SVR.界面信息_时辰 = SVR.界面信息_时辰
SVR.界面信息_聊天 = SVR.界面信息_聊天
SVR.界面信息_公告 = SVR.界面信息_公告
SVR.界面信息_队伍 = SVR.界面信息_队伍
SVR.界面信息_召唤 = SVR.界面信息_召唤
SVR.界面信息_人物 = SVR.界面信息_人物
SVR.界面信息_BUFF = SVR.界面信息_BUFF
SVR.界面信息_公告 = SVR.界面信息_公告
SVR.界面信息_传音 = SVR.界面信息_传音

SVR.界面消息_队伍 = SVR.界面消息_队伍
SVR.界面消息_好友 = SVR.界面消息_好友

SVR.置人物头像 = SVR.置人物头像
SVR.置人物气血 = SVR.置人物气血
SVR.置人物魔法 = SVR.置人物魔法
SVR.置人物经验 = SVR.置人物经验

SVR.刷新召唤兽内丹 = SVR.刷新召唤兽内丹
SVR.申请帮派窗口 = SVR.申请帮派窗口
SVR.作坊总管窗口 = SVR.作坊总管窗口
SVR.灌输灵气窗口 = SVR.灌输灵气窗口
SVR.仙器升级窗口 = SVR.仙器升级窗口
SVR.仙器炼化窗口 = SVR.仙器炼化窗口
SVR.神兵升级窗口 = SVR.神兵升级窗口
SVR.神兵强化窗口 = SVR.神兵强化窗口
SVR.神兵精炼窗口 = SVR.神兵精炼窗口
SVR.神兵炼化窗口 = SVR.神兵炼化窗口
SVR.装备打造窗口 = SVR.装备打造窗口
SVR.移动开始 = SVR.移动开始
SVR.移动更新 = SVR.移动更新
SVR.移动结束 = SVR.移动结束
SVR.切换方向 = SVR.切换方向
SVR.切换称谓 = SVR.切换称谓
SVR.切换外形 = SVR.切换外形
SVR.添加特效 = SVR.添加特效
SVR.添加喊话 = SVR.添加喊话
SVR.删除状态 = SVR.删除状态
SVR.添加状态 = SVR.添加状态
SVR.置队友 = SVR.置队友

SVR.地图添加 = SVR.地图添加
SVR.地图删除 = SVR.地图删除
SVR.常规提示 = SVR.常规提示
SVR.刷新摆摊记录 = SVR.刷新摆摊记录
SVR.聊天框提示 = SVR.聊天框提示
SVR.提示窗口 = SVR.提示窗口
SVR.最后对话 = SVR.最后对话

SVR.刷新银子 = SVR.刷新银子

SVR.刷新师贡 = SVR.刷新师贡
SVR.刷新仙玉 = SVR.刷新仙玉
SVR.删除BUFF = SVR.删除BUFF
SVR.添加BUFF = SVR.添加BUFF
SVR.顶号提示 = SVR.顶号提示
SVR.打开窗口 = SVR.打开窗口
SVR.踢出游戏 = SVR.踢出游戏
SVR.添加管理日志 = SVR.添加管理日志
SVR.自动任务_数据 = SVR.自动任务_数据
SVR.战场倒时 = SVR.战场倒时
SVR.置怨气 = SVR.置怨气
SVR.设置关倒时 = SVR.设置关倒时
SVR.作坊窗口 = SVR.作坊窗口
SVR.刷新任务追踪 = SVR.刷新任务追踪
SVR.切换地图 = SVR.切换地图
SVR.被动对话 = SVR.被动对话
SVR.被动菜单 = SVR.被动菜单

-----------------------
SVR.进入战斗 = SVR.进入战斗
SVR.回合开始 = SVR.回合开始
SVR.战斗菜单 = SVR.战斗菜单
SVR.战斗自动 = SVR.战斗自动
SVR.战斗操作 = SVR.战斗操作
SVR.孩子喊话 = SVR.孩子喊话
SVR.战斗数据 = SVR.战斗数据
SVR.回合结束 = SVR.回合结束
SVR.退出战斗 = SVR.退出战斗
SVR.战斗喊话 = SVR.战斗喊话
SVR.退出观战 = SVR.退出观战
SVR.助战切换战斗自动 = SVR.助战切换战斗自动
SVR.助战关闭战斗自动 = SVR.助战关闭战斗自动
SVR.助战关闭人物战斗菜单 = SVR.助战关闭人物战斗菜单
SVR.助战关闭召唤战斗菜单 = SVR.助战关闭召唤战斗菜单

SVR.检测 = SVR.检测

return SVR
