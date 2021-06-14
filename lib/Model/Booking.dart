class Booking{
  final DateTime bookingTime;
  final String warehouse;
  final String license;
  final String carType;
  final BookingStatus status;

  const Booking({
    this.bookingTime,
    this.warehouse,
    this.license,
    this.carType,
    this.status,
  });

}
 
enum BookingStatus{
  ARRIVED,
  PENDING,
  EXPIRED
}