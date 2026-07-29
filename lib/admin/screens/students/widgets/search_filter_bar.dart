import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:homeopathy/responsive/responsive_constants.dart';
import '../provider/student_provider.dart';

class SearchFilterBar extends StatefulWidget {
  final VoidCallback onExportPressed;
  final VoidCallback onAddStudentPressed;

  const SearchFilterBar({
    super.key,
    required this.onExportPressed,
    required this.onAddStudentPressed,
  });

  @override
  State<SearchFilterBar> createState() => _SearchFilterBarState();
}

class _SearchFilterBarState extends State<SearchFilterBar> {
  late TextEditingController _searchController;

  final List<String> _courses = [
    'All Courses',
    'Classical Homeopathy',
    'Materia Medica',
    'Repertory',
    'Organon',
    'Pharmacy',
    'Anatomy',
    'Physiology',
    'Pathology'
  ];

  final List<String> _statuses = [
    'All Status',
    'Active',
    'Trial',
    'Expired',
    'Inactive'
  ];

  @override
  void initState() {
    super.initState();
    final provider = context.read<StudentProvider>();
    _searchController = TextEditingController(text: provider.searchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StudentProvider>();

    if (_searchController.text != provider.searchQuery) {
      _searchController.text = provider.searchQuery;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Utilize existing project responsive constants
        final isMobile = constraints.maxWidth <= ResponsiveConstants.mobileMax;
        final isTablet = constraints.maxWidth > ResponsiveConstants.mobileMax &&
            constraints.maxWidth <= ResponsiveConstants.tabletMax;

        if (isMobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSearchField(provider),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildCourseDropdown(provider)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatusDropdown(provider)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildExportButton()),
                  const SizedBox(width: 12),
                  Expanded(child: _buildAddButton()),
                ],
              ),
            ],
          );
        } else if (isTablet) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(flex: 2, child: _buildSearchField(provider)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildCourseDropdown(provider)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatusDropdown(provider)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildExportButton(),
                  const SizedBox(width: 12),
                  _buildAddButton(),
                ],
              ),
            ],
          );
        } else {
          return Row(
            children: [
              Expanded(
                flex: 3,
                child: _buildSearchField(provider),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 200,
                child: _buildCourseDropdown(provider),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 160,
                child: _buildStatusDropdown(provider),
              ),
              const SizedBox(width: 16),
              _buildExportButton(),
              const SizedBox(width: 16),
              _buildAddButton(),
            ],
          );
        }
      },
    );
  }

  Widget _buildSearchField(StudentProvider provider) {
    return SizedBox(
      height: 46,
      child: TextField(
        controller: _searchController,
        onChanged: (value) => provider.searchStudents(value),
        decoration: InputDecoration(
          hintText: 'Search students...',
          hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF9CA3AF), size: 20),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Color(0xFF9CA3AF), size: 18),
                  onPressed: () {
                    _searchController.clear();
                    provider.searchStudents('');
                  },
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF10B981), width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildCourseDropdown(StudentProvider provider) {
    return SizedBox(
      height: 46,
      child: DropdownButtonFormField<String>(
        value: provider.selectedCourse,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF10B981), width: 1.5),
          ),
        ),
        items: _courses.map((course) {
          return DropdownMenuItem<String>(
            value: course,
            child: Text(
              course,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, color: Color(0xFF374151)),
            ),
          );
        }).toList(),
        onChanged: (val) {
          if (val != null) {
            provider.filterCourse(val);
          }
        },
      ),
    );
  }

  Widget _buildStatusDropdown(StudentProvider provider) {
    return SizedBox(
      height: 46,
      child: DropdownButtonFormField<String>(
        value: provider.selectedStatus,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF10B981), width: 1.5),
          ),
        ),
        items: _statuses.map((status) {
          return DropdownMenuItem<String>(
            value: status,
            child: Text(
              status,
              style: const TextStyle(fontSize: 14, color: Color(0xFF374151)),
            ),
          );
        }).toList(),
        onChanged: (val) {
          if (val != null) {
            provider.filterStatus(val);
          }
        },
      ),
    );
  }

  Widget _buildExportButton() {
    return SizedBox(
      height: 46,
      child: OutlinedButton.icon(
        onPressed: widget.onExportPressed,
        icon: const Icon(Icons.download_rounded, size: 18, color: Color(0xFF4B5563)),
        label: const Text(
          'Export',
          style: TextStyle(color: Color(0xFF4B5563), fontSize: 14, fontWeight: FontWeight.w600),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: Color(0xFFD1D5DB)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return SizedBox(
      height: 46,
      child: ElevatedButton.icon(
        onPressed: widget.onAddStudentPressed,
        icon: const Icon(Icons.add, size: 18, color: Colors.white),
        label: const Text(
          'Add Student',
          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF10B981),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18),
        ),
      ),
    );
  }
}
