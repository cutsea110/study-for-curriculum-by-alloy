---
title: Specification
---

# 基本モデル設計および仕様に対する正当性検証

教務システムのモデルについての基本設計を行い,そのモデルの仕様に対する正当性を検証する.
仕様の形式的な意味については各依存モデルの詳細を参照のこと.

## 依存モデル

```alloy
private open Base
private open Curriculum
private open CurriculumExtensions
private open Department
private open Education
private open Facility
private open FacilityManagement
private open Fee
private open HealthMedical
private open Positions
private open Staff
private open Student
private open StudentTrace
private open Timetable
private open TimetableExtensions
```

## 仕様一覧

授業および時間割など仕様は以下の通り.

```alloy
check シラバスと授業は同数ある
check 任意の時間割には代表時間割が一意に存在する
check 任意の異なる代表時間割の合併時間割は排他的である
check 任意の子時間割は代表をたどっても循環参照しない
run ひとつの授業に複数の時間割が作れる
run ひとつのシラバスに履修可能な時間割を複数作れる
run 時間割がない授業が作れる
run 複数の教員による時間割が作れる
run 複数の教室を使った時間割が作れる
run 複数の曜時にまたがる時間割が作れる
run 複数の時間割が同じ教室を共有できる
run 隔週時間割が作れる
run 集中授業の時間割を作れる
run 合併時間割に異なる科目の時間割を含めることができる
```

以下は授業および時間割を拡張する機能の仕様に関するもの.

```alloy
run 休講を登録できる
run 休講理由を指定できる
run 補講を登録できる
run 補講の根拠となった休講を紐付けることができる
run 休講してなくても補講を登録できる
run 複数コマの補講を登録できる
run 複数教室を使った補講を登録できる
run 同じ休講に対して複数回に分けて補講を登録できる
```

カリキュラム、学則および卒業進級要件やその他資格要件に関する仕様を以下に示す.

```alloy
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
```

カリキュラムや学則を拡張する機能に関するもの.

```alloy
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
```

教職員の仕様については以下の通り.

```alloy
run 教職員は学部学科に所属できる
run 教職員は組織に所属できる
run 教員に職員系の職種を所属させることができる
run 教職員は複数の組織を兼務できる
```

学生(学籍)の仕様については以下の通り.

```alloy
check 学生に適用されるカリキュラムは一意に決まる
check 学生に適用されるディプロマポリシーは一意に決まる
check 同じカリキュラムに適用されている学生はディプロマポリシーも同じ
check 学生のゼミ担当教員は存在すれば一意に決まる
run 正規生が存在しうる
run 非正規生が存在しうる
run 同じ学科の学生に異なるカリキュラムを適用できる
run 学生は教職要件を取得申請できる
run 学生は複数の教職要件を取得申請できる
run 学生は資格要件を取得申請できる
run 学生は複数の資格要件を取得申請できる
run 学生の異動履歴を残せる
run 学生の保護者を登録できる
run 学生の保証人を登録できる
run 学生の保証人と保護者に異なる人を登録できる
run 学生の保証人と保護者に同じ人を登録できる
run 学生にゼミ担当教員を設定できる
```

学生および教員間の関係やポジションに関する仕様は以下の通り.

```alloy
check 任意の学生教員関係は年度と期で期間が定められている
run 教員にTAやSAやRAなどのアシスタントをつけることができる
run 教員は複数名のTAやSAやRAなどのアシスタントをつけることができる
run 学生にチューターやメンターをつけることができる
run 学生にアドバイザや英式Tutorをつけることができる
run 学生に複数名のアドバイザをつけることができる
```

学生の異動についての仕様は以下の通り.

```alloy
run 在籍学生を卒業させることができる for 5
run 除籍になった学籍を在籍に戻せる for 5
run 在籍学生を除籍状態にできる for 5
```

学生の履修や成績についての仕様は以下の通り.

```alloy
check 任意の成績の科目は適用カリキュラムの学則に含まれる
check 任意の成績のGPAは一意に決まる
check 同じ科目に対して単位認定可能な成績は一意に決まる
check 時間割があればその科目を履修できる学生はその授業を履修できる
run 異なる学科の学生が同じ時間割を履修できる
run 適用カリキュラムにない科目を履修できる
run 異なるカリキュラムの学生が同じ時間割を履修できる
run 異なる学年の学生が同じ時間割を履修できる
run 異なるディプロマポリシーの学生が同じ時間割を履修できる
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
run 履修が不可能な開講なし授業を作れる
```

施設管理についての仕様は以下の通り.

```alloy
run 特定日時の施設利用ができる
run 時間割による施設利用ができる
run 補講による施設利用ができる
run 予約による施設利用ができる
```

学生健康診断についての仕様は以下の通り.

```alloy
run 学生ごとに健康診断データを管理できる
run 学生は年度ごとに健康診断データを保持できる
run 学生は同一年度に複数の健康診断データを保持できる
run 学生は年度ごとに検診データを保持できる
run 学生は同一年度に同じ種類の検診データを複数保持できる
```

学費についての仕様は以下の通り.

```alloy
check 異なる売上に含まれる売上明細はない
check 異なる請求に含まれる請求明細はない
run 年度一括で売上を立てることができる
run 期ごとに売上を立てることができる
run 売上に対して分割請求することができる
run 学生に対して学費納付計画を立てることができる
run 学費の支払い計画として分納を計画することができる
run 学費がなくても売上がつくれる
run 学費納付計画がなくても請求書をつくれる
```

