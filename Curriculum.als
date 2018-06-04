---
title: Curriculum
layout: default
---

```alloy
private open Base
private open Department

open EvalMethod
open Requirement
```

```alloy
sig カリキュラム{
	年度 : 年度,
	対象学科 : 学部学科,
}

sig 学則{
	含まれる : カリキュラム,
	科目 : 科目,
	単位 : 単位数,
	評価基準 : 評価基準,
	-- 科目専門区分-分類-分野 の階層構造を想定
	-- ただし現状一切の制約は存在しない
	-- 科目専門区分は適用要件と合わせて要件の判定条件の対象を絞り込むのに利用される
	-- グループは階層関係なく使用することを想定
	科目専門区分 : 科目専門区分,
	分類 : 分類,
	分野 : 分野,
	グループ : グループ,
	配当学年 : set 年次,
	必修選択 : 必修選択区分,
	CAP制限対象 : フラグ,
	適用要件 : lone 要件,
	強制 : フラグ,
}

sig 正規カリキュラム extends カリキュラム{
}{
	卒業要件 in this.~含まれる.適用要件
}
```
