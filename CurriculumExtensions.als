---
title: CurriculumExtensions
layout: default
---

```alloy
private open Base
private open Curriculum
private open Student
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
	単位数上限 : 単位数,
}
```
