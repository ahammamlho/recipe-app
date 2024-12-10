import 'package:flutter/material.dart';

class AddRecipe extends StatefulWidget {
  const AddRecipe({super.key});

  @override
  State<AddRecipe> createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  final List<String> ingredients = [""];
  final List<String> preparations = [""];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Recipe"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildUploadPictureSection(width),
              const SizedBox(height: 10),
              _buildTitleField(),
              const SizedBox(height: 10),
              _buildPreparationTime(),
              const SizedBox(height: 20),
              const Divider(color: Colors.black, thickness: 0.5),
              const SizedBox(height: 20),
              _buildSectionTitle("Add Ingredients"),
              _buildDynamicList(
                ingredients,
                "Ingredient",
                "ex: 1 Cup water",
                width,
                (index) => ingredients.removeAt(index),
                () => ingredients.add(""),
              ),
              const Divider(color: Colors.black, thickness: 0.5),
              const SizedBox(height: 20),
              _buildSectionTitle("Preparation"),
              _buildDynamicList(
                preparations,
                "Step",
                "ex: In a large bowl ...",
                width,
                (index) => preparations.removeAt(index),
                () => preparations.add(""),
              ),
              const SizedBox(height: 20),
              _buildActionButtons(width),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadPictureSection(double width) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      height: width * 0.4,
      width: width * 0.9,
      decoration: BoxDecoration(
        border: Border.all(width: 0.4),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.camera_alt_outlined, size: 30),
          SizedBox(height: 2),
          Text("Upload Recipe Picture", style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildTitleField() {
    return TextField(
      decoration: InputDecoration(
        labelText: "Title",
        hintText: "Choose Title of your recipe",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey, width: 1),
        ),
      ),
    );
  }

  Widget _buildPreparationTime() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Preparation Time',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 120,
          height: 40,
          child: TextField(
            keyboardType: TextInputType.number, // Ensures only numeric input
            decoration: InputDecoration(
              labelText: "Timer",
              hintText: "in minutes",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.grey, width: 1),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildDynamicList(
    List<String> items,
    String labelPrefix,
    String hintText,
    double width,
    Function(int index) onDelete,
    Function onAdd,
  ) {
    return Column(
      children: [
        Column(
          children: items.asMap().entries.map((entry) {
            int index = entry.key;
            String value = entry.value;

            return Container(
              margin: const EdgeInsets.only(top: 10),
              child: TextField(
                controller: TextEditingController(text: value),
                onChanged: (newValue) {
                  items[index] = newValue;
                },
                maxLines: labelPrefix == "Step" ? null : 1,
                decoration: InputDecoration(
                  labelText: "$labelPrefix ${index + 1}",
                  hintText: hintText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey, width: 1),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: items.length == 1 ? Colors.grey : Colors.red,
                    ),
                    onPressed: items.length == 1
                        ? null
                        : () {
                            setState(() {
                              onDelete(index);
                            });
                          },
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  onAdd();
                });
              },
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                height: 30,
                width: 80,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 5),
                    Text("Add"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionButton("Publish", Colors.green, width * 0.3),
        _buildActionButton("Save as draft", Colors.orange, width * 0.3),
      ],
    );
  }

  Widget _buildActionButton(String text, Color color, double width) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      height: 40,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
