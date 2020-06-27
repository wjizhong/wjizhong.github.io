# Hiho第95周:数论四·扩展欧几里德

## 题目描述

小Hi和小Ho周末在公园溜达。公园有一堆围成环形的石板,小Hi和小Ho分别站在不同的石板上。已知石板总共有m块,编号为 0..m-1,小Hi一开始站在s1号石板上,小Ho一开始站在s2号石板上。

小Hi:小Ho,你说我们俩如果从现在开始按照固定的间隔数同时同向移动,我们会不会在某个时间点站在同一块石板上呢?

小Ho:我觉得可能吧,你每次移动v1块,我移动v2块,我们看能不能遇上好了。

小Hi:好啊,那我们试试呗。

一个小时过去了,然而小Hi和小Ho还是没有一次站在同一块石板上。

小Ho:不行了,这样走下去不知道什么时候才汇合。小Hi,你有什么办法算算具体要多久才能汇合么?

小Hi:让我想想啊。。

### 提示:扩展欧几里德

小Hi:首先可以我俩现在的情况列出一个式子:

```
s1+v1*t=s2+v2*t-k*m  (v1<v2)
```

也就是经过t时间过后,速度快的人刚好超过了速度慢的人k圈,且到达同一个位置。

将这个式子进行变换得到:

```
(v1-v2)*t+k*m=(s2-s1)
```

即原式子变成了形如"Ax+By=C"的情况,我们要求解的是一组(x,y)使得原公式成立。

小Ho:形如"Ax+By=C",也就是说我们令A=(v1-v2),B=m,C=(s2-s1),x=t,y=k。

小Hi:恩,没错。

求解该式子的算法我们称为扩展欧几里德算法。

该算法分为两个部分:

* (1) **判定是否存在解**

对于形如"Ax+By=C"的式子,其存在解的条件为C为A和B最大公约数的整数倍。

我们将A和B的最大公约数记为gcd(A,B)。因此其有解的条件是C=n*gcd(A,B)。

那么我们应该如何来求解gcd(A,B)呢?

一个朴素的算法是枚举1~min(A,B),最大的一个能同时被A,B整除的数即gcd(A,B)。显然这个算法是非常没有效率的。

为了求解gcd(A,B),欧几里德提出了一个辗转相除法:

首先要证明一个定理:gcd(A,B) = gcd(B, A mod B)

证明:

```
假设A = k*B+r,有r = A mod B。不妨设d为A和B的一个任意一个公约数,则有A = pd, B = qd。
由r = A - k*B = pd - k*qd = (p - kq)*d,所以有d也为r的约数,因此d是B和A mod B的公约数。
由于对任意一个A和B的公约数都满足这个性质,gcd(A,B)也满足,因此有gcd(A,B)=gcd(B,A mod B)。
```
	
利用这个性质,我们可以得到算法:

```
A mod B = 0, 则B为gcd(A,B)
A mod B ≠ 0, 则gcd(A,B) = gcd(B, A mod B)
```
	
通过不断的模运算,数据的规模也越来越小,因此能够快速得收敛到一个解。将其写成伪代码为:

```
gcd(A, B):
	If (A mod B == 0) Then
		Return B
	End If
	Return gcd(B, A mod B)
```

* (2) **求解**

在判定有解之后,我们需要在其基础上再求出一组(x,y)。由于A,B,C均是gcd(A,B)的整数倍,因此可以将它们都缩小gcd(A,B)倍。即A'=A/gcd(A,B),B'=B/gcd(A,B),C'=C/gcd(A,B)。

化简为A'x+B'y=C',gcd(A',B')=1,即A',B'互质。

此时,我们可以先求解出A'x+B'y=1的解(x',y'),再将其扩大C'倍,即为我们要求的最后解(x,y)=(C'x', C'y')。

那么接下来我们来研究如何求解A'x+B'y=1:

假设A>B>0,同时我们设:

```
A * x[1] + B * y[1] = gcd(A, B)
B * x[2] + (A mod B) * y[2] = gcd(B, A mod B)
```

已知gcd(A,B)=gcd(B, A mod B),因此有:

