import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:is_dpelicula/api/ticket_methods.dart';
import 'package:is_dpelicula/models/ticket.dart';

// Define el provider para TicketApi
final ticketApiProvider = Provider<TicketApi>((ref) {
  return TicketApi();
});

final ticketControllerProvider = StateNotifierProvider<TicketController, AsyncValue<List<Ticket>>>((ref) {
  return TicketController(ref);
});

final getAllTicketsProvider = FutureProvider<List<Ticket>>((ref) async {
  final ticketController = ref.read(ticketControllerProvider.notifier);
  return ticketController.getAllTickets();
});

class TicketController extends StateNotifier<AsyncValue<List<Ticket>>> {
  TicketController(this.ref) : super(const AsyncValue.loading()) {
    fetchTickets();
  }

  final Ref ref;

  Future<void> fetchTickets() async {
    try {
      final ticketApi = ref.read(ticketApiProvider);
      final tickets = await ticketApi.getAllTickets();
      state = AsyncValue.data(tickets);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> addTicket(Ticket ticket) async {
    try {
      final ticketApi = ref.read(ticketApiProvider);
      await ticketApi.addTicket(ticket);
      fetchTickets();
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateTicket(Ticket ticket) async {
    try {
      final ticketApi = ref.read(ticketApiProvider);
      await ticketApi.updateTicket(ticket);
      fetchTickets();
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deleteTicket(String ticketId) async {
    try {
      final ticketApi = ref.read(ticketApiProvider);
      await ticketApi.deleteTicket(ticketId);
      fetchTickets();
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<List<Ticket>> getAllTickets() async {
    final ticketApi = ref.read(ticketApiProvider);
    return await ticketApi.getAllTickets();
  }
}
