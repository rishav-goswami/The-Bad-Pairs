class Utils {
  static List getCombination(List arr, int n, int r) {
    // A temporary array to store
    // all combination one by one
    var data = List.filled(r, {});
    List answer = [];
    // Print all combination using
    // temporary array 'data[]'
    _combinationUtil(arr, n, r, 0, data, 0, answer);
    return answer;
  }

// To generate possible combinations of teams
  static void _combinationUtil(
      List arr, int n, int r, int index, List data, int i, List answer) {
    // Current combination is ready, print it
    if (index == r) {
      for (int j = 0; j < r; j++) {
        // cout << data[j] << " ";
        answer.add(data[j]);
      }
      // cout << endl;
      return;
    }

    // When no more elements are there to put in data[]
    if (i >= n) return;

    // current is included, put next at next location
    data[index] = arr[i];
    _combinationUtil(arr, n, r, index + 1, data, i + 1, answer);

    // current is excluded, replace it with next (Note that
    // i+1 is passed, but index is not changed)
    _combinationUtil(arr, n, r, index, data, i + 1, answer);
  }
}
