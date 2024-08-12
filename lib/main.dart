import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_treemap/treemap.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Product Sales Treemap',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TreeMap(),
    );
  }
}

class TreeMap extends StatefulWidget {
  const TreeMap({super.key});

  @override
  State<StatefulWidget> createState() => _TreeMapState();
}

class _TreeMapState extends State<TreeMap> {
  final Map<String, IconData> _productIcons = {
    'Electronics': Icons.cable,
    'Automobiles': Icons.airport_shuttle,
    'Pharmaceuticals': Icons.medical_services,
  };

  /// Builds the tooltip settings for the treemap.
  TreemapTooltipSettings _buildTreemapTooltipSettings() {
    return const TreemapTooltipSettings(
      color: Color.fromRGBO(45, 45, 45, 1),
    );
  }

  /// Builds the breadcrumbs of the treemap navigation.
  TreemapBreadcrumbs _buildTreemapBreadCrumbs() {
    return TreemapBreadcrumbs(
      builder: (BuildContext context, TreemapTile tile, bool isCurrent) {
        if (tile.group == 'Home') {
          return const Icon(Icons.home, color: Colors.black);
        } else {
          return Text(tile.group, style: const TextStyle(color: Colors.black));
        }
      },
      divider: const Icon(Icons.chevron_right, color: Colors.black),
      position: TreemapBreadcrumbPosition.top,
    );
  }

  /// Builds the treemap for the product level.
  TreemapLevel _buildProductTreemapLevel() {
    return TreemapLevel(
      groupMapper: (int index) => _source[index].productName,
      labelBuilder: (BuildContext context, TreemapTile tile) {
        return const SizedBox.shrink();
      },
      colorValueMapper: (TreemapTile tile) {
        return _colors[_source[tile.indices[0]].productName] ?? Colors.grey;
      },
      itemBuilder: (BuildContext context, TreemapTile tile) {
        return _buildItemBuilder(tile);
      },
    );
  }

