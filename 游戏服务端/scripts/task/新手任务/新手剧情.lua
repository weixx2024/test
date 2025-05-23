﻿-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2024-09-24 11:15:02
-- @Last Modified time  : 2024-11-03 11:44:42

local 任务 = {
    名称 = '新手剧情',
    类型 = '新手剧情',
    别名 = '加入御武盟',
    是否可取消 = false
}
local _外形 = { 2078, 2048, 2047, 2043, 2044, 2045, 2061 }

local _新手装备 = {
    [1] = {
        {
            name = "血河神剑",
            部位 = 5,
            等级需求 = 30,
            属性 = {
                命中率 = 30,
                加强混乱 = 5,
                加强昏睡 = 5,
                基础攻击 = 1680
            }
        },
        {
            name = "黑魔冠",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = { 水法反击 = 30, 物理吸收 = 40 }
        },
        {
            name = "百裂穿云甲",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = {
                附加攻击 = 500,
                附水攻击 = 30,
                抗混乱 = 45,
                防御 = 1180,
                速度 = -10
            }
        },
        { name = "万里追云履", 部位 = 10, 等级需求 = 30, 属性 = { 速度 = 110 } },
        {
            name = "万里卷云",
            部位 = 4,
            等级需求 = 30,
            属性 = {
                抗混乱 = 37,
                附加气血 = 2800,
                附加魔法 = 2800
            }
        },
    },
    [2] = {
        {
            name = "天崩地裂",
            部位 = 5,
            等级需求 = 30,
            属性 = {
                命中率 = 30,
                加强混乱 = 5,
                加强封印 = 5,
                基础攻击 = 1680
            }
        },
        {
            name = "黑魔冠",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = { 水法反击 = 30, 物理吸收 = 40 }
        },
        {
            name = "百裂穿云甲",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = {
                附加攻击 = 500,
                附水攻击 = 30,
                抗混乱 = 45,
                防御 = 1180,
                速度 = -10
            }
        },
        { name = "万里追云履", 部位 = 10, 等级需求 = 30, 属性 = { 速度 = 110 } },
        {
            name = "万里卷云",
            部位 = 4,
            等级需求 = 30,
            属性 = {
                抗混乱 = 37,
                附加气血 = 2800,
                附加魔法 = 2800
            }
        },
    },
    [3] = {
        {
            name = "九宫定神斧",
            部位 = 5,
            等级需求 = 30,
            属性 = {
                命中率 = 30,
                加强混乱 = 5,
                加强昏睡 = 5,
                基础攻击 = 1680
            }
        },
        {
            name = "黑魔冠",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = { 水法反击 = 30, 物理吸收 = 40 }
        },
        {
            name = "百裂穿云甲",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = {
                附加攻击 = 500,
                附水攻击 = 30,
                抗混乱 = 45,
                防御 = 1180,
                速度 = -10
            }
        },
        { name = "万里追云履", 部位 = 10, 等级需求 = 30, 属性 = { 速度 = 110 } },
        {
            name = "万里卷云",
            部位 = 4,
            等级需求 = 30,
            属性 = {
                抗混乱 = 37,
                附加气血 = 2800,
                附加魔法 = 2800
            }
        },
    },
    [4] = {
        {
            name = "霹雳枪",
            部位 = 5,
            等级需求 = 30,
            属性 = {
                命中率 = 30,
                加强封印 = 5,
                加强毒伤害 = 2500,
                基础攻击 = 1680
            }
        },
        {
            name = "魔女发冠",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = { 水法反击 = 30, 物理吸收 = 40 }
        },
        {
            name = "七宝天衣",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = {
                附加攻击 = 500,
                附水攻击 = 30,
                抗混乱 = 45,
                防御 = 1180,
                速度 = -10
            }
        },
        { name = "万里追云履", 部位 = 10, 等级需求 = 30, 属性 = { 速度 = 110 } },
        {
            name = "万里卷云",
            部位 = 4,
            等级需求 = 30,
            属性 = {
                抗混乱 = 37,
                附加气血 = 2800,
                附加魔法 = 2800
            }
        },
    },
    [5] = {
        {
            name = "日月同辉",
            部位 = 5,
            等级需求 = 30,
            属性 = {
                命中率 = 30,
                加强封印 = 5,
                加强毒伤害 = 2500,
                基础攻击 = 1680
            }
        },
        {
            name = "魔女发冠",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = { 水法反击 = 30, 物理吸收 = 40 }
        },
        {
            name = "七宝天衣",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = {
                附加攻击 = 500,
                附水攻击 = 30,
                抗混乱 = 45,
                防御 = 1180,
                速度 = -10
            }
        },
        { name = "万里追云履", 部位 = 10, 等级需求 = 30, 属性 = { 速度 = 110 } },
        {
            name = "万里卷云",
            部位 = 4,
            等级需求 = 30,
            属性 = {
                抗混乱 = 37,
                附加气血 = 2800,
                附加魔法 = 2800
            }
        },
    },
    [6] = {
        {
            name = "混元金斗",
            部位 = 5,
            等级需求 = 30,
            属性 = {
                命中率 = 30,
                加强封印 = 5,
                加强毒伤害 = 2500,
                基础攻击 = 1680
            }
        },
        {
            name = "魔女发冠",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = { 水法反击 = 30, 物理吸收 = 40 }
        },
        {
            name = "七宝天衣",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = {
                附加攻击 = 500,
                附水攻击 = 30,
                抗混乱 = 45,
                防御 = 1180,
                速度 = -10
            }
        },
        { name = "万里追云履", 部位 = 10, 等级需求 = 30, 属性 = { 速度 = 110 } },
        {
            name = "万里卷云",
            部位 = 4,
            等级需求 = 30,
            属性 = {
                抗混乱 = 37,
                附加气血 = 2800,
                附加魔法 = 2800
            }
        },
    },

    [7] = {
        {
            name = "天罡战刀",
            部位 = 5,
            等级需求 = 30,
            属性 = {
                命中率 = 30,
                加强震慑 = 3,
                加强加攻法术 = 5,
                基础攻击 = 2100
            }
        },
        {
            name = "黑魔冠",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = { 水法反击 = 30, 物理吸收 = 40 }
        },
        {
            name = "百裂穿云甲",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = {
                附加攻击 = 500,
                附水攻击 = 30,
                抗混乱 = 45,
                防御 = 1180,
                速度 = -10
            }
        },
        { name = "万里追云履", 部位 = 10, 等级需求 = 30, 属性 = { 速度 = 110 } },
        {
            name = "万里卷云",
            部位 = 4,
            等级需求 = 30,
            属性 = {
                抗混乱 = 37,
                附加气血 = 2800,
                附加魔法 = 2800
            }
        },
    },
    [8] = {
        {
            name = "天罡战刀",
            部位 = 5,
            等级需求 = 30,
            属性 = {
                命中率 = 30,
                加强震慑 = 3,
                加强加攻法术 = 5,
                基础攻击 = 2100
            }
        },
        {
            name = "黑魔冠",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = { 水法反击 = 30, 物理吸收 = 40 }
        },
        {
            name = "百裂穿云甲",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = {
                附加攻击 = 500,
                附水攻击 = 30,
                抗混乱 = 45,
                防御 = 1180,
                速度 = -10
            }
        },
        { name = "万里追云履", 部位 = 10, 等级需求 = 30, 属性 = { 速度 = 110 } },
        {
            name = "万里卷云",
            部位 = 4,
            等级需求 = 30,
            属性 = {
                抗混乱 = 37,
                附加气血 = 2800,
                附加魔法 = 2800
            }
        },
    },
    [9] = {
        {
            name = "霹雳枪",
            部位 = 5,
            等级需求 = 30,
            属性 = {
                命中率 = 30,
                加强震慑 = 3,
                加强加攻法术 = 5,
                基础攻击 = 2100
            }
        },
        {
            name = "黑魔冠",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = { 水法反击 = 30, 物理吸收 = 40 }
        },
        {
            name = "百裂穿云甲",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = {
                附加攻击 = 500,
                附水攻击 = 30,
                抗混乱 = 45,
                防御 = 1180,
                速度 = -10
            }
        },
        { name = "万里追云履", 部位 = 10, 等级需求 = 30, 属性 = { 速度 = 110 } },
        {
            name = "万里卷云",
            部位 = 4,
            等级需求 = 30,
            属性 = {
                抗混乱 = 37,
                附加气血 = 2800,
                附加魔法 = 2800
            }
        },
    },
    [10] = {
        {
            name = "撕天裂地",
            部位 = 5,
            等级需求 = 30,
            属性 = {
                命中率 = 30,
                加强震慑 = 3,
                加强加防法术 = 5,
                基础攻击 = 2100
            }
        },
        {
            name = "魔女发冠",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = { 水法反击 = 30, 物理吸收 = 40 }
        },
        {
            name = "七宝天衣",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = {
                附加攻击 = 500,
                附水攻击 = 30,
                抗混乱 = 45,
                防御 = 1180,
                速度 = -10
            }
        },
        { name = "万里追云履", 部位 = 10, 等级需求 = 30, 属性 = { 速度 = 110 } },
        {
            name = "万里卷云",
            部位 = 4,
            等级需求 = 30,
            属性 = {
                抗混乱 = 37,
                附加气血 = 2800,
                附加魔法 = 2800
            }
        },
    },
    [11] = {
        {
            name = "混元金斗",
            部位 = 5,
            等级需求 = 30,
            属性 = {
                命中率 = 30,
                加强震慑 = 3,
                加强加防法术 = 5,
                基础攻击 = 2100
            }
        },
        {
            name = "魔女发冠",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = { 水法反击 = 30, 物理吸收 = 40 }
        },
        {
            name = "七宝天衣",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = {
                附加攻击 = 500,
                附水攻击 = 30,
                抗混乱 = 45,
                防御 = 1180,
                速度 = -10
            }
        },
        { name = "万里追云履", 部位 = 10, 等级需求 = 30, 属性 = { 速度 = 110 } },
        {
            name = "万里卷云",
            部位 = 4,
            等级需求 = 30,
            属性 = {
                抗混乱 = 37,
                附加气血 = 2800,
                附加魔法 = 2800
            }
        },
    },
    [12] = {
        {
            name = "天罡战刀",
            部位 = 5,
            等级需求 = 30,
            属性 = {
                命中率 = 30,
                加强震慑 = 3,
                加强加防法术 = 5,
                基础攻击 = 2100
            }
        },
        {
            name = "魔女发冠",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = { 水法反击 = 30, 物理吸收 = 40 }
        },
        {
            name = "七宝天衣",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = {
                附加攻击 = 500,
                附水攻击 = 30,
                抗混乱 = 45,
                防御 = 1180,
                速度 = -10
            }
        },
        { name = "万里追云履", 部位 = 10, 等级需求 = 30, 属性 = { 速度 = 110 } },
        {
            name = "万里卷云",
            部位 = 4,
            等级需求 = 30,
            属性 = {
                抗混乱 = 37,
                附加气血 = 2800,
                附加魔法 = 2800
            }
        },
    },
    [13] = {
        {
            name = "霹雳枪",
            部位 = 5,
            等级需求 = 30,
            属性 = {
                命中率 = 30,
                加强风 = 8,
                加强雷 = 8,
                加强水 = 8,
                基础攻击 = 1250
            }
        },
        {
            name = "黑魔冠",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = { 水法反击 = 30, 物理吸收 = 40 }
        },
        {
            name = "百裂穿云甲",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = {
                附加攻击 = 500,
                附水攻击 = 30,
                抗混乱 = 45,
                防御 = 1180,
                速度 = -10
            }
        },
        { name = "万里追云履", 部位 = 10, 等级需求 = 30, 属性 = { 速度 = 110 } },
        {
            name = "万里卷云",
            部位 = 4,
            等级需求 = 30,
            属性 = {
                抗混乱 = 37,
                附加气血 = 2800,
                附加魔法 = 2800
            }
        },
    },
    [14] = {
        {
            name = "混元金斗",
            部位 = 5,
            等级需求 = 30,
            属性 = {
                命中率 = 30,
                加强风 = 8,
                加强雷 = 8,
                加强水 = 8,
                基础攻击 = 1250
            }
        },
        {
            name = "黑魔冠",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = { 水法反击 = 30, 物理吸收 = 40 }
        },
        {
            name = "百裂穿云甲",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = {
                附加攻击 = 500,
                附水攻击 = 30,
                抗混乱 = 45,
                防御 = 1180,
                速度 = -10
            }
        },
        { name = "万里追云履", 部位 = 10, 等级需求 = 30, 属性 = { 速度 = 110 } },
        {
            name = "万里卷云",
            部位 = 4,
            等级需求 = 30,
            属性 = {
                抗混乱 = 37,
                附加气血 = 2800,
                附加魔法 = 2800
            }
        },
    },
    [15] = {
        {
            name = "拨云扫月",
            部位 = 5,
            等级需求 = 30,
            属性 = {
                命中率 = 30,
                加强风 = 8,
                加强雷 = 8,
                加强水 = 8,
                基础攻击 = 1250
            }
        },
        {
            name = "黑魔冠",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = { 水法反击 = 30, 物理吸收 = 40 }
        },
        {
            name = "百裂穿云甲",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = {
                附加攻击 = 500,
                附水攻击 = 30,
                抗混乱 = 45,
                防御 = 1180,
                速度 = -10
            }
        },
        { name = "万里追云履", 部位 = 10, 等级需求 = 30, 属性 = { 速度 = 110 } },
        {
            name = "万里卷云",
            部位 = 4,
            等级需求 = 30,
            属性 = {
                抗混乱 = 37,
                附加气血 = 2800,
                附加魔法 = 2800
            }
        },
    },
    [16] = {
        {
            name = "捆仙缚魔绫",
            部位 = 5,
            等级需求 = 30,
            属性 = {
                命中率 = 30,
                加强火 = 8,
                加强雷 = 8,
                加强水 = 8,
                基础攻击 = 1250
            }
        },
        {
            name = "魔女发冠",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = { 水法反击 = 30, 物理吸收 = 40 }
        },
        {
            name = "七宝天衣",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = {
                附加攻击 = 500,
                附水攻击 = 30,
                抗混乱 = 45,
                防御 = 1180,
                速度 = -10
            }
        },
        { name = "万里追云履", 部位 = 10, 等级需求 = 30, 属性 = { 速度 = 110 } },
        {
            name = "万里卷云",
            部位 = 4,
            等级需求 = 30,
            属性 = {
                抗混乱 = 37,
                附加气血 = 2800,
                附加魔法 = 2800
            }
        },
    },
    [17] = {
        {
            name = "留影之环",
            部位 = 5,
            等级需求 = 30,
            属性 = {
                命中率 = 30,
                加强火 = 8,
                加强雷 = 8,
                加强水 = 8,
                基础攻击 = 1250
            }
        },
        {
            name = "魔女发冠",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = { 水法反击 = 30, 物理吸收 = 40 }
        },
        {
            name = "七宝天衣",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = {
                附加攻击 = 500,
                附水攻击 = 30,
                抗混乱 = 45,
                防御 = 1180,
                速度 = -10
            }
        },
        { name = "万里追云履", 部位 = 10, 等级需求 = 30, 属性 = { 速度 = 110 } },
        {
            name = "万里卷云",
            部位 = 4,
            等级需求 = 30,
            属性 = {
                抗混乱 = 37,
                附加气血 = 2800,
                附加魔法 = 2800
            }
        },
    },
    [18] = {
        {
            name = "霹雳枪",
            部位 = 5,
            等级需求 = 30,
            属性 = {
                命中率 = 30,
                加强火 = 8,
                加强雷 = 8,
                加强水 = 8,
                基础攻击 = 1250
            }
        },
        {
            name = "魔女发冠",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = { 水法反击 = 30, 物理吸收 = 40 }
        },
        {
            name = "七宝天衣",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = {
                附加攻击 = 500,
                附水攻击 = 30,
                抗混乱 = 45,
                防御 = 1180,
                速度 = -10
            }
        },
        { name = "万里追云履", 部位 = 10, 等级需求 = 30, 属性 = { 速度 = 110 } },
        {
            name = "万里卷云",
            部位 = 4,
            等级需求 = 30,
            属性 = {
                抗混乱 = 37,
                附加气血 = 2800,
                附加魔法 = 2800
            }
        },
    },
    [60] = {
        {
            name = "霹雳枪",
            部位 = 5,
            等级需求 = 30,
            属性 = {
                命中率 = 30,
                加强鬼火 = 8,
                加强三尸虫回血程度 = 10,
                基础攻击 = 1550
            }
        },
        {
            name = "黑魔冠",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = { 水法反击 = 30, 物理吸收 = 40 }
        },
        {
            name = "百裂穿云甲",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = {
                附加攻击 = 500,
                附水攻击 = 30,
                抗混乱 = 45,
                防御 = 1180,
                速度 = -10
            }
        },
        { name = "万里追云履", 部位 = 10, 等级需求 = 30, 属性 = { 速度 = 110 } },
        {
            name = "万里卷云",
            部位 = 4,
            等级需求 = 30,
            属性 = {
                抗混乱 = 37,
                附加气血 = 2800,
                附加魔法 = 2800
            }
        },
    },
    [62] = {
        {
            name = "天罡战刀",
            部位 = 5,
            等级需求 = 30,
            属性 = {
                命中率 = 30,
                加强鬼火 = 8,
                加强三尸虫回血程度 = 10,
                基础攻击 = 1550
            }
        },
        {
            name = "黑魔冠",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = { 水法反击 = 30, 物理吸收 = 40 }
        },
        {
            name = "百裂穿云甲",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = {
                附加攻击 = 500,
                附水攻击 = 30,
                抗混乱 = 45,
                防御 = 1180,
                速度 = -10
            }
        },
        { name = "万里追云履", 部位 = 10, 等级需求 = 30, 属性 = { 速度 = 110 } },
        {
            name = "万里卷云",
            部位 = 4,
            等级需求 = 30,
            属性 = {
                抗混乱 = 37,
                附加气血 = 2800,
                附加魔法 = 2800
            }
        },
    },
    [61] = {
        {
            name = "连山之卷",
            部位 = 5,
            等级需求 = 30,
            属性 = {
                命中率 = 30,
                加强鬼火 = 8,
                加强三尸虫回血程度 = 10,
                基础攻击 = 1550
            }
        },
        {
            name = "黑魔冠",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = { 水法反击 = 30, 物理吸收 = 40 }
        },
        {
            name = "百裂穿云甲",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = {
                附加攻击 = 500,
                附水攻击 = 30,
                抗混乱 = 45,
                防御 = 1180,
                速度 = -10
            }
        },
        { name = "万里追云履", 部位 = 10, 等级需求 = 30, 属性 = { 速度 = 110 } },
        {
            name = "万里卷云",
            部位 = 4,
            等级需求 = 30,
            属性 = {
                抗混乱 = 37,
                附加气血 = 2800,
                附加魔法 = 2800
            }
        },
    },
    [63] = {
        {
            name = "撕天裂地",
            部位 = 5,
            等级需求 = 30,
            属性 = {
                命中率 = 30,
                加强鬼火 = 8,
                加强遗忘 = 5,
                基础攻击 = 1550
            }
        },
        {
            name = "魔女发冠",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = { 水法反击 = 30, 物理吸收 = 40 }
        },
        {
            name = "七宝天衣",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = {
                附加攻击 = 500,
                附水攻击 = 30,
                抗混乱 = 45,
                防御 = 1180,
                速度 = -10
            }
        },
        { name = "万里追云履", 部位 = 10, 等级需求 = 30, 属性 = { 速度 = 110 } },
        {
            name = "万里卷云",
            部位 = 4,
            等级需求 = 30,
            属性 = {
                抗混乱 = 37,
                附加气血 = 2800,
                附加魔法 = 2800
            }
        },
    },
    [64] = {
        {
            name = "捆仙缚魔绫",
            部位 = 5,
            等级需求 = 30,
            属性 = {
                命中率 = 30,
                加强鬼火 = 8,
                加强遗忘 = 5,
                基础攻击 = 1550
            }
        },
        {
            name = "魔女发冠",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = { 水法反击 = 30, 物理吸收 = 40 }
        },
        {
            name = "七宝天衣",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = {
                附加攻击 = 500,
                附水攻击 = 30,
                抗混乱 = 45,
                防御 = 1180,
                速度 = -10
            }
        },
        { name = "万里追云履", 部位 = 10, 等级需求 = 30, 属性 = { 速度 = 110 } },
        {
            name = "万里卷云",
            部位 = 4,
            等级需求 = 30,
            属性 = {
                抗混乱 = 37,
                附加气血 = 2800,
                附加魔法 = 2800
            }
        },
    },
    [65] = {
        {
            name = "混元索",
            部位 = 5,
            等级需求 = 30,
            属性 = {
                命中率 = 30,
                加强鬼火 = 8,
                加强遗忘 = 5,
                基础攻击 = 1550
            }
        },
        {
            name = "魔女发冠",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = { 水法反击 = 30, 物理吸收 = 40 }
        },
        {
            name = "七宝天衣",
            部位 = 2,
            等级需求 = 30,
            属性要求 = { "力量", 10 },
            属性 = {
                附加攻击 = 500,
                附水攻击 = 30,
                抗混乱 = 45,
                防御 = 1180,
                速度 = -10
            }
        },
        { name = "万里追云履", 部位 = 10, 等级需求 = 30, 属性 = { 速度 = 110 } },
        {
            name = "万里卷云",
            部位 = 4,
            等级需求 = 30,
            属性 = {
                抗混乱 = 37,
                附加气血 = 2800,
                附加魔法 = 2800
            }
        },
    },
}

