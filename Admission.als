module Admission

enum 年度 { Y2015, Y2016, Y2017, Y2018, Y2019, Y2020 }
enum 学部課程学科コース{
  経営学科,
  経済学科
}

sig 入試制度{
  年度: one 年度,
  募集: set 入試募集,
}

sig 入試募集{
  募集元: one 学部課程学科コース,
  募集定員: Int,
}{
  -- 複数の入試制度から参照されることはない.
  no disj x, y: 入試制度 | this in x.募集 and this in y.募集
}

assert 入試募集の共有 {
  no b: 入試募集 | some disj x, y: 入試制度 {
     b in x.募集 and b in y.募集
  }
}
check 入試募集の共有

pred show {
}
run show
