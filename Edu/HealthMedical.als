---
title: HealthMedical
layout: default
---

```alloy
private open Base as B
private open Student
```

```alloy
private enum 検診種別 { 胸部, 視力, 聴力, 身体, 糖尿, 検査 }

private sig 医師{
}
```

```alloy
sig 学生健康診断{
	対象 : 学生,
	年度 : 年度,
	検診日 : Time,
	医師名 : 医師,
	発行可 : Bool,
}

abstract sig 検診{
	対象 : 学生,
	年度 : 年度,
	検査日 : Time,
	種別 : 検診種別,
}

sig 胸部検診 extends 検診{
}{
	種別 = 胸部
}

sig 視力検診 extends 検診{
}{
	種別 = 視力
}

sig 聴力検診 extends 検診{
}{
	種別 = 聴力
}

sig 身体検診 extends 検診{
}{
	種別 = 身体
}

sig 糖尿検診 extends 検診{
}{
	種別 = 糖尿
}

sig 検査検診 extends 検診{
}{
	種別 = 検査
}
```

```alloy
pred 学生ごとに健康診断データを管理できる{
	some disj x,x': 学生健康診断 |
		x.対象 != x'.対象
}
run 学生ごとに健康診断データを管理できる

pred 学生は年度ごとに健康診断データを保持できる{
	some disj x,x': 学生健康診断 |
		x.対象 = x'.対象 and x.年度 != x'.年度
}
run 学生は年度ごとに健康診断データを保持できる

pred 学生は同一年度に複数の健康診断データを保持できる{
	some disj x,x': 学生健康診断 |
		x.対象 = x'.対象 and x.年度 = x'.年度
}
run 学生は同一年度に複数の健康診断データを保持できる

pred 学生は年度ごとに検診データを保持できる{
	some disj x,x': 検診 |
		x.種別 = x'.種別 and x.対象 = x'.対象 and x.年度 != x'.年度
}
run 学生は年度ごとに検診データを保持できる

pred 学生は同一年度に同じ種類の検診データを複数保持できる{
	some disj x,x': 検診 |
		x.種別 = x'.種別 and x.対象 = x'.対象 and x.年度 = x'.年度
}
run 学生は同一年度に同じ種類の検診データを複数保持できる
```
