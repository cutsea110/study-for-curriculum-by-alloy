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
pred 入学許可手続き(s,s': 学生, x: 異動履歴){
	x.種別 = 入学前 and
	s'.異動歴 = s.異動歴 + x and
	s'.状態 = 入学予定 and

	その他は変化なし[s,s']
}
pred 入学手続き(s,s': 学生){
}
pred 復学手続き(s,s': 学生){
}
pred 編入手続き(s,s': 学生){
}
pred 転学部学科入手続き(s,s': 学生){
}
pred 再入学手続き(s,s': 学生){
}
pred 休学手続き(s,s': 学生){
}
pred 留学手続き(s,s': 学生){
}
pred 停学手続き(s,s': 学生){
}
pred 退学手続き(s,s': 学生){
}
pred 卒業手続き(s,s': 学生){
}
pred 転籍手続き(s,s': 学生){
}
pred 転学部学科出手続き(s,s': 学生){
}
pred 除籍手続き(s,s': 学生){
}
pred 入学辞退手続き(s,s': 学生){
}
pred 復籍手続き(s,s': 学生){
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
			入学許可手続き[s,s',x]
// or
//		入学手続き[s,s'] or
//		復学手続き[s,s'] or
//		編入手続き[s,s'] or
//		転学部学科入手続き[s,s'] or
//		再入学手続き[s,s'] or
//		休学手続き[s,s'] or
//		留学手続き[s,s'] or
//		停学手続き[s,s'] or
//		退学手続き[s,s'] or
//		卒業手続き[s,s'] or
//		転籍手続き[s,s'] or
//		転学部学科出手続き[s,s'] or
//		除籍手続き[s,s'] or
//		入学辞退手続き[s,s'] or
//		復籍手続き[s,s']
}

run {}
```
