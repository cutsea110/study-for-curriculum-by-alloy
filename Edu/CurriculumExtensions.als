---
title: CurriculumExtensions
layout: default
---

```alloy
private open Base
private open Curriculum
private open Student
private open Timetable as T
```

```alloy
sig 振替科目{
	対象: 学生,
	元科目: 科目,
	先科目: 科目,	
}{
	元科目 != 先科目
}

abstract sig 履修前提科目{
	適用 : カリキュラム,
	対象 : 科目,
	前提 : 科目,
	種別 : 前提種別,
}{
	対象 != 前提
	(対象 + 前提) in 適用.~含まれる.科目
}

sig 事前修得前提科目 extends 履修前提科目{
}{
	種別 in 修得前提
}
sig 事前履修前提科目 extends 履修前提科目{
}{
	種別 in 履修前提
}

sig 修得単位数制限{
	年度 : 年度,
	期 : 期,
	学科 : 学科,
	学年 : 年次,
	GPA上限 : GPA値,
	GPA下限 : GPA値,
	単位数上限 : Int,
}{
	nonneg[単位数上限]
}

sig 科目セット{
	適用 : カリキュラム,
	科目群 : some 科目,
}{
	科目群 in 修得可能科目[適用]
}
```

```alloy
fact 同じ振替元の振替は持てない{
	all disj c,c': 振替科目 |
		c.対象 = c'.対象 => c.元科目 != c'.元科目
}

fact 振替先は適用カリキュラム内にある{
	all c: 振替科目 | c.先科目 in c.対象.適用.~含まれる.科目  
}
```

```alloy
pred 事前修得前提科目を設定できる{
	some 事前修得前提科目
}
run 事前修得前提科目を設定できる

pred 事前履修前提科目を設定できる{
	some 事前履修前提科目
}
run 事前履修前提科目を設定できる

pred 修得単位数制限を定義できる{
	some 修得単位数制限
}
run 修得単位数制限を定義できる

pred 年度ごとに修得単位数制限を定義できる{
	some x: 修得単位数制限 |
		some x.年度
}
run 年度ごとに修得単位数制限を定義できる

pred 学科ごとに修得単位数制限を定義できる{
	some x: 修得単位数制限 |
			some x.学科
}
run 学科ごとに修得単位数制限を定義できる

pred 年次ごとに修得単位数制限を定義できる{
	some x: 修得単位数制限 |
		some x.学年
}
run 年次ごとに修得単位数制限を定義できる

pred 半期ごとに修得単位数制限を定義できる{
	some x: 修得単位数制限 |
		x.期 in (前期 + 後期)
}
run 半期ごとに修得単位数制限を定義できる

pred 通期に修得単位数制限を定義できる{
	some x: 修得単位数制限 |
		x.期 in 通期
}
run 通期に修得単位数制限を定義できる

pred GPA範囲ごとに修得単位数制限を定義できる{
	some x: 修得単位数制限 |
		some x.GPA下限 and some x.GPA上限
}
run GPA範囲ごとに修得単位数制限を定義できる

pred 同時履修させる科目セットを定義できる{
	some s: 科目セット |
		#s.科目群 > 1
}
run 同時履修させる科目セットを定義できる

pred 同じカリキュラム内で交わりのある複数の科目セットが作れる{
	some disj s,s': 科目セット |
		s.適用 = s'.適用 and some (s.科目群 & s'.科目群)
}
run 同じカリキュラム内で交わりのある複数の科目セットが作れる

pred 同じカリキュラム内で交わりのない複数の科目セットが作れる{
	some disj s,s': 科目セット |
		s.適用 = s'.適用 and no (s.科目群 & s'.科目群)
}
run 同じカリキュラム内で交わりのない複数の科目セットが作れる

```


```alloy

fun 振替履修可能科目(s: 学生) : set Base/科目{
	s.~(振替科目 <: 対象).元科目
}

fun 全履修可能科目(s: 学生) : set Base/科目{
	基本履修可能科目[s] + 振替履修可能科目[s]
}

fun 全履修可能時間割(s: 学生) : set T/時間割{
	全履修可能科目[s].~科目.~授業
}

```
