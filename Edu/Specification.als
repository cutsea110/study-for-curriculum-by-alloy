---
title: Specification
layout: default
---

```alloy
private open Base
private open Curriculum
private open CurriculumExtensions
private open Department
private open Education
private open Facility
private open FacilityManagement
private open HealthMedical
private open Staff
private open Student
private open StudentTrace
private open Timetable
private open TimetableExtensions
```

```alloy
-- Timetable
check シラバスと授業は同数ある
check 任意の時間割には代表時間割が一意に存在する
check 任意の異なる代表時間割の合併時間割は排他的である
check 任意の子時間割は代表をたどっても循環参照しない
run 複数の教員による時間割が作れる
run 複数の教室を使った時間割が作れる
run 複数の曜時にまたがる時間割が作れる
run 複数の時間割が同じ教室を共有できる
run 隔週時間割が作れる
run 集中授業の時間割を作れる
run 合併時間割に異なる科目の時間割を含めることができる

-- TimetableExtensions
run 休講を登録できる
run 休講理由を指定できる
run 補講を登録できる
run 補講の根拠となった休講を紐付けることができる
run 休講してなくても補講を登録できる
run 複数コマの補講を登録できる
run 複数教室を使った補講を登録できる
run 同じ休講に対して複数回に分けて補講を登録できる

-- Curriculum
run 複数のカリキュラムを定義できる
run 同じ学部学科に対して複数のカリキュラムを定義できる
run 卒業要件を定義できる
run 卒業要件の判定条件を定義できる
run 卒業要件に対して処理を定義できる
run 教職要件を定義できる
run 教職要件の判定条件を定義できる
run 教職要件に対して処理を定義できる
run その他の資格要件を定義できる
run その他の資格要件の判定条件を定義できる
run その他の資格要件に対して処理を定義できる
run カリキュラム毎に要件判定を定義できる
run 要件判定を学年ごとに定義できる
run 要件判定を学部学科ごとに定義できる
run 要件の判定処理の順序を指定できる
run 卒業進級要件の判定処理で進級できる
run 卒業進級要件の判定処理で卒業できる
run 卒業進級要件の判定処理で卒業研究の受講制限ができる
run 卒業進級要件の判定処理で退学ができる
run 配当学年の範囲指定ができる
run 学則に強制履修を設定できる
run 学則に科目専門区分を定義できる
run 学則に分類を定義できる
run 学則に分野を定義できる
run 学則にグループを定義できる

-- CurriculumExtensions
run 事前修得前提科目を設定できる
run 事前履修前提科目を設定できる
run 修得単位数制限を定義できる
run 年度ごとに修得単位数制限を定義できる
run 学科ごとに修得単位数制限を定義できる
run 年次ごとに修得単位数制限を定義できる
run 半期ごとに修得単位数制限を定義できる
run 通期に修得単位数制限を定義できる
run GPA範囲ごとに修得単位数制限を定義できる
run 同時履修させる科目セットを定義できる
run 同じカリキュラム内で交わりのある複数の科目セットが作れる
run 同じカリキュラム内で交わりのない複数の科目セットが作れる

-- Student
check 学生に適用されるカリキュラムは一意に決まる
run 正規生が存在しうる
run 非正規生が存在しうる
run 同じ学科の学生に異なるカリキュラムを適用できる
run 学生は教職要件を取得申請できる
run 学生は複数の教職要件を取得申請できる
run 学生は資格要件を取得申請できる
run 学生は複数の資格要件を取得申請できる
run 任意の要件を取得可能なように学則を構成できる

-- StudentTrace
run 在籍学生を卒業させることができる for 5
run 除籍になった学籍を在籍に戻せる for 5

-- Education
check 任意の成績の科目は適用カリキュラムの学則に含まれる
check 任意の成績のGPAは一意に決まる
check 同じ科目に対して単位認定可能な成績は一意に決まる
run 異なる学科の学生が同じ時間割を履修できる
run 適用カリキュラムにない科目を履修できる
run 異なるカリキュラムの学生が同じ時間割を履修できる
run 異なる学年の学生が同じ時間割を履修できる
run 時間割がなくても成績は作れる
run 履修がなくても成績は作れる
run 試験成績はなくても成績はつけられる
run 出欠は取らなくても成績はつけられる
run 履修がなくても出欠はつけられる
run 単独科目授業を履修できる
run 分割科目を履修できる
run 一貫分割型複数担当科目を履修できる
run 途中分割型複数担当科目を履修できる
run シリーズ科目を履修できる
run 学生は複数の履修ができる
run 同じ科目の履修を複数持ち得る
run 同じ科目の成績を複数持ち得る
run 合併時間割に異なる科目の履修を含めることができる
run 合併時間割に異なる科目の出席情報を含めることができる
run 合併時間割に異なる科目の試験成績を含めることができる
run 時間割に対して学生の履修申請を作ることができる
run 履修申請に対応する履修を作ることができる
run 抽選による履修登録ができる
run 履修申請のない履修を作ることができる
run 事前修得前提科目が設定された科目を履修できる
run 事前履修前提科目が設定された科目を履修できる
run 科目セットの時間割を履修できる

-- FacilityManagement
run 特定日時の施設管理ができる

-- HealthMedical
run 学生ごとに健康診断データを管理できる
run 学生は年度ごとに健康診断データを保持できる
run 学生は同一年度に複数の健康診断データを保持できる
run 学生は年度ごとに検診データを保持できる
run 学生は同一年度に同じ種類の検診データを複数保持できる

```

```alloy
run 例示せよ{
	-- 見た目調整の制限
	all j: this/時間割 | #j.曜時 <= 2
}
```
