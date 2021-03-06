---
title: Specification
---

# 基本モデル設計および仕様に対する正当性検証

入試システムのモデルについての基本設計を行い,そのモデルの仕様に対する正当性を検証する.
仕様の形式的な意味については各依存モデルの詳細を参照のこと.

## 依存モデル

```alloy
private open Admission
private open Applicant
```

## 仕様一覧

入試および入試募集、評価項目など仕様は以下の通り.


```alloy
check 入試に紐付かない入試募集は存在しない
check 入試募集は複数の入試に共有されることはない
check 試験会場がない入試募集はない
run 学部学科は複数の入試で募集することができる
run 学部学科ごとに入試募集できる
run 入試募集ごとに試験会場を指定できる
run 入試募集ごとに評価基準を定めることができる
run 編入学のための入試ができる
run 同一科目を異なる入試募集の評価項目にできる
run 外部試験を評価項目にできる
run 大学入試センター試験科目を評価項目にできる
```

志願者および出願に関する仕様は以下の通り.

```alloy
check 志願者に紐付かない出願は存在しない
check 出願詳細のない出願は存在しない
check 出願詳細が共有されることはない
run 志願者は複数の出願ができる
run 志願者はひとつの出願で複数の入試募集に同時併願できる
run 同じ入試に複数の出願ができる
run 同じ受験番号の成績でも募集ごとに評価が異なる
run 受験番号ごとに出席を取れる
run 受験科目ごとに出席を取れる
run 志願者は複数の学部学科に合格できる
run 志願者を入学手続き完了にできる

```
