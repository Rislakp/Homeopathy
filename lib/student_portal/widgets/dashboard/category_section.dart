import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/import.dart';

class CategorySection extends StatefulWidget {
  const CategorySection({super.key});

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  // int SelectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoryProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.circle,
                size: 10,
                color: Color(0xff009B5A),
                // color:  Color(0xff009B5A),
              ),
              AppSpacing.w8,

              Text(
                "Popular Categories",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        AppSpacing.h30,
        const Text(
          "Learn what you love. Master what you need.",
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),

        AppSpacing.h16,

        const Text(
          "From AIAPGET and NEET PG to the classical pillars of homeopathy — pick your track.",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),

        AppSpacing.h40,

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: provider.categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,

            mainAxisExtent: 220,
          ),

          itemBuilder: (context, index) {
            final category = provider.categories[index];

            return CategoryCard(
              title: category.title,
              subtitle: category.subtitle,
              icon: category.icon,
              index: index,
            );
          },
        ),
      ],
    );
  }
}
