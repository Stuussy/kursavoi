import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Help and Support screen (Көмек экраны)
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Көмек және қолдау'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contact section
            _buildSection(
              context,
              title: 'Бізбен байланысу',
              children: [
                _ContactCard(
                  icon: Icons.email_outlined,
                  title: 'Email',
                  subtitle: 'support@munchly.kz',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Email көшірілді')),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _ContactCard(
                  icon: Icons.phone_outlined,
                  title: 'Телефон',
                  subtitle: '+7 (777) 123-45-67',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Телефон көшірілді')),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _ContactCard(
                  icon: Icons.schedule_outlined,
                  title: 'Жұмыс уақыты',
                  subtitle: 'Дүйсенбі - Жұма: 09:00 - 18:00',
                  onTap: null,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // FAQ section
            _buildSection(
              context,
              title: 'Жиі қойылатын сұрақтар',
              children: [
                _FAQItem(
                  question: 'Қалай брондау жасаймын?',
                  answer:
                      'Ресторанды таңдап, "Үстел брондау" батырмасын басыңыз. '
                      'Күн мен уақытты таңдап, брондауды растаңыз.',
                ),
                _FAQItem(
                  question: 'Брондауды қалай бас тартамын?',
                  answer:
                      '"Брондар" бөліміне өтіп, брондауды таңдаңыз. '
                      '"Бас тарту" батырмасын басыңыз.',
                ),
                _FAQItem(
                  question: 'Таңдаулыға қалай қосамын?',
                  answer:
                      'Ресторан картасындағы жүрек белгішесін басыңыз. '
                      'Ресторан таңдаулыға қосылады.',
                ),
                _FAQItem(
                  question: 'Профильді қалай өзгертемін?',
                  answer:
                      '"Профиль" бөліміне өтіп, "Профильді өңдеу" батырмасын басыңыз. '
                      'Атыңыз бен телефон нөміріңізді өзгерте аласыз.',
                ),
                _FAQItem(
                  question: 'Құпия сөзді қалай өзгертемін?',
                  answer:
                      'Қазіргі уақытта құпия сөзді тек қолдау қызметі арқылы '
                      'өзгерте аласыз. Бізбен байланысыңыз.',
                ),
              ],
            ),
            const SizedBox(height: 24),

            // About section
            _buildSection(
              context,
              title: 'Қосымша туралы',
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.textSecondaryColor.withOpacity(0.1),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: AppTheme.primaryGradient,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.restaurant_menu,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Munchly',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Нұсқа 1.0.0',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppTheme.textSecondaryColor,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Munchly - сүйікті рестораныларыңызды оңай табыңыз және '
                        'үстелді бірнеше қадаммен брондаңыз. '
                        'Біз сіздің демалысыңызды жеңілдетеміз!',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textSecondaryColor,
                              height: 1.5,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _ContactCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.textSecondaryColor.withOpacity(0.1),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppTheme.primaryColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.copy,
                size: 18,
                color: AppTheme.textSecondaryColor,
              ),
          ],
        ),
      ),
    );
  }
}

class _FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const _FAQItem({required this.question, required this.answer});

  @override
  State<_FAQItem> createState() => _FAQItemState();
}

class _FAQItemState extends State<_FAQItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isExpanded
              ? AppTheme.primaryColor.withOpacity(0.3)
              : AppTheme.textSecondaryColor.withOpacity(0.1),
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.question,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppTheme.primaryColor,
                  ),
                ],
              ),
              if (_isExpanded) ...[
                const SizedBox(height: 12),
                Text(
                  widget.answer,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondaryColor,
                        height: 1.5,
                      ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
