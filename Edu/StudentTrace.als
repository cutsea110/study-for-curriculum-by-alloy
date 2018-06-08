---
title: StudentTrace
layout: default
---

```alloy
private open util/ordering [学生]

private open Student
```

```alloy
pred 入学許可手続き(s,s': 学生){
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
	no 異動歴[s]
}

fact traces{
	init [first]
	all s: 学生 - last | let s' = next[s] |
		入学許可手続き[s,s'] or
		入学手続き[s,s'] or
		復学手続き[s,s'] or
		編入手続き[s,s'] or
		転学部学科入手続き[s,s'] or
		再入学手続き[s,s'] or
		休学手続き[s,s'] or
		留学手続き[s,s'] or
		停学手続き[s,s'] or
		退学手続き[s,s'] or
		卒業手続き[s,s'] or
		転籍手続き[s,s'] or
		転学部学科出手続き[s,s'] or
		除籍手続き[s,s'] or
		入学辞退手続き[s,s'] or
		復籍手続き[s,s']
}

run {} for 5
```
