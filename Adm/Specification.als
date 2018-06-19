---
title: Specification
layout: default
---

```alloy
private open Admission
private open Applicant
```

```alloy
-- Admission
check 入試に紐付かない入試募集は存在しない
check 入試募集は複数の入試に共有されることはない
check 試験会場がない入試募集はない
run 学部学科は複数の入試で募集することができる
run 学部学科ごとに入試募集できる
run 入試募集ごとに試験会場を指定できる
run 入試募集ごとに評価基準を定めることができる
run 編入学のための入試ができる
run 同一科目を異なる入試募集の評価項目にできる

-- Applicant
check 志願者に紐付かない出願は存在しない
check 出願詳細のない出願は存在しない
check 出願詳細が共有されることはない
run 志願者は複数の出願ができる
run 志願者はひとつの出願で複数の入試募集に同時併願できる
run 同じ入試に複数の出願ができる
run 同じ受験番号の成績でも募集ごとに評価が異なる

```

