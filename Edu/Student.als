---
title: Student
layout: default
---

```alloy
private open Base
private open Department
private open Curriculum as C
private open Requirement
private open Timetable as T
```


```alloy
abstract sig 学生{
	学年 : 年次,
	所属 : 学部学科,
	適用 : カリキュラム,
	卒業進級対象 : Bool,
	留学生フラグ : Bool,
	教職 : set 教職要件,
	資格 : set (資格要件 - 教職要件),
	入学年度 : 年度,
	入学期 : 期,
	入学学年 : 年次,
}

sig 正規生 extends 学生{
}{
	適用 in 正規カリキュラム
	卒業進級対象 = True
}
sig 非正規生 extends 学生{
}{
	卒業進級対象 = False
}

```

```alloy
fun 基本履修可能科目(s: 学生) : set Base/科目{
	修得可能学則[s].科目
}

fun 修得可能学則(s: 学生) : set C/学則{
	s.適用.~含まれる
}

```

```alloy
pred 学部学科が同じ(s,s': this/学生){
	s.所属 = s'.所属
}

pred 学年が同じ(s,s': this/学生){
	s.学年 = s'.学年
}

pred カリキュラムが同じ(s,s': this/学生){
	s.適用 = s'.適用
}
```