function 任务:任务初始化()
    self.进度 = 1
end

function 任务:任务上线(玩家)
    if not self.初始对话 then
        self.初始对话 = 1
        玩家:打开对话(
            "欢迎进入复古西游的三种族情义世界#93，我是你们亲爱的大话精灵#98，可以帮助你们解决各种问题需要我的时候可以点击好友栏或ALT+F打开好友栏找到好友大话精灵，把问题的主要关键词发给我就好啦！查询关键词请打“关键词”三个字发给我即可获得对应答案。#86\nmenu\n"
            , 2315, 10086)
        玩家:添加任务经验(400, "新手剧情")
    end
end

local _说明 = {
    '#Y任务目的:#r#W前往#G东海渔村#W找#Y#u#[1208|53|129|$御武盟盟主#]#u#W聊聊吧！',
    --加入御武盟 1
    '#Y任务目的:#r#W前往#G东海渔村#W找#Y#u#[1208|86|107|$宠物领养员#]#u#W聊聊吧！',
    --领养时间宠 2
    '#Y任务目的:#r#W前往#G东海渔村#W找#Y#u#[1208|75|119|$法术指导员#]#u#W聊聊吧！',
    --学习师门技能 3
    '#Y任务目的:#r#W前往#G东海渔村#W找#Y#u#[1208|82|89|$江湖郎中#]#u#W聊聊吧！',
    --拜访江湖郎中 4
    '#Y任务目的:#r#W前往#G东海渔村#W找#Y#u#[1210|13|7|$药店老板#]#u#W聊聊吧！',
    --拜访药店老板 5
    '#Y任务目的:#r#W前往#G东海渔村#W找#Y#u#[1208|38|117|$渔村村长#]#u#W聊聊吧！',
    --拜访渔村村长 6
    '#Y任务目的:#r#W前往#G东海渔村#W找#Y#u#[1208|22|47|$渔夫#]#u#W了解如何去往长安！#r#Y任务提醒:#r#W先将等级提升至#R10#W级，帮助#Y#u#[1208|38|117|$渔村村长#]#u#W完成任务或者前往#Y#u#[1213|210|30|$珊瑚海岛#]#u#W杀敌，可快速提升等级！',
    --前往长安 7
    '#Y任务目的:#r#W快去旁边#G长安城云来酒店#W找#Y#u#[1030|17|7|$酒店老板#]#u#W谈谈！',
    --拜访酒店老板 8
    '#Y任务目的:#r#W去#G长安城回春堂#W找#Y#u#[1016|16|8|$药店老板#]#u#W交谈，就在全面不远！',
    --拜访药店老板 9
    '#Y任务目的:#r#W去#G长安城打铁铺#W找#Y#u#[1025|12|7|$冯铁匠#]#u#W交谈！',
    --拜访冯铁匠 10
    '#Y任务目的:#r#W去#G长安城服装店#W找#Y#u#[1022|14|8|$服装店老板#]#u#W看看吧！',
    --拜访服装店老板 11
    '#Y任务目的:#r#W去#G长安城杂货店#W找#Y#u#[1015|16|8|$杂货店老板#]#u#W看看吧！',
    --拜访杂货店老板 12
    '#Y任务目的:#r#W去#G长安城#W找#Y#u#[1001|323|260|$一品侍卫#]#u#W聊聊吧！',
    --领取双倍 13
    '#Y任务目的:#r#W从#G长安城#W前往#G#u#[1004|27|22|$大雁塔一层#]#u#W杀敌%s/#R5场！',
    --大雁塔杀敌 14
    '#Y任务目的:#r#W前往#Y大雁塔一层#W击杀#G#u#[1004|114|69|索命鬼|$索命鬼#]#u#R(挑战难度建议组队)！',
    --击杀索命鬼 15
    '#Y任务目的:#r#W前往#G地府(76,42)#W找#Y#u#[1122|75|42|$钟馗#]#u#W谈一谈',
    --拜访钟馗 16

    '#Y任务目的:#r#W接受#Y#u#[1122|75|42|$钟馗#]#u#W的考验[钟馗抓鬼%s/7次]#r#R(该任务有一定难度，请组队带上小伙伴共同完成。)',
    --拜访钟馗 17


}

