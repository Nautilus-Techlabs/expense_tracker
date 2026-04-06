import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../logic/sms_parser.dart';
import '../data/sample_data.dart';
import '../logic/sms_service.dart';
import 'package:intl/intl.dart';

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({super.key});

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  final SmsService _smsService = SmsService();
  List<Transaction> _transactions = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // No longer parsing sample data here to avoid confusion
    
    // Auto-sync real messages on startup with a delay
    // This delay ensures the app is fully loaded and splash screen is gone
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        _syncTransactions();
      }
    });
  }

  Future<void> _syncTransactions() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final newTransactions = await _smsService.syncTransactions();
      
      setState(() {
        // Add new transactions and remove any duplicates by rawSms/date
        final existingSms = _transactions.map((t) => t.rawSms).toSet();
        for (var tx in newTransactions) {
          if (!existingSms.contains(tx.rawSms)) {
            _transactions.add(tx);
          }
        }
        
        // Sort by date descending
        _transactions.sort((a, b) => b.date.compareTo(a.date));
        _isLoading = false;
      });

      if (newTransactions.isNotEmpty && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Found ${newTransactions.length} new transactions')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sync Failed: $_errorMessage')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.sync),
              tooltip: 'Sync SMS',
              onPressed: _syncTransactions,
            ),
        ],
      ),
      body: Column(
        children: [
          _buildSummaryCard(),
          if (_errorMessage != null && _transactions.isEmpty)
            Expanded(child: Center(child: Text(_errorMessage!, textAlign: TextAlign.center)))
          else
            Expanded(
              child: RefreshIndicator(
                onRefresh: _syncTransactions,
                child: _transactions.isEmpty
                    ? const Center(child: Text('No transactions found.\nTap sync to check SMS.', textAlign: TextAlign.center))
                    : ListView.builder(
                        itemCount: _transactions.length,
                        itemBuilder: (context, index) {
                          return _TransactionCard(transaction: _transactions[index]);
                        },
                      ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    double totalDebit = 0;
    double totalCredit = 0;
    for (var tx in _transactions) {
      if (tx.type == TransactionType.debit) {
        totalDebit += tx.amount;
      } else {
        totalCredit += tx.amount;
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _SummaryItem(
            label: 'Total Spends',
            amount: totalDebit,
            color: Colors.red.shade700,
            icon: Icons.arrow_outward,
          ),
          _SummaryItem(
            label: 'Total Income',
            amount: totalCredit,
            color: Colors.green.shade700,
            icon: Icons.arrow_downward,
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final IconData icon;

  const _SummaryItem({
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '₹${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final Transaction transaction;

  const _TransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isDebit = transaction.type == TransactionType.debit;
    final color = isDebit ? Colors.red : Colors.green;
    final icon = _getIcon(transaction.method);
    final methodStr = transaction.method.name.toUpperCase();
    final typeStr = isDebit ? 'Debit' : 'Credit';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(
          transaction.merchant ?? '$methodStr $typeStr',
          style: const TextStyle(fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Text(
                DateFormat('dd MMM yyyy').format(transaction.date),
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '$methodStr • $typeStr',
                  style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${isDebit ? "-" : "+"} ₹${transaction.amount.toStringAsFixed(0)}',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            if (transaction.availableBalance != null)
              Text(
                'Bal: ₹${transaction.availableBalance!.toStringAsFixed(0)}',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailRow(label: 'Account', value: transaction.account ?? 'Unknown'),
                _DetailRow(label: 'Method', value: transaction.method.name.toUpperCase()),
                const SizedBox(height: 8),
                const Text('Raw Message:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  transaction.rawSms,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade700, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.upi: return Icons.qr_code;
      case PaymentMethod.card: return Icons.credit_card;
      case PaymentMethod.atm: return Icons.local_atm;
      case PaymentMethod.imps:
      case PaymentMethod.neft:
      case PaymentMethod.rtgs: return Icons.account_balance;
      default: return Icons.payment;
    }
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
