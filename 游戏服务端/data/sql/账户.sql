CREATE TABLE "账户" (
    "id" integer PRIMARY KEY AUTOINCREMENT NOT NULL,
    "IP" text DEFAULT '',
    "状态" integer DEFAULT 0,
    "时间" integer NOT NULL,
    "账号" text NOT NULL DEFAULT '',
    "密码" text NOT NULL DEFAULT '',
    "安全" text NOT NULL DEFAULT '',
    "QQ" text NOT NULL DEFAULT '',
    "体验" text NOT NULL DEFAULT '',
    "首充" text NOT NULL DEFAULT '',
    "点数" INTEGER DEFAULT 0,
    "管理" INTEGER DEFAULT 5,
    "封禁" INTEGER DEFAULT 0,
    "累充" INTEGER DEFAULT 0,
    "仙玉" INTEGER DEFAULT 999999999
);
CREATE UNIQUE INDEX "_账户账号" ON "账户" ("账号" ASC);