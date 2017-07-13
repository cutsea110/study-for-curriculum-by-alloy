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

---------------------
-- ファクト関係
---------------------

pred 成績は募集の評価項目の部分集合(s: 出願){
  s.~受験.科目コード in s.~orig.希望.~適用.科目コード
}

pred 科目成績はユニーク(s: 出願){
  #s.~受験 = #s.~受験.科目コード
}

pred 年度をまたぐ(a: 志願者){
  #a.~出願者.~orig.希望.募集.年度 > 1
}

pred 同じ募集に複数出願している(a: 志願者) {
  some b: 入試募集 | some disj s, s': 出願詳細 {
    b in s.希望 and b in s'.希望 and (s.orig + s'.orig) in a.~出願者
  }
}

pred 複数の入試制度にまたがる(s: 出願){
  #s.~orig.希望.募集 > 1
}

-- これは明治なんかはある
pred 同じ入試制度に複数出願している(a: 志願者){
  some disj s, s': 出願 | some n: 入試制度 {
    a in s.出願者 and a in s'.出願者 and n in s.~orig.希望.募集 and n in s'.~orig.希望.募集
  }
}

pred 単願している(a: 志願者){
  -- 出願詳細が1つだけ
  one a.~出願者.~orig
}

pred 併願している(a: 志願者){
  -- 出願が2つ以上
  #a.~出願者 > 1
}

pred 同時併願している(x: 志願者){
  -- 出願詳細が2つ以上の出願がある
  some s: x.~出願者 | #s.~orig > 1
}
pred 入試制度複数{
  #入試制度 > 1
}
pred 志願者複数{
  #志願者 > 1
}

pred show {
  -- 見た目の奇妙さを回避したいだけ
  all s: 出願 | 成績は募集の評価項目の部分集合[s] and 科目成績はユニーク[s]
  -- 大前提にしよう
  no x: 志願者 | 年度をまたぐ[x]
  no x: 志願者 | 同じ募集に複数出願している[x]

  -- この辺からどうか?
  no s: 出願 | 複数の入試制度にまたがる[s]
  some a: 志願者 | 同じ入試制度に複数出願している[a]
--  some a: 志願者 | 単願している[a]

--  some x: 志願者 | 併願している[x]
--  some y: 志願者 | 同時併願している[y]
--  入試制度複数
--  志願者複数
}
run show for 4 but exactly 1 志願者

