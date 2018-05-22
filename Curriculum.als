module Curriculum

enum 曜日時限 { 月1, 月2, 月3, 月4, 月5, 月6, 月7, 月8,
								火1, 火2, 火3, 火4, 火5, 火6, 火7, 火8,
								水1, 水2, 水3, 水4, 水5, 水6, 水7, 水8,
								木1, 木2, 木3, 木4, 木5, 木6, 木7, 木8,
								金1, 金2, 金3, 金4, 金5, 金6, 金7, 金8,
								土1, 土2, 土3, 土4, 土5, 土6, 土7, 土8,
								日1, 日2, 日3, 日4, 日5, 日6, 日7, 日8
							}

enum 出欠状態 { 出席, 欠席, 未判定 }
enum 必修選択区分 { 必修, 選択 }
enum 隔週 { 奇, 偶 }
enum フラグ { On, Off }
enum 試験区分 { 通常, 追試, 再試 }
enum 試験時期 { 前期中間, 前期末, 後期中間, 後期末 }
enum 処理 { 何もしない, 進級, 卒業, 卒研受講制限, 退学 }
enum 年次 { 零年次, 一年次, 二年次, 三年次, 四年次 }
enum 評価コード { S, A, B, C, D, E, F, N }
enum GPA値 { GPA_0, GPA_1, GPA_2, GPA_3, GPA_4 }

sig 年度{
}

sig 学部{
}
sig 課程{
}
sig 学科{
}
sig コース{
}

sig 分類{
}
sig 分野{
}
sig グループ{
}
sig 科目専門区分{
}

sig 単位数{
}

sig 授業回{
}

abstract sig 評価基準{
	取り得る評価 : set 評価コード,
  単位認定評価 : set 評価コード,
	GPA : 取り得る評価 -> GPA値,
}{
	単位認定評価 in 取り得る評価
}
one sig 段階評価 extends 評価基準{
}{
	取り得る評価 = A + B + C + D + E + F
	単位認定評価 = A + B + C + D
	GPA = (A -> GPA_4) + (B -> GPA_3) + (C -> GPA_2) + (D -> GPA_1) + (E -> GPA_0) + (F -> GPA_0) 
}
one sig 認定評価 extends 評価基準{
}{
	取り得る評価 = N + D
	単位認定評価 = N
	GPA = (N -> GPA_0) + (D -> GPA_0)
}

abstract sig 要件 {
}
one sig 卒業要件 extends 要件{
}
sig 資格要件 extends 要件{
}
sig 教職要件 extends 資格要件{
}
sig 要件判定{
	適用: カリキュラム,
	学科: 学科,
	年次: 年次,
	GPA下限: GPA値,
	判定順: Int,
}{
	判定順 >= 0
}
sig 判定条件{
	属する: 要件判定,
	単位数下限: 単位数,
	必修単位数下限: 単位数,
	必修科目数下限: 単位数,
	必修完了: フラグ,
	在籍年数超過: フラグ,
}
sig 判定条件科目専門区分{
	属する: 判定条件,
	対象要件: 要件,
	対象区分 : 科目専門区分,
}
sig 判定後処理{
	属する: 要件判定,
	実行する: 処理,
}

sig 学部学科{
	学部 : 学部,
	課程 : 課程,
	学科 : 学科,
	コース : コース,
}

sig 学則{
	含まれる : カリキュラム,
	科目 : 科目,
	単位 : 単位数,
	評価基準 : 評価基準,
	分類 : 分類,
	分野 : 分野,
	グループ : グループ,
	配当学年 : set 年次,
	必修選択 : 必修選択区分,
	CAP制限対象 : フラグ,
	適用要件 : lone 要件,
	科目専門区分 : 科目専門区分,
	強制 : フラグ,
}

sig カリキュラム{
	年度 : 年度,
	対象学科 : 学部学科,
}

sig 正規カリキュラム extends カリキュラム{
}{
	卒業要件 in this.~含まれる.適用要件
}

sig 科目{
}

sig 教員{
}

sig 学生{
	年次 : 年次,
	所属 : 学部学科,
	適用 : カリキュラム,
	教職 : set 教職要件,
	資格 : set (資格要件 - 教職要件),
}

sig シラバス{
	対応 : 授業
}

sig 授業{
	科目 : 科目,
	代表教員 : 教員,
}{
	-- 紐付くシラバスはひとつ
	one this.~対応
}

assert シラバスと授業は対{
	#シラバス = #this/授業
}
check シラバスと授業は対

sig 出席情報{
	時間割 : 時間割,
	学生 : 学生,
	教室 : 教室,
	回 : 授業回,
	出欠 : 出欠状態,
}

sig 時間割{
	授業 : 授業,
	曜時 : set 曜日時限,
	担当 : 教員,
	副担 : set 教員,
	教室時間割 : set 教室,
	隔週区分 : lone 隔週,
}

abstract sig 施設{
}

sig 教室 extends 施設{
}

sig 履修{
	履修者 : 学生,
	時間割 : 時間割,
}

fact 重複する履修登録はない{
	no t:this/時間割 | some s:this/学生 | some disj r,r':履修 |
		s in r.履修者 and s in r'.履修者 and t in r.時間割 and t in r'.時間割
}

sig 試験成績{
	学生 : 学生,
	時間割 : 時間割,
	区分 : 試験区分,
	期 : 試験時期,
	評価 : 評価コード,
}

sig 成績{
	学生 : 学生,
	科目 : 科目,
	評価 : 評価コード,
}

sig 振替科目{
	対象: 学生,
	元科目: 科目,
	先科目: 科目,	
}{
	元科目 != 先科目
}

fact 振替先は適用カリキュラム内にある{
	all c: 振替科目 | c.先科目 in c.対象.適用.~含まれる.科目  
}
fact 同じ振替元の振替は持てない{
	all disj c,c': 振替科目 |
		c.対象 = c'.対象 => c.元科目 != c'.元科目
}

pred show{
	-- 見た目調整の制限
	#曜時 <= 2
	some 正規カリキュラム
}

run show
