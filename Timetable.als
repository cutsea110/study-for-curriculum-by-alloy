---
title: Timetable
layout: default
---

```alloy
private open Base
private open Staff
```


```alloy
sig シラバス{
	対応 : disj 授業,
}

sig 授業{
	実施年度 : 年度,
	実施期 : 期,
	科目 : 科目,
	代表教員 : 教員,
}{
	some this.~対応
}
```
