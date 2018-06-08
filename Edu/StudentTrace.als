---
title: StudentTrace
layout: default
---

```alloy
private open util/ordering [学生]

private open Student
```

```alloy
pred その他は変化なし(s,s': 学生){
	s.学年 = s'.学年 and
	s.所属 = s'.所属 and
	s.適用 = s'.適用 and
	s.卒業進級対象 = s'.卒業進級対象 and
	s.留学生フラグ = s'.留学生フラグ and
	s.教職 = s'.教職 and
	s.資格 = s'.資格 and
	s.入学年度 = s'.入学年度 and
	s.入学期 = s'.入学期 and
	s.入学学年 = s'.入学学年
}
pred 手続き(s,s': 学生, x: 異動履歴, t: 異動種別, k: 学籍区分){
	x not in s.異動歴 and
	x.種別 = t and
	s'.異動歴 = s.異動歴 + x and
	s'.状態 = k and

	その他は変化なし[s,s']
}
 
pred 入学許可手続き(s,s': 学生, x: 異動履歴){
	手続き[s,s',x,入学前,入学予定]
}
pred 入学手続き(s,s': 学生, x: 異動履歴){
	手続き[s,s',x,入学,通常]
}
pred 復学手続き(s,s': 学生, x: 異動履歴){
	手続き[s,s',x,復学,通常]
}
pred 編入手続き(s,s': 学生, x: 異動履歴){
	手続き[s,s',x,編入,通常]
}
pred 転学部学科入手続き(s,s': 学生, x: 異動履歴){
	手続き[s,s',x,転学部学科入,通常]
}
pred 再入学手続き(s,s': 学生, x: 異動履歴){
	手続き[s,s',x,再入学,通常]
}
pred 休学手続き(s,s': 学生, x: 異動履歴){
	手続き[s,s',x,休学,休学中]
}
pred 留学手続き(s,s': 学生, x: 異動履歴){
	手続き[s,s',x,留学,留学中]
}
pred 停学手続き(s,s': 学生, x: 異動履歴){
	手続き[s,s',x,停学,停学中]
}
pred 退学手続き(s,s': 学生, x: 異動履歴){
	手続き[s,s',x,退学,退学済]
}
pred 卒業手続き(s,s': 学生, x: 異動履歴){
	手続き[s,s',x,卒業,卒業済]
}
pred 転籍手続き(s,s': 学生, x: 異動履歴){
	手続き[s,s',x,転籍,転籍済]
}
pred 転学部学科出手続き(s,s': 学生, x: 異動履歴){
	手続き[s,s',x,転学部学科出,転学部学科出済]
}
pred 除籍手続き(s,s': 学生, x: 異動履歴){
	手続き[s,s',x,除籍,除籍済]
}
pred 入学辞退手続き(s,s': 学生, x: 異動履歴){
	手続き[s,s',x,入学辞退,入学辞退済]
}
pred 復籍手続き(s,s': 学生, x: 異動履歴){
	手続き[s,s',x,復籍,通常]
}
```


```alloy
pred init(s: 学生) {
	no s.異動歴
}

fact traces{
	init [first]
	all s: 学生 - last | let s' = next[s] |
		some x: 異動履歴 |
			入学許可手続き[s,s',x] or
			入学手続き[s,s',x] or
			復学手続き[s,s',x] or
			編入手続き[s,s',x] or
			転学部学科入手続き[s,s',x] or
			再入学手続き[s,s',x] or
			休学手続き[s,s',x] or
			留学手続き[s,s',x] or
			停学手続き[s,s',x] or
			退学手続き[s,s',x] or
			卒業手続き[s,s',x] or
			転籍手続き[s,s',x] or
			転学部学科出手続き[s,s',x] or
			除籍手続き[s,s',x] or
			入学辞退手続き[s,s',x] or
			復籍手続き[s,s',x]
}

run {} for 5
```
