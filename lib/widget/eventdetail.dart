import 'package:event_management_app/screeen/payment_method_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:clay_containers/clay_containers.dart';

class EventDetail extends StatefulWidget {
  final Map<String, dynamic> event;

  const EventDetail({Key? key, required this.event}) : super(key: key);

  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  late int totalTickets;
  late int availableTickets;
  int selectedTickets = 1;
  double ticketPrice = 100;
  final TextEditingController _couponController = TextEditingController();
  String couponMessage = '';

  @override
  void initState() {
    super.initState();
    totalTickets = widget.event['totalTickets'] ?? 500;
    availableTickets = widget.event['availableTickets'] ?? 120;
  }

  void _incrementTickets() {
    if (selectedTickets < availableTickets) {
      setState(() {
        selectedTickets++;
      });
    }
  }

  void _decrementTickets() {
    if (selectedTickets > 1) {
      setState(() {
        selectedTickets--;
      });
    }
  }

  void _buyTicket() {
    if (availableTickets >= selectedTickets) {
      Navigator.push<int>(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentMethodScreen(
            event: widget.event,
            ticketsBought: selectedTickets,
          ),
        ),
      ).then((ticketsPurchased) {
        if (ticketsPurchased != null && ticketsPurchased > 0) {
          setState(() {
            availableTickets -= ticketsPurchased;
          });
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Not enough tickets available!'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _applyCoupon() {
    // Implement your coupon logic here.
    setState(() {
      // This is a simple example. You can modify it based on your discount logic.
      if (_couponController.text.trim().toUpperCase() == 'DISCOUNT10') {
        couponMessage = 'Coupon applied: 10% off!';
      } else {
        couponMessage = 'Invalid coupon code.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.event['title'] ?? 'No Title Available';
    String date = widget.event['date'] ?? 'No Date Available';
    String time = widget.event['time'] ?? 'No Time Available';
    //String location = widget.event['location'] ?? 'Location Not Provided';
    String image = widget.event['image'] ?? 'https://via.placeholder.com/400';

    double ticketPrice = widget.event['totalPrice'] != null &&
        widget.event['totalPrice'] is double
        ? widget.event['totalPrice']
        : 100;

    double totalPrice = ticketPrice * selectedTickets;

    return Scaffold(
      backgroundColor: Colors.red,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero animation for the event image with gradient overlay
            Stack(
              children: [
                Hero(
                  tag: title,
                  child: Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
                // Back Button
                Positioned(
                  top: 40,
                  left: 20,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 28),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                // Title with icon representing plan type
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Row(
                    children: [
                      // Sample icon; replace with an icon matching the plan type if needed.
                      const Icon(Icons.event, color: Colors.white, size: 28),
                      const SizedBox(width: 8),
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 18, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        '$date | $time',
                        style: GoogleFonts.poppins(
                            fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Location Container (showing location clearly)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 20, color: Colors.white),
                        const SizedBox(width: 8),

                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.event['description'] ??
                        'No description provided.',
                    style: GoogleFonts.poppins(
                        fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  // Coupon Container
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Have a coupon?",
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _couponController,
                                style: GoogleFonts.poppins(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: "Enter coupon code",
                                  hintStyle:
                                  GoogleFonts.poppins(color: Colors.white70),
                                  filled: true,
                                  fillColor: Colors.black38,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: _applyCoupon,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                "Apply",
                                style: GoogleFonts.poppins(
                                    color: Colors.black, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        if (couponMessage.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              couponMessage,
                              style: GoogleFonts.poppins(
                                  color: Colors.white, fontSize: 14),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Event Ticket Details Card
                  ClayContainer(
                    depth: 20,
                    borderRadius: 12,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Total Tickets:",
                                  style: GoogleFonts.poppins(
                                      fontSize: 16, color: Colors.black)),
                              Text("$totalTickets",
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Available Tickets:",
                                  style: GoogleFonts.poppins(
                                      fontSize: 16, color: Colors.black)),
                              Text("$availableTickets",
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Total Price:",
                                  style: GoogleFonts.poppins(
                                      fontSize: 16, color: Colors.black)),
                              Text("৳ ${totalPrice.toStringAsFixed(2)}",
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text("Select Tickets:",
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: _decrementTickets,
                                  icon: const Icon(
                                      Icons.remove_circle_outline,
                                      size: 32,
                                      color: Colors.white),
                                ),
                                Text(
                                  '$selectedTickets',
                                  style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  onPressed: _incrementTickets,
                                  icon: const Icon(
                                      Icons.add_circle_outline,
                                      size: 32,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Tappable Book Ticket button with updated white style
                  Center(
                    child: InkWell(
                      onTap: _buyTicket,
                      borderRadius: BorderRadius.circular(12),
                      child: Hero(
                        tag: "bookTicketButton$title",
                        child: ClayContainer(
                          depth: 10,
                          borderRadius: 12,
                          color: const Color(0xFF100720),
                          child: Container(
                            width: 165,
                            height: 62,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white70,
                            ),
                            child: Text(
                              "Book Ticket",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
