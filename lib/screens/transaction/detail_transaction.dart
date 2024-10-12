import 'package:afrik_flow/services/transaction_service.dart';
import 'package:afrik_flow/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:afrik_flow/models/transaction.dart';

class TransactionDetailsScreen extends ConsumerStatefulWidget {
  final Transaction transaction;

  const TransactionDetailsScreen({super.key, required this.transaction});

  @override
  TransactionDetailsScreenState createState() =>
      TransactionDetailsScreenState();
}

class TransactionDetailsScreenState
    extends ConsumerState<TransactionDetailsScreen> {
  late Transaction _transaction;
  bool _isLoading = true;
  late TransactionService _transactionService;

  Future<void> _resubmit() async {
    setState(() {
      _isLoading = true;
    });
    final res = await _transactionService.resubmit(widget.transaction.token);
    setState(() {
      _isLoading = false;
    });
    if (res['success']) {
      showSucessToast(context, res['data']);
    } else {
      showToast(context, res['message']);
    }
  }

  @override
  void initState() {
    super.initState();
    _transaction = widget.transaction;
    _transactionService = TransactionService(ref: ref);

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de la transaction'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTransactionHeader(),
                    const SizedBox(height: 20),
                    _buildTransactionDetails(),
                    // const SizedBox(height: 20),
                    // _buildReceiverDetails(),
                    const SizedBox(height: 20),
                    if (_shouldShowRetryButton()) _buildRetryButton(context),
                    const SizedBox(height: 20),
                    _buildDownloadButton(context),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTransactionHeader() {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transaction #${_transaction.id}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.grey.shade600),
                const SizedBox(width: 5),
                Text(_transaction.humarizeDate),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.payment, color: Colors.grey.shade600),
                const SizedBox(width: 5),
                Text(
                    'Par ${_transaction.mode == 'local' ? 'transfert local' : 'carte de crédit'}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      radius: 20,
                      backgroundImage: const NetworkImage(
                        "https://media.licdn.com/dms/image/D4E12AQE8uOMdl4km9w/article-cover_image-shrink_600_2000/0/1678624190074?e=2147483647&v=beta&t=YEhO6rD75nuvHIg9za08JHadmzcjOyl-xBdtim_UnU4",
                      ),
                    ),
                    Positioned(
                      left: 22,
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        radius: 20,
                        backgroundImage: const NetworkImage(
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcReoan3T0XNqnM9MJzptamAyMNNv70le5prnw&s",
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 18),
                Text(
                    "De ${_transaction.payinWProvider.name} vers ${_transaction.payoutWProvider.name}"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionDetails() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Montant recu:', '${_transaction.amount} FCFA'),
            const SizedBox(height: 8),
            _buildDetailRow(
                'Montant transfere:', '${_transaction.amountWithoutFees} FCFA'),
            const SizedBox(height: 8),
            _buildStatusRow('Statut Payin:', _transaction.payinStatus),
            const SizedBox(height: 8),
            _buildStatusRow('Statut Payout:', _transaction.payoutStatus),
            const SizedBox(height: 8),
            _buildDetailRow('Téléphone Payin:', _transaction.payinPhoneNumber),
            const SizedBox(height: 8),
            if (_transaction.payoutPhoneNumber != null)
              _buildDetailRow(
                  'Téléphone Payout:', _transaction.payoutPhoneNumber!),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiverDetails() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Détails du récepteur',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildDetailRow('Nom:',
                '${_transaction.receiver.firstName ?? ''} ${_transaction.receiver.lastName ?? ''}'),
            const SizedBox(height: 8),
            if (_transaction.receiver.email != null)
              _buildDetailRow('Email:', _transaction.receiver.email!),
            const SizedBox(height: 8),
            if (_transaction.receiver.address != null)
              _buildDetailRow('Adresse:', _transaction.receiver.address!),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        Text(value, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildStatusRow(String label, String status) {
    Color statusColor;
    IconData icon;

    if (status.toLowerCase() == 'success') {
      status = 'Reussi';
      statusColor = Colors.green;
      icon = Icons.check_circle;
    } else if (status.toLowerCase() == 'pending') {
      statusColor = Colors.orange;
      icon = Icons.hourglass_bottom;
      status = 'En attente';
    } else {
      statusColor = Colors.red;
      icon = Icons.error;
      status = 'Échoué';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        Row(
          children: [
            Icon(icon, color: statusColor),
            const SizedBox(width: 5),
            Text(status, style: TextStyle(color: statusColor, fontSize: 16)),
          ],
        ),
      ],
    );
  }

  bool _shouldShowRetryButton() {
    return _transaction.payinStatus != 'success' ||
        _transaction.payoutStatus != 'success';
  }

  Widget _buildRetryButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: _resubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          'Relancer la transaction',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildDownloadButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text('Télécharger la facture'),
      ),
    );
  }
}
