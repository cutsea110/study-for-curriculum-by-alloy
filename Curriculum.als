module Curriculum


enum 曜日 { 日, 月, 火, 水, 木, 金, 土 }
enum 期 { 前期, 後期, 通期 }
enum 出欠状態 { 出席, 欠席, 未判定 }
enum 必修選択区分 { 必修, 選択 }
enum 週間隔 { 毎週, 隔週 }
enum フラグ { On, Off }
enum 試験区分 { 通常, 追試, 再試 }
enum 試験時期 { 前期中間, 前期末, 後期中間, 後期末 }
enum 処理 { 何もしない, 進級, 卒業, 卒研受講制限, 退学 }
enum 年次 { 零年次, 一年次, 二年次, 三年次, 四年次 }
enum 評価コード { S, A, B, C, D, F, N }
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
sig 科目数{
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
	取り得る評価 = S + A + B + C + D
	単位認定評価 = S + A + B + C
	GPA = (S -> GPA_4) + (A -> GPA_3) + (B -> GPA_2) + (C -> GPA_1) + (D -> GPA_0)
}
one sig 認定評価 extends 評価基準{
}{
	取り得る評価 = N + F
	単位認定評価 = N
	GPA = (N -> GPA_0) + (F -> GPA_0)
}
one sig 評価不要 extends 評価基準{
}{
	取り得る評価 = A
	単位認定評価 = A
	GPA = (A -> GPA_3)
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
	必修科目数下限: 科目数,
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

abstract sig 学生{
	学年 : 年次,
	所属 : 学部学科,
	適用 : カリキュラム,
	卒業進級対象 : フラグ,
	留学生フラグ : フラグ,
	教職 : set 教職要件,
	資格 : set (資格要件 - 教職要件),
	入学年度 : 年度,
	入学期 : 期,
	入学学年 : 年次,
}

sig 正規生 extends 学生{
}{
	適用 in 正規カリキュラム
	卒業進級対象 = On
}
sig 非正規生 extends 学生{
}{
	卒業進級対象 = Off
}

sig シラバス{
	対応 : 授業
}

sig 授業{
	実施年度 : 年度,
	実施期 : 期,
	科目 : 科目,
	代表教員 : 教員,
}{
	-- 紐付くシラバスはひとつ
	one this.~対応
}

sig 出席情報{
	時間割 : 時間割,
	学生 : 学生,
	教室 : 教室,
	回 : 授業回,
	出欠 : 出欠状態,
}

sig 時間割{
	実施年度 : 年度,
	実施期 : 期,
	授業 : 授業,
	曜時 : set (曜日 -> Int),
	担当 : 教員,
	副担 : set 教員,
	教室時間割 : set 教室,
	週間隔区分 : one 週間隔,
}{
	all n : 曜時[曜日] | n > 0
}

abstract sig 施設{
}

sig 教室 extends 施設{
}

sig 履修{
	履修者 : 学生,
	履修時間割 : 時間割,
}{
	履修科目[this] in 全履修可能科目[履修者]
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

--------------------------
-- Global Facts
--------------------------

fact カリキュラム内の学則で同一科目で評価基準が異なってはならない{
	all c:カリキュラム | all disj r,r':c.~含まれる |
		r.科目 = r'.科目 => r.評価基準.取り得る評価 = r'.評価基準.取り得る評価
}

fact 重複する履修登録はない{
	no t:this/時間割 | some s:this/学生 | some disj r,r':履修 |
		s in r.履修者 and s in r'.履修者 and t in r.履修時間割 and t in r'.履修時間割
}

fact 成績の評価は学則の評価基準の範囲にある必要がある{
	all s: 成績 | let rs = {r : s.学生.適用.~含まれる | r.科目 = s.科目} |
		s.評価 in rs.評価基準.取り得る評価
}

fact 振替先は適用カリキュラム内にある{
	all c: 振替科目 | c.先科目 in c.対象.適用.~含まれる.科目  
}

fact 同じ振替元の振替は持てない{
	all disj c,c': 振替科目 |
		c.対象 = c'.対象 => c.元科目 != c'.元科目
}

fact 単位修得できる成績は学生・科目ごとに高々ひとつしかない{
	no s: this/学生 | some disj e,e': s.~(成績 <: 学生) |
		e.科目 = e'.科目 and 単位になる[e] and 単位になる[e']
}

--------------------------
-- Utilities
--------------------------

fun 評価者(r: 履修) : 教員{
	r.履修時間割.担当
}

fun 講師陣(t: this/時間割) : set 教員{
	t.(担当 + 副担)
}

fun 講師陣(r: 履修) : set 教員{
	講師陣[r.履修時間割]
}

fun 授業内容(t: this/時間割) : シラバス{
	t.授業.~対応
}

fun 履修授業(r: 履修) : this/授業{
	r.履修時間割.授業
}

fun 履修科目(r: 履修) : this/科目{
	履修授業[r].科目
}

fun 履修場所(r: 履修) : set this/教室{
	r.履修時間割.教室時間割
}

fun 履修時期(r: 履修) : this/年度 -> this/期{
	let t = r.履修時間割 |
		t.実施年度 -> t.実施期
}

fun 履修曜時(r: 履修) : set (曜日 -> Int) -> 週間隔{
	let t = r.履修時間割 |
		t.曜時 -> t.週間隔区分
}

fun 試験成績科目(t: 試験成績) : this/科目{
	t.時間割.授業.科目
}

fun 出席情報科目(a: 出席情報) : this/科目{
	a.時間割.授業.科目
}

fun 基本履修可能科目(s: this/学生) : set this/科目{
	修得可能学則[s].科目
}

fun 修得可能学則(s: this/学生) : set 学則{
	s.適用.~含まれる
}

fun 振替履修可能科目(s: this/学生) : set this/科目{
	s.~(振替科目 <: 対象).元科目
}

fun 全履修可能科目(s: this/学生) : set this/科目{
	基本履修可能科目[s] + 振替履修可能科目[s]
}

fun GPA(s: 成績) : set GPA値{
	{r : 学則 | r in 修得可能学則[s.学生] and r.科目 = s.科目}.評価基準.GPA[s.評価]
}

pred 学部学科が同じ(s,s': this/学生){
	s.所属 = s'.所属
}

pred 学年が同じ(s,s': this/学生){
	s.学年 = s'.学年
}

pred カリキュラムが同じ(s,s': this/学生){
	s.適用 = s'.適用
}

pred 時間割が同じ(r,r': 履修){
	r.履修時間割 = r'.履修時間割
}

pred 単位になる(s: 成績){
	some r: 修得可能学則[s.学生] |
		s.科目 = r.科目 and s.評価 in r.評価基準.単位認定評価
}

--------------------------------------
-- Specifications and Properties
--------------------------------------

assert シラバスと授業は対{
	#シラバス = #this/授業
}
check シラバスと授業は対

assert 任意の成績の科目は適用カリキュラムの学則に含まれる{
	all s: 成績 | s.科目 in 修得可能学則[s.学生].科目
}
check 任意の成績の科目は適用カリキュラムの学則に含まれる

assert 任意の成績のGPAは一意に決まる{
	all s: 成績 | #GPA[s] = 1
}
check 任意の成績のGPAは一意に決まる

assert 同じ科目に対して単位認定可能な成績は一意に決まる{
	no g: this/学生 | some disj s,s': g.~(成績 <: 学生) |
		s.科目 = s'.科目 and 単位になる[s] and 単位になる[s']
}
check 同じ科目に対して単位認定可能な成績は一意に決まる

