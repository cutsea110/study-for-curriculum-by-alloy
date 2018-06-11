---
title: HealthMedical
layout: default
---

```alloy
private open Base
private open Student
```

```alloy
sig 学生健康診断{
	対象 : 学生,
	年度 : 年度,
	検診日 : Time,
	医師名 : String,
	発行可 : Bool,
}

abstract sig 検診{
	対象 : 学生,
	年度 : 年度,
	検査日 : Time,
}

sig 胸部 extends 検診{
}

sig 視力 extends 検診{
}

sig 聴力 extends 検診{
}

sig 身体 extends 検診{
}

sig 糖尿 extends 検診{
}

sig 検査 extends 検診{
}
```

