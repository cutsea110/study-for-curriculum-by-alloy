---
title: EvalMethod
layout: default
---

```alloy
private open Base
```

```alloy
abstract sig 評価基準{
	取り得る評価 : set 評価コード,
  単位認定評価 : set 評価コード,
	GPA : 取り得る評価 -> GPA値,
}{
	単位認定評価 in 取り得る評価
}
```

```alloy
one sig 段階評価 extends 評価基準{
}{
	取り得る評価 = S + A + B + C + D
	単位認定評価 = S + A + B + C
	GPA = (S -> GPA_4) + (A -> GPA_3) + (B -> GPA_2) + (C -> GPA_1) + (D -> GPA_0)
}
one sig 認定評価 extends 評価基準{
}{
	取り得る評価 = N + F
	単位認定評価 = N
	GPA = (N -> GPA_0) + (F -> GPA_0)
}
one sig 評価不要 extends 評価基準{
}{
	取り得る評価 = A
	単位認定評価 = A
	GPA = (A -> GPA_3)
}

```
