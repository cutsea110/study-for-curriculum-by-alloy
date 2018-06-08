open util/ordering[Student]

sig Student{
	TransHistory: set TransRecord
}

sig TransRecord{
}

pred init(s: Student){
	no s.TransHistory
}

fact traces{
	first.init
	all s: Student - last | let s' = s.next |
		some x: TransRecord |
			s'.TransHistory = s.TransHistory + x
}

run {} for 5
