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
sig ディプロマポリシー{
}

sig カリキュラム{
	年度 : 年度,
	対象学科 : 学部学科,
	DP : ディプロマポリシー,
}

sig 学則{
	含まれる : カリキュラム,
	科目 : 科目,
	単位 : Int,
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
	CAP制限対象 : Bool,
	適用要件 : lone 要件,
	強制 : Bool,
}{
	nonneg[単位]
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
	nonneg[判定順]
}
sig 判定条件{
	属する: 要件判定,
	単位数下限: Int,
	必修単位数下限: Int,
	必修科目数下限: Int,
	必修完了: Bool,
	在籍年数超過: Bool,
}{
	nonneg[単位数下限]
	nonneg[必修単位数下限]
	nonneg[必修科目数下限]
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
pred 複数のカリキュラムを定義できる{
	#カリキュラム > 1
}
run 複数のカリキュラムを定義できる

pred 同じ学部学科に対して複数のカリキュラムを定義できる{
	some disj c,c': カリキュラム |
		c.対象学科 = c'.対象学科
}
run 同じ学部学科に対して複数のカリキュラムを定義できる

pred 同一ディプロマポリシーの相異なるカリキュラムが存在できる{
	some disj c,c': カリキュラム |
		c.DP = c'.DP
}
run 同一ディプロマポリシーの相異なるカリキュラムが存在できる

pred 卒業要件を定義できる{
	some 卒業要件
}
run 卒業要件を定義できる

pred 卒業要件の判定条件を定義できる{
	some j: 要件判定 | some r: 卒業要件 |
		r in 判定対象要件[j]
}
run 卒業要件の判定条件を定義できる

pred 卒業要件に対して処理を定義できる{
	some a: 判定後処理 |
		some (判定対象要件[a.属する] & 卒業要件)
}
run 卒業要件に対して処理を定義できる

pred 教職要件を定義できる{
	some 教職要件
}
run 教職要件を定義できる

pred 教職要件の判定条件を定義できる{
	some j: 要件判定 | some r: 教職要件 |
		r in 判定対象要件[j]
}
run 教職要件の判定条件を定義できる

pred 教職要件に対して処理を定義できる{
	some a: 判定後処理 |
		some (判定対象要件[a.属する] & 教職要件)
}
run 教職要件に対して処理を定義できる

pred その他の資格要件を定義できる{
	some (資格要件 - 教職要件)
}
run その他の資格要件を定義できる

pred その他の資格要件の判定条件を定義できる{
	some j: 要件判定 | some r: (資格要件 - 教職要件) |
		r in 判定対象要件[j]
}
run その他の資格要件の判定条件を定義できる

pred その他の資格要件に対して処理を定義できる{
	some a: 判定後処理 |
		some (判定対象要件[a.属する] & (資格要件 - 教職要件))
}
run その他の資格要件に対して処理を定義できる

pred カリキュラム毎に要件判定を定義できる{
	some disj j,j': 要件判定 |
		j.適用 != j'.適用
}
run カリキュラム毎に要件判定を定義できる

pred 要件判定を学年ごとに定義できる{
	some disj j,j': 要件判定 |
		j.年次 != j'.年次
}
run 要件判定を学年ごとに定義できる

pred 要件判定を学部学科ごとに定義できる{
	some disj j,j': 要件判定 |
		j.学科 != j'.学科
}
run 要件判定を学部学科ごとに定義できる

pred 要件の判定処理の順序を指定できる{
	some disj j,j': 要件判定 |
		j.判定順 != j'.判定順
}
run 要件の判定処理の順序を指定できる

pred 卒業進級要件の判定処理で進級できる{
	some j: 要件判定 |
		卒業要件に対する判定[j] and 進級 in 後処理[j]
}
run 卒業進級要件の判定処理で進級できる

pred 卒業進級要件の判定処理で卒業できる{
	some j: 要件判定 |
		卒業要件に対する判定[j] and 卒業 in 後処理[j]
}
run 卒業進級要件の判定処理で卒業できる

pred 卒業進級要件の判定処理で卒業研究の受講制限ができる{
	some j: 要件判定 |
		卒業要件に対する判定[j] and 卒研受講制限 in 後処理[j]
}
run 卒業進級要件の判定処理で卒業研究の受講制限ができる

pred 卒業進級要件の判定処理で退学ができる{
	some j: 要件判定 |
		卒業要件に対する判定[j] and 退学 in 後処理[j]
}
run 卒業進級要件の判定処理で退学ができる

pred 配当学年の範囲指定ができる{
	some r: 学則 |
		#r.配当学年 > 1
}
run 配当学年の範囲指定ができる

pred 学則に強制履修を設定できる{
	some r: 学則 |
		r.強制 in True
}
run 学則に強制履修を設定できる

pred 学則に科目専門区分を定義できる{
	some r: 学則 |
		some r.科目専門区分
}
run 学則に科目専門区分を定義できる

pred 学則に分類を定義できる{
	some r: 学則 |
		some r.分類
}
run 学則に分類を定義できる

pred 学則に分野を定義できる{
	some r: 学則 |
		some r.分野
}
run 学則に分野を定義できる

pred 学則にグループを定義できる{
	some r: 学則 |
		some r.グループ
}
run 学則にグループを定義できる

```

```alloy
fun 修得可能科目(c: カリキュラム) : set Base/科目{
	c.~含まれる.科目
}

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