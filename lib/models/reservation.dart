import 'package:carsharing_app/models/car.dart';
import 'package:carsharing_app/models/user.dart';

class Reservation {
  final int id;
  final String dirOrigen;
  final String dirDestino;
  final double costo;
  final bool uso;
  final bool mastercard;
  final bool visa;
  final String fecha;
  final String hora;
  final Car auto;
  final Usuario user;

  Reservation(this.id, this.dirOrigen, this.dirDestino, this.costo, this.uso, this.mastercard, this.visa, this.fecha, this.hora,
      this.auto, this.user);
}