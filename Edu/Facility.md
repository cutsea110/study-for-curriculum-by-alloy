---
title: Facility
---

# 施設の概要

大学施設を定義する.

## 依存モデル

```alloy
private open Base
```

## 施設および教室

主に施設管理を目的として定義する.
教室は施設の一種と位置づける.

```alloy
abstract sig 施設{
}

sig 教室 extends 施設{
	キャンパス : キャンパス,
}
```
