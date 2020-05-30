# hiho第96周:数论五·欧拉函数
## 题目描述
小Hi和小Ho有时候会用密码写信来互相联系,他们用了一个很大的数当做密钥。小Hi和小Ho约定了一个区间[L,R],每次小Hi和小Ho会选择其中的一个数作为密钥。

小Hi:小Ho,这次我们选[L,R]中的一个数K。

小Ho:恩,小Hi,这个K是多少啊?

小Hi:这个K嘛,不如这一次小Ho你自己想办法算一算怎么样?我这次选择的K满足这样一个条件:

> 假设φ(n)表示1..n-1中与n互质的数的个数。对于[L,R]中的任意一个除K以外的整数y,满足φ(K)≤φ(y)且φ(K)=φ(y)时,K\<y。

也即是K是[L,R]中φ(n)最小并且值也最小的数。

小Ho:噫,要我自己算么?

小Hi:没错！

小Ho:好吧,让我想一想啊。

<几分钟之后...>

小Ho:啊,不行了。。感觉好难算啊。

小Hi:没有那么难吧,小Ho你是怎么算的?

小Ho:我从枚举每一个L,R的数i,然后利用辗转相除法去计算[1,i]中和i互质的数的个数。但每计算一个数都要花好长的时间。

小Hi:你这样做的话,时间复杂度就很高了。不妨告诉你一个巧妙的算法吧:

### 提示:欧拉函数

小Hi:刚刚我所描述的φ(n),一般被称为欧拉函数。其定义为:小于n的正整数中与n互质的数的个数。

小Ho:又是欧拉么！

小Hi:毕竟是伟大的数学家,所以以他名字命名的东西很多啦。

对于φ(n),我们有这样三个性质:

**(1) 若n为素数,则φ(n) = n - 1**

显然,由于n为素数,1~n-1与n都只有公因子1,因此φ(n) = n - 1。

**(2) 若n = p^k,p为素数（即n为单个素数的整数幂）,则φ(n) = (p-1)\*p^(k-1)**

因为n是p的整数幂,因此所有p的倍数和n都不互质。小于n的p的倍数一共有p^(k-1)-1个,因此和n互质的个数为:

p^k-1 - (p^(k-1)-1) = p^k - p^(k-1) = (p-1)\*p^(k-1)

**(3) 若p和q互质,则φ(p\*q) = φ(p) \* φ(q)**

对于所有小于pq的整数u,可以表示为u=aq+r。(a=0,1,2,...,p-1,r=0,1,...,q-1)。

对于u = aq + r, 设R = u mod p,0≤R<q。对于一个固定的r,设a1, a2满足0 <= a1, a2 < p且a1≠a2,有:

```
u1 = a1*q+r, u2 = a2*q+r
u1-u2=(a1-a2)*q
```
因为p与q互质,且|a1-a2|<p,则|u1-u2|一定不是p的倍数。

所以对于每一个固定的r,其对应的p个u = a\*q+r(a=0,1,2,...,p-1)对mod p来说余数都不相同,即u mod p的结果恰好取遍0,1,...,p-1中的每一个数。

下面我证明一个引理:u mod p与p互质 <=> u与p互质,其证明如下:

```
假设a,b互质,c = a mod b。
假设c与b不互质,则存在d≥1,使得c=nd, b=md。
由于c = a mod b,因此a = kb + c,
则a = kmd + nd = (kn+m)d
因此d是a,b的公因数,与a,b互质矛盾。
假设不成立,所以c与b互质。
```

因此对于任意一个确定的r,与其对应的p个u中恰好有φ(p)个与p互质。

同理,由u = aq + r知r与q互质 <=> u与q互质。因此在0..q-1中恰好有φ(q)个r使得u与q互质。

综上,当r与q互质的情况下,固定r可以得到φ(p)个与p和q都互质的数。

