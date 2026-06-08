import 'package:flutter/material.dart';
import 'package:voluntariapp/features/detalhesEvento/detalhes_evento.dart';
import 'package:voluntariapp/features/notificacoes/pages/notificacoes.dart';
import 'package:voluntariapp/models/app_user.dart';
import 'package:voluntariapp/models/event.dart';
import 'package:voluntariapp/services/event_service.dart';
import 'package:voluntariapp/services/user_service.dart';
import 'package:voluntariapp/widgets/app_avatar.dart';
import 'package:voluntariapp/widgets/bottonMenu.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final searchController = TextEditingController();
  String searchTerm = '';
  String selectedCategory = 'Todas';
  bool onlyFutureEvents = true;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Event> _filterEvents(List<Event> events) {
    final term = searchTerm.trim().toLowerCase();
    return events.where((event) {
      final matchSearch = term.isEmpty ||
          event.title.toLowerCase().contains(term) ||
          event.organization.toLowerCase().contains(term) ||
          event.description.toLowerCase().contains(term) ||
          event.location.toLowerCase().contains(term) ||
          event.category.toLowerCase().contains(term);
      final matchCategory = selectedCategory == 'Todas' ||
          event.category.toLowerCase() == selectedCategory.toLowerCase();
      final matchDate = !onlyFutureEvents ||
          event.date.isAfter(DateTime.now().subtract(const Duration(days: 1)));
      return matchSearch && matchCategory && matchDate;
    }).toList();
  }

  void _openFilters(List<Event> events) {
    final categories = <String>{'Todas'};
    for (final event in events) {
      if (event.category.trim().isNotEmpty) categories.add(event.category.trim());
    }

    showModalBottomSheet(
      context: context,
      builder: (context) {
        var tempCategory = selectedCategory;
        var tempOnlyFuture = onlyFutureEvents;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filtros',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: categories.contains(tempCategory) ? tempCategory : 'Todas',
                    decoration: const InputDecoration(labelText: 'Categoria'),
                    items: categories
                        .map((category) => DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setModalState(() => tempCategory = value ?? 'Todas');
                    },
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: tempOnlyFuture,
                    title: const Text('Mostrar apenas eventos futuros'),
                    onChanged: (value) {
                      setModalState(() => tempOnlyFuture = value);
                    },
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFA500),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedCategory = tempCategory;
                          onlyFutureEvents = tempOnlyFuture;
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('Aplicar filtros'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _openCreateEventDialog(AppUser user) async {
    await showDialog(
      context: context,
      builder: (context) => _CreateEventDialog(user: user),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDE9FF),
      body: SafeArea(
        bottom: false,
        child: StreamBuilder<List<Event>>(
          stream: EventService().getEvents(),
          builder: (context, snapshot) {
            final events = snapshot.data ?? [];
            final filteredEvents = _filterEvents(events);

            return Column(
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  child: _HomeHeader(
                    controller: searchController,
                    onChanged: (value) => setState(() => searchTerm = value),
                    onFilterTap: () => _openFilters(events),
                  ),
                ),
                const SizedBox(height: 16),
                if (selectedCategory != 'Todas' || !onlyFutureEvents)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          if (selectedCategory != 'Todas')
                            Chip(label: Text('Categoria: $selectedCategory')),
                          if (!onlyFutureEvents)
                            const Chip(label: Text('Incluindo eventos antigos')),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                Expanded(
                  child: _EventList(
                    snapshot: snapshot,
                    events: filteredEvents,
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: StreamBuilder<AppUser?>(
        stream: UserService().currentUserStream(),
        builder: (context, snapshot) {
          final user = snapshot.data;
          if (user?.isOng != true) return const SizedBox.shrink();
          return FloatingActionButton.extended(
            backgroundColor: const Color(0xFFFFA500),
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add),
            label: const Text('Evento'),
            onPressed: () => _openCreateEventDialog(user!),
          );
        },
      ),
      bottomNavigationBar: const BottomMenu(),
    );
  }
}

class _EventList extends StatelessWidget {
  const _EventList({required this.snapshot, required this.events});

  final AsyncSnapshot<List<Event>> snapshot;
  final List<Event> events;

  @override
  Widget build(BuildContext context) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
      return Center(child: Text(snapshot.error.toString()));
    }

    if (events.isEmpty) {
      return const Center(child: Text('Nenhum evento encontrado'));
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(11, 0, 12, 88),
      itemCount: events.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) => EventCard(event: events[index]),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({
    required this.controller,
    required this.onChanged,
    required this.onFilterTap,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onFilterTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFF9F9F9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: 'Pesquisar',
                border: InputBorder.none,
                prefixIcon: IconButton(
                  icon: const Icon(Icons.filter_list, color: Color(0xFF49454F)),
                  onPressed: onFilterTap,
                ),
                suffixIcon: const Icon(Icons.search, color: Color(0xFF49454F)),
                contentPadding: const EdgeInsets.only(top: 9),
              ),
            ),
          ),
        ),
        const SizedBox(width: 11),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Notificacoes()),
            );
          },
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Color(0xFFFFA500),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.notifications_none_rounded, color: Colors.white, size: 22),
            ),
          ),
        ),
        const SizedBox(width: 6),
        const AppAvatar(size: 40),
      ],
    );
  }
}

