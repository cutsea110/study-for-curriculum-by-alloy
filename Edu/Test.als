open util/ordering[Student]

enum Type { X, Y }

abstract sig Student{
	T : Type,
	TransHistory: set TransRecord
}
sig StudentX extends Student{
}{
	T = X
}
sig StudentY extends Student{
}{
	T = Y
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
			s'.TransHistory = s.TransHistory + x and s'.T = s.T
}

run {} for 5
