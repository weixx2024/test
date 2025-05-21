CREATE TABLE "任务" (
    "nid" text NOT NULL,
    "rid" integer,
    "名称" text,
    "获得时间" integer,
    "数据" blob,
    PRIMARY KEY ("nid")
);
CREATE UNIQUE INDEX "_任务nid" ON "任务" ("nid" ASC);
CREATE INDEX "_任务rid" ON "任务" ("rid" ASC);