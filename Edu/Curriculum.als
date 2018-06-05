---
title: Curriculum
layout: default
---

```alloy
private open Base
private open Department

open EvalMethod
open Requirement as R
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

```alloy
sig 要件判定{
	適用: カリキュラム,
	学科: 学科,
	年次: 年次,
	GPA下限: GPA値,
	判定順: Int,
}{
	判定順 >= 0
}
sig 判定条件{
	属する: 要件判定,
	単位数下限: 単位数,
	必修単位数下限: 単位数,
	必修科目数下限: 科目数,
	必修完了: フラグ,
	在籍年数超過: フラグ,
}
sig 判定条件科目専門区分{
	属する: 判定条件,
	対象要件: 要件,
	対象区分 : 科目専門区分,
}
sig 判定後処理{
	属する: 要件判定,
	実行する: 処理,
}
```

```alloy
fact カリキュラム内の学則で同一科目で評価基準が異なってはならない{
	all c:カリキュラム | all disj r,r':c.~含まれる |
		r.科目 = r'.科目 => r.評価基準.取り得る評価 = r'.評価基準.取り得る評価
}
```

```alloy
fun 判定対象要件(j: 要件判定) : set R/要件{
	j.~属する.~属する.対象要件
}

fun 後処理(j: 要件判定) : set 処理{
	j.~属する.実行する
}
```

```alloy
pred 卒業要件に対する判定(j: 要件判定){
	判定対象要件[j] in 卒業要件
}
```
