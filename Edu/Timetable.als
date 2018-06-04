---
title: Timetable
layout: default
---

```alloy
private open Base
private open Facility
private open Staff
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
	-- ペア科目はこの時間割を履修する際に
	-- 同時に履修すべき時間割を指す
	ペア : lone 時間割,
	代表 : 時間割,
}{
	this not in ペア
	-- ペア科目は同時履修させるので必然的に科目が一緒なのはまずいのでは?
	-- と思ったが世の中にはこれを許容したい運用が存在するかもしれない.
	-- 二つの異なる時間割を履修してどっちかの先生に成績を付けてもらうとか.
--	ペア.@授業.@科目 != this.@授業.@科目
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
