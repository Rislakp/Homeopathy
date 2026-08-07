
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
    'Pathology',
  ];

  final List<String> _statuses = [
    'All Status',
    'Active',
    'Trial',
    'Expired',
    'Inactive',
  ];

  @override
  void initState() {
    super.initState();

    final provider = context.read<StudentProvider>();

    _searchController = TextEditingController(
      text: provider.searchQuery,
    );
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
      _searchController.selection = TextSelection.fromPosition(
        TextPosition(offset: _searchController.text.length),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final isMobile =
            width <= ResponsiveConstants.mobileMax;

        final isTablet =
            width > ResponsiveConstants.mobileMax &&
            width <= ResponsiveConstants.tabletMax;

        // MOBILE
        if (isMobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSearchField(provider),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _buildCourseDropdown(provider),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildStatusDropdown(provider),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _buildExportButton(),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildAddButton(),
                  ),
                ],
              ),
            ],
          );
        }

        // TABLET
        if (isTablet) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildSearchField(provider),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: _buildCourseDropdown(provider),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: _buildStatusDropdown(provider),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildExportButton(),
                  const SizedBox(width: 8),
                  _buildAddButton(),
                ],
              ),
            ],
          );
        }

        // DESKTOP
        return Row(
          children: [
            // Search gets all remaining space
            Expanded(
              flex: 3,
              child: _buildSearchField(provider),
            ),

            const SizedBox(width: 12),

            // Course
            Flexible(
              flex: 2,
              child: _buildCourseDropdown(provider),
            ),

            const SizedBox(width: 12),

            // Status
            Flexible(
              flex: 1,
              child: _buildStatusDropdown(provider),
            ),

            const SizedBox(width: 12),

            // Export
            _buildExportButton(),

            const SizedBox(width: 8),

            // Add
            _buildAddButton(),
          ],
        );
      },
    );
  }

  Widget _buildSearchField(StudentProvider provider) {
    return SizedBox(
      height: 46,
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          provider.searchStudents(value);
        },
        decoration: InputDecoration(
          hintText: 'Search students...',
          hintStyle: const TextStyle(
            color: Color(0xFF9CA3AF),
            fontSize: 14,
          ),

          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xFF9CA3AF),
            size: 20,
          ),

          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.clear,
                    color: Color(0xFF9CA3AF),
                    size: 18,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    provider.searchStudents('');
                    setState(() {});
                  },
                )
              : null,

          contentPadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 16,
          ),

          filled: true,
          fillColor: Colors.white,

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFFE5E7EB),
            ),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFFE5E7EB),
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 10, 5, 100),
              width: 1.5,
            ),
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

        isExpanded: true,

        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),

          filled: true,
          fillColor: Colors.white,

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFFE5E7EB),
            ),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFFE5E7EB),
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFF10B981),
              width: 1.5,
            ),
          ),
        ),

        items: _courses.map((course) {
          return DropdownMenuItem<String>(
            value: course,
            child: Text(
              course,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF374151),
              ),
            ),
          );
        }).toList(),

        onChanged: (value) {
          if (value != null) {
            provider.filterCourse(value);
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

        isExpanded: true,

        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),

          filled: true,
          fillColor: Colors.white,

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFFE5E7EB),
            ),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFFE5E7EB),
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFF10B981),
              width: 1.5,
            ),
          ),
        ),

        items: _statuses.map((status) {
          return DropdownMenuItem<String>(
            value: status,
            child: Text(
              status,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF374151),
              ),
            ),
          );
        }).toList(),

        onChanged: (value) {
          if (value != null) {
            provider.filterStatus(value);
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

        icon: const Icon(
          Icons.download_rounded,
          size: 18,
          color: Color(0xFF4B5563),
        ),

        label: const Text(
          'Export',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Color(0xFF4B5563),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),

        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,

          side: const BorderSide(
            color: Color(0xFFD1D5DB),
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),

          padding: const EdgeInsets.symmetric(
            horizontal: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return SizedBox(
      height: 46,
      child: ElevatedButton.icon(
        onPressed: widget.onAddStudentPressed,

        icon: const Icon(
          Icons.add,
          size: 18,
          color: Colors.white,
        ),

        label: const Text(
          'Add Student',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),

        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF10B981),
          elevation: 0,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),

          padding: const EdgeInsets.symmetric(
            horizontal: 14,
          ),
        ),
      ),
    );
  }
}


