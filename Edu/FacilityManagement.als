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
enum 管理種別 { 時間割, 予約, 補講, 集中授業 }
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

sig 施設利用{
	年度 : 年度,
	期 : 期,
	日付 : Time,
	曜時 : 曜日時限,
	場所 : 施設,
	授業 : lone 授業,
	生成源 : lone 管理種別,
}
```


```alloy
pred 特定日時の施設利用ができる{
	some x: 施設利用 | 施設利用の登録[x]
}
run 特定日時の施設利用ができる

pred 時間割による施設利用ができる{
	some x: 施設利用 | 施設利用の登録[x] and x.生成源 = 時間割 and some x.授業
}
run 時間割による施設利用ができる

pred 補講による施設利用ができる{
	some x: 施設利用 | 施設利用の登録[x] and x.生成源 = 補講 and some x.授業
}
run 補講による施設利用ができる

pred 予約による施設利用ができる{
	some x: 施設利用 | 施設利用の登録[x] and x.生成源 = 予約
}
run 予約による施設利用ができる

```

```alloy
pred 施設利用の登録(x: 施設利用){
	some x.日付 and some x.曜時 and some x.場所
}
```
