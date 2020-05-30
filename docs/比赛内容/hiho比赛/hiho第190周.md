# hiho第190周:震荡数组
## 题目描述

给定一个长度为N的数组$A_1,A_2,...,A_N$,如果对于任意$1<i<N$都有$A_i>A_{i-1}$且$A_i>A_{i+1}$,或者$A_i<A_{i-1}$且$A_i<A_{i+1}$,我们就称A数组是一个震荡数组。

例如{4,2,3,1,5}就是一个震荡数组;而{1,4,3,2,5}不是一个震荡数组因为4,3,2三个连续的元素不满足条件。

现在给定一个长度为N的数组组$A_1,A_2,...,A_N$,最少进行多少次两两交换,可以使A变成一个震荡数组?

### 输入输出
* 输入

第一行包含一个整数N,代表数组的长度。($1<= N<30$)

第二行包含N个整数,A$_1, A_2, ... A_N$。($1<=A_i <= N$)

输入保证$A_i$两两不同。

* 输出

输出最少交换的次数。

样例输入

```
5
1 2 3 4 5
```

样例输出

```
1
```
	
## 解题代码

```
#include<iostream>
#include<climits>

using namespace std;
#define N 32

int a[N],b[N];
int n,m,k,ans,min_ans;

void print(int *a,int n) {
    for(int i=1;i<=n;i++)
        cout<<a[i]<<" ";
    cout<<endl;
    ans++;
}

bool check(int h) {
    if(h>1 && h%2==1 && (a[h]-a[h-1])<0)
        return true;
    if(h>1 && h%2==0 && (a[h]-a[h-1])>0)
        return true;
    return false;
}

void dfs(int n,int h,int z) {
    if(h==n+1) {
        min_ans=min(min_ans,z);
        return ;
    }
    if(z>=min_ans) return ;
    int temp;
    if(h>1 && h%2==1 &&(a[h]-a[h-1])<0)
        dfs(n,h+1,z);
    if(h>1 && h%2==0 && (a[h]-a[h-1])>0)
        dfs(n,h+1,z);
    if(h==1) dfs(n,h+1,z);
    if(z+1>=min_ans) return ;
    for(int i=h+1;i<=n;i++){
        if(check(i)==1) continue;
        temp=a[h];
        a[h]=a[i];
        a[i]=temp;
        if(h>1 && h%2==1 && (a[h]-a[h-1])<0)
            dfs(n,h+1,z+1);
            if(h>1 && h%2==0 && (a[h]-a[h-1])>0)
                dfs(n,h+1,z+1);
            if(h==1) dfs(n,h+1,z+1);
        temp=a[h];
        a[h]=a[i];
        a[i]=temp;
    }
}

int main() {
    int n;
    while(cin>>n){
        for(int i=1;i<=n;i++)
            cin>>a[i];
        min_ans=INT_MAX;
        ans=0;
        dfs(n,1,0);

        for(int i=1;i<=n;i++)
            a[i]=-a[i];
        dfs(n,1,0);
        cout<<min_ans<<endl;
    }
    return 0;
}
```
