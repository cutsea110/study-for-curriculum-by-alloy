for work

$ cat Adm/Base.md Adm/Department.md Adm/Admission.md Adm/Applicant.md Adm/Specification.md | pandoc -f markdown -o 入試システム仕様および基本設計書.pdf -V documentclass=ltjltxdoc -H preanble.tex --pdf-engine=lualatex --toc -N

$ cat Edu/Base.md Edu/Department.md Edu/Staff.md Edu/Curriculum.md Edu/EvalMethod.md Edu/Requirement.md Edu/CurriculumExtensions.md Edu/Timetable.md Edu/TimetableExtensions.md Edu/Student.md Edu/Education.md Edu/HealthMedical.md Edu/StudentTrace.md Edu/Facility.md Edu/FacilityManagement.md Edu/Positions.md Edu/Specification.md | pandoc -f markdown -o 教務システム仕様および基本設計書.pdf -V documentclass=ltjltxdoc -H preanble.tex --pdf-engine=lualatex --toc -N