function 任务:任务取详情(玩家)
    if self.进度 == 17 then
        return _说明[self.进度]:format(self.抓鬼)
    elseif self.进度 == 14 then
        return _说明[self.进度]:format(self.大雁杀敌)
    end
    return _说明[self.进度]
end

local _一法 = {
    [1001] = { '催眠咒', '反间之计', '作茧自缚' }, --男人
    [1002] = { '催眠咒', '作茧自缚', '蛇蝎美人' }, --女人--女人
    [2001] = { '妖之魔力', '夺命勾魂', '魔之飞步' }, --男魔
    [2002] = { '妖之魔力', '夺命勾魂', '红袖添香' }, --女魔
    [3001] = { '雷霆霹雳', '龙卷雨击', '飞砂走石' }, --男仙
    [3002] = { '雷霆霹雳', '龙卷雨击', '地狱烈火' }, --女仙
    [4001] = { '幽冥鬼火', '麻沸散', '吸血水蛭' }, --男鬼
    [4002] = { '幽冥鬼火', '麻沸散', '幽怜魅影' } --女鬼
}

function 任务:计算选项(玩家)
    local xx = ''
    for k, v in pairs(_一法[玩家.种族 * 1000 + 玩家.性别]) do
        if not 玩家:取技能是否存在(v) then
            xx = xx .. v .. '\n'
        end
    end
    return xx
