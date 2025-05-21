CREATE TABLE "坐骑" (
    "nid" text NOT NULL,
    "rid" INTEGER,
    "名称" TEXT,
    "几座" INTEGER,
    "等级" INTEGER,
    "获得时间" integer,
    "数据" blob,
    PRIMARY KEY ("nid")
);
CREATE UNIQUE INDEX "_坐骑nid" ON "坐骑" ("nid" ASC);
CREATE INDEX "_坐骑rid" ON "坐骑" ("rid" ASC);