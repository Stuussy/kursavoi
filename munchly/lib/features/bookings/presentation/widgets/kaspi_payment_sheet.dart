import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/theme/app_theme.dart';

/// Kaspi QR Payment Bottom Sheet
class KaspiPaymentSheet extends StatefulWidget {
  final String restaurantName;
  final int tableNumber;
  final String date;
  final String time;
  final int guests;
  final int amount;
  final VoidCallback onPaymentConfirmed;
  final VoidCallback onCancel;

  const KaspiPaymentSheet({
    super.key,
    required this.restaurantName,
    required this.tableNumber,
    required this.date,
    required this.time,
    required this.guests,
    required this.amount,
    required this.onPaymentConfirmed,
    required this.onCancel,
  });

  @override
  State<KaspiPaymentSheet> createState() => _KaspiPaymentSheetState();
}

class _KaspiPaymentSheetState extends State<KaspiPaymentSheet> {
  bool _isProcessing = false;
  bool _paymentSuccess = false;

  // Kaspi QR payment data (simulated)
  String get _kaspiQrData {
    return 'https://kaspi.kz/pay/munchly?amount=${widget.amount}&service=booking&restaurant=${Uri.encodeComponent(widget.restaurantName)}&table=${widget.tableNumber}';
  }

  void _simulatePayment() async {
    setState(() {
      _isProcessing = true;
    });

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isProcessing = false;
      _paymentSuccess = true;
    });

    // Wait a moment to show success, then callback
    await Future.delayed(const Duration(milliseconds: 1500));
    widget.onPaymentConfirmed();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.textSecondaryColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            if (_paymentSuccess)
              _buildSuccessContent()
            else if (_isProcessing)
              _buildProcessingContent()
            else
              _buildPaymentContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentContent() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Kaspi Logo
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF14635), // Kaspi red
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Kaspi QR',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Title
          Text(
            'Брондау төлемі',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'QR кодты Kaspi қолданбасымен сканерлеңіз',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // QR Code
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF14635), width: 3),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF14635).withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: QrImageView(
              data: _kaspiQrData,
              version: QrVersions.auto,
              size: 200,
              backgroundColor: Colors.white,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: Color(0xFFF14635),
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Amount
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFF14635).withOpacity(0.1),
                  const Color(0xFFFF6B35).withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Төлем сомасы:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${widget.amount} ₸',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF14635),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Booking details
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildDetailRow(Icons.restaurant, widget.restaurantName),
                const SizedBox(height: 8),
                _buildDetailRow(Icons.table_restaurant, 'Үстел №${widget.tableNumber}'),
                const SizedBox(height: 8),
                _buildDetailRow(Icons.calendar_today, widget.date),
                const SizedBox(height: 8),
                _buildDetailRow(Icons.access_time, widget.time),
                const SizedBox(height: 8),
                _buildDetailRow(Icons.people, '${widget.guests} қонақ'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onCancel,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Болдырмау'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _simulatePayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF14635),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Төледім',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Info text
          Text(
            'QR кодты сканерлеп, төлем жасағаннан кейін "Төледім" батырмасын басыңыз',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildProcessingContent() {
    return Padding(
      padding: const EdgeInsets.all(48),
      child: Column(
        children: [
          const SizedBox(
            width: 80,
            height: 80,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF14635)),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Төлем тексерілуде...',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Күте тұрыңыз',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessContent() {
    return Padding(
      padding: const EdgeInsets.all(48),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.successColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle,
              size: 80,
              color: AppTheme.successColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Төлем сәтті!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.successColor,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            '${widget.amount} ₸ төленді',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppTheme.textSecondaryColor),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
