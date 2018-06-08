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
enum 異動種別 { 入学前, 入学, 復学, 編入, 転学部学科入, 再入学, 休学, 留学, 停学,
								退学, 卒業, 転籍, 転学部学科出, 除籍, 入学辞退,
								復籍
							}
enum 学籍区分 { 入学予定, 通常, 休学中, 留学中, 停学中,
								退学済, 卒業済, 転籍済, 転学部学科出済, 除籍済, 入学辞退済
							}

sig 異動理由{
}
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

	状態 : 学籍区分,
	異動歴 : seq 異動履歴,
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

sig 異動履歴{
	開始日 : Time,
	終了日 : Time,
	種別 : 異動種別,
	理由 : 異動理由,
}{
	lte[開始日, 終了日]
}

```

```alloy
assert 学生に適用されるカリキュラムは一意に決まる{
	all s: 学生 | one s.適用
}
check 学生に適用されるカリキュラムは一意に決まる
```

```alloy
pred 正規生が存在しうる{
	some 正規生
}
run 正規生が存在しうる

pred 非正規生が存在しうる{
	some 非正規生
}
run 非正規生が存在しうる

pred 同じ学科の学生に異なるカリキュラムを適用できる{
	some disj s,s': 学生 |
		学部学科が同じ[s,s'] and not カリキュラムが同じ[s,s']
}
run 同じ学科の学生に異なるカリキュラムを適用できる

pred 学生は教職要件を取得申請できる{
	some s: 学生 |
		some s.教職
}
run 学生は教職要件を取得申請できる

pred 学生は複数の教職要件を取得申請できる{
	some s: 学生 |
		#s.教職 > 1
}
run 学生は複数の教職要件を取得申請できる

pred 学生は資格要件を取得申請できる{
	some s: 学生 |
		some s.資格
}
run 学生は資格要件を取得申請できる

pred 学生は複数の資格要件を取得申請できる{
	some s: 学生 |
		#s.資格 > 1
}
run 学生は複数の資格要件を取得申請できる

pred 任意の要件を取得可能なように学則を構成できる{
	all g: 学生 |
		g.(教職 + 資格) in 修得可能学則[g].適用要件
}
run 任意の要件を取得可能なように学則を構成できる

pred 学生の異動履歴を残せる{
	some g : 学生 |
		some g.異動歴
}
run 学生の異動履歴を残せる

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
pred 学部学科が同じ(s,s': 学生){
	s.所属 = s'.所属
}

pred 学年が同じ(s,s': 学生){
	s.学年 = s'.学年
}

pred カリキュラムが同じ(s,s': 学生){
	s.適用 = s'.適用
}
```
