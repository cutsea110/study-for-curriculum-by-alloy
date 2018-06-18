---
title: Applicant
layout: default
---

```alloy
private open Base
private open Admission

private open util/boolean
```

```alloy
sig 志願者{
}

sig 出願{
	受験番号 : Int,
  出願者: 志願者,

	詳細 : some 出願詳細,
	試験成績 : set 成績,
}{
	詳細.~@詳細 in this
	試験成績.~@試験成績 in this
	受験番号 > 0
}

sig 出願詳細{
  応募: 入試募集,
  希望順位: Int,
	合否 : 合否区分,
	手続き完了 : Bool,
}{
	希望順位 > 0
}

sig 成績{
  科目: 科目,
  素点: Int,
}
```

```alloy
assert 志願者に紐付かない出願は存在しない{
	no a: 出願 |
		no a.出願者
}
check 志願者に紐付かない出願は存在しない

assert 出願詳細のない出願は存在しない{
	no a: 出願 |
		no a.詳細
}
check 出願詳細のない出願は存在しない

assert 出願詳細が共有されることはない{
	no d: 出願詳細 |
		some disj a,a': 出願 |
			d in a.詳細 and d in a'.詳細
}
check 出願詳細が共有されることはない
```

```alloy
pred 志願者は複数出願できる{
	some a: 志願者 |
		#a.~出願者 > 1
}
run 志願者は複数出願できる

run {}
```

