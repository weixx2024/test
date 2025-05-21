CREATE TABLE "帮派" (
    "nid" text NOT NULL,
    "名称" TEXT,
    "帮主" TEXT,
    "等级" integer DEFAULT 1,
    "数据" blob,
    PRIMARY KEY ("nid")
);

