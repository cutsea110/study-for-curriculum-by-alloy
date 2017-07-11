module Admission

enum 年度 { Y2015, Y2016, Y2017, Y2018, Y2019, Y2020 }
enum 学部課程学科コース{
  経営学科,
  経済学科
}
enum 定員 {N40, N60, N80, N100, N200, N500 }

sig 入試制度{
  年度: one 年度,
  募集: set 入試募集,
}

sig 入試募集{
  募集元: one 学部課程学科コース,
  募集定員: 定員,
}{
  -- A01: 複数の入試制度から参照されることはない.
  no disj x, y: 入試制度 | this in x.募集 and this in y.募集
}

-- A01
assert 入試募集の共有はない {
  all x : 入試制度 | x.募集.~募集 in x
}
check 入試募集の共有はない

pred show {
}
run show
