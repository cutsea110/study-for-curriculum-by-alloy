---
title: Student
layout: default
---

```alloy
private open Base
private open Department
private open Curriculum as C
private open Requirement
private open Staff
private open Timetable as T
```

```alloy
enum 異動種別 { 入学前, 入学, 復学, 編入, 転学部学科入, 再入学, 休学, 留学, 停学,
								退学, 卒業, 転籍, 転学部学科出, 除籍, 入学辞退,
								復籍
							}
enum 学籍区分 { 入学予定, 在学中, 休学中, 留学中, 停学中,
								退学済, 卒業済, 転籍済, 転学部学科出済, 除籍済, 入学辞退済
							}
enum 教職申請状態 { 履修しない, 申請中, 履修確定 }

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
	教職状態 : 教職申請状態,
	資格 : set (資格要件 - 教職要件),
	入学年度 : 年度,
	入学期 : 期,
	入学学年 : 年次,

	状態 : 学籍区分,
	異動歴 : set 異動履歴,

	クラス担任 : lone 教員,

	ゼミ担当 : lone 教員,
	ゼミ授業 : lone T/授業,

	保護者 : lone 関係者,
	保証人 : lone 関係者,
}{
	no 教職 => 教職状態 in 履修しない
	some 教職 => 教職状態 in 申請中 + 履修確定
	-- 異動履歴は他の学籍とは共有しない
	-- [TODO]しかしトレースした時に困る...
--	異動歴.~@異動歴 in this
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

sig 関係者{
}
```

```alloy
fact 教職およびその他資格要件を必要とする学生がいるならそれら資格要件はすべて学則にて用意してある{
	all g: 学生 |
		g.(教職 + 資格) in 修得可能学則[g].適用要件
}
```

```alloy
assert 学生に適用されるカリキュラムは一意に決まる{
	all s: 学生 | one s.適用
}
check 学生に適用されるカリキュラムは一意に決まる

assert 学生に適用されるディプロマポリシーは一意に決まる{
	all s: 学生 | one s.適用されるディプロマポリシー
}
check 学生に適用されるディプロマポリシーは一意に決まる

assert 同じカリキュラムに適用されている学生はディプロマポリシーも同じ{
	all s,s': 学生 |
		カリキュラムが同じ[s,s'] => ディプロマポリシーが同じ[s,s']
}
check 同じカリキュラムに適用されている学生はディプロマポリシーも同じ

assert 学生のゼミ担当教員は存在すれば一意に決まる{
	all s: 学生 | some s.ゼミ担当 => one s.ゼミ担当
}
check 学生のゼミ担当教員は存在すれば一意に決まる
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

pred 学生の異動履歴を残せる{
	some g : 学生 |
		some g.異動歴
}
run 学生の異動履歴を残せる

pred 学生の保護者を登録できる{
	some s: 学生 | some s.保護者
}
run 学生の保護者を登録できる

pred 学生の保証人を登録できる{
	some s: 学生 | some s.保証人
}
run 学生の保証人を登録できる

pred 学生の保証人と保護者に異なる人を登録できる{
	some s: 学生 | some s.保証人 and some s.保護者 and s.保証人 != s.保護者
}
run 学生の保証人と保護者に異なる人を登録できる

pred 学生の保証人と保護者に同じ人を登録できる{
	some s: 学生 | some s.保証人 and some s.保護者 and s.保証人 = s.保護者
}
run 学生の保証人と保護者に同じ人を登録できる

pred 学生にゼミ担当教員を設定できる{
	some s: 学生 | some s.ゼミ担当 and s.ゼミ担当 in 教員
}
run 学生にゼミ担当教員を設定できる
```

```alloy
fun 基本履修可能科目(s: 学生) : set Base/科目{
	修得可能学則[s].科目
}

fun 修得可能学則(s: 学生) : set C/学則{
	s.適用.~含まれる
}

fun 在籍区分 : set 学籍区分{
	入学予定 + 在学中 + 休学中 + 留学中 + 停学中
}
fun 除籍区分 : set 学籍区分{
	退学済 + 卒業済 + 転籍済 + 転学部学科出済 + 除籍済 + 入学辞退済
}
fun 適用されるディプロマポリシー(s: 学生) : set C/ディプロマポリシー{
	s.適用.DP
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

pred ディプロマポリシーが同じ(s,s': 学生){
	s.適用されるディプロマポリシー = s'.適用されるディプロマポリシー
}

pred 在籍状態にある(s: 学生){
	s.状態 in 在籍区分
}

pred 除籍状態にある(s: 学生){
	s.状態 in 除籍区分
}
```