end

local _台词 = {
    '少侠，你身上没有足够的包裹放奖励的物品哦！请最少保留一个包裹栏空位！',
    --1
    '恭喜您加入游侠盟#43以后您可以在游侠盟频道中向高手请教问题了#90',
    --2
    '1.宠物随主人的#Y在线时间#W增长而升级；#r2.召唤兽通过在战斗中选择#G捕捉#W指令获得，捕捉需要满足一定的称谓和等级，捕捉后在战斗中通过#G召唤#W指令将之释放出来；#r3.某些召唤兽能使用魔法，成长到一定等级后将自动掌握；#r4.从0级开始培养的高级召唤兽其威力可是很惊人的；#r5.长安城等地中有#G超级巫医#W可以给召唤兽恢复状态哦！',
    --3
    '好的，看我的妙手回春！你已经完全好了。',
    --4
    ' 药品可以在在东海渔村草药店，长安药店，长寿药店，洛阳药店，洛阳集市药店，傲来药店有售，更高级的药品只有通过一些日常任务获得，200环任务可以获得百分比药品。',
    --5
    '少侠，外面很危险！还是先找#Y渔村村长#W磨练磨练，将等级提升至10级后再来吧！',
    --6
    '相见即为有缘，我稍微懂点微末之技，你想学习什么呢？',
    --7
    '钟馗老大命我日夜在此监视塔内情况，但近期塔内情况越来越复杂，我刚看你在塔内奋力杀敌，可否接受我的考验？考验成功后便可前往地府接受钟馗的考验了！\nmenu\n1|我接受你的考验\n2|鬼才信你的话'
    --8
}
function 任务:任务NPC对话(玩家, NPC)
    if NPC.名称 == '御武盟盟主' and NPC.台词 then
        if self.进度 == 1 then
            NPC.台词 = NPC.台词 .. '\n1|好呢！我正想向高手请教呢！\n2|算了，自己动手丰衣足食。'
        end
    elseif NPC.名称 == '宠物领养员' then
        if self.进度 == 2 then
            NPC.台词 = NPC.台词
        end
    elseif NPC.名称 == '法术指导员' then
        if self.进度 == 3 then
            NPC.台词 = NPC.台词 .. "我要学习技能"
        end
    elseif NPC.名称 == '江湖郎中' then
        if self.进度 == 4 then
            NPC.台词 = NPC.台词 .. '\n1|是啊，我伤的厉害，快救治我吧。\n2|算了，活泼着呢！没有什么大碍。'
        end
    elseif NPC.名称 == '药店老板' then
        if 玩家.地图 == 1210 then
            if self.进度 == 5 then
                NPC.台词 = NPC.台词
            end
        elseif 玩家.地图 == 1016 then
            if self.进度 == 9 then
                NPC.台词 = NPC.台词
            end
        end
    elseif NPC.名称 == '渔村村长' then
        if self.进度 == 6 then
            self:完成进度(玩家)
            NPC.台词 = '我们村人少，需要不少的人手，不会亏了你的好处的。'
        end
    elseif NPC.名称 == '酒店老板' and 玩家.地图 == 1030 then
        if self.进度 == 8 then
            NPC.台词 = NPC.台词
        end
    elseif NPC.名称 == '冯铁匠' then
        if self.进度 == 10 then
            NPC.台词 = NPC.台词
        end
    elseif NPC.名称 == '服装店老板' then
        if self.进度 == 11 then
            NPC.台词 = NPC.台词
        end
    elseif NPC.名称 == '一品侍卫' then
        if self.进度 == 13 then
            self:完成进度(玩家)
            NPC.台词 = NPC.台词
        end
    elseif NPC.名称 == '索命鬼' then
        if 玩家.地图 == 1004 and self.进度 == 15 then
            NPC.台词 = _台词[8]
        end
    elseif NPC.名称 == '钟馗' then
        if 玩家.地图 == 1122 and self.进度 == 16 then
            self:完成进度(玩家)
            self.抓鬼 = 0
        end
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
    if NPC.名称 == '御武盟盟主' then
        if i == '1' then
            if self.进度 == 1 then
                self:完成进度(玩家)
            end
            NPC.台词 = _台词[2]
        end
    elseif NPC.名称 == '宠物领养员' then
        if i == '4' then
            NPC.台词 = nil
            local p = 玩家:打开宠物领养窗口()
            if p then
                for _, v in 玩家:遍历队伍() do
                    local r = v:取任务('新手剧情')
                    if r and r.进度 == 2 then
                        local rr = v:领养时间宠(p)
                        if rr == 1 then
                            v:打开对话(_台词[3], NPC.外形)
                            v:提示窗口('#Y领养成功！')
                            v:添加任务经验(462, "新手剧情2")
                             --v:添加召唤(生成召唤 { 名称 = "白晶晶", 类型 = 0 })
                             v:添加召唤(生成召唤 { 名称 = "至尊小宝", 类型 = 0 })
                            v:添加召唤(生成召唤 { 名称 = "小浪淘沙", 类型 = 0 })
                            v:添加物品({ 生成物品 { 名称 = '召唤兽内丹', 数量 = 1, 技能 = "浩然正气" } })
                            r.进度 = r.进度 + 1
                        end
                    end
                end
            end
        end
    elseif NPC.名称 == '法术指导员' then
        if i == "我要学习技能" then
            for _, v in 玩家:遍历队伍() do
                local r = v:取任务('新手剧情')
                if r and r.进度 == 3 then
                    v:添加全部技能(1)
                    v:添加任务经验(105720 * 3, "新手剧情3")
                    v:常规提示("#Y恭喜你！你学会了门派技能#W。")
                    v:最后对话('你学会了所有技能')
                    r.进度 = r.进度 + 1
                end
            end
        end
    elseif NPC.名称 == '江湖郎中' then
        if i == '1' then
            if self.进度 == 4 then
                self:完成进度(玩家)
                NPC.台词 = _台词[4]
            end
        end
    elseif NPC.名称 == '药店老板' then
        if 玩家.地图 == 1210 then
            if i == '3' then
                if self.进度 == 5 then
                    self:完成进度(玩家)
                    NPC.台词 = _台词[5]
                end
            end
        elseif 玩家.地图 == 1016 then
            if i == '3' then
                if self.进度 == 9 then
                    self:完成进度(玩家)
                end
            end
        end
    elseif NPC.名称 == '渔夫' then
        NPC.台词 = nil
        if self.进度 == 7 and 玩家.等级 >= 10 then
            if i == '3' then
                self:完成进度(玩家)
                玩家:切换地图(1001, 342, 18)
            end
            NPC.台词 = _台词[6]
        end
    elseif NPC.名称 == '酒店老板' and 玩家.地图 == 1030 then
        if self.进度 == 8 then
            if i == '4' then
                self:完成进度(玩家)
            end
        end
    elseif NPC.名称 == '冯铁匠' then
        if i == '3' then
            if self.进度 == 10 then
                self:完成进度(玩家)
            end
        end
    elseif NPC.名称 == '服装店老板' then --001022
        if i == '3' then
            if self.进度 == 11 then
                self:完成进度(玩家)
            end
        end
    elseif NPC.名称 == '杂货店老板' then --001015
        if i == '2' then
            if self.进度 == 12 then
                self:完成进度(玩家)
            end
        end
    elseif NPC.名称 == '索命鬼' then
        if 玩家.地图 == 1004 and self.进度 == 15 then
            if i == "1" then
                玩家:进入战斗('scripts/task/新手任务/新手剧情.lua', NPC)
            end
        end
    end
