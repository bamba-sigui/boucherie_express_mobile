import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/checkout.dart';
import '../../domain/entities/delivery_address.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/repositories/checkout_repository.dart';

/// Implémentation mock du repository checkout.
///
/// Simule un délai réseau et retourne des données de test.
@LazySingleton(as: CheckoutRepository)
class CheckoutRepositoryImpl implements CheckoutRepository {
  @override
  Future<Either<Failure, List<PaymentMethod>>> getPaymentMethods() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return Right(_mockPaymentMethods);
  }

  @override
  Future<Either<Failure, DeliveryAddress>> getDefaultAddress() async {
    await Future.delayed(const Duration(milliseconds: 200));

    return const Right(_mockAddress);
  }

  @override
  Future<Either<Failure, String>> placeOrder(Checkout checkout) async {
    // Simulate network call
    await Future.delayed(const Duration(seconds: 2));

    // Return mock order ID
    final orderId =
        'BE-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
    return Right(orderId);
  }

  // ── Mock data ──────────────────────────────────────────────────────────

  static const _mockAddress = DeliveryAddress(
    id: 'addr_1',
    title: 'Cocody, Angré 7e Tranche',
    detail: 'Immeuble Phoenix, Appt 4B',
    city: 'Abidjan',
  );

  static final _mockPaymentMethods = [
    const PaymentMethod(
      id: 'orange_money',
      name: 'Orange Money',
      description: 'Paiement instantané via Orange',
      type: PaymentMethodType.mobileMoney,
      logoUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuANXWmp2XJRxx5dhVeeyfABXfa7MyB0sVjwjhTmmI1Z5Qr7H455sVznhjGAF80b7vSva7BdXz-xUGd5EJ2o1FvhnFKqBuv0wIwrMoDSfvDCv27z-kYmEWNl9ClqzXiBOg6c1q2LyrjP5vg5itAGqpVYai7I3N619I2T6J7cpTdvUts0KgAhhJEkKfmIkyIPOLk8eTA87VvZeAqWcCyAQaWQaVoaPipz14Z887LDhP8E3DHIR2xR0eQJPCo7gTgGJzGdgKx5f3AvFg',
      logoBgColor: 0xFFFFFFFF,
    ),
    const PaymentMethod(
      id: 'mtn_momo',
      name: 'MTN MoMo',
      description: 'Payez avec votre compte MTN',
      type: PaymentMethodType.mobileMoney,
      logoUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDxEX5-zoa6P7nx6Q9Za_B3P1pIkq8Qy_nINHRoyMTr0B2ieol_RCgZOpRPQzvwuyw1w60vYop4-EMjRF98FMbLJNfrnxd0v7GN3dBs7K2eKuTPGK2FO9pI_9ABxm4t8cLpggqg7jWmdKHsaEQ8A6_Fi3U-HmnwXNtCYpfjv5JDeUuGceS6j4exvA6qbIUkSDasEhYA3RJ8FpwINqn7Su7tnLUqGVxFJgCoAf8MQ6GM0Vfb9O_Wmao8nkeIMdCZj9q4HHXAS85HoQ',
      logoBgColor: 0xFFFFCC00,
    ),
    const PaymentMethod(
      id: 'wave',
      name: 'Wave',
      description: "Application Wave Côte d'Ivoire",
      type: PaymentMethodType.mobileMoney,
      logoUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAxRpKG0gPyfNmyrH99QkTLepbLqdYlU_Izo_z48Inpy3hyypr58Liiib7Y_v9qDIqoNC2JC9pXSpy_s6FquVAwkCLaBar796uy7leGse0buRfrKJSvp9s6IXfGSIhB16GwsJg7Nfwxoo67i_VAwlrYHe1X3LZD5NbeIEi8YZIhv0TIAO-fgRxLE6ATPNVnFgYqXqC4MO-qPKh4NAaJfTxt-oF_Oa7VCwp7VVmIh7ffWDU4v90z3zSWXTbIyet-fUIIg66iggBgWw',
      logoBgColor: 0xFF1DA1F2,
    ),
    const PaymentMethod(
      id: 'cash',
      name: 'Paiement à la livraison',
      description: 'Régler en espèces à la réception',
      type: PaymentMethodType.cash,
      // No logo URL — will use a Material icon
    ),
  ];
}
