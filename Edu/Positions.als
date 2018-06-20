---
title: Positions
layout: default
---

```alloy
private open Staff
private open Student
```

```alloy
enum 第１種役割 { TA, SA, RA }
enum 第２種役割 { チューター, メンター }
enum 第３種役割 { クラス副担任, アドバイザ, Tutor }
```

```alloy
abstract sig 関係{
	主 : 学生 + 教員,
	被 : 学生 + 教員,
	役割種別 : 第１種役割 + 第２種役割 + 第３種役割,
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
