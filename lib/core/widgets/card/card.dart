import 'package:flutter/material.dart' as m;

class Card extends m.StatelessWidget {
  final String title;
  final String description;
  final m.Widget child;

  const Card({
    super.key,
    required this.title,
    required this.description,
    required this.child,
  });

  @override
  m.Widget build(m.BuildContext context) {
    return m.Card(
      child: m.Padding(
        padding: const m.EdgeInsets.all(16),
        child: m.Column(
          crossAxisAlignment: m.CrossAxisAlignment.start,
          children: [
            m.Expanded(
              child: m.Column(
                crossAxisAlignment: m.CrossAxisAlignment.start,
                children: [
                  m.Text(
                    title,
                    style: context.theme.textTheme.titleSmall?.copyWith(
                      fontWeight: m.FontWeight.bold,
                    ),
                  ),
                  const m.SizedBox(height: 4),
                  m.Text(description),
                  const m.SizedBox(height: 12),
                  m.Expanded(child: m.Center(child: child)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension _BuildContextX on m.BuildContext {
  m.ThemeData get theme => m.Theme.of(this);
}
