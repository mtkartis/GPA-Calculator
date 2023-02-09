extends Node

const COURSE = preload("res://Course.tscn")
const SEMESTER = preload("res://Semester.tscn")
const UTIL = preload("res://Utility.gd")

#const SAVE_PATH = "res://Saves/"
const SAVE_PATH = "user://Saves/"
const SAVE_FILE = "GPAdata.cfg"


export var GPA_total: float = 0.0

onready var layout = $UI/Scroll/Layout
onready var semester_container = $UI/Scroll/Layout/Semesters
onready var GPATotal = $UI/Scroll/Layout/Header/GPADisplay/GPATotal


#---------------------------------FUNC-----------------------------------------
func _ready():
	if save_exists():
		load_data()
	SignalBus.connect("update", self, "update")


func init_semester()-> Semester:
	var semester = SEMESTER.instance()
	semester_container.add_child(semester)
	return semester


func add_blank_semester(courses:int = 0)-> Semester:
	var semester = init_semester()
	semester.add_blank_course(courses)
	return semester


func update():
	update_GPA()
#	print("update")
	save_data()


func update_GPA():
	var total_courses:Array = []
	for semester in semester_container.get_children():
		total_courses.append_array(semester.course_container.get_children())
	
	var gradePointsSum: float = 0.0
	var courseWeightSum: float = 0.0
	for course in total_courses:
		if course.is_active():
			gradePointsSum += (UTIL.GRADE_TO_POINTS[course.get_grade_as_string()] * course.get_weight())
			courseWeightSum += course.weight
	
	if courseWeightSum <= 0:
		courseWeightSum = 1
	GPA_total = stepify(gradePointsSum/courseWeightSum, 0.01)
	GPATotal.set_text(str(GPA_total))
#	print(GPATotal.text)


func save_exists()-> bool:
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_PATH):
		dir.make_dir_recursive(SAVE_PATH)
		return false
	var file = File.new()
	if file.file_exists(SAVE_PATH + SAVE_FILE):
		return true
	return false


func save_data()-> ConfigFile:
	var config = ConfigFile.new()
	var semesters:Array = semester_container.get_children()
	for semester in semesters:
		semester.save_data(config)
		for course in semester.course_container.get_children():
			course.save_data(config)
	config.save(SAVE_PATH + SAVE_FILE)
	return config


func load_data():
	var config = ConfigFile.new()
	var error = config.load(SAVE_PATH + SAVE_FILE)
	if error != OK: return
	var sections = config.get_sections()
	for section in sections:
		if config.get_section_keys(section).has("TYPE"):
			if config.get_value(section, "TYPE") == "SEMESTER":
				var semester = init_semester()
				semester.load_data(config, section)

	for section in sections:
		if config.get_section_keys(section).has("TYPE"):
			if config.get_value(section, "TYPE") == "COURSE":
				
				for semester in semester_container.get_children():
					if semester.ID == config.get_value(section, "SEMESTER_ID"):
						var course = semester.init_course()
						course.load_data(config, section)
						break
	update_GPA()


#-------------------------------SIGNALS-----------------------------------------
func _on_AddSemesterButton_button_down():
	add_blank_semester(5)
	update()
