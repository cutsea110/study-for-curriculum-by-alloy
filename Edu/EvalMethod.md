---
title: EvalMethod
---

# 概要

履修成績の評価基準のモデルを定義する.

## 依存モデル

```alloy
private open Base
```

## 評価基準

主に成績に対する段階評価を行う際に使える評価コード(レターコード)を定義したものであり,
そのうちのどれが単位認定される評価コードか,あるいは各評価コードのGPA値への対応を定義するモデル.

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
