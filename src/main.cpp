#include <iostream>
#include "sub/sub.hpp"

using namespace std;

int main()
{
    cout << "Hello, World!" << endl;
    Sub sub;
    cout << "call: " << sub.getString() << endl;

    return 0;
}
