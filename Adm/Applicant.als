---
title: Applicant
layout: default
---

```alloy
private open Base
private open Admission

private open util/boolean
```

```alloy
sig 志願者{
	年度 : 年度,
	期 : 入学期,
}

sig 出願{
	受験番号 : Int,
  出願者: 志願者,
	出欠 : 出席区分,

	詳細 : some 出願詳細,
	試験成績 : set 成績,
}{
	詳細.~@詳細 in this
	試験成績.~@試験成績 in this
	受験番号 > 0
}

sig 出願詳細{
  応募: 入試募集,
  希望順位: Int,
	合否 : 合否区分,
	手続き完了 : Bool,
	席次 : Int,

	試験評価 : set 評価,
}{
	試験評価.~@試験評価 in this
	席次 > 0
	希望順位 > 0
}

sig 成績{
  科目 : 科目,
	出欠 : 出席区分,
  素点 : Int,
}

sig 評価{
	対象 : 入試募集,
	科目 : 科目,
	評価値 : Int,
}
```

```alloy
fact 志願者は年度をまたがって出願できない{
	all a: 志願者 |
		let n = a.出願している入試 |
			n.年度 = a.年度 and n.期 = a.期
}
```

```alloy
assert 志願者に紐付かない出願は存在しない{
	no a: 出願 |
		no a.出願者
}
check 志願者に紐付かない出願は存在しない

assert 出願詳細のない出願は存在しない{
	no a: 出願 |
		no a.詳細
}
check 出願詳細のない出願は存在しない

assert 出願詳細が共有されることはない{
	no d: 出願詳細 |
		some disj a,a': 出願 |
			d in a.詳細 and d in a'.詳細
}
check 出願詳細が共有されることはない
```

```alloy
pred 志願者は複数の出願ができる{
	some a: 志願者 |
		#a.~出願者 > 1
}
run 志願者は複数の出願ができる

pred 志願者はひとつの出願で複数の入試募集に同時併願できる{
	some a: 志願者, a': a.~出願者 |
		#a'.詳細 > 1
}
run 志願者はひとつの出願で複数の入試募集に同時併願できる

-- 明治なんかはこれができる
pred 同じ入試に複数の出願ができる{
	some a: 志願者 |
		some disj x,x': a.~出願者 |
			x.入試募集.~募集 = x'.入試募集.~募集
}
run 同じ入試に複数の出願ができる
```

```alloy
fun 出願詳細(a: 志願者) : set 出願詳細{
	a.~出願者.詳細
}
fun 出願している入試募集(a: 志願者) : set 入試募集{
	a.出願詳細.応募
}
fun 出願している入試(a: 志願者) : set 入試{
	a.出願している入試募集.~募集
}
fun 入試募集(a: 出願) : set 入試募集{
	a.詳細.応募
}
```

