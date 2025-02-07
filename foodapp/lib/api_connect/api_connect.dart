class API {
  // 192.168.110.56 trọ
  // 192.168.1.6 nhà
  // 172.16.49.130 trường
  static const hostConnect = "http://192.168.1.6/hoangyenfood";
  static const hostConnectUser = "$hostConnect/user";
  static const hostConnectAdmin = "$hostConnect/admin";
  static const hostConnectAdminCategory = "$hostConnectAdmin/categories";
  static const hostConnectAdminProduct = "$hostConnectAdmin/food";
  static const hostConnectAdminUser = "$hostConnectAdmin/user";
  //USER
  //signup user
  static const signUp = "$hostConnectUser/signup.php";
  //login user
  static const logIn = "$hostConnectUser/login.php";
  //update user
  static const updateUser = "$hostConnectUser/updateUser.php";
  //view user
  static const viewUser = "$hostConnectAdminUser/view_user.php";
  //delete user
  static const deleteUser = "$hostConnectAdminUser/delete_user.php";

  //CATEGORY
  //add categories
  static const addCategories = "$hostConnectAdminCategory/add_category.php";
  //view categories
  static const viewCategories = "$hostConnectAdminCategory/view_all.php";
  //view 4 categories
  static const view4Categories =
      "$hostConnectAdminCategory/view_4_categories.php";
  //delete categories
  static const deleteCategories =
      "$hostConnectAdminCategory/delete_category.php";
  //update categories
  static const updateCategories =
      "$hostConnectAdminCategory/update_category.php";

  //PRODUCT
  //add product
  static const addProduct = "$hostConnectAdminProduct/add_product.php";
  //view product
  static const viewProduct = "$hostConnectAdminProduct/view_all_product.php";
  //delete product
  static const deleteProduct = '$hostConnectAdminProduct/delete_product.php';
  //update product
  static const updateProduct = '$hostConnectAdminProduct/update_product.php';
  //view product with categary
  static const viewProductWithCategory =
      '$hostConnectAdminProduct/view_product_category.php';
}