class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 363,
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Color(0x1A000000), offset: Offset(0, 4), blurRadius: 4),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                const AppAvatar(size: 40, openProfile: false),
                const SizedBox(width: 13),
                Expanded(
                  child: Text(
                    event.organization,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF727272),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              event.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF111111),
                fontSize: 18,
                fontWeight: FontWeight.w700,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              event.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF111111),
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                height: 1.24,
                letterSpacing: 0.1,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 16, color: Colors.black54),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    event.location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black54),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _formatDate(event.date),
                  style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 114,
                  width: double.infinity,
                  color: const Color(0xFFD9D9D9),
                  child: event.imageUrl.trim().isNotEmpty
                      ? Image.network(
                          event.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.image_outlined, size: 82),
                        )
                      : const Icon(Icons.image_outlined, color: Color(0xFF1F1F24), size: 82),
                ),
              ),
            ),
            const Spacer(),
            Center(
              child: SizedBox(
                width: 95,
                height: 39,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color(0xFFFFA500),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetalhesEvento(event: event)),
                    );
                  },
                  child: const Text('Detalhes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

class _CreateEventDialog extends StatefulWidget {
  const _CreateEventDialog({required this.user});

  final AppUser user;

  @override
  State<_CreateEventDialog> createState() => _CreateEventDialogState();
}

class _CreateEventDialogState extends State<_CreateEventDialog> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  final categoryController = TextEditingController();
  final imageUrlController = TextEditingController();
  final slotsController = TextEditingController(text: '0');

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  bool saving = false;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    categoryController.dispose();
    imageUrlController.dispose();
    slotsController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => selectedTime = picked);
  }

  Future<void> _save() async {
    if (!formKey.currentState!.validate()) return;
    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe a data e o horário do evento.')),
      );
      return;
    }

    setState(() => saving = true);
    try {
      final date = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );
      await EventService().createEvent(
        title: titleController.text,
        organization: widget.user.displayName,
        description: descriptionController.text,
        location: locationController.text,
        date: date,
        category: categoryController.text,
        availableSlots: int.tryParse(slotsController.text.trim()) ?? 0,
        imageUrl: imageUrlController.text,
      );
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      Navigator.pop(context);
      messenger.showSnackBar(
        const SnackBar(content: Text('Evento cadastrado com sucesso.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao cadastrar evento: $e')),
      );
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cadastrar evento'),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _DialogField(controller: titleController, label: 'Título'),
              _DialogField(controller: descriptionController, label: 'Descrição', maxLines: 3),
              _DialogField(controller: locationController, label: 'Local'),
              _DialogField(controller: categoryController, label: 'Categoria'),
              _DialogField(controller: slotsController, label: 'Vagas (0 para ilimitado)', keyboardType: TextInputType.number),
              _DialogField(controller: imageUrlController, label: 'URL da imagem (opcional)', requiredField: false),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickDate,
                      icon: const Icon(Icons.calendar_month),
                      label: Text(selectedDate == null ? 'Data' : '${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.year}'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickTime,
                      icon: const Icon(Icons.schedule),
                      label: Text(selectedTime == null ? 'Hora' : selectedTime!.format(context)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: saving ? null : () => Navigator.pop(context), child: const Text('Cancelar')),
        ElevatedButton(
          onPressed: saving ? null : _save,
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFA500), foregroundColor: Colors.white),
          child: saving ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Salvar'),
        ),
      ],
    );
  }
}

class _DialogField extends StatelessWidget {
  const _DialogField({
    required this.controller,
    required this.label,
    this.maxLines = 1,
    this.requiredField = true,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final int maxLines;
  final bool requiredField;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        validator: (value) {
          if (requiredField && (value == null || value.trim().isEmpty)) {
            return 'Campo obrigatório';
          }
          return null;
        },
      ),
    );
  }
}
