---
title: FacilityManagement
layout: default
---

```alloy
open Base
open Facility
open Staff
open Student
open Timetable
open TimetableExtensions
```

```alloy
-- enum 管理種別 { 時間割, 施設, 補講, 集中授業 }
```

```alloy
sig 施設予約{
	年度 : 年度,
	期 : 期,
	日付 : Time,
	曜時 : 曜日時限,	
	場所 : 施設,
	予約者 : 教員 + 職員 + 学生,
}

sig 施設管理{
	年度 : 年度,
	期 : 期,
	日付 : Time,
	曜時 : 曜日時限,
	場所 : 施設,
	授業 : lone 授業,
	生成源 : lone (時間割 + 施設予約 + 補講),
}
```


```alloy
pred 特定日時の施設管理ができる{
	some x: 施設管理 |
		some x.日付 and some x.曜時 and some x.場所
}
run 特定日時の施設管理ができる

```
