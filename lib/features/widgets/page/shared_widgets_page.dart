import 'package:flutter/material.dart' hide Card;
import '../../../core/widgets/button/button.dart';
import '../../../core/widgets/card/card.dart';
import '../../../core/widgets/input/input.dart';

class SharedWidgetsPage extends StatelessWidget {
  const SharedWidgetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shared Widgets'), centerTitle: true),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.05,
        children: const [
          Card(
            title: 'Card',
            description: 'Thẻ dùng để hiển thị thông tin.',
            child: Text('Nội dung thẻ'),
          ),
          Card(
            title: 'Primary Button',
            description: 'Nút chính cho hành động quan trọng.',
            child: Button(text: 'Xác nhận'),
          ),
          Card(
            title: 'Text Field',
            description: 'Ô nhập liệu dùng chung.',
            child: Input(hintText: 'Nhập nội dung...'),
          ),
        ],
      ),
    );
  }
}
