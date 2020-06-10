# shell教程

## 一、字符串操作

在shell批处理程序时候,经常会涉及到字符串相关操作。有很多命令语句如:awk,sed都可以做字符串各种操作。其实shell内置一系列操作符号,可以达到类似效果,使用内部操作符会省略启动外部程序等时间,因此速度会非常的快。

### 1.1 判断读取字符串值

| 变量 | 说明 |
| :---  | :---  |
| `${var}` | 变量`var`的值,与`$var`相同 |
| `${var-DEFAULT}` | 如果`var`没有被声明,那么就以`$DEFAULT`作为其值: |
| `${var:-DEFAULT}` | 如果`var`没有被声明,或者其值为空,那么就以`$DEFAULT`作为其值 |
| `${var=DEFAULT}` | 如果`var`没有被声明,那么就以`$DEFAULT`作为其值 |
| `${var:=DEFAULT}` | 如果`var`没有被声明,或者其值为空,那么就以`$DEFAULT`作为其值 |
| `${var+OTHER}` | 如果var声明了,那么其值就是`$OTHER`,否则就为`null`字符串 |
| `${var:+OTHER}` | 如果var被设置了,那么其值就是`$OTHER`,否则就为`null`字符串 |
| `${var?ERR_MSG}` | 如果var没被声明,那么就打印`$ERR_MSG` |
| `${var:?ERR_MSG}` | 如果var没被设置,那么就打印`$ERR_MSG` |
| `${!varprefix*}` | 匹配之前所有以`varprefix`开头进行声明的变量 |
| `${!varprefix@}` | 匹配之前所有以`varprefix`开头进行声明的变量 |

### 1.2 字符串操作(长度.读取,替换)

| 变量 | 说明 |
| :---  | :---  |
| `${#string}` | `$string`的长度 |
| `${string:position}` | 在`$string`中,从位置`$position`开始提取子串 |
| `${string:position:length}` | 在`$string`中,从位置`$position`开始提取长度为`$length`的子串 |
| `${string#substring}` | 从变量`$string`的开头,删除最短匹配`$substring`的子串 |
| `${string##substring}` | 从变量`$string`的开头,删除最长匹配`$substring`的子串 |
| `${string%substring}` | 从变量`$string`的结尾,删除最短匹配`$substring`的子串 |
| `${string%%substring}` | 从变量`$string`的结尾,删除最长匹配`$substring`的子串 |
| `${string/substring/replacement}` | 使用`$replacement`,来代替第一个匹配的`$substring` |
| `${string//substring/replacement}` | 使用`$replacement`,代替所有匹配的`$substring` |
| `${string/#substring/replacement}` | 如果`$string`的前缀匹配`$substring`,那么就用`$replacement`来代替匹配到的`$substring` |
| `${string/%substring/replacement}` | 如果`$string`的后缀匹配`$substring`,那么就用`$replacement`来代替匹配到的`$substring` |

`$substring`可以是一个正则表达式.如下例子:

| 变量 | 说明 |
| :---  | ---  |
| `${var##*/}` | 从目录中提取出所需要的文件名 |
| `${var##*.}` | 从目录文件中提取文件的后缀名 |
| `${var%/*}`  | 文件路径中提取所在的目录     |

* **实例1:分割字符串**

```sh
string="hello,shell,split,test"
array=(${string//,/ })
for var in ${array[@]}
do
   echo $var
done


# method 2
# Shell脚本中有个变量叫IFS(Internal Field Seprator),内部域分隔符
string="hello,shell,split,test"
OLD_IFS="$IFS"
IFS=","
array=($string)
IFS="$OLD_IFS"
for var in ${array[@]}
do
   echo $var
done

# echo "$IFS" | od -b   // 直接输出IFS是看不到的,把它转化为二进制就可以看到了,"040"是空格,"011"是Tab,"012"是换行符"\n"
```

### 1.3 ANSI字符和控制码

#### 1.3.1 ANSI码表

