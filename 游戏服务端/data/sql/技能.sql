CREATE TABLE "技能" (
    "nid" text NOT NULL,
    "rid" INTEGER,
    "名称" TEXT,
    "熟练度" integer,
    "数据" blob,
    PRIMARY KEY ("nid")
);
CREATE UNIQUE INDEX "_技能nid" ON "技能" ("nid" ASC);
CREATE INDEX "_技能rid" ON "技能" ("rid" ASC);