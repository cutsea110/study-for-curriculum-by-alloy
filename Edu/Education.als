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
private open Student as G
private open Timetable as T
```

```alloy
sig 出席情報{
	時間割 : 時間割,
	学生 : 学生,
	教室 : 教室,
	回 : Int,
	出欠 : 出欠状態,
}{
	nonneg[回]
}


sig 履修申請{
	申請者 : 学生,
	申請時間割 : 時間割,
	状態 : 履修申請状態,
	結果 : 履修申請結果,
	再履修 : Bool,
}

sig 履修{
	履修者 : 学生,
	履修時間割 : 時間割,
	再履修 : Bool,
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
fact 重複する履修登録はない{
	no g: G/学生 |
		some disj r,r': g.~履修者 |
			r.履修時間割 = r'.履修時間割
}

fact 成績の評価は学則の評価基準の範囲にある必要がある{
	all s: 成績 | let rs = {r : s.学生.適用.~含まれる | r.科目 = s.科目} |
		s.評価 in rs.評価基準.取り得る評価
}

fact 単位修得できる成績は学生科目ごとに高々ひとつしかない{
	no s: G/学生 | some disj e,e': s.~(成績 <: 学生) |
		e.科目 = e'.科目 and 単位になる[e] and 単位になる[e']
}

fact 履修の科目は履修者の全履修可能科目の範囲内にある{
	all r: 履修 | 履修科目[r] in 全履修可能科目[r.履修者]
}

fact 対称的な事前修得前提科目はない{
	all c: カリキュラム |
		no disj p,p': 事前修得前提[c] |
			p.対象 = p'.前提 and p.前提 = p'.対象
}

-- 前提を推移的に辿っていないことに注意
fact 学生が事前修得前提科目の対象科目を履修できるなら前提科目を全て修得している{
	all g: G/学生 |
		all r: g.~履修者 |
			all k: 事前修得前提科目群[g.適用, 履修科目[r]] |
				some s: 成績 |
					単位になる[s] and s.学生 = g and s.科目 = k
}
```

```alloy
assert 任意の成績の科目は適用カリキュラムの学則に含まれる{
	all s: 成績 | s.科目 in 修得可能学則[s.学生].科目
}
check 任意の成績の科目は適用カリキュラムの学則に含まれる

assert 任意の成績のGPAは一意に決まる{
	all s: 成績 | #GPA[s] = 1
}
check 任意の成績のGPAは一意に決まる

assert 同じ科目に対して単位認定可能な成績は一意に決まる{
	no g: G/学生 | some disj s,s': g.~(成績 <: 学生) |
		s.科目 = s'.科目 and 単位になる[s] and 単位になる[s']
}
check 同じ科目に対して単位認定可能な成績は一意に決まる
```

```alloy
pred 異なる学科の学生が同じ時間割を履修できる{
	some disj r,r': 履修 |
		not 学部学科が同じ[r.履修者,r'.履修者] and 時間割が同じ[r,r']
}
run 異なる学科の学生が同じ時間割を履修できる

pred 適用カリキュラムにない科目を履修できる{
	some r: 履修 |
		履修科目[r] not in 基本履修可能科目[r.履修者]
}
run 適用カリキュラムにない科目を履修できる

pred 異なるカリキュラムの学生が同じ時間割を履修できる{
	some disj r,r': 履修 |
		not カリキュラムが同じ[r.履修者,r'.履修者] and 時間割が同じ[r,r']
}
run 異なるカリキュラムの学生が同じ時間割を履修できる

pred 異なる学年の学生が同じ時間割を履修できる{
	some disj r,r': 履修 |
		not 学年が同じ[r.履修者,r'.履修者] and 時間割が同じ[r,r']
}
run 異なる学年の学生が同じ時間割を履修できる

pred 時間割がなくても成績は作れる{
	no t: T/時間割 | some s: 成績 |
		s.科目 = t.授業.科目
}
run 時間割がなくても成績は作れる

pred 履修がなくても成績は作れる{
	no r: 履修 | some s: 成績 | 
		s.学生 = r.履修者 and s.科目 = 履修科目[r]
}
run 履修がなくても成績は作れる

pred 試験成績はなくても成績はつけられる{
	no t: 試験成績 | some s: 成績 |
		s.学生 = t.学生 and s.科目 = 試験成績科目[t]
}
run 試験成績はなくても成績はつけられる

pred 出欠は取らなくても成績はつけられる{
	no a: 出席情報 | some s: 成績 |
		a.学生 = s.学生 and 出席情報科目[a] = s.科目
}
run 出欠は取らなくても成績はつけられる

pred 履修がなくても出欠はつけられる{
	no r: 履修 | some a: 出席情報 |
		r.履修者 = a.学生 and 履修科目[r] = 出席情報科目[a]
}
run 履修がなくても出欠はつけられる

