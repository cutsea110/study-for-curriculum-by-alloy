---
title: Department
---

# 学生の所属組織の概要

学生が所属する組織を定義する.

## 依存モデル

```alloy
private open Base
```

## 学部学科

学部を最上位階層として順に4段階の階層構造を想定している.
ただし,現状では以下のシグネチャの通り学部学科は4レベルの組合わせにすぎない.

```alloy
sig 学部学科{
	学部 : 学部,
	課程 : 課程,
	学科 : 学科,
	コース : コース,
}
```
