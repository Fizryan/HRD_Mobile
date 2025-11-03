import 'dart:convert';
import 'package:hrd_system_project/controllers/variable.dart';
import 'package:hrd_system_project/data/user_data.dart';
import 'package:hrd_system_project/models/status_m.dart';
import 'package:hrd_system_project/models/user_m.dart';
import 'package:hrd_system_project/models/user_requests_m.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRequestsData {
  static const String _keyRequests = 'requests';

  static Future<void> saveRequests(List<ApprovalRequest> requests) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> requestsJsonList = requests
        .map((request) => jsonEncode(request.toJson()))
        .toList();
    await prefs.setStringList(_keyRequests, requestsJsonList);
  }

  static Future<List<ApprovalRequest>> loadRequests() async {
    final prefs = await SharedPreferences.getInstance();
    final requestsJsonList = prefs.getStringList(_keyRequests);

    if (requestsJsonList == null) return [];

    return requestsJsonList.map((jsonStr) {
      final requestMap = jsonDecode(jsonStr);
      return ApprovalRequest.fromJson(requestMap);
    }).toList();
  }

  static Future<void> resetRequests() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyRequests);
  }

  static Future<List<ApprovalRequest>> getPendingRequests() async {
    List<ApprovalRequest> requests = await loadRequests();
    if (requests.isEmpty) {
      List<User> userList = await UserList.getAllUsers();
      userList = userList
          .where((user) => user.role == UserRole.employee)
          .toList();
      requests = [
        ApprovalRequest(
          id: 1,
          name: userList[0].name,
          role: userList[0].role,
          type: RequestType.cutiTahunan,
          date: CurrentDate.getDate(),
          days: CurrentRandom.getIntRandom(1, 5),
          reason: "Annual leave for family vacation.",
        ),
        ApprovalRequest(
          id: 2,
          name: userList[1].name,
          role: userList[1].role,
          type: RequestType.izinSakit,
          date: CurrentDate.getDate(),
          days: CurrentRandom.getIntRandom(1, 3),
          reason: "Sick leave due to high fever.",
        ),
        ApprovalRequest(
          id: 3,
          name: userList[2].name,
          role: userList[2].role,
          type: RequestType.businessTrip,
          date: CurrentDate.getDate(),
          days: CurrentRandom.getIntRandom(2, 7),
          reason: "Business trip to Jakarta for a meeting.",
        ),
        ApprovalRequest(
          id: 4,
          name: userList[3].name,
          role: userList[3].role,
          type: RequestType.claimReimbursment,
          date: CurrentDate.getDate(),
          days: 0,
          amount: CurrentRandom.getDoubleRandom(100000, 500000),
          reason: "Claim for transportation cost reimbursement.",
        ),
        ApprovalRequest(
          id: 5,
          name: userList[4].name,
          role: userList[4].role,
          type: RequestType.cutiTahunan,
          date: CurrentDate.getDate(),
          days: CurrentRandom.getIntRandom(3, 7),
          reason: "Annual leave for personal reasons.",
        ),
        ApprovalRequest(
          id: 6,
          name: userList[5].name,
          role: userList[5].role,
          type: RequestType.cutiTahunan,
          date: CurrentDate.getDate(),
          days: CurrentRandom.getIntRandom(2, 5),
          reason: "Annual leave to attend a family event.",
        ),
        ApprovalRequest(
          id: 7,
          name: userList[6].name,
          role: userList[6].role,
          type: RequestType.izinSakit,
          date: CurrentDate.getDate(),
          days: CurrentRandom.getIntRandom(1, 3),
          reason: "Sick leave due to severe flu.",
        ),
        ApprovalRequest(
          id: 8,
          name: userList[7].name,
          role: userList[7].role,
          type: RequestType.businessTrip,
          date: CurrentDate.getDate(),
          days: CurrentRandom.getIntRandom(2, 4),
          reason: "Business trip to Bandung for internal training.",
        ),
        ApprovalRequest(
          id: 9,
          name: userList[8].name,
          role: userList[8].role,
          type: RequestType.cutiTahunan,
          date: CurrentDate.getDate(),
          days: CurrentRandom.getIntRandom(7, 14),
          reason: "Maternity leave according to HR regulations.",
        ),
        ApprovalRequest(
          id: 10,
          name: userList[9].name,
          role: userList[9].role,
          type: RequestType.claimReimbursment,
          date: CurrentDate.getDate(),
          days: 0,
          amount: CurrentRandom.getDoubleRandom(100000, 200000),
          reason: "Claim for transportation and meal costs during out-of-town assignments.",
        ),
      ];
      await saveRequests(requests);
    }
    return requests;
  }
}
