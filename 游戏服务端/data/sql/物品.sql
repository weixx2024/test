CREATE TABLE "物品" (
    "nid" text NOT NULL,
    "rid" integer,
    "名称" text,
    "数量" integer DEFAULT 1,
    "获得时间" integer DEFAULT 0,
    "丢弃时间" integer DEFAULT 0,
    "位置" integer,
    "数据" blob,
    PRIMARY KEY ("nid")
);
CREATE UNIQUE INDEX "_物品nid" ON "物品" ("nid" ASC);
CREATE INDEX "_物品rid" ON "物品" ("rid" ASC);