run 正規生が存在しうる{
	some 正規生
}

run 非正規生が存在しうる{
	some 非正規生
}

run 同じ学科の学生に異なるカリキュラムを適用できる{
	some disj s,s': this/学生 |
		学部学科が同じ[s,s'] and not カリキュラムが同じ[s,s']
}

run 異なる学科の学生が同じ時間割を履修できる{
	some disj r,r': 履修 |
		not 学部学科が同じ[r.履修者,r'.履修者] and 時間割が同じ[r,r']
}

run 適用カリキュラムにない科目を履修できる{
	some r: 履修 |
		履修科目[r] not in 基本履修可能科目[r.履修者]
}

run 異なるカリキュラムの学生が同じ時間割を履修できる{
	some disj r,r': 履修 |
		not カリキュラムが同じ[r.履修者,r'.履修者] and 時間割が同じ[r,r']
}

run 異なる学年の学生が同じ時間割を履修できる{
	some disj r,r': 履修 |
		not 学年が同じ[r.履修者,r'.履修者] and 時間割が同じ[r,r']
}

run 時間割がなくても成績は作れる{
	no t: this/時間割 | some s: 成績 |
		s.科目 = t.授業.科目
}

run 履修がなくても成績は作れる{
	no r: 履修 | some s: 成績 | 
		s.学生 = r.履修者 and s.科目 = 履修科目[r]
}

