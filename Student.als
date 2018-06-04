---
title: Student
layout: default
---

```alloy
private open Base
private open Department
private open Curriculum
private open Requirement
```


```alloy
abstract sig 学生{
	学年 : 年次,
	所属 : 学部学科,
	適用 : カリキュラム,
	卒業進級対象 : フラグ,
	留学生フラグ : フラグ,
	教職 : set 教職要件,
	資格 : set (資格要件 - 教職要件),
	入学年度 : 年度,
	入学期 : 期,
	入学学年 : 年次,
}

sig 正規生 extends 学生{
}{
	適用 in 正規カリキュラム
	卒業進級対象 = On
}
sig 非正規生 extends 学生{
}{
	卒業進級対象 = Off
}

```
