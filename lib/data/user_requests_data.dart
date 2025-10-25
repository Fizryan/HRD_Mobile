import 'package:hrd_system_project/controllers/variable.dart';
import 'package:hrd_system_project/data/user_data.dart';
import 'package:hrd_system_project/models/status_m.dart';
import 'package:hrd_system_project/models/user_m.dart';
import 'package:hrd_system_project/models/user_requests_m.dart';

class UserRequestsData {
  static List<ApprovalRequest> getPendingRequests() {
    List<User> userList = UserList.getAllUsers()
        .where((user) => user.role == UserRole.employee)
        .toList();
    return [
      ApprovalRequest(
        id: 1,
        name: userList[0].name,
        role: userList[0].role,
        type: RequestType.cutiTahunan,
        date: CurrentDate.getDate(),
        days: CurrentRandom.getIntRandom(1, 5),
        reason: "Cuti tahunan untuk liburan keluarga.",
      ),
      ApprovalRequest(
        id: 2,
        name: userList[1].name,
        role: userList[1].role,
        type: RequestType.izinSakit,
        date: CurrentDate.getDate(),
        days: CurrentRandom.getIntRandom(1, 3),
        reason: "Izin sakit karena demam tinggi.",
      ),
      ApprovalRequest(
        id: 3,
        name: userList[2].name,
        role: userList[2].role,
        type: RequestType.businessTrip,
        date: CurrentDate.getDate(),
        days: CurrentRandom.getIntRandom(2, 7),
        reason: "Perjalanan dinas ke Jakarta untuk meeting.",
      ),
      ApprovalRequest(
        id: 4,
        name: userList[3].name,
        role: userList[3].role,
        type: RequestType.claimReimbursment,
        date: CurrentDate.getDate(),
        days: 0,
        amount: CurrentRandom.getDoubleRandom(100000, 500000),
        reason: "Klaim reimbursement biaya transportasi.",
      ),
      ApprovalRequest(
        id: 5,
        name: userList[4].name,
        role: userList[4].role,
        type: RequestType.cutiTahunan,
        date: CurrentDate.getDate(),
        days: CurrentRandom.getIntRandom(3, 7),
        reason: "Cuti tahunan untuk keperluan pribadi.",
      ),
      ApprovalRequest(
        id: 6,
        name: userList[5].name,
        role: userList[5].role,
        type: RequestType.cutiTahunan,
        date: CurrentDate.getDate(),
        days: CurrentRandom.getIntRandom(2, 5),
        reason: "Cuti tahunan untuk menghadiri acara keluarga.",
      ),
      ApprovalRequest(
        id: 7,
        name: userList[6].name,
        role: userList[6].role,
        type: RequestType.izinSakit,
        date: CurrentDate.getDate(),
        days: CurrentRandom.getIntRandom(1, 3),
        reason: "Izin sakit karena flu berat.",
      ),
      ApprovalRequest(
        id: 8,
        name: userList[7].name,
        role: userList[7].role,
        type: RequestType.businessTrip,
        date: CurrentDate.getDate(),
        days: CurrentRandom.getIntRandom(2, 4),
        reason: "Perjalanan dinas ke Bandung untuk pelatihan internal.",
      ),
      ApprovalRequest(
        id: 9,
        name: userList[8].name,
        role: userList[8].role,
        type: RequestType.cutiTahunan,
        date: CurrentDate.getDate(),
        days: CurrentRandom.getIntRandom(7, 14),
        reason: "Cuti melahirkan sesuai ketentuan HR.",
      ),
      ApprovalRequest(
        id: 10,
        name: userList[9].name,
        role: userList[9].role,
        type: RequestType.claimReimbursment,
        date: CurrentDate.getDate(),
        days: 0,
        amount: CurrentRandom.getDoubleRandom(100000, 200000),
        reason: "Klaim biaya transportasi dan makan saat tugas luar kota.",
      ),
    ];
  }
}