  /// Builds the treemap for the country level.
  TreemapLevel _buildCountryTreemapLevel() {
    return TreemapLevel(
      groupMapper: (int index) => _source[index].countryName,
      colorValueMapper: (TreemapTile tile) {
        final productName = _source[tile.indices[0]].productName;
        return _colors[productName];
      },
      labelBuilder: (BuildContext context, TreemapTile tile) {
        return const SizedBox.shrink();
      },
      tooltipBuilder: (BuildContext context, TreemapTile tile) {
        final int index = tile.indices[0];
        final product = _source[index];
        return Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 7.0, 10.0, 8.5),
          child: SizedBox(
            height: 70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildRichText(context, 'Country : ', product.countryName),
                _buildRichText(context, 'Product : ', product.productName),
                _buildRichText(context, 'Amount : ',
                    '\$${product.salesAmount?.toStringAsFixed(2)}'),
              ],
            ),
          ),
        );
      },
      itemBuilder: (BuildContext context, TreemapTile tile) {
        return _buildItemBuilderLevel(tile);
      },
    );
  }

  /// Builds the treemap for the state level.

  TreemapLevel _buildStateTreemapLevel() {
    return TreemapLevel(
      groupMapper: (int index) => _source[index].state,
      colorValueMapper: (TreemapTile tile) {
        final productName = _source[tile.indices[0]].productName;
        return _colors[productName];
      },
      labelBuilder: (BuildContext context, TreemapTile tile) {
        return const SizedBox.shrink();
      },
      tooltipBuilder: (BuildContext context, TreemapTile tile) {
        final int index = tile.indices[0];
        final product = _source[index];
        return Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 7.0, 10.0, 8.5),
          child: SizedBox(
            height: 70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildRichText(
                    context, 'State     : ', product.state as String),
                _buildRichText(context, 'Product : ', product.productName),
                _buildRichText(context, 'Amount : ',
                    '\$${product.salesAmount?.toStringAsFixed(2)}'),
              ],
            ),
          ),
        );
      },
      itemBuilder: (BuildContext context, TreemapTile tile) {
        return _buildItemBuilderLevel(tile);
      },
    );
  }

  /// Builds the circular add icon which is used to expand the treemap while tapped
  /// and builds the background icon for the products.
  Widget _buildItemBuilder(TreemapTile tile) {
    final productName = _source[tile.indices[0]].productName;
    final icon = _productIcons[productName];

    return Stack(
      children: [
        Positioned.fill(
          child: Icon(
            icon,
            size: 220,
            color: const Color.fromARGB(255, 107, 106, 106).withOpacity(0.5),
          ),
        ),
        Center(
          child: Text(
            tile.group,
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (tile.hasDescendants)
          const Padding(
            padding: EdgeInsets.only(right: 4, bottom: 4),
            child: Align(
              alignment: Alignment.bottomRight,
              child:
                  Icon(Icons.add_circle_outline, size: 20, color: Colors.white),
            ),
          ),
      ],
    );
  }

  /// Builds the circular add icon which is used to expand the treemap while tapped.
  Widget _buildItemBuilderLevel(TreemapTile tile) {
    return Stack(
      children: [
        Center(
          child: Text(
            tile.group,
            style: const TextStyle(color: Colors.white),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (tile.hasDescendants)
          const Padding(
            padding: EdgeInsets.only(right: 4, bottom: 4),
            child: Align(
              alignment: Alignment.bottomRight,
              child:
                  Icon(Icons.add_circle_outline, size: 20, color: Colors.white),
            ),
          ),
      ],
    );
  }

  /// Builds the different text color for the tooltip label and value.
  Widget _buildRichText(BuildContext context, String label, String value) {
    return RichText(
      text: TextSpan(
        text: label,
        style: DefaultTextStyle.of(context).style.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
        children: <TextSpan>[
          TextSpan(
            text: ' $value',
            style: DefaultTextStyle.of(context).style.copyWith(
                fontWeight: FontWeight.normal,
                color: const Color.fromARGB(244, 255, 255, 255)),
          ),
        ],
      ),
    );
  }

  late List<ProductSales> _source;
  late Map<String, Color> _colors;

  @override
  void initState() {
    _source = <ProductSales>[
      // Electronics
      const ProductSales(
        countryName: 'United States',
        productName: 'Electronics',
        salesAmount: 500000,
      ),
      // China
      const ProductSales(
        countryName: 'China',
        productName: 'Electronics',
        state: 'Hebei',
        salesAmount: 60000,
      ),
      const ProductSales(
        countryName: 'China',
        productName: 'Electronics',
        state: 'Hunan',
        salesAmount: 60000,
      ),
      const ProductSales(
        countryName: 'China',
        productName: 'Electronics',
        state: 'Zhejiang',
        salesAmount: 50000,
      ),
      const ProductSales(
        countryName: 'China',
        productName: 'Electronics',
        state: 'Anhui',
        salesAmount: 40000,
      ),
      const ProductSales(
        countryName: 'China',
        productName: 'Electronics',
        state: 'Hubei',
        salesAmount: 30000,
      ),
      const ProductSales(
        countryName: 'China',
        productName: 'Electronics',
        state: 'Guangxi',
        salesAmount: 20000,
      ),
      const ProductSales(
        countryName: 'China',
        productName: 'Electronics',
        state: 'Yunnan',
        salesAmount: 30000,
      ),
      const ProductSales(
        countryName: 'China',
        productName: 'Electronics',
        state: 'Jiangxi',
        salesAmount: 10000,
      ),
      const ProductSales(
        countryName: 'China',
        productName: 'Electronics',
        state: 'Liaoning',
        salesAmount: 40000,
      ),
      const ProductSales(
        countryName: 'South Korea',
        productName: 'Electronics',
        salesAmount: 280000,
      ),
      // India
      const ProductSales(
        countryName: 'India',
        productName: 'Electronics',
        state: 'Uttar Pradesh',
        salesAmount: 450000,
      ),
      const ProductSales(
        countryName: 'India',
        productName: 'Electronics',
        state: 'Maharashtra',
        salesAmount: 412374,
      ),
      const ProductSales(
        countryName: 'India',
        productName: 'Electronics',
        state: 'Bihar',
        salesAmount: 404099,
      ),
      const ProductSales(
        countryName: 'India',
        productName: 'Electronics',
        state: 'West Bengal',
        salesAmount: 412760,
      ),
      const ProductSales(
        countryName: 'India',
        productName: 'Electronics',
        state: 'Madhya Pradesh',
        salesAmount: 32626,
      ),
      const ProductSales(
        countryName: 'India',
        productName: 'Electronics',
        state: 'Madhya Pradesh',
        salesAmount: 721470,
      ),
      const ProductSales(
        countryName: 'India',
        productName: 'Electronics',
        state: 'Tamil Nadu',
        salesAmount: 685480,
      ),
      const ProductSales(
        countryName: 'India',
        productName: 'Electronics',
        state: 'Rajasthan',
        salesAmount: 610950,
      ),
      const ProductSales(
        countryName: 'Brazil',
        productName: 'Electronics',
        salesAmount: 320000,
      ),
      const ProductSales(
        countryName: 'France',
        productName: 'Electronics',
        salesAmount: 400000,
      ),
      const ProductSales(
        countryName: 'Germany',
        productName: 'Electronics',
        salesAmount: 480000,
      ),
      // Japan
      const ProductSales(
        countryName: 'Japan',
        productName: 'Electronics',
        state: 'Tokyo',
        salesAmount: 100000,
      ),
      const ProductSales(
        countryName: 'Japan',
        productName: 'Electronics',
        state: 'Osaka',
        salesAmount: 95000,
      ),
      const ProductSales(
        countryName: 'Japan',
        productName: 'Electronics',
        state: 'Aichi',
        salesAmount: 90000,
      ),
      const ProductSales(
        countryName: 'Japan',
        productName: 'Electronics',
        state: 'Hokkaido',
        salesAmount: 85000,
      ),
      const ProductSales(
        countryName: 'Japan',
        productName: 'Electronics',
        state: 'Hyogo',
        salesAmount: 80000,
      ),
      const ProductSales(
        countryName: 'Japan',
        productName: 'Electronics',
        state: 'Fukuoka',
        salesAmount: 75000,
      ),
      const ProductSales(
        countryName: 'Japan',
        productName: 'Electronics',
        state: 'Shizuoka',
        salesAmount: 70000,
      ),
      const ProductSales(
        countryName: 'Japan',
        productName: 'Electronics',
        state: 'Chiba',
        salesAmount: 65000,
      ),
      const ProductSales(
        countryName: 'Japan',
        productName: 'Electronics',
        state: 'Saitama',
        salesAmount: 60000,
      ),
      const ProductSales(
        countryName: 'Japan',
        productName: 'Electronics',
        state: 'Hiroshima',
        salesAmount: 55000,
      ),
      const ProductSales(
        countryName: 'Japan',
        productName: 'Electronics',
        state: 'Kyoto',
        salesAmount: 50000,
      ),
      const ProductSales(
        countryName: 'Japan',
        productName: 'Electronics',
        state: 'Miyagi',
        salesAmount: 45000,
      ),
      const ProductSales(
        countryName: 'Japan',
        productName: 'Electronics',
        state: 'Nagano',
        salesAmount: 40000,
      ),
      const ProductSales(
        countryName: 'Japan',
        productName: 'Electronics',
        state: 'Gifu',
        salesAmount: 35000,
      ),
      const ProductSales(
        countryName: 'Japan',
        productName: 'Electronics',
        state: 'Tochigi',
        salesAmount: 30000,
      ),
      const ProductSales(
        countryName: 'Japan',
        productName: 'Electronics',
        state: 'Okayama',
        salesAmount: 25000,
      ),
      const ProductSales(
        countryName: 'Japan',
        productName: 'Electronics',
        state: 'Gunma',
        salesAmount: 20000,
      ),
      const ProductSales(
        countryName: 'Japan',
        productName: 'Electronics',
        state: 'Fukushima',
        salesAmount: 15000,
      ),
      const ProductSales(
        countryName: 'Japan',
        productName: 'Electronics',
        state: 'Kumamoto',
        salesAmount: 10000,
      ),
      const ProductSales(
        countryName: 'Japan',
        productName: 'Electronics',
        state: 'Kagoshima',
        salesAmount: 5000,
      ),
      const ProductSales(
        countryName: 'United Kingdom',
        productName: 'Electronics',
        salesAmount: 350000,
      ),
      const ProductSales(
        countryName: 'Canada',
        productName: 'Electronics',
        salesAmount: 330000,
      ),
      const ProductSales(
        countryName: 'Australia',
        productName: 'Electronics',
        salesAmount: 310000,
      ),
      const ProductSales(
        countryName: 'Russia',
        productName: 'Electronics',
        salesAmount: 290000,
      ),
      const ProductSales(
        countryName: 'Italy',
        productName: 'Electronics',
        salesAmount: 270000,
      ),
      const ProductSales(
        countryName: 'Mexico',
        productName: 'Electronics',
        salesAmount: 260000,
      ),
      const ProductSales(
        countryName: 'South Africa',
        productName: 'Electronics',
        salesAmount: 240000,
      ),
      const ProductSales(
        countryName: 'Saudi Arabia',
        productName: 'Electronics',
        salesAmount: 230000,
      ),
      const ProductSales(
        countryName: 'Turkey',
        productName: 'Electronics',
        salesAmount: 220000,
      ),
      const ProductSales(
        countryName: 'Spain',
        productName: 'Electronics',
        salesAmount: 210000,
      ),
      const ProductSales(
        countryName: 'Netherlands',
        productName: 'Electronics',
        salesAmount: 200000,
      ),
      const ProductSales(
        countryName: 'Sweden',
        productName: 'Electronics',
        salesAmount: 190000,
      ),
      const ProductSales(
        countryName: 'Argentina',
        productName: 'Electronics',
        salesAmount: 180000,
      ),
      const ProductSales(
        countryName: 'Chile',
        productName: 'Electronics',
        salesAmount: 170000,
      ),
      const ProductSales(
        countryName: 'Poland',
        productName: 'Electronics',
        salesAmount: 160000,
      ),
      const ProductSales(
        countryName: 'Norway',
        productName: 'Electronics',
        salesAmount: 150000,
      ),
      const ProductSales(
        countryName: 'Denmark',
        productName: 'Electronics',
        salesAmount: 140000,
      ),
      const ProductSales(
        countryName: 'Finland',
        productName: 'Electronics',
        salesAmount: 130000,
      ),
      const ProductSales(
        countryName: 'Ireland',
        productName: 'Electronics',
        salesAmount: 120000,
      ),
      const ProductSales(
        countryName: 'New Zealand',
        productName: 'Electronics',
        salesAmount: 110000,
      ),
      const ProductSales(
        countryName: 'Portugal',
        productName: 'Electronics',
        salesAmount: 105000,
      ),
      const ProductSales(
        countryName: 'Malaysia',
        productName: 'Electronics',
        salesAmount: 95000,
      ),
      const ProductSales(
        countryName: 'Singapore',
        productName: 'Electronics',
        salesAmount: 90000,
      ),
      const ProductSales(
        countryName: 'Thailand',
        productName: 'Electronics',
        salesAmount: 85000,
      ),
      const ProductSales(
        countryName: 'Philippines',
        productName: 'Electronics',
        salesAmount: 80000,
      ),
      const ProductSales(
        countryName: 'Vietnam',
        productName: 'Electronics',
        salesAmount: 75000,
      ),
      const ProductSales(
        countryName: 'Indonesia',
        productName: 'Electronics',
        salesAmount: 70000,
      ),
      const ProductSales(
        countryName: 'Pakistan',
        productName: 'Electronics',
        salesAmount: 65000,
      ),
      const ProductSales(
        countryName: 'Bangladesh',
        productName: 'Electronics',
        salesAmount: 60000,
      ),
      const ProductSales(
        countryName: 'Sri Lanka',
        productName: 'Electronics',
        salesAmount: 55000,
      ),
      const ProductSales(
        countryName: 'Nepal',
        productName: 'Electronics',
        salesAmount: 50000,
      ),
      // Automobiles
      const ProductSales(
        countryName: 'Germany',
        productName: 'Automobiles',
        salesAmount: 300000,
      ),
      const ProductSales(
        countryName: 'Japan',
        productName: 'Automobiles',
        salesAmount: 350000,
      ),
      const ProductSales(
        countryName: 'Australia',
        productName: 'Automobiles',
        salesAmount: 220000,
      ),
      const ProductSales(
        countryName: 'United States',
        productName: 'Automobiles',
        salesAmount: 310000,
      ),
      const ProductSales(
        countryName: 'South Korea',
        productName: 'Automobiles',
        salesAmount: 280000,
      ),
      const ProductSales(
        countryName: 'Italy',
        productName: 'Automobiles',
        salesAmount: 260000,
      ),
      const ProductSales(
        countryName: 'France',
        productName: 'Automobiles',
        salesAmount: 250000,
      ),
      const ProductSales(
        countryName: 'United Kingdom',
        productName: 'Automobiles',
        salesAmount: 240000,
      ),
      const ProductSales(
        countryName: 'China',
        productName: 'Automobiles',
        salesAmount: 320000,
      ),
      const ProductSales(
        countryName: 'Canada',
        productName: 'Automobiles',
        salesAmount: 270000,
      ),
      const ProductSales(
        countryName: 'Brazil',
        productName: 'Automobiles',
        salesAmount: 260000,
      ),
      const ProductSales(
        countryName: 'Spain',
        productName: 'Automobiles',
        salesAmount: 220000,
      ),
      const ProductSales(
        countryName: 'Mexico',
        productName: 'Automobiles',
        salesAmount: 210000,
      ),
      const ProductSales(
        countryName: 'Russia',
        productName: 'Automobiles',
        salesAmount: 230000,
      ),
      const ProductSales(
        countryName: 'India',
        productName: 'Automobiles',
        salesAmount: 200000,
      ),
      const ProductSales(
        countryName: 'South Africa',
        productName: 'Automobiles',
        salesAmount: 190000,
      ),
      const ProductSales(
        countryName: 'Saudi Arabia',
        productName: 'Automobiles',
        salesAmount: 180000,
      ),
      const ProductSales(
        countryName: 'Turkey',
        productName: 'Automobiles',
        salesAmount: 170000,
      ),
      const ProductSales(
        countryName: 'Norway',
        productName: 'Automobiles',
        salesAmount: 160000,
      ),
      const ProductSales(
        countryName: 'Sweden',
        productName: 'Automobiles',
        salesAmount: 150000,
      ),
      // Pharmaceuticals
      const ProductSales(
        countryName: 'United Kingdom',
        productName: 'Pharmaceuticals',
        salesAmount: 150000,
      ),
      const ProductSales(
        countryName: 'Switzerland',
        productName: 'Pharmaceuticals',
        salesAmount: 200000,
      ),
      const ProductSales(
        countryName: 'Canada',
        productName: 'Pharmaceuticals',
        salesAmount: 180000,
      ),
      const ProductSales(
        countryName: 'Brazil',
        productName: 'Pharmaceuticals',
        salesAmount: 170000,
      ),
      const ProductSales(
        countryName: 'Germany',
        productName: 'Pharmaceuticals',
        salesAmount: 220000,
      ),
      const ProductSales(
        countryName: 'United States',
        productName: 'Pharmaceuticals',
        salesAmount: 250000,
      ),
      const ProductSales(
        countryName: 'France',
        productName: 'Pharmaceuticals',
        salesAmount: 190000,
      ),
      const ProductSales(
        countryName: 'Japan',
        productName: 'Pharmaceuticals',
        salesAmount: 210000,
      ),
      const ProductSales(
        countryName: 'Italy',
        productName: 'Pharmaceuticals',
        salesAmount: 180000,
      ),
      const ProductSales(
        countryName: 'Australia',
        productName: 'Pharmaceuticals',
        salesAmount: 160000,
      ),
      const ProductSales(
        countryName: 'India',
        productName: 'Pharmaceuticals',
        salesAmount: 150000,
      ),
      const ProductSales(
        countryName: 'China',
        productName: 'Pharmaceuticals',
        salesAmount: 140000,
      ),
      const ProductSales(
        countryName: 'South Korea',
        productName: 'Pharmaceuticals',
        salesAmount: 130000,
      ),
      const ProductSales(
        countryName: 'Spain',
        productName: 'Pharmaceuticals',
        salesAmount: 120000,
      ),
      const ProductSales(
        countryName: 'Netherlands',
        productName: 'Pharmaceuticals',
        salesAmount: 110000,
      ),
    ];

    _colors = <String, Color>{
      'Electronics': Colors.pinkAccent,
      'Automobiles': Colors.deepPurpleAccent,
      'Pharmaceuticals': const Color.fromARGB(255, 70, 184, 157),
    };

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Regional Sales Analysis of Key Products'),
      ),
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          width: MediaQuery.of(context).size.width * 0.9,
          child: SfTreemap(
            dataCount: _source.length,
            enableDrilldown: true,
            weightValueMapper: (int index) => _source[index].salesAmount!,
            tooltipSettings: _buildTreemapTooltipSettings(),
            breadcrumbs: _buildTreemapBreadCrumbs(),
            levels: [
              _buildProductTreemapLevel(),
              _buildCountryTreemapLevel(),
              _buildStateTreemapLevel(),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductSales {
  const ProductSales({
    required this.countryName,
    required this.productName,
    this.state,
    this.salesAmount,
  });

  final String countryName;
  final String productName;
  final String? state;
  final double? salesAmount;
}
