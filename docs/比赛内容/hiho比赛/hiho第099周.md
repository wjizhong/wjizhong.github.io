# hiho第099周:搜索二·骑士问题

* **描述**

小Hi:小Ho你会下国际象棋么?

小Ho:应该算会吧,我知道每个棋子的移动方式,马走日象飞田什么的...

小Hi:象飞田那是中国象棋啦!

小Ho:哦,对。国际象棋好像是走斜线来着。

小Hi:不过马走日倒是对了。国际象棋中的马一般叫做骑士,关于它有个很有意思的问题。

小Ho:什么啊?

小Hi:骑士巡游问题,简单来说就是关于在棋盘上放置若干个骑士,然后探究移动这些骑士是否能满足一定的而要求。举个例子啊:一个骑士从起始点开始,能否经过棋盘上所有的格子再回到起点。

小Ho:哦,看上去好像很难的样子。

小Hi:其实也还好了。简单一点的比如棋盘上有3个骑士,能否通过若干次移动走到一起。

小Ho:能够么?

小Hi:当然能够了。由于骑士特殊的移动方式,放置在任何一个初始位置的骑士,都可以通过若干次移动到达棋盘上任意一个位置。

小Ho:那么只要选定一个位置,把它们全部移动过去就好了是吧?

小Hi:是的,那么这里又有另一个问题了:要选择哪一个位置汇合,使得3个骑士行动的总次数最少?

小Ho:嗯,这个好像不是很难,让我想一想。

> * **提示:骑士问题**

小Ho:小Hi你刚刚说到了这样一点:放置在任何一个初始位置的骑士,都可以通过若干次移动到达棋盘上任意一个位置。

那么我就可以把整个局面分开来做:我先计算出每一个骑士到达棋盘上每个位置的最短距离;再枚举每一个位置,表示将三个骑士在这个位置上汇合,累加这三个骑士到达的步数之和;最后选择一个最小的和作为解。

求解骑士到达每一个位置最少步数时,我可以使用之前讲过的宽度优先搜索。从而保证我第一次枚举到这个位置时就是最少的步数。

那么整个流程就是:

```c++
bfs_solve(f, x, y):
	f[][] = -1	// 初始化为-1
	f[x][y] = 0	// 起始点
	queue.push( (x,y) ) // 将初始点加入队列中
	while (!queue.isEmpty())
		(now_x, now_y) = queue.pop()	// 弹出队列头元素
		For i = 1 .. 8
			// 枚举8种可能的移动
			(next_x, next_y) = move(now_x, now_y, i)
			If ((next_x, next_y) in chessboard AND f[next_x][next_y] equal -1)
				f[next_x][next_y] = f[now_x][now_y] + 1
				queue.push( (next_x, next_y) )
			End If
		End For
	End While

For i = 1 .. 3
	// 通过bfs求解
	// step[i][x][y]表示第i个骑士移动到(x,y)的最少步数
	bfs_solve(step[i][][], initialX[i], initialY[i])
End 
ans = Infinite
For x = A .. H
	For y = 1 .. 8
		If (ans > sigma(step[][x][y])) Then
			ans = sigma(step[][x][y])
		End If
	End For
End For
```

小Hi:小Ho挺厉害的嘛,这样的确把问题解决了。不过我这里还有另一种方法,虽然同样是通过宽度优先搜索来搜索最少步数，但是我将三个骑士的位置看做了一个整体。

由于每一个骑士的位置都是由2个坐标来决定,这俩个坐标恰好可以对应一个2位的八进制数。若我把3个坐标合起来,就可以用一个6位的八进制数来表示。比如"B2 D3 F4",就表示为"113253"。

由此可以通过一个大小为8^6的布尔数组来进行状态的判重。而每一次的状态转移也从原来的仅枚举8个方向,变成了枚举骑士加枚举方向,一共有3*8=24种可能。

此方法的伪代码为:

```c++
queue.push( initialStatus ) // 将初始的8进制数加入队列中
while (!queue.isEmpty())
	now_status = queue.pop()	// 弹出队列头元素
	For i = 1 .. 3
	// 枚举移动的其实
		For j = 1 .. 8
		// 枚举8种可能的移动
		next_status = move(now_status, i, j)	// 移动骑士并记录状态	
		If (next_status is valid AND not visited[ next_status ])
			step[ next_status ] = step[ now_status ] + 1
			queue.push( next_status )
			If (check(next_status)) Then
				// 检查这个八进制数是否满足3个坐标重合
				Return step[ next_status ]
			End If 
		End If
	End For
End While
```

