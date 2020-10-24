
class Student {

	int _id;
	String _fullName;
	String _cne;
  int _sectionId;


	Student(this._fullName, this._cne);
  Student.withSecId(this._fullName, this._cne,this._sectionId);
	Student.withId(this._id, this._fullName,this._cne);


	int get id => _id;
	String get fullName => _fullName;
	String get cne => _cne;
  int get sectionId => _sectionId;


	set fullName(String name) {
		if (name.length <= 255) {
			this._fullName = name;
		}
	}

	set cne(String code) {
		if (code.length <= 255) {
			this._cne = code;
		}
	}

  set sectionId(int id) {
    this._sectionId = id;
  }

	
	// Convert a Note object into a Map object
	Map<String, dynamic> toMap() {

		var map = Map<String, dynamic>();
		if (id != null) {
			map['id'] = _id;
		}
		map['fullName'] = _fullName;
		map['cne'] = _cne;
    map['sectionId'] = _sectionId;


		return map;
	}

	// Extract a Note object from a Map object
	Student.fromMapObject(Map<String, dynamic> map) {
		this._id = map['id'];
		this._fullName = map['fullName'];
		this._cne = map['cne'];
    this._sectionId =  map['sectionId'];
	}
}









