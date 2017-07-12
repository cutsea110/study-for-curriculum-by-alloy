module Admission

enum 年度 { Y2016, Y2017 }
enum 学部課程学科コース{
  経営学科,
  経済学科
}
enum 定員 {N80, N100 }
enum code { X01, X02 }
enum desired_order { D1, D2 }
enum 評価方法 {A, B} -- 重みとか調整点とかもろもろ
enum 制度種別 {前期, 中期}
enum 得点 {P60, P80}

sig 入試制度{
  年度: one 年度,
  制度: one 制度種別,
}{
  -- 1つ以上は募集がある.
  some this.~募集
}

sig 入試募集{
  募集: one 入試制度,
  学科コース: one 学部課程学科コース,
  募集定員: 定員,
}{
  -- 1つ以上は評価基準がある.
  some this.~適用
}

sig 評価項目 {
  適用: one 入試募集,
  科目コード: code,
  評価関数: one 評価方法,
}

sig 志願者{
}{
  -- 1つ以上出願がある,
  some this.~出願者
}

sig 出願{
  出願者: one 志願者,
}{
  -- 1つ以上は出願詳細がある
  some this.~orig
}

sig 出願詳細{
  orig: one 出願,
  希望: one 入試募集,
  希望順位: desired_order,
}

sig 成績{
  受験: one 出願,
  科目コード: code,
  素点: one 得点,
}

-----

fact 成績は募集の評価の部分集合{
  all x: 出願 | x.~受験.科目コード in x.~orig.希望.~適用.科目コード
}

fact 成績は出願内でユニーク{
  all x: 出願 | #x.~受験 = #x.~受験.科目コード
}

fact 志願者は年度をまたがない{
  all x: 志願者 | one x.~出願者.~orig.希望.募集.年度
}

fact 同じ募集に複数出願を持つ志願者はいない {
  no b: 入試募集 | some disj s, s': 出願詳細 | some a: 志願者 {
    b in s.希望 and b in s'.希望 and (s.orig + s'.orig) in a.~出願者
  }
}

pred show {
}
run show for 3