满足条件的r一共用φ(q)个,所以一共能找到有φ(p) * φ(q)个与p和q都互质的数。

由此得证:φ(p\*q) = φ(p) \* φ(q)

这一段证明不是太好理解,小Ho你一定要自己推导一遍哦。

小Ho:好。


小Hi:在上面这些性质的基础上我们能到推导出两条定理:

若p为质数,n为任意整数:

**(1) 若p为n的约数,则φ(n\*p) = φ(n) \* p**

若p为n的约数,且p为质数。则我们可以将n表示为p^k*m。m表示其他和p不同的质数的乘积。

显然有p^k与m互质,则:

```
φ(n) = φ(p^k)*φ(m) = (p-1)*p^(k-1)*φ(m)
φ(n*p) = φ(p^(k+1))*φ(m) = (p-1)*p^k*φ(m) = (p-1)*p^(k-1)*φ(m) * p =  φ(n) * p
```
**(2) 若p为不为n的约数,则φ(n\*p) = φ(n) \* (p-1)**

由p不为n的约数,因此p与n互质,所以φ(n\*p) = φ(n) \* φ(p) = φ(n)*(p-1)


根据这两条定理,当我们得到一个n时,可以枚举质数p来递推的求解φ(n*p)。这一步是不是觉得很眼熟呢?

小Ho:嗯...我想起了,这不是我们使用欧拉筛法时一样的算法么?

小Hi:没错！因此我们只需要在欧拉筛代码的基础上做一个小改动,就可以得到递推求解φ(n)的算法:

```
isPrime[] = true
primeList = []
phi = []	// phi[n]表示n的欧拉函数
primeCount = 0
For i = 2 .. N
	If isPrime[i] Then
		primeCount = primeCount + 1
		primeList[ primeCount ] = i
		phi[i] = i - 1 // 质数的欧拉函数为p-1
	End If 
	For j = 1 .. primeCount
		If (i * primeList[j] > N) Then
			Break
		End If
		isPrime[ i * primeList[j] ] = false
		If (i % primeList[j] == 0) Then
			// primeList[j]是i的约数,φ(n*p) = φ(n) * p
			phi[ i * primeList[j] ] = phi[i] * primeList[j];
			Break
		Else 
			// primeList[j]不是i的约数,φ(n*p) = φ(n) * (p-1)
			phi[ i * primeList[j] ] = phi[i] * (primeList[j] - 1);
		End If
	End If
End For
```
小Ho:因为欧拉筛的时间复杂度是O(n)的,因此求出一个大区间内所有数的欧拉函数也只用了O(n)的时间。接下来再使用O(n)的枚举就可以求得最小的K了。我知道该怎么做了！

### 输入输出

* 输入

第1行:2个正整数, L,R,2≤L≤R≤5,000,000。

* 输出

第1行:1个整数,表示满足要求的数字K

样例输入

```
4 6
```
样例输出

```
4
```

## 解题代码

```

#include <iostream>
#include <vector>

using namespace std;

int tag[5000001];
vector<int> prime;
int low, hign;

void solve(int m){
    if (tag[m] == 0) {
        tag[m] = m - 1;
        prime.push_back(m);
    }
    for (auto it = prime.begin(); it != prime.end(); ++it) {
        int t = *it;
        if (t * m > hign) {
            break;
        }else{
            if (m % t == 0) {
                tag[m * t] = tag[m] * t;
                break;
            }else{
                tag[m * t] = tag[m] * (t - 1);
            }
        }
    }
}

int main(int argc, const char * argv[]) {
    // insert code here...
    scanf("%d %d", &low, &hign);
    for (int i = 2; i <= hign; ++i) {
        solve(i);
    }
    int val = hign;
    int rst = 0;
    for (int i = low; i <= hign; ++i) {
        if (tag[i] < val) {
            val = tag[i];
            rst = i;
        }
    }
    printf("%d", rst);
    return 0;
}
```
