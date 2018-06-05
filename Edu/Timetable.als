---
title: Timetable
layout: default
---

```alloy
private open Base
private open Facility
private open Staff as S
```


```alloy
sig シラバス{
	対応 : disj 授業,
}

sig 授業{
	実施年度 : 年度,
	実施期 : 期,
	科目 : 科目,
	代表教員 : 教員,
}{
	some this.~対応
}
```

```alloy
abstract sig 時間割{
	実施年度 : 年度,
	実施期 : 期,
	授業 : 授業,
	曜時 : set 曜日時限,
	担当 : 教員,
	副担 : set 教員,
	教室時間割 : set 教室,
	週間隔区分 : 週間隔,
	代表 : 時間割,
}{
	集中 in 曜時 => no (曜時 - 集中)
}

sig 子時間割 extends 時間割{
}{
	-- 子時間割の定義
	代表 != this
	代表 in 代表時間割
}

sig 代表時間割 extends 時間割{
}{
	-- 代表時間割の定義
	代表 = this
}
```

```alloy
assert シラバスと授業は同数ある{
	#シラバス = #this/授業
}
check シラバスと授業は同数ある

assert 任意の時間割には代表時間割が一意に存在する{
	all j: 時間割 | one 代表時間割[j]
}
check 任意の時間割には代表時間割が一意に存在する

assert 任意の異なる代表時間割の合併時間割は排他的である{
	all disj r,r': 代表時間割 |
		no (合併時間割[r] & 合併時間割[r'])
}
check 任意の異なる代表時間割の合併時間割は排他的である

assert 任意の子時間割は代表をたどっても循環参照しない{
	all c: 子時間割 |
		c not in c.^代表
}
check 任意の子時間割は代表をたどっても循環参照しない
```

```alloy
pred 複数の教員による時間割が作れる{
	some t: 時間割 |
		#講師陣[t] > 1
}
run 複数の教員による時間割が作れる

pred 複数の教室を使った時間割が作れる{
	some t: 時間割 |
		#教室時間割[t] > 1
}
run 複数の教室を使った時間割が作れる

pred 複数の曜時にまたがる時間割が作れる{
	some t: 時間割 |
		#t.曜時 > 1
}
run 複数の曜時にまたがる時間割が作れる

pred 複数の時間割が同じ教室を共有できる{
	some disj t,t': 時間割 |
		some (教室時間割[t] & 教室時間割[t'])
}
run 複数の時間割が同じ教室を共有できる

pred 隔週時間割が作れる{
	some t: 時間割 |
		t.週間隔区分 in (隔週1 + 隔週2)
}
run 隔週時間割が作れる

pred 集中授業の時間割を作れる{
	some j: 時間割 |
		集中 in j.曜時
}
run 集中授業の時間割を作れる

pred 合併時間割に異なる科目の時間割を含めることができる{
	some j: 時間割 | some disj c,c': 合併時間割[j] |
		c.授業.科目 != c'.授業.科目
}
run 合併時間割に異なる科目の時間割を含めることができる

```

```alloy
fun 講師陣(t: 時間割) : set S/教員{
	t.(担当 + 副担)
}

fun 授業内容(t: 時間割) : シラバス{
	t.授業.~対応
}

fun 代表時間割(j: 時間割) : set 時間割{
	j.*代表 & 代表時間割
}

fun 合併時間割(j: 時間割) : set 時間割{
	代表時間割[j].*(~代表)
}

```
