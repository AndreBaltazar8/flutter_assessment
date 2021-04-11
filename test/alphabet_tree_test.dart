import 'package:flutter_assessment/alphabet_tree/alphabet_tree.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('empty constructor constructs an empty tree', () {
    final tree = AlphabetTree.empty();
    expect(tree.isEmpty, isTrue);
    expect(tree.isNotEmpty, isFalse);
    expect(tree.letter, isNull);
  });

  test('single letter tree is not empty', () {
    final tree = AlphabetTree.fromString('A');
    expect(tree.isEmpty, isFalse);
    expect(tree.isNotEmpty, isTrue);
    expect(tree.letter, 'A');
  });

  test('tree only accepts letters A through Z', () {
    final charCodeUpperA = 'A'.codeUnitAt(0);
    for (var letter in Iterable.generate(26, (i) => String.fromCharCode(charCodeUpperA + i)))
      expect(() => AlphabetTree.fromString(letter), returnsNormally);
    final charCodeLowerA = 'a'.codeUnitAt(0);
    for (var letter in Iterable.generate(26, (i) => String.fromCharCode(charCodeLowerA + i)))
      expect(() => AlphabetTree.fromString(letter), returnsNormally);
    expect(() => AlphabetTree.fromString('5'), throwsArgumentError);
    expect(() => AlphabetTree.fromString('😒'), throwsArgumentError);
  });

  test('add new letters to tree', () {
    final tree = AlphabetTree.fromString('A')..addLetter('B')..addLetter('C')..addLetter('D');
    var children = tree.children;

    expect(tree.letter, 'A');
    expect(children.length, 3);
    expect(children[0].letter, 'B');
    expect(children[1].letter, 'C');
    expect(children[2].letter, 'D');
  });

  test('add one tree to another', () {
    final tree = AlphabetTree.fromString('A')
      ..addLetter('B')
      ..addLetter('C')
      ..addTree(AlphabetTree.fromString('D')..addLetter('E'));
    var children = tree.children;

    expect(tree.letter, 'A');
    expect(children.length, 3);
    expect(children[0].letter, 'B');
    expect(children[1].letter, 'C');
    expect(children[2].letter, 'D');

    var subChildren = children[2].children;
    expect(subChildren[0].letter, 'E');
  });

  test('cannot make circular graphs', () {
    final treeOne = AlphabetTree.fromString('A');
    final treeTwo = AlphabetTree.fromString('B')..addTree(treeOne);

    expect(() => treeOne.addTree(treeOne), throwsArgumentError);
    expect(() => treeOne.addTree(treeTwo), throwsArgumentError);
    expect(() => treeTwo.addTree(treeOne), returnsNormally);
  });

  test('set produced from tree contains all unique letters', () {
    final tree = AlphabetTree.fromString('A')
      ..addLetter('B')
      ..addLetter('A')
      ..addTree(AlphabetTree.fromString('F')..addLetter('E')..addLetter('a'));
    var set = tree.toSet();
    expect(set.length, 4);
    expect(set.containsAll(['A', 'B', 'E', 'F']), isTrue);
  });

  test('set produced from empty tree is empty', () {
    final tree = AlphabetTree.empty();
    var set = tree.toSet();
    expect(set.length, 0);
  });

  test('unique produces all unique elements between two trees', () {
    final treeOne = AlphabetTree.fromString('A')
      ..addLetter('B')
      ..addTree(AlphabetTree.fromString('C'));
    final treeTwo = AlphabetTree.fromString('C')..addLetter('B')..addLetter('D');
    var unique = treeOne.unique(treeTwo);
    expect(unique.length, 2);
    expect(unique.containsAll(['A', 'D']), isTrue);
  });

  test('unique method is commutative', () {
    final treeOne = AlphabetTree.fromString('A')
      ..addLetter('B')
      ..addTree(AlphabetTree.fromString('C'));
    final treeTwo = AlphabetTree.fromString('C')..addLetter('B')..addLetter('D');
    var uniqueOne = treeOne.unique(treeTwo);
    var uniqueTwo = treeTwo.unique(treeOne);
    expect(uniqueOne.length, 2);
    expect(uniqueOne.containsAll(['A', 'D']), isTrue);
    expect(uniqueTwo.length, 2);
    expect(uniqueTwo.containsAll(['D', 'A']), isTrue);
    expect(uniqueOne, uniqueTwo);
  });

  test('unique between empty trees is empty', () {
    final treeOne = AlphabetTree.empty();
    final treeTwo = AlphabetTree.empty();
    var unique = treeOne.unique(treeTwo);
    expect(unique.length, 0);
  });

  test('unique between empty tree and another, gives all unique elements of other', () {
    final treeOne = AlphabetTree.empty();
    final treeTwo = AlphabetTree.fromString('C')..addLetter('B')..addLetter('B');
    var unique = treeOne.unique(treeTwo);
    expect(unique.length, 2);
    expect(unique.containsAll(['C', 'B']), isTrue);
  });

  test('getOrderedUnique produces all unique elements between two trees', () {
    final treeOne = AlphabetTree.fromString('A')
      ..addLetter('B')
      ..addTree(AlphabetTree.fromString('C'));
    final treeTwo = AlphabetTree.fromString('C')..addLetter('B')..addLetter('D');
    var unique = treeOne.getOrderedUnique(treeTwo);
    expect(unique, 'AD');
  });

  test('getOrderedUnique produces empty string for empty trees', () {
    final treeOne = AlphabetTree.empty();
    final treeTwo = AlphabetTree.empty();
    var unique = treeOne.getOrderedUnique(treeTwo);
    expect(unique, '');
  });
}
