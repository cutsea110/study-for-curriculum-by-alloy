module Curriculum

sig 教育課程{
	grades: set 学年教育課程
}{
	-- 全の学年は異なる
	#grades = #grades.学年
}

-- 修得単位や進級卒業要件の何にカウントするかなどスロット情報を含むが捨象する.
-- 抽象化しているけど学科が違えば別である必要があり入学年度や学年でも異なりうる.
-- その為に学年教育課程のレベルで排他的になる.
-- このあたりを前提にモデル化している.
sig 科目編成{
}

sig 学年教育課程{
	学年: Int,
	編成: set 科目編成
}{
	-- 1-3に限定
	0 < 学年 and 学年 < 4
	編成.~(@編成) = this
}

sig 学生{
	適用教育課程: one 教育課程
}

pred 初年度は同じ課程{
	some x: 学年教育課程 | x.学年 = 1 and #x.~grades > 1
}
pred 常識的な教育課程{
	-- 歯抜けはない.
	no x: 教育課程 | let gs = x.grades.学年 | 1 in gs and 2 not in gs and 3 in gs
}

pred show {
	初年度は同じ課程[]
	常識的な教育課程[]
}
run show for 3 but 5 学年教育課程, 10 科目編成
