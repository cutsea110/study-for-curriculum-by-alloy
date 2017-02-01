module Curriculum1

sig 教育課程{
}

fact 同じ学年の学年教育課程を含まない{
	all x: 教育課程 | #x.~属す = #x.~属す.学年
}

sig 学年教育課程{
	学年: Int,
	属す: lone 教育課程
}{
	-- とりうる学年の範囲を限定
	0 < 学年 and 学年 < 4
}

pred 初年度は同じ課程{
	some x: 学年教育課程 | x.学年 = 1 and #x.属す > 1
}


pred show{
	初年度は同じ課程[] -- not found , but it's trivial!
}
run show
