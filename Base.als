---
title: Base
layout: default
---

```alloy
enum 曜日時限 { 日１, 日２, 日３, 日４, 日５, 日６, 日７, 日８,
								月１, 月２, 月３, 月４, 月５, 月６, 月７, 月８,
								火１, 火２, 火３, 火４, 火５, 火６, 火７, 火８,
								水１, 水２, 水３, 水４, 水５, 水６, 水７, 水８,
								木１, 木２, 木３, 木４, 木５, 木６, 木７, 木８,
								金１, 金２, 金３, 金４, 金５, 金６, 金７, 金８,
								土１, 土２, 土３, 土４, 土５, 土６, 土７, 土８,
								集中
							}
enum 期 { 前期, 後期, 通期 }
enum 出欠状態 { 出席, 欠席, 未判定 }
enum 必修選択区分 { 必修, 選択 }
enum 週間隔 { 毎週, 隔週1, 隔週2 }
enum フラグ { On, Off }
enum 試験区分 { 通常, 追試, 再試 }
enum 試験時期 { 前期中間, 前期末, 後期中間, 後期末 }
enum 処理 { 何もしない, 進級, 卒業, 卒研受講制限, 退学 }
enum 年次 { 零年次, 一年次, 二年次, 三年次, 四年次 }
enum 評価コード { S, A, B, C, D, F, N }
enum GPA値 { GPA_0, GPA_1, GPA_2, GPA_3, GPA_4 }
enum 前提種別 { 修得前提, 履修前提 }
enum 履修申請状態 { 下書き, 申請中, 完了 }
enum 履修申請結果 { 確定, 抽選で確定, 取消, 申請の取消, 抽選漏れ }
```

```alloy
sig 年度{
}

sig 学部{
}
sig 課程{
}
sig 学科{
}
sig コース{
}

sig 分類{
}
sig 分野{
}
sig グループ{
}
sig 科目専門区分{
}

sig 単位数{
}
sig 科目数{
}
sig 授業回{
}
```
