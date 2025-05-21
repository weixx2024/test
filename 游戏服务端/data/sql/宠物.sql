CREATE TABLE "宠物" (
    "nid" text NOT NULL,
    "rid" integer,
    "外形" integer DEFAULT 4001,
    "名称" text DEFAULT '',
    "等级" integer DEFAULT 0,
    "耐力" integer DEFAULT 0,
    "最大耐力" integer DEFAULT 0,
    "经验" integer DEFAULT 0,
    "最大经验" integer DEFAULT 0,
    "数据" blob,
    PRIMARY KEY ("nid")
);
CREATE UNIQUE INDEX "_宠物nid" ON "宠物" ("nid" ASC);
CREATE INDEX "_宠物rid" ON "宠物" ("rid" ASC);