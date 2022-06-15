class AddScratchPad {
  final String isi;
  AddScratchPad({
    required this.isi,
  });

  Map<String, dynamic> toJson() => {
        'content': isi,
      };
}

class NotebookList {
  final String notebookName;
  final String timeCreated;
  final String timeModif;

  NotebookList({
    required this.notebookName,
    required this.timeCreated,
    required this.timeModif,
  });

  Map<String, dynamic> toJson() => {
        'Notebook': notebookName,
        'timeCreated': timeCreated,
        'timeModif': timeModif,
      };
}

class UserData {
  final String name;
  final String? email;
  final String alasan;
  final String know;
  final String? gender;
  final dynamic time;
  final bool? newsletter;

  UserData(
      {required this.name,
      required this.email,
      required this.know,
      required this.gender,
      required this.alasan,
      required this.newsletter,
      required this.time});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'] as String,
      email: json['email'] as String,
      gender: json['gender'] as String,
      know: json['know'] as String,
      newsletter: json['newsletter'] as bool,
      alasan: json['alasan'] as String,
      time: json['time'] as dynamic,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'alasan': alasan,
        'gender': gender,
        'newsletter': newsletter,
        'know': know,
        'time': time,
      };
}


// class HelpForm {
//   final String name;
//   final String? email;
//   final String subject;
//   final String detail;

//   HelpForm({
//     required this.name,
//     required this.email,
//     required this.subject,
//     required this.detail,
//   });

//   Map<String, dynamic> toJson() => {
//         'name': name,
//         'email': email,
//         'subject': subject,
//         'detail': detail,
//       };
// }
