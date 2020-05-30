
# hiho第093周:数论二·Eular质数筛法

* **题目描述**

小Ho:小Hi,上次我学会了如何检测一个数是否是质数。于是我又有了一个新的问题,我如何去快速得求解[1,N]这个区间内素数的个数呢？

小Hi:你自己有什么想法么?

小Ho:有!我一开始的想法是,自然我们已经知道了如何快速判定一个数是否是质数,那么我就直接将[1,N]之间每一个数判定一次,就可以得到结果。但我发现这个方法太笨了。

小Hi:确实呢,虽然我们已经通过快速素数检测将每一次判定的时间复杂度降低,但是N个数字的话,总的时间复杂度依旧很高。

小Ho:是的,所以后来我改变了我的算法。我发现如果一个数p是质数的话,那么它的倍数一定都是质数。所以我建立了一个布尔类型的数组isPrime,初始化都为true。我从2开始枚举,当我找到一个isPrime[p]仍然为true时,可以确定p一定是一个质数。接着我再将N以内所有p的倍数全部设定为isPrime[p\*i]=false。

写成伪代码为:

```c++
isPrime[] = true
primeCount = 0
For i = 2 .. N
	If isPrime[i] Then
		primeCount = primeCount + 1
		multiple = 2
		While (i * multiple ≤ N)
			isPrime[i * multiple] = false
			multiple = multiple + 1
		End While 
	End If
End For
```
  
小Hi:小Ho你用的这个算法叫做Eratosthenes筛法,是一种非常古老的质数筛选算法。其时间复杂度为O(n log log n)。但是这个算法有一个冗余的地方:比如合数10,在枚举2的时候我们判定了一次,在枚举5的时候我们又判定了一次。因此使得其时间复杂度比O(n)要高。

小Ho:那有没有什么办法可以避免啊?

小Hi:当然有了,一个改进的方法叫做Eular筛法,其时间复杂度是O(n)的。

> * 提示:Eular质数筛法

小Hi:我们可以知道,任意一个正整数k,若k≥2,则k可以表示成若干个质数相乘的形式。Eratosthenes筛法中,在枚举k的每一个质因子时,我们都计算了一次k,从而造成了冗余。因此在改进算法中,只利用k的最小质因子去计算一次k。

首先让我们了解一下Eular筛法,其伪代码为:

```c++
isPrime[] = true
primeList = []
primeCount = 0
For i = 2 .. N
	If isPrime[i] Then
		primeCount = primeCount + 1
		primeList[ primeCount ] = i
	End If 
	For j = 1 .. primeCount
		If (i * primeList[j] > N) Then
			Break
		End If
		isPrime[ i * primeList[j] ] = false
		If (i % primeList[j] == 0) Then
			Break
		End If
	End If
End For
```

与Eratosthenes筛法不同的是,对于外层枚举i,无论i是质数,还是是合数,我们都会用i的倍数去筛。但在枚举的时候,我们只枚举i的质数倍。比如2i,3i,5i,...,而不去枚举4i,6i...,原因我们后面会讲到。

此外,在从小到大依次枚举质数p来计算i的倍数时,我们还需要检查i是否能够被p整除。若i能够被p整除,则停止枚举。

利用该算法,可以保证每个合数只会被枚举到一次。我们可以证明如下命题:

假设一个合数k=M\*p1,p1为其最小的质因子。则k只会在i=M,primeList[j]=p1时被筛掉一次。

首先会在i=M,primeList[j]=p1时被筛掉是显然的。因为p1是k的最小质因子,所以i=M的所有质因子也≥p1。于是j循环在枚举到primeList[j]=p1前不会break,从而一定会在i=M,primeList[j]=p1时被筛掉

其次不会在其他时候被筛掉。否则假设k在i=N, primeList[j]=p2时被筛掉了,此时有k=N\*p2。由于p1是k最小的质因子,所以p2 > p1,M > N且p1|N。则i=N,j枚举到primeList[j]=p1时(没到primeList[j]=p2)就break了。所以不会有其他时候筛掉k。

同时,不枚举合数倍数的原因也在此:对于一个合数k=M\*2\*3。只有在枚举到i=M\*3时,才会计算到k。若我们枚举合数倍数,则可能会在i=M时,通过M\*6计算到k,这样也就造成了多次重复计算了。

综上,Eular筛法可以保证每个合数只会被枚举到一次,时间复杂度为O(n)。当N越大时,其相对于Eratosthenes筛法的优势也就越明显。

* **输入输出**

> * 输入

第1行:1个正整数n,表示数字的个数,2≤n≤1,000,000。

> * 输出

第1行:1个整数,表示从1到n中质数的个数

样例输入

`9`

样例输出

`4`

* **解题代码**

`c++`代码:

```c++
#include <iostream>
#define N 1000000
using namespace std;

bool isPrime[N+10];

int main(){
    int n; cin >> n;
    for(int i=2; i<=n; i++)
        isPrime[i] = true;
        
    for(int d=2; d*d <=n; d++){
        if(isPrime[d]){
            for(int k=d*d; k<=n; k += d)
                isPrime[k] = false;
        }
    }
    int cnt = 0;
    for(int i=2; i<=n; i++)
        if(isPrime[i]) cnt++;
    cout << cnt << endl;
    return 0;
}
```

`python`代码:

```python
n = int(raw_input())
is_prime = [True] * (n + 1)
primes = []
for i in range(2, n + 1):
    if is_prime[i]: primes.append(i)
    for j in primes:
        if i * j > n: break
        is_prime[i * j] = False
        if i % j == 0: break
print len(primes)
```

```
# 1000以内的素数
2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97,101,103,107,109,113,127,131,137,139,149,151,157,163,167,173,179,181,191,193,197,199,211,223,227,229,233,239,241,251,257,263,269,271,277,281,283,293,307,311,313,317,331,337,347,349,353,359,367,373,379,383,389,397,401,409,419,421,431,433,439,443,449,457,461,463,467,479,487,491,499,503,509,521,523,541,547,557,563,569,571,577,587,593,599,601,607,613,617,619,631,641,643,647,653,659,661,673,677,683,691,701,709,719,727,733,739,743,751,757,761,769,773,787,797,809,811,821,823,827,829,839,853,857,859,863,877,881,883,887,907,911,919,929,937,941,947,953,967,971,977,983,991,997
```
