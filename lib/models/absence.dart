

class Absence {

  int _id;
  String _dateAbsence;
  String _observation;
  int _studentId;

  Absence(this._id,this._observation);
  Absence.withAll(this._id,this._dateAbsence,this._observation,_studentId);
  Absence.withoutId(this._dateAbsence,this._observation);
  Absence.withStdId(this._dateAbsence,this._observation,_studentId);
  Absence.withId(this._id,this._dateAbsence,this._observation);
  
  int get id => _id;
  String get dateAbsence => _dateAbsence;
  String get observation => _observation;
  int get studentId => _studentId;

  
  set dateAbsence(String date) {
      this._dateAbsence = date;
  }
  set observation(String obs) {
    if(obs.length <= 255) {
      this._observation = obs;
    }
  } 
  set studentId(int id) {
    this._studentId =id;
  }

  Map<String,dynamic> toMap() {

    var map = Map<String,dynamic>();
    if(id != null){
      map['id'] = _id;
    }
    map['dateAbsence'] = _dateAbsence;
    map['observation'] = _observation;
    map['studentId'] = _studentId;

    return map;
  }

  Absence.fromMapObject(Map<String,dynamic> map) {
    this._id = map['id'];
    this._dateAbsence = map['dateAbsence'];
    this._observation = map['observation'];
    this._studentId = map['studentId'];
  }


}