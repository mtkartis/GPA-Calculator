extends Script

enum CREDIT_TYPES {
	THREE,
	SIX,
	HALF,
}


const SEMESTER_SAVE_KEYS = [
	"TYPE",
	"NAME",
	"ACTIVE",
]


const COURSE_SAVE_KEYS = [
	"TYPE",
	"SEMESTER_ID",
	"NAME",
	"GRADE_INDEX",
	"CREDIT_TYPE",
	"ACTIVE",
]


const CREDIT_TYPE_TO_WEIGHT = {
	0: 3.0,
	1: 6.0,
	2: 1.5,
}

const GRADE_TO_POINTS = {
	"A+": 4.0,
	"A": 4.0,
	"A-": 3.7,
	"B+": 3.3,
	"B": 3.0,
	"B-": 2.7,
	"C+": 2.3,
	"C": 2.0,
	"C-": 1.7,
	"D+": 1.3,
	"D": 1.0,
	"F": 0.0,
}





#---------------------------------------------FUNCS-------------------------------------------------
static func grade_to_points(grade:String)-> float:
	return GRADE_TO_POINTS[grade]

static func get_gpa_scale_keys()-> Array:
	return GRADE_TO_POINTS.keys()
