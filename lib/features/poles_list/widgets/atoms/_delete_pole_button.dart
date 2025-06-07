part of '../pole_tile.dart';

class _DeletePoleButton extends StatefulWidget {
  const _DeletePoleButton({required this.pole, required this.bloc});

  final Pole pole;
  final PolesBloc bloc;

  @override
  State<_DeletePoleButton> createState() => _DeletePoleButtonState();
}

class _DeletePoleButtonState extends State<_DeletePoleButton> {
  bool _isDeleting = false;

  Future<void> _onDeletePressed() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            content: Text(
              'Вы уверены, что хотите удалить?\n"${widget.pole.number}"',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Отмена'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Удалить',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isDeleting = true);

    widget.bloc.add(DeletePole(deletePoleId: widget.pole.id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PolesBloc, PolesState>(
      bloc: widget.bloc,
      listener: (context, state) {
        if (state is DeletedPoleLoaded) {
          if (mounted) {
            Navigator.of(
              context,
              rootNavigator: true,
            ).pop(); // Закрыть прогресс
            Navigator.pop(
              context,
              true,
            ); // Вернуться назад и сообщить об удалении
          }
          setState(() => _isDeleting = false);
        } else if (state is DeletePoleFailure) {
          if (mounted) {
            Navigator.of(
              context,
              rootNavigator: true,
            ).pop(); // Закрыть прогресс
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ошибка при удалении')),
            );
          }
          setState(() => _isDeleting = false);
        }
      },
      child: Positioned(
        top: 0,
        right: 0,
        child: IconButton(
          icon: const Icon(
            Icons.delete,
            color: Colors.redAccent,
            shadows: [
              Shadow(
                offset: Offset(1, 2),
                color: Colors.black12,
                blurRadius: 4,
              ),
            ],
          ),
          onPressed: _isDeleting ? null : _onDeletePressed,
        ),
      ),
    );
  }
}
