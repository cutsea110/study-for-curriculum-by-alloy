---
title: Staff
layout: default
---

```alloy
private open Base
private open Department
```


```alloy
-- 教務課, 入試課, 就職課...
sig 組織 {
}
-- 部長
sig 役職{
}
-- 常勤, 非常勤
sig 職種{
}
```

```alloy
abstract sig 教職員{
	所属 : set 教職員所属,
}

sig 教員 extends 教職員{
}

sig 職員 extends 教職員{
}

sig 教職員所属{
	所属 : lone (学部学科 + 組織),
	役職 : lone 役職,
	職種 : lone 職種,
}
```

```alloy
pred 教職員は学部学科に所属できる{
	some x: 教職員 |
		some x.所属.所属 and x.所属.所属 in 学部学科
}
run 教職員は学部学科に所属できる

pred 教職員は組織に所属できる{
	some x: 教職員 |
		some x.所属.所属 and x.所属.所属 in 組織
}
run 教職員は組織に所属できる

pred 教職員は複数の組織を兼務できる{
	some x: 教職員 |
		#x.所属 > 1
}
run 教職員は複数の組織を兼務できる
```
