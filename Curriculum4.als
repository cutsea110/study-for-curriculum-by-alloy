module Curriculum4

sig 教育課程{
	grade1: lone 学年教育課程1,
	grade2: lone 学年教育課程2,
	grade3: lone 学年教育課程3
}

abstract sig 学年教育課程{
	学年: Int
}

sig 学年教育課程1 extends 学年教育課程{
}{
	学年 = 1
}
sig 学年教育課程2 extends 学年教育課程{
}{
	学年 = 2
}
sig 学年教育課程3 extends 学年教育課程{
}{
	学年 = 3
}

pred 初年度は同じ課程{
	some x: 学年教育課程1 | #x.~grade1 > 1
}
pred 常識的な教育課程{
	-- 歯抜けはない.
	no x: 教育課程 | let gs = (x.grade1+x.grade2+x.grade3).学年 | 1 in gs and 2 not in gs and 3 in gs
}

pred show{
	初年度は同じ課程[]
	常識的な教育課程[]
}
run show
