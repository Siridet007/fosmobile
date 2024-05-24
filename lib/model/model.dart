class GetApproveHead {
  String? prnum;
  String? prdate;
  String? deptname;
  String? prorder;
  String? reqname;
  String? fordeptname;
  String? purby;
  String? forprojects;
  String? depcode;
  String? datediff;
  String? total;
  String? hold;
  String? priceChange;
  String? projectTotal;
  String? montotal;
  String? montotalL;
  String? montotal2;
  String? montotal2L;
  String? montotal3;
  String? montotal3L;
  String? forprojectsCode;
  String? forprojectsName;
  String? prremark;
  String? reqnamecode;
  String? reqnamename;
  String? purbycode;
  String? purbyname;
  String? budget;
  String? dl;
  String? forpro;
  String? totalRec;
  String? totalHold;
  String? totalUhold;
  String? curren;

  GetApproveHead(
      {this.prnum,
      this.prdate,
      this.deptname,
      this.prorder,
      this.reqname,
      this.fordeptname,
      this.purby,
      this.forprojects,
      this.depcode,
      this.datediff,
      this.total,
      this.hold,
      this.priceChange,
      this.projectTotal,
      this.montotal,
      this.montotalL,
      this.montotal2,
      this.montotal2L,
      this.montotal3,
      this.montotal3L,
      this.forprojectsCode,
      this.forprojectsName,
      this.prremark,
      this.reqnamecode,
      this.reqnamename,
      this.purbycode,
      this.purbyname,
      this.budget,
      this.dl,
      this.forpro,
      this.totalRec,
      this.totalHold,
      this.totalUhold,
      this.curren});

  GetApproveHead.fromJson(Map<String, dynamic> json) {
    prnum = json['prnum'] ?? '';
    prdate = json['prdate'] ?? '';
    deptname = json['deptname'] ?? '';
    prorder = json['prorder'] ?? '';
    reqname = json['reqname'] ?? '';
    fordeptname = json['fordeptname'] ?? '';
    purby = json['purby'] ?? '';
    forprojects = json['forprojects'] ?? '';
    depcode = json['depcode'] ?? '';
    datediff = json['datediff'] ?? '';
    total = json['total'] ?? '';
    hold = json['hold'] ?? '';
    priceChange = json['price_change'] ?? '';
    projectTotal = json['project_total'] ?? '';
    montotal = json['montotal'] ?? '';
    montotalL = json['montotalL'] ?? '';
    montotal2 = json['montotal2'] ?? '';
    montotal2L = json['montotal2L'] ?? '';
    montotal3 = json['montotal3'] ?? '';
    montotal3L = json['montotal3L'] ?? '';
    forprojectsCode = json['forprojects_code'] ?? '';
    forprojectsName = json['forprojects_name'] ?? '';
    prremark = json['prremark'] ?? '';
    reqnamecode = json['reqnamecode'] ?? '';
    reqnamename = json['reqnamename'] ?? '';
    purbycode = json['purbycode'] ?? '';
    purbyname = json['purbyname'] ?? '';
    budget = json['budget'] ?? '';
    dl = json['dl'] ?? '';
    forpro = json['forpro'] ?? '';
    totalRec = json['total_rec'] ?? '';
    totalHold = json['total_hold'] ?? '';
    totalUhold = json['total_uhold'] ?? '';
    curren = json['curren'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['prnum'] = prnum;
    data['prdate'] = prdate;
    data['deptname'] = deptname;
    data['prorder'] = prorder;
    data['reqname'] = reqname;
    data['fordeptname'] = fordeptname;
    data['purby'] = purby;
    data['forprojects'] = forprojects;
    data['depcode'] = depcode;
    data['datediff'] = datediff;
    data['total'] = total;
    data['hold'] = hold;
    data['price_change'] = priceChange;
    data['project_total'] = projectTotal;
    data['montotal'] = montotal;
    data['montotalL'] = montotalL;
    data['montotal2'] = montotal2;
    data['montotal2L'] = montotal2L;
    data['montotal3'] = montotal3;
    data['montotal3L'] = montotal3L;
    data['forprojects_code'] = forprojectsCode;
    data['forprojects_name'] = forprojectsName;
    data['prremark'] = prremark;
    data['reqnamecode'] = reqnamecode;
    data['reqnamename'] = reqnamename;
    data['purbycode'] = purbycode;
    data['purbyname'] = purbyname;
    data['budget'] = budget;
    data['dl'] = dl;
    data['forpro'] = forpro;
    data['total_rec'] = totalRec;
    data['total_hold'] = totalHold;
    data['total_uhold'] = totalUhold;
    data['curren'] = curren;
    return data;
  }

  static List<GetApproveHead>? fromJsonList(List list) {
    //if (list == null) return null;
    return list.map((item) => GetApproveHead.fromJson(item)).toList();
  }
}

class GetApproveDetail {
  String? prinvcode;
  String? prinvname;
  String? prunit;
  String? prqu;
  String? subquan;
  String? curren;
  String? lastprice;
  String? prunitpr;
  String? total;
  String? hold;
  String? mark;
  String? prsubt;
  String? prsubt2;
  String? prdis;
  String? prdis2;
  String? pramount;
  String? pramount2;
  String? itemno;

  GetApproveDetail(
      {this.prinvcode,
      this.prinvname,
      this.prunit,
      this.prqu,
      this.subquan,
      this.curren,
      this.lastprice,
      this.prunitpr,
      this.total,
      this.hold,
      this.mark,
      this.prsubt,
      this.prsubt2,
      this.prdis,
      this.prdis2,
      this.pramount,
      this.pramount2,
      this.itemno});

  GetApproveDetail.fromJson(Map<String, dynamic> json) {
    prinvcode = json['prinvcode'] ?? '';
    prinvname = json['prinvname'] ?? '';
    prunit = json['prunit'] ?? '';
    prqu = json['prqu'] ?? '';
    subquan = json['subquan'] ?? '';
    curren = json['curren'] ?? '';
    lastprice = json['lastprice'] ?? '';
    prunitpr = json['prunitpr'] ?? '';
    total = json['total'] ?? '';
    hold = json['hold'] ?? '';
    mark = json['mark'] ?? '';
    prsubt = json['prsubt'] ?? '';
    prsubt2 = json['prsubt2'] ?? '';
    prdis = json['prdis'] ?? '';
    prdis2 = json['prdis2'] ?? '';
    pramount = json['pramount'] ?? '';
    pramount2 = json['pramount2'] ?? '';
    itemno = json['itemno'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['prinvcode'] = prinvcode;
    data['prinvname'] = prinvname;
    data['prunit'] = prunit;
    data['prqu'] = prqu;
    data['subquan'] = subquan;
    data['curren'] = curren;
    data['lastprice'] = lastprice;
    data['prunitpr'] = prunitpr;
    data['total'] = total;
    data['hold'] = hold;
    data['mark'] = mark;
    data['prsubt'] = prsubt;
    data['prsubt2'] = prsubt2;
    data['prdis'] = prdis;
    data['prdis2'] = prdis2;
    data['pramount'] = pramount;
    data['pramount2'] = pramount2;
    data['itemno'] = itemno;
    return data;
  }

  static List<GetApproveDetail>? fromJsonList(List list) {
    //if (list == null) return null;
    return list.map((item) => GetApproveDetail.fromJson(item)).toList();
  }
}

class GetHeadTotal {
  String? totalRec;
  String? totalHold;

  GetHeadTotal({this.totalRec, this.totalHold});

  GetHeadTotal.fromJson(Map<String, dynamic> json) {
    totalRec = json['total_rec'];
    totalHold = json['total_hold'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_rec'] = totalRec;
    data['total_hold'] = totalHold;
    return data;
  }

  static List<GetHeadTotal>? fromJsonList(List list) {
    //if (list == null) return null;
    return list.map((item) => GetHeadTotal.fromJson(item)).toList();
  }
}

class GetMonthTotal {
  String? montotalL;
  String? montotal;
  String? montotal2L;
  String? montotal2;
  String? montotal3L;
  String? montotal3;

  GetMonthTotal(
      {this.montotalL,
      this.montotal,
      this.montotal2L,
      this.montotal2,
      this.montotal3L,
      this.montotal3});

  GetMonthTotal.fromJson(Map<String, dynamic> json) {
    montotalL = json['montotalL'];
    montotal = json['montotal'];
    montotal2L = json['montotal2L'];
    montotal2 = json['montotal2'];
    montotal3L = json['montotal3L'];
    montotal3 = json['montotal3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['montotalL'] = montotalL;
    data['montotal'] = montotal;
    data['montotal2L'] = montotal2L;
    data['montotal2'] = montotal2;
    data['montotal3L'] = montotal3L;
    data['montotal3'] = montotal3;
    return data;
  }

  static List<GetMonthTotal>? fromJsonList(List list) {
    //if (list == null) return null;
    return list.map((item) => GetMonthTotal.fromJson(item)).toList();
  }
}

class GetProject {
  String? projectAmount;
  String? projectUsed;
  String? balance;
  String? additional;

  GetProject(
      {this.projectAmount, this.projectUsed, this.balance, this.additional});

  GetProject.fromJson(Map<String, dynamic> json) {
    projectAmount = json['project_amount'];
    projectUsed = json['project_used'];
    balance = json['balance'];
    additional = json['additional'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['project_amount'] = projectAmount;
    data['project_used'] = projectUsed;
    data['balance'] = balance;
    data['additional'] = additional;
    return data;
  }

  static List<GetProject>? fromJsonList(List list) {
    //if (list == null) return null;
    return list.map((item) => GetProject.fromJson(item)).toList();
  }
}

class GetCustomer {
  String? sHOWDATE1;
  String? bookRevice;
  String? tOT;

  GetCustomer({this.sHOWDATE1, this.bookRevice, this.tOT});

  GetCustomer.fromJson(Map<String, dynamic> json) {
    sHOWDATE1 = json['SHOWDATE1'];
    bookRevice = json['book_revice'];
    tOT = json['TOT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['SHOWDATE1'] = sHOWDATE1;
    data['book_revice'] = bookRevice;
    data['TOT'] = tOT;
    return data;
  }

  static List<GetCustomer>? fromJsonList(List list) {
    //if (list == null) return null;
    return list.map((item) => GetCustomer.fromJson(item)).toList();
  }
}

class GetMail {
  String? item;
  String? mailno;
  String? maildate1;
  String? sendcode;
  String? recivecode;
  String? reciveby;
  String? fy;
  String? subjects;
  String? status;
  String? flag;
  String? deadline;
  String? mailStatusBox;
  String? type;
  String? getType;
  String? attachqty;
  String? priority;
  String? nickname;
  String? companycode;
  String? nicknamet;
  String? nickname2;
  String? firstname;
  String? deptname;
  String? mailnoType;
  String? secretTime;
  String? autoType;
  String? mark;
  String? statusMail;
  String? rname;
  String? company;

  GetMail(
      {this.item,
      this.mailno,
      this.maildate1,
      this.sendcode,
      this.recivecode,
      this.reciveby,
      this.fy,
      this.subjects,
      this.status,
      this.flag,
      this.deadline,
      this.mailStatusBox,
      this.type,
      this.getType,
      this.attachqty,
      this.priority,
      this.nickname,
      this.companycode,
      this.nicknamet,
      this.nickname2,
      this.firstname,
      this.deptname,
      this.mailnoType,
      this.secretTime,
      this.autoType,
      this.mark,
      this.statusMail,
      this.rname,
      this.company});

  GetMail.fromJson(Map<String, dynamic> json) {
    item = json['item'] ?? '';
    mailno = json['mailno'] ?? '';
    maildate1 = json['maildate1'] ?? '';
    sendcode = json['sendcode'] ?? '';
    recivecode = json['recivecode'] ?? '';
    reciveby = json['reciveby'] ?? '';
    fy = json['fy'] ?? '';
    subjects = json['subjects'] ?? '';
    status = json['status'] ?? '';
    flag = json['flag'] ?? '';
    deadline = json['deadline'] ?? '';
    mailStatusBox = json['mail_status_box'] ?? '';
    type = json['type'] ?? '';
    getType = json['get_type'] ?? '';
    attachqty = json['attachqty'] ?? '';
    priority = json['priority'] ?? '';
    nickname = json['nickname'] ?? '';
    companycode = json['companycode'] ?? '';
    nicknamet = json['nicknamet'] ?? '';
    nickname2 = json['nickname2'] ?? '';
    firstname = json['firstname'] ?? '';
    deptname = json['deptname'] ?? '';
    mailnoType = json['mailno_type'] ?? '';
    secretTime = json['secret_time'] ?? '';
    autoType = json['auto_type'] ?? '';
    mark = json['mark'] ?? '';
    statusMail = json['status_mail'] ?? '';
    rname = json['rname'] ?? '';
    company = json['company'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['item'] = item;
    data['mailno'] = mailno;
    data['maildate1'] = maildate1;
    data['sendcode'] = sendcode;
    data['recivecode'] = recivecode;
    data['reciveby'] = reciveby;
    data['fy'] = fy;
    data['subjects'] = subjects;
    data['status'] = status;
    data['flag'] = flag;
    data['deadline'] = deadline;
    data['mail_status_box'] = mailStatusBox;
    data['type'] = type;
    data['get_type'] = getType;
    data['attachqty'] = attachqty;
    data['priority'] = priority;
    data['nickname'] = nickname;
    data['companycode'] = companycode;
    data['nicknamet'] = nicknamet;
    data['nickname2'] = nickname2;
    data['firstname'] = firstname;
    data['deptname'] = deptname;
    data['mailno_type'] = mailnoType;
    data['secret_time'] = secretTime;
    data['auto_type'] = autoType;
    data['mark'] = mark;
    data['status_mail'] = statusMail;
    data['rname'] = rname;
    data['company'] = company;
    return data;
  }

  static List<GetMail>? fromJsonList(List list) {
    //if (list == null) return null;
    return list.map((item) => GetMail.fromJson(item)).toList();
  }
}

class GetMailDetail {
  String? detail;
  String? subjects;

  GetMailDetail({this.detail, this.subjects});

  GetMailDetail.fromJson(Map<String, dynamic> json) {
    detail = json['detail'];
    subjects = json['subjects'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['detail'] = detail;
    data['subjects'] = subjects;
    return data;
  }

  static List<GetMailDetail>? fromJsonList(List list) {
    //if (list == null) return null;
    return list.map((item) => GetMailDetail.fromJson(item)).toList();
  }
}

class GetCC {
  String? recivecode;
  String? recivename;
  String? fname;
  String? company;

  GetCC({this.recivecode, this.recivename, this.fname, this.company});

  GetCC.fromJson(Map<String, dynamic> json) {
    recivecode = json['recivecode'];
    recivename = json['recivename'];
    fname = json['fname'];
    company = json['company'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['recivecode'] = recivecode;
    data['recivename'] = recivename;
    data['fname'] = fname;
    data['company'] = company;
    return data;
  }

  static List<GetCC>? fromJsonList(List list) {
    //if (list == null) return null;
    return list.map((item) => GetCC.fromJson(item)).toList();
  }
}
