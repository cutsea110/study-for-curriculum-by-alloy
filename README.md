# 準備

## 仕様の検証について

Markdownですが実体はAlloyAnalyzerのliterateファイルです.
AlloyAnalyzer 5.0以降が必要.(実際には.mdのモジュールインポートが可能なのはSNAPSHOT-20180618以降になります)

## 仕様のドキュメント生成について

TeXLiveとpandocをインストールする必要がある.

# PDFの生成

以下のコマンドを実行する.

```shell
$ cat Adm/Preface.md Adm/Base.md Adm/Department.md Adm/Admission.md Adm/Applicant.md Adm/Specification.md | pandoc -f markdown -o 入試システム仕様および基本設計書.pdf -V documentclass=ltjltxdoc -H preanble.tex --pdf-engine=lualatex --toc -N

$ cat Edu/Preface.md Edu/Base.md Edu/Department.md Edu/Staff.md Edu/Curriculum.md Edu/EvalMethod.md Edu/Requirement.md Edu/CurriculumExtensions.md Edu/Timetable.md Edu/TimetableExtensions.md Edu/Student.md Edu/Education.md Edu/HealthMedical.md Edu/StudentTrace.md Edu/Facility.md Edu/FacilityManagement.md Edu/Positions.md Edu/Sales.md Edu/Specification.md | pandoc -f markdown -o 教務システム仕様および基本設計書.pdf -V documentclass=ltjltxdoc -H preanble.tex --pdf-engine=lualatex --toc -N
```
