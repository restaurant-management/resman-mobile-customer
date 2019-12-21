class DishItem {
  final int id;
  final String image;
  final String name;
  final int price;
        int quantity;

  DishItem({
    this.id,
    this.image,
    this.name,
    this.price,
    this.quantity
  });
}

class FakeBillItem{
  static final dishItems = [
    DishItem(
      id: 1,
      image: 'https://avatars1.githubusercontent.com/u/36977998?s=460&v=4',
      name: 'Gà châu âu',
      price: 20000000,
      quantity: 1,
    ),
    DishItem(
      id: 1,
      image: 'https://avatars1.githubusercontent.com/u/36977998?s=460&v=4',
      name: 'Gà châu âu',
      price: 20000000,
      quantity: 1,
    ),
    DishItem(
      id: 1,
      image: 'https://avatars1.githubusercontent.com/u/36977998?s=460&v=4',
      name: 'Gà châu âu',
      price: 20000000,
      quantity: 1,
    ),
    DishItem(
      id: 1,
      image: 'https://avatars1.githubusercontent.com/u/36977998?s=460&v=4',
      name: 'Gà châu âu',
      price: 20000000,
      quantity: 1,
    ),
    DishItem(
      id: 1,
      image: 'https://avatars1.githubusercontent.com/u/36977998?s=460&v=4',
      name: 'Gà châu âu',
      price: 20000000,
      quantity: 1,
    ),
  ];
}