run 試験成績はなくても成績はつけられる{
	no t: 試験成績 | some s: 成績 |
		s.学生 = t.学生 and s.科目 = 試験成績科目[t]
}

run 出欠は取らなくても成績はつけられる{
	no a: 出席情報 | some s: 成績 |
		a.学生 = s.学生 and 出席情報科目[a] = s.科目
}

run 履修がなくても出欠はつけられる{
	no r: 履修 | some a: 出席情報 |
		r.履修者 = a.学生 and 履修科目[r] = 出席情報科目[a]
}

run 単独科目授業を履修できる{
	some disj r,r': 履修 |
		履修科目[r] = 履修科目[r'] and
		履修時期[r] = 履修時期[r'] and
		履修場所[r] = 履修場所[r'] and
		履修曜時[r] = 履修曜時[r'] and
		評価者[r] = 評価者[r']
}

run 分割科目を履修できる{
	some disj r,r': 履修 |
		履修科目[r] = 履修科目[r'] and
		履修時期[r] = 履修時期[r'] and
		履修場所[r] != 履修場所[r'] and
		評価者[r] != 評価者[r']
}

run 一貫分割型複数担当科目を履修できる{
	some disj r,r': 履修 |
		履修科目[r] = 履修科目[r'] and
		履修時期[r] = 履修時期[r'] and
		評価者[r] = 評価者[r'] and
		#講師陣[r] > 1 and #講師陣[r'] > 1
}

run 途中分割型複数担当科目を履修できる{
	some disj r,r': 履修 |
		履修科目[r] = 履修科目[r'] and
		履修時期[r] = 履修時期[r'] and
		履修場所[r] != 履修場所[r'] and some (履修場所[r] & 履修場所[r']) and
		評価者[r] != 評価者[r'] and some (講師陣[r] & 講師陣[r'])
}

run シリーズ科目を履修できる{
	some disj r,r': 履修 |
		履修科目[r] = 履修科目[r'] and
		履修時期[r] = 履修時期[r'] and
		履修場所[r] = 履修場所[r'] and
		評価者[r] = 評価者[r'] and #講師陣[r] > 1 and #講師陣[r'] > 1
}

run 複数の教員による時間割が作れる{
	some t: this/時間割 |
		#講師陣[t] > 1
}

run 複数の教室を使った時間割が作れる{
	some t: this/時間割 |
		#教室時間割[t] > 1
}

run 複数の時間割が同じ教室を共有できる{
	some disj t,t': this/時間割 |
		some (教室時間割[t] & 教室時間割[t'])
}

run 卒業要件が作れる{
	some 卒業要件
}
run 卒業要件の判定条件が作れる{
	some j: 要件判定 | some r: 卒業要件 |
		r in j.~属する.~属する.対象要件
}

run 教職要件が作れる{
	some 教職要件
}
run 教職要件の判定条件が作れる{
	some j: 要件判定 | some r: 教職要件 |
		r in j.~属する.~属する.対象要件
}

run その他の資格要件が作れる{
	some (資格要件 - 教職要件)
}
run その他の資格要件の判定条件が作れる{
	some j: 要件判定 | some r: (資格要件 - 教職要件) |
		r in j.~属する.~属する.対象要件
}

run 同じ科目の成績を複数持ち得る{
	some g: this/学生 | some disj s,s': g.~(成績 <: 学生) |
		s.科目 = s'.科目
}


--------------------------
-- Preds and Assertions
--------------------------

run 例示せよ{
	-- 見た目調整の制限
	#曜時 <= 2
}

