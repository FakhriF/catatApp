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
