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
enum desired_order { D1, D2, D3, D4, D5 }

sig 入試制度{
  年度: one 年度,
  募集: some 入試募集,
}

sig 入試募集{
  募集元: one 学部課程学科コース,
  募集定員: 定員,
  評価基準: some 評価項目,
}{
  -- A01: 入試募集には唯一の入試制度がいる
  -- こおfactをRDBのスキーマで実現する場合には,このテーブルに入試制度へのID(NOT NULL)を保持することに相当する.
  one this.~募集
}

sig 評価項目 {
  科目コード: code,
  素点範囲: scoreRange,
  乗数: weight,
  調整: offset,
}

sig 志願者{
  出願: some 志願,
}{
}

sig 志願{
  希望: one 入試募集,
  希望順位: desired_order,
}{
  -- A02: 志願には唯一の志願者がいる.
  -- こおfactをRDBのスキーマで実現する場合には,このテーブルに志願者へのID(NOT NULL)を保持することに相当する.
  one this.~出願
}

-- これは志願者および志願にバリデーションロジックが要.
fact 同じ募集に複数出願はできない {
  no b: 入試募集 | some disj s, s': 志願 | some a: 志願者 {
    b in s.希望 and b in s'.希望 and (s + s') in a.出願
  }
}

-- A01
assert 入試募集の共有はない {
  all x: 入試制度 | x.募集.~募集 in x
}
check 入試募集の共有はない

-- A02
assert 出願の共有はない {
  all x: 志願者 | x.出願.~出願 in x
}
check 出願の共有はない

pred show {
}
run show for 3 but exactly 2 入試制度, exactly 3 入試募集, exactly 3 志願者, 5 志願
