import 'dart:collection';

/// A tree of letters.
///
/// The [AlphabetTree] is a non binary tree which contains letters from A to Z.
///
/// The simplest tree is the empty tree:
/// ```dart
/// AlphabetTree.empty();
/// ```
///
/// The letter contained in the tree is immutable, however the tree itself is
/// can be changed by changing the child nodes.
///
/// All members that require a single letter represented by a [String] will throw
/// if the string has length different than 1 (one).
///
/// A node (or tree) can bn added multiple times to the same children or different branches.
class AlphabetTree {
  int? _letter;
  List<AlphabetTree> _children = List.empty(growable: true);

  /// Returns the letter stored in the root of this [AlphabetTree] or null if empty.
  String? get letter {
    var localLetter = _letter;
    return localLetter != null ? String.fromCharCode(localLetter) : null;
  }

  /// Returns the direct child nodes of the tree.
  List<AlphabetTree> get children => _children.toList(growable: false);

  /// Whether this tree is empty.
  bool get isEmpty => _letter == null;

  /// Whether this tree is not empty.
  bool get isNotEmpty => !isEmpty;

  /// Constructs an empty [AlphabetTree].
  AlphabetTree.empty();

  /// Constructs a [AlphabetTree} with one letter.
  ///
  /// Lower case letters are automatically converted to upper case.
  AlphabetTree.fromString(String letter) {
    letter = letter.toUpperCase();
    _ensureLetterArgument(letter);
    _letter = letter.codeUnitAt(0);
  }

  /// Adds [letter] to the end of the children of this tree.
  ///
  /// Lower case letters are automatically converted to upper case.
  ///
  /// Returns the node that was added.
  AlphabetTree addLetter(String letter) {
    letter = letter.toUpperCase();
    _ensureLetterArgument(letter);
    var newNode = AlphabetTree.fromString(letter);
    _children.add(newNode);
    return newNode;
  }

  /// Adds [tree] to the end of the children of this tree.
  void addTree(AlphabetTree tree) {
    if (tree == this)
      throw new ArgumentError.value(tree, 'tree', 'Must be not be the same tree as the one being added into');
    if (tree.isEmpty) throw new ArgumentError.value(tree, 'tree', 'Must be not be an empty tree');
    if (tree._containsTreeInstance(this))
      throw ArgumentError.value(tree, 'tree', 'Must not contain the tree that it is being added into');
    _children.add(tree);
  }

  /// Produces a [Set] with all unique letter in the tree.
  Set<String> toSet() {
    var set = Set<String>();
    _addToSet(set);
    return set;
  }

  /// Returns all the letters that are unique within the trees, in alphabetical order.
  String getOrderedUnique(AlphabetTree other) {
    return (unique(other).toList()..sort()).join();
  }

  /// Prints to the console all the letters that are unique within the trees, in alphabetical order.
  void printOrderedUnique(AlphabetTree other) {
    print(getOrderedUnique(other));
  }

  /// Produces a [Set] all unique letters within the trees.
  Set<String> unique(AlphabetTree tree) {
    var setThis = toSet();
    var setTree = tree.toSet();
    return setThis.difference(setTree)..addAll(setTree.difference(setThis));
  }

  /// Whether [other] tree contains at any level on this tree
  bool _containsTreeInstance(AlphabetTree other) {
    if (other == this) return false;
    var trees = Queue<AlphabetTree>.of(_children);
    while (trees.isNotEmpty) {
      var tree = trees.removeFirst();
      if (tree == other) return true;
      trees.addAll(tree._children);
    }
    return false;
  }

  void _addToSet(Set<String> set) {
    var localLetter = letter;
    if (localLetter != null) {
      set.add(localLetter);
      for (var node in _children) node._addToSet(set);
    }
  }

  // Helper method to ensure single letter arguments passed as String are valid
  _ensureLetterArgument(String letter) {
    if (letter.length != 1 || letter.compareTo('A') < 0 || letter.compareTo('Z') > 0)
      throw new ArgumentError.value(letter, 'letter', 'Must be contain a single letter from A to Z');
  }
}
