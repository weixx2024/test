CREATE TABLE "法宝" (
    "nid" text NOT NULL,
    "rid" integer,
    "名称" text,
    "阴阳" integer DEFAULT 0,
    "等级" integer DEFAULT 0,
    "灵气" integer DEFAULT 0,
    "最大灵气" integer DEFAULT 0,
    "道行" integer DEFAULT 0,
    "升级道行" integer DEFAULT 0,
    "佩戴" integer DEFAULT 0,
    "获得时间" integer,
    "丢弃时间" integer DEFAULT 0,
    "数据" blob,
    PRIMARY KEY ("nid")
);
CREATE UNIQUE INDEX "_法宝nid" ON "法宝" ("nid" ASC);
CREATE INDEX "_法宝rid" ON "法宝" ("rid" ASC);