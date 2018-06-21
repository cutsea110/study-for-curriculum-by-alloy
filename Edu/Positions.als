---
title: Positions
layout: default
---

```alloy
private open Staff
private open Student

private open util/time
```

```alloy
enum 第１種役割 { TA, SA, RA }
enum 第２種役割 { チューター, メンター }
enum 第３種役割 { アドバイザ, Tutor }
enum 状態 { 下書き, 申請中, 確定済 }
```

```alloy
abstract sig 関係{
	主 : 学生 + 教員,
	被 : 学生 + 教員,
	役割種別 : 第１種役割 + 第２種役割 + 第３種役割,

	開始日 : Time,
	終了日 : Time,
	状態 : 状態,
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
pred 教員にTAやSAやRAなどのアシスタントをつけることができる{
	some s: 教員 |
		some {r: s.~被 | r.役割種別 in 第１種役割}.主
}
run 教員にTAやSAやRAなどのアシスタントをつけることができる

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
