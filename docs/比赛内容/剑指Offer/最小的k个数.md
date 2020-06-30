# 最小的k个数

## 题目描述

输入整数数组arr,找出其中最小的k个数。例如,输入4、5、1、6、2、7、3、8这8个数字，则最小的4个数字是1、2、3、4。

示例1:

```
输入：arr = [3,2,1], k = 2
输出：[1,2] 或者 [2,1]
```

示例2:

```
输入：arr = [0,1,2,1], k = 1
输出：[0]
```

限制:


> 0 <= k <= arr.length <= 10000
> 
> 0 <= arr[i] <= 10000

## 解题技巧

* **方法一:排序**

对原数组从小到大排序后取出前k个数即可。

```python
class Solution:
    def getLeastNumbers(self, arr: List[int], k: int) -> List[int]:
        arr.sort()
        return arr[:k]
```

复杂度分析

> 时间复杂度:$O(n\log n)$,其中n是数组arr的长度。算法的时间复杂度即排序的时间复杂度。
> 
> 空间复杂度:$O(\log n)$,排序所需额外的空间复杂度为$O(\log n)$。

* **方法二:堆**

我们用一个大根堆实时维护数组的前k小值。首先将前k个数插入大根堆中,随后从第k+1个数开始遍历,如果当前遍历到的数比大根堆的堆顶的数要小,就把堆顶的数弹出,再插入当前遍历到的数。最后将大根堆里的数存入数组返回即可。在下面的代码中,由于C++语言中的堆(即优先队列)为大根堆,我们可以这么做。而Python语言中的对为小根堆,因此我们要对数组中所有的数取其相反数,才能使用小根堆维护前k小值。

C++Python

```python
class Solution:
    def getLeastNumbers(self, arr: List[int], k: int) -> List[int]:
        if k == 0:
            return list()

        hp = [-x for x in arr[:k]]
        heapq.heapify(hp)
        for i in range(k, len(arr)):
            if -hp[0] > arr[i]:
                heapq.heappop(hp)
                heapq.heappush(hp, -arr[i])
        ans = [-x for x in hp]
        return ans
```

复杂度分析

> 时间复杂度:$O(n\log k)$,其中n是数组arr的长度。由于大根堆实时维护前k小值,所以插入删除都是$O(\log k)$的时间复杂度,最坏情况下数组里n个数都会插入,所以一共需要$O(n\log k)$的时间复杂度。
> 
> 空间复杂度$O(k)$,因为大根堆里最多k个数。

* **方法三:快排思想**

我们可以借鉴快速排序的思想。我们知道快排的划分函数每次执行完后都能将数组分成两个部分,小于等于分界值pivot的元素的都会被放到数组的左边,大于的都会被放到数组的右边,然后返回分界值的下标。与快速排序不同的是,快速排序会根据分界值的下标递归处理划分的两侧,而这里我们只处理划分的一边。

我们定义函数`randomized_selected(arr, l, r, k)`表示划分数组arr的[l,r]部分,使前k小的数在数组的左侧,在函数里我们调用快排的划分函数,假设划分函数返回的下标是pos(表示分界值pivot最终在数组中的位置),即pivot是数组中第pos-l+1小的数,那么一共会有三种情况:

> 如果pos-l+1==k,表示pivot就是第k小的数,直接返回即可;
> 
> 如果pos - l + 1 < k，表示第 kk 小的数在 pivot 的右侧，因此递归调用 randomized_selected(arr, pos + 1, r, k - (pos - l + 1))；
> 
> 如果 pos - l + 1 > k，表示第 kk 小的数在 pivot 的左侧，递归调用 randomized_selected(arr, l, pos - 1, k)。

函数递归入口为`randomized_selected(arr, 0, arr.length - 1, k)`。在函数返回后,将前`k`个数放入答案数组返回即可。

```python
class Solution:
    def partition(self, nums, l, r):
        pivot = nums[r]
        i = l - 1
        for j in range(l, r):
            if nums[j] <= pivot:
                i += 1
                nums[i], nums[j] = nums[j], nums[i]
        nums[i + 1], nums[r] = nums[r], nums[i + 1]
        return i + 1

    def randomized_partition(self, nums, l, r):
        i = random.randint(l, r)
        nums[r], nums[i] = nums[i], nums[r]
        return self.partition(nums, l, r)

    def randomized_selected(self, arr, l, r, k):
        pos = self.randomized_partition(arr, l, r)
        num = pos - l + 1
        if k < num:
            self.randomized_selected(arr, l, pos - 1, k)
        elif k > num:
            self.randomized_selected(arr, pos + 1, r, k - num)

    def getLeastNumbers(self, arr: List[int], k: int) -> List[int]:
        if k == 0:
            return list()
        self.randomized_selected(arr, 0, len(arr) - 1, k)
        return arr[:k]
```

复杂度分析

> 时间复杂度:期望为$O(n)$,由于证明过程很繁琐,所以不再这里展开讲。具体证明可以参考《算法导论》第9章第2小节。最坏情况下的时间复杂度为$O(n^2)$。情况最差时,每次的划分点都是最大值或最小值，一共需要划分n-1次,而一次划分需要线性的时间复杂度,所以最坏情况下时间复杂度为$O(n^2)$。
> 
> 空间复杂度:期望为$O(\log n)$,递归调用的期望深度为$O(\log n)$,每层需要的空间为$O(1)$,只有常数个变量。最坏情况下的空间复杂度为$O(n)$。最坏情况下需要划分n次,即`randomized_selected`函数递归调用最深n-1层,而每层由于需要$O(1)$的空间,所以一共需要$O(n)$的空间复杂度。
