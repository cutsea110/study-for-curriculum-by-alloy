---
title: Admission
layout: default
---

```alloy
private open Base
private open Department
private open DNC

private open util/time
```

```alloy
enum 検査方法 { 学力, 調査書, 小論文, 面接, 実技 }

abstract sig 試験源{
}
one sig 試験源_手入力 extends 試験源{
}
sig 試験源_大学入試センター extends 試験源{
}
sig 試験源_評定平均 extends 試験源{
}

sig 入学方式{
}
sig 入学経路{
}
```

```alloy
sig 入試{
	年度 : 年度,
	期 : 入学期,
	入学学年 : 年次,
	方式 : 入学方式,
	経路 : 入学経路,
	センター試験区分 : 大学入試センター試験区分,
	センター成績請求区分 : 大学入試センター成績請求区分,

	募集 : set 入試募集,
}{
	募集.~@募集 in this
}

sig 入試募集{
	募集学科 : 学部学科,
	募集定員 : Int,

	申し込み受付開始日 : Time,
	申し込み受付終了日 : Time,
	試験日 : Time,
	合格発表日 : Time,
	入学手続き受付開始日 : Time,
	入学手続き〆切日 : Time,

	評価基準 : set 評価項目,
}{
	some this.~募集
	評価基準.~@評価基準 in this
	募集定員 >= 0
}

sig 評価項目{
	科目 : 科目,

	検査方法 : 検査方法,
	試験源 : 試験源,

	-- TODO: 評価換算関数とかグループ化とか
}
```

```alloy
assert 入試に紐付かない入試募集は存在しない{
	no r: 入試募集 |
		no r.~募集
}
check 入試に紐付かない入試募集は存在しない

assert 入試募集は複数の入試に共有されることはない{
	no r: 入試募集 |
		some disj a,a': 入試 |
			r in a.募集 and r in a'.募集
}
check 入試募集は複数の入試に共有されることはない
```

---------------------
-- ファクト関係
---------------------

pred 同じ入試制度が複数ある{
  some disj x, x': 入試制度 | x.年度 = x'.年度 and x.制度 = x'.制度
}

pred 成績は募集の評価項目の部分集合(s: 出願){
  s.~受験.科目コード in s.~orig.希望.~適用.科目コード
}

pred 科目成績はユニーク(s: 出願){
  #s.~受験 = #s.~受験.科目コード
}

pred 希望は1から(s: 出願){
  let n = #s.~orig {
    n = 1 => s.~orig.希望順位 in D1
    n = 2 => s.~orig.希望順位 in D1 + D2
  }
}

pred 希望はユニーク(s: 出願){
  #s.~orig = #s.~orig.希望順位
}

pred 年度をまたぐ(a: 志願者){
  #a.~出願者.~orig.希望.募集.年度 > 1
}

pred 同じ募集に複数出願している(a: 志願者) {
  some b: 入試募集 | some disj s, s': 出願詳細 {
    b in s.希望 and b in s'.希望 and (s.orig + s'.orig) in a.~出願者
  }
}

pred 複数の入試制度にまたがる(s: 出願){
  #s.~orig.希望.募集 > 1
}

-- これは明治なんかはある
pred 同じ入試制度に複数出願している(a: 志願者){
  some disj s, s': 出願 | some n: 入試制度 {
    a in s.出願者 and a in s'.出願者 and n in s.~orig.希望.募集 and n in s'.~orig.希望.募集
  }
}

pred 単願している(a: 志願者){
  -- 出願詳細が1つだけ
  one a.~出願者.~orig
}

pred 併願している(a: 志願者){
  -- 出願が2つ以上
  #a.~出願者 > 1
}

pred 同時併願している(x: 志願者){
  -- 出願詳細が2つ以上の出願がある
  some s: x.~出願者 | #s.~orig > 1
}

pred 入試制度複数{
  #入試制度 > 1
}
pred 志願者複数{
  #志願者 > 1
}
pred 単年度{
  #入試制度.年度 = 1
}
pred 複数年度{
  #入試制度.年度 > 1
}

pred show {
  -- 見た目の奇妙さを回避したいだけ
  all s: 出願 | 成績は募集の評価項目の部分集合[s] and
                    科目成績はユニーク[s] and
                    希望は1から[s] and
                    希望はユニーク[s]
  -- 大前提にしよう
  no x: 志願者 | 年度をまたぐ[x]
  no x: 志願者 | 同じ募集に複数出願している[x]

  -- この辺からどうか?
--  not 同じ入試制度が複数ある
  no s: 出願 | 複数の入試制度にまたがる[s]
  some a: 志願者 | 同じ入試制度に複数出願している[a]
--  some a: 志願者 | 単願している[a]

  some x: 志願者 | 併願している[x]
  some y: 志願者 | 同時併願している[y]

--  単年度
  複数年度
--  入試制度複数
--  志願者複数
}
run show for 4 -- but exactly 1 志願者
