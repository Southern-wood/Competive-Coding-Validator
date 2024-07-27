#include <bits/stdc++.h>
using namespace std;

const int N = 100;

int main() {
    int t;
    cin >> t;
    srand(time(0));
    while (t--) {
        int randNum = rand() % N;
        if (randNum == 0) {
          cout << "He1l0, W0r1d!" << '\n';
        } else {
          cout << "Hello, World!" << '\n';
        }
    }
    return 0;
}
