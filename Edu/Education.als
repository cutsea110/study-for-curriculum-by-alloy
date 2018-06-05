---
title: Education
layout: default
---

```alloy
private open Base
private open Curriculum
private open CurriculumExtensions
private open Department
private open Facility as F
private open Staff as S
private open Student
private open Timetable as T
```

```alloy
sig 出席情報{
	時間割 : 時間割,
	学生 : 学生,
	教室 : 教室,
	回 : 授業回,
	出欠 : 出欠状態,
}


sig 履修申請{
	申請者 : 学生,
	申請時間割 : 時間割,
	状態 : 履修申請状態,
	結果 : 履修申請結果,
	再履修 : フラグ,
}

sig 履修{
	履修者 : 学生,
	履修時間割 : 時間割,
	再履修 : フラグ,
	由来する : lone 履修申請,
}

sig 試験成績{
	学生 : 学生,
	時間割 : 時間割,
	区分 : 試験区分,
	期 : 試験時期,
	評価 : 評価コード,
}

sig 成績{
	学生 : 学生,
	科目 : 科目,
	評価 : 評価コード,
}
```


```alloy
fun 評価者(r: 履修) : S/教員{
	r.履修時間割.担当
}

fun 講師陣(r: 履修) : set S/教員{
	講師陣[r.履修時間割]
}

fun 履修授業(r: 履修) : T/授業{
	r.履修時間割.授業
}

fun 履修科目(r: 履修) : Base/科目{
	履修授業[r].科目
}

fun 履修場所(r: 履修) : set F/教室{
	r.履修時間割.教室時間割
}

fun 履修時期(r: 履修) : Base/年度 -> Base/期{
	let t = r.履修時間割 |
		t.実施年度 -> t.実施期
}

fun 履修曜時(r: 履修) : set Base/曜日時限 -> Base/週間隔{
	let t = r.履修時間割 |
		t.曜時 -> t.週間隔区分
}

fun 試験成績科目(t: 試験成績) : Base/科目{
	t.時間割.授業.科目
}

fun 出席情報科目(a: 出席情報) : Base/科目{
	a.時間割.授業.科目
}

```
