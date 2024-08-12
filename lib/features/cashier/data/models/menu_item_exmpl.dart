class MenuItem {
  final String name;
  final String imageUrl;
  final String price;
  final String category;
  final String subCategory;

  MenuItem({
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.category,
    required this.subCategory,
  });
}

final List<MenuItem> dummyMenuItems = [
  // Aneka Nasi
  MenuItem(
    name: 'Nasi Goreng',
    imageUrl: 'https://images.pexels.com/photos/376464/pexels-photo-376464.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    price: 'Rp 25.000',
    category: 'makanan',
    subCategory: 'Aneka Nasi',
  ),
  MenuItem(
    name: 'Nasi Goreng Merah',
    imageUrl: 'https://images.pexels.com/photos/14272918/pexels-photo-14272918.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    price: 'Rp 30.000',
    category: 'makanan',
    subCategory: 'Aneka Nasi',
  ),
  MenuItem(
    name: 'Nasi Kuning Biasa',
    imageUrl: 'https://images.pexels.com/photos/376464/pexels-photo-376464.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    price: 'Rp 25.000',
    category: 'makanan',
    subCategory: 'Aneka Nasi',
  ),
  MenuItem(
    name: 'Nasi Kuning Spesial',
    imageUrl: 'https://images.pexels.com/photos/14272918/pexels-photo-14272918.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    price: 'Rp 25.000',
    category: 'makanan',
    subCategory: 'Aneka Nasi',
  ),
  MenuItem(
    name: 'Nasi Uduk',
    imageUrl: 'https://images.pexels.com/photos/376464/pexels-photo-376464.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    price: 'Rp 20.000',
    category: 'makanan',
    subCategory: 'Aneka Nasi',
  ),
  // Aneka Ayam
  MenuItem(
    name: 'Ayam Goreng',
    imageUrl: 'https://images.pexels.com/photos/14272918/pexels-photo-14272918.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    price: 'Rp 30.000',
    category: 'makanan',
    subCategory: 'Aneka Ayam',
  ),
  MenuItem(
    name: 'Ayam Bakar',
    imageUrl: 'https://images.pexels.com/photos/376464/pexels-photo-376464.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    price: 'Rp 35.000',
    category: 'makanan',
    subCategory: 'Aneka Ayam',
  ),
  MenuItem(
    name: 'Ayam Geprek',
    imageUrl: 'https://images.pexels.com/photos/14272918/pexels-photo-14272918.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    price: 'Rp 25.000',
    category: 'makanan',
    subCategory: 'Aneka Ayam',
  ),
  MenuItem(
    name: 'Ayam Penyet',
    imageUrl: 'https://images.pexels.com/photos/376464/pexels-photo-376464.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    price: 'Rp 25.000',
    category: 'makanan',
    subCategory: 'Aneka Ayam',
  ),
  MenuItem(
    name: 'Ayam Rica-rica',
    imageUrl: 'https://images.pexels.com/photos/14272918/pexels-photo-14272918.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    price: 'Rp 30.000',
    category: 'makanan',
    subCategory: 'Aneka Ayam',
  ),
  // Teh
  MenuItem(
    name: 'Teh Manis',
    imageUrl: 'https://images.pexels.com/photos/312418/pexels-photo-312418.jpeg?auto=compress&cs=tinysrgb&w=600',
    price: 'Rp 10.000',
    category: 'minuman',
    subCategory: 'Teh',
  ),
  MenuItem(
    name: 'Teh Tawar',
    imageUrl: 'https://images.pexels.com/photos/312418/pexels-photo-312418.jpeg?auto=compress&cs=tinysrgb&w=600',
    price: 'Rp 5.000',
    category: 'minuman',
    subCategory: 'Teh',
  ),
  MenuItem(
    name: 'Teh Hijau',
    imageUrl: 'https://images.pexels.com/photos/312418/pexels-photo-312418.jpeg?auto=compress&cs=tinysrgb&w=600',
    price: 'Rp 15.000',
    category: 'minuman',
    subCategory: 'Teh',
  ),
  MenuItem(
    name: 'Teh Tarik',
    imageUrl: 'https://images.pexels.com/photos/312418/pexels-photo-312418.jpeg?auto=compress&cs=tinysrgb&w=600',
    price: 'Rp 20.000',
    category: 'minuman',
    subCategory: 'Teh',
  ),
  MenuItem(
    name: 'Es Teh',
    imageUrl: 'https://images.pexels.com/photos/312418/pexels-photo-312418.jpeg?auto=compress&cs=tinysrgb&w=600',
    price: 'Rp 10.000',
    category: 'minuman',
    subCategory: 'Teh',
  ),
  // Kopi
  MenuItem(
    name: 'Kopi Hitam',
    imageUrl: 'https://images.pexels.com/photos/312418/pexels-photo-312418.jpeg?auto=compress&cs=tinysrgb&w=600',
    price: 'Rp 15.000',
    category: 'minuman',
    subCategory: 'Kopi',
  ),
  MenuItem(
    name: 'Kopi Susu',
    imageUrl: 'https://images.pexels.com/photos/312418/pexels-photo-312418.jpeg?auto=compress&cs=tinysrgb&w=600',
    price: 'Rp 20.000',
    category: 'minuman',
    subCategory: 'Kopi',
  ),
  MenuItem(
    name: 'Cappuccino',
    imageUrl: 'https://images.pexels.com/photos/312418/pexels-photo-312418.jpeg?auto=compress&cs=tinysrgb&w=600',
    price: 'Rp 25.000',
    category: 'minuman',
    subCategory: 'Kopi',
  ),
  MenuItem(
    name: 'Latte',
    imageUrl: 'https://images.pexels.com/photos/312418/pexels-photo-312418.jpeg?auto=compress&cs=tinysrgb&w=600',
    price: 'Rp 25.000',
    category: 'minuman',
    subCategory: 'Kopi',
  ),
  MenuItem(
    name: 'Espresso',
    imageUrl: 'https://images.pexels.com/photos/312418/pexels-photo-312418.jpeg?auto=compress&cs=tinysrgb&w=600',
    price: 'Rp 20.000',
    category: 'minuman',
    subCategory: 'Kopi',
  ),
];
