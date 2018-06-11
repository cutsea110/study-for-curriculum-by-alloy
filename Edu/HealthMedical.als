---
title: HealthMedical
layout: default
---

```alloy
private open Base
private open Student
```

```alloy
sig HealthMedical{
	対象 : 学生,
	年度 : 年度,
	検診日 : Time,
	医師名 : String,
	発行可 : Bool,
}
```

