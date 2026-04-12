import 'package:flutter/material.dart' hide Card;
import '../../../../core/widgets/card/card.dart';
import '../../../../core/widgets/input/input.dart';
import '../widgets/button_style_card.dart';

class SharedWidgetsPage extends StatelessWidget {
  const SharedWidgetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final crossAxisCount = width >= 980
        ? 3
        : width >= 680
            ? 2
            : 1;

    return Scaffold(
      appBar: AppBar(title: const Text('Shared Widgets'), centerTitle: true),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: width >= 680 ? 0.95 : 0.72,
        children: [
          Card(
            title: 'Card',
            description: 'Thẻ dùng để hiển thị thông tin.',
            child: const Text('Nội dung thẻ'),
          ),
          const ButtonStyleCard(),
          Card(
            title: 'Text Field',
            description: 'Ô nhập liệu dùng chung.',
            child: const Input(hintText: 'Nhập nội dung...'),
          ),
        ],
      ),
    );
  }
}
