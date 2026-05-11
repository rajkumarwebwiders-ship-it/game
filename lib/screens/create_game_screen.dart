import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/game_bloc/game_bloc.dart';
import '../bloc/game_bloc/game_event.dart';
import '../bloc/game_bloc/game_state.dart';
import '../models/game_model.dart';
import '../services/game_service.dart';
import '../widgets/custom_dropdown_field.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/custom_text_field.dart';

/// [CreateGameScreen] allows a coach to create a new game.
///
/// Refactored to eliminate **setState** entirely:
/// 1. **BLoC**: Handles business logic and asynchronous states (Saving, Success, Failure).
/// 2. **ValueNotifier**: Handles local ephemeral UI states (Sport and Grade selections).
///
/// This approach ensures a highly reactive and performant UI by only rebuilding
/// the specific widgets that need to change.
class CreateGameScreen extends StatefulWidget {
  const CreateGameScreen({super.key});

  @override
  State<CreateGameScreen> createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends State<CreateGameScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text controllers manage input values and have their own listeners
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _teamAController = TextEditingController();
  final TextEditingController _teamBController = TextEditingController();

  // ValueNotifiers for granular local state management without setState
  final ValueNotifier<String?> _sportNotifier = ValueNotifier<String?>(null);
  final ValueNotifier<String?> _gradeNotifier = ValueNotifier<String?>(null);

  final List<String> _sports = ['Camogie', 'Hurling', 'Football', 'Handball'];
  final List<String> _grades = ['U14', 'U16', 'Minor', 'Junior', 'Senior'];

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _locationController.dispose();
    _teamAController.dispose();
    _teamBController.dispose();
    _sportNotifier.dispose();
    _gradeNotifier.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      // Controllers handle their own internal notification to the TextField
      _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      _timeController.text = picked.format(context);
    }
  }

  void _onSavePressed(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final game = GameModel(
        date: _dateController.text,
        time: _timeController.text,
        location: _locationController.text,
        sport: _sportNotifier.value!,
        grade: _gradeNotifier.value!,
        teamA: _teamAController.text,
        teamB: _teamBController.text,
        createdAt: DateTime.now(),
      );

      context.read<GameBloc>().add(SaveGameEvent(game));
    }
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _dateController.clear();
    _timeController.clear();
    _locationController.clear();
    _teamAController.clear();
    _teamBController.clear();
    _sportNotifier.value = null;
    _gradeNotifier.value = null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => GameBloc(gameService: GameService()),
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        appBar: AppBar(title: const Text('Create Game')),
        body: BlocListener<GameBloc, GameState>(
          listener: (context, state) {
            if (state is GameSuccess) {
              CustomSnackBar.showSuccess(context, 'Game saved successfully!');
              _resetForm();
            } else if (state is GameFailure) {
              CustomSnackBar.showError(
                context,
                'Failed to save game: ${state.message}',
              );
            }
          },
          child: BlocBuilder<GameBloc, GameState>(
            builder: (context, state) {
              final isLoading = state is GameLoading;

              return Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CustomTextField(
                            controller: _dateController,
                            label: 'Date',
                            icon: Icons.calendar_today,
                            onTap: _selectDate,
                            readOnly: true,
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _timeController,
                            label: 'Time',
                            icon: Icons.access_time,
                            onTap: _selectTime,
                            readOnly: true,
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _locationController,
                            label: 'Location',
                            icon: Icons.location_on,
                          ),
                          const SizedBox(height: 16),

                          // ValueListenableBuilder for reactive Dropdown without setState
                          ValueListenableBuilder<String?>(
                            valueListenable: _sportNotifier,
                            builder: (context, sport, _) {
                              return CustomDropdownField(
                                value: sport,
                                label: 'Sport',
                                icon: Icons.sports,
                                items: _sports,
                                onChanged: (val) => _sportNotifier.value = val,
                              );
                            },
                          ),
                          const SizedBox(height: 16),

                          ValueListenableBuilder<String?>(
                            valueListenable: _gradeNotifier,
                            builder: (context, grade, _) {
                              return CustomDropdownField(
                                value: grade,
                                label: 'Grade',
                                icon: Icons.grade,
                                items: _grades,
                                onChanged: (val) => _gradeNotifier.value = val,
                              );
                            },
                          ),
                          const SizedBox(height: 16),

                          CustomTextField(
                            controller: _teamAController,
                            label: 'Team A',
                            icon: Icons.group,
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _teamBController,
                            label: 'Team B',
                            icon: Icons.group,
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () => _onSavePressed(context),
                            child: const Text('Save Game'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isLoading)
                    Container(
                      color: Colors.black12,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
