# hiho第101周:搜索四·跳舞链

* **描述**

小Ho最近遇到一个难题,他需要破解一个棋局。

棋局分成了n行,m列,每行有若干个棋子。小Ho需要从中选择若干行使得每一列有且恰好只有一个棋子。

比如下面这样局面:

![](http://media.hihocoder.com/problem_images/20160604/14650297539464.png)

其中1表示放置有棋子的格子,0表示没有放置棋子。

![](http://media.hihocoder.com/problem_images/20160604/14650297531540.png)

对于上面这个问题,小Ho经过多次尝试以后得到了解为选择2、3、4行就可以做到。

但是小Ho觉得自己的方法不是太好,于是他求助于小Hi。

小Hi!小Ho你是怎么做的呢?

小Ho：我想每一行都只有两种状态,选中和未被选中。那么我将选中视为1,未选中视为0。则每一种组合恰好对应了一个4位的01串，也就是一个4位的二进制数。

小Hi:恩,没错。

小Ho:然后我所做的就是去枚举每一个二进制数然后再来判定是否满足条件。

小Hi:小Ho你这个做法本身没什么问题,但是对于棋盘行数再多一点的情况就不行了。

小Ho:恩，我也这么觉得,那你有什么好方法么?

小Hi:我当然有了,你听我慢慢道来。

> * **提示:跳舞链**

小Hi:对于这一类的问题,我们可以把所有的列看成一个集合S,每一行是一个S的子集s[i]。

我们要做的是选取若干个s[i],满足两个条件:

```
1. 对于任何选择的s[i],s[j]，s[i]∩s[j]=∅
2. ∪s[i] = S,即所有s[i]取并集后刚好等于S
```

对于满足这个性质的问题,它们有一个统一的名称,叫做精确覆盖问题。

精确覆盖问题的常见解法就是搜索。

小Ho:但是小Hi你刚刚已经说了,直接按照二进制来枚举是不行的。那还有其他求解方法么?

小Hi:当然有了,著名的程序设计大师Knuth就提到过一种叫做Dancing Links的搜索方法,专门针对精确覆盖问题。

小Ho:Dancing Links,跳舞的链接?

小Hi:中文翻译叫做跳舞链啦,他构造了一种特别的数据结构来保存精确覆盖问题的状态。

由于精确覆盖问题总可以将集合的元素表示为列,各个子集表示为行。每个精确覆盖问题一定有其对应的01矩阵。

跳舞链在原01矩阵的基础上,增加了若干个节点,并将这些节点都串联了起来。

我们不妨举个例子来说明吧:

比如覆盖的问题为:

![](http://media.hihocoder.com/problem_images/20160604/14650297539464.png)

其对应的跳舞链数据结构为:

![](http://media.hihocoder.com/problem_images/20160604/14650299026526.jpg)

其中每一个蓝色的矩形表示一个节点,节点1~6和原矩阵中的6个1的位置相对应。

每个节点有4个方向的指针,分别指向它上下左右四个方向的节点。并且这些链表都是循环链表。

需要注意的是,若一行只有一个元素,则它的左右指针均会指向自己。比如图中的节点3。

这样的数据结构被称为双向十字循环链表。

同时和原来的01矩阵相比,跳舞链的数据结构中还增加了5个节点,分别为H,a,b,c,d。

节点a,b,c,d是每一列的头节点,每一列必须要有一个头结点。

节点H,是所有列头节点的头节点,一般被称为Head。

那么小Ho,假如01矩阵的大小为n*m,构造为跳舞链之后一共有多少个节点呢?

小Hi:原来每一个1都需要对应1个节点,那么假设原来有k个1,则有k个节点。每一列也必须有1个节点,这里就是m个节点。再加上Head节点,所以一共是k+m+1个节点。

小Ho:没错,那么接下来就需要了解如何在这个数据结构上进行搜索了！

首先拿到我们的双向十字循环链表:

![](http://media.hihocoder.com/problem_images/20160604/14650299026526.jpg)

第一步,先取出head节点,然后访问head节点的右边第一个列头节点。

![](http://media.hihocoder.com/problem_images/20160604/14650299023257.jpg)

于是我们获得了节点a,然后考虑在第a列取第几行。此时可以选择的有1和4节点。(图中绿色节点)

![](http://media.hihocoder.com/problem_images/20160604/14650299028630.jpg)

由于是搜索,所以我们先按照顺序来取,这一次我们选择节点1。(图中橙色的节点)

![](http://media.hihocoder.com/problem_images/20160604/14650299028746.jpg)

选择了第一行,就会对其他行产生影响。

首先可以确定第a列不能再选择其他元素,因此所有在第a列有元素的行都需要删除。(图中的绿色节点)

同时由于第一行还存在一个第c列的元素,因此所有在第c列有元素的行也需要删除。(图中的黄色节点)

从数据结构中将这些节点全部删除。同时将第1行压入答案栈。

![](http://media.hihocoder.com/problem_images/20160604/14650299029419.jpg)

删除节点后得到新的跳舞链数据结构。

重复操作,取出head节点,然后访问head节点的右边第一个列头节点。

![](http://media.hihocoder.com/problem_images/20160604/14650299029995.jpg)

这一次我们选取了第b列,在该列下只有节点3一个节点,因此只能选择它。

将第2行压入答案栈。

![](http://media.hihocoder.com/problem_images/20160604/14650299025063.jpg)

将关联节点删除后,得到的新数据结构。

此时我们还是取出head,并访问其右边第一个节点d。

但是在第d列下并没有任何节点,因此出现错误。在选择当前答案栈行数的情况下,d列无法被覆盖。

进行回溯,并将删除的节点还原。

![](http://media.hihocoder.com/problem_images/20160604/14650299025607.jpg)

回到第一次进行选择的地方,此时我们选择节点4。

同样删除在第a列存在元素的其他节点(绿色),以及相关的节点(黄色)。

并将第3行压入答案栈。

![](http://media.hihocoder.com/problem_images/20160604/14650299021099.jpg)

这一次还是选取了第b列的节点3。

![](http://media.hihocoder.com/problem_images/20160604/14650299025560.jpg)

第三层递归，选取了第c列的节点5。由于第4行存在第d列的元素，因此需要删除第d列相关的行。

![](http://media.hihocoder.com/problem_images/20160604/14650299029198.jpg)

最后再一次递归时,我们发现head节点的右边是它自己了。此时可以判定答案栈中的行,将所有节点覆盖了。

跳舞链的巧妙之处在于:每一次删除节点,都把有冲突的部分删掉,保留下来的一定是不冲突的部分。

小Ho:但是小Hi,我有一个地方不是太明白。在下面两步的时候,为啥第一次要删除第c列的头节点,第二次就不删除呢?

![](http://media.hihocoder.com/problem_images/20160604/14650299028746.jpg)
![](http://media.hihocoder.com/problem_images/20160604/14650299025607.jpg)

小Hi：这和我们所选取的节点有关。

第一次我们选择了节点1,也就是我们选择了第1行。因此第1行所有对应的第a列和第c列都被覆盖了。因此我们要删除a和c两个头结点。同时所有在第a列和c列有元素的行也会删去,比如第3行和第4行。而删除这些没有被选中的行时,只要删除其信息就可以了,不需要去处理对应的头节点。比如第一次删除的第4行中也包含了节点6,但并不包含第d列的头结点。

第二次也是同样的,由于第3行只包含节点4,因此我们只需要删除a列的头结点。而第1行删除时,需要把其对应的节点2删除,但是第c列并没有被覆盖到,所以并不需要删除第c列的头结点。

小Ho:原来如此,我大概明白了跳舞链的思想。那么它应该怎么实现呢?尤其是这个删除和恢复节点的过程。

小Hi:如何去实现也确实是跳舞链的一个难点,我们将其分解为4个部分:构造,删除,恢复,搜索。

**1. 构造**

构造部分就是如何将原来的01矩阵转化为双十字循环链表的过程。

每个节点需要包含有6个信息,上下左右四个指针,以及该节点所在的坐标。

```
Node:
    left, right, up, down, x, y
```

若x=0则表示该节点为列的头节点,若x=0,y=0则表示该节点为head节点。

由于每一行每一列都是一个循环链表,因此我们可以用逐个添加的方法,将所有的节点加入。

```
//处理行
Build:
    // 初始化head节点
    head = {left: head, right: head, up: head, down: head, x: 0, y: 0}
    // 初始化列头节点
    columnHead = []
    pre = head // 表示前一个节点
    For i = 1 .. m
        p = columnHead[i]
        // 上下指针指向自己
        p.up = p, p.down = p
        // 记录坐标
        p.x = 0, p.y = i
        // 向横向的双向列表中添加一个元素
        p.right = pre.right
        p.left = pre
        pre.right.left = p
        pre.right = p
        // 更新pre为当前节点
        pre = p
    End For
    // 给节点编号，并初始化每个节点
    cnt = 0
    node = []
    For i = 1 .. n
        For j = 1 .. m
            If (board[i][j] == 1) Then
                cnt = cnt + 1
                id[i][j] = cnt
                node[cnt] = {
                    left: node[cnt], right: node[cnt], 
                    up: node[cnt], down: node[cnt],
                    x: i, y: j
                }
            End If  
        End For
    End For
    // 纵向添加节点
    For j = 1 .. m
        pre = columnHead[j]
        For i = 1 .. n
            If (board[i][j] == 1) Then
                p = node[ id[i][j] ];
                p.down = pre.down
                p.up = pre
                pre.down.up = p
                pre.down = p
                pre = p
            End If
        End For
    End For
    // 横向添加节点
    For i = 1 .. n
        pre = NULL  // 横向没有头结点
        For j = 1 .. m
            If (board[i][j] == 1) Then
                If (pre == NULL) Then
                    // 将扫描到的第一个节点作为头结点
                    pre = node[ id[i][j] ]
                Else
                    p = node[ id[i][j] ]
                    p.right = pre.right
                    p.left = pre
                    pre.right.left = p
                    pre.right = p
                    pre = p
                End If
            End If
        End For
    End For
```

通过build函数就可以在O(nm)的时间内构造出整个数据结构。

接下来考虑如何删除。

```
remove(col):    // 删除第col列
    p = columnHead[col]
    p.right.left = p.left
    p.left.right = p.right
    p2 = p.down
    While (p2 != p) 
        // 获取该列下的每一个节点p2
        p3 = p2.right 
        While (p3 != p2)
            // 获取节点p2所在行的其他节点p3
            p3.down.up = p3.up
            p3.up.down = p3.down
            p3 = p3.right
        End While
        p2 = p2.down
    End While
```

而恢复操作是删除操作的逆操作:

```
resume(col):    // 恢复第col列
    p = columnHead[col]
    p.right.left = p
    p.left.right = p
    p2 = p.down
    While (p2 != p) 
        // 获取该列下的每一个节点p2
        p3 = p2.right 
        While (p3 != p2)
            // 获取节点p2所在行的其他节点p3
            p3.down.up = p3
            p3.up.down = p3
            p3 = p3.right
        End While
        p2 = p2.down
    End While
```

上面这两个操作都充分利用了双向链表的性质,如果小Ho你有不太明白的地方,手动模拟一次就可以明白了。

小Ho:好的!

小Hi:那么最后就是跳舞链的主函数搜索过程,这一部分我们称为跳舞(Dance)：

```
dance(depth):
    p = head.right
    If (p == head) Then
        // 若head的右边就是head自己，则已经找到解
        Return True;
    End If
    p2 = p.down
    If (p2 == p) Then
        // 当前列没有节点，则当前列一定不会被覆盖
        Return false
    End If 
    
    remove(p.y) // 删除当前列
    While (p2 != p) 
        // 枚举选取每一个节点
        ans[ depth ] = p2.x // 将行压入答案栈中
        
        // 删除p2所在行的其他列
        p3 = p2.right
        While (p3 != p2)
            remove(p3.y)
            p3 = p3.right
        End While
        
        // 递归下一步
        If (dance(depth + 1)) Then
            Return True
        End If
        
        // 恢复p2所在行的其他列
        p3 = p2.left // 这个地方需要反向来做
        While (p3 != p2)
            resume(p3.y)
            p3 = p3.left
        End While
        
        //  枚举下一个节点
        p2 = p2.down
    End While
    resume(p.y) // 恢复当前列
    Return False
```

在充分利用链表的情况下将跳舞链实现了,是不是很简单啊。

小Ho:(⊙o⊙)哦,我这就去写写看!

* **输入输出**

> * **输入**

第1行:1个正整数t,表示数据组数,1≤t≤10。

接下来t组数据,每组的格式为:

第1行:2个正整数n,m,表示输入数据的行数和列数。2≤n,m≤100。

第2..n+1行:每行m个数,只会出现0或1。

> * **输出**

第1..t行:第i行表示第i组数据是否存在解,若存在输出"Yes",否则输出"No"。

样例输入

```
2
4 4
1 1 0 1
0 1 1 0
1 0 0 0
0 1 0 1
4 4
1 0 1 0
0 1 0 0
1 0 0 0
0 0 1 1
```

样例输出

```
No
Yes
```

* **解题代码**

`c++`代码:

```c++
#include<iostream>
#include<cstdio>
#include<bitset>
#include<cstring>

#define MAXN 105

using namespace std;

int n,m;
bitset<MAXN>rolcolList[MAXN];
bitset<MAXN>colrolList[MAXN];
bitset<MAXN>colremain;
bitset<MAXN>rolremain;

bool Dfs(int index)
{
    //if we have found the answer or there is no rol to choose
    //return the result
    if(colremain.count() == m)return true;
    else if(rolremain.count() == n)return false;
    int i,j;
    bitset<MAXN>recordrol;
    bitset<MAXN>recordcol;
    recordcol = colremain;
    recordrol = rolremain;
    for(i=index;i<=n;i++){
        //search for the available row
        if(rolremain[i] == 0){
            for(j=1;j<=m;j++){
                if(rolcolList[i][j] == 1)rolremain |= colrolList[j];
            }
            colremain |= rolcolList[i];
            if(Dfs(i))return true;
            rolremain = recordrol;
            colremain = recordcol;
        }
    }
    return false;
}

void Init()
{
    rolremain.reset();
    colremain.reset();
    int i;
    for(i=0;i<MAXN;i++){
        colrolList[i].reset();
        rolcolList[i].reset();
    }
}

int main()
{
    //freopen("input","r",stdin);
    int t,i,j,a;
    scanf("%d",&t);
    while(t--){
        Init();
        scanf("%d %d",&n,&m);
        //input the whole matrix
        for(i=1;i<=n;i++){
            for(j=1;j<=m;j++){
                scanf("%d",&a);
                if(a){
                    rolcolList[i][j] = 1;
                    colrolList[j][i] = 1;
                }
            }
        }
        if(Dfs(1))printf("Yes\n");
        else printf("No\n");
    }
    return 0;
}
```