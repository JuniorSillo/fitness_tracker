import 'package:flutter/material.dart';
import '../app_router.dart'; 
class WorkoutCategoryTile extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;

  const WorkoutCategoryTile({
    required this.title,
    required this.icon,
    required this.color,
    super.key,
  });

  @override
  State<WorkoutCategoryTile> createState() => _WorkoutCategoryTileState();
}

class _WorkoutCategoryTileState extends State<WorkoutCategoryTile> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      
      onTap: () {
        Navigator.of(context).pushRouteWithArgs(
          AppRoute.exerciseList,
          ExerciseListArgs(
            categoryName: widget.title,
            themeColor: widget.color,     // pass the category-specific color
            iconData: widget.icon,        // pass the category icon
          ),
        );
      },

      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF196745),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Category icon 
            Positioned(
              top: 16,
              left: 16,
              child: Icon(
                widget.icon,
                size: 36,
                color: widget.color.withOpacity(0.9),
              ),
            ),

            // Favorite heart button 
            Positioned(
              top: 16,
              right: 12,
              child: IconButton(
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? const Color(0xFF2DE394) : Colors.white70,
                  size: 28,
                ),
                onPressed: () {
                  setState(() {
                    _isFavorite = !_isFavorite;
                  });
                },
              ),
            ),

            
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
