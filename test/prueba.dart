void main() {
  List<int> originalList = [1, 2, 3, 4, 5];
  
  // Asignación por referencia, no se crea una copia independiente
  List<int> referenceList = originalList.toList();

  // Modificar la lista original
  originalList[0] = 99;

  // Imprimir ambas listas
  print("Original List: $originalList");
  print("Reference List: $referenceList");
}
