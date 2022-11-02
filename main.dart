List<E> quicksortNaive<E extends Comparable<dynamic>>(List<E> list) {
  // There must be more than one element in the list.
  if (list.length < 2) return list;
  // Pick the first element in the list as your pivot value.
  final pivot = list[0];
  // Using the pivot, split the original list into three
  // partitions.
  /// Calling where three times on the same list isn't
  /// time-efficient.
  /// Creating a new list for every partition isn't
  /// space-efficient.
  final less = list.where((value) => value.compareTo(pivot) < 0).toList();
  final greater = list.where((value) => value.compareTo(pivot) > 0).toList();
  final equal = list.where((value) => value.compareTo(pivot) == 0).toList();
  // Recursively sort the partitions and then combine them.
  return [
    ...quicksortNaive(less),
    ...equal,
    ...quicksortNaive(greater),
  ];
}

extension Swappable<E> on List<E> {
  void swap(int indexA, int indexB) {
    if (indexA == indexB) return;
    final temp = this[indexA];
    this[indexA] = this[indexB];
    this[indexB] = temp;
  }
}

/// This algorithm partitions the list into two regions.
/// Then recursively sort these regions.
/// Lumuto's algorithm performs the partitioning in place.
void quicksortLomuto<E extends Comparable<dynamic>>(
  List<E> list1,
  int low,
  int high,
) {
  // The recursion ends once a region has less than two elements.
  if (low >= high) return;
  final pivotIndex = _partitionLomuto(list1, low, high);
  quicksortLomuto(list1, low, pivotIndex - 1);
  quicksortLomuto(list1, pivotIndex + 1, high);
}

// low and high are the index values of the range that you want
// to partition within the list.This range will get smaller and
// smaller with every recursion.
int _partitionLomuto<E extends Comparable<dynamic>>(
    List<E> list2, int low, int high) {
  //Lomuto always chooses the last element as the pivot.
  final pivotValue = list2[high];
  // pivotIndex will keep track of where the pivot value needs
  // to go later.
  var pivotIndex = low;
  for (int i = low; i < high; i++) {
    if (list2[i].compareTo(pivotValue) <= 0) {
      list2.swap(i, pivotIndex);
      pivotIndex++;
    }
  }
  //  Once done with the loop, swap the value at pivotIndex
  // with pivot. The pivot always sits between the less and
  // greater partitions.
  // The list maintain it's state because it use extension on
  // List thus the algorithm performs the partitioning in place.
  list2.swap(pivotIndex, high);
  return pivotIndex;
}

void quicksortHoare<E extends Comparable<dynamic>>(
  List<E> list,
  int low,
  int high,
) {
  if (low >= high) return;
  final leftHigh = _hoareQuickSortAlgorithmPartitioning(list, low, high);
  quicksortHoare(list, low, leftHigh);
  quicksortHoare(list, leftHigh + 1, high);
}

int _hoareQuickSortAlgorithmPartitioning<E extends Comparable<dynamic>>(
    List<E> list, int low, int high) {
  // Select first element as pivot.
  final pivot = list[low];
  var left = low - 1;
  var right = high + 1;
  while (true) {
    // Keep increasing the left value until it comes to a value
    // greater than or equal to the pivot.
    do {
      left += 1;
    } while (list[left].compareTo(pivot) < 0);
    // Keep decreasing the right index until it comes to a value
    // greater than or equal to the pivot.
    do {
      right -= 1;
    } while (list[right].compareTo(pivot) > 0);
    // Swap the values at left and right if they haven't crossed
    // yet.Otherwise, return right as the new dividing index
    // between the two partitions. The right value will be the
    // high end of the left sublist on the next recursion.
    if (left < right) {
      list.swap(left, right);
    } else {
      return right;
    }
  }
}

void main() {
  final list = [8, 2, 2, 8, 9, 5, 9, 2, 8];
  quicksortDutchFlag(list, 0, list.length - 1);
  print(list);
}

// Finds te median of `list[low]`, `list[center]` and
// list[`high`] by sorting them. The median will end up at index
// center, which is what the function returns.
int _medianOfThree<T extends Comparable<dynamic>>(
    List<T> list, int low, int high) {
  final center = (high + low) ~/ 2;
  if (list[low].compareTo(list[center]) > 0) {
    list.swap(low, center);
  }
  if (list[low].compareTo(list[high]) > 0) {
    list.swap(low, high);
  }
  if (list[center].compareTo(list[high]) > 0) {
    list.swap(center, high);
  }
  return center;
}

void quickSortMedian<E extends Comparable<dynamic>>(
    List<E> list, int low, int high) {
  if (low <= high) return;
  final medianIndex = _medianOfThree(list, low, high);
  list.swap(medianIndex, high);
  final pivotIndex = _partitionLomuto(list, low, high);
  quicksortLomuto(list, low, pivotIndex - 1);
  quicksortLomuto(list, pivotIndex + 1, high);
}

/// Keeps track of ranges of pivot instead of single pivot
/// index.
///
/// Low and High are inclusive and to prevent confusion with
/// other API we didn't use start and end since they usually
/// uses end as an exclusive index.
class Range {
  final int low;
  final int high;

  Range(this.low, this.high);
}

Range _partitionDutchFlag<T extends Comparable<dynamic>>(
    List<T> list, int low, int high) {
  //. Choose the last value as the pivot. You could
  // also use the median-of-three strategy
  final pivot = list[high];
  //Initialize smaller and equal at the beginning of the list
  // and larger at the end of the list.
  var smaller = low;
  var equal = low;
  var larger = high;
  // Compare the value at equal with the pivot value. Swap it
  // into the correct partition if needed and advance the
  // appropriate pointers.
  while (equal <= larger) {
    if (list[equal].compareTo(pivot) < 0) {
      list.swap(smaller, equal);
      smaller += 1;
      equal += 1;
    } else if (list[equal] == pivot) {
      equal += 1;
    } else {
      list.swap(equal, larger);
      larger -= 1;
    }
  }
  // The algorithm returns indices smaller and larger. These
  // point to the first and last elements of the middle
  // partition.
  return Range(smaller, larger);
}

void quicksortDutchFlag<E extends Comparable<dynamic>>(
  List<E> list,
  int low,
  int high,
) {
  if (low >= high) return;
  final middle = _partitionDutchFlag(list, low, high);
  quicksortDutchFlag(list, low, middle.low - 1);
  quicksortDutchFlag(list, middle.high + 1, high);
}
