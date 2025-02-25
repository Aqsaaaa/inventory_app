import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inventory/gen/assets.gen.dart';
import '../../services/api_service.dart';
import '../../models/item.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});

  @override
  _ItemsScreenState createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  final ItemsRepository _itemsRepository = ItemsRepository();
  final ScrollController _scrollController = ScrollController();
  List<Item> _items = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';

  // Add pagination variables
  int _currentPage = 1;
  bool _hasMoreItems = true;
  static const int _itemsPerPage = 10;

  Future<void> _loadItems({bool refresh = false}) async {
    if (_isLoading || (!_hasMoreItems && !refresh)) return;

    setState(() {
      _isLoading = true;
      if (refresh) {
        _items = [];
        _currentPage = 1;
        _hasMoreItems = true;
        _hasError = false;
        _errorMessage = '';
      }
    });

    try {
      // Modify your API service to accept page and limit parameters
      var newItems = await _itemsRepository.getItems(
        page: _currentPage,
        limit: _itemsPerPage,
      );

      setState(() {
        if (refresh) {
          _items = newItems;
        } else {
          _items.addAll(newItems);
        }
        _hasMoreItems = newItems.length >= _itemsPerPage;
        _currentPage++;
        _hasError = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = "Failed to load items";
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_errorMessage)));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _loadItems();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 500) {
      _loadItems();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildItemCard(Item item) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  item.nama,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                height: constraints.maxHeight * 0.4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child:
                      item.image != null
                          ? Image.network(
                            "http://10.0.2.2:3000/api/uploads/${item.image}",
                            width: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: Colors.grey[300],
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value:
                                        loadingProgress.expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                ),
                              );
                            },
                          )
                          : Container(
                            color: Colors.grey[300],
                            child: Icon(
                              Icons.image,
                              size: 50,
                              color: Colors.grey[700],
                            ),
                          ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'Kategori',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            item.kategori,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'Jumlah',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            item.jumlah.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Deskripsi:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          item.deskripsi,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[800],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Items"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/form', arguments: 'add');
            },
            tooltip: 'User Input',
          ),
          IconButton(
            icon: SvgPicture.asset(
              Assets.icon.update.path,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                Theme.of(context).iconTheme.color!,
                BlendMode.srcIn,
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/form', arguments: 'update');
            },
            tooltip: 'Update', // Tambahkan tooltip
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _loadItems(refresh: true),
        child:
            _hasError && _items.isEmpty
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_errorMessage),
                      ElevatedButton(
                        onPressed: () => _loadItems(refresh: true),
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                )
                : GridView.builder(
                  controller: _scrollController,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  padding: EdgeInsets.all(8),
                  itemCount: _items.length + (_hasMoreItems ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= _items.length) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return _buildItemCard(_items[index]);
                  },
                ),
      ),
    );
  }
}