在进行检查是否已经走到一起时,可以通过一个位运算来做:

```c++
check(status):
	Return ((status and 0x3f) == ((status rsh 6) and 0x3f)) and (((status rsh 6) and 0x3f) == ((status rsh 12) and 0x3f))
	// rsh表示右移操作
```

小Ho:哦,这样就可以不用计算出每个骑士走到每个点的步数,而是在过程中就有可能直接求解到最先汇合位置的步数。

小Hi:对,不过这个算法中状态的转移会稍微复杂一点。你可以选择一个你比较喜欢的方法来实现。

小Ho:好!

* **输入输出**

> * **输入**

第1行:1个正整数t,表示数据组数,2≤t≤10。

第2..t+1行:用空格隔开的3个坐标,每个坐标由2个字符AB组成,A为'A'~'H'的大写字母,B为'1'~'8'的数字，表示3个棋子的初始位置。

> * **输出**

第1..t行:每行1个数字,第i行表示第i组数据中3个棋子移动到同一格的最小行动步数。

样例输入

```
2
A1 A1 A1
B2 D3 F4
```

样例输出

```
0
2
```

* **解题代码**

`c++`代码:

```c++
#include<iostream>
#include<stdio.h>
#include<string.h>
#include<string>
#include<queue>
using namespace std;
const int SIZE = 10;

int dis[SIZE][SIZE][3];

struct point{
    int x;
    int y;
    point(int _x, int _y) :x(_x), y(_y){};
};

void bfs(int x, int y, int n) {
    queue<point> Queue;
    Queue.push(point(x, y));
    dis[x][y][n] = 0;
    //开始广搜
    int row[8] = { 1, 1, -1, -1, 2, 2, -2, -2 };
    int col[8] = { 2, -2, 2, -2, 1, -1, 1, -1 };
    while (!Queue.empty()) {
        point p = Queue.front();
        Queue.pop();
        int x = p.x;
        int y = p.y;
        int d = dis[x][y][n];
        for (int i = 0; i<8; i++) {
            int tx = x + row[i];
            int ty = y + col[i];
            if (tx<0 || ty<0 || tx >= 8 || ty >= 8 || dis[tx][ty][n]>=0)
                continue;
            dis[tx][ty][n] = d + 1;
            Queue.push(point(tx, ty));
        }
    }
}

int main() {
    int T;
    scanf("%d", &T);
    while (T--) {
        memset(dis, -1, sizeof(dis));
        for (int i = 0; i<3; i++) {
            char node[10];
            scanf("%s", node);
            int x = node[0] - 'A';
            int y = node[1] - '1';
            bfs(x, y, i);
        }
        int x = -1, y = -1, min = 10000000;
        for (int i = 0; i<8; i++) {
            for (int j = 0; j<8; j++) {
                int sum = dis[i][j][0] + dis[i][j][1] + dis[i][j][2];
                if (sum<min) {
                    min = sum;
                    x = i;
                    y = j;
                }
            }
        }
        printf("%d\n", min);
    }
    return 0;
}
```

`python`代码:

```python
def chk(s): return s[0] == s[1] == s[2]
def move(s):
    for i in [(1,2),(2,1)]:
        for j in [(1,1),(1,-1),(-1,-1),(-1,1)]:
            for k in range(3):
                v = s[k][0] + i[0] * j[0], s[k][1] + i[1] * j[1]
                if v[0] < 0 or v[0] >= 8 or v[1] < 0 or v[1] >= 8: continue
                t = list(s)
                t[k] = v
                yield tuple(t)
def solve(s):
    if chk(s): return 0
    d = {s:0}
    q = [s]
    while len(q):
        u = q.pop()
        for i in move(u):
            if i in d: continue
            d[i] = d[u] + 1
            if chk(i): return d[i]
            q.insert(0, i)
for c in range(input()):
    s = tuple(((ord(i[0]) - ord('A')), ord(i[1]) - ord('1')) for i in raw_input().split())
    print solve(s)
```