end

function 任务:完成抓鬼(玩家)
    if self.进度 ~= 17 then
        return
    end
    if not self.抓鬼 then
        self.抓鬼 = 0
    end
    self.抓鬼 = self.抓鬼 + 1
    if self.抓鬼 >= 7 then
        self:完成进度(玩家)
    end
end

function 任务:大雁塔杀敌(玩家)
    if self.进度 ~= 14 then
        return
    end
    if not self.大雁杀敌 then
        self.大雁杀敌 = 0
    end
    self.大雁杀敌 = self.大雁杀敌 + 1
    if self.大雁杀敌 >= 5 then
        self:完成进度(玩家)
    end
end

local _经验奖励 = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 }
local _银子奖励 = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 }
local _别名 = { "加入御武盟", '领养时间宠', '学习师门技能', '拜访江湖郎中', '拜访药店老板',
    '拜访村长', '前往长安', '拜访酒店老板', '拜访药店老板', '拜访冯铁匠', '拜访服装店老板',
    '拜访杂货店老板', '领取双倍', '大雁塔杀敌', "击杀索命鬼", "拜访钟馗", "钟馗的考验" }

function 任务:被动学习技能(玩家, n)
    玩家:添加全部技能(1)
    玩家:常规提示("恭喜你！你学会了门派技能")
    玩家:添加任务经验(10572 * 3, "新手剧情3")
    self:完成进度(玩家)
