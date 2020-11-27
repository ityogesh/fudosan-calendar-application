class StatesList {
  List<StateList> stateList;

  StatesList({this.stateList});

  StatesList.fromJson(Map<String, dynamic> json) {
    if (json['state_list'] != null) {
      stateList = new List<StateList>();
      json['state_list'].forEach((v) {
        stateList.add(new StateList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.stateList != null) {
      data['state_list'] = this.stateList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StateList {
  int id;
  String stateCodeName;
  String stateName;

  StateList({this.id, this.stateCodeName, this.stateName});

  StateList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stateCodeName = json['state_code_name'];
    stateName = json['state_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['state_code_name'] = this.stateCodeName;
    data['state_name'] = this.stateName;
    return data;
  }
}
