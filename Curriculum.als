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
enum Bool { True, False }

sig 科目{
	科目コード : Int
}

sig 教員{
	教員番号 : Int
}

sig 学生{
	学生番号 : Int
}

sig シラバス{
}

sig 授業{
	科目 : one 科目,
	代表教員 : one 教員,
	時間割 : some 時間割,
	シラバス : one シラバス
}

sig 出席情報{
	学生 : one 学生,
	教室 : one 教室,
	回 : Int,
	出欠 : one 出欠状態
}

sig 時間割{
	曜時 : set 曜日時限,
	担当 : one 教員,
	副担 : set 教員,
	履修者 : set 履修,
	出欠 : set 出席情報,
	時間割教室 : set 教室,
	隔週 : one Bool
}

sig 施設{
}

sig 教室 extends 施設{
	教室番号 : Int
}

sig 履修{
	履修者 : one 学生
}

pred show{
}

run show
