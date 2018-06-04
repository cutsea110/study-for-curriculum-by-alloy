module Education

private open Base
private open Curriculum
private open CurriculumExtensions
private open Department
private open Facility
private open Staff
private open Student
private open Timetable



sig 出席情報{
	時間割 : 時間割,
	学生 : 学生,
	教室 : 教室,
	回 : 授業回,
	出欠 : 出欠状態,
}


sig 履修申請{
	申請者 : 学生,
	申請時間割 : 時間割,
	状態 : 履修申請状態,
	結果 : 履修申請結果,
	再履修 : フラグ,
}

sig 履修{
	履修者 : 学生,
	履修時間割 : 時間割,
	再履修 : フラグ,
	由来する : lone 履修申請,
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


--------------------------
-- Global Facts
--------------------------

fact カリキュラム内の学則で同一科目で評価基準が異なってはならない{
	all c:カリキュラム | all disj r,r':c.~含まれる |
		r.科目 = r'.科目 => r.評価基準.取り得る評価 = r'.評価基準.取り得る評価
}

fact 重複する履修登録はない{
	no g: this/学生 |
		some disj r,r': g.~履修者 |
			r.履修時間割 = r'.履修時間割
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

fact 単位修得できる成績は学生科目ごとに高々ひとつしかない{
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

fun 履修曜時(r: 履修) : set 曜日時限 -> 週間隔{
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

fun 全履修可能時間割(s: this/学生) : set this/時間割{
	全履修可能科目[s].~科目.~授業
}

fun GPA(s: 成績) : set GPA値{
	{r : 学則 | r in 修得可能学則[s.学生] and r.科目 = s.科目}.評価基準.GPA[s.評価]
}

fun 判定対象要件(j: 要件判定) : set 要件{
	j.~属する.~属する.対象要件
}

fun 後処理(j: 要件判定) : set 処理{
	j.~属する.実行する
}

fun 代表時間割(j: this/時間割) : set this/時間割{
	j.*代表 & 代表時間割
}

fun 合併時間割(j: this/時間割) : set this/時間割{
	代表時間割[j].*(~代表)
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

pred 卒業要件に対する判定(j: 要件判定){
	判定対象要件[j] in 卒業要件
}

--------------------------------------
-- Specifications and Properties
--------------------------------------

assert シラバスと授業は同数ある{
	#シラバス = #this/授業
}
check シラバスと授業は同数ある

assert 任意の時間割には代表時間割が一意に存在する{
	all j: this/時間割 | one 代表時間割[j]
}
check 任意の時間割には代表時間割が一意に存在する

assert 任意の異なる代表時間割の合併時間割は排他的である{
	all disj r,r': 代表時間割 |
		no (合併時間割[r] & 合併時間割[r'])
}
check 任意の異なる代表時間割の合併時間割は排他的である

assert 任意の子時間割は代表をたどっても循環参照しない{
	all c: 子時間割 |
		c not in c.^代表
}
check 任意の子時間割は代表をたどっても循環参照しない

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

assert 学生に適用されるカリキュラムは一意に決まる{
	all s: this/学生 | one s.適用
}
check 学生に適用されるカリキュラムは一意に決まる

run 複数のカリキュラムを定義できる{
	#カリキュラム > 1
}

run 同じ学部学科に対して複数のカリキュラムを定義できる{
	some disj c,c': カリキュラム |
		c.対象学科 != c'.対象学科
}

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

run 複数の曜時にまたがる時間割が作れる{
	some t: this/時間割 |
		#t.曜時 > 1
}

run 複数の時間割が同じ教室を共有できる{
	some disj t,t': this/時間割 |
		some (教室時間割[t] & 教室時間割[t'])
}

run 隔週時間割が作れる{
	some t: this/時間割 |
		t.週間隔区分 in (隔週1 + 隔週2)
}

run 片側ペア時間割の指定ができる{
	some disj t,t': this/時間割 |
		t.ペア = t' and no t'.ペア
}

run 両側ペア時間割の指定ができる{
	some disj t,t': this/時間割 |
		t.ペア = t' and t = t'.ペア
}

run クラスタペア時間割の指定ができる{
	some disj t,t',t'': this/時間割 |
		(t + t' + t'') in t.*ペア
}

run クラスタペア時間割で対称でない指定ができる{
	some disj t,t',t'': this/時間割 |
		(t + t' + t'') in t.*ペア and t.*ペア != t'.*ペア
}

run 集中授業の時間割を作れる{
	some j: this/時間割 |
		集中 in j.曜時
}

run 卒業要件を定義できる{
	some 卒業要件
}

run 卒業要件の判定条件を定義できる{
	some j: 要件判定 | some r: 卒業要件 |
		r in 判定対象要件[j]
}

run 卒業要件に対して処理を定義できる{
	some a: 判定後処理 |
		some (判定対象要件[a.属する] & 卒業要件)
}

run 教職要件を定義できる{
	some 教職要件
}

run 教職要件の判定条件を定義できる{
	some j: 要件判定 | some r: 教職要件 |
		r in 判定対象要件[j]
}

run 教職要件に対して処理を定義できる{
	some a: 判定後処理 |
		some (判定対象要件[a.属する] & 教職要件)
}

run その他の資格要件を定義できる{
	some (資格要件 - 教職要件)
}

run その他の資格要件の判定条件を定義できる{
	some j: 要件判定 | some r: (資格要件 - 教職要件) |
		r in 判定対象要件[j]
}

run その他の資格要件に対して処理を定義できる{
	some a: 判定後処理 |
		some (判定対象要件[a.属する] & (資格要件 - 教職要件))
}

run 学生は複数の履修ができる{
	all s: this/学生 |
		#s.~履修者 > 1
}

run 同じ科目の履修を複数持ち得る{
	some g: this/学生 | some disj r,r': g.~履修者 |
		履修科目[r] = 履修科目[r']
}

run 同じ科目の成績を複数持ち得る{
	some g: this/学生 | some disj s,s': g.~(成績 <: 学生) |
		s.科目 = s'.科目
}

run 学生は教職要件を取得申請できる{
	some s: this/学生 |
		some s.教職
}
run 学生は複数の教職要件を取得申請できる{
	some s: this/学生 |
		#s.教職 > 1
}

run 学生は資格要件を取得申請できる{
	some s: this/学生 |
		some s.資格
}

run 学生は複数の資格要件を取得申請できる{
	some s: this/学生 |
		#s.資格 > 1
}

run 任意の要件を取得可能なように学則を構成できる{
	all g: this/学生 |
		g.(教職 + 資格) in 修得可能学則[g].適用要件
}

run カリキュラム毎に要件判定を定義できる{
	some disj j,j': 要件判定 |
		j.適用 != j'.適用
}

run 要件判定を学年ごとに定義できる{
	some disj j,j': 要件判定 |
		j.年次 != j'.年次
}
run 要件判定を学部学科ごとに定義できる{
	some disj j,j': 要件判定 |
		j.学科 != j'.学科
}
run 要件の判定処理の順序を指定できる{
	some disj j,j': 要件判定 |
		j.判定順 != j'.判定順
}

run 卒業進級要件の判定処理で進級できる{
	some j: 要件判定 |
		卒業要件に対する判定[j] and 進級 in 後処理[j]
}
run 卒業進級要件の判定処理で卒業できる{
	some j: 要件判定 |
		卒業要件に対する判定[j] and 卒業 in 後処理[j]
}
run 卒業進級要件の判定処理で卒業研究の受講制限ができる{
	some j: 要件判定 |
		卒業要件に対する判定[j] and 卒研受講制限 in 後処理[j]
}
run 卒業進級要件の判定処理で退学ができる{
	some j: 要件判定 |
		卒業要件に対する判定[j] and 退学 in 後処理[j]
}
run 合併時間割に異なる科目の時間割を含めることができる{
	some j: this/時間割 | some disj c,c': 合併時間割[j] |
		c.授業.科目 != c'.授業.科目
}
run 合併時間割に異なる科目の履修を含めることができる{
	some j: this/時間割 | some disj r,r': 履修 |
		(r + r').履修時間割 in 合併時間割[j] and 履修科目[r] != 履修科目[r']
}
run 合併時間割に異なる科目の出席情報を含めることができる{
	some j: this/時間割 | some disj a,a': 出席情報 |
		(a + a').時間割 in 合併時間割[j] and 出席情報科目[a] != 出席情報科目[a']
}
run 合併時間割に異なる科目の試験成績を含めることができる{
	some j: this/時間割 | some disj t,t': 試験成績 |
		(t + t').時間割 in 合併時間割[j] and 試験成績科目[t] != 試験成績科目[t']
}

run 配当学年の範囲指定ができる{
	some r: 学則 |
		#r.配当学年 > 1
}

run 学則に強制履修を設定できる{
	some r: 学則 |
		r.強制 in On
}

run 事前修得前提科目を設定できる{
	some 事前修得前提科目
}

run 事前履修前提科目を設定できる{
	some 事前履修前提科目
}

run 修得単位数制限を定義できる{
	some 修得単位数制限
}

run 年度ごとに修得単位数制限を定義できる{
	some x: 修得単位数制限 |
		some x.年度
}

run 学科ごとに修得単位数制限を定義できる{
	some x: 修得単位数制限 |
			some x.学科
}

run 年次ごとに修得単位数制限を定義できる{
	some x: 修得単位数制限 |
		some x.学年
}

run 半期ごとに修得単位数制限を定義できる{
	some x: 修得単位数制限 |
		x.期 in (前期 + 後期)
}

run 通期に修得単位数制限を定義できる{
	some x: 修得単位数制限 |
		x.期 in 通期
}

run GPA範囲ごとに修得単位数制限を定義できる{
	some x: 修得単位数制限 |
		some x.GPA下限 and some x.GPA上限
}

run 時間割に対して学生の履修申請を作ることができる{
	some t: this/時間割 |
		some s: this/学生 |
			some r: 履修申請 |
			r.申請者 in s and r.申請時間割 in t
}

run 履修申請に対応する履修を作ることができる{
	some r: 履修申請 |
		some x: 履修 |
			x.由来する in r
}

run 抽選による履修登録ができる{
	some t: this/時間割 |
		some s: this/学生 |
			some x: 履修 |
				let r = x.由来する |
					some r and
					r.申請者 in s and r.申請時間割 in t and
					x.履修者 in s and x.履修時間割 in t
}

run 履修申請のない履修を作ることができる{
	some x: 履修 |
		no x.由来する
}

run 学則に科目専門区分を定義できる{
	some r: 学則 |
		some r.科目専門区分
}

run 学則に分類を定義できる{
	some r: 学則 |
		some r.分類
}

run 学則に分野を定義できる{
	some r: 学則 |
		some r.分野
}

run 学則にグループを定義できる{
	some r: 学則 |
		some r.グループ
}

run 年度ごとに学年歴を定義できる{
	1 = 0
}

run 施設管理ができる{
	1 = 0
}

run 休講が登録できる{
	1 = 0
}

run 補講が登録できる{
	1 = 0
}

--------------------------
-- Preds and Assertions
--------------------------

run 例示せよ{
	-- 見た目調整の制限
	all j: this/時間割 | #j.曜時 <= 2
}

