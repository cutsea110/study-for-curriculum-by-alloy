---
title: TimetableExtensions
layout: default
---

```alloy
private open Base
private open Facility
private open Staff
private open Timetable

```

```alloy
enum 休講理由 { 病欠, 公用_公共機関等からの要請業務, 学会, 校用_兼任講師の本務校用事, 海外出張, 私用, その他, 教室変更, 校務 }
enum 時限 { 第１限, 第２限, 第３限, 第４限, 第５限, 第６限, 第７限, 第８限 }
```

```alloy
sig 休講{
	代表年度 : 年度,
	代表期 : 期,
	代表授業 : 授業,
	年度 : 年度,
	期 : 期,
	授業 : 授業,

	休講日 : Time,
	時間割 : 時間割,
	教室: 教室,
	理由 : lone 休講理由,
	お知らせ先 : set 教員,
}

sig 補講{
	代表年度 : 年度,
	代表期 : 期,
	代表授業 : 授業,
	年度 : 年度,
	期 : 期,

	補講日 : Time,
	時限 : some Int,
	対象 : lone 休講,
	教室 : some 教室,
	お知らせ先 : set 教員,
}{
	時限 > 0
}
```

```alloy
pred 休講を登録できる{
	some 休講
}
run 休講を登録できる
pred 休講理由を指定できる{
	some x: 休講 |
		some x.理由
}
run 休講理由を指定できる

pred 補講を登録できる{
	some 補講
}
run 補講を登録できる
pred 補講の根拠となった休講を紐付けることができる{
	some x: 補講 |
		some x.対象
}
run 補講の根拠となった休講を紐付けることができる
pred 休講してなくても補講を登録できる{
	some x: 補講 |
		no x.対象
}
run 休講してなくても補講を登録できる
pred 複数コマの補講を登録できる{
	some x: 補講 |
		#x.時限 > 1
}
run 複数コマの補講を登録できる
pred 複数教室を使った補講を登録できる{
	some x: 補講 |
		#x.教室 > 1
}
run 複数教室を使った補講を登録できる

```
