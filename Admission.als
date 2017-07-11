module Admission

enum 年度 { Y2015, Y2016, Y2017, Y2018, Y2019, Y2020 }
enum 学部課程学科コース{
  経営学科,
  経済学科
}
enum 定員 {N40, N60, N80, N100, N200, N500 }
enum code { X01, X02, X03, X04, X05, X06, X07, X08, X09, X10 }
enum scoreRange {R0_100, R0_200, R0_250, R1_5}
enum weight { W0, W1_0, W1_5, W2_0, W5_0 }
enum offset {OFF0, OFF10, OFF20, OFF30 }

sig 入試制度{
  年度: one 年度,
  募集: set 入試募集,
}

sig 入試募集{
  募集元: one 学部課程学科コース,
  募集定員: 定員,
  評価基準: some 評価項目
}{
  -- A01: 複数の入試制度から参照されることはない.
  no disj x, y: 入試制度 | this in x.募集 and this in y.募集
}

sig 評価項目 {
  科目コード: code,
  素点範囲: scoreRange,
  乗数: weight,
  調整: offset,
}

-- A01
assert 入試募集の共有はない {
  all x : 入試制度 | x.募集.~募集 in x
}
check 入試募集の共有はない

pred show {
}
run show
