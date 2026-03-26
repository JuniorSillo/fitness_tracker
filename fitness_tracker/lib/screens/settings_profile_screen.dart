import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';

class SettingsProfileScreen extends StatefulWidget {
  const SettingsProfileScreen({super.key});

  @override
  State<SettingsProfileScreen> createState() => _SettingsProfileScreenState();
}

class _SettingsProfileScreenState extends State<SettingsProfileScreen> {
  final _formKey       = GlobalKey<FormState>();
  final _nameController   = TextEditingController();
  final _ageController    = TextEditingController();
  final _goalController   = TextEditingController();

  
  late double _sliderValue;

  @override
  void initState() {
    super.initState();
    final profile = context.read<ProfileProvider>();
    _nameController.text  = profile.name == 'Guest' ? '' : profile.name;
    _ageController.text   = profile.age  == 0       ? '' : '${profile.age}';
    _goalController.text  = profile.weightGoal == 0.0 ? '' : '${profile.weightGoal}';
    _sliderValue          = profile.restTimer.toDouble();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  // Helpers
  String _formatTimer(double seconds) {
    final s = seconds.toInt();
    if (s < 60) return '$s seconds';
    final m = s ~/ 60;
    final rem = s % 60;
    return rem == 0 ? '$m min' : '$m min $rem sec';
  }

  // Save profile fields
  void _saveProfile() {
    if (!_formKey.currentState!.validate()) return;
    final profile = context.read<ProfileProvider>();
    profile.saveName(_nameController.text);

    final age = int.tryParse(_ageController.text.trim());
    if (age != null) profile.saveAge(age);

    final goal = double.tryParse(_goalController.text.trim());
    if (goal != null) profile.saveWeightGoal(goal);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile saved!'),
        backgroundColor: Color(0xFF2DE394),
        duration: Duration(seconds: 1),
      ),
    );
  }

  // Dialogs 
  void _confirmResetProfile() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF196745),
        title: const Text('Reset Profile',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text(
          'This will permanently delete your name, age, and weight goal. '
          'Your app preferences (unit system, rest timer, notifications) will NOT be affected.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.white60)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white),
            onPressed: () async {
              await context.read<ProfileProvider>().resetProfile();
              if (!mounted) return;
              Navigator.pop(ctx);
              _nameController.clear();
              _ageController.clear();
              _goalController.clear();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile data reset.'),
                  backgroundColor: Colors.redAccent,
                ),
              );
            },
            child: const Text('Reset Profile'),
          ),
        ],
      ),
    );
  }

  void _confirmResetEverything() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF196745),
        title: const Text('Reset Everything',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text(
          'This will permanently delete ALL your data — your profile AND all '
          'app preferences. The app will return to its default state. '
          'This cannot be undone.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.white60)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white),
            onPressed: () async {
              await context.read<ProfileProvider>().resetEverything();
              if (!mounted) return;
              Navigator.pop(ctx);
              _nameController.clear();
              _ageController.clear();
              _goalController.clear();
              setState(() => _sliderValue = 60);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All data has been reset.'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Reset Everything'),
          ),
        ],
      ),
    );
  }

  
  @override
  Widget build(BuildContext context) {
    // watch so suffix and slider label react to unit changes instantly
    final profile = context.watch<ProfileProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Settings',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF196745),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //  PROFILE SECTION 
              _sectionHeader('Profile', Icons.person_rounded),
              const SizedBox(height: 16),

              // Name
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Your Name', 'e.g. Alex', Icons.badge_outlined),
                validator: (v) {
                  if (v != null && v.trim().isNotEmpty && v.trim().length < 2) {
                    return 'Name must be at least 2 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Age
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Age', 'e.g. 25', Icons.cake_outlined),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return null;
                  final age = int.tryParse(v.trim());
                  if (age == null) return 'Enter a whole number';
                  if (age < 1 || age > 120) return 'Age must be between 1 and 120';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Weight Goal, suffix reacts to unit changes in real time
              TextFormField(
                controller: _goalController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration(
                  'Weight Goal',
                  'e.g. 75',
                  Icons.flag_outlined,
                  suffix: profile.weightUnit, // live unit suffix
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return null;
                  final goal = double.tryParse(v.trim());
                  if (goal == null) return 'Enter a valid number';
                  if (goal < 0) return 'Weight goal must be positive';
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Save profile button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveProfile,
                  icon: const Icon(Icons.save_rounded),
                  label: const Text('Save Profile',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2DE394),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),

              const SizedBox(height: 36),
              const Divider(color: Colors.white24),
              const SizedBox(height: 16),

              // PREFERENCES SECTION 
              _sectionHeader('Preferences', Icons.tune_rounded),
              const SizedBox(height: 20),

             
              const Text('Weight Unit',
                  style: TextStyle(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 10),
              Center(
                child: SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'kg', label: Text('kg'), icon: Icon(Icons.scale)),
                    ButtonSegment(value: 'lbs', label: Text('lbs'), icon: Icon(Icons.monitor_weight_outlined)),
                  ],
                  selected: {profile.weightUnit},
                  onSelectionChanged: (selected) {
                    context.read<ProfileProvider>().saveWeightUnit(selected.first);
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return const Color(0xFF2DE394);
                      }
                      return const Color(0xFF196745);
                    }),
                    foregroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return Colors.black;
                      }
                      return Colors.white70;
                    }),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Rest Timer slider
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Rest Timer',
                      style: TextStyle(color: Colors.white70, fontSize: 14)),
                  Text(
                    _formatTimer(_sliderValue),
                    style: const TextStyle(
                        color: Color(0xFF2DE394),
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                ],
              ),
              Slider(
                value: _sliderValue,
                min: 15,
                max: 300,
                divisions: 19, 
                activeColor: const Color(0xFF2DE394),
                inactiveColor: Colors.white24,
                onChanged: (val) {
                  // Update RAM instantly for smooth UI
                  setState(() => _sliderValue = val);
                },
                onChangeEnd: (val) {
                  // Write to disk only when user lifts finger
                  context.read<ProfileProvider>().saveRestTimer(val.toInt());
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('15s', style: TextStyle(color: Colors.white38, fontSize: 12)),
                    Text('300s', style: TextStyle(color: Colors.white38, fontSize: 12)),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Notifications toggle
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF196745),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SwitchListTile(
                  title: const Text('Notifications',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Workout reminders and tips',
                      style: TextStyle(color: Colors.white54, fontSize: 13)),
                  secondary: const Icon(Icons.notifications_outlined,
                      color: Color(0xFF2DE394)),
                  value: profile.notificationsEnabled,
                  activeColor: const Color(0xFF2DE394),
                  onChanged: (val) {
                    context.read<ProfileProvider>().saveNotifications(val);
                  },
                ),
              ),

              const SizedBox(height: 40),
              const Divider(color: Colors.white24),
              const SizedBox(height: 20),

              // EXTRA CREDIT 
              _sectionHeader('Danger Zone', Icons.warning_amber_rounded, color: Colors.redAccent),
              const SizedBox(height: 16),

              // Reset Profile (outlined)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _confirmResetProfile,
                  icon: const Icon(Icons.person_off_outlined, color: Colors.redAccent),
                  label: const Text('Reset Profile Data',
                      style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.redAccent),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  'Clears name, age, and weight goal. Preferences are kept.',
                  style: TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ),
              const SizedBox(height: 20),

              // Reset Everything (filled)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _confirmResetEverything,
                  icon: const Icon(Icons.delete_forever_rounded),
                  label: const Text('Reset Everything',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  'Clears ALL data including preferences. Cannot be undone.',
                  style: TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable widgets 
  Widget _sectionHeader(String title, IconData icon,
      {Color color = const Color(0xFF2DE394)}) {
    return Row(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(width: 8),
        Text(title,
            style: TextStyle(
                color: color, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  InputDecoration _inputDecoration(String label, String hint, IconData icon,
      {String? suffix}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white54),
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white24),
      prefixIcon: Icon(icon, color: const Color(0xFF2DE394)),
      suffixText: suffix,
      suffixStyle: const TextStyle(
          color: Color(0xFF2DE394), fontWeight: FontWeight.bold),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF2DE394)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      filled: true,
      fillColor: const Color(0xFF196745),
    );
  }
}
