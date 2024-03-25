import 'package:flutter/material.dart';

class TextSearchScreen extends StatefulWidget {
  @override
  _TextSearchScreenState createState() => _TextSearchScreenState();
}

class _TextSearchScreenState extends State<TextSearchScreen> {
  final TextEditingController searchController = TextEditingController();
  List<List<String>> grid = [];
  List<List<bool>> highlighted = [];

  @override
  void initState() {
    super.initState();
    initializeGrid();
  }

  void initializeGrid() {
    grid = [
      ['A', 'B', 'C'],
      ['D', 'E', 'F'],
      ['G', 'H', 'I'],
    ];
    highlighted = List.generate(
      grid.length,
          (r) => List.generate(grid[r].length, (c) => false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('2D Grid'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            buildGrid(),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 10),
              child: TextFormField(

                autofocus: false,

                cursorColor: Colors.black,

                // textCapitalization: TextCapitalization.sentences,

                controller: searchController,
                style: TextStyle(

                  // fontFamily: 'Poppins',
                  fontSize: 14,
                  letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                  fontWeight: FontWeight.normal,
                  // height: 1
                ),

                decoration: InputDecoration(
                  // border: InputBorder.none,
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(17)
                  ),

                  labelStyle: TextStyle(
                    // color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                  filled: true,
                  fillColor: Colors.white,


                  labelText: 'Search an alphabet',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: searchText,
                  ),

                  floatingLabelBehavior: FloatingLabelBehavior.never,

                  contentPadding: const EdgeInsets.only(left: 15, bottom: 15),
                ),
              ),
            ),
            // TextField(
            //   controller: searchController,
            //   decoration: InputDecoration(
            //     labelText: 'Search for a word',
            //     suffixIcon: IconButton(
            //       icon: Icon(Icons.search),
            //       onPressed: searchText,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget buildGrid() {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.width/2,
          width: MediaQuery.of(context).size.width/2,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: grid.length, // Assuming square grid for simplicity
            ),
            itemBuilder: (context, index) {
              int row = (index / grid.length).floor();
              int col = index % grid.length;
              return GestureDetector(
                onTap: () => toggleHighlight(row, col),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    color: highlighted[row][col] ? Colors.yellow : Colors.white,
                  ),
                  child: Center(
                    child: Text(grid[row][col], style: TextStyle(fontSize: 22),),
                  ),
                ),
              );
            },
            itemCount: grid.length * grid.length,
          ),
        ),
        SizedBox(height: 15,),
        ElevatedButton(
          onPressed: resetApplication,
          child: Text('Reset Application'),
        ),
      ],
    );
  }

  void resetApplication() {
    grid.clear();
    highlighted.clear();
    searchController.clear();
    setState(() {
      initializeGrid();
    });
  }

  void searchText() {
    final searchText = searchController.text.toLowerCase();
    for (int row = 0; row < grid.length; row++) {
      for (int col = 0; col < grid[row].length; col++) {
        if (checkWord(row, col, searchText)) {
          highlightWord(row, col, searchText);
          return;
        }
      }
    }
  }

  bool checkWord(int row, int col, String searchText) {
    if (col + searchText.length <= grid[row].length) {
      String word = '';
      for (int i = 0; i < searchText.length; i++) {
        word += grid[row][col + i];
      }
      if (word.toLowerCase() == searchText) return true;
    }
    if (row + searchText.length <= grid.length) {
      String word = '';
      for (int i = 0; i < searchText.length; i++) {
        word += grid[row + i][col];
      }
      if (word.toLowerCase() == searchText) return true;
    }
    if (row + searchText.length <= grid.length &&
        col + searchText.length <= grid[row].length) {
      String word = '';
      for (int i = 0; i < searchText.length; i++) {
        word += grid[row + i][col + i];
      }
      if (word.toLowerCase() == searchText) return true;
    }
    return false;
  }

  void highlightWord(int row, int col, String searchText) {
    highlighted = List.generate(
      grid.length,
          (r) => List.generate(grid[r].length, (c) => false),
    );
    if (col + searchText.length <= grid[row].length) {
      for (int i = 0; i < searchText.length; i++) {
        highlighted[row][col + i] = true;
      }
    }
    else if (row + searchText.length <= grid.length) {
      for (int i = 0; i < searchText.length; i++) {
        highlighted[row + i][col] = true;
      }
    }
    else if (row + searchText.length <= grid.length &&
        col + searchText.length <= grid[row].length) {
      for (int i = 0; i < searchText.length; i++) {
        highlighted[row + i][col + i] = true;
      }
    }
    setState(() {});
  }

  void toggleHighlight(int row, int col) {
    setState(() {
      highlighted[row][col] = !highlighted[row][col];
    });
  }


}

