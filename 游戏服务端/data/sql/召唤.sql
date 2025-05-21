CREATE TABLE "召唤" (
    "nid" text NOT NULL,
    "rid" integer,
    "外形" integer,
    "原形" integer,
    "原名" text,
    "等级" integer DEFAULT 0,
    "获得时间" integer,
    "丢弃时间" integer DEFAULT 0,
    "数据" blob,
    PRIMARY KEY ("nid")
);
CREATE UNIQUE INDEX "_召唤nid" ON "召唤" ("nid" ASC);
CREATE INDEX "_召唤rid" ON "召唤" ("rid" ASC);