```
	A * x[1] + B * y[1] = B * x[2] + (A mod B) * y[2]
=>	A * x[1] + B * y[1] = B * x[2] + (A - kB) * y[2]    // A = kB + r
=>	A * x[1] + B * y[1] = A * y[2] + B * x[2] - kB * y[2]
=>	A * x[1] + B * y[1] = A * y[2] + B * (x[2] - ky[2])
=>	x[1] = y[2], y[1] = (x[2] - ky[2])
```

利用这个性质,我们可以递归的去求解(x,y)。

其终止条件为gcd(A, B)=B,此时对应的(x,y)=(0,1)

将这个过程写成伪代码为:

```
extend_gcd(A, B):
	If (A mod B == 0) Then
		Return (0, 1)
	End If
	(tempX, tempY) = extend_gcd(B, A mod B)
	x = tempY
	y = tempX - (A / B) * tempY
	Return (x, y)	
```

小Ho:那么我只需要把A=(v1-v2),B=m,C=(s2-s1),x=t,y=k代入就可以得到t了么?

小Hi:是的,在已知A,B,C的情况下,我们的确能够顺利求解出一组合法的(x,y)。

但是在求解过程中,我们并没有保证x是最小的非负整数,它不能直接作为我们的解。

小Ho:那还需要做怎样的处理么?

小Hi:我们需要将(A',B',x',y')扩充为一个解系。

由于A'B'是互质的,所以可以将A'x'+B'y'=1扩展为:

```
	A'x'+B'y'+(u+(-u))A'B'=1
=>	(x' + uB')*A' + (y' - uA')*B' = 1
=>	X = x' + uB', Y = y' - uA'
```

可以求得最小的X为(x'+uB') mod B',(x'+uB'>0)

同时我们还需要将X扩大C'倍,因此最后解为:

```
x = (x'*C') mod B'
```

若x<0,则不断累加B',直到x>0为止。

那么最后,小Ho你来总结一下主体部分的伪代码吧！

小Ho:好的,最后的代码为:

```
solve(s1, s2, v1, v2, m):
	A = v1 - v2
	B = m
	C = s2 - s1
	
	If (A < 0) Then
		A = A + m // 相对距离变化
	End If
	D = gcd(A, B)
	
	If (C mod D) Then
		Return -1
	End If
	
	A = A / D
	B = B / D
	C = C / D
	
	(x, y) = extend_gcd(A, B)
	x = (x * C) mod B
	While (x < 0)
		x = x + B
	End While
	Return x
```


## 输入输出

* **输入**

第1行:每行5个整数s1,s2,v1,v2,m,0≤v1,v2≤m≤1,000,000,000。0≤s1,s2< m

中间过程可能很大,最好使用64位整型

* **输出**

第1行:每行1个整数,表示解,若该组数据无解则输出-1

样例输入

```
0 1 1 2 6
```

样例输出

```
5
```

## 解题代码

```c++
#include <iostream>
using namespace std;
long gcd(long a,long b){
	if(a%b==0)return b;
	return gcd(b,a%b);
}
void exgcd(long a,long b,long &x,long &y){
	if(b==0){
		x=1;
		y=0;
		return; 
	}
	exgcd(b,a%b,x,y);
	long tx = x;
	x = y;
	y = tx-a/b*y;
}
int main(){
	long s1,s2,v1,v2,m;
	cin>>s1>>s2>>v1>>v2>>m;
	long a = v1 - v2;
	long b = m;
	long c = s2 - s1;
	if(a<0) a+=m;
	long d = gcd(a,b);
	if(c%d)	{
		cout<<-1<<endl;return 0;
	}
	a/=d;
	b/=d;
	c/=d;
	long x,y;
	exgcd(a,b,x,y);
	x = x*c%b;
	while(x<0)	x+=b;
	cout<<x<<endl;
	return 0;
}
```

```python
def egcd(a, b):
    if b == 0: return a, 1, 0
    g, x, y = egcd(b, a % b)
    return g, y, x - a / b * y
s1, s2, v1, v2, m = map(int, raw_input().split())
if v1 < v2: v1, v2, s1, s2 = v2, v1, s2, s1
a, b, c = v1 - v2, m, (s2 - s1 + m) % m
g, x, y = egcd(a, b)
if c % g or not a and c:
    print -1
    exit()
b /= g
x = (x * c / g) % b
while x < 0: x += b
print x
```