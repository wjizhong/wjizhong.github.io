# Hiho第301周:缺失的拼图

## 题目描述

小Hi在玩一个拼图游戏。如下图所示,整个拼图是由N块小矩形组成的大矩形。现在小Hi发现其中一块小矩形不见了。给定大矩形以及N-1个小矩形的顶点坐标,你能找出缺失的那块小矩形的顶点坐标吗?

![](http://media.hihocoder.com//problem_images/20170813/15025653913001.png)

**输入**

第一行包含一个整数,N。  

第二行包含四个整数,(X0, Y0), (X'0, Y'0),代表大矩形左下角和右上角的坐标。  

以下N-1行每行包含四个整数,(Xi, Yi), (X'i, Y'i),代表其中一个小矩形的左下角和右上角坐标。

对于30%的数据,1 <= N <= 1000  

对于100%的数据,1 <= N <= 100000 所有的坐标(X, Y)满足 0 <= X, Y <= 100000000

**输出**

输出四个整数(X, Y), (X', Y')代表缺失的那块小矩形的左下角和右上角的坐标。

样例输入

```
5  
0 0 4 5  
0 0 3 1  
0 1 2 5  
3 0 4 5  
2 2 3 5
```

样例输出

```
2 1 3 2
```


## 解题代码

```c++
#include <iostream>
#include <cstring>
#include <algorithm>
#include <vector>
using namespace std;
typedef long long LL;
int n, m;
int aa, bb, cc, dd;
vector<LL> v, res;
int main() {
    scanf("%d%d%d%d%d", &n, &aa, &bb, &cc, &dd);
    m = dd + 1;
    v.push_back((LL)aa * m + bb);
    v.push_back((LL)aa * m + dd);
    v.push_back((LL)cc * m + bb);
    v.push_back((LL)cc * m + dd);
    for (int i = 1; i < n; ++i) {
        int a, b, c, d;
        scanf("%d%d%d%d", &a, &b, &c, &d);
        v.push_back((LL)a * m + b);
        v.push_back((LL)a * m + d);
        v.push_back((LL)c * m + b);
        v.push_back((LL)c * m + d);
    }
    sort(v.begin(), v.end());
    // for (auto t: v) printf("%d\n", t);
    int i = 0;
    while (i < v.size()) {
        int cnt = 0;
        int j = i + 1;
        if (v[j] != v[i]) res.push_back(v[i]);
        else j++;
        if (res.size() == 4) break;
        i = j;
    }
    // for (auto t: res) printf("res:%lld\n", t);
    printf("%lld %lld %lld %lld", res[0] / m, res[0] % m, res[3] / m, res[3] % m);
    return 0;
}
```