import 'package:hrd_system_project/controllers/variable.dart';
import 'package:hrd_system_project/models/status_m.dart';
import 'package:hrd_system_project/models/user_requests_m.dart';

class UserRequestsData {
  static List<ApprovalRequest> getPendingRequests() {
    return [
      ApprovalRequest(
        id: 1,
        name: "Bunga",
        type: RequestType.cutiTahunan,
        date: CurrentDate.getDate(),
        days: CurrentRandom.getIntRandom(1, 5),
        reason: "Cuti tahunan untuk liburan keluarga.",
      ),
      ApprovalRequest(
        id: 2,
        name: "Andi",
        type: RequestType.izinSakit,
        date: CurrentDate.getDate(),
        days: CurrentRandom.getIntRandom(1, 3),
        reason: "Izin sakit karena demam tinggi.",
      ),
      ApprovalRequest(
        id: 3,
        name: "Cecep",
        type: RequestType.businessTrip,
        date: CurrentDate.getDate(),
        days: CurrentRandom.getIntRandom(2, 7),
        reason: "Perjalanan dinas ke Jakarta untuk meeting.",
      ),
      ApprovalRequest(
        id: 4,
        name: "Dewi",
        type: RequestType.claimReimbursment,
        date: CurrentDate.getDate(),
        days: 0,
        amount: CurrentRandom.getDoubleRandom(100000, 500000),
        reason: "Klaim reimbursement biaya transportasi.",
      ),
      ApprovalRequest(
        id: 5,
        name: "Eko",
        type: RequestType.cutiTahunan,
        date: CurrentDate.getDate(),
        days: CurrentRandom.getIntRandom(3, 7),
        reason: "Cuti tahunan untuk keperluan pribadi.",
      ),
    ];
  }
}
