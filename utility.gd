class_name U # for Utility

static func getAllFilePaths(path: String) -> Array[String]:  
	var file_paths: Array[String] = []  
	var dir = DirAccess.open(path)  
	dir.list_dir_begin()  
	var file_name = dir.get_next()  
	while file_name != "":  
		var file_path = path + "/" + file_name  
		if dir.current_is_dir():  
			file_paths += getAllFilePaths(file_path)  
		else:  
			file_paths.append(file_path)  
		file_name = dir.get_next()  
	return file_paths

static func getAllResUnderDir(dirPath: String) -> Array[Resource]:
	var ret : Array[Resource] = []
	for path in getAllFilePaths(dirPath):
		ret.append(load(path) as Resource)
	return ret

static func foreach(array: Array, callable: Callable):
	for i in range(len(array)):
		var item = array[i]
		callable.callv([item, i])

static func map(array: Array, callable: Callable) -> Array:
	var ret = []
	for i in range(len(array)):
		var item = array[i]
		ret.append(callable.callv([item, i]))
	return ret

static func reduce(array: Array, start, callable: Callable):
	var ret = start
	for i in range(len(array)):
		var item = array[i]
		ret = callable.callv([ret, item, i])
	return ret