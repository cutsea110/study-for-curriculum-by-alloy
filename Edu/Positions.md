---
title: Positions
layout: default
---

```alloy
private open Base
private open Staff
private open Student

private open util/time
```

```alloy
enum 第１種役割 { TA, SA, RA }
enum 第２種役割 { チューター, メンター }
enum 第３種役割 { アドバイザ, Tutor }
enum ステータス { 下書き, 申請中, 確定済 }
```

```alloy
abstract sig 関係{
	主 : lone (学生 + 教員),
	被 : lone (学生 + 教員),
	役割種別 : 第１種役割 + 第２種役割 + 第３種役割,

	年度 : 年度,
	期 : 期,
	状態 : ステータス,
}{
	状態 in (this/申請中 + this/確定済) => one 主 and one 被
	状態 in this/下書き => one 主 or one 被
}

sig 学生教員関係 extends 関係{
}{
	主 in 学生
	被 in 教員
	役割種別 in 第１種役割
}

sig 学生学生関係 extends 関係{
}{
	主 in 学生
	被 in 学生
	役割種別 in 第２種役割
}

sig 教員学生関係 extends 関係{
}{
	主 in 教員
	被 in 学生
	役割種別 in 第３種役割
}
```

```alloy
assert 任意の学生教員関係は年度と期で期間が定められている{
	all r: 学生教員関係 | 期間が定められている[r]
}
check 任意の学生教員関係は年度と期で期間が定められている

pred 教員にTAやSAやRAなどのアシスタントをつけることができる{
	some s: 教員 |
		some {r: s.~被 | r.役割種別 in 第１種役割}.主
}
run 教員にTAやSAやRAなどのアシスタントをつけることができる

pred 教員は複数名のTAやSAやRAなどのアシスタントをつけることができる{
	some s: 教員 |
		#{r: s.~被 | r.役割種別 in 第１種役割}.主 > 1
}
run 教員は複数名のTAやSAやRAなどのアシスタントをつけることができる

pred 学生にチューターやメンターをつけることができる{
	some s: 学生 |
		some {r: s.~被 | r.役割種別 in 第２種役割}.主
}
run 学生にチューターやメンターをつけることができる

pred 学生にアドバイザや英式Tutorをつけることができる{
	some s: 学生 |
		some {r: s.~被 | r.役割種別 in 第３種役割}.主
}
run 学生にアドバイザや英式Tutorをつけることができる

pred 学生に複数名のアドバイザをつけることができる{
	some s: 学生 |
		#{r: s.~被 | r.役割種別 in アドバイザ}.主 > 1
}
run 学生に複数名のアドバイザをつけることができる
```

```alloy
pred 期間が定められている(r: 関係){
	some r.年度 and some r.期
}
```
