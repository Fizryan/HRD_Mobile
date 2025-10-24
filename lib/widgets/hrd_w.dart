import 'package:flutter/material.dart';
import 'package:hrd_system_project/controllers/variable.dart';
import 'package:hrd_system_project/data/user_color.dart';
import 'package:hrd_system_project/models/user_m.dart';
import 'package:hrd_system_project/widgets/general_w.dart';

class HrdPanel extends StatefulWidget {
  final User user;
  const HrdPanel({super.key, required this.user});
  @override
  State<HrdPanel> createState() => _HrdPanelState();
}

class _HrdPanelState extends State<HrdPanel>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int currentEmployee = CurrentRandom.getIntRandom(50, 200);
    String currentDate = CurrentDate.getDate();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context, currentDate: currentDate),
            const SizedBox(height: 16),
            _buildStatsGrid(
              currentDate: currentDate,
              currentEmployee: currentEmployee,
            ),
            const SizedBox(height: 8),
            ...GeneralWidget().toDoInfoChildrens(
              'Pengajuan Cuti',
              'Pengajuan baru menunggu persetujuan Anda.',
              (currentEmployee / 8).toInt(),
              Icon(Icons.chevron_right),
              widget.user,
            ),
            const SizedBox(height: 24),
            _buildQuickActions(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, {required String currentDate}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                "Berikut ringkasan aktivitas hari ini",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.purple[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.purple[100]!),
          ),
          child: Text(
            currentDate,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.purple[800],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid({
    required String currentDate,
    required int currentEmployee,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth < 600 ? 2 : 4;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: crossAxisCount == 2 ? 0.96 : 1,
          children: [
            _buildStatCard(
              title: "Total Karyawan",
              value: currentEmployee.toString(),
              icon: Icons.people_outline,
              color: Colors.blue,
              change: currentDate,
            ),
            _buildStatCard(
              title: "Cuti Pending",
              value: (currentEmployee / 8).toInt().toString(),
              icon: Icons.beach_access_outlined,
              color: Colors.orange,
              change: "Butuh approval",
            ),
            _buildStatCard(
              title: "Absensi Hari Ini",
              value: "${CurrentRandom.getIntRandom(75, 95)}%",
              icon: Icons.fact_check_outlined,
              color: Colors.green,
              change: CurrentDate.getTime(),
            ),
            _buildStatCard(
              title: "Training Aktif",
              value: CurrentRandom.getIntRandom(0, 20).toString(),
              icon: Icons.school_outlined,
              color: Colors.purple,
              change: "20 peserta",
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String change,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: ColorUser().getColor(widget.user.role),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: change.contains("+")
                        ? Colors.green[50]
                        : Colors.orange[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    change.contains("+") ? "↑" : "!",
                    style: TextStyle(
                      color: change.contains("+")
                          ? Colors.green
                          : Colors.orange,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              change,
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Actions",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 380;
            final crossAxisCount = isNarrow ? 2 : 4;

            return GridView.count(
              crossAxisCount: crossAxisCount,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.1,
              children: [
                _buildActionButton(
                  icon: Icons.storage_outlined,
                  label: "Master Data",
                  subtitle: "Jabatan, tipe karyawan",
                  color: Colors.purple,
                ),
                _buildActionButton(
                  icon: Icons.edit_note_outlined,
                  label: "Edit Karyawan",
                  subtitle: "Update data karyawan",
                  color: Colors.blue,
                ),
                _buildActionButton(
                  icon: Icons.fact_check_outlined,
                  label: "Approval Cuti",
                  subtitle: "8 pending requests",
                  color: Colors.orange,
                ),
                _buildActionButton(
                  icon: Icons.assessment_outlined,
                  label: "Laporan",
                  subtitle: "Generate reports",
                  color: Colors.green,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: ColorUser().getColor(widget.user.role),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
