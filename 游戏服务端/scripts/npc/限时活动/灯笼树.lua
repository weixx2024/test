local NPC = {}
local 对话 = [[
元宵快乐。
]]

local 真确对话 = [[
哇塞,您太有才了,这是一点小小的心意。
]]
local 错误对话 = [[
很遗憾回答错误,不要灰心，我相信你可以的。
]]

local 题库 = { --字谜
    { "饭（打一字）", "糙" },
    { "稻（打一字）", "类" },
    { "武（打一字）", "斐" },
    { "刃（打一字）", "召" },
    { "冰（打一字）", "涸" },
    { "再（打一字）", "变" },
    { "巨（打一字）", "奕" },
    { "厩（打一字）", "驴" },
    { "嘴（打一字）", "唧" },
    { "岸（打一字）", "滂" },
    { "矮（打一字）", "射" },
    { "炭（打一字）", "樵" },
    { "痴（打一字）", "保" },
    { "雨（打一字）", "池" },
    { "日（打一字）", "畔" },
    { "目（打一字）", "置" },
    { "灰（打一字）", "尘" },
    { "众（打一字）", "侈" },
    { "爿（打一字）", "版" },
    { "思（打一字）", "十" },
    { "水库（打一字）", "沧" },
    { "丰收（打一字）", "移" },
    { "丹朱（打一字）", "赫" },
    { "丹江（打一字）", "洙" },
    { "干涉（打一字）", "步" },
    { "西施（打一字）", "俪" },
    { "东施（打一字）", "妞" },
    { "书签（打一字）", "颊" },
    { "血盆（打一字）", "唬" },
    { "早上（打一字）", "日" },
    { "航道（打一字）", "潞" },
    { "和局（打一字）", "抨" },
    { "泥峰（打一字）", "击" },
    { "祝福（打一字）", "诘" },
    { "烟缸（打一字）", "盔" },
    { "晚会（打一字）", "多" },
    { "瑞士（打一字）", "佶" },
    { "粮食（打一字）", "稞" },
    { "乍得人（打一字）", "作" },
    { "鬼头山（打一字）", "嵬" },
    { "顶破天（打一字）", "夫" },
    { "三丫头（打一字）", "羊" },
    { "不怕火（打一字）", "镇" },
    { "写下面（打一字）", "与" },
    { "陈玉成（打一字）", "瑛" },
    { "旱天雷（打一字）", "田" },
    { "热处理（打一字）", "煺" },
    { "不要走（打一字）", "还" },
    { "半导体（打一字）", "付" },
    { "关帝庙（打一字）", "扇" },
    { "好读书（打一字）", "敞" },
    { "雁双飞（打一字）", "从" },
    { "单人床（打一字）", "庥" },
    { "神农架（打一字）", "枢" },
    { "抽水泵（打一字）", "石" },
    { "画中人（打一字）", "佃" },
    { "绊脚石（打一字）", "跖" },
    { "高尔基（打一字）", "尚" },
    { "春末夏初（打一字）", "旦" },
    { "冬初秋末（打一字）", "八" },
    { "包头界首（打一字）", "甸" },
    { "古文观止（打一字）", "故" },
    { "争先恐后（打一字）", "急" },
    { "百无一是（打一字）", "白" },
    { "上下一体（打一字）", "卡" },
    { "另有变动（打一字）", "加" },
    { "异口同声（打一字）", "谐" },
    { "半耕半读（打一字）", "讲" },
    { "颠三倒四（打一字）", "泪" },
    { "凤头虎尾（打一字）", "几" },
    { "弹丸之地（打一字）", "尘" },
    { "四个晚上（打一字）", "罗" },
    { "熙熙攘攘（打一字）", "侈" },
    { "连声应允（打一字）", "哥" },
    { "孩子丢了（打一字）", "亥" },
    { "池塘亮底（打一字）", "汗" },
    { "内里有人（打一字）", "肉" },
    { "谢绝参观（打一字）", "企" },
    { "床前明月光（打一字）", "旷" },
    { "对影成三人（打一字）", "奏" },
    { "总是玉关情（打一字）", "国" },
    { "柴门闻犬吠（打一字）", "润" },
    { "我独不得出（打一字）", "圄" },
    { "三点河旁落（打一字）", "可" },
    { "二十四小时（打一字）", "旧" },
    { "两点天上来（打一字）", "关" },
    { "入门无犬吠（打一字）", "问" },
    { "一人背张弓（打一字）", "夷" },
    { "说话的技术（打一字）", "团" },
    { "第二次握手（打一字）", "观" },
    { "开门日正中（打一字）", "间" },
    { "李时珍所著（打一字）", "苯" },
    { "一口咬破衣（打一字）", "哀" },
    { "非正式协定（打一字）", "药" },
    { "有一点不准（打一字）", "淮" },
    { "宿鸟恋枝头（打一字）", "术" },
    { "日月一齐来（打一字）", "胆" },
    { "进水行不成（打一字）", "衍" },
    { "天际孤帆愁别离（打一字）", "穗" },
    { "十日画一水（打一字）", "洵" },
    { "一一入史册（打一字）", "更" },
    { "四方一条心（打一字）", "愣" },
    { "日迈长安远（打一字）", "宴" },
    { "驿外断桥边（打一字）", "骄" },
    { "陕西人十分好（打一字）", "附" },
    { "早不说晚不说（打一字）", "午" },
    { "西安相聚之日（打一字）", "晒" },
    { "一直真心相对（打一字）", "非" },
    { "对方进了一球（打一字）", "哼" },
    { "孤峦叠嶂层云散（打一字）", "崛" },
    { "江西如今变了样（打一字）", "冷" },
    { "后村闺中听风声（打一字）", "封" },
    { "送走观音使不得（打一字）", "还" },
    { "一点一点得知（打一字）", "短" },
    { "除夕残年又逢春（打一字）", "桀" },
    { "水映横山落残红（打一字）", "绿" },
    { "遥指红楼是妾家（打一字）", "舒" },
    { "画前画后费心思（打一字）", "田" },
}
local 题库2 = { --成语谜

    { "龙（打一成语）", "充耳不闻" },
    { "一（打一成语）", "接二连三" },
    { "乖（打一成语）", "乘人不备" },
    { "亚（打一成语）", "有口难言" },
    { "主（打一成语）", "一往无前" },
    { "呀（打一成语）", "唇齿相依" },
    { "判（打一成语）", "一刀两断" },
    { "者（打一成语）", "有目共睹" },
    { "泵（打一成语）", "水落石出" },
    { "扰（打一成语）", "半推半就" },
    { "黯（打一成语）", "有声有色" },
    { "田（打一成语）", "挖空心思" },
    { "十（打一成语）", "纵横交错" },
    { "板（打一成语）", "残茶剩饭" },
    { "咄（打一成语）", "脱口而出" },
    { "票（打一成语）", "闻风而起" },
    { "骡（打一成语）", "非驴非马" },
    { "桁（打一成语）", "行将就木" },
    { "皇（打一成语）", "白玉无瑕" },
    { "忘（打一成语）", "死心塌地" },
    { "中的（打一成语）", "矢无虚发" },
    { "会计（打一成语）", "足智多谋" },
    { "电梯（打一成语）", "能上能下" },
    { "并重（打一成语）", "恰如其分" },
    { "相声（打一成语）", "装腔作势" },
    { "伞兵（打一成语）", "从天而降" },
    { "背脸（打一成语）", "其貌不扬" },
    { "假眼（打一成语）", "目不转睛" },
    { "氙氚（打一成语）", "气吞山河" },
    { "胜境（打一成语）", "不败之地" },
    { "武断（打一成语）", "不容分说" },
    { "雨披（打一成语）", "一衣带水" },
    { "极小（打一成语）", "微乎其微" },
    { "初一（打一成语）", "日新月异" },
    { "仙乐（打一成语）", "不同凡响" },
    { "美梦（打一成语）", "好景不长" },
    { "兄弟（打一成语）", "数一数二" },
    { "齐唱（打一成语）", "异口同声" },
    { "卧倒（打一成语）", "五体投地" },
    { "圆寂（打一成语）", "坐以待毙" },
    { "感冒通（打一成语）", "有伤风化" },
    { "化妆学（打一成语）", "谈何容易" },
    { "太阳灶（打一成语）", "热火朝天" },
    { "显微镜（打一成语）", "一孔之见" },
    { "爬竹竿（打一成语）", "节节上升" },
    { "无底洞（打一成语）", "深不可测" },
    { "望江亭（打一成语）", "近水楼台" },
    { "脱粒机（打一成语）", "吞吞吐吐" },
    { "农产品（打一成语）", "土生土长" },
    { "彩调剧（打一成语）", "声色俱厉" },
    { "黑板报（打一成语）", "白字连篇" },
    { "飞行员（打一成语）", "有机可乘" },
    { "翘翘板（打一成语）", "此起彼伏" },
    { "婚丧事（打一成语）", "悲喜交加" },
    { "打边鼓（打一成语）", "旁敲侧击" },
    { "飞鸣镝（打一成语）", "弦外之音" },
    { "垃圾箱（打一成语）", "藏垢纳污" },
    { "纸老虎（打一成语）", "外强中干" },
    { "八十八（打一成语）", "入木三分" },
    { "笑死人（打一成语）", "乐极生悲" },
    { "鹊巢鸦占（打一成语）", "化为乌有" },
    { "尽收眼底（打一成语）", "一览无遗" },
    { "逆水划船（打一成语）", "力争上游" },
    { "石榴成熟（打一成语）", "皮开肉绽" },
    { "举重比赛（打一成语）", "斤斤计较" },
    { "枪弹上膛（打一成语）", "一触即发" },
    { "全面开荒（打一成语）", "不留余地" },
    { "《聊斋志异》（打一成语）", "鬼话连篇" },
    { "零存整取（打一成语）", "积少成多" },
    { "愚公之家（打一成语）", "开门见山" },
    { "盲人摸象（打一成语）", "不识大体" },
    { "清浊合流（打一成语）", "泾渭不分" },
    { "四通八达（打一成语）", "头头是道" },
    { "双手赞成（打一成语）", "多此一举" },
    { "蜜饯黄连（打一成语）", "同甘共苦" },
    { "单方告别（打一成语）", "一面之词" },
    { "照相底片（打一成语）", "颠倒黑白" },
    { "爱好旅游（打一成语）", "喜出望外" },
    { "公用毛巾（打一成语）", "面面俱到" },
    { "武大郎设宴（打一成语）", "高朋满座" },
    { "遇事不求人（打一成语）", "自力更生" },
    { "千里通电话（打一成语）", "遥相呼应" },
    { "多看无滋味（打一成语）", "屡见不鲜" },
    { "兔子请老虎（打一成语）", "寅吃卯粮" },
    { "不考虑中间（打一成语）", "瞻前顾后" },
    { "没关水龙头（打一成语）", "放任自流" },
    { "快刀斩乱麻（打一成语）", "迎刃而解" },
    { "暗中下围棋（打一成语）", "皂白不分" },
    { "给家捎个话（打一成语）", "言而无信" },
    { "一块变九块（打一成语）", "四分五裂" },
    { "鲁达当和尚（打一成语）", "半路出家" },
    { "哑巴打手势（打一成语）", "不言而喻" },
    { "娄阿鼠问卦（打一成语）", "做贼心虚" },
    { "超级好牙刷（打一成语）", "一毛不拔" },
    { "猫狗像什么（打一成语）", "如狼似虎" },
    { "电锯开木头（打一成语）", "当机立断" },
    { "空对空导弹（打一成语）", "见机行事" },
    { "二三四五六七八九（打一成语）", "缺衣少食" },




}
local 题库3 = { --典故迷
    { "尖（打《论语》一句）", "小大由之" },
    { "退休（打《论语》一句）", "老者安之" },
    { "退席（打《论语》一句）", "不在其位" },
    { "好读书（打《论语》一句）", "学而不厌" },
    { "门外汉（打《论语》一句）", "未入于室也" },
    { "到处碰壁（打《论语》一句）", "不得其门而入" },
    { "于予与何诛（打《论语》一句）", "我无言责之" },
    { "莫中美人计（打《论语》一句）", "戒之在色" },
    { "傀儡（打《孟子》一句）", "为其像人而用之也" },
    { "请勿过虑（打《孟子》一句）", "求其放心而已矣" },
    { "使女择焉（打《孟子》一句）", "决汝汉" },
    { "席地谈天（打《孟子》一句）", "位卑而言高" },
    { "世界冠军（打《孟子》一句）", "无敌于天下" },
    { "丰衣足食（打《孟子》一句）", "黎民不饥不寒" },
    { "斯已而已矣（打《孟子》一句）", "可以止则止" },
    { "广厦千万间（打《孟子》一句）", "大哉居乎" },
    { "易之而教之（打《孟子》一句）", "迭为宾主" },
    { "为储户保密（打《四书》一句）", "慎言其余" },
    { "北行竟迷途（打《四书》一句）", "上失其道" },
    { "句句扣心弦（打《四书》一句）", "言必有中" },
    { "不省人事（打《孙子兵法》一句）", "知天知地" },
    { "光杆司令（打《孙子兵法》一句）", "将不重也" },
    { "智力考核（打《孙子兵法》一句）", "校之以计" },
    { "全民皆兵（打《孙子兵法》一句）", "齐之以武" },
    { "男尊女卑（打《孙子兵法》一句）", "贵阳而贱阴" },
    { "祸及子孙（打《孙子兵法》一句）", "不能善其后" },
    { "周瑜死因（打《孙子兵法》一句）", "将不胜其忿" },
    { "青梅竹马（打《孙子兵法》一句）", "少而往来者" },
    { "破门而入（打《孙子兵法》一句）", "进而不可御者" },
    { "计划承包田（打《孙子兵法》一句）", "围地而谋" },
    { "见先进就学（打《孙子兵法》一句）", "良将随之" },
    { "用钱买官作（打《孙子兵法》一句）", "因利而制权也" },
    { "以柔克刚者胜（打《孙子兵法》一句）", "无勇功" },
    { "我自岿然不动（打《孙子兵法》一句）", "守则有余" },
    { "所来全不费工夫（打《孙子兵法》一句）", "不求而得" },
    { "独在异乡为异客（打《孙子兵法》一句）", "亲而离之" },
    { "在地愿为连理枝（打《孙子兵法》一句）", "故合之以交" },
    { "长剑在握镇东吴（打《孙子兵法》一句）", "因利而制权民" },
    { "智者千虑，必有一失（打《孙子兵法》一句）", "得算多也" },
    { "前不着村，后不着店（打《孙子兵法》一句）", "行无人之地也" },
    { "工（打《史记》一句）", "用力曰功" },
    { "故（打《史记》一句）", "不离古文者近者" },
    { "木乃伊（打《史记》一句）", "终不能化" },
    { "坚持到底（打《史记》一句）", "虽死不易" },
    { "偏听偏信（打《史记》一句）", "此与以耳食无异" },
    { "世界冠军（打《史记》一句）", "威震天下" },
    { "双兔傍地走（打《史记》一句）", "则雌雄之所，在未可知也" },
    { "死而轻于鸿毛（打《史记》一句）", "卒为天下笑" },
    { "三军过后尽开颜（打《史记》一句）", "卒相与欢" },
    { "万紫千红总是春（打《史记》一句）", "当时则荣" },
    { "不知木兰是女郎（打《史记》一句）", "阴阳有变" },
    { "口道恒河沙复沙（打《史记》一句）", "不可胜数" },
    { "留取丹心照汗青（打《史记》一句）", "烈士润名" },
    { "一索功高缚楚王（打《史记》一句）", "信而不疑" },
    { "二世朝廷扫地空（打《史记》一句）", "卒亡其国" },
    { "董卓鸩酒杀少帝（打《史记》一句）", "以臣弑君" },
    { "齐楚燕赵皆降服（打《史记》一句）", "四国顺之" },
    { "千金散尽还复来（打《史记》一句）", "用而不匮" },
    { "四知美誉留人世（打《史记》一句）", "其行廉" },
    { "哭声直上干云霄（打《史记》一句）", "楚人之多也" },
    { "大楼皆是鸳鸯楼（打《滕王阁序》一句）", "洪都新府" },
    { "山外青山楼外楼（打《滕王阁序》一句）", "层峦耸翠" },
    { "塞鸿何因又南飞（打《滕王阁序》一句）", "雁阵惊寒" },
    { "飞将军自重霄入（打《滕王阁序》一句）", "李广难封" },
    { "平原门下客三千（打《滕王阁序》一句）", "胜友如云" },
    { "坚决煞住吃喝风（打《滕王阁序》一句）", "盛筵难再" },
    { "身为王储哪得穷（打《滕王阁序》一句）", "君子安贫" },
    { "柳毅传书结连理（打《滕王阁序》一句）", "喜托龙门" },
    { "香凝最解稚儿心（打《滕王阁序》一句）", "童子何知" },
    { "帝子乘风下翠微（打《滕王阁序》一句）", "上出重霄" },
    { "洪湖歌声融暮色（打《滕王阁序》一句）", "渔舟唱晚" },
    { "班超不作抄书吏（打《滕王阁序》一句）", "有怀投笔" },
    { "回归洛阳（打《前出师表》一句）", "还于旧都" },
    { "明知故问（打《前出师表》一句）", "悉以咨之" },
    { "爱兵如子（打《前出师表》一句）", "将军向宠" },
    { "结合本人（打《前出师表》一句）", "俱为一体" },
    { "科举制度（打《前出师表》一句）", "试用于昔日" },
    { "鲁人经商（打《前出师表》一句）", "愚以为营中之事" },
    { "才不明主弃（打《前出师表》一句）", "亲贤臣" },
    { "人家在何处（打《前出师表》一句）", "不知所云" },
    { "可烧而走也（打《前出师表》一句）", "然后施行" },
    { "子路欲谢之（打《前出师表》一句）", "由是感激" },
    { "平蛮十八洞（打《前出师表》一句）", "今南方已定" },
    { "将言辞说上（打《前出师表》一句）", "欲报之于陛下" },
    { "夫妻量刑不同（打《前出师表》一句）", "使内外异法也" },
    { "抱千金而长叹（打《前出师表》一句）", "可计日而待也" },
    { "青梅竹马两无猜（打《前出师表》一句）", "亲小人" },
    { "有赚无赚饮淡薄（打《前出师表》一句）", "至于斟酌损益" },
    { "但愿一识韩荆州（打《前出师表》一句）", "不求闻达于诸侯" },
    { "梨桔柚各有其美（打《前出师表》一句）", "此皆良实" },
    { "好歹分到房一套（打《前出师表》一句）", "优劣得所也" },


}
local 题库4 = { --地名
    { "一起作东家（打北京一地名）", "同合庄" },
    { "钱多才可做东（打北京一地名）", "大有庄" },
    { "沫若乡间住处（打北京一地名）", "郭公庄" },
    { "掌声经久不息（打北京一地名）", "延庆" },
    { "庙建成菩萨到（打上海一地名）", "新寺" },
    { "光启族人大团圆（打上海一地名）", "徐家汇" },
    { "中国振兴更辉煌（打上海一地名）", "龙华" },
    { "金银铜铁珠翠钻（打上海一地名）", "七宝" },
    { "给爷爷让座位（打天津一地名）", "小站" },
    { "重点干起，秋前方成（打天津一地名）", "和平" },
    { "前藏安家，怡然开心（打天津一地名）", "芦台" },
    { "悔教夫婿觅封侯，只因陌头忽有见（打天津一地名）", "杨柳青" },
    { "朔方有石无土培（打重庆一地名）", "北碚" },
    { "从打工起，终于出头（打重庆一地名）", "巫山" },
    { "山水之间，一方独立（打重庆一地名）", "涪陵" },
    { "集资共建，大桥贯通（打重庆一地名）", "铜梁" },
    { "兵家必争之地（打香港一地名）", "旺角站" },
    { "超级骗子之言（打香港一地名）", "大坑道" },
    { "保卫珍宝岛之战（打香港一地名）", "北角" },
    { "欧洲敬献皇帝之物（打香港一地名）", "西贡" },
    { "固若金汤（打河北一地名）", "保定" },
    { "辣椒市场（打河北一地名）", "辛集" },
    { "中国界首（打河北一地名）", "玉田" },
    { "山呼万岁（打河北一地名）", "赞皇" },
    { "日照清流涌（打山西一地名）", "阳泉" },
    { "共同走江湖（打山西一地名）", "洪洞" },
    { "抵达分水处（打山西一地名）", "临汾" },
    { "静静的顿河（打山西一地名）", "文水" },
    { "为天下唱（打内蒙古一地名）", "呼和浩特" },
    { "冲着你打（打内蒙古一地名）", "和林格尔" },
    { "山花红烂漫（打内蒙古一地名）", "赤峰" },
    { "潘仁美卖国（打内蒙古一地名）", "通辽" },
    { "落红有主（打辽宁一地名）", "丹东" },
    { "何谓五岳（打辽宁一地名）", "盘山" },
    { "八一勋章（打辽宁一地名）", "彰武" },
    { "客人初至（打辽宁一地名）", "新宾" },
    { "促其反正（打吉林一地名）", "敦化" },
    { "泾渭不分（打吉林一地名）", "浑江" },
    { "雄踞山寨（打吉林一地名）", "公主岭" },
    { "双双无突破（打吉林一地名）", "四平" },
    { "贵在廉洁（打黑龙江一地名）", "宝清" },
    { "楚剧选段（打黑龙江一地名）", "林口" },
    { "又到鸡西市（打黑龙江一地名）", "双城" },
    { "千里来慰问（打黑龙江一地名）", "抚远" },
    { "安得后羿弓（打江苏一地名）", "射阳" },
    { "空付一书扎（打江苏一地名）", "高邮" },
    { "鬼脸儿善变    （打江苏一地名）", "兴化" },
    { "准点到西宁（打江苏一地名）", "淮安" },
    { "分床不分家（打浙江一地名）", "桐庐" },
    { "此日意无穷（打浙江一地名）", "富阳" },
    { "无一知其义也（打浙江一地名）", "文成" },
    { "无丝竹之乱耳（打浙江一地名）", "乐清" },
    { "人在楼头空伫立（打安徽一地名）", "休宁" },
    { "风物长宜放眼量（打安徽一地名）", "怀远" },
    { "上下四方无险情（打安徽一地名）", "六安" },
    { "介子推辞官退隐（打安徽一地名）", "潜山" },
    { "根治黄河（打福建一地名）", "清流" },
    { "神不在焉（打福建一地名）", "仙游" },
    { "晓以大义（打福建一地名）", "德化" },
    { "静观待变（打福建一地名）", "宁化" },
    { "战太平（打江西一地名）", "武宁" },
    { "鸿鸟飞（打江西一地名）", "余江" },
    { "下不为例（打江西一地名）", "上饶" },
    { "树叶落尽（打江西一地名）", "余干" },
    { "店主站柜台（打山东一地名）", "东营" },
    { "佳作已见报（打山东一地名）", "文登" },
    { "春光临渡口（打山东一地名）", "夏津" },
    { "美人锁铜雀（打山东一地名）", "鱼台" },
    { "千里相会见真心（打台湾一地名）", "三重" },
    { "华夏大地沧桑史（打台湾一地名）", "中坜" },
    { "刘关张结义遗址（打台湾一地名）", "桃园" },
    { "投身改革获褒奖（打台湾一地名）", "彰化" },
    { "金乌西坠白头看（打河南一地名）", "洛阳" },
    { "先收集然后整理（打河南一地名）", "焦作" },
    { "柳暗花明又一村（打河南一地名）", "新乡" },
    { "珍珠如土金如铁（打河南一地名）", "宝丰" },
    { "介胄之士（打湖北一地名）", "武汉" },
    { "公开赞助（打湖北一地名）", "襄阳" },
    { "正者日也（打湖北一地名）", "当阳" },
    { "年少无知（打湖北一地名）", "大悟" },
    { "主人无恙（打湖南一地名）", "东安" },
    { "红杏出墙（打湖南一地名）", "花垣" },
    { "刚刚平静（打湖南一地名）", "新宁" },
    { "安居故里（打湖南一地名）", "宁乡" },
    { "拨开云雾现红轮（打广东一地名）", "揭阳" },
    { "烟火灭后心安宁（打广东一地名）", "恩平" },
    { "桃李杏梅菊含笑（打广东一地名）", "五华" },
    { "湖中倒影水纵横（打广东一地名）", "潮州" },
    { "日照幽篁笼古刹（打广西一地名）", "天等" },
    { "春水纵横送我还（打广西一地名）", "梧州" },
    { "向阳坡上桃花艳（打广西一地名）", "南丹" },
    { "财源茂盛达三江（打广西一地名）", "富川" },
    { "皇后在京坐正宫（打海南一地名）", "琼中" },
    { "雄心纵横行无阻（打海南一地名）", "通什" },
    { "公私仓廪皆丰实（打海南一地名）", "屯昌" },
    { "子仪出征讨禄山（打海南一地名）", "定安" },
    { "北平解放之后（打四川一地名）", "成都" },
    { "刘邦登基诏书（打四川一地名）", "宣汉" },
    { "花和尚鲁智深（打四川一地名）", "色达" },
    { "南人不复反矣（打四川一地名）", "泸定" },
    { "三十六载共患难（打贵州一地名）", "桐梓" },
    { "那个愿臣虏自认（打贵州一地名）", "安顺" },
    { "田心一片磁针石（打贵州一地名）", "思南" },
    { "艳阳天却听雷声（打贵州一地名）", "晴隆" },
    { "惩恶扬善（打云南一地名）", "宜良" },
    { "依然故我（打云南一地名）", "个旧" },
    { "美哉嘉陵（打云南一地名）", "丽江" },
    { "全面整顿（打云南一地名）", "大理" },
    { "漩涡里的歌（打西藏一地名）", "曲水" },
    { "繁荣的北京（打西藏一地名）", "昌都" },
    { "飞花满四邻（打西藏一地名）", "谢通门" },
    { "长江后浪推前浪（打西藏一地名）", "波密" },
    { "一劳永逸（打陕西一地名）", "长安" },
    { "支出两分（打陕西一地名）", "岐山" },
    { "叔伯昆仲（打陕西一地名）", "咸阳" },
    { "为虎作伥（打陕西一地名）", "扶风" },
    { "发扬大协作精神（打青海一地名）", "互助" },
    { "一帆风顺无险阻（打青海一地名）", "平安" },
    { "人的品格最重要（打青海一地名）", "贵德" },
    { "千街万巷没堵塞（打青海一地名）", "大通" },
    { "蜜罐城（打宁夏一地名）", "甜水堡" },
    { "情投意合（打宁夏一地名）", "同心" },
    { "老少多病（打宁夏一地名）", "中宁" },
    { "聚气守精（打宁夏一地名）", "固原" },
    { "叶飘时零客人来（打新疆一地名）", "喀什" },
    { "加的结果乃能大（打新疆一地名）", "和硕" },
    { "芙蓉帐暖度春宵（打新疆一地名）", "温宿" },
    { "举起鞭儿又紧缰（打新疆一地名）", "策勒" },
}
local 题库5 = { --动植物日常用品迷
    { "耳朵长，尾巴短只吃菜，不吃饭（打一动物名）", "兔子" },
    { "粽子脸，梅花脚前面喊叫，后面舞刀（打一动物名）", "狗" },
    { "小姑娘，夜纳凉带灯笼，闪闪亮（打一动物名）", "萤火虫" },
    { "一支香，地里钻弯身走，不会断（打一动物名）", "蚯蚓" },
    { "一样物，花花绿扑下台，跳上屋（打一动物名）", "猫" },
    { "沟里走，沟里串背了针，忘了线（打一动物名）", "刺猬" },
    { "肥腿子，尖鼻子穿裙子，背屋子（打一动物名）", "鳖" },
    { "船板硬，船面高四把桨，慢慢摇（打一动物名）", "乌龟" },
    { "一把刀，顺水漂有眼睛，没眉毛（打一动物名）", "鱼" },
    { "一星星，一点点走大路，钻小洞（打一动物名）", "蚂蚁" },
    { "脚儿小，腿儿高戴红帽，穿白袍（打一动物名）", "丹顶鹤" },
    { "小小船，白布篷头也红，桨也红（打一动物名）", "鹅" },
    { "长胳膊，猴儿脸大森林里玩得欢摘野果，捣鹊蛋，抓住树枝荡秋千（打一动物名）",
        "长臂猿" },
    { "娘子娘子，身似盒子麒麟剪刀，八个钗子（打一动物名）", "蟹" },
    { "进洞像龙，出洞像凤凤生百子，百子成龙（打一动物名）", "蚕" },
    { "尖尖长嘴，细细小腿拖条大尾，疑神疑鬼（打一动物名）", "狐狸" },
    { "为你打我，为我打你打到你皮开，打得我出血（打一动物名）", "蚊子" },
    { "无脚也无手，身穿鸡皮皱谁若碰着它，吓得连忙走（打一动物名）", "蛇" },
    { "背板过海，满腹文章从无偷窃行为，为何贼名远扬？（打一动物名）", "乌贼" },
    { "日飞落树上，夜晚到庙堂不要看我小，有心肺肝肠（打一动物名）", "麻雀" },
    { "说马不像马，路上没有它若用它做药，要到海中抓（打一动物名）", "海马" },
    { "海上一只鸟，跟着船儿跑冲浪去抓鱼，不怕大风暴（打一动物名）", "海鸥" },
    { "小时像逗号，在水中玩耍长大跳得高，是捉虫冠军（打一动物名）", "青蛙" },
    { "白天一起玩，夜间一块眠到老不分散，人夸好姻缘（打一动物名）", "鸳鸯" },
    { "姑娘真辛苦，晚上还织布天色蒙蒙亮，机声才停住（打一动物名）", "纺织娘" },
    { "有位小姑娘，身穿黄衣裳谁要欺负她，她就戳一枪（打一动物名）", "黄蜂" },
    { "身小力不小，团结又勤劳有时搬粮食，有时挖地道（打一动物名）", "蚂蚁" },
    { "头顶两只角，身背一只镬只怕晒太阳，不怕大雨落（打一动物名）", "蜗牛" },
    { "你坐我不坐，我行你不行你睡躺得平，我睡站到明（打一动物名）", "马" },
    { "穿着大红袍，头戴铁甲帽叫叫我阿公，捉捉我不牢（打一动物名）", "蜈蚣" },
    { "沙漠一只船，船上载大山远看像笔架，近看一身毡（打一动物名）", "骆驼" },
    { "身穿绿色衫，头戴五花冠喝的清香酒，唱如李翠莲（打一动物名）", "蝈蝈" },
    { "头胖脚掌大，像个大傻瓜四肢短又粗，爱穿黑大褂（打一动物名）", "熊" },
    { "个儿高又大，脖子似吊塔和气又善良，从来不打架（打一动物名）", "长颈鹿" },
    { "鼻子像钩子，耳朵像扇子大腿像柱子，尾巴像鞭子（打一动物名）", "象" },
    { "远看像黄球，近看毛茸茸叽叽叽叽叫，最爱吃小虫（打一动物名）", "小鸡" },
    { "兄弟七八千，住在屋檐边日日做浆卖，浆汁更值钱（打一动物名）", "蜂" },
    { "皮白腰儿细，会爬又会飞木头当粮食，专把房屋毁（打一动物名）", "白蚁" },
    { "身上滑腻腻，喜欢钻河底张嘴吐泡泡，可以测天气（打一动物名）", "泥鳅" },
    { "长得像黄菊，引诱小鱼虾触手捕食物，舞爪又张牙（打一动物名）", "海葵" },
    { "像鱼不是鱼，终生住海里远看是喷泉，近看像岛屿（打一动物名）", "鲸" },
    { "两眼如灯盏，一尾如只钉半天云里过，湖面过光阴（打一动物名）", "蜻蜓" },
    { "黑脸包丞相，坐在大堂上扯起八卦旗，专拿飞天将（打一动物名）", "蜘蛛" },
    { "驼背老公公，胡子乱蓬蓬生前没有血，死后满身红（打一动物名）", "虾" },
    { "像猫不是猫，身穿皮袄花山中称霸王，寅年它当家（打一动物名）", "老虎" },
    { "身长约一丈，鼻生头顶上背黑肚皮白，安家在海洋（打一动物名）", "海豚" },
    { "远看像只猫，近看是只鸟晚上捉田鼠，天亮睡大觉（打一动物名）", "猫头鹰" },
    { "腿长胳膊短，眉毛遮住眼没人不吭声，有人它乱窜（打一动物名）", "蚂蚱" },
    { "头插花翎翅，身穿彩旗袍终日到处游，只知乐逍遥（打一动物名）", "蝴蝶" },
    { "身子轻如燕，飞在天地间不怕相隔远，也能把话传（打一动物名）", "信鸽" },
    { "脚着暖底靴，口边出胡须夜里当巡捕，日里把眼眯（打一动物名）", "猫" },
    { "头前两把刀，钻地害禾苗捕来烘成干，一味利尿药（打一动物名）", "蝼蛄" },
    { "四柱八栏杆，住着懒惰汉鼻子团团转，尾巴打个圈（打一动物名）", "猪" },
    { "生的是一碗，煮熟是一碗不吃是一碗，吃了也一碗（打一动物名）", "田螺" },
    { "头戴周瑜帽，身穿张飞袍自称孙伯符，脾气像马超（打一动物名）", "蟋蟀" },
    { "身穿绿衣裳，肩扛两把刀庄稼地里走，害虫吓得跑（打一动物名）", "螳螂" },
    { "叫猫不抓鼠，像熊爱吃竹摇摆惹人爱，是猫还是熊？（打一动物名）", "熊猫" },
    { "播种（打一动物名）", "布谷" },
    { "多兄长（打一动物名）", "八哥" },
    { "屡试屡成（打一动物名）", "百灵" },
    { "轻描柳叶（打一动物名）", "画眉" },
    { "华而不实（打一植物名）", "无花果" },
    { "红娘子，上高楼心里疼，眼泪流    （打一日常用品）", "蜡烛" },
    { "一棵麻，多枝丫雨一淋，就开花（打一日常用品）", "雨伞" },
    { "小小狗，手里走走一走，咬一口（打一日常用品）", "剪刀" },
    { "一只罐，两个口只装火，不装酒（打一日常用品）", "灯笼" },
    { "左手五个，右手五个拿去十个，还剩十个（打一日常用品）", "手套" },
    { "有硬有软，有长有宽白天空闲，夜晚上班（打一日常用品）", "床" },
    { "生在山崖，落在人家凉水浇背，千刀万剐（打一日常用品）", "磨刀石" },
    { "一物三口，有腿无手谁要没它，难见亲友（打一日常用品）", "裤子" },
    { "又白又软，罩住人脸守住关口，防止传染（打一日常用品）", "口罩" },
    { "头大尾细，全身生疥拿起索子，跟你讲价（打一日常用品）", "秤" },
    { "平日不思，中秋想你有方有圆，又甜又蜜（打一日常用品）", "月饼" },
    { "一只黑狗，两头开口一头咬煤，一头咬手（打一日常用品）", "火钳" },
    { "外麻里光，住在闺房姑娘怕戳疼，拿它来抵挡（打一日常用品）", "顶针" },
    { "口比肚子大，给啥就吃啥它吃为了你，你吃端着它（打一日常用品）", "碗" },
    { "猛将百余人，无事不出城出城就放火，引火自烧身（打一日常用品）", "火柴" },
    { "有头没有尾，有角又有嘴扭动它的角，嘴里直淌水（打一日常用品）", "水龙头" },
    { "一群黄鸡娘，生蛋进船舱烤后一声响，个个大过娘（打一日常用品）", "爆米花" },
    { "一只黑鞋子，黑帮黑底子挂破鞋子口，漏出白衬子（打一日常用品）", "西瓜子" },
    { "身穿红衣裳，常年把哨放，遇到紧急事，敢往火里闯（打一日常用品）", "灭火器" },
    { "前面来只船，舵手在上边来时下小雨，走后路已干（打一日常用品）", "熨斗" },
    { "一只没脚鸡，立着从不啼吃水不吃米，客来敬个礼（打一日常用品）", "茶壶" },
    { "中间是火山，四边是大海海里宝贝多，快快捞上来（打一日常用品）", "火锅" },
    { "楼台接楼台，层层叠起来上面飘白雾，下面水花开（打一日常用品）", "蒸笼" },
    { "一队胡子兵，当了牙医生早晚来巡逻，打扫真干净（打一日常用品）", "牙刷" },
    { "半个西瓜样，口朝上面搁上头不怕水，下头不怕火（打一日常用品）", "锅" },
    { "生在鸡家湾，嫁到竹家滩向来爱干净，常逛灰家山（打一日常用品）", "鸡毛掸子" },
    { "站着百分高，躺着十寸长裁衣做数学，它会帮你忙（打一日常用品）", "尺" },
    { "一只八宝袋，样样都能装能装棉和纱，能装铁和钢（打一日常用品）", "针线包" },
    { "一藤连万家，家家挂只瓜瓜儿长不大，夜夜会开花（打一日常用品）", "电灯" },
    { "你打我不恼，背后有人挑心中亮堂堂，指明路一条（打一日常用品）", "灯笼" },
    { "生来青又黄，好比水一样把它倒水里，它能浮水上（打一日常用品）", "油" },
    { "一颗小红枣，一屋盛不了只要一开门，枣儿往外跑（打一日常用品）", "油灯" },
    { "远看两个零，近看两个零有人用了行不得，有人不用不得行（打一日常用品）", "眼镜" },
    { "对着你的脸，按住你的心请你通知主人翁，快快开门接客人（打一日常用品）", "门铃" },


}
local 题库6 = { --中草药迷
    { "金钿遍野（打一中草药名）", "地黄" },
    { "三九时节（打一中草药名）", "天冬" },
    { "难以称呼（打一中草药名）", "无名子" },
    { "返老还童（打一中草药名）", "老来少" },
    { "三省吾身（打一中草药名）", "防己" },
    { "造极摩天（打一中草药名）", "千层塔" },
    { "天女散花（打一中草药名）", "降香" },
    { "人间四月芳菲尽（打一中草药名）", "春不见" },
    { "大开绿灯（打一中草药名）", "路路通" },
    { "道旁栽草（打一中草药名）", "路边青" },
    { "古城姐妹（打一中草药名）", "金银花" },
    { "海棠春睡（打一中草药名）", "安息香" },
    { "久别重逢（打一中草药名）", "一见喜" },
    { "儿行母忧（打一中草药名）", "相思子" },
    { "快快松绑（打一中草药名）", "急解索" },
    { "雷电之后（打一中草药名）", "阴阳水" },
    { "两个少女（打一中草药名）", "二妙散" },
    { "恍然大悟（打一中草药名）", "脑立清" },
    { "香山秋艳（打一中草药名）", "一片丹" },
    { "老蚌生珠（打一中草药名）", "附子" },
    { "老谋深算（打一中草药名）", "苍术" },
    { "岭上开花（打一中草药名）", "山香" },
    { "不欢而去（打一中草药名）", "失笑散" },
    { "重新制作（打一中草药名）", "再造丸" },
    { "红十字会（打一中草药名）", "九一丹" },
    { "分兵出发（打一中草药名）", "行军散" },
    { "威风扫地（打一中草药名）", "虎力散" },
    { "敲山震虎（打一中草药名）", "驱风散" },
    { "鲛人挥泪（打一中草药名）", "珍珠散" },
    { "峨嵋第一峰（打一中草药名）", "川山甲" },
    { "儿童节放假（打一中草药名）", "六一散" },
    { "他乡遇故知（打一中草药名）", "一见喜" },
    { "春游芳草地（打一中草药名）", "步步清" },
    { "十人九死焉（打一中草药名）", "独活" },
    { "不生第二胎（打一中草药名）", "杜仲" },
    { "低头思故乡（打一中草药名）", "怀熟地" },
    { "妇女节前夕（打一中草药名）", "三七" },
    { "决心扎根边疆（打一中草药名）", "远志" },
    { "第四季度经费（打一中草药名）", "款冬花" },
    { "春前秋后正寒时（打一中草药名）", "天冬" },
    { "一江春水向东流（打一中草药名）", "通大海" },
    { "严寒时节郁葱葱（打一中草药名）", "冬青" },
    { "踏花归来蝶绕膝（打一中草药名）", "香附" },
    { "两横一竖打一字（打一中草药名）", "射干" },
    { "两字相乘二十一（打一中草药名）", "三七" },
    { "莫让年华付水流（打一中草药名）", "青春宝" },
    { "防暑降温见成效（打一中草药名）", "抗炎灵" },
    { "万象更新百花红（打一中草药名）", "回春丹" },
    { "难过皆因负担重（打一中草药名）", "薄荷通" },
    { "梅须自逊三分白（打一中草药名）", "雪里开" },
    { "虚有其表要不得（打一中草药名）", "云实" },
    { "猜谜更使人生慧（打一中草药名）", "益智" },
    { "湖光水影接秋色（打一中草药名）", "胡黄连" },
    { "寒凝大地发春华（打一中草药名）", "冰凉花" },
    { "窗前江水泛春色（打一中草药名）", "空青" },
    { "零落成泥碾作尘（打一中草药名）", "沉香粉" },
    { "子规啼尽杜鹃红（打一中草药名）", "血竭花" },





}

local function 取灯谜()
    local jj = math.random(120)
    if jj <= 20 then
        return 题库[math.random(#题库)]
    elseif jj <= 40 then
        return 题库2[math.random(#题库2)]
    elseif jj <= 60 then
        return 题库3[math.random(#题库3)]
    elseif jj <= 80 then
        return 题库4[math.random(#题库4)]
    elseif jj <= 100 then
        return 题库5[math.random(#题库5)]
    else
        return 题库6[math.random(#题库6)]
    end
    return 题库6[math.random(#题库6)]
end

function NPC:NPC对话(玩家)
    if 玩家:判断等级是否低于2(80, 0) then
        return 对话
    end


    -- if 玩家:取活动限制次数('猜灯谜') >= 30 then
    --     return 对话
    -- end


    local t = 取灯谜()
    if t then
       -- 玩家:增加活动限制次数('猜灯谜')
        local r = 玩家:灯谜窗口(t[1])
        if r then

            if r == t[2] then --正确

                return 真确对话

            else --错误

                return 错误对话
            end
        end
    end



    -- return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
