---
title: Education
layout: default
---

```alloy
private open Base
private open Curriculum
private open CurriculumExtensions
private open Department
private open Facility
private open Staff
private open Student
private open Timetable
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
