import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/game_bloc/game_bloc.dart';
import '../bloc/game_bloc/game_event.dart';
import '../bloc/game_bloc/game_state.dart';
import '../models/game_model.dart';
import '../services/game_service.dart';
import '../utils/date_formatter_extension.dart';
import '../widgets/custom_dropdown_field.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/custom_text_field.dart';

/// [CreateGameScreen] allows a coach to create a new game.
class CreateGameScreen extends StatefulWidget {
  const CreateGameScreen({super.key});

  @override
  State<CreateGameScreen> createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends State<CreateGameScreen> {
  // GlobalKey for the form validation
  final _formKey = GlobalKey<FormState>();

  // Text controllers for each input field
  final TextEditingController _dateController = TextEditingController(); // for date picker
  final TextEditingController _timeController = TextEditingController(); // for time picker
  final TextEditingController _locationController = TextEditingController(); // for game location
  final TextEditingController _teamAController = TextEditingController(); // for first team name
  final TextEditingController _teamBController = TextEditingController(); // for second team name

  // ValueNotifiers for reactive dropdown selections
  final ValueNotifier<String?> _sportNotifier = ValueNotifier<String?>(null); // for sport selection
  final ValueNotifier<String?> _gradeNotifier = ValueNotifier<String?>(null); // for grade selection

  // Data lists for the dropdown menus
  final List<String> _sports = ['Camogie', 'Hurling', 'Football', 'Handball']; // sports list for Sport dropdown
  final List<String> _grades = ['U14', 'U16', 'Minor', 'Junior', 'Senior']; // grades list for Grade dropdown

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

  // Opens a date picker and updates the _dateController
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      _dateController.text = picked.toGameDate;
    }
  }

  // Opens a time picker and updates the _timeController
  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      _timeController.text = picked.format(context);
    }
  }

  // Validates the form and dispatches the SaveGameEvent
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

  // Clears all form fields and resets notifiers
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