pred 単独科目授業を履修できる{
	some disj r,r': 履修 |
		履修科目[r] = 履修科目[r'] and
		履修時期[r] = 履修時期[r'] and
		履修場所[r] = 履修場所[r'] and
		履修曜時[r] = 履修曜時[r'] and
		評価者[r] = 評価者[r']
}
run 単独科目授業を履修できる

pred 分割科目を履修できる{
	some disj r,r': 履修 |
		履修科目[r] = 履修科目[r'] and
		履修時期[r] = 履修時期[r'] and
		履修場所[r] != 履修場所[r'] and
		評価者[r] != 評価者[r']
}
run 分割科目を履修できる

pred 一貫分割型複数担当科目を履修できる{
	some disj r,r': 履修 |
		履修科目[r] = 履修科目[r'] and
		履修時期[r] = 履修時期[r'] and
		評価者[r] = 評価者[r'] and
		#講師陣[r] > 1 and #講師陣[r'] > 1
}
run 一貫分割型複数担当科目を履修できる

pred 途中分割型複数担当科目を履修できる{
	some disj r,r': 履修 |
		履修科目[r] = 履修科目[r'] and
		履修時期[r] = 履修時期[r'] and
		履修場所[r] != 履修場所[r'] and some (履修場所[r] & 履修場所[r']) and
		評価者[r] != 評価者[r'] and some (講師陣[r] & 講師陣[r'])
}
run 途中分割型複数担当科目を履修できる

pred シリーズ科目を履修できる{
	some disj r,r': 履修 |
		履修科目[r] = 履修科目[r'] and
		履修時期[r] = 履修時期[r'] and
		履修場所[r] = 履修場所[r'] and
		評価者[r] = 評価者[r'] and #講師陣[r] > 1 and #講師陣[r'] > 1
}
run シリーズ科目を履修できる

pred 学生は複数の履修ができる{
	all s: G/学生 |
		#s.~履修者 > 1
}
run 学生は複数の履修ができる

pred 同じ科目の履修を複数持ち得る{
	some g: G/学生 | some disj r,r': g.~履修者 |
		履修科目[r] = 履修科目[r']
}
run 同じ科目の履修を複数持ち得る

pred 同じ科目の成績を複数持ち得る{
	some g: G/学生 | some disj s,s': g.~(成績 <: 学生) |
		s.科目 = s'.科目
}
run 同じ科目の成績を複数持ち得る

pred 合併時間割に異なる科目の履修を含めることができる{
	some j: T/時間割 | some disj r,r': 履修 |
		(r + r').履修時間割 in 合併時間割[j] and 履修科目[r] != 履修科目[r']
}
run 合併時間割に異なる科目の履修を含めることができる

pred 合併時間割に異なる科目の出席情報を含めることができる{
	some j: T/時間割 | some disj a,a': 出席情報 |
		(a + a').時間割 in 合併時間割[j] and 出席情報科目[a] != 出席情報科目[a']
}
run 合併時間割に異なる科目の出席情報を含めることができる

pred 合併時間割に異なる科目の試験成績を含めることができる{
	some j: T/時間割 | some disj t,t': 試験成績 |
		(t + t').時間割 in 合併時間割[j] and 試験成績科目[t] != 試験成績科目[t']
}
run 合併時間割に異なる科目の試験成績を含めることができる

pred 時間割に対して学生の履修申請を作ることができる{
	some t: T/時間割 |
		some s: G/学生 |
			some r: 履修申請 |
			r.申請者 in s and r.申請時間割 in t
}
run 時間割に対して学生の履修申請を作ることができる

pred 履修申請に対応する履修を作ることができる{
	some r: 履修申請 |
		some x: 履修 |
			x.由来する in r
}
run 履修申請に対応する履修を作ることができる

pred 抽選による履修登録ができる{
	some t: T/時間割 |
		some s: G/学生 |
			some x: 履修 |
				let r = x.由来する |
					some r and
					r.申請者 in s and r.申請時間割 in t and
					x.履修者 in s and x.履修時間割 in t
}
run 抽選による履修登録ができる

pred 履修申請のない履修を作ることができる{
	some x: 履修 |
		no x.由来する
}
run 履修申請のない履修を作ることができる

pred 事前修得前提科目が設定された科目を履修できる{
	some r: 履修 |
		some p: 事前修得前提科目 |
			履修科目[r] in p.対象
}
run 事前修得前提科目が設定された科目を履修できる

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

fun GPA(s: 成績) : set GPA値{
	{r : 学則 | r in 修得可能学則[s.学生] and r.科目 = s.科目}.評価基準.GPA[s.評価]
}

```



```alloy
pred 時間割が同じ(r,r': 履修){
	r.履修時間割 = r'.履修時間割
}

pred 単位になる(s: 成績){
	some r: 修得可能学則[s.学生] |
		s.科目 = r.科目 and s.評価 in r.評価基準.単位認定評価
}
```
