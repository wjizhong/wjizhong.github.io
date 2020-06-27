# Hiho第100周:搜索三·启发式搜索

## 题目描述

在小Ho的手机上有一款叫做八数码的游戏,小Ho在坐车或者等人的时候经常使用这个游戏来打发时间。

游戏的棋盘被分割成3x3的区域,上面放着标记有1~8八个数字的方形棋子,剩下一个区域为空。

![](http://media.hihocoder.com/problem_images/20160528/14644336271419.png)

游戏过程中,小Ho只能移动棋子到相邻的空区域上。当小Ho将8个棋子都移动到如下图所示的位置时,游戏就结束了。

![](http://media.hihocoder.com/problem_images/20160528/14644336274267.png)

小Hi:小Ho,你觉得如果用计算机来玩这个游戏应该怎么做?

小Ho:用计算机来玩么?我觉得应该是搜索吧,让我想一想。

### 提示:启发式搜索

小Ho:这个问题和上一次一样嘛,用宽度优先搜索来求解。

然后把这个3x3的二维数组拉伸成一个长度为9的数组,将长度为9的数组作为状态。

那么最终状态就是{1,2,3,4,5,6,7,8,0}。

由于每一个位置的有9种可能,所以我建立一个9维数组来判重进行搜索就好了。

小Hi:9维数组,每一维的大小为9。小Ho,你确定这不会超过内存限制么?

小Ho:9的9次方等于387420489,好像是挺大的。不过应该没问题吧。

小Hi:怎么可能没问题!这个数据已经很大了好么!

小Ho:那该怎么办啊?

小Hi:小Ho,你仔细观察题目的状态。由于每个数字一定只会出现一次,每个状态对应的恰好是1~9的一个排列。

那么1~9的全排列有多少种呢?

小Ho:这个我知道,是9!,一共362880种。

小Hi:没错,总共只有不到40万种不同的情况。如果我们能够使用一个方法来表示不同排列的状态,那么是不是就可以把判重的状态数量压缩到40万以内了呢?

小Ho:恩,没错。但是有什么好的方法么？

小Hi:当然有啦,这里我们需要用的事全排列的知识。小Ho你知道全排列是有顺序的么？

小Ho:恩,知道。比如3个数的全排列,按顺序就是:

```
123, 132, 213, 231, 312, 321
```

小Hi:没错,那么第二个问题:假如我给你一个全排列,你能计算出它是第几个排列么?

小Ho:(⊙v⊙),这个我不知道。

小Hi:我就知道你不知道,让我来告诉你吧。这里我们需要用到一个叫做康托展开的方法。

对于一个长度为n的排列num[1..n],其序号X为：

```
X = a[1]*(n-1)!+a[2]*(n-2)!+...+a[i]*(n-i)!+...+a[n-1]*1!+a[n]*0!
其中a[i]表示在num[i+1..n]中比num[i]小的数的数量。
```

举个例子，比如213:

```
num[] = {2, 1, 3}
a[] = {1, 0, 0}
X = 1 * 2! + 0 * 1! + 0 * 1! = 2
```

我们如果将3的全排列从0开始编号，2号对应的正是213。

其写做伪代码为:

```c++
Cantor(num[])
    X = 0
    For i = 1 .. n
        tp = 0
        For j = i + 1 .. n
            If (num[j] < num[i]) Then
                tp = tp + 1
            End If
        End For
        X = X + tp * (n - i)!
    End For
    Return X
```

那么接下来,第三个问题!

小Ho:你说吧!

小Hi:已知X,如何去反向求解出全排列?

小Ho:我觉得应该还是从康托展开的公式入手。

< 小Ho拿出草稿纸,在上面推算了一会儿 >

根据X的求值公式,可以推断出对于a[i]来说,其值一定小于等于n-i。那么有:

```
a[i]≤n-i, a[i]*(n-i)!≤(n-i)*(n-i)!<(n-i+1)!
```

也就是说,对于a[i]来说,无论a[i+1..n]的值为多少,其后面的和都不会超过(n-i)!

那么也就是说,如果我用X除以(n-1)!,得到商c和余数r。其中c就等于a[1],r则等于后面的部分。

这样依次求解,就可以得到a[]数组了!

比如求解3的全排列中,编号为3的排列：

```
3 / 2! = 1 ... 1 => a[1] = 1
1 / 1! = 1 ... 0 => a[2] = 1
0 / 0! = 0 ... 0 => a[3] = 0
```

然后就是根据a[]来求解num[]，让我想一想。

...

我知道了!由于a[i]表示的是num[i+1..n]中比num[i]还小的数字。

那么只需要从num[1]开始,依次从尚未使用的数字中选取第a[i]+1小的数字填入就可以了！

紧接着上面的例子:

```
a[] = {1, 1, 0}
unused = {1, 2, 3}, a[1] = 1, num[1] = 2
unused = {1, 3}, a[2] = 1, num[2] = 3
unused = {1}, a[3] = 0, num[3] = 1
=> 2, 3, 1
```

231也确实是3的全排列中编号为3的排列。

小Hi:小Ho,你真棒!你使用的这个方法也被称为逆康托展开,写作代码的话:

```c++
unCantor(X):
    a = []
    num = []
    used = [] // 长度为n的boolean数组，初始为false
    For i = 1 .. n
        a[i] = X / (n - i)!
        X = X mod (n - i)!
        cnt = 0
        For j = 1 .. n
            If (used[j]) Then
                cnt = cnt + 1
                If (cnt == a[i] + 1) Then
                    num[i] = j
                    used[j] = true
                    Break
                End If
            End If
        End For
    End For
    Return num
```

通过康托展开以及康托逆展开,我们就将该问题的状态空间压缩到了9!,在空间复杂度上得到了优化。

小Ho:那么这次的问题不就解决了!

小Hi:远远没那么简单哦,其实这个问题还有一个时间上的优化。

小Ho:但是宽度优先搜索不就是最快寻找到解的方法了么?还有更好的方法么?

小Hi:当然有了,我们有一种叫做启发式搜索的方法。

在启发式搜索的过程中,不再是一定按照步数最优的顺序来搜索。

首先在启发式搜索中,我们每次找到当前“最有希望是最短路径”的状态进行扩展。对于每个状态的我们用函数F来估计它是否有希望。F包含两个部分:

```
F = G + H
```

G:就是普通宽度优先搜索中的从起始状态到当前状态的代价,比如在这次的问题中,G就等于从起始状态到当前状态的最少步数。

H:是一个估计的值,表示从当前状态到目标状态估计的代价(步数)。

H是由我们自己设计的,H函数设计的好坏决定了A*算法的效率。H值越大,算法运行越快。

但是在设计评估函数时,需要注意一个很重要的性质:评估函数的值一定要小于等于实际当前状态到目标状态的代价(步数)。

否则虽然你的程序运行速度加快,但是可能在搜索过程中漏掉了最优解。相对的,只要评估函数的值小于等于实际当前状态到目标状态的代价,就一定能找到最优解

在这个问题中可以表述为:评估函数得到的从当前状态到目标的状态需要行动的步数一定不能超过实际上需要行动的步数。

所以,我们可以将评估函数设定为:1-8八数字当前位置到目标位置的曼哈顿距离之和。(为什么这样设计留给读者思考。当然也有其他符合条件的估计函数,不同估计函数效率如何也留给读者自行比较。)

F:评估值和状态值的总和。

同时在启发式搜索中将原来的一个队列变成了两个队列:openlist和closelist。

在openlist中的状态,其F值还可能发生变化。而在closelist中的状态,其F值一定不会再发生改变。

整个搜索解的流程变为:

```
计算初始状态的F值,并将其加入openlist
从openlist中取出F值最小的状态u,并将u加入closelist。若u为目标状态,结束搜索;
对u进行扩展,假设其扩展的状态为v:若v未出现过,计算v的f值并加入openlist;若v在openlist中,更新v的F值,取较小的一个;若v在closelist中,抛弃该状态。
若openlist为空,结束搜索。否则回到2。
```

利用这个方法可以避免搜索一些明显会远离目标状态的状态,从而缩小搜索空间,早一步搜索到目标结果。

在启发式搜索中,最重要的是评估函数的选取,一个好的评估函数能够更快的趋近于目标状态。

将上述过程写做伪代码为:

```c++
search(status):
    start.status = status
    start.g = 0 // 实际步数
    start.h = evaluate(start.status)
    start.f = start.g + start.h
    
    openlist.insert(start)
    
    While (!openlist.isEmpty()) 
        u = openlist.getMinFStatus()
        closelist.insert(u)
        For v is u.neighborStatus
            If (v in openlist) Then
                // 更新v的f值
                If (v.f > v.h + u.g + 1) Then
                    v.f = v.h + u.g + 1
                End If
            Else If (v in closelist)
                continue
            Else 
                v.g = u.g + 1
                v.h = evaluate(v.status)
                v.f = v.g + v.h
                openlist.insert(v)
            End If
        End For
    End While
```

其中openlist.getMinFStatus()可以使用堆来实现。

启发式搜索在某些情况下并不一定好用,一方面取决于评估函数的选取,另一个方面由于在选取状态时也会有额外的开销。而快速趋近目标结果所减少的时间.能否弥补这一部分开销也是非常关键的。

所以根据题目选取合适的搜索方法才是最重要的。

## 输入输出

* **输入**

第1行:1个正整数t,表示数据组数。1≤t≤8。

接下来有t组数据,每组数据有3行,每行3个整数,包含0~8,每个数字只出现一次,其中0表示空位。

* **输出**

第1..t行:每行1个整数,表示该组数据解的步数。若无解输出"No Solution!"

样例输入

```
3
1 2 3
4 5 6
7 8 0
1 2 3
4 5 6
8 7 0
8 0 1
5 7 4
3 6 2
```

样例输出

```
0
No Solution!
25
```

* **解题代码**

`c++`代码:

```c++
//启发式搜索
#include <stdio.h>  
#include <string.h>  
#include <math.h>  
#include <queue>  
#include <stack>  
#include <algorithm>  
#include <iostream>
using namespace std;  
int Hash[15];    
struct node  
{  
    int f,h,g;  
    int x,y;  
    char map[3][3];  
    friend bool operator< (const node &a,const node &b)  
    {  
        if(a.f==b.f)  
            return a.g<b.g;  
        return a.f>b.f;  
    }  
};  

node start;

int pos[][2]= {{0,0},{0,1},{0,2},{1,0},{1,1},{1,2},{2,0},{2,1},{2,2}};  
bool vis[500000];   
int to[4][2]={0,-1,0,1,-1,0,1,0};

int check()//判断不可能的状况  
{  
    int i,j,k;  
    int s[20];  
    int cnt = 0;  
    for(i = 0; i<3; i++)  
    {  
        for(j = 0; j<3; j++)  
        {  
            s[3*i+j] = start.map[i][j];  
            if(s[3*i+j] == 'x')  
                continue;  
            for(k = 3*i+j-1; k>=0; k--)  
            {  
                if(s[k] == 'x')  
                    continue;  
                if(s[k]>s[3*i+j])  
                    cnt++;  
            }  
        }  
    }  
    if(cnt%2)  
        return 0;  
    return 1;  
}  

int solve(node a)//康托  
{  
    int i,j,k;  
    int s[20];  
    int ans = 0;  
    for(i = 0; i<3; i++)  
    {  
        for(j = 0; j<3; j++)  
        {  
            s[3*i+j] = a.map[i][j];  
            int cnt = 0;  
            for(k = 3*i+j-1; k>=0; k--)  
            {  
                if(s[k]>s[3*i+j])  
                    cnt++;  
            }  
            ans = ans+Hash[i*3+j]*cnt;  
        }  
    }  
    return ans;  
}  

int get_h(node a)//得到H值  
{  
    int i,j;  
    int ans = 0;  
    for(i = 0; i<3; i++)  
    {  
        for(j = 0; j<3; j++)  
        {  
            if(a.map[i][j] == 'x')  
                continue;  
            int k = a.map[i][j]-'1';  
            ans+=abs(pos[k][0]-i)+abs(pos[k][1]-j);  
        }  
    }  
    return ans;  
}  

int bfs()  
{  
    memset(vis,0,sizeof(vis));  
    priority_queue<node> Q;  
    start.g = 0;  
    start.h = get_h(start);  
    start.f = start.h; 
    vis[solve(start)]=true;
    if(solve(start)==0)  return 0;
    Q.push(start);  
    node next;
    while(!Q.empty())  
    {  
        node a = Q.top();  
        Q.pop();  
        int k_s = solve(a);  
        vis[k_s]=true;
        for(int i = 0; i<4; i++)  
        {  
            next = a;  
            next.x+=to[i][0];  
            next.y+=to[i][1];  
            if(next.x < 0 || next.y < 0 || next.x>2 || next.y > 2)  
                continue;  
            next.map[a.x][a.y] = a.map[next.x][next.y];  
            next.map[next.x][next.y] = 'x';  
            next.g+=1;  
            next.h = get_h(next);  
            next.f = next.g+next.h;  
            int k_n = solve(next);  
            if(vis[k_n])  
                continue;  
            Q.push(next);  
            if(k_n == 0)  
                return next.g;  
        }  
    }  
}  

int main()  
{    
    Hash[0] = 1;  
    for(int i = 1; i<=9; i++)  
        Hash[i] = Hash[i-1]*i;  
    int t=0;
    cin>>t;
    char a=0;
    for (int i=0;i<t;i++)
    {
        for (int i=0;i<3;i++)
        {
            for (int j=0;j<3;j++)
            {
                cin>>a;
                start.map[i][j]=a;
                if(a=='0')  
                {
                    start.map[i][j]='x';
                    start.x=i;
                    start.y=j;
                }
            }
        }
        if(!check())  
        {  
            cout<<"No Solution!"<<endl;  
        }  
        else cout<<bfs()<<endl;  
    } 
    return 0;  
}
```