import 'package:flutter/material.dart';
import '../domain/entities/ticket.dart';

class TicketQuantitySelector extends StatefulWidget {
  final TicketEntity ticket;
  final Function(int quantity) onQuantityChanged;
  final int initialQuantity;

  const TicketQuantitySelector({
    Key? key,
    required this.ticket,
    required this.onQuantityChanged,
    this.initialQuantity = 1,
  }) : super(key: key);

  @override
  _TicketQuantitySelectorState createState() => _TicketQuantitySelectorState();
}

class _TicketQuantitySelectorState extends State<TicketQuantitySelector> {
  late int quantity;

  @override
  void initState() {
    super.initState();
    quantity = widget.initialQuantity;
  }

  void _incrementQuantity() {
    if (quantity < widget.ticket.onePer && quantity < widget.ticket.availableQuantity) {
      setState(() {
        quantity++;
      });
      widget.onQuantityChanged(quantity);
    }
  }

  void _decrementQuantity() {
    if (quantity > 0) {
      setState(() {
        quantity--;
      });
      widget.onQuantityChanged(quantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canIncrement = quantity < widget.ticket.onePer && 
                        quantity < widget.ticket.availableQuantity &&
                        widget.ticket.isAvailable;
    final canDecrement = quantity > 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[600]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ticket Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.ticket.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${widget.ticket.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              // Quantity Control
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Decrease Button
                    GestureDetector(
                      onTap: canDecrement ? _decrementQuantity : null,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: canDecrement ? Colors.orange : Colors.grey[600],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          ),
                        ),
                        child: Icon(
                          Icons.remove,
                          color: canDecrement ? Colors.white : Colors.grey[400],
                          size: 20,
                        ),
                      ),
                    ),
                    // Quantity Display
                    Container(
                      width: 50,
                      height: 36,
                      color: Colors.grey[700],
                      child: Center(
                        child: Text(
                          quantity.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // Increase Button
                    GestureDetector(
                      onTap: canIncrement ? _incrementQuantity : null,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: canIncrement ? Colors.orange : Colors.grey[600],
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        child: Icon(
                          Icons.add,
                          color: canIncrement ? Colors.white : Colors.grey[400],
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Ticket Details
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Available: ${widget.ticket.availableQuantity}',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'Max per person: ${widget.ticket.onePer}',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (quantity > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: Text(
                    'Subtotal: \$${(quantity * widget.ticket.price).toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          
          // Warning messages
          if (!widget.ticket.isAvailable)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.red),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning, color: Colors.red, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Sold Out',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ],
              ),
            ),
          
          if (quantity >= widget.ticket.onePer && widget.ticket.onePer > 0)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.blue),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info, color: Colors.blue, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Maximum ${widget.ticket.onePer} tickets per person',
                    style: const TextStyle(color: Colors.blue, fontSize: 12),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
