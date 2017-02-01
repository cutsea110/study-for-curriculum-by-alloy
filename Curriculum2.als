module Curriculum2

sig 教育課程{
	grade1 : lone 学年教育課程,
	grade2 : lone 学年教育課程,
	grade3 : lone 学年教育課程,
}{
	-- 学年の整合を取る
	some grade1 => grade1.学年 = 1
	some grade2 => grade2.学年 = 2
	some grade3 => grade3.学年 = 3
}

sig 学年教育課程{
	学年: Int
}{
	-- とりうる学年の範囲を限定
	0 < 学年 and 学年 < 4
}

pred 初年度は同じ課程{
	some x: 学年教育課程 | #x.~grade1 > 1
}

pred show{
	初年度は同じ課程[]
}
run show