end

function 任务:添加奖励(玩家)
    if self.进度 == 1 then
        玩家:添加物品({ 生成物品 { 名称 = '游侠盟锦囊', 数量 = 1 } })
        玩家:添加称谓('游侠盟小虾米')
        玩家:更换称谓('游侠盟小虾米')
        玩家:添加任务经验(103156, "新手剧情1")
    elseif self.进度 == 2 then
    elseif self.进度 == 3 then
    elseif self.进度 == 4 then
        玩家:添加物品({ 生成物品 { 名称 = '宠物口粮', 数量 = 50 } })
        玩家:双加(玩家.最大气血, 玩家.最大魔法)
        玩家:添加任务经验(111698, "新手剧情3")
    elseif self.进度 == 5 then
        玩家:添加物品({ 生成物品 { 名称 = '金针', 数量 = 50 }, 生成物品 { 名称 = '八角莲叶',
            数量 = 50 } })
        玩家:添加任务经验(882, "新手剧情4")
    elseif self.进度 == 6 then
        玩家:添加任务经验(11135, "新手剧情5")
    elseif self.进度 == 7 then
        玩家:添加任务经验(735125, "新手剧情6")
    elseif self.进度 == 8 then
        玩家:双加(玩家.最大气血, 玩家.最大魔法)
        玩家:添加任务经验(132852, "新手剧情7")
    elseif self.进度 == 9 then
        玩家:添加物品({
            生成物品 { 名称 = '月见草', 数量 = 50 },
            生成物品 { 名称 = '凤凰尾', 数量 = 50 }
        })
        玩家:添加任务经验(192179, "新手剧情7")
    elseif self.进度 == 10 then
        local t = _新手装备[玩家.原形]
        if not t then
            return
        end
        local list = {}
        for k, v in pairs(t) do
            if v.部位 == 4 or v.部位 == 5 then
                local r = 生成装备 { 名称 = v.name }
                if r then
                    r.等级需求 = { 0, 30 }
                    if v.属性要求 then
                        r.属性要求 = { "力量", 10 }
                    end
                    r.基本属性 = {}
                    r.新手装备 = true
                    r.禁止交易 = true
                    for a, b in pairs(v.属性) do
                        table.insert(r.基本属性, { a, b })
                    end
                end
                table.insert(list, r)
            end
        end
        if 玩家:添加物品(list) then --新手装备 9级武器 9级项链
            玩家:添加任务经验(251506, "新手剧情7")
        end
    elseif self.进度 == 11 then
        local t = _新手装备[玩家.原形]
        if not t then
            return
        end
        local list = {}
        for k, v in pairs(t) do
            if v.部位 ~= 4 and v.部位 ~= 5 then
                local r = 生成装备 { 名称 = v.name }
                if r then
                    r.等级需求 = { 0, 30 }
                    if v.属性要求 then
                        r.属性要求 = { "力量", 10 }
                    end
                    r.基本属性 = {}
                    r.新手装备 = true
                    r.禁止交易 = true
                    for a, b in pairs(v.属性) do
                        table.insert(r.基本属性, { a, b })
                    end
                end
                table.insert(list, r)
            end
        end
        if 玩家:添加物品(list) then
            玩家:添加任务经验(310833, "新手剧情7")
        end
    elseif self.进度 == 12 then
        玩家:添加物品 {
            生成物品 { 名称 = '高级飞行旗', 数量 = 1 },
            生成物品 { 名称 = '高级飞行旗', 数量 = 1 }
        }

        玩家:添加任务经验(370160, "新手剧情7")
    elseif self.进度 == 13 then
        local r = 生成任务 { 名称 = '变身卡', 外形 = _外形[math.random(#_外形)] }
        r:添加任务(玩家)
        玩家:添加任务经验(429487, "新手剧情7")
        self.大雁杀敌 = 0
    elseif self.进度 == 14 then
        玩家:添加任务经验(445845, "新手剧情7")
    elseif self.进度 == 15 then
        玩家:添加任务经验(488814, "新手剧情7")
    elseif self.进度 == 16 then

    elseif self.进度 == 17 then
        玩家:添加任务经验(548141, "新手剧情7")
    elseif self.进度 == 18 then

    end
end

function 任务:完成进度(玩家)
    local r = 玩家:取任务('新手剧情')
    local 进度 = r.进度
    for _, v in 玩家:遍历队伍() do
        local rr = v:取任务('新手剧情')
        if rr and rr.进度 == 进度 then
            rr:添加奖励(v) --当前进度
            rr.进度 = rr.进度 + 1
            rr.别名 = _别名[rr.进度]
            if rr.进度 > 17 then
                rr:删除()
            end
        end
    end
end

function 任务:升级事件(玩家)
end

local _可切换 = {
    [1208] = true,
    [1213] = true,
    [1214] = true,
    [1215] = true,
    [1216] = true,
    [1210] = true,
    [1211] = true,
    [11074] = true,
}


function 任务:切换地图前事件(玩家, 地图)
    if 玩家.等级 < 10 then
        if 地图 and _可切换[地图.id] then
        else
            return false
        end
    end
end

function 任务:任务战斗结束(玩家)
    if 玩家.地图 == 1004 then
        self:大雁塔杀敌(玩家)
    end
end

local _小怪 = { { 2001, "兔妖" }, { 2004, "小妖" }, { 2017, "骷颅怪" }, { 2027, "死灵" } }
function 任务:战斗初始化(玩家, NPC)
    if NPC.名称 == "索命鬼" then
        for i = 1, 1 do
            local r = 生成战斗怪物 {
                外形 = NPC.外形,
                名称 = NPC.名称,
                攻击 = 59,
                速度 = 38,
                气血 = 9862,
            }
            self:加入敌方(i, r)
        end
        for i = 2, 5 do
            local r = 生成战斗怪物 {
                外形 = _小怪[i - 1][1],
                名称 = _小怪[i - 1][2],
                攻击 = 3,
                速度 = 12,
                气血 = 2314,
            }
            self:加入敌方(i, r)
        end
    end
end

function 任务:战斗回合开始(dt)
end

function 任务:战斗结束(s)
    if s then
        for k, v in self:遍历我方() do
            if v.是否玩家 then
                local r = v.对象.接口:取任务("新手剧情")
                if r and r.进度 == 15 then
                    r:完成进度(v.对象.接口)
                end
            end
        end
    end
end

return 任务
