module Curriculum3

sig 教育課程{
}

sig 学年教育課程{
	学年: Int
}{
	-- とりうる学年の範囲を限定
	0 < 学年 and 学年 < 4
}

fact 同じ学年の学年教育課程を含まない{
	all x: 教育課程 | #x.~親.子 = #x.~親.子.学年
}

fact 重複した関係は無い{
	no z: 学年教育課程 | some x: 教育課程 | some disj r1, r2: 関係 {
		x in r1.親 and x in r2.親 and z in r1.子 and z in r2.子
		}
}

sig 関係{
	親: one 教育課程,
	子: one 学年教育課程
}

pred 初学年は同じ課程{
	some x: 学年教育課程 | x.学年 = 1 and #x.~子.親 > 1 
}
pred 常識的な教育課程{
	-- 歯抜けはない.
	no x: 教育課程 | let gs = (x.~親.子).学年 | 1 in gs and 2 not in gs and 3 in gs
}

pred show{
	初学年は同じ課程[]
	常識的な教育課程[]
}
run show for 3 but 9 関係
