# Hiho第102周:搜索五·数独

## 题目描述

在上一次学会了跳舞链的搜索方法之后,小Ho觉得这个算法真是棒极了。

小Ho:小Hi,还有没有什么有意思的题目可以用跳舞链解决的啊？

小Hi:我想想,首先可以确定的是给出01矩阵的精确覆盖问题都可以解决。

小Ho:嗯,我觉得如果一个问题能够通过模型转换成01矩阵，应该都可以用跳舞链解决吧。

小Hi:是的,那么小Ho,你觉得数独问题能用跳舞链解决么？

小Ho:数独是啥？

小Hi:小Ho,你居然不知道数独?

小Ho:我有听过,但是没有实际去做过。

小Hi:这样啊,那我就简单给你讲一讲。数独问题就是给定一个9x9的矩阵。然后将1~9填入当中,比如下面这个:

![](http://media.hihocoder.com/problem_images/20160611/14656297993791.jpg)

其中有些格子已经填好了,有些格子则需要你填进去。

对于填好后的格子,需要满足3个条件:

```
每一个数字在每一行只能出现1次
每一个数字在每一列只能出现1次
每一个数字在每一个九宫区域内只能出现1次,上图中每一个粗线包围的区域就是一个九宫。
```

小Ho:规则看上去还是蛮简单的嘛。

小Hi:对啊。那么你觉得这个问题可以用跳舞链解决么?

小Ho:嗯,我想一想啊。

### 提示:数独

小Ho:不行不行,我觉得搞不定啊!

小Hi:什么搞不定?你先说说你的想法?

小Ho:我是这样想的,要用跳舞链来解决数独问题,那就要求把数独问题转化为01的矩阵。我们之前遇到的问题是,一个格子只存在覆盖或是不覆盖的情况。而数独这个问题里面,一个位置是从数字当中选择一个。这样我就没有办法去覆盖一个解了。

小Hi:你说的没错。

小Ho:那应该怎么办啊？

小Hi:小Ho,其实你陷入了一个很大的误区。

小Ho:什么?

小Hi:对于精确覆盖问题的01矩阵,其实它的含义是这样:

```
列:一个原问题的约束条件
行:一个方案所满足的约束条件
```

在我们之前的问题中,一个问题的约束条件就是每一列是否被覆盖到,因此约束条件的数量也就和列的数量相同了。

而对于数独来说,其约束条件并不是列的数量。

根据数独游戏的规则,我们要满足的约束条件有四个:

每一个数字在每一行只能出现1次。由于行和数字的互相匹配,因此一共会产生9x9,81个约束条件:

```
 1. 第1行存在数字1
 2. 第1行存在数字2
 3. 第1行存在数字3
    ...
 9. 第1行存在数字9
10. 第2行存在数字1
11. 第2行存在数字2
    ...
18. 第2行存在数字9
19. 第3行存在数字1
    ...
80. 第9行存在数字8
81. 第9行存在数字9
```

对于第i行第j列填写数字k时,其对应的序号为(i-1)*9+k,每一个数字在每一列只能出现1次。


由于列和数字的互相匹配,因此一共会产生9x9,81个约束条件:

```
 82. 第1列存在数字1
 83. 第1列存在数字2
 84. 第1列存在数字3
    ...
 90. 第1列存在数字9
 91. 第2列存在数字1
 92. 第2列存在数字2
    ...
 99. 第2列存在数字9
100. 第3列存在数字1
    ...
161. 第9列存在数字8
162. 第9列存在数字9
```

对于第i行第j列填写数字k时,其对应的序号为81+(j-1)*9+k,每一个数字在每一个九宫只能出现1次。

由于九宫和数字的互相匹配,因此一共会产生9x9,81个约束条件:

```
163. 第1个九宫存在数字1
164. 第1个九宫存在数字2
165. 第1个九宫存在数字3
    ...
171. 第1个九宫存在数字9
172. 第2个九宫存在数字1
173. 第2个九宫存在数字2
    ...
180. 第2个九宫存在数字9
181. 第3个九宫存在数字1
    ...
242. 第9个九宫存在数字8
243. 第9个九宫存在数字9
```

对于第i行第j列填写数字k时,位于第t个九宫,其对应的序号为162+(t-1)*9+k,每一个格子只能填一个数字。

由于一共有81个格子，所以也是81个约束条件:

```
244. 第1行第1列填写了数字
245. 第1行第2列填写了数字
246. 第1行第3列填写了数字
    ...
252. 第1行第9列填写了数字
253. 第2行第1列填写了数字
254. 第2行第2列填写了数字
    ...
261. 第2行第9列填写了数字
262. 第3行第1列填写了数字
    ...
323. 第9行第8列填写了数字
324. 第9行第9列填写了数字
```

对于第i行第j列填写数字k时,其对应的序号为243+(i-1)*9+j,总共有324个约束条件,也就是说对于数独游戏来说,对应的01矩阵有324列。

对于我们填写好的答案,一定会满足这全部324个约束条件。

那么再来看看方案的数量,这里有两种情况:

```
board[i][j] = 0:即第i行第j列为空格,因此我们可以将1-9中的数字填入,会产生9个不同的方案。
board[i][j] ≠ 0:即第i行第j列已经填了数字,所以这个地方只有1种方案。
```

那么小Ho,数独问题最多会有多少个方案呢?

小Ho:每一个格子可能填1-9这9个数字,一共有81个格子,所以总共是729个方案。

小Hi:对,由此可以得到数独问题的01矩阵有729行。

最后一步,就是来生成方案所覆盖的约束条件:

假设有方案在第i行第j列填写了数字k,其中第i行第j列是属于第t个九宫的格子。则其对应的约束条件为：

```
满足了第i行存在数字k。
满足了第j列存在数字k。
满足了第t个九宫存在数字k。
满足了第i行第j列填写有数字。
```

由此也可以看出,每一个方案恰好对应了4个约束条件。满足324个约束条件一共需要81个方案,也正好对应了数独游戏一共有81个格子的规则。

至此,我们也就构造出了生成数独游戏01矩阵的方法,其伪代码为:

```c++
set(i, j, k):
    id = (i - 1) * 9 + j // 表示第i行第j列格子的编号
    pid = (id - 1) * 9 + k // 表示该格子填写k所对应的方案编号
    // 约束条件1 - 对应第1~81列
    // 第(i-1)*9+k列表示第i行存在数字k
    matrix[ pid ][(i - 1) * 9 + k] = 1
    
    // 约束条件2 - 对应第82~162列
    // 第81+(j-1)*9+k列表示第j列存在数字k
    matrix[ pid ][81 + (j - 1) * 9 + k] = 1
    
    // 约束条件3 - 对应第163~243列
    // 第162+(t-1)*9+k列表示第t个九宫存在数字k
    t = ((i - 1) / 3 * 3 + (j - 1) / 3) + 1
    matrix[ pid ][162 + (t - 1) * 9 + k] = 1
    
    // 约束条件4 - 对应第244~324列
    // 第243+id列表示第i行第j列填写有数字
    matrix[ pid ][243 + id] = 1
    
create(board):
    matrix = [] // 设置01矩阵为729*324的矩阵，初始化为全0
    For i = 1 .. 9
        For j = 1 .. 9
            If (board[i][j] == 0) Then
                For k = 1 .. 9  // 枚举可能填写的9个数字
                    set(i, j, k)
                End For
            Else
                set(i, j, board[i][j])
            End If
        End For
    End For
```

之后的工作只需要将这个矩阵用跳舞链跑一次就可以了!最后根据答案栈中的行数还原出对应的位置和数字,就得到了数独的解。

小Ho:好,让我试试!

小Hi:小Ho,你先别着急。对于数独问题来说,直接使用跳舞链可能会导致超时,因此还有一个可以用到的优化。

小Ho:什么优化啊?

小Hi:这个优化需要改变我们的搜索顺序。每次都选择元素最少的那一列进行搜索,而不是每次都搜素head节点右边的节点。

额外增加一个cnt数组来记录每一列除了头结点外的节点个数。同时需要修改原来的跳舞链函数:

build函数中纵向增加节点的部分:

```c++
For j = 1 .. m
    pre = columnHead[j]
    For i = 1 .. n
        If (board[i][j] == 1) Then
            cnt[j] = cnt[j] + 1 // 计数器增加
            p = node[ id[i][j] ]
            p.down = pre.down
            p.up = pre
            pre.down.up = p
            pre.down = p
            pre = p
        End If
    End For
End For
```

remove函数中需要修改对应列的计数:

```c++
While (p2 != p) 
    // 获取该列下的每一个节点p2
    p3 = p2.right 
    While (p3 != p2)
        // 获取节点p2所在行的其他节点p3
        p3.down.up = p3.up
        p3.up.down = p3.down
        cnt[ p3.y ] = cnt[ p3.y ] - 1 // 计数器减少
        p3 = p3.right
    End While
    p2 = p2.down
End While
```

resume函数中需要修改对应列的计数:

```c++
While (p2 != p) 
    // 获取该列下的每一个节点p2
    p3 = p2.right 
    While (p3 != p2)
        // 获取节点p2所在行的其他节点p3
        p3.down.up = p3
        p3.up.down = p3
        cnt[ p3.y ] = cnt[ p3.y ] + 1 // 计数器增加
        p3 = p3.right
    End While
    p2 = p2.down
End While
```

dance函数中需要去查找cnt最小的列：

```c++
dance(depth):
    If (head.right == head) Then
        // 若head的右边就是head自己，则已经找到解
        Return True;
    End If
    p = findMinCnt(head)    // 从head右边的所有节点中找到cnt最小的
    p2 = p.down
    If (p2 == p) Then
        // 当前列没有节点，则当前列一定不会被覆盖
        Return false
    End If 
    
    ...
    
    ans[(p2.x - 1) / 81 + 1][((p2.x - 1) / 9) % 9 + 1] = (p2.x - 1) % 9 + 1
    
    ...
```

小Ho:我知道了!我这加上这个优化。

## 输入输出

* **输入**

第1行:1个正整数t,表示数据组数,2≤t≤5

接下来t组数据,每组按照如下格式给出:

第1..9行：9个整数,可能包含0~9。0表示该格未填写数字,其他数字表示该格已经填写有该数字。

* **输出**

与输入数据相对应的t组输出数据:

第1..9行:9个整数,表示第i组数据完成后的状态,满足数独的要求,保证每组数据有且仅有一组合法解。

样例输入

```
1
4 0 0 0 7 0 1 0 0
0 0 1 9 0 4 6 0 5
0 0 0 0 0 1 0 0 0
0 0 0 7 0 0 0 0 2
0 0 2 0 3 0 0 0 0
8 4 7 0 0 6 0 0 0
0 1 4 0 0 0 8 0 6
0 2 0 0 0 0 3 0 0
6 0 0 0 9 0 0 0 0
```

样例输出

```
4 9 6 5 7 3 1 2 8
3 8 1 9 2 4 6 7 5
2 7 5 8 6 1 9 4 3
1 5 3 7 8 9 4 6 2
9 6 2 4 3 5 7 8 1
8 4 7 2 1 6 5 3 9
7 1 4 3 5 2 8 9 6
5 2 9 6 4 8 3 1 7
6 3 8 1 9 7 2 5 4
```

## 解题代码

```c++
#include <iostream>
#include <cstdio>
#include <cstring>
#include <cmath>
#include <queue>
using namespace std;

struct Node {
    int x, y, v;
    Node *up, *down, *left, *right;
} node[240000]; // 729行,324列的01精确覆盖问题

struct HeadCnt {
    int y, cnt;
    bool operator < (const HeadCnt& x) const {
        return x.cnt < cnt;
    }
} headCnt[325];

int Index;
int ans[100];
int ansIndex;
int mash[10][10];

void removeCol(int col) {
    Node *p = &node[col];
    p->right->left = p->left;
    p->left->right = p->right;
    Node *p2 = p->down;
    while (p != p2) {
        Node *p3 = p2->right;
        while (p2 != p3) {
            headCnt[p3->y].cnt--;
            p3->down->up = p3->up;
            p3->up->down = p3->down;
            p3 = p3->right;
        }
        p2 = p2->down;
    }
}
void recoverCol(int col) {
    Node *p = &node[col];
    p->right->left = p;
    p->left->right = p;
    Node *p2 = p->down;
    while (p != p2) {
        Node *p3 = p2->right;
        while (p2 != p3) {
            headCnt[p3->y].cnt++;
            p3->down->up = p3;
            p3->up->down = p3;
            p3 = p3->right;
        }
        p2 = p2->down;
    }
}

int minHeadCnt() {
    int Min = 0x7fffffff, index = 1;
    Node *p = node->right;
    while (p != node) {
        if (Min > headCnt[p->y].cnt) {
            Min = headCnt[p->y].cnt;
            index = p->y;
        }
        p = p->right;
    }
    return index;
}

bool dfs(int colDepth) {
    if (node[0].right == &node[0]) {
        return true;
    }
    int in = minHeadCnt();
    Node *p = &node[in];
    
    if (p == p->down) {
        return false;
    }
    removeCol(p->y);
    Node *p2 = p->down;
    while (p != p2) {
        ans[ansIndex] = p2->v;
        ansIndex++;
        
        Node *p3 = p2->right;
        while (p2 != p3) {
            removeCol(p3->y);
            p3 = p3->right;
        }
        if(dfs(colDepth + 1)) {
            return true;
        }
        
        ansIndex--;
        p3 = p2->right;
        while (p2 != p3) {
            recoverCol(p3->y);
            p3 = p3->right;
        }
        p2 = p2->down;
    }
    recoverCol(p->y);
    return false;
}

void addNode (int i, int j, int value) {
    headCnt[j].cnt++;
    Node *lastP = node[j].up;
    
    lastP->down->up = &node[Index + 1];
    node[Index + 1].down = lastP->down;
    lastP->down = &node[Index + 1];
    node[Index + 1].up = lastP;
    
    if (node[Index].x != i) {
        node[Index + 1].left = node[Index + 1].right = &node[Index + 1];
    } else {
        node[Index].right->left = &node[Index+1];
        node[Index + 1].right = node[Index].right;
        node[Index].right = &node[Index+1];
        node[Index + 1].left = &node[Index];
    }
    Index++;
    node[Index].x = i, node[Index].y = j, node[Index].v = value;
}

void setPlane (int x, int y, int v) {
    int i = ((x - 1) * 9 + (y - 1)) * 9 + v;
    int value = x * 100 + y * 10 + v;
    addNode(i, (x - 1) * 9 + v, value);
    addNode(i, 81 + (y - 1) * 9 + v, value);
    int index9 = (x - 1) / 3 * 3 + (y - 1) / 3;
    addNode(i, 162 + index9 * 9 + v, value);
    addNode(i, 243 + (x - 1) * 9 + y, value);
}

int main () {
    int T, tmp;
    scanf("%d", &T);
    while (T--) {
        Index = 0, ansIndex = 0;
        node[0].x = 0, node[0].y = 0;
        node[0].up = node[0].down = node[0].left = node[0].right = &node[0];
        
        for (int j = 1; j <= 324; j++) {
            node[Index].right->left = &node[Index+1];
            node[Index].right = &node[Index+1];
            Index++;
            node[Index].left = &node[Index - 1];
            node[Index].right = &node[0];
            node[Index].x = 0, node[Index].y = j;
            node[Index].up = node[Index].down = &node[Index];
            headCnt[j].y = j, headCnt[j].cnt = 0;
        }
        for (int i = 1; i <= 9; i++) {
            for (int j = 1; j <= 9; j++) {
                scanf("%d", &tmp);
                mash[i][j] = tmp;
                if (tmp != 0) {
                    setPlane(i, j, tmp);
                } else {
                    for (int cnt = 1; cnt <= 9; cnt++) {
                        setPlane(i, j, cnt);
                    }
                }
            }
        }
        
        if(dfs(0)){
            for (int i = 0; i < ansIndex; i++) {
                mash[ans[i] / 100][(ans[i] % 100) / 10] = ans[i] % 10;
            }
            for (int i = 1; i <= 9; i++) {
                for (int j = 1 ; j <= 9; j++) {
                    printf("%d", mash[i][j]);
                    if (j != 9) {
                        printf(" ");
                    }
                }
                puts("");
            }
        } else {
            puts("No");
        }
    }
    return 0;
}
```