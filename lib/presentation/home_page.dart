import 'package:flutter/material.dart';import 'package:flutter_bloc/flutter_bloc.dart';import 'package:flutter_svg/svg.dart';import 'package:texnomartoriginal/presentation/product_details_page.dart';import 'package:texnomartoriginal/presentation/productspage.dart';import '../bloc/home/home_bloc.dart';import '../bloc/products/products_bloc.dart';import '../data/api/allcategories/category.dart';import '../data/api/products/product.dart';import 'components/category.dart';import 'components/product.dart';import 'components/search.dart';import 'components/slider.dart';class HomePage extends StatefulWidget {  const HomePage({Key? key}) : super(key: key);  @override  State<HomePage> createState() => _HomePageState();}class _HomePageState extends State<HomePage> {  final _bloc = HomeBloc();  List<CategoryHolder> categoryHolder = [];  List<String> sliderData = [];  List<ProductData> product = [];  int currentPageIndex = 0;  var myController = TextEditingController();  @override  void initState() {    _bloc.add(HomeInitialEvent());    _bloc.add(HomeCategoryEvent());    _bloc.add(HomeProductEvent());    super.initState();  }  @override  void dispose() {    _bloc.close();    super.dispose();  }  void _onItemTapped(int index) {    setState(() {      currentPageIndex = index;    });  }  @override  Widget build(BuildContext context) {    return BlocProvider.value(      value: _bloc,      child: BlocConsumer<HomeBloc, HomeState>(        listener: (context, state) {          if (state is GetAllCategoriesModel) {            state.model.data.categories?.forEach((element) {              categoryHolder.add(CategoryHolder(                  element.name ?? '', element.slug ?? '', element.smallImage ?? '',element.childs ?? []));            });          }          if (state is GetHomeSliderData) {            state.data.data?.data?.forEach((element) {              sliderData.add(element.imageMobileWeb ?? '');            });          }          if (state is GetTopProducts) {            state.modelproduct.data?.data?.forEach((element) {              product.add(ProductData(                  element.name ?? '',                  element.image ?? '',                  element.axiomMonthlyPrice ?? '',                  element.salePrice.toString() ?? '',              element.allCount?? 0, false, element.id ?? 0));            });          }        },        builder: (context, state) {          return Scaffold(            appBar: AppBar(              toolbarHeight: 120,              backgroundColor: const Color(0xFFFFC300),              shadowColor: Theme.of(context).colorScheme.shadow,              shape: const RoundedRectangleBorder(                borderRadius: BorderRadius.vertical(                  bottom: Radius.circular(10),                ),              ),              title: Column(                children: [                  Image.asset(                    "assets/images/img.png",                    width: 170,                    height: 30,                    fit: BoxFit.cover,                  ),                  const SizedBox(height: 16),                  InputSearch(context, myController),                ],              ),            ),              // bottomNavigationBar: BottomNavigationBar(              //   items: const [              //     BottomNavigationBarItem(icon: Icon(Icons.home_outlined),label: "Bosh sahifa"),              //     BottomNavigationBarItem(icon: Icon(Icons.manage_search_outlined), label: "Katalog"),              //     BottomNavigationBarItem(icon: Icon(Icons.shopping_basket_outlined,), label: "Savatcha"),              //     BottomNavigationBarItem(icon: Icon(Icons.card_travel_outlined), label: "Buyurtmalar"),              //     BottomNavigationBarItem(icon: Icon(Icons.perm_identity_outlined), label: "Profil"),              //   ],              //   selectedItemColor: Colors.black,              //   currentIndex: currentPageIndex,              //   unselectedItemColor: Colors.grey,              //   onTap: (int index){              //     _onItemTapped(index);              //     if(index == 1){              //       Navigator.pushNamed(context, 'catalog');              //     }              //   },              // ),              body: SingleChildScrollView(                child: Column(                  children: [                    const SizedBox(height: 10),                    SizedBox(                      height: 230,                        child: ImageSliderDemo(imgList: sliderData)),                     SizedBox(height: 40,                    child: Row(                      children: const [                        Padding(                          padding: EdgeInsets.only(left: 12.0),                          child: Text("Kategoriyalar", style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20 ),),                        ),                      ],                    ),                    ),                    SizedBox(                      height: 150,                      child: ListView.builder(                        scrollDirection: Axis.horizontal,                        itemCount: categoryHolder.length,                        itemBuilder: (context, index) {                          if (index == categoryHolder.length - 1) {                            return Padding(                              padding: const EdgeInsets.only(right: 16.0),                              child: InkWell(                                  onTap: (){                                    Navigator.push(context, MaterialPageRoute(builder: (context) =>BlocProvider(create: (context)=>                                    ProductsBloc(),                                    child: ProductsPage(category: categoryHolder[index].slug ?? '',),)));                                  },                                  child: categoryItem2(                                  categoryHolder[index].name ?? '',                                  categoryHolder[index].image ?? '')),                            );                          } else {                            return InkWell(                                onTap: (){                                  Navigator.push(context, MaterialPageRoute(builder: (context) =>BlocProvider(create: (context)=>                                      ProductsBloc(),                                    child: ProductsPage(category: categoryHolder[index].slug ?? '',),)));                                },                                child: categoryItem2(                                categoryHolder[index].name ?? '',                                categoryHolder[index].image ?? ''));                          }                        },                      ),                    ),                     const SizedBox(height: 30,                      child: Row(                        mainAxisAlignment: MainAxisAlignment.spaceBetween,                        children:  [                          Padding(                            padding: EdgeInsets.only(left: 12.0),                            child: Text("Yangi mahsulotlar", style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20 ),),                          ),                        ],                      ),                    ),                    GridView.builder(                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(                        crossAxisCount: 2,                        childAspectRatio: MediaQuery.of(context).size.width /                            (MediaQuery.of(context).size.height / 1.4),                      ),                      scrollDirection: Axis.vertical,                      shrinkWrap: true,                      physics: const NeverScrollableScrollPhysics(),                      itemCount: product.length,                      itemBuilder: (context, index) {                        return InkWell(                          onTap: () {                            Navigator.push(                                context,                                MaterialPageRoute(                                    builder: (context) => ProductDetailsPage(                                        item: product[index])));                          },                          child: productItem2(                              product[index].name ?? "",                              product[index].image ?? "",                              product[index].value ?? "",                              product[index].price ?? ""),                        );                      },                    ),                  ],                ),              ),          );        },      ),    );  }}