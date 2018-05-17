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
enum Bool { True, False }

sig 分類{
	分類コード : Int,
}

sig 分野{
	分野コード : Int,
}

abstract sig 要件 {
	要件コード : one Int,
}
sig 卒業要件 extends 要件{
}
sig 資格要件 extends 要件{
}
sig 教職要件 extends 資格要件{
}

sig 学部学科{
	学部 : one Int,
	課程 : one Int,
	学科 : one Int,
	コース : one Int,
}

sig 学則{
	教育課程 : one カリキュラム,
	科目 : one 科目,
	単位 : one Int,
	分類 : one 分類,
	分野 : one 分野,
	配当学年 : set Int,
	必修選択 : one 必修選択区分,
	適用要件 : lone 要件,
	強制フラグ : one Bool,
}{
	配当学年 in (1 + 2 + 3 + 4)
	0 <= 単位 and 単位 <= 4
}

sig カリキュラム{
	年度 : Int,
	対象学科 : one 学部学科,
}

sig 科目{
	科目コード : Int,
}

sig 教員{
	教員番号 : Int,
}

sig 学生{
	学生番号 : Int,
	年次 : one Int,
	所属 : one 学部学科,
	適用教育課程 : one カリキュラム,
	卒業 : one 卒業要件,
	資格 : set 資格要件,
}{
	年次 in (0 + 1 + 2 + 3 + 4)
}

sig シラバス{
	授業 : one 授業,
}

sig 授業{
	科目 : one 科目,
	代表教員 : one 教員,
}

sig 出席情報{
	時間割 : one 時間割,
	学生 : one 学生,
	教室 : one 教室,
	回 : one Int,
	出欠 : one 出欠状態,
}

sig 時間割{
	授業 : one 授業,
	曜時 : set 曜日時限,
	担当 : one 教員,
	副担 : set 教員,
	時間割教室 : set 教室,
	隔週区分 : lone 隔週,
}

abstract sig 施設{
	施設コード : one Int,
}

sig 教室 extends 施設{
}

sig 履修{
	履修者 : one 学生,
	時間割 : one 時間割,
}

fact どんな学生もひとつの時間割を重複して履修できない{
	no t:this/時間割 | some s:this/学生 | some disj r,r':履修 |
		s in r.履修者 and s in r'.履修者 and t in r.時間割 and t in r'.時間割
}

pred show{
	-- 見た目調整の制限
	#曜時 <= 2
}

run show for 5