![](http://images2018.cnblogs.com/blog/1222619/201803/1222619-20180311113759492-1251988758.jpg)

| `NUL` | `VT`垂直制表 | `SYN`空转同步 |
| :--- | --- | --- |
| `SOH`标题开始 | `FF`走纸控制 | `ETB`信息组传送结束 |
| `STX`正文开始 | `CR`回车    | `CAN`作废 |
| `ETX`正文结束 | `SO`移位输出  | `EM`纸尽 |
| `EOY`传输结束 | `SI`移位输入 | `SUB`换置 |
| `ENQ`询问字符 | `DLE`空格 | `ESC`换码 |
| `ACK`承认 | `DC1`设备控制1 | `FS`文字分隔符 |
| `BEL`报警 | `DC2`设备控制2 | `GS`组分隔符 |
| `BS`退一格 | `DC3`设备控制3 | `RS`记录分隔符 |
| `HT`横向列表 | `DC4`设备控制4 | `US`单元分隔符 |
| `LF`换行    | `NAK`否定 | `DEL`删除 |

```shell
echo -e '\007'
```

#### 1.3.2 C0与C1控制字符

C0与C1控制字符是[ISO/IEC 2022](https://zh.wikipedia.org/wiki/ISO/IEC_2022)定义的控制字符集。C0控制字符集的码位范围$00_{HEX}-1F_{HEX}$;C1控制字符集的码位范围$80_{HEX}-9F_{HEX}$。默认的C0控制字符集起源于[ISO 646 (ASCII)](https://zh.wikipedia.org/wiki/ISO_646)的定义。默认的C1控制字符集起源于[ECMA-48 (后为ISO 6429)](https://zh.wikipedia.org/wiki/ECMA-48)的定义。

* **C0(ASCII及其派生)**

ASCII定义了32个控制字符,再加上一个`Delete`字符。在当时(20世纪六七十年代)这么多控制字符都是需要的,因为多字节表示的控制序列要求终端机实现一个状态机,这在当时的电传或机械终端非常困难。但现在仅有少数控制字符还被使用(如空白符范畴的`BS`,`TAB`,`LF`,`VT`,`FF`,`CR`),其它一些字符无用,还有一些改变了用途(如NUL表示C语言字符串的终止)。

一些传输协议如ANPA-1312对控制字符`SOH`,`STX`,`ETX`与`EOT`做了扩展使用。其它著名的如`BEL`,`ACK`,`NAK`与`SYN`现在过时了。现代终端有很多控制符可通过多字节的ANSI转义序列(开头为`ESC`与'`[`')表示。

ASCII控制字符的标准最初定义为[ANSI X3.4](https://zh.wikipedia.org/wiki/ASCII#Control_characters)。对于ISO/IEC 2022扩展机制,称为主动的C0控制字符集,采用八进制表示`0x1B 0x21 0x40 (ESC ! @)`.

![](http://wx4.sinaimg.cn/large/006HJ6Ndly1g7xt05sa8mj31co0qak2i.jpg)

* **C1控制字符集**

当8比特ISO/IEC 8859 ASCII扩展提出后,人们认识到把最高比特去掉后可打印字符不应该变成控制字符(显然Delete字符被认为是无害的)。因此,新的标准保留了对应于C0控制字符集的32个码位但最高比特置1,作为C1控制字符集。所有C1控制字符在标准中指定了用ESC开头的7比特字符序列表示,以向后兼容比特传输。除了几乎不用的NEL,C1控制符在UTF-8中需要2字节编码。

当这些码位用于现代文档、网页、电子邮件消息等表示时,虽然表面上是用包含C1控制字符集的ISO-8859-n编码,但通常这些码位被私有、系统相关的编码方案如Windows-1252或苹果公司的Macintosh (Mac OS Roman)字符集,把C1控制符的码位用作提供额外的可打印字符。

![](http://wx3.sinaimg.cn/large/006HJ6Ndly1g7xt01j2kwj31cp0quk11.jpg)

#### 1.3.3 控制序列

控制序列,即ANSI控制码。大多数终端模拟器(Unix,Linux,Windows)都支持ANSI控制码。ANSI控制码以ESC字符(ASCII27/0x1b/033)开头,对于两个字符的ANSI控制码,第二个字符范围是ASCII64-95(`‘@’-‘_’`),然而大多数ANSI控制码都多于两个字符,并且以ESC和[开头,这时将`ESC+[`(即“`\033`[“)称为`CSI(ControlSequenceIntroducer)`,这些控制码最后一个字符范围是ASCII64-126(`‘@’-‘~’`)。还有一种单字符CSI(155/0x9B/0233),但是不如`ESC+[`用的多,而且可能不被某些设备支持。

* **非CSI序列**

部分非CSI序列:

| 序列 | 名称 | 作用
| :--- | --- | ---
| ESC c | RIS | 重绘屏幕
| ESC D | IND | 换行
| ESC E | NEL | 新的一行
| ESC H | HTS | 设置当前列为制表位
| ESC 7 | DECSC | 存储当前状态(光标坐标,属性,字符集)
| ESC 8 | DECRC | 恢复上一次储存的设置
| ESC % |   | 开始一个字符集选择序列
| ESC ( |   | 开始一个G0字符集定义序列
| ESC ) |   | 开始一个G1字符集定义序列
| ESC > | DECPNM | 设置数字小键盘模式
| ESC = | DECPAM | 设置程序键盘模式
| ESC ] | OSC | 操作系统命令

有些控制序列效果可能与单个控制字符相同。

* **CSI序列**

CSI序列由ESC [、若干个(包括0个)“参数字节”、若干个“中间字节”,以及一个“最终字节”组成。基本结构是:`CSI n1 ; n2... letter`。各部分的字符范围如下:

组成部分 | 字符范围 | ASCII
--- | --- | ---
参数字节 | 0x30–0x3F | 0–9:;<=>?
中间字节 | 0x20–0x2F | 空格、!"#$%&'()\*+,-./
最终字节 | 0x40–0x7E | @A–Z[\]^\_`a–z{|}~

所有常见的序列都只是把参数用作一系列分号分隔的数字,如1;2;3。缺少的数字视为0(如1;;3相当于中间的数字是0,ESC[m这样没有参数的情况相当于参数为0)。某些序列(如CUU)把0视为1,以使缺少参数的情况下有意义。一部分字符定义是“私有”的,以便终端制造商可以插入他们自己的序列而不与标准相冲突。包括参数字节`<=>?`的使用,或者最终字节`0x70–0x7F(p–z{|}~)`,例如`VT320`序列`CSI?25h`和`CSI?25l`的作用是打开和关闭光标的显示。

当CSI序列含有超出0x20–0x7E范围的字符时,其行为是未定义的。这些非法字符包括C0控制字符(范围0–0x1F)、DEL(0x7F),以及高位字节。

**常见的序列**

![](http://wx1.sinaimg.cn/large/006HJ6Ndly1g7xt033vqqj31co0gngrv.jpg)

**选择图形再现(SGR)参数**

代码 | 作用 | 备注
--- | --- | ---
0 | 重置/正常 | 关闭所有属性。
1 | 粗体或增加强度 |
2 | 弱化(降低强度) | 未广泛支持。
3 | 斜体 | 未广泛支持。有时视为反相显示。
4 | 下划线 |
5 | 缓慢闪烁 | 低于每分钟150次。
6 | 快速闪烁 | MS-DOSANSI.SYS；每分钟150以上；未广泛支持。
7 | 反显 | 前景色与背景色交换。
8 | 隐藏 | 未广泛支持。
9 | 划除 | 字符清晰,但标记为删除。未广泛支持。
10 | 主要(默认)字体 |
11–19 | 替代字体 | 选择替代字体`${\displaystyle n-10}$`。
20 | 尖角体 | 几乎无支持。
21 | 关闭粗体或双下划线 | 关闭粗体未广泛支持；双下划线几乎无支持。
22 | 正常颜色或强度 | 不强不弱。
23 | 非斜体、非尖角体 |
24 | 关闭下划线 | 去掉单双下划线。
25 | 关闭闪烁 |
27 | 关闭反显 |
28 | 关闭隐藏 |
29 | 关闭划除 |
30–37 | 设置前景色 | 参见下面的颜色表。
38 | 设置前景色 | 下一个参数是5;n或2;r;g;b,见下。
39 | 默认前景色 | 由具体实现定义(按照标准)。
40–47 | 设置背景色 | 参见下面的颜色表。
48 | 设置背景色 | 下一个参数是5;n或2;r;g;b,见下。
49 | 默认背景色 | 由具体实现定义(按照标准)。
51 | Framed |
52 | Encircled |
53 | 上划线 |
54 | Notframedorencircled |
55 | 关闭上划线 |
60 | 表意文字下划线或右边线 | 几乎无支持。
61 | 表意文字双下划线或双右边线
62 | 表意文字上划线或左边线
63 | 表意文字双上划线或双左边线
64 | 表意文字着重标志
65 | 表意文字属性关闭 | 重置60–64的所有效果。
90–97 | 设置明亮的前景色 | aixterm(非标准)。
100–107 | 设置明亮的背景色 | aixterm(非标准)。

**颜色**

> * **3/4位**

初始的规格只有8种颜色,只给了它们的名字。SGR参数30-37选择前景色,40-47选择背景色。相当多的终端将“粗体”(SGR代码1)实现为更明亮的颜色而不是不同的字体,从而提供了8种额外的前景色,但通常情况下并不能用于背景色,虽然有时候反显(SGR代码7)可以允许这样。例如:在白色背景上显示黑色文字使用ESC[30;47m,显示红色文字用ESC[31m,显示明亮的红色文字用ESC[1;31m。重置为默认颜色用ESC[39;49m(某些终端不支持),重置所有属性用ESC[0m。后来的终端新增了功能,可以直接用90-97和100-107指定“明亮”的颜色。

当硬件开始使用8位DAC时,多个软件为这些颜色名称分配了24位的代码。下面的图表显示了发送到DAC的一些常用硬件和软件的值。

![](http://wx3.sinaimg.cn/large/006HJ6Ndly1fzpstm0oudj30ow0bk0wg.jpg)

> * **8位**

随着256色查找表在显卡上越来越常见,相应的转义序列也增加了,以从预定义的256种颜色中选择:

```sh
ESC[ … 38;5;<n> … m选择前景色
ESC[ … 48;5;<n> … m选择背景色
  0-  7:标准颜色(同ESC [ 30–37 m)
  8- 15:高强度颜色(同ESC [ 90–97 m)
 16-231:6 × 6 × 6 立方(216色): 16 + 36 × r + 6 × g + b (0 ≤ r, g, b ≤ 5)
232-255:从黑到白的24阶灰度色
```

ITU的T.416信息技术-开放文档体系结构(ODA)和交换格式:字符内容体系结构使用“:”作为分隔符:

```
ESC[ … 38:5:<n> … m选择前景色
ESC[ … 48:5:<n> … m选择背景色
```

![](http://wx1.sinaimg.cn/large/006HJ6Ndly1fzpstlzpykj31cm06jdiz.jpg)

> * **24位**

随着16位到24位颜色的“真彩色”显卡的普及,Xterm、KDE的Konsole,以及所有基于libvte的终端(包括GNOME终端)支持了ISO-8613-3的24位前景色和背景色设置。

```sh
ESC[ … 38;2;<r>;<g>;<b> … m选择RGB前景色
ESC[ … 48;2;<r>;<g>;<b> … m选择RGB背景色
```
作为ISO/IEC国际标准8613-6采用的ITU的T.416信息技术-开放文档体系结构(ODA)和交换格式:字符内容体系结构给出了一个似乎不太受支持的替代版本:

```sh
ESC[ … 38:2:<Color-Space-ID>:<r>:<g>:<b>:<unused>:<CS tolerance>:<Color-Space: 0="CIELUV"; 1="CIELAB">m选择RGB前景色
ESC[ … 48:2:<Color-Space-ID>:<r>:<g>:<b>:<unused>:<CS tolerance>:<Color-Space: 0="CIELUV"; 1="CIELAB">m选择RGB背景色
```

请注意,这里使用了保留的“:”字符来分隔子选项,这可能是在实际实现中造成混淆的始作俑者。它还使用“3”作为第二个参数来指定使用青-品红-黄方案的方案,“4”用于青-品红-黄-黑的方案,后者使用上面标记为“unused”(“未使用”)的位置作为黑色组件。还要注意,许多识别“:”作为分隔符的实现错误地忽视了色彩空间标识符参数,并因此改变了其余部分的位置。

* **代码实例**

```
echo -ne "\033[32mtest\033[0m"                 # 显示绿色文字
echo -ne "\033[3;1H123"                        # 可以将光标移到第3行第1列处
export PS1="\[\e[34m\][\u@\h \W]\$ \[\e[0m\]"  # 修改PS1,用法稍有不同


# 显示旋转的光标,表示等待：
charset=('|' '/' '-' '\')
i=0
echo -ne "\033[?25l"
while true; do
    echo -n "${charset[((i%4))]}"
    echo -ne "\033[1D"
    ((i++))
    sleep 0.2
done

# python脚本
STYLE = {
        'fore': {'black': 30, 'red': 31, 'green': 32, 'yellow': 33,'blue': 34, 'purple': 35, 'cyan': 36, 'white': 37},
        'back': {'black': 40, 'red': 41, 'green': 42, 'yellow': 43,'blue': 44, 'purple': 45, 'cyan': 46, 'white': 47},
        'mode': {'bold': 1, 'underline': 4, 'blink': 5, 'invert': 7},
        'default': {'end': 0,}
}
def use_style(string, mode='', fore='', back=''):
    mode = '%s' % STYLE['mode'][mode] if mode in STYLE['mode'] else ''
    fore = '%s' % STYLE['fore'][fore] if fore in STYLE['fore'] else ''
    back = '%s' % STYLE['back'][back] if back in STYLE['back'] else ''
    style = ';'.join([s for s in [mode, fore, back] if s])
    style = '\033[%sm' % style if style else ''
    end = '\033[%sm' % STYLE['default']['end'] if style else ''
    return '%s%s%s' % (style, string, end)
print(use_style('Normal'))
print(use_style('Bold', mode='bold'))
print(use_style('Underline & red text', mode='underline', fore='red'))
print(use_style('Invert & green back', mode='reverse', back='green'))
print(use_style('Black text & White back', fore='black', back='white'))
```

## 二、逻辑运算
### 2.1 关于文件逻辑运算

* **关于文件和目录**

| 参数 | 说明 |
| :--- | --- |
| `-f` | 判断某普通文件是否存在 |
| `-d` | 判断某目录是否存在 |
| `-b` | 判断某文件是否块设备 |
| `-c` | 判断某文件是否字符设备 |
| `-S` | 判断某文件是否socket |
| `-L` | 判断某文件是否为符号链接 |
| `-e` | 判断某东西是否存在 |
| `-p` | 判断某文件是否为`pipe`或是`FIFO` |

* **关于文件的属性**

| 参数 | 说明 |
| :--- | --- |
| `-r` | 判断文件是否为可读的属性 |
| `-w` | 判断文件是否为可以写入的属性 |
| `-x` | 判断文件是否为可执行的属性 |
| `-s` | 判断文件是否为非空白文件 |
| `-u` | 判断文件是否具有SUID的属性 |
| `-g` | 判断文件是否具有SGID的属性 |
| `-k` | 判断文件是否具有stickybit的属性 |

* **文件之间的判断与比较**

| 参数 | 说明 |
| :--- | --- |
| `-nt` | 第一个文件比第二个文件新 |
| `-ot` | 第一个文件比第二个文件旧 |
| `-ef` | 第一个文件与第二个文件为同一个 |

* **逻辑与和或**

| 参数 | 说明 |
| :--- | --- |
| `&&/-a` | 逻辑AND |
| `||/-o` | 逻辑OR |

* **运算符号**

| 参数 | 说明 |
| :--- | --- |
| `=` | 等于应用于:整型或字符串比较如果在`[]`中,只能是字符串 |
| `!=` | 不等于应用于:整型或字符串比较如果在`[]`中,只能是字符串
| `<` | 小于应用于:整型比较在`[]`中,不能使用表示字符串
| `>` | 大于应用于:整型比较在[]中,不能使用表示字符串
| `-eq` | 等于应用于:整型比较 |
| `-ne` | 不等于应用于:整型比较 |
| `-lt` | 小于应用于:整型比较 |
| `-gt` | 大于应用于:整型比较 |
| `-le` | 小于或等于应用于:整型比较 |
| `-ge` | 大于或等于应用于:整型比较 |
| `-a` | 双方都成立(and)逻辑表达式`–a`逻辑表达式 |
| `-o` | 单方成立(or)逻辑表达式`–o`逻辑表达式 |
| `-z` | 空字符串 |
| `-n` | 非空字符串 |

**所有字符与逻辑运算符直接用“空格”分开,不能连到一起**

* **`[  ]`单双括号**


> 1. `[  ]`两个符号左右都要有空格分隔
> 2. 内部操作符与操作变量之间要有空格:如`[  “a”  =  “b”  ]`
> 3. 字符串比较中,`> <`需要写成`\> \<`进行转义
> 4. `[  ]`中字符串或者`${}`变量尽量使用`""`双引号扩住,避免值未定义引用而出错的好办法
> 5. `[  ]`中可以使用`–a –o`进行逻辑运算
> 6. `[  ]`是`bash`内置命令
> 7. `[[ ]]`两个符号左右都要有空格分隔
> 8. 内部操作符与操作变量之间要有空格:如`[[  “a” =  “b”  ]]`
> 9. 字符串比较中,可以直接使用`> <`无需转义
> 10. `[[ ]]`中字符串或者${}变量尽量如未使用`""`双引号扩住的话,会进行模式和元字符匹配
> 11. `[[]]`内部可以使用`&& ||`进行逻辑运算

```sh
# 某些例子
[  exp1  -a exp2  ] = [[  exp1 && exp2 ]] = [  exp1  ]&& [  exp2  ] = [[ exp1  ]] && [[  exp2 ]]
[  exp1  -o exp2  ] = [[  exp1 || exp2 ]] = [  exp1  ]|| [  exp2  ] = [[ exp1  ]] || [[  exp2 ]]
```

## 四、find命令

`find`命令用来在指定目录下查找文件,任何位于参数之前的字符串都将被视为欲查找的目录名。如果使用该命令时,不设置任何参数,则`find`命令将在当前目录下查找子目录与文件,并且将查找到的子目录和文件全部进行显示。

语法:

```sh
find path -option [ -print ] [ -exec -ok command ] {} ;
```

参数选项,参考[`FreeBSD Manual Pages:find`](https://www.freebsd.org/cgi/man.cgi?query=find&apropos=0&sektion=0&manpath=FreeBSD+12.0-RELEASE+and+Ports&arch=default&format=html):

| 参数 | 说明 |
| ---  | ---  |
| `-amin [-\|+]n` | 如果文件上次访问时间与开始查找的时间(四舍五入到下一整分钟)大于`n(+n)`,小于`n(-n)`或恰好在`n`分钟则为`True` |
| `-atime n[smhdw]` | 如果未指定单位,则文件访问时间在`find`查找的时间内(以24小时制四舍五入)则为`True`,如果指定的单位,则时间差异以时间单位为准,可能的时间单位如下:<br>1. `s:second`<br>2. `m:minute(60 seconds)`<br>3. `h:hour(60 minutes)`<br>4. `d:day(24 hours)`<br>5. `w:week(7 days)`<br>时间单位可以组合,比如1h30m,也可以加[-\|+]符号,+代表指定时间,-表示小于指定时间 |
| `-cmin [-\|+]n` | 如果文件上次修改时间与开始查找的时间(四舍五入到下一整分钟)大于`n(+n)`,小于`n(-n)`或恰好在n分钟则为`True` |
| `-ctime n[smhdw]` | 如果未指定单位,则文件修改时间在`find`查找的时间内(以24小时制四舍五入)则为`True`,如果指定的单位,则时间差异以时间单位为准,时间标准参考`-atime` |
| `-empty` | 如果文件或者目录为空则为`True` |
| `-exec utility [argument ...];` | 如果名为`Utility`的程序返回零作为退出状态则为`True`,可选参数可以传递给实用程序。表达式必须以分号`;`结尾。如果你从shell调用`find`,如果您需要引号,否则将其视为控制运算符。如果字符串“`{}`”出现在`Utility`名称或参数中的任何位置,它被当前文件的路径名代替,实用程序将从执行查找的目录中执行 |
| `-size [-\|+] n[ckMGTP]` | 如果文件大小(以512字节块为单位向上舍入)在find查找的文件大小范围内则为true,其中+代表大于查找的文件大小,-代表小于查找文件的大小。如果n后跟c表示文件大小以字节级别进行比较。其中文件大小缩放比例进行比较的级别有以下几种:<br>1. `k:kilobytes (1024 bytes)`<br>2. `M:megabytes(1024 kilobytes)`<br>3. `G:gigabytes(1024 megabytes)`<br>4. `T:terabytes(1024 gigabytes)`<br>5. `P:petabytes(1024 terabytes)` |
| `-type t` | 如果文件的类型是指定的类型则为`True`,文件类型如下:<br>1. `b`:块设备文件<br>2. `c`:字符设备文件<br>3. `d`:目录文件<br>4. `f`:普通文件<br>5. `l`:符号链接文件<br>6. `p`:管道文件<br>7. `s`:套接字文件 |

**实例代码:**

```sh
# 当前目录及子目录中查找所有的‘ *.log‘文件
find . -name "*.log" -print
# 删除2小时之前的文件
find . -mmin +120 -type f -name "*.log" -exec rm -rf {} \;
```

## 五、curl教程

在Linux中`curl`是一个利用URL规则在命令行下工作的文件传输工具,可以说是一款很强大的`http`命令行工具。它支持文件的上传和下载,是综合传输工具,但按传统,习惯称`curl`为下载工具。

语法：`curl [options...] url`

常见参数:

| 参数 | 说明 |
| :--- | :---: |
| `-A/--user-agent <string>` | 设置用户代理发送给服务器` |
| `-b/--cookie <name=string/file>` | `cookie`字符串或文件读取位置` |
| `-c/--cookie-jar <file>` | 操作结束后把`cookie`写入到这个文件中` |
| `-C/--continue-at <offset>` | 断点续转` |
| `-D/--dump-header <file>` | 把`header`信息写入到该文件中` |
| `-e/--referer` | 来源网址` |  |
| `-f/--fail` | 连接失败时不显示`http`错误` |
| `-o/--output` | 把输出写到该文件中` |
| `-O/--remote-name` | 把输出写到该文件中,保留远程文件的文件名` |
| `-r/--range <range>` | 检索来自`HTTP/1.1`或`FTP`服务器字节范围` |
| `-s/--silent` | 静音模式,不输出任何东西` |
| `-T/--upload-file <file>` | 上传文件` |
| `-u/--user <user[:password]>` | 设置服务器的用户和密码` |
| `-w/--write-out [format]` | 什么输出完成后` |
| `-x/--proxy <host[:port]>` | 在给定的端口上使用HTTP代理` |
| `-#/--progress-bar` | 进度条显示当前的传送状态` |
| `-a/--append` | 上传文件时,附加到目标文件 |
| `--anyauth` | 可以使用“任何”身份验证方法 |
| `--basic` |  使用HTTP基本验证 |
| `-B/--use-ascii` | 使用ASCII文本传输 |
| `-d/--data <data>` | HTTP POST方式传送数据 |
| `--data-ascii <data>` | 以ascii的方式post数据 |
| `--data-binary <data>` | 以二进制的方式post数据 |
| `--negotiate` |  使用HTTP身份验证 |
| `--digest` | 使用数字身份验证 |
| `--disable-eprt` | 禁止使用EPRT或LPRT |
| `--disable-epsv` | 禁止使用EPSV |
| `--egd-file <file>` |  为随机数据(SSL)设置EGD socket路径 |
| `--tcp-nodelay` | 使用TCP_NODELAY选项 |
| `-E/--cert <cert[:passwd]>` | 客户端证书文件和密码 (SSL) |
| `--cert-type <type>` |  证书文件类型(DER/PEM/ENG) (SSL) |
| `--key <key>` |  私钥文件名 (SSL) |
| `--key-type <type>` |  私钥文件类型(DER/PEM/ENG) (SSL) |
| `--pass <pass>` | 私钥密码(SSL) |
| `--engine <eng>` | 加密引擎使用(SSL). "--engine list" for list |
| `--cacert <file>` | CA证书 (SSL) |
| `--capath <directory>` | (made using c_rehash) to verify peer against (SSL) |
| `--ciphers <list>` | SSL密码 |
| `--compressed` |  要求返回是压缩的形势 (using deflate or gzip) |
| `--connect-timeout <seconds>` | 设置最大请求时间 |
| `--create-dirs` | 建立本地目录的目录层次结构 |
| `--crlf` |  上传是把LF转变成CRLF |
| `--ftp-create-dirs` |  如果远程目录不存在,创建远程目录 |
| `--ftp-method [multicwd/nocwd/singlecwd]` | 控制CWD的使用 |
| `--ftp-pasv` | 使用 PASV/EPSV 代替端口 |
| `--ftp-skip-pasv-ip` |  使用PASV的时候,忽略该IP地址 |
| `--ftp-ssl` | 尝试用 SSL/TLS 来进行ftp数据传输 |
| `--ftp-ssl-reqd` | 要求用 SSL/TLS 来进行ftp数据传输 |
| `-F/--form <name=content>` |  模拟http表单提交数据 |
| `-form-string <name=string>` | 模拟http表单提交数据 |
| `-g/--globoff` |  禁用网址序列和范围使用{}和[] |
| `-G/--get` | 以get的方式来发送数据 |
| `-h/--help` | 帮助 |
| `-H/--header <line>` |  自定义头信息传递给服务器 |
| `--ignore-content-length` |  忽略的HTTP头信息的长度 |
| `-i/--include` |  输出时包括protocol头信息 |
| `-I/--head` | 只显示文档信息 |
| `-j/--junk-session-cookies` | 读取文件时忽略session cookie |
| `--interface <interface>` |  使用指定网络接口/地址 |
| `--krb4 <level>` | 使用指定安全级别的krb4 |
| `-k/--insecure` | 允许不使用证书到SSL站点 |
| `-K/--config` |  指定的配置文件读取 |
| `-l/--list-only` | 列出ftp目录下的文件名称 |
| `--limit-rate <rate>` | 设置传输速度 |
| `--local-port<NUM>` |  强制使用本地端口号 |
| `-m/--max-time <seconds>` |  设置最大传输时间 |
| `--max-redirs <num>` |  设置最大读取的目录数 |
| `--max-filesize <bytes>` | 设置最大下载的文件总量 |
| `-M/--manual` |  显示全手动 |
| `-n/--netrc` | 从netrc文件中读取用户名和密码 |
| `--netrc-optional` | 使用`.netrc`或者`URL`来覆盖-n |
| `--ntlm` |  使用HTTP NTLM身份验证 |
| `-N/--no-buffer` | 禁用缓冲输出 |
| `-p/--proxytunnel` | 使用HTTP代理 |
| `--proxy-anyauth` | 选择任一代理身份验证方法 |
| `--proxy-basic` | 在代理上使用基本身份验证 |
| `--proxy-digest` | 在代理上使用数字身份验证 |
| `--proxy-ntlm` |  在代理上使用ntlm身份验证 |
| `-P/--ftp-port <address>` |  使用端口地址,而不是使用PASV |
| `-Q/--quote <cmd>` | 文件传输前,发送命令到服务器 |
| `--range-file` |  读取(SSL)的随机文件 |
| `-R/--remote-time` | 在本地生成文件时,保留远程文件时间 |
| `--retry <num>` | 传输出现问题时,重试的次数 |
| `--retry-delay <seconds>` | 传输出现问题时,设置重试间隔时间 |
| `--retry-max-time <seconds>` | 传输出现问题时,设置最大重试时间 |
| `-S/--show-error` | 显示错误` |
| `--socks4 <host[:port]>` | 用`socks4`代理给定主机和端口 |
| `--socks5 <host[:port]>` | 用`socks5`代理给定主机和端口 |
| `-t/--telnet-option <OPT=val>` | `Telnet`选项设置 |
| `--trace <file>` | 对指定文件进行`debug` |
| `--trace-ascii <file>` | Like--跟踪但没有hex输出 |
| `--trace-time` | 跟踪/详细输出时,添加时间戳` |
| `--url <URL>` | Spet URL to work with` |
| `-U/--proxy-user <user[:password]>` | 设置代理用户名和密码 |
| `-V/--version` | 显示版本信息 |
| `-X/--request <command>` | 指定什么命令 |
| `-y/--speed-time` | 放弃限速所要的时间,默认为30 |
| `-Y/--speed-limit` | 停止传输速度的限制,速度时间为秒 |
| `-z/--time-cond` | 传送时间设置 |
| `-0/--http1.0` |  使用HTTP 1.0 |
| `-1/--tlsv1` | 使用`TLSv1(SSL)` |
| `-2/--sslv2` | 使用`SSLv2`的`(SSL)` |
| `-3/--sslv3` | 使用的`SSLv3(SSL)` |
| `--3p-quote` | like -Q for the source URL for 3rd party transfer |
| `--3p-url` | 使用`url`,进行第三方传送 |
| `--3p-user` | 使用用户名和密码,进行第三方传送 |
| `-4/--ipv4` | 使用IP4 |
| `-6/--ipv6` | 使用IP6 |


**某些例子**

```sh
# 基本用法
curl http://www.linux.com
# 执行后,www.linux.com的html就会显示在屏幕上了

# 保存访问的网页
## 使用linux的重定向功能保存
curl http://www.linux.com >> linux.html
## 可以使用curl的内置option:-o(小写)保存网页
curl -o linux.html http://www.linux.com
# 执行完成后会显示如下界面,显示100%则表示保存成功
% Total    % Received % Xferd  Average Speed  Time    Time    Time  Current
                                Dload  Upload  Total  Spent    Left  Speed
100 79684    0 79684    0    0  3437k      0 --:--:-- --:--:-- --:--:-- 7781k
## 可以使用curl的内置option:-O(大写)保存网页中的文件,要注意这里后面的url要具体到某个文件,不然抓不下来
curl -O http://www.linux.com/hello.sh

# 测试网页返回值
curl -o /dev/null -s -w %{http_code} www.linux.com # 在脚本中,这是很常见的测试网站是否正常的用法

# 指定proxy服务器以及其端口
curl -x 192.168.100.100:1080 http://www.linux.com

# cookie,有些网站是使用cookie来记录session信息,对于chrome这样的浏览器,可以轻易处理cookie信息,但在curl中只要增加相关参数也是可以很容易的处理cookie
## 保存http的response里面的cookie信息,内置option:-c(小写)
curl -c cookiec.txt  http://www.linux.com # 执行后cookie信息就被存到了cookiec.txt里面了
## 保存http的response里面的header信息。内置option: -D
curl -D cookied.txt http://www.linux.com # 执行后cookie信息就被存到了cookied.txt里面了
## 注意:-c(小写)产生的cookie和-D里面的cookie是不一样的。

# 使用cookie,很多网站都是通过监视你的cookie信息来判断你是否按规矩访问他们的网站的,因此我们需要使用保存的cookie信息。内置option: -b
curl -b cookiec.txt http://www.linux.com

# 模仿浏览器,有些网站需要使用特定的浏览器去访问他们,有些还需要使用某些特定的版本。curl内置option:-A可以让我们指定浏览器去访问网站
curl -A "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.0)" http://www.linux.com  # 这样服务器端就会认为是使用IE8.0去访问的

# 伪造referer(盗链),很多服务器会检查http访问的referer从而来控制访问。比如:你是先访问首页，然后再访问首页中的邮箱页面,这里访问邮箱的referer地址就是访问首页成功后的页面地址,如果服务器发现对邮箱页面访问的referer地址不是首页的地址,就断定那是个盗连了
## curl中内置option：-e可以让我们设定referer
curl -e "www.linux.com" http://mail.linux.com   # 这样就会让服务器其以为你是从www.linux.com点击某个链接过来的

# 下载文件
## 利用curl下载文件,使用内置option：-o(小写)
curl -o dodo1.jpg http:www.linux.com/dodo1.JPG
## 使用内置option:-O(大写)
curl -O http://www.linux.com/dodo1.JPG


# 循环下载,有时候下载图片可以能是前面的部分名称是一样的,就最后的尾椎名不一样
curl -O http://www.linux.com/dodo[1-5].JPG  # 这样就会把dodo1,dodo2,dodo3,dodo4,dodo5全部保存下来

# 下载重命名
curl -O http://www.linux.com/{hello,bb}/dodo[1-5].JPG
### 由于下载的hello与bb中的文件名都是dodo1,dodo2,dodo3,dodo4,dodo5。因此第二次下载的会把第一次下载的覆盖,这样就需要对文件进行重命名。
curl -o #1_#2.JPG http://www.linux.com/{hello,bb}/dodo[1-5].JPG
### 这样在hello/dodo1.JPG的文件下载下来就会变成hello_dodo1.JPG,其他文件依此类推,从而有效的避免了文件被覆盖

# 分块下载,有时候下载的东西会比较大,这个时候我们可以分段下载。使用内置option:-r

curl -r 0-100 -o dodo1_part1.JPG http://www.linux.com/dodo1.JPG
curl -r 100-200 -o dodo1_part2.JPG http://www.linux.com/dodo1.JPG
curl -r 200- -o dodo1_part3.JPG http://www.linux.com/dodo1.JPG
cat dodo1_part* > dodo1.JPG
### 这样就可以查看dodo1.JPG的内容了

# 通过ftp下载文件,curl可以通过ftp下载文件,curl提供两种从ftp中下载的语法
curl -O -u 用户名:密码 ftp://www.linux.com/dodo1.JPG
curl -O ftp://用户名:密码@www.linux.com/dodo1.JPG

# 显示下载进度条
curl -# -O http://www.linux.com/dodo1.JPG

# 不会显示下载进度信息
curl -s -O http://www.linux.com/dodo1.JPG

# 断点续传
# 在windows中,我们可以使用迅雷这样的软件进行断点续传。curl可以通过内置option:-C同样可以达到相同的效果,如果在下载dodo1.JPG的过程中突然掉线了,可以使用以下的方式续传
curl -C -O http://www.linux.com/dodo1.JPG

# 上传文件,curl不仅仅可以下载文件,还可以上传文件。通过内置option:-T来实现
curl -T dodo1.JPG -u 用户名:密码 ftp://www.linux.com/img/  # 这样就向ftp服务器上传了文件dodo1.JPG

# 显示抓取错误
curl -f http://www.linux.com/error

# 指定HTTP请求的方法。
curl -X POST https://www.example.com

# 输出通信的整个过程,用于调试
curl -v https://www.example.com
curl --trace - https://www.example.com
```