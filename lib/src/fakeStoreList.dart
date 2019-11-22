class Store {
  final int id;
  final String name;
  final String logo;
  final String address;
  final String description;
  final String hotline;
  final DateTime openTime;
  final DateTime closeTime;
  final double rating;

  Store({
    this.id,
    this.name,
    this.logo,
    this.address,
    this.description,
    this.hotline,
    this.openTime,
    this.closeTime,
    this.rating,
  });
}
class FakeStoreList{
  static final stores = [
    Store(
      id: 123,
      name: 'ABC',
      logo: 'https://www.abcrestaurants.com/images/1000x0/kerst-25-dec.jpg',
      address: 'Q9',
      description: 'cơm ngon vl',
      hotline: '19000000',
      openTime: DateTime.now(),
      closeTime: DateTime.now(),
      rating: 4.9,
    ),
    Store(
      id: 234,
      name: 'XYZ',
      logo: 'https://avatars2.githubusercontent.com/u/48937704?s=460&v=4',
      address: 'Q9',
      description: 'cơm ngon vl',
      hotline: '19000000',
      openTime: DateTime.now(),
      closeTime: DateTime.now(),
      rating: 4.9,
    ),
    Store(
      id: 345,
      name: 'UIT',
      logo: 'https://www.abcrestaurants.com/images/1000x0/kerst-25-dec.jpg',
      address: 'Q9',
      description: 'cơm ngon vl',
      hotline: '19000000',
      openTime: DateTime.now(),
      closeTime: DateTime.now(),
      rating: 4.9,
    ),
    Store(
      id: 456,
      name: 'HPX',
      logo: 'https://www.abcrestaurants.com/images/1000x0/kerst-25-dec.jpg',
      address: 'Q9',
      description: 'cơm ngon vl',
      hotline: '19000000',
      openTime: DateTime.now(),
      closeTime: DateTime.now(),
      rating: 4.9,
    ),
    Store(
      id: 567,
      name: 'AGK',
      logo: 'https://www.abcrestaurants.com/images/1000x0/kerst-25-dec.jpg',
      address: 'Q9',
      description: 'cơm ngon vl',
      hotline: '19000000',
      openTime: DateTime.now(),
      closeTime: DateTime.now(),
      rating: 4.9,
    ),
    Store(
      id: 678,
      name: 'UKH',
      logo: 'https://www.abcrestaurants.com/images/1000x0/kerst-25-dec.jpg',
      address: 'Q9',
      description: 'cơm ngon vl',
      hotline: '19000000',
      openTime: DateTime.now(),
      closeTime: DateTime.now(),
      rating: 4.9,
    ),
  ];
}

