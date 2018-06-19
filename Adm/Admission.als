---
title: Admission
layout: default
---

```alloy
private open Base
private open Department

private open util/time
```

```alloy
enum 検査方法 { 学力, 調査書, 小論文, 面接, 実技 }

abstract sig 試験源{
}
one sig 内部試験 extends 試験源{
}
sig 評定平均 extends 試験源{
}
sig 外部試験 extends 試験源{
}
sig 大学入試センター試験科目 extends 外部試験{
}
one sig TOEIC extends 外部試験{
}

sig 入学方式{
}
sig 入学経路{
}
sig 試験会場{
}
```

```alloy
sig 入試{
	年度 : 年度,
	期 : 入学期,
	入学学年 : 年次,
	方式 : 入学方式,
	経路 : 入学経路,

	募集 : set 入試募集,
}{
	募集.~@募集 in this
}

sig 入試募集{
	募集学科 : 学部学科,
	募集定員 : Int,

	評価基準 : set 評価項目,
	会場 : some 試験会場,
}{
	some this.~募集
	評価基準.~@評価基準 in this
	募集定員 >= 0
}

sig 評価項目{
	科目 : 科目,

	検査方法 : 検査方法,
	試験源 : 試験源,

	-- TODO: 評価換算関数とかグループ化とか
}
```

```alloy
fact 入試募集は同一科目の評価項目を複数持ってはならない{
	no r: 入試募集 |
		some disj x,x': r.評価基準 |
			x.科目 = x'.科目
}
```

```alloy
assert 入試に紐付かない入試募集は存在しない{
	no r: 入試募集 |
		no r.~募集
}
check 入試に紐付かない入試募集は存在しない

assert 入試募集は複数の入試に共有されることはない{
	no r: 入試募集 |
		some disj a,a': 入試 |
			r in a.募集 and r in a'.募集
}
check 入試募集は複数の入試に共有されることはない

assert 試験会場がない入試募集はない{
	no r: 入試募集 |
		no r.会場
}
check 試験会場がない入試募集はない
```

```alloy
pred 学部学科は複数の入試で募集することができる{
	some g: 学部学科, y: Base/年度, t: 入学期 |
		#{a: 入試 | g in a.募集.募集学科 and a.年度 = y and a.期 = t} > 1
}
run 学部学科は複数の入試で募集することができる

pred 学部学科ごとに入試募集できる{
	some r,r': 入試募集 |
		同一年度期である[r.~募集, r'.~募集] and
		r.募集学科 != r'.募集学科
}
run 学部学科ごとに入試募集できる

pred 入試募集ごとに試験会場を指定できる{
	some r,r': 入試募集 |
		同一年度期である[r.~募集, r'.~募集] and
		r.会場 != r'.会場
}
run 入試募集ごとに試験会場を指定できる

pred 入試募集ごとに評価基準を定めることができる{
	some r,r': 入試募集 |
		同一年度期である[r.~募集, r'.~募集] and
		r.評価基準 != r'.評価基準
}
run 入試募集ごとに評価基準を定めることができる

pred 編入学のための入試ができる{
	some a: 入試 |
		a.入学学年 in 年次 - (零年次 + 一年次)
}
run 編入学のための入試ができる

pred 同一科目を異なる入試募集の評価項目にできる{
	some s: Base/科目 |
		some disj r,r': 入試募集 |
			s in r.評価基準.科目 and s in r'.評価基準.科目
}
run 同一科目を異なる入試募集の評価項目にできる

pred 外部試験を評価項目にできる{
	some x: 評価項目 |
		x.試験源 in 外部試験
}
run 外部試験を評価項目にできる

pred 大学入試センター試験科目を評価項目にできる{
	some x: 評価項目 |
		x.試験源 in 大学入試センター試験科目
}
run 大学入試センター試験科目を評価項目にできる
```

```alloy
pred 同一入試の募集である(r,r': 入試募集){
	r.~募集 = r'.~募集
}
pred 同一年度期である(a,a': 入試){
	a.年度 = a'.年度 and a.期 = a'.期
}
```
