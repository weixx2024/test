CREATE TABLE "孩子" (
    "nid" text NOT NULL,
    "rid" integer,
    "外形" integer,
    "原形" integer,
    "原名" text,
    "评价" integer,
    "获得时间" integer,
    "数据" blob,
    PRIMARY KEY ("nid")
);
CREATE UNIQUE INDEX "_孩子nid" ON "孩子" ("nid" ASC);
CREATE INDEX "_孩子rid" ON "孩子" ("rid" ASC);