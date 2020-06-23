# python模块
## 一、模块打包

### 1.1 setup.py编写指南

python有非常丰富的第三方库可以使用,很多开发者会向pypi上提交自己的python包。要想向pypi包仓库提交自己开发的包,首先要将自己的代码打包,才能上传分发。

* **distutils简介**

distutils是标准库中负责建立python第三方库的安装器,使用它能够进行python模块的安装和发布。distutils对于简单的分发很有用,但功能缺少。大部分python用户会使用更先进的setuptools模块。

* **setuptools简介**

setuptools是distutils增强版,不包括在标准库中。其扩展了很多功能,能够帮助开发者更好的创建和分发python包。大部分python用户都会使用更先进的setuptools模块。

Setuptools有一个fork分支是distribute。它们共享相同的命名空间,因此如果安装了distribute,import setuptools时实际上将导入使用distribute创建的包。Distribute已经合并回setuptools。

还有一个大包分发工具是distutils2,其试图尝试充分利用distutils,detuptools和distribute并成为python标准库中的标准工具。但该计划并没有达到预期的目的,且已经是一个废弃的项目。

因此setuptools是一个优秀的，可靠的python包安装与分发工具。以下设计到包的安装与分发均针对setuptools,并不保证distutils可用。

#### 1.1.1 包格式

python库打包的格式包括wheel和egg。egg格式是由setuptools在2004年引入,而wheel格式是由PEP427在2012年定义。使用wheel和egg安装都不需要重新构建和编译,其在发布之前就应该完成测试和构建。

egg和wheel本质上都是一个zip格式包,egg文件使用.egg扩展名,wheel使用.whl扩展名。wheel的出现是为了替代egg,其现在被认为是python的二进制包的标准格式。

以下是wheel和egg的主要区别:

> * wheel有一个官方的PEP427来定义,而egg没有PEP定义
> * wheel是一种分发格式,即打包格式。而egg既是一种分发格式,也是一种运行时安装的格式,并且是可以被直接import
> * wheel文件不会包含.pyc文件
> * wheel使用和PEP376兼容的.dist-info目录,而egg使用.egg-info目录
> * wheel有着更丰富的命名规则。
> * wheel是有版本的。每个wheel文件都包含wheel规范的版本和打包的实现
> * wheel在内部被sysconfig path type管理,因此转向其他格式也更容易

#### 1.1.2 setup.py文件

python库打包分发的关键在于编写setup.py文件。setup.py文件编写的规则是从setuptools或者distuils模块导入setup函数,并传入各类参数进行调用。

```python
from setuptools import setup
# or
# from distutils.core import setup  

setup(
        name='demo',     # 包名字
        version='1.0',   # 包版本
        description='This is a test of the setup',   # 简单描述
        author='huoty',  # 作者
        author_email='sudohuoty@163.com',  # 作者邮箱
        url='https://www.konghy.com',      # 包的主页
        packages=['demo'],                 # 包
)
```

setup函数常用的参数如下：

| 参数 | 说明 |
| :--- | :--- |
| `name` | 包名称 |
| `version` | 包版本 |
| `author` | 程序的作者 |
| `author_email` | 程序的作者的邮箱地址 |
| `maintainer` | 维护者 | 
| `maintainer_email` | 维护者的邮箱地址 |
| `url` | 程序的官网地址 |
| `license` | 程序的授权信息 |
| `description` | 程序的简单描述 |
| `long_description` | 程序的详细描述 |
| `platforms` | 程序适用的软件平台列表 |
| `classifiers` | 程序的所属分类列表 |
| `keywords` | 程序的关键字列表 |
| `packages` | 需要处理的包目录(通常为包含`__init__.py`的文件夹) |
| `py_modules` | 需要打包的python单文件列表 |
| `download_url` | 程序的下载地址 |
| `cmdclass` | 添加自定义命令 |
| `package_data` | 指定包内需要包含的数据文件 |
| `include_package_data` | 自动包含包内所有受版本控制(cvs/svn/git)的数据文件 |
| `exclude_package_data` | 当`include_package_data`为`True`时该选项用于排除部分文件 |
| `data_files` | 打包时需要打包的数据文件,如图片、配置文件等 |
| `ext_modules` | 指定扩展模块 |
| `scripts` | 指定可执行脚本,安装时脚本会被安装到系统`PATH`路径下 |
| `package_dir` | 指定哪些目录下的文件被映射到哪个源码包 | 
| `requires` | 指定依赖的其他包 | 
| `provides` | 指定可以为哪些模块提供依赖 |
| `install_requires` | 安装时需要安装的依赖包 |
| `entry_points` | 动态发现服务和插件,下面详细讲 |
| `setup_requires` | 指定运行setup.py文件本身所依赖的包 |
| `dependency_links` | 指定依赖包的下载地址 |
| `extras_require` | 当前包的高级/额外特性需要依赖的分发包 |
| `zip_safe` | 不压缩包,而是以目录的形式安装 |

更多参数可见: https://setuptools.readthedocs.io/en/latest/setuptools.html

* **`find_packages`**

对于简单工程来说,手动增加`packages`参数是容易。而对于复杂的工程来说,可能添加很多的包,这是手动添加就变得麻烦。setuptools模块提供了一个`find_packages`函数,它默认在与setup.py文件同一目录下搜索各个含有`__init__.py`的目录做为要添加的包。

```python
find_packages(where='.', exclude=(), include=('*',))
```

`find_packages`函数的第一个参数用于指定在哪个目录下搜索包,参数exclude用于指定排除哪些包,参数include指出要包含的包。

默认默认情况下setup.py文件只在其所在的目录下搜索包。如果不用`find_packages`,想要找到其他目录下的包,也可以设置`package_dir`参数,其指定哪些目录下的文件被映射到哪个源码包,如:`package_dir={'': 'src'}`表示"root package"中的模块都在src目录中。

* **包含数据文件**

**`package_data`:** 该参数是一个从包名称到glob模式列表的字典。如果数据文件包含在包的子目录中,则glob可以包括子目录名称。其格式一般为`{'package_name': ['files']}`,比如:`package_data={'mypkg': ['data/*.dat'],}`。

**`include_package_data`:** 该参数被设置为True时自动添加包中受版本控制的数据文件,可替代`package_data`,同时`exclude_package_data`可以排除某些文件。注意当需要加入没有被版本控制的文件时,还是仍然需要使用`package_data`参数才行。

**`data_files`:** 该参数通常用于包含不在包内的数据文件,即包的外部文件,如:配置文件,消息目录,数据文件。其指定了一系列二元组,即(目的安装目录、源文件),表示哪些文件被安装到哪些目录中。如果目录名是相对路径,则相对于安装前缀进行解释。

**`manifest template`:** manifest template即编写MANIFEST.in文件,文件内容就是需要包含在分发包中的文件。一个MANIFEST.in文件如下:

```
include *.txt
recursive-include examples *.txt *.py
prune examples/sample?/build
```

`MANIFEST.in`文件的编写规则可参考:https://docs.python.org/3.6/distutils/sourcedist.html

* **生成脚本**

有两个参数scripts参数或console\_scripts可用于生成脚本。

`entry_points`参数用来支持自动生成脚本,其值应该为是一个字典,从`entry_point`组名映射到一个表示`entry_point`的字符串或字符串列表,如:

```python
setup(
    # other arguments here...
    entry_points={
        'console_scripts': [
            'foo=foo.entry:main',
            'bar=foo.entry:main',
        ],    
    }
)
```

scripts参数是一个list,安装包时在该参数中列出的文件会被安装到系统PATH路径下。如:

```python
scripts=['bin/foo.sh', 'bar.py']
```

用如下方法可以将脚本重命名,例如去掉脚本文件的扩展名(.py、.sh):

```python
from setuptools.command.install_scripts import install_scripts

class InstallScripts(install_scripts):

    def run(self):
        setuptools.command.install_scripts.install_scripts.run(self)

        # Rename some script files
        for script in self.get_outputs():
            if basename.endswith(".py") or basename.endswith(".sh"):
                dest = script[:-3]
            else:
                continue
            print("moving %s to %s" % (script, dest))
            shutil.move(script, dest)

setup(
    # other arguments here...
    cmdclass={
        "install_scripts": InstallScripts
    }
)
```

其中,cmdclass参数表示自定制命令,后文详述。

**`ext_modules`**

`ext_modules`参数用于构建C和C++扩展扩展包。其是`Extension`实例的列表,每一个`Extension`实例描述了一个独立的扩展模块,扩展模块可以设置扩展包名,头文件、源文件、链接库及其路径、宏定义和编辑参数等。如:

```python
setup(
    # other arguments here...
    ext_modules=[
        Extension('foo',
                  glob(path.join(here, 'src', '*.c')),
                  libraries = [ 'rt' ],
                  include_dirs=[numpy.get_include()])
    ]
)
```

详细了解可参考:https://docs.python.org/3.6/distutils/setupscript.html#preprocessor-options

**`zip_safe`**

`zip_safe`参数决定包是否作为一个`zip`压缩后的`egg`文件安装,还是作为一个以`.egg`结尾的目录安装。因为有些工具不支持`zip`压缩文件,而且压缩后的包也不方便调试,所以建议将其设为`False`,即`zip_safe=False`。

> * **自定义命令**

`setup.py`文件有很多内置的的命令,可以使用`python setup.py --help-commands`查看。如果想要定制自己需要的命令,可以添加`cmdclass`参数,其值为一个`dict`。实现自定义命名需要继承`setuptools.Command`或者`distutils.core.Command`并重写`run`方法。

```python
from setuptools import setup, Command

class InstallCommand(Command):
    description = "Installs the foo."
    user_options = [
        ('foo=', None, 'Specify the foo to bar.'),
    ]
    def initialize_options(self):
        self.foo = None
    def finalize_options(self):
        assert self.foo in (None, 'myFoo', 'myFoo2'), 'Invalid foo!'
    def run(self):
        install_all_the_things()

setup(
    ...,
    cmdclass={
        'install': InstallCommand,
    }
)
```

> * **依赖关系**

如果包依赖其他的包,可以指定`install_requires`参数,其值为一个`list`,如:

```python
install_requires=[
    'requests>=1.0',
    'flask>=1.0'
]
```

指定该参数后,在安装包时会自定从`pypi`仓库中下载指定的依赖包安装。

此外,还支持从指定链接下载依赖,即指定`dependency_links`参数,如:

```python
dependency_links = [
    "http://packages.example.com/snapshots/foo-1.0.tar.gz",
    "http://example2.com/p/bar-1.0.tar.gz",
]
```

> * **分类信息**

`classifiers`参数说明包的分类信息。所有支持的分类列表见:`https://pypi.org/pypi?%3Aaction=list_classifiers`。示例:

```python
classifiers = [
    # 发展时期,常见的如下
    #   3 - Alpha
    #   4 - Beta
    #   5 - Production/Stable
    'Development Status :: 3 - Alpha',

    # 开发的目标用户
    'Intended Audience :: Developers',

    # 属于什么类型
    'Topic :: Software Development :: Build Tools',

    # 许可证信息
    'License :: OSI Approved :: MIT License',

    # 目标 Python 版本
    'Programming Language :: Python :: 2',
    'Programming Language :: Python :: 2.7',
    'Programming Language :: Python :: 3',
    'Programming Language :: Python :: 3.3',
    'Programming Language :: Python :: 3.4',
    'Programming Language :: Python :: 3.5',
]
```

* **`setup.py`命令**

`setup.py`文件有很多内置命令可供使用,查看所有支持的命令:

```sh
python setup.py --help-commands
```

此处列举一些常用命令:

build:构建安装时所需的所有内容

sdist:构建源码分发包,在Windows下为zip格式,Linux下为tag.gz格式。执行sdist命令时,默认会被打包的文件:

> 所有`py_modules`或`packages`指定的源码文件
>
> 所有`ext_modules`指定的文件
>
> 所有`package_data`或`data_files`指定的文件
>
> 所有`scripts`指定的脚本文件
> 
> `README`、`README.txt`、`setup.py`和`setup.cfg`文件

该命令构建的包主要用于发布,例如上传到`pypi`上。

bdist:构建一个二进制的分发包。

bdist_egg: 构建一个egg分发包,经常用来替代基于bdist生成的模式

install:安装包到系统环境中。

develop:以开发方式安装包,该命名不会真正的安装包,而是在系统环境中创建一个软链接指向包实际所在目录。这边在修改包之后不用再安装就能生效,便于调试。

register、upload:用于包的上传发布，后文详述。

`setup.cfg`文件:setup.cfg文件用于提供setup.py的默认参数,详细的书写规则可参考:`https://docs.python.org/3/distutils/configfile.html`

版本命名:包版本的命名格式应为如下形式:

```
N.N[.N]+[{a|b|c|rc}N[.N]+][.postN][.devN]
```

从左向右做一个简单的解释:

> "N.N": 必须的部分,两个"N"分别代表了主版本和副版本号
>
> "[.N]": 次要版本号,可以有零或多个
>
> "{a|b|c|rc}": 阶段代号,可选a,b,c,rc分别代表alpha,beta,candidate和release candidate
> 
> "N[.N]": 阶段版本号,如果提供,则至少有一位主版本号,后面可以加无限多位的副版本号
> 
> ".postN": 发行后更新版本号,可选
>
> ".devN": 开发期间的发行版本号,可选

* **`easy_install`与`pip`**

`easy_insall`是`setuptool`包提供的第三方包安装工具,而`pip`是`python`中一个功能完备的包管理工具,是`easy_install`的改进版,提供更好的提示信息,删除包等功能。

`pip`相对于`easy_install`进行了以下几个方面的改进:

> 所有的包是在安装之前就下载了,所以不可能出现只安装了一部分的情况
> 
> 在终端上的输出更加友好
> 
> 对于动作的原因进行持续的跟踪。例如,如果一个包正在安装,那么pip就会跟踪为什么这个包会被安装
> 
> 错误信息会非常有用
> 
> 代码简洁精悍可以很好的编程
> 
> 不必作为egg存档,能扁平化安装(仍然保存egg元数据)
> 
> 原生的支持其他版本控制系统(Git,Mercurial and Bazaar)
> 
> 加入卸载包功能
> 
> 可以简单的定义修改一系列的安装依赖,还可以可靠的赋值一系列依赖包

* **发布包**

PyPI(Python Package Index)是`python`官方维护的第三方包仓库,用于统一存储和管理开发者发布的`python`包。

如果要发布自己的包,需要先到pypi上注册账号。然后创建`~/.pypirc`文件,此文件中配置PyPI访问地址和账号。如的`.pypirc`文件内容请根据自己的账号来修改。

典型的`.pypirc`文件

```
[distutils]
index-servers = pypi

[pypi]
username:xxx
password:xxx
```

接着注册项目: `python setup.py register`

该命令在`PyPi`上注册项目信息,成功注册之后,可以在PyPi上看到项目信息。最后构建源码包发布即可:`python setup.py sdist upload`


## 二、python与c参考手册

应用程序程序员的python接口使C和C++程序员可以在各种级别访问python解释器。API可以与C++同等地使用,但为了简洁起见,它通常被称为python/C API。使用python/C API有两个根本不同的原因。第一个原因是为特定目的写扩展模块;这些是扩展python解释器的C模块。这可能是最常用的。第二个原因是使用python作为大型应用程序中的一个组件;这种技术通常被称为嵌入pythonin一个应用程序.

编写扩展模块是一个相对容易理解的过程,其中"烹饪书"方法很有效。有几种工具可以在一定程度上自动化过程。虽然人们在早期存在的过程中将python嵌入到其他应用程序中,但嵌入python的过程并不比编写扩展程序简单得多.

许多API函数都是有用的,无论你是否嵌入了原始python;此外,大多数嵌入python的应用程序也需要提供自定义扩展,因此在尝试将python嵌入到重新应用之前熟悉编写扩展可能是个好主意.

### 2.1 基础使用

python可以非常方便地和C进行相互的调用,一般,我们不会使用C去直接编写一个python的模块。通常的情景是我们需要把C的相关模块包装一下,然后在python中可以直接调用它。或者是,把python逻辑中的某一效率要求很高的部分使用C来实现。整个过程大概是:

> 引入`python.h`头文件
>
> 编写包装函数
>
> 函数中处理从python传入的参数
>
> 实现功能逻辑
>
> 处理C中的返回值,包装成python对象
>
> 在一个PyMethodDef结构体中注册需要的函数。
>
> 在一个初始化方法中注册模块名。
>
> 把这个C源文件编译成链接库。

```c
int add(int x, int y){
    return x + y;
}

// int main(void){
//     printf("%d", add(1, 2));
//     return 0;
// }

#include<python.h>    // 引入python.h头文件,在/usr/include/python*目录

// 编写包装函数
// 包装函数一般声明成static,并且第一个参数是一个默认传入的python对象,就是python中某个对象的属性方法一样,第二个参数才是我们调用时传入的参数
static PyObject* W_add(PyObject* self, PyObject* args){
    int x;
    int y;
    // 出入传入参数:常用的函数PyArg_ParseTuple
    if(!PyArg_ParseTuple(args, "i|i", &x, &y)){
        return NULL;
    } else {
        // 处理C中的返回值,常用的函数Py_BuildValue
        return Py_BuildValue("i", add(x, y));
    }
}

//  注册函数
//  PyMethodDef列表中结构体成员有四个函数:
//      "add"导出后在pyhton中可见的方法名。
//      W_add实际映射到C中的方法名。
//      METH_VARARGS表示传入方法的是普通参数,当然还可以处理关键词参数。
//      此方法的注释。
static PyMethodDef ExtendMethods[] = {
    {"add", W_add, METH_VARARGS, "a function from C"},
    {NULL, NULL, 0, NULL},
};

//  注册模块
//      方法名必须是init加上模块名,然后调用Py_InitModule来注册模块,
//      这个函数的第一个参数就是模块名,第二个参数是此模块中我们导出的方法,就是上一步定义的结构体
PyMODINIT_FUNC initdemo(){
    Py_InitModule("demo", ExtendMethods);
}
```

编译和使用:

```sh
gcc demo.c -I /usr/include/python2.6 -shared -o demo.so
```

使用模块:

```python
import demo
demo.add(3, 4)
```

### 2.2 编码标准

如果您正在编写包含在Cpython中的C代码,那么你必须遵循[PEP 7](https://www.python.org/dev/peps/pep-0007/)。这些指南适用于您所贡献的python版本。除非你最终希望将它们贡献给python,否则你的第三方扩展模块不需要遵循这些约定.


* **包含文件**

使用python所需的所有函数,类型和宏定义C API包含在您的代码中,如下所示:

```c
#include"python.h"
```

这意味着包含以下标准标题:`<stdio.h>`,`<string.h>`,`<errno.h>`,`<limits.h>`,`<assert.h>`和`<stdlib.h>`(如果可用).

注意:

> 由于python可能会定义一些影响某些系统上标准头的预处理器定义,所以在包含任何标准头之前你must包含python.h
>
> python.h定义的所有用户可见名称(包括标准头文件定义的除外)都有一个前缀Py或_Py。以_Py开头的名称供python实现内部使用,不应由扩展编写者使用。结构成员名称没有保留前缀.
>
> 重要的用户代码永远不应该定义以Py或_Py开头的名称。这会使读者感到困惑,并危及用户代码对未来python版本的可移植性,这些版本可能会定义以这些前缀之一开头的其他名称.
>
> 头文件通常与python一起安装。在Unix上,它们位于`prefix/include/pythonversion/`和`exec_prefix/include/pythonversion/`目录中,其中`prefix`和`exec_prefix`由`python`的相应参数定义配置脚本和`version`是`"%d.%d"%sys.version_info[:2]`。在Windows上,标题安装在`prefix/include`中,其中`prefix`是指定给安装程序的安装目录.
>
> 要包含标题,请将两个目录(如果不同)放在编译器上包含的搜索路径。做not将父目录放在搜索路径上,然后使用`#include<pythonX.Y/python.h>`;这将打破多平台构建,因为`prefix`下面的平台独立头包含来自`exec_prefix`.
>
> C++用户应该注意,尽管API完全使用C定义,但是头文件正确地将入口点声明为extern"C",因此不需要做任何特殊的事情来使用C++中的API.

* **有用的宏**

python头文件中定义了几个有用的宏。许多被定义为更接近它们有用的地方(例如Py_RETURN_NONE)。这里定义了更通用的其他实用程序。这不一定是完整的列表.

> Py_UNREACHABLE():当你有一个你不希望达到的代码路径时使用这个。例如,在default:声明switch声明中有关可能的值的声明包含在case声明中。在你可能想要放置assert(0)或abort()来电的地方使用它
>
> Py_ABS(x):返回x的绝对值。
>
> Py_MIN(x,y):返回x和y之间的最小值
>
> Py_MAX(x,y): 返回x和y之间的最大值
>
> Py_STRINGIFY(x):将x转换为C字符串。例如Py_STRINGIFY(123)返回"123".
>
> Py_MEMBER_SIZE(type,member):返回大小一个结构(type)member以字节为单位
>
> Py_CHARMASK(c):参数必须是[-128,127]或[0,255]范围内的字符或整数。这个宏返回c施放到unsignedchar.
>
> Py_GETENV(s):就像getenv(s),但是返回NULL如果-E在命令行上传递(即如果设置了Py_IgnoreEnvironmentFlag).
>
> Py_UNUSED(arg):将此用于函数定义中未使用的参数,以使编译警告静音,例如PyObject*func(PyObject*Py_UNUSED(ignored)).

* **类型和引用计数**

大多数python/C API函数都有一个或多个参数以及类型的返回值`PyObject *`。此类型是指向表示任意python对象的不透明数据类型的指针。由于在大多数情况下(例如赋值,范围规则和参数传递),python语言都以相同的方式处理所有python对象类型,因此它们应该由单个C类型表示。几乎所有python对象都存在于堆中:你永远不会声明类型为PyObject,只能声明`PyObject *`类型的指针变量。唯一的例外是类型对象;因为它们绝对不能被分配,所以它们通常是静态的PyTypeObject对象.

所有python对象(甚至python整数)都有type和referencecount。对象的类型确定它是什么类型的对象(例如,整数,列表或用户定义的函数;还有更多的问题在中标准类型层次结构)。对于每个众所周知的类型,都有一个macroto检查对象是否属于该类型;例如,`PyList_Check(a) is true if(且仅当)a`指向的对象是一个python列表.

**引用计数**

引用计数很重要因为今天的计算机有一个有限的(并且是严重限制)内存大小;它计算有多少不同的地方有一个对象的引用。这样的位置可以是另一个对象,或全局(或静态)C变量,或某个C函数中的局部变量。当对象的引用计数变为零时,该对象将被释放。If it包含对其他对象的引用,它们的引用计数递减。如果此递减使其引用计数变为零,则可以依次释放其他对象,依此类推。(这里有一个明显的问题,对象在这里相互引用;现在,解决方案是“不要用do that。”)

引用计数总是被明确地操作。通常的方法是使用宏Py_INCREF()将对象的引用计数增加1,并使用Py_DECREF()将其减1。Py_DECREF()macrois比incrementf要复杂得多,因为它必须检查引用计数是否为零然后导致对象的解除分配器被置换。deallocator是包含在对象的类型结构中的函数指针。特定于类型的解除分配器负责减少对象中包含的其他对象的干扰计数(如果这是复合对象类型,例如列表),以及执行所需的任何其他完成。引用计数不可能溢出;由于虚拟内存中存在明显的内存位置(假设sizeof(Py_ssize_t)>=sizeof(void*)),因此至少会使用多少位来保存引用计数。因此,引用计数增量是一个简单的操作.

没有必要为包含指向对象的指针的每个局部变量递增对象的引用计数。从理论上讲,当变量指向它时,对象的引用计数增加1,当变量超出范围时,它会减1。但是,这些两个相互出来,所以最后引用计数没有改变。使用引用计数的唯一真正原因是,只要我们的变量指向它,就可以防止对象被释放。如果我们知道至少有一个对该对象的引用至少和变量一样长,那么就不需要临时增加引用计数。出现这种情况的一个重要情况是在向C函数传递参数的对象中。一个从python调用的扩展模块;调用机制保证保存对每个参数的引用以便调用该调用.

但是,常见的缺陷是从列表中提取对象并保持一段时间而不增加其引用计数。其他一些操作可能会从列表中删除该对象,减少其引用计数并可能解除分配。真正的危险是,无辜的操作可能会调用可以执行此操作的任意python代码;有一个代码路径,允许控件从回流到用户Py_DECREF()最重要的是任何操作都有潜在危险.

一种安全的方法是始终使用泛型操作(namebegins与PyObject_,PyNumber_,PySequence_要么PyMapping_这些操作总是增加它们返回的对象的引用计数。这使得调用者有责任调用Py_DECREF()当他们完成结果;这很快成为第二天性.


**引用计数详细信息**

python/C API中函数的引用计数行为最好用ownership of references。所有权属于引用,never to对象(对象不归属于:它们始终是共享的)。“拥有参考”意味着当不再需要参考时负责在其上调用Py_DECREF。所有权也可以被转移,这意味着接受参考所有权的代码然后通过在不再需要时调用Py_DECREF()或Py_XDECREF()或者传递这一责任而成为负责人,从而降低它的负担(通常是它的召唤者)。当函数将引用的所有权传递给其调用者时,调用者被称为接收new引用。当没有所有权转移时,呼叫者被称为borrow参考。没有什么需要为明天的引用而做.

相反,当一个调用函数传入一个对象的引用时,有两种可能性:函数steals对象的引用,或者它不是。Stealingareference表示当你传递一个函数的引用时,该函数假定它现在拥有该引用,并且你不再对它负责.

很少有函数窃取引用;这两个值得注意的例外是PyList_SetItem()和PyTuple_SetItem(),它们窃取了对项目的引用(但不是对项目所放置的元组或列表！)。这些函数被设计为窃取引用,因为有一个常见的习惯用于使用新创建的对象来填充元组或列表;例如,代码创建元组(1,2,"three")可能看起来像这样(暂时忘记abouterror处理;更好的编码方式如下所示):

```c
PyObject *t;t = PyTuple_New(3);
PyTuple_SetItem(t, 0, PyLong_FromLong(1L));
PyTuple_SetItem(t, 1, PyLong_FromLong(2L));
PyTuple_SetItem(t, 2, PyUnicode_FromString("three"));
```

这里,PyLong_FromLong()返回一个新的引用,它被PyTuple_SetItem()立即删除。当你想继续使用一个对象时,对它的引用会被盗,在调用引用窃取函数之前使用Py_INCREF()来指示其他参考.

偶然的,PyTuple_SetItem()是only设置元组项目的方式;PySequence_SetItem()和PyObject_SetItem()拒绝这样做,因为元组是一个不可变的数据类型。您应该只使用PyTuple_SetItem()来创建自己创建的元组.

用于填充列表的等效代码可以使用PyList_New()和PyList_SetItem().

编写但是,在实践中,您很少会使用这些方法来创建和填充元组或列表。有一个通用函数,Py_BuildValue(),它可以用format string指定从C值创建大多数常见对象。例如,上面两个代码块可以用以下代码替换(也需要关心错误检查):

```c
PyObject *tuple, *list;
tuple = Py_BuildValue("(iis)", 1, 2, "three");
list = Py_BuildValue("[iis]", 1, 2, "three");
```

更常见的是使用PyObject_SetItem()和朋友的项目,这些项目只是你借用的参考文献,就像你正在编写的函数中传递的参数一样。在这种情况下,他们对参考计数的行为更加明智,因为您不必增加引用计数,因此您可以提供参考(“让它被盗”)。例如,此函数将列表中的所有项(实际上是任何可变序列)设置为给定项:

```c
intset_all(PyObject *target, PyObject *item){
    Py_ssize_t i, n;
    n = PyObject_Length(target);
    if (n < 0)
        return -1;
    for (i = 0; i < n; i++) {
        PyObject *index = PyLong_FromSsize_t(i);
        if (!index)
            return -1;
        if (PyObject_SetItem(target, index, item) < 0) {
            Py_DECREF(index);
            return -1;
        }
        Py_DECREF(index);
    }
    return 0;
}
```

函数返回值的情况略有不同。虽然传递对大多数函数的引用并不会更改对该引用的所有权责任,但许多返回对对象引用的函数都会给您引用的所有权。原因很简单:在很多情况下,动态创建了对象,您获得的引用是对象的唯一引用。因此,返回对象引用的泛型函数,如PyObject_GetItem()和PySequence_GetItem(),总是返回一个新的引用(调用者成为引用的所有者).

重要的是意识到你是否拥有一个由函数返回的引用取决于你只调用哪个函数–theplumage(作为参数传递给函数的对象的类型)doesn’tenterintoit!因此,如果你提取一个项目从使用PyList_GetItem()的列表中,你不拥有引用–但如果你使用PySequence_GetItem()(它恰好采用完全相同的参数),你拥有对返回对象的引用.

下面是一个示例,说明如何编写一个函数来计算整数列表中项目的总和;一次使用PyList_GetItem(),一次使用PySequence_GetItem().

```c
longsum_list(PyObject *list){
    Py_ssize_t i, n;
    long total = 0, value;
    PyObject *item;
    n = PyList_Size(list);
    if (n < 0)
        return -1;
 /* Not a list */
    for (i = 0; i < n; i++) {
        item = PyList_GetItem(list, i);
 /* Can"t fail */
        if (!PyLong_Check(item)) continue;
 /* Skip non-integers */
        value = PyLong_AsLong(item);
        if (value == -1 && PyErr_Occurred())
            /* Integer too big to fit in a C long, bail out */
            return -1;
        total += value;
    }
    return total;
}

longsum_sequence(PyObject *sequence){
    Py_ssize_t i, n;
    long total = 0, value;
    PyObject *item;
    n = PySequence_Length(sequence);
    if (n < 0)
        return -1;
    /* Has no length */
    for (i = 0; i < n; i++) {
        item = PySequence_GetItem(sequence, i);
        if (item == NULL)
            return -1;
    /* Not a sequence, or other failure */
        if (PyLong_Check(item)) {
            value = PyLong_AsLong(item);
            Py_DECREF(item);
            if (value == -1 && PyErr_Occurred())
                /* Integer too big to fit in a C long, bail out */
                return -1;
            total += value;
        }
        else {
            Py_DECREF(item); /* Discard reference ownership */
        }
    }
    return total;
}
```

**类型**

很少有其他数据类型在python/C API中发挥重要作用;大多数是简单的C类型,如int,long,double和char*。一些结构类型用于描述用于列出模块导出的函数的静态表或新对象类型的数据属性,另一种用于描述复数的值。这些将与使用它们的功能一起讨论.

例外,如果需要特定的错误处理,python程序员只需要处理异常;未处理的异常会自动传播给调用者,然后传递给调用者的调用者,依此类推,直到他们到达顶级解释器,然后将它们报告给用户并伴随stacktraceback.

然而,对于C程序员来说,错误检查总是必须明确。python/CAPI中的所有函数都可以引发异常,除非在函数文档中另有明确声明。通常,当函数发生错误时,它会设置异常,丢弃所拥有的任何对象引用,并返回错误指示符。如果没有另外说明,则该指示符是NULL或-1,具体取决于函数的返回类型。一些函数返回布尔值true/false结果,false表示错误。很少有函数返回没有明确的错误指示符或具有不明确的返回值,并且需要使用PyErr_Occurred()。始终明确记录这些异常.

在每线程存储中维护异常状态(这相当于在无线程应用程序中存储全局存储)。线程可以处于以下两种状态之一:发生了异常,或者没有。函数PyErr_Occurred()可用于检查:当发生异常时,它返回对异常类型对象的借用引用,否则返回NULL。有许多函数可以设置异常状态:PyErr_SetString()是设置异常状态最常见的(虽然不是最常用的)函数,而PyErr_Clear()清除异常状态.

完整异常状态由三个对象组成(所有对象都可以是NULL):异常类型,相应的异常值和跟踪。这些与sys.exc_info()的python结果具有相同的含义;然而,它们并不相同:python对象代表python处理的最后一个异常try…except语句,而C级异常状态只存在,而C函数之间传递异常,直到它到达pythonbytecode解释器的主循环,它负责将它传递给sys.exc_info()和friends.

请注意,从python1.5开始,从python代码访问异常状态的首选,线程安全方法是调用函数sys.exc_info(),它返回python代码的每线程异常状态。此外,访问异常状态的两种方法的这些语法已经改变,因此捕获异常的功能将保存并恢复其线程的异常状态,以便保留其调用者的异常状态。这可以防止异常处理代码中的commonbugs由一个无辜的函数覆盖正在处理的异常;它还减少了由追踪中的堆栈帧引用的对象经常不需要的生命周期扩展.

作为一般原则,调用另一个函数来执行某个任务的函数应检查被调用函数是否引发异常,如果是,则将异常状态传递给其调用者。它应该丢弃它拥有的任何对象引用,并返回一个错误指示符,但它应该notsetanother异常–它将覆盖刚刚引发的异常,并丢失有关错误确切原因的重要信息.

在sum_sequence()上面的例子。碰巧这个例子在检测到错误时不需要清理任何拥有的引用。followingexample函数显示了一些错误清理。首先,为了提醒你为什么喜欢python,我们展示了相应的python代码:

```python
def incr_item(dict, key):
    try:
        item = dict[key]
    except KeyError:
        item = 0
    dict[key] = item + 1
```

这是相应的C代码,它的所有荣耀:

```c
intincr_item(PyObject *dict, PyObject *key){
    /* Objects all initialized to NULL for Py_XDECREF */
    PyObject *item = NULL, *const_one = NULL, *incremented_item = NULL;
    int rv = -1; /* Return value initialized to -1 (failure) */
    item = PyObject_GetItem(dict, key);
    if (item == NULL) {
        /* Handle KeyError only: */
        if (!PyErr_ExceptionMatches(PyExc_KeyError))
            goto error;
        /* Clear the error and use zero: */
        PyErr_Clear();
        item = PyLong_FromLong(0L);
        if (item == NULL)
            goto error;
    }
    const_one = PyLong_FromLong(1L);
    if (const_one == NULL)
        goto error;
    incremented_item = PyNumber_Add(item, const_one);
    if (incremented_item == NULL)
        goto error;
    if (PyObject_SetItem(dict, key, incremented_item) < 0)
        goto error;
    rv = 0; /* Success */
    /* Continue with cleanup code */
 error:
    /* Cleanup code, shared by success and failure path */
    /* Use Py_XDECREF() to ignore NULL references */
    Py_XDECREF(item);
    Py_XDECREF(const_one);
    Py_XDECREF(incremented_item);
    return rv;
 /* -1 for error, 0 for success */
}
```

这个例子代表了gotoC中的陈述！它说明了PyErr_ExceptionMatches()和PyErr_Clear()处理特定异常,并使用Py_XDECREF()处理可能是NULL的所有引用(注意名称中的"X";Py_DECREF()会崩溃当遇到NULL参考时)。重要的是,用于保存所有参考的变量被初始化为NULL以使其起作用;同样,建议的返回值初始化为-1(失败),并且只有在最终调用成功后才能成功.


### 2.3 嵌入python

只有嵌入器的一项重要任务(而不是扩展编写者)python解释器必须担心的是python解释器的初始化,可能还有最终化。解释器的大多数功能只能在解释器初始化后才能使用.

基本初始化函数是Py_Initialize()。这初始化了已加载模块的表,并创建了基本模块builtins,__main__和sys。它还初始化模块搜索路径(sys.path).

Py_Initialize()没有设置“脚本参数列表”(sys.argv)。如果以后执行的python代码需要这个变量,那么在调用之后必须通过调用PySys_SetArgvEx(argc,argv,updatepath)显式设置它。Py_Initialize().

在大多数系统上(特别是在Unix和Windows上,尽管细节略有不同),Py_Initialize()基于对标准pythoninterpreterexecutable位置的最佳猜测来计算模块搜索路径,假设python库位于与python解释器可执行文件相关的固定位置。特别是,它寻找名为lib/pythonX.Y相对于名为python在shell命令searchpath中找到(环境变量PATH).

例如,如果在/usr/local/bin/python,它会假设库在/usr/local/lib/pythonX.Y。(事实上,这个特殊的路径也是“后备”位置,在没有名为python发现PATH。)用户可以通过设置环境变量PYTHONHOME来覆盖此行为,或者通过设置PYTHONPATH.

嵌入应用程序可以通过调用Py_SetProgramName(file)before调用Py_Initialize()来引导搜索。注意PYTHONHOME仍然覆盖了这个和PYTHONPATH仍然插在标准路径的前面。需要全面控制的应用程序必须提供自己的Py_GetPath(),Py_GetPrefix(),Py_GetExecPrefix()和Py_GetProgramFullPath()的实现(全部在Modules/getpath.c中定义.

有时,需要“取消初始化”python。例如,应用程序可能要重新开始(再次调用Py_Initialize()或者应用程序只是通过使用python来完成,并希望释放python分配的内存。这可以通过调用Py_FinalizeEx()来完成。功能Py_IsInitialized()如果python当前处于初始化状态,则返回returntrue。有关这些功能的更多信息将在后面的章节中给出。注意Py_FinalizeEx()做not释放python解释器分配的所有内存,例如:目前无法释放由扩展模块分配的内存.

更高的参考:https://www.itbook5.com/2019/02/10984/


## 三、基本模块

### 3.1 `psutil`模块

`psutil`是个跨平台库,能够轻松实现获取系统运行的进程和系统利用率,包括CPU、内存、磁盘、网络等信息。它主要应用于信息监控，分析和限制系统资源及进程的管理。它实现了同等命令命令行工具提供的功能,如:`ps`、`top`、`lsof`、`netstat`、`ifconfig`、`who`、`df`、`kill`、`free`、`nice`、`ionice`、`iostat`、`iotop`、`uptime`、`pidof`、`tty`、`taskset`、`pmap`等。目前支持32位和64位的`linux`、`windows`、`OS X`、`FreeBSD`和`Sun Solaris`等操作系统。

* **获取`CPU`信息**

```python
psutil.cpu_times(percpu=False)  #查看CPU所有信息
# scputimes(user=306.98, nice=2.01, system=337.34, idle=410414.39, iowait=78.37, irq=0.0, softirq=17.42, steal=0.0, guest=0.0, guest_nice=0.0)
#   user:用户进程花费的时间
#   nice:用户模式执行Niced优先级进程花费的时间
#   system:内核模式进程花费的时间
#   idle:闲置时间
#   iowait:等待I/O完成的时间
#   irq:处理硬件中断的时间
#   softirq:处理软件中断的时间
#   steal:虚拟化环境中运行的其他操作系统花费的时间
#   guest:在linux内核的控制下为客户端操作系统运行虚拟CPU所花费的时间
#   guest_nice:虚拟机运行niced所花费的时间


psutil.cpu_times(percpu=True)  #显示所有CPU逻辑信息
# [scputimes(user=56676.49, nice=0.0, system=38614.3, idle=431441.25),
#  scputimes(user=20572.6, nice=0.0, system=10738.09, idle=495404.12),
#  scputimes(user=55527.28, nice=0.0, system=27354.65, idle=443833.23),
#  scputimes(user=18629.33, nice=0.0, system=8379.76, idle=499705.7)]

psutil.cpu_times().user  # 显示用户占CPU的时间比
# 151413.85

psutil.cpu_count(logical=True)  # 显示CPU逻辑个数
# 4

psutil.cpu_count(logical=False)  #显示CPU物理个数
# 4

psutil.cpu_stats()    # CPU统计信息
# scpustats(ctx_switches=30475, interrupts=694164, soft_interrupts=846899249, syscalls=491839)
#   ctx_switches:启动后的上下问切换次数
#   interrupts:自启动以来的中断次数
#   soft_interrupts:启动后的软件中断数量
#   syscalls:启动以来的系统调用次数,在linux上始终为0
```

* **内存信息**

`psutil.virtual_memory()`以字节返回内存使用情况的统计信息

```python
mem = psutil.virtual_memory()  # 获取内存完整信息
mem
# svmem(total=8589934592, available=2228961280, percent=74.1, used=4871819264, free=34856960, active=2194817024, inactive=2111557632, wired=2677002240)
#   total:总物理内存
#   available:可用的内存
#   used:使用的内存
#   free:完全没有使用的内存
#   active:当前正在使用的内存
#   inactive:标记为未使用的内存
#   buffers:缓存文件系统元数据使用的内存
#   cached:缓存各种文件的内存
#   shared:可以被多个进程同时访问的内存
#   slab:内核数据结构缓存的内存

mem.total   # 获取内存总数
# 8589934592

mem.used   # 获取已使用内存
# 4871819264

mem.free   # 获取空闲内存
# 34856960

psutil.swap_memory()  # 获取swap内存信息
# sswap(total=3221225472, used=1956118528, free=1265106944, percent=60.7, sin=373117317120, sout=3539480576)
#   total:以字节为单位的总交换内存
#   used:以字节为单位使用交换内存
#   free:以字节为单位的可用交换内存
#   percent:使用百分比
#   sin:系统从磁盘交换的字节数
#   sout:系统从磁盘换出的字节数
```

* **磁盘信息**

`psutil.disk_partitions(all=False)`:返回所有安装的磁盘分区作为名称元组的列表,包括设备,安装点和文件系统类型,类似于`Unix`上的'`df`'命令。

```python
psutil.disk_partitions(all=False)    # 获取磁盘完整信息
# [sdiskpart(device='/dev/disk1s5', mountpoint='/', fstype='apfs', opts='ro,local,rootfs,dovolfs,journaled,multilabel'),
#  sdiskpart(device='/dev/disk1s1', mountpoint='/System/Volumes/Data', fstype='apfs', opts='rw,local,dovolfs,dontbrowse,journaled,multilabel'),
#  sdiskpart(device='/dev/disk1s4', mountpoint='/private/var/vm', fstype='apfs', opts='rw,local,dovolfs,dontbrowse,journaled,multilabel')]
```

`psutil.disk_usage(path)`:将有关包含给定路径的分区的磁盘使用情况统计信息返回为指定元组,包括以字节表示的,总共,已使用和空闲的空间以及百分比使用率,如果路径存在则引发`OSError`。

```python
psutil.disk_usage('/')  # 获取分区使用情况
# sdiskusage(total=250685575168, used=10994212864, free=144880254976, percent=7.1)
#   total:总的大小(字节)
#   used:已使用的大小(字节)
#   free:空闲的大小(字节)
#   percent:使用百分比
```

`psutil.disk_io_counters(perdisk=False,nowrap=True)`:将系统范围的磁盘`I/0`统计作为命名元组返回,包括以下字段:

> `read_count`:读取次数
> <br>`write_count`:写入次数
> <br>`read_bytes`:读取的字节数
> <br>`write_bytes`:写入的字节数
> <br>`read_time`:从磁盘读取的时间(以毫秒为单位)
> <br>`write_time`:写入磁盘的时间(毫秒为单位)
> <br>`busy_time`:花费在实际`I/O`上的时间
> <br>`read_merged_count`:合并读取的数量
> <br>`write_merged_count`:合并写入次数
> <br>`perdisk`为`True`时返回物理磁盘相同的信息;`nowrap`为`True`它将检测并调整函数调用中的新值。

```python
psutil.disk_io_counters(perdisk=True)  # 获取单个分区的IO信息
# {'disk0': sdiskio(read_count=17795776, write_count=10289680, read_bytes=569967538176, write_bytes=743204978688, read_time=12355382, write_time=8300453)}
```

* **网络信息**

`psutil.net_io_counters(pernic=False,nowrap=True)`:将系统范围的网络`I/O`统计信息作为命名元组返回,包括以下属性:

> `bytes_sent`:发送的字节数
> <br>`bytes_recv`:收到的字节数
> <br>`packets_sent`:发送的数据包数量
> <br>`packets_recv`:接收的数据包数量
> <br>`errin`:接收时的错误总数
> <br>`errout`:发送时的错误总数
> <br>`dropin`:丢弃的传入数据包总数
> <br>`dripout`:丢弃的传出数据包总数(在`OSX`和`BSD`上始终为0）
> <br>如果`pernic`为`True`网络接口上安装的每个网络接口返回相同的信息,`nowrap`为`True`时将检测并调整函数调用中的这些数字,将旧值添加到新值,保证返回的数字将增加或不变,但不减少,`net_io_counters.cache_clear()`可用于使`nowrap`缓存失效

```python
psutil.net_io_counters(pernic=False,nowrap=True)
# snetio(bytes_sent=12010523648, bytes_recv=85769799680, packets_sent=37748129, packets_recv=68741297, errin=0, errout=0, dropin=0, dropout=0)
psutil.net_io_counters(pernic=True,nowrap=True)
# {'ens32': snetio(bytes_sent=17684066, bytes_recv=299856862, packets_sent=121275, packets_recv=335825, errin=0, errout=0, dropin=0, dropout=0),
#  'lo': snetio(bytes_sent=1812739, bytes_recv=1812739, packets_sent=2270, packets_recv=2270, errin=0, errout=0, dropin=0, dropout=0)}
```

`psutil.net_connections(kind='inet')`:返回系统范围的套接字链接,命令元组列表返回,每个命名元组提供了7个属性:

> `fd`:套接字文件描述符。
> <br>`family`:地址系列`AF_INET`,`AF_INET6`或`AF_UNIX`。
> <br>`type`:地址类型`SOCK_STREAM`或`SOCK_DGRAM`。
> <br>`laddr`:本地地址作为命名元组或`AF_UNIX`套接字的情况
> <br>`raddr`:远程地址是指定的元组,或者是`UNIX`套接字的绝对地址,当远程端点未连接时,您将获得一个空元组`(AF_INET *)`或`(AF_UNIX)`
> <br>`status`:表示`TCP`连接的状态。
> <br>`pid`:打开套接字的进程的`PID`,如果是可检索的,否则`None`。在某些平台(例如`Linux`)上,此字段的可用性根据进程权限而变化(需要`root`)
> <br>`kind`参数的值包括:`inet`(`ipv4`和`ipv6`),`inet4`(`ipv4`),`inet6`(`ipv6`),`tcp`(`TCP`),`tcp4`(`TCP over ipv4`),`tcp6`(`TCP over ipv6`),`udp`(`UDP`),`dup4`(基于`ipv4`的`udp`),`cpu6`(基于`ipv6`的`udp`),`Unix`(`UNIX`套接字(`udp`和`TCP`协议),`all`(所有可能的家庭和协议的总和)

```python
psutil.net_connections(kind='tcp')
# [sconn(fd=3, family=<AddressFamily.AF_INET: 2>, type=<SocketKind.SOCK_STREAM: 1>, laddr=addr(ip='127.0.0.1', port=9090), raddr=(), status='LISTEN', pid=103599),
#  sconn(fd=4, family=<AddressFamily.AF_INET6: 10>, type=<SocketKind.SOCK_STREAM: 1>, laddr=addr(ip='::', port=22), raddr=(), status='LISTEN', pid=1179),
#  sconn(fd=13, family=<AddressFamily.AF_INET: 2>, type=<SocketKind.SOCK_STREAM: 1>, laddr=addr(ip='127.0.0.1', port=25), raddr=(), status='LISTEN', pid=1279),
#  sconn(fd=10, family=<AddressFamily.AF_INET: 2>, type=<SocketKind.SOCK_STREAM: 1>, laddr=addr(ip='0.0.0.0', port=3306), raddr=(), status='LISTEN', pid=70099),
#  sconn(fd=3, family=<AddressFamily.AF_INET: 2>, type=<SocketKind.SOCK_STREAM: 1>, laddr=addr(ip='0.0.0.0', port=22), raddr=(), status='LISTEN', pid=1179),
#  sconn(fd=3, family=<AddressFamily.AF_INET: 2>, type=<SocketKind.SOCK_STREAM: 1>, laddr=addr(ip='192.168.146.139', port=22), raddr=addr(ip='192.168.146.1', port=4238), status='ESTABLISHED', pid=122738),
#  sconn(fd=12, family=<AddressFamily.AF_INET: 2>, type=<SocketKind.SOCK_STREAM: 1>, laddr=addr(ip='127.0.0.1', port=9001), raddr=(), status='LISTEN', pid=103596),
#  sconn(fd=14, family=<AddressFamily.AF_INET6: 10>, type=<SocketKind.SOCK_STREAM: 1>, laddr=addr(ip='::1', port=25), raddr=(), status='LISTEN', pid=1279)]

psutil.net_connections(kind='inet4')
# [sconn(fd=3, family=<AddressFamily.AF_INET: 2>, type=<SocketKind.SOCK_STREAM: 1>, laddr=addr(ip='127.0.0.1', port=9090), raddr=(), status='LISTEN', pid=103599),
#  sconn(fd=13, family=<AddressFamily.AF_INET: 2>, type=<SocketKind.SOCK_STREAM: 1>, laddr=addr(ip='127.0.0.1', port=25), raddr=(), status='LISTEN', pid=1279),
#  sconn(fd=10, family=<AddressFamily.AF_INET: 2>, type=<SocketKind.SOCK_STREAM: 1>, laddr=addr(ip='0.0.0.0', port=3306), raddr=(), status='LISTEN', pid=70099),
#  sconn(fd=3, family=<AddressFamily.AF_INET: 2>, type=<SocketKind.SOCK_STREAM: 1>, laddr=addr(ip='0.0.0.0', port=22), raddr=(), status='LISTEN', pid=1179),
#  sconn(fd=3, family=<AddressFamily.AF_INET: 2>, type=<SocketKind.SOCK_STREAM: 1>, laddr=addr(ip='192.168.146.139', port=22), raddr=addr(ip='192.168.146.1', port=4238), status='ESTABLISHED', pid=122738),
#  sconn(fd=6, family=<AddressFamily.AF_INET: 2>, type=<SocketKind.SOCK_DGRAM: 2>, laddr=addr(ip='0.0.0.0', port=68), raddr=(), status='NONE', pid=119605),
#  sconn(fd=12, family=<AddressFamily.AF_INET: 2>, type=<SocketKind.SOCK_STREAM: 1>, laddr=addr(ip='127.0.0.1', port=9001), raddr=(), status='LISTEN', pid=103596),
#  sconn(fd=1, family=<AddressFamily.AF_INET: 2>, type=<SocketKind.SOCK_DGRAM: 2>, laddr=addr(ip='127.0.0.1', port=323), raddr=(), status='NONE', pid=741)]
```

`psutil.net_if_addrs()`:以字典的方式返回系统上的每个网络接口的关联地址

```python
psutil.net_if_addrs()
# {'lo': [snic(family=<AddressFamily.AF_INET: 2>, address='127.0.0.1', netmask='255.0.0.0', broadcast=None, ptp=None),
#   snic(family=<AddressFamily.AF_INET6: 10>, address='::1', netmask='ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff', broadcast=None, ptp=None),
#   snic(family=<AddressFamily.AF_PACKET: 17>, address='00:00:00:00:00:00', netmask=None, broadcast=None, ptp=None)],
#  'ens32': [snic(family=<AddressFamily.AF_INET: 2>, address='192.168.146.139', netmask='255.255.255.0', broadcast='192.168.146.255', ptp=None),
#   snic(family=<AddressFamily.AF_INET6: 10>, address='fe80::9853:19bb:b07b:89d4%ens32', netmask='ffff:ffff:ffff:ffff::', broadcast=None, ptp=None),
#   snic(family=<AddressFamily.AF_PACKET: 17>, address='00:50:56:31:d8:11', netmask=None, broadcast='ff:ff:ff:ff:ff:ff', ptp=None)]}
```

`psutil.net_if_stats()`:将安装在系统上的网络接口的信息作为字典返回,其中包括`isup`是否启动,`duplex`双工模式,`speed`速率,`mtu`最大传输单位,以字节表示

```python
psutil.net_if_stats()
# {'ens32': snicstats(isup=True, duplex=<NicDuplex.NIC_DUPLEX_FULL: 2>, speed=1000, mtu=1500),
#  'lo': snicstats(isup=True, duplex=<NicDuplex.NIC_DUPLEX_UNKNOWN: 0>, speed=0, mtu=65536)}
```

* **其他系统信息**

```python
import psutil,time
psutil.boot_time()  # 系统启动时间戳
# 1576293376.0
time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(psutil.boot_time()))    # 格式化时间
# 2019-12-14 11:16:16

psutil.users()   #返回当前链接的系统用户
# [suser(name='root', terminal='tty1', host='', started=1527050368.0, pid=769),
#  suser(name='root', terminal='pts/0', host='192.168.146.1', started=1527559040.0, pid=122742),
#  suser(name='root', terminal='pts/1', host='192.168.146.1', started=1527559040.0, pid=122761)]
```

* **系统进程管理**

```python
import psutil
psutil.pids()     # 列出所有进程PID
# [1,2,3,5,6,7,8,]

p = psutil.Process(1265)  # 实例化一个Process对象,参数为进程PID
p.name()   # 进程名
# 'mysqld'
p.exe()    # 进程bin路径
# '/usr/local/mysql-5.5.32/bin/mysqld'
p.cwd()    # 进程工作目录绝对路径
# '/mysql/data'
p.status() # 进程状态
# 'sleeping'
p.create_time()  # 进程创建时间,时间戳格式
1527642963.22
p.uids()   # 进程UID信息
# puids(real=1001, effective=1001, saved=1001)
p.gids()  # 进程GID信息
# pgids(real=1001, effective=1001, saved=1001)
p.cpu_times()  # 进程CPU时间信息,包括user、system的CPU时间
# pcputimes(user=1.53, system=6.06, children_user=0.0, children_system=0.0)
p.cpu_affinity()  # get进程CPU亲和度,如果设置进程CPU亲和度,将CPU号作为参数即可
# [0, 1, 2, 3]
p.memory_info() # 进程内存rss、vms信息
# pmem(rss=45268992, vms=460525568, shared=4399104, text=9420800, lib=0, data=425431040, dirty=0)
p.io_counters() # 进程IO信息包括读写IO数及字节数
# pio(read_count=594, write_count=27, read_bytes=15859712, write_bytes=32768, read_chars=6917150, write_chars=1555)
p.connections()  # 返回发开进程socket的namedutples列表,包括fs、family、laddr等信息
# [pconn(fd=10, family=<AddressFamily.AF_INET: 2>, type=<SocketKind.SOCK_STREAM: 1>, laddr=addr(ip='0.0.0.0', port=3306), raddr=(), status='LISTEN')]
p.num_threads()  # 进程开启的线程数
# 16
p.memory_percent() # 进程内存利用率
# 2.177553778800572
```

`psutil.process_iter(attrs=None,ad_value=None)`:返回一个迭代器`process`,为本地机器上的所有正在运行的进程生成一个类实例。

`psutil.pid_exists(pid)`:检查给定的PID是否存在于当前进程列表中。

`psutil.wait_procs(procs,timeout=None,callback=None)`:等待`process`终止实例列表的便捷函数,返回一个元组,指示哪些进程已经消失,哪些进程还活着。

`class psutil.Popen(*args,**kwargs)`:它启动一个子进程,并完全像使用`subprocess.Popen`一样处理,它还提供了所有`psutil.Process`类的方法。`Popen`类的作用是获取用户启动的应用程序进程信息,以便跟踪程序进程的运行状态。

```python
from subprocess import PIPE
p = psutil.Popen(["/usr/bin/python","-c","print('hello world')"],stdout=PIPE)
p.name()
# 'python'
p.username()
# 'root'
 p.communicate()
# (b'hello world\n', None)
```

进程过滤实例:

```python
from pprint import pprint as pp

# 根据进程名查看系统中的进程名与pid
pp([p.info for p in psutil.process_iter(attrs=['pid','name']) if 'python' in p.info['name']])
# [{'name': 'ipython3', 'pid': 2429}]

pp([p.info for p in psutil.process_iter(attrs=['pid','name']) if 'mysql' in p.info['name']])
# [{'name': 'mysqld_safe', 'pid': 987}, {'name': 'mysqld', 'pid': 1265}]

# 所有用户进程
import getpass
pp([(p.pid,p.info['name']) for p in psutil.process_iter(attrs=['name','username']) if p.info['username'] == getpass.getuser()])
# [(1, 'systemd'),
#  (2, 'kthreadd'),
#  (3, 'ksoftirqd/0'),
#  (5, 'kworker/0:0H'),
#  (6, 'kworker/u256:0'),
#  ...
#  (5004, 'kworker/0:0')]

# 查看积极运行的进程：
pp([(p.pid,p.info) for p in psutil.process_iter(attrs=['name','status']) if p.info['status'] == psutil.STATUS_RUNNING])
# [(2429, {'name': 'ipython3', 'status': 'running'})]

# 使用日志文件的进程
# import os,psutil
for p in psutil.process_iter(attrs=['name','open_files']):
  for file in p.info['open_files'] or []:
    if os.path.splitext(file.path)[1] == '.log':
      print("%-5s %-10s %s" % (p.pid,p.info['name'][:10],file.path))
# 689   auditd     /var/log/audit/audit.log
# 725   vmtoolsd   /var/log/vmware-vmsvc.log
# 974   tuned      /var/log/tuned/tuned.log

# 消耗超过5M内存的进程：
pp([(p.pid,p.info['name'],p.info['memory_info'].rss) for p in psutil.process_iter(attrs=['name','memory_info']) if p.info['memory_info'].rss > 5 * 1024 * 1024])
# [(1, 'systemd', 7118848),
#  (411, 'systemd-udevd', 6254592),
#  (712, 'polkitd', 13553664),
#  (716, 'abrtd', 5734400),
#  (724, 'VGAuthService', 6262784),
#  (725, 'vmtoolsd', 6426624),
#  (974, 'tuned', 19648512),
#  (1265, 'mysqld', 45268992),
#  (2204, 'sshd', 5726208),
#  (2429, 'ipython3', 37232640)]

# 消耗量最大的3个进程
pp([(p.pid, p.info) for p in sorted(psutil.process_iter(attrs=['name', 'memory_percent']), key=lambda p: p.info['memory_percent'])][-3:])
# [(974, {'memory_percent': 0.9451434561080659, 'name': 'tuned'}),
#  (2429, {'memory_percent': 1.7909847854955845, 'name': 'ipython3'}),
#  (1265, {'memory_percent': 2.177553778800572, 'name': 'mysqld'})]

# 消耗最多CPU时间的前3个进程
pp([(p.pid, p.info['name'], sum(p.info['cpu_times'])) for p in sorted(psutil.process_iter(attrs=['name', 'cpu_times']), key=lambda p: sum(p.info['cpu_times'][:2]))][-3:])
# [(1265, 'mysqld', 13.93),
#  (2429, 'ipython3', 14.809999999999999),
#  (725, 'vmtoolsd', 16.74)]

# 导致最多I/O的前3个进程
pp([(p.pid, p.info['name']) for p in sorted(psutil.process_iter(attrs=['name', 'io_counters']), key=lambda p: p.info['io_counters'] and p.info['io_counters'][:2])][-3:])
# [(2429, 'ipython3'), (725, 'vmtoolsd'), (1, 'systemd')]


# 前3个进程打开最多的文件描述符：
pp([(p.pid, p.info) for p in sorted(psutil.process_iter(attrs=['name', 'num_fds']), key=lambda p: p.info['num_fds'])][-3:])
# [(377, {'name': 'systemd-journald', 'num_fds': 24}),
#  (1, {'name': 'systemd', 'num_fds': 43}),
#  (1307, {'name': 'master', 'num_fds': 91})]
```

### 3.2 `argparse`教程

* **命令行与参数解析**

通俗来说,命令行与参数解析就是当你输入`cmd`打开`dos`交互界面时候,启动程序要进行的参数给定。比如在`dos`界面输入:

```sh
python openPythonFile.py "a" -b "number"
```
其中的"`a`",`-b`等就是命令行与参数解析要做的事。

`python`命令行与参数解析使用步骤

```
创建解析 -> 添加参数 -> 解析参数
```

下面通过一个例子进行简单创建:

```python
import argparse
# 创建解析步骤
parser = argparse.ArgumentParser(description='Process some integers.')
# 添加参数步骤
parser.add_argument('integers', metavar='N', type=int, nargs='+',
                   help='an integer for the accumulator')
parser.add_argument('--sum', dest='accumulate', action='store_const',
                   const=sum, default=max,
                   help='sum the integers')
# 解析参数步骤
args = parser.parse_args()
print(args.accumulate(args.integers))
```

在终端执行:`python test.py -h`。运行结果:

```sh
usage: test.py [-h] [--sum] N [N ...]
Process some integers.
positional arguments:
  N           an integer for the accumulator
optional arguments:
  -h, --help  show this help message and exit
  --sum       sum the integers
```

* **每个步骤的参数设定**

> * **创建解析过程参数设定**

```python
ArgumentParser(prog='', usage=None, description='Process some integers.', version=None,
              formatter_class=<class 'argparse.HelpFormatter'>, conflict_handler='error', add_help=True)
# 例如
parser = argparse.ArgumentParser(description='Process some integers.')
```

**`prog`(不建议更改)**

程序名称(默认`sys.argv[0]`,默认为函数文件名),设置`prog`则改变这一默认(仍使用上面那个实例):

```python
# 变更参数
parser = argparse.ArgumentParser(prog='sum or max',
                                description='Process some integers.')
# 运行结果
# 原始
usage: test.py [-h] [--sum] N [N ...]
# 变更后
usage: sum or max [-h] [--sum] N [N ...]
```

**`usage`(不建议更改)**

用于描述程序的使用用法(默认为添加到解析器中的参数)。在使用python xxx.py -h之后将出现。看例子:

```python
# 变更参数
parser = argparse.ArgumentParser(usage='python test.py arguments',
                                description='Process some integers.')
# 运行结果
# 原始
usage: test.py [-h] [--sum] N [N ...]
# 变更后
usage: python test.py arguments
```

**`description`**

描述文件的作用,上面实例已体现。

**`epilog`**

参数选项帮助后的显示文本。看例子:

```python
# 变更参数
epilog='And What can I help U?'
# 运行结果
optional arguments:
  -h, --help  show this help message and exit
  --sum       sum the intergers
And What can I help U?
```

**parents**

共享同一个父类解析器,由ArgumentParser对象组成的列表,它们的`arguments`选项会被包含到新`ArgumentParser`对象中,类似于继承。

**`formatter_class`(没必要改变)**

`help`信息输出格式共有三种形式:

> 1. `argparse.RawDescriptionHelpFormatter`:以输入格式输出,并不将其合并为一行
> 2. `argparse.RawTextHelpFormatter`:所有信息以输入格式输出,并不将其合并为一行
> 3. `argparse.ArgumentDefaultsHelpFormatter`:输出参数的defalut值

**`prefix_chars`(不建议改变)**

参数前缀,默认为`'-'`。前缀字符,放在文件名之前。当参数过多时,可以将参数放在文件中读取。看例子:

```python
>>> with open('args.txt', 'w') as fp:
...    fp.write('-f\nbar')
>>> parser = argparse.ArgumentParser(fromfile_prefix_chars='@')
>>> parser.add_argument('-f')
>>> parser.parse_args(['-f', 'tmp', '@args.txt'])
Namespace(f='bar')
```
例子中`parser.parse_args(['-f','foo','@args.txt'])`解析时会从文件`args.txt`读取,相当于`['-f','foo','-f','bar']`

**`conflict_handler`(最好不要修改)**

解决冲突的策略,默认情况下冲突会发生错误。

```python
>>> parser = argparse.ArgumentParser(prog='PROG')
>>> parser.add_argument('-f', '--foo', help='old foo help')
>>> parser.add_argument('--foo', help='new foo help')
Traceback (most recent call last):
 ..
ArgumentError: argument --foo: conflicting option string(s): --foo
```

**`add_help`(不建议修改)**

是否增加`-h/-help`选项(默认为`True`),一般`help`信息都是必须的。设为`False`时,`help`信息里面不再显示`-h –help`信息。

**`argument_default`**

设置一个全局的选项的缺省值,一般每个选项单独设置,基本没用。缺省为:`None`。

> * **添加参数过程参数设定**

```python
ArgumentParser.add_argument(name or flags...[, action][, nargs][, const][, default][, type][, choices][, required][, help][, metavar][, dest])

# 例如
parser.add_argument('intergers',metavar='N',type=int,nargs='+',help='an interger for the accumulator')
parser.add_argument('--sum',dest='accumulate',action='store_const',const=sum,default=max,help='sum the intergers (default:find the max)')
```

知识点:

> 1. 每一个参数都要单独设置,就像上面例子,需要两个参数就用两个add\_argument 。
> 2. 从上面的实例中也可以看到,参数分为两种:positional arguments和optional arguments。
> 3. positional arguments参数按照参数设置的先后顺序对应读取,实际中不用设置参数名,必须有序设计。
> 4. optional arguments参数在使用时必须使用参数名,然后是参数具体数值,设置可以是无序的。
> 5. 程序根据prefix\_chars(默认"-")自动识别positional arguments还是optional arguments。
> 6. prefix\_chars分为缩写(比如"-h")和对应的全写(比如"--help"),可以同时设置

参数设定详细解释:

**`name` or `flag`**

`optional arguments`以'`-`'(默认)为前缀的参数,其他的为`positional arguments`。上面例子已经有体现如何设定。

**`action`**

命令行参数的操作,操作的形式有以下几种:

> 1. `store`:仅仅存储参数的值(默认)
> 2. `storeconst`:存储`const`关键字指定的值,`parser.add_argument('-t',action='store_const',const=7)`
> 3. `store_true/store_false`:值为`True/False`,`parser.add_argument('-t',action='store_truet')`
> 4. `append`:值追加到`list`中(普通的`store`和`append`不是一样的?)
> 5. `append_const`:存为列表,会根据`const`关键参数进行添加

```python
>>> parser = argparse.ArgumentParser()
>>> parser.add_argument('--str', dest='types', action='append_const', const=str)
>>> parser.add_argument('--int', dest='types', action='append_const', const=int)
>>> parser.parse_args('--str --int --str --int'.split())
Namespace(l=None, types=[<type 'str'>, <type 'int'>, <type 'str'>, <type 'int'>])
```

**`count`**

统计参数出现的次数

```python
>>> parser = argparse.ArgumentParser()
>>> parser.add_argument('--counte', '-c', action='count')
>>> parser.parse_args('-cccc'.split())
Namespace(counte=4)
```

**`version`**

显示`version`信息

```python
>>> parser = argparse.ArgumentParser()
>>> parser.add_argument('--version', action='version', version='version 2.0')
>>> parser.parse_args(['--version'])
version 2.0
```

**`nrgs`**

参数的数量,有如下几个设定:

> 1. `N`:`N`个参数
> 2. `?`:首先从命令行中获取,若没有则从`const`中获取,仍然没有则从`default`中获取
> 3. `*/+`:任意多个参数

**`const`**

保存为一个常量,上面在讲`action`行为时已经解释用法。

**`default`**

默认值

**`type`**

参数类型,默认为`str`

**`choices`**

设置参数值的范围,如果`choices`中的类型不是字符串,记得指定`type`。看例子:

```python
>>> parser = argparse.ArgumentParser()
>>> parser.add_argument('x', type=int, choices=range(1, 4))
>>> parser.parse_args(['3'])
Namespace(x=3)
>>> parser.parse_args(['4'])
usage: [-h] {1,2,3}
: error: argument x: invalid choice: 4 (choose from 1, 2, 3)
```

**`required`**

是否为必选参数,默认为`True`

**`desk`**

参数别名,看例子:

```python
>>> parser = argparse.ArgumentParser()
>>> parser.add_argument('--foo', dest='f_name')
>>> parser.parse_args('--foo XXX'.split())
Namespace(f_name='XXX')
```

**`help`**

参数的帮助信息,即解释信息

**`metavar`**

帮助信息中显示的参数名称


**定义互斥参数**

```python
group = parser.add_mutually_exclusive_group()
group.add_argument("-v", "--verbose", action="store_true")
group.add_argument("-q", "--quiet", action="store_true")
```

> * **解析参数过程参数设定**

```python
>>> parser = argparse.ArgumentParser()
>>> parser.add_argument('x')
>>> a = parser.parse_args(['1'])
>>> a
Namespace(x='1')
>>> type(a)
<class 'argparse.Namespace'>
>>> a.x
'1'
```

一个完整的例子:

```python
import sys
import argparse

def cmd():
    args = argparse.ArgumentParser(description = 'Personal Information ',epilog = 'Information end ')
    #必写属性,第一位
    args.add_argument("name",         type = str,                  help = "Your name")
    #必写属性,第二位
    args.add_argument("birth",        type = str,                  help = "birthday")
    #可选属性,默认为None
    args.add_argument("-r",'--race',  type = str, dest = "race",   help = u"民族")
    #可选属性,默认为0,范围必须在0~150
    args.add_argument("-a", "--age",  type = int, dest = "age",    help = "Your age",         default = 0,      choices=range(150))
    #可选属性,默认为male
    args.add_argument('-s',"--sex",   type = str, dest = "sex",    help = 'Your sex',         default = 'male', choices=['male', 'female'])
    #可选属性,默认为None,-p后可接多个参数
    args.add_argument("-p","--parent",type = str, dest = 'parent', help = "Your parent",      default = "None", nargs = '*')
    #可选属性,默认为None,-o后可接多个参数
    args.add_argument("-o","--other", type = str, dest = 'other',  help = "other Information",required = False,nargs = '*')

    args = args.parse_args()#返回一个命名空间,如果想要使用变量,可用args.attr
    print "argparse.args=",args,type(args)
    print 'name = %s'%args.name
    d = args.__dict__
    for key,value in d.iteritems():
        print '%s = %s'%(key,value)

if __name__=="__main__":
    cmd()
```

### 3.3 `schedule`模块

官方文档:[`https://schedule.readthedocs.io/en/stable/`](https://schedule.readthedocs.io/en/stable/)


* **使用示例**

```python
import schedule
import time

def job():
    print("I'm working...")

def job1(name):        #带参数
    print(name)

schedule.every(10).minutes.do(job)              # 每10分钟执行一次
schedule.every().hour.do(job)                   # 每小时执行一次  
schedule.every().day.at("10:30").do(job)        # 每天10:30执行一次  
schedule.every().monday.do(job)                 # 每周星期一执行一次
schedule.every().wednesday.at("13:15").do(job)  # 每周星期三执行一次
schedule.every().wednesday.at("13:15").do(job1,'waiwen')  # 传入参数

while True:
    schedule.run_pending()
    time.sleep(1)
```

* **如何并行执行工作**


假如每10分钟运行50个任务,每个任务耗时1分钟,这样在下一个10分钟到来时,上一轮的任务仍在运行,然后又开始了新一轮的任务。解决这个问题的方法是,为每个任务创建一个线程,让任务在线程中运行,从而并行工作。

```python
import threading
import time
import schedule

def job():
    print("I'm running on thread %s" % threading.current_thread())

def run_threaded(job_func):
    job_thread = threading.Thread(target=job_func)
    job_thread.start()

schedule.every(10).seconds.do(run_threaded, job)
schedule.every(10).seconds.do(run_threaded, job)

while 1:
    schedule.run_pending()
    time.sleep(1)
```

* **使用队列**

使用queue队列共享,使用多个`worker_thread`。

```python
import Queue
import time
import threading
import schedule


def job():
    print("I'm working")

def worker_main():
    while 1:
        job_func = jobqueue.get()
        job_func()
        jobqueue.task_done()

jobqueue = Queue.Queue()

schedule.every(10).seconds.do(jobqueue.put, job)
schedule.every(10).seconds.do(jobqueue.put, job)
schedule.every(10).seconds.do(jobqueue.put, job)
schedule.every(10).seconds.do(jobqueue.put, job)
schedule.every(10).seconds.do(jobqueue.put, job)

worker_thread = threading.Thread(target=worker_main)
worker_thread.start()

while 1:
    schedule.run_pending()
    time.sleep(1)
```

* **只运行一次任务**

```python
def job_that_executes_once():
    # Do some work ...
    return schedule.CancelJob

schedule.every().day.at('22:30').do(job_that_executes_once)
```

* **取消任务**

```python
def greet(name):
    print('Hello {}'.format(name))

schedule.every().day.do(greet, 'Andrea').tag('daily-tasks', 'friend')
schedule.every().hour.do(greet, 'John').tag('hourly-tasks', 'friend')
schedule.every().hour.do(greet, 'Monica').tag('hourly-tasks', 'customer')
schedule.every().day.do(greet, 'Derek').tag('daily-tasks', 'guest')

schedule.clear('daily-tasks')
```

* **随机间隔内运行任务**

```python
def my_job():
    # This job will execute every 5 to 10 seconds.
    print('Foo')

schedule.every(5).to(10).seconds.do(my_job)
```

* **如何抛出异常**

模块不会主动抛出异常,但是可以使用装饰器捕获目标任务的异常。

```python
import functools

def catch_exceptions(job_func, cancel_on_failure=False):
    @functools.wraps(job_func)
    def wrapper(*args, **kwargs):
        try:
            return job_func(*args, **kwargs)
        except:
            import traceback
            print(traceback.format_exc())
            if cancel_on_failure:
                return schedule.CancelJob
    return wrapper

@catch_exceptions(cancel_on_failure=True)
def bad_task():
    return 1 / 0

schedule.every(5).minutes.do(bad_task)
```

### 3.4 `tqdm`模块

最主要的用法有3种,自动控制、手动控制或者用于脚本或命令行。参考:[`https://github.com/tqdm/tqdm`](https://github.com/tqdm/tqdm)

最基本的用法,将`tqdm()`直接包装在任意迭代器上。

```python
from tqdm import tqdm
import time

text = ""
for char in tqdm(["a", "b", "c", "d"]):
    time.sleep(0.25)
    text = text + char
```

`trange(i)`是对`tqdm(range(i))`特殊优化过的实例。

```python
for i in trange(100):
    time.sleep(0.1)
```

如果在循环之外实例化,可以允许对`tqdm()`手动控制。

```python
pbar = tqdm(["a", "b", "c", "d"])
for char in pbar:
  time.sleep(0.25)
  pbar.set_description("Processing %s" % char)
```

手动控制运行,用`with`语句手动控制`tqdm()`的更新。

```python
with tqdm(total=100) as pbar:
    for i in range(10):
        time.sleep(0.1)
        pbar.update(10)
```

或者不用with语句,但是最后需要加上`del`或者`close()`方法。

```python
pbar = tqdm(total=100)
for i in range(10):
    time.sleep(0.1)
    pbar.update(10)
pbar.close()
```

`tqdm.update()`方法用于手动更新进度条,对读取文件之类的流操作非常有用。

```python
t = tqdm(total=filesize) # Initialise
for current_buffer in stream:
  ...
  t.update(len(current_buffer))
t.close()
```
`tqdm`最常用的用法是在命令行:

```sh
> time find . -name '*.py' -type f -exec cat {} \; | tqdm | wc -l

> find . -name '*.py' -type f -exec cat {} \; | tqdm --unit loc --unit_scale --total 857366 >> /dev/null

> 7z a -bd -r backup.7z docs/ | grep Compressing | tqdm --total $(find docs/ -type f | wc -l) --unit files >> backup.log
```

给出`class tqdm`的初始化参数列表

```python
class tqdm():
  """
  Decorate an iterable object, returning an iterator which acts exactly
  like the original iterable, but prints a dynamically updating
  progressbar every time a value is requested.
  """

  def __init__(self, iterable=None, desc=None, total=None, leave=True,
               file=None, ncols=None, mininterval=0.1,
               maxinterval=10.0, miniters=None, ascii=None, disable=False,
               unit='it', unit_scale=False, dynamic_ncols=False,
               smoothing=0.3, bar_format=None, initial=0, position=None,
               postfix=None, unit_divisor=1000):
```

> `desc`:str,optional。进度条的前缀
> 
> `miniters`:int,optional。迭代过程中进度显示的最小更新间隔。
> 
> `unit`:str,optional。定义每个迭代的单元。默认为"it",即每个迭代,在下载或解压时,设为"B",代表每个"块"。
> 
> `unit_scale`:bool or int or float,optional。默认为False,如果设置为1或者True,会自动根据国际单位制进行转换 (kilo, mega, etc.)。比如，在下载进度条的例子中,如果为False,数据大小是按照字节显示,设为True之后转换为Kb、Mb。
> 
> `total`:总的迭代次数,不设置则只显示统计信息,没有图形化的进度条。设置为`len(iterable)`,会显示黑色方块的图形化进度条。

* **实时显示下载进度**

```python
from urllib.request import urlretrieve
from tqdm import tqdm

class TqdmUpTo(tqdm):
    # Provides `update_to(n)` which uses `tqdm.update(delta_n)`.

    last_block = 0
    def update_to(self, block_num=1, block_size=1, total_size=None):
        '''
        block_num  : int, optional
            到目前为止传输的块 [default: 1].
        block_size : int, optional
            每个块的大小 (in tqdm units) [default: 1].
        total_size : int, optional
            文件总大小 (in tqdm units). 如果[default: None]保持不变.
        '''
        if total_size is not None:
            self.total = total_size
        self.update((block_num - self.last_block) * block_size)  
        self.last_block = block_num

eg_link = "https://www.cs.toronto.edu/~kriz/cifar-10-python.tar.gz"
file = eg_link.split('/')[-1]
with TqdmUpTo(unit='B', unit_scale=True, unit_divisor=1024, miniters=1, desc=file) as t:  
  # 继承至tqdm父类的初始化参数
  urlretrieve(eg_link, filename=file, reporthook=t.update_to, data=None)
```

* **实时显示解压进度**

可以用`ZipFile.namelist()`返回整个压缩文件的名字列表,然后逐个解压。

```python
...
if not isdir('dir_path'):
    with ZipFile('imgs.zip', 'r') as zipf:   
        for name in tqdm(zipf.namelist()[:1000],desc='Extract files', unit='files'):
            zipf.extract(name, path='dir_path')
        zipf.close()
...
```

## 四、falsk教程

参考链接:https://juejin.im/post/5a32513ff265da430f321f3d

### 4.1 falsk介绍

* **Hello World**

```python
from flask import Flask
app = Flask(__name__)

@app.route('/')
def index():
    return '<h1>Hello World</h1>'

if __name__ == '__main__':
    app.run()
```

一个Web应用的代码就写完了,对,就是这么简单!保存为”hello.py”,打开控制台,到该文件目录下,运行`python hello.py`。如果看到

```sh
* Running on http://127.0.0.1:5000/ (Press CTRL+C to quit)
```

字样后,就说明服务器启动完成。打开你的浏览器,访问`http://127.0.0.1:5000/`,一个硕大的”Hello World”映入眼帘。

**简单解释这段代码**

首先引入了Flask包,并创建一个Web应用的实例”app”

```python
from flask import Flask
app = Flask(__name__)
```

这里给的实例名称就是这个python模块名。

**定义路由规则**

`@app.route('/')`:这个函数级别的注解指明了当地址是根路径时,就调用下面的函数。可以定义多个路由规则,说的高大上些,这里就是MVC中的Contoller。

**处理请求**

```python
def index():
    return '<h1>Hello World</h1>'
```

当请求的地址符合路由规则时,就会进入该函数。可以说,这里是MVC的Model层。你可以在里面获取请求的request对象,返回的内容就是response。本例中的response就是大标题”Hello World”。

**启动Web服务器**

```python
if __name__ == '__main__':
    app.run()
```

当本文件为程序入口(也就是用python命令直接执行本文件)时,就会通过app.run()启动Web服务器。如果不是程序入口,那么该文件就是一个模块。Web服务器会默认监听本地的5000端口,但不支持远程访问。如果你想支持远程,需要在run()方法传入host=0.0.0.0,想改变监听端口的话,传入port=端口号,你还可以设置调试模式。具体例子如下:

```python
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8888, debug=True)
```

注意,Flask自带的Web服务器主要还是给开发人员调试用的,在生产环境中,你最好是通过WSGI将Flask工程部署到类似Apache或Nginx的服务器上。

* **路由**

从Hello World中,我们了解到URL的路由可以直接写在其要执行的函数上。有人会质疑,这样不是把Model和Controller绑在一起了吗?的确,如果你想灵活的配置Model和Controller,这样是不方便,但是对于轻量级系统来说,灵活配置意义不大,反而写在一块更利于维护。Flask路由规则都是基于Werkzeug的路由模块的,它还提供了很多强大的功能。

**带参数的路由**

让我们在上一篇Hello World的基础上,加上下面的函数。并运行程序。

```python
@app.route('/hello/<name>')
def hello(name):
    return 'Hello %s' % name
```

当你在浏览器的地址栏中输入`http://localhost:5000/hello/man`,你将在页面上看到”Hello man”的字样。URL路径中`/hello/`后面的参数被作为hello()函数的name参数传了进来。你还可以在URL参数前添加转换器来转换参数类型,我们再来加个函数:

```python
@app.route('/user/<int:user_id>')
def get_user(user_id):
    return 'User ID: %d' % user_id
```

试下访问`http://localhost:5000/user/man`,你会看到404错误。但是试下`http://localhost:5000/user/123`,页面上就会有”User ID: 123”显示出来。参数类型转换器int:帮你控制好了传入参数的类型只能是整形。目前支持的参数类型转换器有:

| 类型转换器 | 作用 |
| :--- | --- |
| 缺省 | 字符型,但不能有斜杠 |
| `int:` | 整型 |
| `float:` | 浮点型 |
| `path:` | 字符型,可有斜杠 |

另外,大家有没有注意到,Flask自带的Web服务器支持热部署。当你修改好文件并保存后,Web服务器自动部署完毕,你无需重新运行程序。

**多URL的路由**

一个函数上可以设施多个URL路由规则

```python
@app.route('/')
@app.route('/hello')
@app.route('/hello/<name>')

def hello(name=None):
    if name is None:
        name = 'World'
    return 'Hello %s' % name
```

这个例子接受三种URL规则,`/`和`/hello`都不带参数,函数参数name值将为空,页面显示”Hello World”;`/hello/<name>`带参数,页面会显示参数name的值,效果与上面第一个例子相同。

* **HTTP请求方法设置**

HTTP请求方法常用的有Get,Post,Put,Delete。不熟悉的朋友们可以去Google查下。Flask路由规则也可以设置请求方法。

```python
from flask import request
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        return 'This is a POST request'
    else:
        return 'This is a GET request'
```
当你请求地址`http://localhost:5000/login`,”GET”和”POST”请求会返回不同的内容,其他请求方法则会返回405错误。有没有觉得用Flask来实现Restful风格很方便啊?

* **URL构建方法**

Flask提供了`url_for()`方法来快速获取及构建URL,方法的第一个参数指向函数名(加过`@app.route`注解的函数),后续的参数对应于要构建的URL变量。下面是几个例子:

```python
url_for('login')    # 返回/login
url_for('login', id='1')    # 将id作为URL参数,返回/login?id=1
url_for('hello', name='man')    # 适配hello函数的name参数,返回/hello/man
url_for('static', filename='style.css')    # 静态文件地址,返回/static/style.css
```

* **静态文件位置**

一个Web应用的静态文件包括了JS, CSS, 图片等,Flask的风格是将所有静态文件放在”static”子目录下。并且在代码或模板(下篇会介绍)中,使用`url_for('static')`来获取静态文件目录。如果你想改变这个静态目录的位置,你可以在创建应用时,指定`static_folder`参数。

```python
app = Flask(__name__, static_folder='files')
```

### 4.2 模板

Flask的模板功能是基于[Jinja2模板引擎](http://jinja.pocoo.org/)实现的。让我们来实现一个例子吧。创建一个新的Flask运行文件(你应该不会忘了怎么写吧),代码如下:

```python
from flask import Flask
from flask import render_template

app = Flask(__name__)
@app.route('/hello')
@app.route('/hello/<name>')
def hello(name=None):
    return render_template('hello.html', name=name)

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)
```

这段代码同上一篇的多URL路由的例子非常相似,区别就是hello()函数并不是直接返回字符串,而是调用了`render_template()`方法来渲染模板。方法的第一个参数hello.html指向你想渲染的模板名称,第二个参数name是你要传到模板去的变量,变量可以传多个。

那么这个模板hello.html在哪儿呢,变量参数又该怎么用呢?别急,接下来我们创建模板文件。在当前目录下,创建一个子目录”templates”(注意,一定要使用这个名字)。然后在”templates”目录下创建文件”hello.html”,内容如下:

```html
<!doctype html>
<title>Hello Sample</title>
{% if name %}
    <h1>Hello {{ name }}!</h1>
{% else %}
    <h1>Hello World!</h1>
{% endif %}
```

这段代码是不是很像HTML?接触过其他模板引擎的朋友们肯定立马秒懂了这段代码。它就是一个HTML模板,根据name变量的值,显示不同的内容。变量或表达式由`{{ }}`修饰,而控制语句由`{% %}`修饰,其他的代码,就是我们常见的HTML。

让我们打开浏览器,输入`http://localhost:5000/hello/man`,页面上即显示大标题”Hello man!“。我们再看下页面源代码

```html
<!doctype html>
<title>Hello from Flask</title>

    <h1>Hello man!</h1>
```

果然,模板代码进入了`Hello {{ name }}`!分支,而且变量`{{ name }}`被替换为了”man”。Jinja2的模板引擎还有更多强大的功能,包括for循环,过滤器等。模板里也可以直接访问内置对象如request, session等。对于Jinja2的细节,感兴趣的朋友们可以自己去查查。

* **模板继承**

一般我们的网站虽然页面多,但是很多部分是重用的,比如页首,页脚,导航栏之类的。对于每个页面,都要写这些代码,很麻烦。Flask的Jinja2模板支持模板继承功能,省去了这些重复代码。让我们基于上面的例子,在”templates”目录下,创建一个名为”layout.html”的模板:

```html
<!doctype html>
<title>Hello Sample</title>
<link rel="stylesheet" type="text/css" href="{{ url_for('static', filename='style.css') }}">
<div class="page">
    {% block body %}
    {% endblock %}
</div>
```

再修改之前的”hello.html”,把原来的代码定义在`{% block body %}`中,并在代码一开始”继承”上面的”layout.html”:

```html
{% extends "layout.html" %}
{% block body %}
{% if name %}
    <h1>Hello {{ name }}!</h1>
{% else %}
    <h1>Hello World!</h1>
{% endif %}
{% endblock %}
```

打开浏览器,再看下`http://localhost:5000/hello/man`页面的源码。

```html
<!doctype html>
<title>Hello Sample</title>
<link rel="stylesheet" type="text/css" href="/static/style.css">
<div class="page">
    <h1>Hello man!</h1>
</div>
```

你会发现,虽然`render_template()`加载了”hello.html”模板,但是”layout.html”的内容也一起被加载了。而且”hello.html”中的内容被放置在”layout.html”中`{% block body %}`的位置上。形象的说,就是”hello.html”继承了”layout.html”。

* **HTML自动转义**

我们看下下面的代码:

```python
@app.route('/')
def index():
    return '<div>Hello %s</div>' % '<em>Flask</em>'
```

打开页面,你会看到”Hello Flask”字样,而且”Flask”是斜体的,因为我们加了`<em>`标签。但有时我们并不想让这些HTML标签自动转义,特别是传递表单参数时,很容易导致HTML注入的漏洞。我们把上面的代码改下,引入”Markup”类:

```python
from flask import Flask, Markup

app = Flask(__name__)

@app.route('/')
def index():
    return Markup('<div>Hello %s</div>') % '<em>Flask</em>'
```

再次打开页面,`<em>`标签显示在页面上了。Markup还有很多方法,比如escape()呈现HTML标签, striptags()去除HTML标签。这里就不一一列举了。

### 4.3 Flask内建对象

Flask提供的内建对象常用的有request,session,g,通过request,你还可以获取cookie对象。这些对象不但可以在请求函数中使用,在模板中也可以使用。

* **请求对象request**

引入flask包中的request对象,就可以直接在请求函数中直接使用该对象了。

```python
from flask import request

@app.route('/login', methods=['POST', 'GET'])
def login():
    if request.method == 'POST':
        if request.form['user'] == 'admin':
            return 'Admin login successfully!'
        else:
            return 'No such user!'
    title = request.args.get('title', 'Default')
    return render_template('login.html', title=title)
```

在templates目录下,添加”login.html”文件

```html
{% extends "layout.html" %}
{% block body %}
<form name="login" action="/login" method="post">
    Hello {{ title }}, please login by:
    <input type="text" name="user" />
</form>
{% endblock %}
```

执行上面的例子,结果我就不多描述了。简单解释下,request中method变量可以获取当前请求的方法,即”GET”,“POST”,“DELETE”,“PUT”等;form变量是一个字典,可以获取”Post”请求表单中的内容,在上例中,如果提交的表单中不存在user项,则会返回一个KeyError,你可以不捕获,页面会返回400错误(想避免抛出这KeyError,你可以用`request.form.get('user')`来替代)。而request.args.get()方法则可以获取”Get”请求URL中的参数,该函数的第二个参数是默认值,当URL参数不存在时,则返回默认值。

* **会话对象session**

会话可以用来保存当前请求的一些状态,以便于在请求之前共享信息。我们将上面的python代码改动下:

```python
from flask import request, session

@app.route('/login', methods=['POST', 'GET'])
def login():
    if request.method == 'POST':
        if request.form['user'] == 'admin':
            session['user'] = request.form['user']
            return 'Admin login successfully!'
        else:
            return 'No such user!'
    if 'user' in session:
        return 'Hello %s!' % session['user']
    else:
        title = request.args.get('title', 'Default')
        return render_template('login.html', title=title)

app.secret_key = '123456'
```

你可以看到,”admin”登陆成功后,再打开”login”页面就不会出现表单了。session对象的操作就跟一个字典一样。特别提醒,使用session时一定要设置一个密钥app.secret_key,如上例。不然你会得到一个运行时错误,内容大致是RuntimeError: the session is unavailable because no secret key was set。密钥要尽量复杂,最好使用一个随机数,这样不会有重复,上面的例子不是一个好密钥。

我们顺便写个登出的方法,估计我不放例子,大家也都猜到怎么写,就是清除字典里的键值:

```python
from flask import request, session, redirect, url_for

@app.route('/logout')
def logout():
    session.pop('user', None)
    return redirect(url_for('login'))
```

* **构建响应**

在之前的例子中,请求的响应我们都是直接返回字符串内容,或者通过模板来构建响应内容然后返回。其实我们也可以先构建响应对象,设置一些参数(比如响应头)后,再将其返回。修改下上例中的”Get”请求部分:

```python
from flask import request, session, make_response

@app.route('/login', methods=['POST', 'GET'])
def login():
    if request.method == 'POST':
        ...
    if 'user' in session:
        ...
    else:
        title = request.args.get('title', 'Default')
        response = make_response(render_template('login.html', title=title), 200)
        response.headers['key'] = 'value'
        return response
```

打开浏览器调试,在”Get”请求用户未登录状态下,你会看到响应头中有一个key项。`make_response`方法就是用来构建response对象的,第二个参数代表响应状态码,缺省就是”200”。response对象的详细使用可参阅Flask的官方API文档。

* **Cookie的使用**

提到了Session,当然也要介绍Cookie喽,毕竟没有Cookie,Session就根本没法用。Flask中使用Cookie也很简单:

```python
from flask import request, session, make_response
import time

@app.route('/login', methods=['POST', 'GET'])
def login():
    response = None
    if request.method == 'POST':
        if request.form['user'] == 'admin':
            session['user'] = request.form['user']
            response = make_response('Admin login successfully!')
            response.set_cookie('login_time', time.strftime('%Y-%m-%d %H:%M:%S'))
        ...
    else:
        if 'user' in session:
            login_time = request.cookies.get('login_time')
            response = make_response('Hello %s, you logged in on %s' % (session['user'], login_time))
        ...

    return response
```

例子越来越长了,这次我们引入了time模块来获取当前系统时间。我们在返回响应时,通过`response.set_cookie()`函数,来设置Cookie项,之后这个项值会被保存在浏览器中。这个函数的第三个参数max_age可以设置该Cookie项的有效期,单位是秒,不设的话,在浏览器关闭后,该Cookie项即失效。在请求中,request.cookies对象就是一个保存了浏览器Cookie的字典,使用其get()函数就可以获取相应的键值。

* **全局对象g**

flask.g是Flask一个全局对象,这里有点容易让人误解,其实g的作用范围,就在一个请求(也就是一个线程)里,它不能在多个请求间共享。你可以在g对象里保存任何你想保存的内容。一个最常用的例子,就是在进入请求前,保存数据库连接。这个我们会在介绍数据库集成时讲到。

### 4.4 错误处理

使用abort()函数可以直接退出请求,返回错误代码:

```python
from flask import abort

@app.route('/error')
def error():
    abort(404)
```

上例会显示浏览器的404错误页面。有时候,我们想要在遇到特定错误代码时做些事情,或者重写错误页面,可以用下面的方法:

```python
@app.errorhandler(404)
def page_not_found(error):
    return render_template('404.html'), 404
```

此时,当再次遇到404错误时,即会调用`page_not_found()`函数,其返回”404.html”的模板页。第二个参数代表错误代码。不过,在实际开发过程中,我们并不会经常使用abort()来退出,常用的错误处理方法一般都是异常的抛出或捕获。装饰器`@app.errorhandler()`除了可以注册错误代码外,还可以注册指定的异常类型。让我们来自定义一个异常:

```python
class InvalidUsage(Exception):
    status_code = 400

    def __init__(self, message, status_code=400):
        Exception.__init__(self)
        self.message = message
        self.status_code = status_code

@app.errorhandler(InvalidUsage)
def invalid_usage(error):
    response = make_response(error.message)
    response.status_code = error.status_code
    return response
```

我们在上面的代码中定义了一个异常InvalidUsage,同时我们通过装饰器`@app.errorhandler()`修饰了函数invalid_usage(),装饰器中注册了我们刚定义的异常类。这也就意味着,一但遇到InvalidUsage异常被抛出,这个invalid_usage()函数就会被调用。写个路由试一试吧。

```python
@app.route('/exception')
def exception():
    raise InvalidUsage('No privilege to access the resource', status_code=403)
```

* **URL重定向**

重定向redirect()函数的使用在上一篇logout的例子中已有出现。作用就是当客户端浏览某个网址时,将其导向到另一个网址。常见的例子,比如用户在未登录时浏览某个需授权的页面,我们将其重定向到登录页要求其登录先。

```python
from flask import session, redirect

@app.route('/')
def index():
    if 'user' in session:
        return 'Hello %s!' % session['user']
    else:
        return redirect(url_for('login'), 302)
```

redirect()的第二个参数时HTTP状态码,可取的值有301,302,303,305和307,默认即302。

* **日志**

提到错误处理,那一定要说到日志。Flask提供logger对象,其是一个标准的Python Logger类。修改上例中的exception()函数:

```python
@app.route('/exception')
def exception():
    app.logger.debug('Enter exception method')
    app.logger.error('403 error happened')
    raise InvalidUsage('No privilege to access the resource', status_code=403)
```

执行后,你会在控制台看到日志信息。在debug模式下,日志会默认输出到标准错误stderr中。你可以添加FileHandler来使其输出到日志文件中去,也可以修改日志的记录格式,下面演示一个简单的日志配置代码:

```python
server_log = TimedRotatingFileHandler('server.log','D')
server_log.setLevel(logging.DEBUG)
server_log.setFormatter(logging.Formatter('%(asctime)s %(levelname)s: %(message)s'))

error_log = TimedRotatingFileHandler('error.log', 'D')
error_log.setLevel(logging.ERROR)
error_log.setFormatter(logging.Formatter('%(asctime)s: %(message)s [in %(pathname)s:%(lineno)d]'))

app.logger.addHandler(server_log)
app.logger.addHandler(error_log)
```

上例中,我们在本地目录下创建了两个日志文件,分别是”server.log”记录所有级别日志;”error.log”只记录错误日志。我们分别给两个文件不同的内容格式。另外,我们使用了TimedRotatingFileHandler并给了参数D,这样日志每天会创建一个新的文件,并将旧文件加日期后缀来归档。

* **消息闪现**

“Flask Message”是一个很有意思的功能,一般一个操作完成后,我们都希望在页面上闪出一个消息,告诉用户操作的结果。用户看完后,这个消息就不复存在了。Flask提供的flash功能就是为了这个。我们还是拿用户登录来举例子:

```python
from flask import render_template, request, session, url_for, redirect, flash

@app.route('/')
def index():
    if 'user' in session:
        return render_template('hello.html', name=session['user'])
    else:
        return redirect(url_for('login'), 302)

@app.route('/login', methods=['POST', 'GET'])
def login():
    if request.method == 'POST':
        session['user'] = request.form['user']
        flash('Login successfully!')
        return redirect(url_for('index'))
    else:
        return '''

        '''
```

上例中,当用户登录成功后,就用flash()函数闪出一个消息。让我们找回第三篇中的模板代码,在”layout.html”加上消息显示的部分:

```html
<!doctype html>
<title>Hello Sample</title>
<link rel="stylesheet" type="text/css" href="{{ url_for('static', filename='style.css') }}">
{% with messages = get_flashed_messages() %}
  {% if messages %}
    <ul class="flash">
    {% for message in messages %}
      <li>{{ message }}</li>
    {% endfor %}
    </ul>
  {% endif %}
{% endwith %}
<div class="page">
    {% block body %}
    {% endblock %}
</div>
```

上例中`get_flashed_messages()`函数就会获取我们在login()中通过flash()闪出的消息。从代码中我们可以看出,闪出的消息可以有多个。模板”hello.html”不用改。运行下试试。登录成功后,是不是出现了一条”Login successfully”文字?再刷新下页面,你会发现文字消失了。你可以通过CSS来控制这个消息的显示方式。

flash()方法的第二个参数是消息类型,可选择的有”message”, “info”, “warning”, “error”。你可以在获取消息时,同时获取消息类型,还可以过滤特定的消息类型。只需设置`get_flashed_messages()`方法的`with_categories`和`category_filter`参数即可。比如,python部分可改为:

```python
@app.route('/login', methods=['POST', 'GET'])
def login():
    if request.method == 'POST':
        session['user'] = request.form['user']
        flash('Login successfully!', 'message')
        flash('Login as user: %s.' % request.form['user'], 'info')
        return redirect(url_for('index'))
    ...
```

layout模板部分可改为:

```html
...
{% with messages = get_flashed_messages(with_categories=true, category_filter=["message","error"]) %}
  {% if messages %}
    <ul class="flash">
    {% for category, message in messages %}
        <li class="{{ category }}">{{ category }}: {{ message }}</li>
    {% endfor %}
    </ul>
  {% endif %}
{% endwith %}
...
```

运行结果大家就自己试试吧。

### 4.5 集成数据库

既然前几篇都用用户登录作为例子,我们这篇就继续讲登录,只是登录的信息会由数据库来验证。让我们先准备SQLite环境吧。

* **初始化数据库**

怎么安装SQLite这里就不说了。我们先写个数据库表的初始化SQL,保存在”init.sql”文件中:

```python
DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  password TEXT NOT NULL
);

INSERT INTO users (name, password) VALUES ('visit', '111');
INSERT INTO users (name, password) VALUES ('admin', '123');
```

运行sqlite3命令,初始化数据库。我们的数据库文件就放在”db”子目录下的”user.db”文件中。

```sh
$ sqlite3 db/user.db < init.sql
```
* **配置连接参数**

创建配置文件”config.py”,保存配置信息:

```python
#coding:utf8
DATABASE = 'db/user.db'       # 数据库文件位置
DEBUG = True                  # 调试模式
SECRET_KEY = 'secret_key_1'   # 会话密钥
```

在创建Flask应用时,导入配置信息:

```python
from flask import Flask
import config

app = Flask(__name__)
app.config.from_object('config')
```

这里也可以用`app.config.from_envvar('FLASK_SETTINGS', silent=True)`方法来导入配置信息,此时程序会读取系统环境变量中`FLASK_SETTINGS`的值,来获取配置文件路径,并加载此文件。如果文件不存在,该语句返回False。参数`silent=True`表示忽略错误。

* **建立和释放数据库连接**

这里要用到请求的上下文装饰器。

```python
@app.before_request
def before_request():
    g.db = sqlite3.connect(app.config['DATABASE'])

@app.teardown_request
def teardown_request(exception):
    db = getattr(g, 'db', None)
    if db is not None:
        db.close()
```

我们在`before_request()`里建立数据库连接,它会在每次请求开始时被调用;并在`teardown_request()`关闭它,它会在每次请求关闭前被调用。

* **查询数据库**

让我们取回上一篇登录部分的代码,index()和logout()请求不用修改,在login()请求中,我们会查询数据库,验证客户端输入的用户名和密码是否存在:

```python
@app.route('/login', methods=['POST', 'GET'])
def login():
    if request.method == 'POST':
        name = request.form['user']
        passwd = request.form['passwd']
        cursor = g.db.execute('select * from users where name=? and password=?', [name, passwd])
        if cursor.fetchone() is not None:
            session['user'] = name
            flash('Login successfully!')
            return redirect(url_for('index'))
        else:
            flash('No such user!', 'error')
            return redirect(url_for('login'))
    else:
        return render_template('login.html')
```

模板中加上”login.html”文件

```html
{% extends "layout.html" %}
{% block body %}
<form name="login" action="/login" method="post">
    Username: <input type="text" name="user" /><br>
    Password: <input type="password" name="passwd" /><br>
    <input type="submit" value="Submit" />
</form>
{% endblock %}
```

终于一个真正的登录验证写完了(前几篇都是假的),打开浏览器登录下吧。

### 4.6 Vue.js和Flask构建单页App

参考连接:[`https://juejin.im/post/5ab0a21df265da23a228efd3`](https://juejin.im/post/5ab0a21df265da23a228efd3)

建立一个单页应用程序(应用程序使用单页组成,vue-router在HTML5的History-mode以及其他更多好用的功能)用vue.js,由Flask提供Web服务?简单地说应该这样,如下所示:

> * Flask为index.html服务,index.html包含我的vue.js App。
> * 在前端开发中我使用Webpack,它提供了所有很酷的功能。
> * Flask有API端,可以从我的SPA访问。
> * 可以访问API端,甚至当为了前端开发而运行Node.js的时候。

#### 4.6.1 客户端

将使用Vue CLI产生基本vue.js App。如果你还没有安装它,请运行:`npm install -g vue-cli`,客户端和后端代码将被拆分到不同的文件夹。初始化前端部分运行跟踪:

```shell
mkdir flaskvue
cd flaskvue
vue create frontend
cd frontend
npm install
# after installation
npm run dev
```

添加`home.vue`和`about.vue`到`frontend/src/components`文件夹。它们非常简单,像这样:

```html
// Home.vue
<template>
    <div>
        <p>Home page</p>
    </div>
</template>

// About.vue
<template>
    <div>
        <p>About</p>
    </div>
</template>
```

我们将使用它们正确地识别我们当前的位置(根据地址栏)。现在我们需要改变`frontend/src/router/index.js`文件以便使用我们的新组件:

```html
import Vue from 'vue'
import Router from 'vue-router'
const routerOptions = [
    { path: '/', component: 'Home' },
    { path: '/about', component: 'About' }
]

const routes = routerOptions.map(route => {
    return {
        route,
        component: () => import(`@/components/${route.component}.vue`)
    }
})

Vue.use(Router)
export default new Router({
    routes,
    mode: 'history'
})
```

如果你试着输入`localhost:8080`和`localhost:8080/about`,你应该看到相应的页面。我们几乎已经准备好构建一个项目,并且能够创建一个静态资源文件包。在此之前,让我们为它们重新定义一下输出目录。在`frontend/config/index.js`找到下一个设置:

```shell
index: path.resolve(__dirname, '../dist/index.html'),
assetsRoot: path.resolve(__dirname, '../dist'),
```

把它们改为

```shell
index: path.resolve(__dirname, '../../dist/index.html'),
assetsRoot: path.resolve(__dirname, '../../dist'),
```

所以`/dist`文件夹的HTML、CSS、JS会在同一级目录`/frontend`。现在你可以运行npm run build创建一个包。

#### 4.6.2 后端

对于Flask服务器,我将使用Python版本3.6。在/flaskvue创建新的子文件夹存放后端代码并初始化虚拟环境:

```shell
# 需要安装flask: pip install Flask
mkdir backend
cd backend
```

现在让我们为Flask服务端编写代码。创建根目录文件run.py:

```python
from flask import Flask, render_template
app = Flask(__name__, static_folder = "./dist/static", template_folder = "./dist")
    
@app.route('/')
def index():
    return render_template("index.html")
```

这段代码与Flask的**“Hello World”**代码略有不同。主要的区别是,我们指定存储静态文件和模板位置在文件夹/dist,以便和我们的前端文件夹区别开。在根文件夹中运行Flask服务端:`FLASK_APP=run.py FLASK_DEBUG=1 flask run`

这将启动本地主机上的Web服务器:localhost:5000上的FLASK_APP服务器端的启动文件,flask_debug=1将运行在调试模式。如果一切正确,你会看到熟悉的主页,你已经完成了对Vue的设置。

同时,如果您尝试输入`/about`页面,您将面临一个错误。Flask抛出一个错误,说找不到请求的URL。事实上,因为我们使用了HTML5的History-Mode在Vue-router需要配置Web服务器的重定向,将所有路径指向index.html。用Flask做起来很容易。将现有路由修改为以下:

```python
@app.route('/', defaults={'path': ''})
@app.route('/<path:path>')
def catch_all(path):
    return render_template("index.html")
```

现在输入网址localhost:5000/about将重新定向到index.html和vue-router将处理路由。

#### 4.6.3 404页

因为我们有一个包罗万象的路径,我们的Web服务器在现在已经很难赶上404错误,Flask将所有请求指向index.html(甚至不存在的页面)。所以我们需要处理未知的路径在vue.js应用。当然,所有的工作都可以在我们的路由文件中完成。

在`frontend/src/router/index.js`添加下一行:

```shell
const routerOptions = [
    { path: '/', component: 'Home' },
    { path: '/about', component: 'About' },
    { path: '*', component: 'NotFound' }
]
```

这里的路径'`*`'是一个通配符, Vue-router就知道除了我们上面定义的所有其他任何路径。现在我们需要更多的创造NotFound.vue文件在**/components**目录。试一下很简单:

```html
// NotFound.vue
<template>
    <div>
        <p>404 - Not Found</p>
    </div>
</template>
```

现在运行的前端服务器再次npm run dev,尝试进入一些毫无意义的地址例如:`localhost:8080/gljhewrgoh`。您应该看到我们的“未找到”消息。

#### 4.6.4 API端

我们的`vue.js/flask`教程的最后一个例子将是服务器端API创建和调度客户端。我们将创建一个简单的Api,它将从1到100返回一个随机数。打开run.py并添加:

```python
from flask import Flask, render_template, jsonify
from random import *

app = Flask(__name__,static_folder = "./dist/static", template_folder = "./dist")

@app.route('/api/random')
def random_number():
    response = {
        'randomNumber': randint(1, 100)
    }
    return jsonify(response)

@app.route('/', defaults={'path': ''})
@app.route('/<path:path>')
def catch_all(path):
    return render_template("index.html")
```

首先我导入random库和jsonify函数从Flask库中。然后我添加了新的路由`/api/random`来返回像这样的JSON:

```python
{
    "randomNumber": 36
}
```

你可以通过本地浏览测试这个路径:`localhost:5000/api/random`。此时服务器端工作已经完成。是时候在客户端显示了。我们来改变home.vue组件显示随机数:

```html
<template>
    <div>
        <p>Home page</p>
        <p>Random number from backend: {{ randomNumber }}</p>
        <button @click="getRandom">New random number</button>
    </div>
</template>
<script>
    export default {
        data () {
            return { randomNumber: 0 }
        },

        methods: {
            getRandomInt (min, max) {
                min = Math.ceil(min)
                max = Math.floor(max)
                return Math.floor(Math.random() * (max - min + 1)) + min
            },

            getRandom () {
                this.randomNumber = this.getRandomInt(1, 100)
            }
        },
        created () {
            this.getRandom()
        }
    }
</script>
```

在这个阶段,我们只是模仿客户端的随机数生成过程。所以,这个组件就是这样工作的:

> * 在初始化变量 randomNumber等于0。
> * 在methods部分我们通过getRandomInt(min, max)功能来从指定的范围内返回一个随机数,getrandom函数将生成随机数并将赋值给randomNumber
> * 组件方法getrandom创建后将会被调用来初始化随机数
> * 在按钮的单击事件我们将用getrandom方法得到新的随机数

现在在主页上,你应该看到前端显示我们产生的随机数。让我们把它连接到后端。为此目的,我将用axios库。它允许我们用响应HTTP请求并用Json返回JavaScript Promise。我们安装下它:

```shell
cd frontend
npm install --save axios
```

打开home.vue再在`<script>`部分添加一些变化:

```html
import axios from 'axios'
methods: {
    getRandom () {
        // this.randomNumber = this.getRandomInt(1, 100)
        this.randomNumber = this.getRandomFromBackend()
    },

    getRandomFromBackend () {
        const path = `http://localhost:5000/api/random`
        axios.get(path).then(response => {
            this.randomNumber = response.data.randomNumber
        }).catch(error => {
            console.log(error)
        })
    }
}
```

在顶部,我们需要引用Axios库。然后有一个新的方法getrandomfrombackend将使用Axios异步调用API和检索结果。最后,getrandom方法现在应该使用getrandomfrombackend函数得到一个随机值。

保存文件,到浏览器,运行一个开发服务器再次刷新localhost:8080。你应该看到控制台错误没有随机值。但别担心,一切都正常。我们得到了CORS的错误意味着Flask服务器API默认会关闭其他Web服务器(在我们这里,vue.js App是在Node.js服务器上运行的应用程序)。如果你npm run build项目,那在localhost:5000(如Flask服务器)你会看到App在工作的。但是,每次对客户端应用程序进行一些更改时,都创建一个包并不十分方便。

让我们用打包了CORS插件的Flask,将使我们能够创建一个API访问规则。插件叫做Flask CORS,让我们安装它:

```python
pip install -U flask-cors
```

你可以阅读文档,更好的解释你要使你的服务器怎么样使用CORS。我将使用特定的方法,并将**`{“origins”: “*”}`**应用于所有`/api/*`路由(这样每个人都可以使用我的API端)。在run.py加上:

```python
from flask_cors import CORS
app = Flask(__name__, static_folder = "./dist/static", template_folder = "./dist")
cors = CORS(app, resources={r"/api/*": {"origins": "*"}})
```

有了这种改变,您就可以从前端调用服务端。事实上,如果你想通过Flask提供静态文件不需要CORS。这个主意是这样的。如果应用程序在调试模式下,它只会代理我们的前端服务器。否则(在生产中)只为静态文件服务。所以我们这样做:

```python
import requests
@app.route('/', defaults={'path': ''})
@app.route('/<path:path>')
def catch_all(path):
    if app.debug:
        return requests.get('http://localhost:8080/{}'.format(path)).text
    return render_template("index.html")
```

### 4.7 Web服务器网关接口

#### 4.7.1 前言

本文档是`PEP 333`的升级版,针对`python 3`进行了可用性方面的细微修改,采纳了几个针对`WSGI`协议的存在已久的事实修订(相关代码示例也已经移植到`python 3`)。

由于流程上的原因,本次修改是独立的,不会影响到`python 2.x`下服务端或应用端的程序。如果你的程序遵守`PEP 333`,则它必然符合此次升级后的要求。

但是如果你的程序运行在`python 3`环境下,则必须注意下文中"字符串类型"和"`Unicode`编码"两节中的要求。

#### 4.7.2 摘要

本文档描述了Web服务器与Web应用或框架的标准交互接口,以提高`python` `Web`应用在不同`Web`服务器之间具有可移植性。

#### 4.7.3 基本原理和目标

`python`目前有很多`Web`框架,比如`Zope`,`Quixote`,`Webware`,`SkunkWeb`,`PSO`和`Twisted`等等。新手面对如此多的选择十分纠结,因为一般来说,框架的选择会限制他们对`Web`服务器的选择,反之亦然。相比之下,`Java`也有非常多的`Web`框架,但是它的`servlet API`使得用户无论选择哪种框架,都可以保证程序正常运行在支持该`API`的任何`Web`服务器上。

无论`Web`服务器是由`python`写成,还是内嵌`python`,抑或使用`CGI`和`FastCGI`之类的网关协议调用`python`,在`Python`世界推广类似的`API`将使`Web`框架的选择与`Web`服务器无关,使框架和服务端的开发者能够专注于他们各自的领域。因此本文档提出了一种简单且通用的接口以完成`Web`服务器与应用和框架的交互:`Python` `Web`服务器网关接口(WSGI)。

不过仅仅一个`WSGI`的存在并不足以缓解当前`Python` `Web`开发中的困境,只有在服务端和框架中真的实现了`WSGI`才行。由于现有的服务端和框架并不支持`WSGI`,必须给哪些愿意支持`WSGI`的开发者们一点好处,故`WSGI`必须易于实现,以保证实现它的代价比较小。因此,在服务端和框架中都容易实现对于`WSGI`的实用性至关重要,也是所有设计决策的主要考量。

在`Web`框架中易于实现并不代表对`Web`应用开发者也易用。`WSGI`向`Web`框架开发者提供了绝对简洁的接口,因为类似响应对象(response objects)和`cookie`管理这样锦上添花的功能只会妨碍现有框架本身对应的功能。重申一遍,`WSGI`的目标是使现有`Web`服务器与`Web`应用或框架的交互变得更容易,而不是发明一个新的`Web`框架。

这个目标要求`WSGI`不能依赖于任何在当前已部署的`Python`环境中不支持的功能。所以本次升级并没有产生新的标准库,且只要求用户的`Python`环境版本不低于`2.2.2`(不过在未来的`Web`服务器标准库中集成新标准应该是一个不错的选择)。

除了在现有和未来出现的框架和服务端易于集成之外,`WSGI`还应该能很容易地创建请求预处理器、响应处理程序和其他基于`WSGI`的中间件组件(对于`Web`服务器它们是应用,但对于它们包含的应用来说则是服务器)。

如果中间件能够既简洁又健壮,`WSGI`又在服务端和框架中广泛应用,这将使一种全新的`Python` `Web`框架得以出现:一种由各种松耦合的`WSGI`中间件组成的框架。现有的框架开发者们甚至会重构他们的现有服务,使他们的框架更像一些和`WSGI`配合的库而不是一个独立的框架。这样`Web`应用开发者就可以针对特定的需求选择最好的组件,而不是只能接受某一个框架的所有优点和缺点。

当然,前途是光明的,道路是曲折的,`WSGI`的短期目标是先让任意框架可以与任意`Web`服务器交互。

最后需要注意的是,当前版本的`WSGI`并没有规定一个应用具体以何种方式部署在`Web`服务器或网关服务器上,目前这由二者的具体实现决定。如果足够多实现了`WSGI`的服务器或网关在实践中产生了这个需求,也许可以另写一份`PEP`来描述`WSGI`服务器和应用框架的部署标准。

#### 4.7.4 概述

`WSGI`接口有两种形式:服务端和应用端。服务端请求一个由应用端提供的可调用的对象,至于该对象应当如何被提供取决于服务端。有些服务端需要应用程序的部署人员编写一个简短的脚本来启动一个`Web`服务器或网关服务器的实例,以为此实例提供所需对象;而另一些服务端则需要配置文件或其他机制来指定从哪里导入或者得到所需对象。

除了`Web`服务器/网关服务器和`Web`应用/开发框架,还可以创建包含两种接口的中间件组件:对于`Web`服务器它们是应用,而对于应用来说他们是服务器。中间件可以用来提供扩展`API`,内容转换,导航和其他有用的功能。

在本文档中,我们使用术语`可调用者`代表`一个函数,方法,类,或者拥有__call__ 方法的一个实例`。实现`可调用者`的`Web`服务器,网关服务器或应用程序可以根据需要选择合适的实现方式;相反,请求`可调用者`的`Web`服务器,网关服务器或应用程序不可以依赖具体的实现方式。`可调用者`只能被调用,不能自省。

##### 4.7.4.1 字符串类型

一般来说,`HTTP`协议处理字节流,也就是说本文档主要面向字节流的处理。不过字节流经常是文本意义上可读的,而在`Python`中,字符串类型是处理文本的趁手工具。

但是在很多`Python`的版本和实现中,字符串是`Unicode`编码的,而不是字节流。这要求我们在`HTTP`字节流与文本的相互转换和好用的`API`之间保持很好的平衡,尤其要注意支持基于不同版本的`Python`程序之间的可移植性,这些版本中字符串类型不尽相同。

因此`WSGI`定义了两种字符串类型:

> 原生字符串(一般使用`str`类型实现),这种字符串用在请求和响应的包头和元数据中。
> 
> 字节流字符串(在`Python 3`中使用`bytes`类型实现,其他版本中使用`str`类型实现),这种字符串用在请求和响应的包内容中(比如`POST`方法或`PUT`方法的输入数据以及`HTML`页面的输出)。

大家一定要注意不要搞混了:即使`Python`的`str`类型实质上是`Unicode`编码的,但是原生字符串的内容仍然将通过`Latin-1`编码转换为字节流(参见下文`Unicode编码`一节可获得更多信息)。

简而言之,本文档中的`字符串`这个词都是指`原生字符串`,亦即一个`str`类型的对象,无论其实质上是字节流还是`Unicode`编码。任何地方出现的`字节流字符串`,都是指`Python 3`下`bytes`类型的一个实例,或者`Python 2`下`str`类型的一个实例。

因此,虽然`HTTP`某种意义上来说就是字节流,使用`Python`默认的字符串类型来解析会带来不少`API`使用上的好处。

##### 4.7.4.2 应用端接口

应用对象是一个简单的接受两个参数的可调用对象。这里的对象并不是真的需要一个对象实例,一个函数、方法、类、或者带有`__call__`方法的对象实例都可以当作应用对象。应用对象必须可以多次被调用,因为实际上所有的服务端(而非`CGI`)都会产生这样的重复请求。

(注意:虽然我们称之为`应用`对象,但这并不是说程序员可以把`WSGI`当做`Web`编程`API`来调用!我们假定应用开发者仍然使用更高层面上的框架服务来开发应用,`WSGI`是提供给框架和`Web`服务器开发者使用的工具,并不打算直接对应用开发者提供支持。)

这里有两个应用对象的示例,一个是函数,另一个是类:

```python
HELLO_WORLD = b”Hello world!n”

def simple_app(environ, start_response):
    """
    Simplest possible application object
    """ 
    status = ‘200 OK’ 
    response_headers = [(‘Content-type’, ‘text/plain’)] 
    start_response(status, response_headers) 
    return [HELLO_WORLD]

class AppClass:
    """
    Produce the same output, but using a class

    (Note: ‘AppClass’ is the “application” here, so calling it returns an instance of ‘AppClass’, which \
    is then the iterable return value of the “application callable” as required by the spec.

    If we wanted to use instances of ‘AppClass’ as application objects instead, we would have to implement \
    a ‘__call__’ method, which would be invoked to execute the application, and we would need to create an \
    instance for use by the server or gateway. 
    """

def __init__(self, environ, start_response):
    self.environ = environ 
    self.start = start_response

def __iter__(self):
    status = ‘200 OK’ 
    response_headers = [(‘Content-type’, ‘text/plain’)] 
    self.start(status, response_headers) 
    yield HELLO_WORLD
```

##### 4.7.4.3 服务端接口

服务端为`HTTP`客户端发来的每一个请求调用一次可调用者,这是由应用决定的。为了方便说明,这里以一个获取应用对象的函数实现了一个简单的`CGI`网关。请注意,这个例子的错误处理功能很有限,因为默认情况下没有被捕获的异常都会被输出到`sys.stderr`并被`Web`服务器记录下来。

```python
import os, sys

enc, esc = sys.getfilesystemencoding(), 'surrogateescape'

def unicode_to_wsgi(u):
    # Convert an environment variable to a WSGI "bytes-as-unicode" string
    return u.encode(enc, esc).decode('iso-8859-1')

def wsgi_to_bytes(s):
    return s.encode('iso-8859-1')

def run_with_cgi(application):
    environ = {k: unicode_to_wsgi(v) for k,v in os.environ.items()}
    environ['wsgi.input']        = sys.stdin.buffer
    environ['wsgi.errors']       = sys.stderr
    environ['wsgi.version']      = (1, 0)
    environ['wsgi.multithread']  = False
    environ['wsgi.multiprocess'] = True
    environ['wsgi.run_once']     = True

    if environ.get('HTTPS', 'off') in ('on', '1'):
        environ['wsgi.url_scheme'] = 'https'
    else:
        environ['wsgi.url_scheme'] = 'http'

    headers_set = []
    headers_sent = []

    def write(data):
        out = sys.stdout.buffer

        if not headers_set:
             raise AssertionError("write() before start_response()")

        elif not headers_sent:
             # Before the first output, send the stored headers
             status, response_headers = headers_sent[:] = headers_set
             out.write(wsgi_to_bytes('Status: %s\r\n' % status))
             for header in response_headers:
                 out.write(wsgi_to_bytes('%s: %s\r\n' % header))
             out.write(wsgi_to_bytes('\r\n'))

        out.write(data)
        out.flush()

    def start_response(status, response_headers, exc_info=None):
        if exc_info:
            try:
                if headers_sent:
                    # Re-raise original exception if headers sent
                    raise exc_info[1].with_traceback(exc_info[2])
            finally:
                exc_info = None     # avoid dangling circular ref
        elif headers_set:
            raise AssertionError("Headers already set!")

        headers_set[:] = [status, response_headers]

        # Note: error checking on the headers should happen here,
        # *after* the headers are set.  That way, if an error
        # occurs, start_response can only be re-called with
        # exc_info set.

        return write

    result = application(environ, start_response)
    try:
        for data in result:
            if data:    # don't send headers until body appears
                write(data)
        if not headers_sent:
            write('')   # send headers now if body was empty
    finally:
        if hasattr(result, 'close'):
            result.close()
```

##### 4.7.4.4 中间件:分饰两角的组件

同一个对象既可以作为服务端存在,也可以作为应用端存在。这样的中间件可以完成以下功能:

> 重写上文代码中的`environ`之后,可以根据目标`URL`将请求转发到不同的应用程序对象
> 
> 允许多个应用程序或框架在一个进程中同时运行
> 
> 通过转发请求和响应,实现负载均衡和远程处理
> 
> 对内容进行后期处理,比如引入`XSL`样式表
> 
> 中间件的存在对于服务端和应用端来说都应该是透明的,并且不需要特殊的支持。

希望在应用程序中加入中间件的用户只需简单的把中间件当作应用提供给`Web`服务器,并配置中间件使其以服务器的身份与应用程序交互即可。当然,中间件包装后提供给服务器的应用也可以是另一个中间件,如此连锁下去便构成了所谓的`中间件栈`。

一般情况下,中间件要符合`WSGI`对应用端和服务端提出的一些限制和要求,有些时候这样的限制甚至比纯粹的服务端或应用端还要严格,这些地方我们会特别指出。

下面是一个非正式的中间件组件的示例,使用`Joe Strout`的`piglatin.py`将`text/plain`的响应转换成儿童黑话(注意:真正的中间件应该使用更加安全的方式——应该检查内容的类型和编码,而且这个简单的例子还忽略了一个单词可能会被拆分到两个包中的可能性)。

```python
from piglatin import piglatin

class LatinIter:
    """
    Transform iterated output to piglatin, if it's okay to do so

    Note that the "okayness" can change until the application yields
    its first non-empty bytestring, so 'transform_ok' has to be a mutable
    truth value.
    """

    def __init__(self, result, transform_ok):
        if hasattr(result, 'close'):
            self.close = result.close
        self._next = iter(result).__next__
        self.transform_ok = transform_ok

    def __iter__(self):
        return self

    def __next__(self):
        if self.transform_ok:
            return piglatin(self._next())   # call must be byte-safe on Py3
        else:
            return self._next()

class Latinator:
    # by default, don't transform output
    transform = False

    def __init__(self, application):
        self.application = application

    def __call__(self, environ, start_response):

        transform_ok = []

        def start_latin(status, response_headers, exc_info=None):

            # Reset ok flag, in case this is a repeat call
            del transform_ok[:]

            for name, value in response_headers:
                if name.lower() == 'content-type' and value == 'text/plain':
                    transform_ok.append(True)
                    # Strip content-length if present, else it'll be wrong
                    response_headers = [(name, value)
                        for name, value in response_headers
                            if name.lower() != 'content-length'
                    ]
                    break

            write = start_response(status, response_headers, exc_info)

            if transform_ok:
                def write_latin(data):
                    write(piglatin(data))   # call must be byte-safe on Py3
                return write_latin
            else:
                return write

        return LatinIter(self.application(environ, start_latin), transform_ok)

# Run foo_app under a Latinator's control, using the example CGI gateway
from foo_app import foo_app
run_with_cgi(Latinator(foo_app))
```

##### 4.7.4.5 细则

应用对象必须接受两个形式参数,为了方便说明我们不妨分别命名为`environ`和`start_response`,但这并不是强制的。服务端必须使用形式参数(而非关键字)调用应用对象(就像这样:`result = application(environ, start_response)`)。

`environ`参数是个字典对象,包含`CGI`风格的环境变量。这个对象必须是一个`Python`内建的字典对象(不能是子类、`UserDict`或其他对字典对象的模仿),应用程序可以以任意方式修改这个字典。`environ`还应该包含一些特定的`WSGI`所需的变量(在后面的小节里会详述),也可以包含一些服务器特定的扩展变量,通过下文的约定命名。

`start_response`参数是一个接受两个固定参数和一个可选参数的可调用者。为了方便说明,我们分别命名为`status`、`response_headers`和`exc_info`,同样的,这样命名也不是强制的。应用程序必须用形式参数来调用`start_response`(就像这样:`start_response(status,response_headers)`)。

`status`参数是一个形式上像`999 Message here`这样的状态字符串。而`response_headers`参数是一个(`header_name`,`header_value`)元组的列表,用来描述`HTTP`响应头。可选的`exc_info` 参数会在下面的`start_response()函数`和`错误处理`两节中详述,它只有在应用程序产生了错误并希望在浏览器上显示相关信息的时候才有用。

`start_response`可调用者必须返回一个`write(body_data)`可调用者,它接受一个形式参数:一个将要被作为`HTTP`响应体的一部分输出的字节流字符串(注意:提供可调用者`write()`只是为了支持现有框架的必要的输出`API`,新的应用程序或框架尽量避免使用,详细情况参见`缓冲区和流处理`一节)。

当被服务器调用的时候,应用对象必须返回一个生成`0`或多个字节流字符串的迭代器,这可以通过多种方法实现,比如返回一个字节流字符串的列表,或者应用程序本身是一个字节流字符串的生成器,或者应用程序是一个类而其实例是可迭代的.不管怎么实现,应用对象必须总是返回一个生成`0`或多个字节流字符串的迭代器。

服务器端必须将生成的字节流字符串以一种无缓冲的方式传送到客户端,每次传完一个再去获取下一个(换句话说,应用程序应该自己实现缓冲,更多关于应用程序如何处理输出的细节参见`缓冲区和流处理`小节)。

服务端应该把产生的字节流字符串当作字节流对待:尤其必须保证没修改行尾。应用程序负责确保字符串以与客户端匹配的编码输出(服务端可能会附加`HTTP`传送编码,或者为了实现一些`HTTP`特性而进行一些转换,比如字节范围转换,更多细节参见`其他HTTP特性`小节)

如果调用`len(iterable)`成功,服务器将认为结果是正确的。也就是说,应用程序返回的可迭代的字符串提供了一个靠谱的`__len__()`方法,那么肯定返回了正确的结果(关于这个方法正常情况下如何被使用参见`处理 Content-Length头`)。

如果应用程序返回的迭代器有`close()`方法,则不管该请求是正常结束还是由于迭代错误或浏览器失去连接而终止,服务端都必须在结束该请求之前调用这个方法(这是用来支持应用程序对资源的释放,以完善`PEP 342`的生成器支持和其他含有`close()`方法的一般迭代器)。

应用程序返回的生成器或其他定制的迭代器并不一定会被使用,可能直接就被服务端关闭了。

(注意:应用程序必须在迭代器生成第一个字节流字符串之前调用`start_response()`可调用者,这样服务器才能在发送任何主体内容之前发送响应头。不过这一步也可以在迭代器第一次迭代的时候进行,所以服务器不能假定开始迭代之前`start_response()`已经被调用过了。）

除以上提及的之外,服务端不能直接使用任何应用程序返回的迭代器属性,除非该属性是针对服务端特定类型的一个实例,比如`wsgi.file_wrapper`返回的`文件包装器`(参见`(可选)特定平台上的文件处理`)。通常情况下,只有这里指定的属性,或者通过如`PEP 234`迭代`API`之类的途径获取的其他属性才是可以访问的。

##### 4.7.4.6 `environ`变量

`environ`字典中要求包含下面这些在`CGI`规范中定义了的`CGI`环境变量。除非其值是空字符串(这种情况下如果下面没有特别指出的话它们可能会被忽略),下面这些变量必须存在:

| 变量 | 说明 |
| :--- | --- |
| `REQUEST_METHOD` | `HTTP`请求的类型,比如`GET`或者`POST`,这个不可能是空字符串,所以是必须给出的 |
| `SCRIPT_NAME` | `URL`请求中路径的开始部分,对应应用程序对象,这样应用程序就知道它的虚拟位置。如果该应用程序对应服务器的根目录的话,它可能是空字符串。 | 
| `PATH_INFO` | `URL`请求中路径的剩余部分,指定请求的目标在应用程序内部的虚拟位置。如果请求的目标是应用程序根目录并且没有末尾的斜杠的话,可能为空字符串。 |
| `QUERY_STRING` | `URL`请求中后面的那部分,可能为空或不存在。 | 
| `CONTENT_TYPE` | `HTTP`请求中任何`Content-Type`域的内容,可能为空或不存在。 |
| `CONTENT_LENGTH` | `HTTP`请求中任何`Content-Length`域的内容,可能为空或不存在。 |
| `SERVER_NAME`,`SERVER_PORT` | 这些变量可以和`SCRIPT_NAME`、`PATH_INFO`一起组成完整的`URL`。然而要注意的是,重建请求`URL`的时候应该优先使用`HTTP_HOST`而非`SERVER_NAME`。详细内容参见`URL重建`。`SERVER_NAME`和`SERVER_PORT`永远不能为空字符串,也总是必须存在的。 |
| `SERVER_PROTOCOL` | 客户端发送请求所使用协议的版本。通常是类似`HTTP/1.0`或`HTTP/1.1`的东西,可以被用来判断如何处理请求包头。(既然这个变量表示的是请求中使用的协议,而且和服务器响应时使用的协议无关,也许它应该被叫做`REQUEST_PROTOCOL`。不过为了保持和`CGI`的兼容性,我们还是使用这个名字。) |
| `HTTP_Variables` | 对应客户端提供的`HTTP`请求包头(即名字以`HTTP_`开头的各种变量)。这些变量的存在与否应该与请求中对应的`HTTP`包头是否存在相一致。服务端应该尽可能提供所有可用的`CGI`变量。另外,如果使用了`SSL`,服务端也应该尽可能提供所有可用的`Apache SSL`环境变量,比如`HTTPS=on`和`SSL_PROTOCOL`。不过要注意,使用了任何上面没有列出的`CGI`变量的应用程序对不支持相关扩展的服务器来说就不具有可移植性了。(比如,不发布文件的`Web`服务器就不能提供有意义的`DOCUMENT_ROOT`变量或`PATH_TRANSLATED`变量。) |

支持`WSGI`的服务端应该在自述文档中说明它们可以提供些什么变量;应用端则应该简称所有需要的变量的存在性,并且在某变量不存在的时候有备用方案。

注意:不存在的变量(比如在不需要验证的情况下的`REMOTE_USER`变量)应该被移出`environ`字典。另外要注意`CGI`定义的变量如果存在的话必须是原生字符串。任何`str`类型以外的`CGI`变量都是不符合本规范。

除了`CGI`定义的变量,`environ`字典也可以包含任意操作系统的环境变量,并且必须包含下面这些`WSGI`定义的变量:

| 变量 | 值 |
| :--- | --- |
| `wsgi.version` | `(1,0)`元组,代表`WSGI` 1.0版 | 
| `wsgi.url_scheme` | 字符串,表示应用请求的`URL`所属的协议,通常为`http`或`https` | 
| `wsgi.input` | 类文件对象的输入流,用于读取`HTTP`请求包体的内容。(服务端在应用端请求时开始读取,或者预读客户端请求包体内容缓存在内存或磁盘中,或者视情况而定采用任何其他技术提供此输入流。) | 
| `wsgi.errors` | 类文件对象的输出流,用于写入错误信息,以集中规范地记录程序产生的或其他相关错误信息。这是一个文本流,即应用应该使用`n`来表示行尾,并假定其会被服务端正确地转换。(在`str`类型是`Unicode` 编码的平台上,错误流应该正常接收并记录任意`Unicode`编码而不报错,并且允许自行替代在该平台编码中无法渲染的字符。)很多`Web`服务器中`wsgi.errors`是主要的错误日志,也有一些使用`sys.stderr`或其他形式的文件来记录。`Web`服务器的自述文档中应该包含如何配置错误日志以及如何找到记录的位置。服务端可以在被要求的情况下,向不同的应用提供不同的错误日志 |
| `wsgi.multithread` | 如果应用对象可能会被同一进程的另一个线程同步调用,此变量值为真,否则为假 | 
| `wsgi.multiprocess` | 如果同一个应用对象可能会被另一个进程同步调用,此变量值为真,否则为假 | 
| `wsgi.run_once` | 如果服务端期望(但是不保证能得到满足)应用对象在生命周期中之辈调用一次,此变量值为真,否则为假。一般只有在基于类似`CGI`的网关服务器中此变量才会为真 | 

最后,`environ`字典也可以包含服务端定义的变量。这些变量的名称应当由小写字母、数字、点和下划线组成,并且应当带有一个所在服务端独有的前缀。比如 mod_python 可以定义 mod_python.some_variable 这样的变量。

##### 4.7.4.7 输入流和错误流

服务器提供的输入和错误流必须提供以下方法:

| 方法 | 流 | Notes |
| :--- | --- | --- |
| `read(size)` | 输入流 | `1` |
| `readline()` | 输入流 | `1,2` |
| `readlines(hint)` | 输入流 | 1,3
| `__iter__()` | 输入流 | |
| `flush()` | 错误流 | `4` |
| `write(str)` | 错误流 | | 
| `writelines(seq)` | 错误流 | |

每个方法的语义如果上面没有特别指出均和`python`标准库介绍中记载的一样:

1. 不要求`Web`服务器读取超过客户端指定的`Content-Length`的内容,并且应该在应用尝试读取越界内容时虚拟出一个文件结束符。应用不应该尝试读取超过`Content-Length`指定长度的内容。

`Web`服务器应该允许不使用参数调用`read()`,并返回客户端输入流剩余的部分;同时服务器应该对任何尝试读取空的或到文件尾的输入流的行为返回空字符串。

2. `Web`服务器应该支持`readline()`函数的可选`size`参数,但是在`WSGI 1.0`版本中可以忽略这一点。

(在`WSGI 1.0`中,`size`参数并不要求提供,因为可能很难实现也不常用。但是由于`CGI`模块开始支持它了,所以生产环境中的`Web`服务器还是得实现`size`参数。)

3. `readlines()`函数的`hint`参数对于调用者和实现者来说都是可选的。应用端完全可以忽略它,服务端亦然。

4. 由于错误流不能重设读写位置,服务端可以使用无缓冲模式来进行写操作。在这种情况下,`flush()`函数不做任何操作。但是具有良好可移植性的程序不能假设输出流是无缓冲或`flush()`函数是误操作的,而应当在需要输出真的被写到存储设备中的时候调用`flush()`函数。(比如防止多进程写数据造成的混乱这种情况。) 

上表中列出的方法必须被所有遵守本规范的服务端支持。遵守本规范的应用端则不应该调用任何其他的输入流和输出流相关的方法和属性。尤其要注意的是,应用端即使在这些流提供`close()`方法的情况下,也不应该尝试关闭它们。

##### 4.7.4.8 `start_response()`可调用者

传给应用程序对象的第二个参数是一个形为`start_response(status, response_headers, exc_info=None)`的可调用者。(像`WSGI`的所有其他可调用者一样,这个参数必须使用形式参数提供,而不能以关键字参数提供。)`start_response`可调用者用于开始`HTTP`响应,它必须返回一个`write(body_data)`可调用者(参见`缓冲区和流处理`)。

`status`参数是一个形如`200 OK`或`404 Not Found`这样的`HTTP`状态字符串。换言之是一个由状态编号和具体信息组成的字符串,按顺序并用空格隔开,两头没有其他空格和其他字符。(更多信息参见`RFC 2616,6.1.1`小节。)该字符串禁止包含控制字符,也不允许以回车、换行或二者的组合形式结尾。

`response_headers`参数是一个`(header_name, header_value)`元组的列表。它必须是一个`python`中的列表,即`type(response_headers)`的值为`ListType`,并且`Web`服务器可以以任何方式改变其内容。每一个`header_name`必须是一个不含冒号或其他标点符号的合法的`HTTP header`字段名(`RFC 2616 4.2`小节中有详细定义)。

每一个`header_value`禁止包含任何控制字符(包括回车或换行)。(这些要求是为了将那些必须检查或修改响应头的服务端和中间件所必须执行的解析工作的复杂性降到最低。)

一般来说,服务端要保证发送到客户端的包头的正确性:如果应用忽略了`HTTP`规定的包头(或其他类似的内容)服务端必须自己加上。比如`HTTP`的`Date:`和`Server:`包头一般都是由服务端提供的。

(服务端开发者小贴士:`HTTP`包头名称是大小写敏感的,所以请确保你们检查应用提供的包头时考虑了这一点!)

应用和中间件禁止使用`HTTP/1.1`中的`逐跳`机制和包头,`HTTP/1.0`中类似的机制也禁用,任何应用客户端到`Web`服务器的连接持久性的包头也都不允许使用。使用这些特性是服务端的特权,服务端发现客户端违反此规定时应视为致命错误,需在请求提交到`start_response()`时报错。(关于`逐跳`特性和包头,请参见`其他HTTP特性`小节。)

在`start_response`被调用时`Web`服务器需要检查是否有错误,所以可以在应用正在运行的时候报错。

但是,`start_response`可调用者禁止传送响应包头。只能在服务端缓存起来,当且仅当应用的第一次迭代完成并返回一个非空字节流字符串或应用第一次调用`write()`可调用者的时候才能由服务端传送。换言之,响应包头只有在包体数据已经准备好,或者应用返回的迭代器已经迭代完成的时候才能被传送出去。(唯一的例外是响应包头显式包含了一个值为零的`Content-Length`字段。)

响应包头的延迟传送是为了保证带缓冲区和异步的应用能够将它们原生的输出替换为错误流,一直到所能允许的最后一刻。举例来说,当应用使用缓冲区生成包体的时候如果出错,应用可能需要将响应状态从`200 OK`改为`500 Internal Error`。

如果提供了`exc_info`参数,则其必须为`python`中的`sys.exc_info()`元组。只有当`start_response`被错误处理程序调用时,这个参数才应当被提供。如果提供了`exc_info`参数且没有尚未有任何`HTTP`包头输出,`start_response`应该将当前缓存的`HTTP`响应包头替换成新生成的,从而允许应用在错误发生的时候修改输出。

但是,如果`HTTP`包头在其时已有输出,`start_response`必须报错,且应当使用`exc_info`元组再报一次:

```python
raise exc_info[1].with_traceback(exc_info[2])
```

以上代码会把应用捕获的异常再抛出一次,原则上会终止应用。(当`HTTP`包头已经被送出后应用尝试将错误信息输出至浏览器的行为是不安全的。)如果应用使用`exc_info`参数调用`start_response`,则禁止捕获任何由`start_response`抛出的异常,而应该让该异常被返回到服务端。详见`错误处理`小节。

当且仅当提供`exc_info`参数时,应用可能会调用`start_response`多次。说得更精确一点,如果`start_response`应该在当前的应用调用中被调用过了,再次调用时如果不提供`exc_info`参数就会引发一个致命错误。第一次调用`start_response`出错也包括在这种情况中。(参见上文的`CGI网关`示例以领会正确的逻辑流程。)

注意,集成了`start_response`的`Web`服务器、网关服务器和中间件必须保证在`start_response`执行期之外的时间内不能访问到`exc_info`,以避免在追踪和涉及到框架时发生循环引用。最简单的处理方式如下:

```python
def start_response(status, response_headers, exc_info=None):
    if exc_info:
        try:
            # do stuff w/exc_info here
        finally:
            exc_info = None    # Avoid circular ref.
```

`CGI网关样例`程序则提供了另一种处理方法。

##### 4.7.4.9 处理`Content-Length`头

如果应用提供`Content-Length`包头,`Web`服务器不应该传送大于该包头指定长度的数据给客户端,而应该在发送了足量数据之后停止对改请求进行迭代,或者在应用尝试在此后调用`write()`时报错。(当然,如果应用提供的数据量不够`Content-Length`指定的大小,`Web`服务器应当关闭此连接或直接报错。)

如果应用没有提供 Content-Length 包头,服务端有好几种方法可以处理。最简单的一种是当响应结束后关闭客户端连接。

但是在某些情况下,服务端要么必须自己生成一个`Content-Length`包头,或者至少避免关闭客户端连接。如果应用没有调用`write()`函数,且返回一个长度为`1`的迭代器,服务端应该根据迭代器生成的第一个字节流字符串自动确定`Content-Length`包头的值。

如果服务端和客户端都支持`HTTP/1.1`标准中的`整块编码`,则服务端可以使用`整块编码`在每次调用`write()`或迭代器每生成一个字节流字符串就发送一个数据块,同时为每一个数据块生成一个`Content-Length`包头。这种方法使服务端能够在需要的情况下保证客户端的连接不断。在采用这种方法时服务端必须遵守`RFC 2616`,否则就只能使用其他方法来处理`Content-Length`包头缺失的情况。

(注意：应用和中间件禁止在各自的输出中使用任何数据编码手段,比如分块或压缩;在进行`逐跳`操作时,这些编码方式是服务端的特权。参见`其他HTTP特性`小节以获取更多细节。)

##### 4.7.4.10 缓冲区和流处理

一般来说,应用通过缓存适量的数据最后一次输出来达到最佳的吞吐量。这是现有框架比如`Zope`中常用的技术:输出被缓存在一个`StringIO`或类似对象中,最后与响应包头一起一次输出。

`WSGI`中类似的处理是让应用简单地返回一个包含字节流字符串形式的响应包体的迭代器(比如一个列表)。对于绝大多数渲染数据量很小(足以放在内存中)的`HTML`页面的应用函数都建议采用这种方法。

但是对于大文件,或对于`HTTP`流的特殊用途(比如多部件`服务器推送`),应用可以根据需要将输出以小块形式提供(比如为了避免将一个大文件全部加载到内存中)。有时候响应的部分数据生成很耗时,也可以将已经生成的输出提前发送过去。

在这些情况下,应用经常会返回一个生成迭代器来生成一块一块的输出。这些数据块可以被打散以适应多部件边界(比如`服务器推送`),或者只是在耗时很长的任务之前进行(比如读取另一个在磁盘上的文件数据块)。

遵循`WSGI`的`Web`服务器,网关服务器和中间件不能延迟传送任何数据块。它们必须要么将整个数据块传送给客户端,要么保证即使应用在生成下一个数据块的时候它们仍然会继续传输,可以通过以下三种方法提供保证:

> 将这个数据块转交给操作系统并请求刷新所有系统缓存。 
> <br> 使用另一个单独的线程保证数据块在应用生成下一个数据块的时候继续传送。
> <br> 中间件还可以将整个数据块传送给其上层的网关服务器或`Web`服务器。 

通过提供这个保证,`WSGI`保证数据传送不会再应用输出数据的某个时刻被打断。这对于诸如多部件`服务器推送`输出流之类技术有重要作用,在这些技术中多部件边间之间的数据要求必须完整地传送到客户端。

##### 4.7.4.11 `Block Boundaries`的中间件处理

为了更好地支持异步的应用和服务器,中间件不能在等待应用迭代器生成多个值时阻塞迭代。如果中间件需要在应用尚未有输出的时候收集更多数据,则它必须生成一个空的字节流字符串。

换言之,每次下层应用产生一个值时中间件都必须相应生成至少一个值。如果中间件不能生成任何有意义的值,则生成一个空的字节流字符串。

这个规定保证了异步应用和服务器能够合作,以减少同时支持固定数量应用实例所需的线程数量。

值得注意的是,这要求中间件必须在下层应用返回一个迭代器时也立即向上返回一个迭代器。中间件禁止使用`write()`可调用者来传送下层应用生成的数据。中间件只能调用上层服务器的 write() 可调用者来传送下层应用调用中间件自己的`write()`可调用者生成的数据。(译者注:即下层只能调用上层的`write()`可调用者。)

##### 4.7.4.12 `write()`函数

某些现有框架的`API`支持无缓冲输出的方法与`WSGI`不同。尤其是他们提供了某种形式的`write`函数以无缓冲地写入一个数据块,或者提供了一个有缓冲的`write`函数和一个`flush`机制来刷新缓存。

不幸的是这些`API`不能使用`WSGI`应用的迭代器返回值来实现,除非使用多线程或类似的特殊技术。

因此为了让这些框架继续使用必要的`API`,`WSGI`包含了一个特别的`write()`可调用者,由`start_response`可调用者返回。

新的`WSGI`应用和框架在不必要的时候不应该使用`write()`可调用者。`write()`可调用者是为了支持必要的流式`API`的一种`hack`手段。一般而言,应用应该使用迭代器返回输出,这样`Web`服务器可以在同一个`python`线程中交替完成不同的任务,从而潜在地提高服务器的吞吐量。

`write()`可调用者由`start_response()`可调用者返回,只接受一个参数:作为`HTTP`包体一部分的一个字节流字符串,并将此字符串当作由输出迭代器生成的。换言之,在`write()`返回前,必须保证传入的字节流字符串要么被完整地传送到了客户端,或者在应用继续运行的时候已被缓存起来等待传送。

应用必须返回一个迭代器对象,即使它使用了`write()`来生成全部或者部分的响应包体。返回的迭代器必须为空(即不生成任何非空字节流字符串),但是如果它确实生成了非空字节流字符串,则该输出必须被`Web`服务器或网关服务器当作一般输出处理(即必须被立即传送或缓存)。应用禁止在其返回的迭代器内部调用`write()`,因此任何迭代器生成的字节流字符串必须在所有传递给`write()`的字符串被发送给客户端之后才能进行传送。

##### 4.7.4.13 `Unicode`编码

`HTTP`并不直接支持`Unicode`,`WSGI`亦然。所有的编码和解码工作由应用自己完成,所有发送给服务器或从服务器接收的字符串必须是`str`类型或`bytes`类型的,而不能是`unicode`类型。在要求使用字符串类型的地方使用`unicode`类型的结果是不可知的。

作为状态或响应包头传递给`start_response()`的字符串必须遵守`RFC 2616`中关于编码的规定,即要么是`ISO-8859-1`字符,要么使用`RFC 2047 MIME`编码。

在`str`或`StringType`类型实际上是`Unicode`编码的`python`平台(如`Jython`,`IronPython`,`python 3`等)上,所有对应于本规范的`字符串`只能包含对应于那些`ISO-8859-1`可表示编码点的`Unicode`编码(即`u0000`到`u00FF`)。应用使用的字符串中包含有其他字符或编码点会引发致命错误。`Web`服务器和网关服务器也禁止提供包含其他`Unicode`字符的字符串。

再强调一遍,所有对应到本规范的`字符串`必须是`str`类型或者`StringType`类型,而不能是`unicode`类型或者`UnicodeType`类型。即使已有的平台允许在`str`或`StringType`类型中使用每个字符多于`8`比特的编码,也只有低`8`位允许使用。

本规范中所谓的`字节流字符串`(即从`wsgi.input`中读入的值,最后会传递给`write()`或由应用生成),其值必须是`Python 3`下的`bytes`类型,或者更低版本`Python`中的`str`类型。

##### 4.7.4.14 错误处理

一般而言,应用应该自己捕获内部错误,并在浏览器中显示有帮助的错误信息。(由应用自己决定什么叫`有帮助`。)

但是要显示这条信息,应用在之前必须没有发送任何数据到浏览器,或者可以冒险中断响应。`WSGI`提供了一个机制以使应用要么能够传送错误信息,要么会被自动终止:通过`start_response`的`exc_info`参数。下面有一个例子来阐述其用法:

```python
::
try:
    # regular application code here 
    status = "200 Froody"
    response_headers = [("content-type", "text/plain")] 
    start_response(status, response_headers) 
    return ["normal body goes here"]
except:
    # XXX should trap runtime issues like MemoryError, KeyboardInterrupt 
    # in a separate handler before this bare ‘except:’... 
    status = "500 Oops"
    response_headers = [("content-type", "text/plain")] 
    start_response(status, response_headers, sys.exc_info()) 
    return ["error body goes here"]
```

如果在异常发生时还没有任何输出,`start_response`的调用会正常返回,应用会收到可用以传递给浏览器的错误信息。而如果之前有任何输出已经被传递给浏览器,`start_response`会重新抛出异常。这个异常不能被应用捕获,所以应用不会终止。`Web`服务器或网关服务器能够捕获这个异常并终止响应。

服务器应该捕获并记录所有终止了应用或其返回值迭代过程的异常。如果错误发生时部分响应信息已经被传递给浏览器,`Web`服务器或网关服务器可以尝试在输出中添加一条错误信息,只要已发送的包头包含服务器可以显式修改的`text/*`类型内容。

某些中间件可能希望能够提供其他的错误处理机制,或拦截和替换应用错误信息。在这种情况下,中间件可以选择不重新将`exc_info`抛出给`start_response`,但是必须相应地抛出一个中间件特定的异常,或者缓存下提供的参数后简单地正常返回。这迫使应用返回其错误信息迭代器(或调用`write()`),从而使中间件能够捕获和修改错误信息。这些技术要求开发者遵循如下规范:

> 开始错误响应时总是提供`exc_info`参数。
> <br> 提供了`exc_info`参数的情况下不要捕获任何由`start_response`抛出的异常。 


##### 4.7.4.15 `HTTP 1.1`相关

实现了`HTTP 1.1`标准的`Web`服务器和网关服务器必须提供`HTTP 1.1`标准中`expect/continue`机制的透明支持。这可以通过以下方法做到:

> 对于任何`Expect: 100-continue`的请求返回一个即时的`100 Continue`响应,然后正常继续运行。 
> <br> 继续正常运行,但是提供给应用一个`wsgi.input`流,这个流会在应用第一次尝试读取输入流的时候发送`100 Continue`响应。读请求之后必须阻塞,直到客户端响应为止。 
> >br> 阻塞请求直到客户端意识到服务器不支持`expect/continue`机制,然后自己发送请求包体。(这种方法不是最优的,不推荐使用。)

这些限制并不针对`HTTP 1.0`的请求,也不适用于不传递给应用对象的请求。参见`RFC 2616 8.2.3`小节和`10.1.1`小节以获取更多关于`HTTP 1.1 Expect/Continue`请求的信息。

##### 4.7.4.16 其他`HTTP`特性 

一般来说,服务端应该让应用全权负责控制自己的输出。服务端只能进行不影响应用响应语义的改动。应用开发者总是可以通过添加中间件来提供附件特性,因此服务端开发者在实现过程中必须尽可能保守。从某种意义上来说,`Web`服务器应当视自己为`HTTP网关服务器`,而将应用看成一个`HTTP`的`源服务器`。(参见`RFC 2616 1.3`小节获取更多信息。)

但是因为`WSGI`服务端和应用端不通过`HTTP`交互,所以`RFC 2616`称之为`逐跳`包头的特性不适用与`WSGI`的内部通信。`WSGI`应用不能生成任何`逐跳`包头,不能使用任何需要生成该包头的`HTTP`特性,也不能依赖于`environ`字典中的任何传入的`逐跳`包头。`WSGI`服务端必须自己处理任何传入的能够支持的`逐跳`包头,比如对传入的`Transfer-Encoding`进行解码,如果可能的话其中也包括整块编码。

以上的原则适用于很多`HTTP`特性,服务端可以通过`If-None-Match`和`If-Modified-Since`请求包头以及`Last-Modified`和`ETag`响应包头来处理缓存生效的问题。但是这并不是必要的,应用如果想支持该特性应该自己处理自己的缓存生效问题,因为服务端不一定会处理。

类似情况比如服务端可以对应用的响应进行重新编码或传输编码,但是应用应该自己选择一个合适的内容编码方式,并且禁止使用传输编码。服务端可以在客户端要求的时候传输应用响应的字节范围,而应用并不原生支持字节范围,但是同样的,应用应该在有需求时自己干这个。

请注意,这些限制条件并不是要求应用把每一个`HTTP`特性都自己重新实现一遍。很多特性可以部分或全部被中间件实现,从而避免服务端和应用端的开发者一次又一次地重复实现同样的特性。

##### 4.7.4.17 线程支持

线程机制的支持与否取决与各`Web`服务器自身。可以并行处理多个请求的服务器,必须提供单线程运行应用的选项,以使非线程安全的应用或框架仍然能够在其上运行。

#### 4.7.5 应用实现指南

##### 4.7.5.1 服务器扩展API

一些服务端开发者希望暴露更多的高级`API`,以使应用端开发者用来实现特殊的需求。比如说一个基于`mod_python`的网关服务器会希望以`WSGI`扩展的方式暴露部分`Apache`的`API`。

在最简单的情况下,这只要求定义一个`environ`变量,比如`mod_python.some_api`。但是很多时候可能存在的中间件会使情况变得复杂起来。比如一个`environ`变量中提供访问某个`HTTP`包头功能的`API`,可能在`environ`被中间件修改之后返回不同的值。

一般而言,任何复制、补足或绕过了部分`WSGI`功能的`API`都有与中间件不兼容的危险。服务端开发者不应该假设没有使用中间件,因为某些框架开发者尤其希望将他们的框架设计或重构成类似中间件的样子。

所以为了提供最大程度的兼容性,提供扩展`API`以取代某些`WSGI`功能的服务端应该精心设计,以使它们在被调用时使用了这些扩展`API`。举例来说,一个访问`HTTP`请求包头的`API`必须要求应用传递其当前的`environ`,以使服务端能确定通过该`API`能访问到的`HTTP`包头没有被中间件修改。如果扩展`API`不能保证其对`HTTP`包头的要求与`environ`一致,那么它必须通过报错、返回`None`而不是包头集合或任何其他合适的方式拒绝为应用服务。

类似的例子还有如果扩展`API`提供写入响应数据或包头的功能,它必须要求应用在使用扩展功能之前传入`start_response`可调用者。如果该可调用者与服务端最早从应用那儿收到的不一致,那么该`API`便不能保证正确的响应,只能拒绝为应用提供改扩展服务。

这些指导原则也适用于在`environ`中额外添加了类似解析过的`cookie`、构造变量、会话等内容的中间件。尤其是那些将这些功能以作用于`environ`的函数形式提供的中间件,相比简单将数据插入`environ`中的中间件更要注意。这保证了在每次中间件对`environ`进行了`URL`重写或其他修改之后`environ`中的信息都会被检查一遍。

这些`安全扩展`的原则非常重要,服务端和应用端开发者都应该遵守,以避免未来的某个时候中间件开发者不得不删除某些或全部涉及`environ`的扩展`API`,以免中间件的功能因为应用调用了扩展`API`而失效。

##### 4.7.5.2 应用配置 

本规范并没有定义服务端如何选择或获取一个应用来调用。这些以及其他的配置选项是由服务端根据自己的特定情况决定的。服务端开发者应该在自述文档中记述如何配置才能以特定的选项(如线程选项)执行一个特定的应用程序对象。

另一方面,框架开发者应该在自述文档中记载如何创建一个包含框架功能的应用对象。在服务端和应用端都使用了框架的用户必须将二者结合起来考虑。但是由于双方现在都有通用接口了,这只是个体力活儿,而不是一个重要的工程难题。

最后,有些应用、框架和中间件希望使用`environ`字典来收取简单的配置选项字符串。`Web`服务器和网关服务器应该通过允许应用开发者在`environ`中指定键值对来支持这个特性。最简单的情况下,只需要从`os.environ`中拷贝所有操作系统提供的环境变量到`environ`字典中即可,因为部署人员原则上能够在服务器上手工配置这些变量,或者在 CGI 环境下他们可以通过服务器的配置文件来完成。

应用应该尽量少使用这些变量,因为不是所有的服务器都能够很方便地配置它们。当然,即使在最坏的情况下,部署应用的人也能够通过创建一个脚本提供必要配置选项:

```python
from the_app import application

def new_app(environ, start_response):
    environ['the_app.configval1'] = 'something'
    return application(environ, start_response)
```

但是大部分的应用和框架可能只需要`environ`中的一个配置域来显示应用或框架用到的配置文件路径。(当然,应用可以缓存这些配置来避免在每次调用中都读一遍。)

##### 4.7.5.3 URL reconstruction

如果应用希望重建一个请求的完整`URL`,可以通过下面由Ian Bicking提供的算法来实现:

```python
from urllib import quote
url = environ['wsgi.url_scheme']+'://'

if environ.get('HTTP_HOST'):
    url += environ['HTTP_HOST']
else:
    url += environ['SERVER_NAME']

    if environ['wsgi.url_scheme'] == 'https':
        if environ['SERVER_PORT'] != '443':
           url += ':' + environ['SERVER_PORT']
    else:
        if environ['SERVER_PORT'] != '80':
           url += ':' + environ['SERVER_PORT']

url += quote(environ.get('SCRIPT_NAME', ''))
url += quote(environ.get('PATH_INFO', ''))
if environ.get('QUERY_STRING'):
    url += '?' + environ['QUERY_STRING']
```

注意重建出来的`URL`可能不是客户端请求的那个`URI`,比如服务器重写规则可能会修改客户端请求的原始`URL`以使其符合规范。

##### 4.7.5.4 支持低于`2.2`版本的`python`

某些`Web`服务器、网关服务器或者应用可能会需要支持低于`2.2`版本的`python`。在使用`Jython`作为平台的时候这一点尤其重要,因为高于`2.2`版本的`Jython`还不能在生产环境中应用。

对于`Web`服务器和网关服务器,这种支持相对直接:目标平台是低于`2.2`版本的`Python`的服务器和网关只能使用一个标准的`for`循环来迭代任何应用返回的迭代器。这是唯一保证各版本间的迭代器协议在源码级兼容的方法,后面我们会详细讨论。(最新的迭代器协议见`PEP 234`。)

(注意这个技术只适用于`Python`下的`Web`服务器、网关服务器和中间件。其他语言中的迭代器协议如何正确使用超出了本规范的讨论范围。)

对于应用程序,支持低于`2.2`版本的`Python`有一点麻烦:

> 你不能返回一个文件对象并期望它像一个迭代器一样工作,因为从`Python 2.2`开始文件就不是迭代器了。(一般而言你也不应该使用这种方法,因为绝大多数情况下这是一种丑陋的实现!)应该使用`wsgi.file_wrapper`或者应用指定的文件包装器。(参见(可选)特定平台上的文件处理小节以获取更多文件包装器的信息,以及一个可以用来将文件包装为迭代器的样例类。)
> 
> 如果你返回一个经过定制的迭代器,它必须实现`2.2`版本之前的迭代器协议。亦即提供一个`__getitem__`方法,这个方法接受一个整数键值,当该值耗尽时就会抛出`IndexError`异常。(内建的序列类型也是可接受的,因为它们已经集成了相关协议。)最后,希望支持低于`2.2`版本的`Python`且迭代应用返回值或本身返回一个迭代器的中间件必须遵守以上提到的相应的推荐方法。

(注意:`Web`服务器、网关服务器、应用或者中间件在支持低于`2.2`版本的`Python`都必须只使用该版本支持的特性,比如使用`1`和`0`来代替`True`和`False`等。)

##### 4.7.5.5 (可选)特定平台上的文件处理

某些操作系统提供特殊的高性能文件传输功能,比如`Unix`的`sendfile()`系统调用。`Web`服务器和网关服务器可以通过`environ`中可选的`wsgi.file_wrapper`域值来提供此功能。应用可以使用这种`文件包装器`来将一个文件或类文件对象转换为一个迭代器并返回,如下所示:

```python
if 'wsgi.file_wrapper' in environ:
    return environ['wsgi.file_wrapper'](filelike, block_size)
else:
    return iter(lambda: filelike.read(block_size), '')
```

如果`Web`服务器或网关服务器支持`wsgi.file_wrapper`,则它必须是一个可调用者,接收一个必须的形式参数和一个可选的形式参数。第一个形式参数是一个待发送的类文件对象,第二个可选的则是一个建议的块大小(服务端不一定要采纳)。这个可调用者必须返回一个迭代对象,并且禁止在服务端实际接收到该迭代器返回值之前传送任何数据。(不这样做的话会妨碍中间件对响应数据进行译码或修改。)

为了被看做一个文件,应用提供的对象必须有一个能接受一个可选文件大小参数的`read()`方法。该对象也可以有一个`close()`方法,如果提供了这个方法,`wsgi.file_wrapper`返回的迭代器就必须提供一个`close()`方法,这个方法最终调用了对象提供的`close()`方法。如果该对象提供了任何与`Python`内建文件对象名字一样的方法或属性(比如`fileno()`),`wsgi.file_wrapper`可以假设这些方法和属性与它们作为内建的方法和属性时语义相同。

任何平台相关的文件处理必须是现在应用返回之后,并且由`Web`服务器和网关服务器来检查包装器对象是否返回了。(再强调一遍,由于中间件、错误处理程序之类的存在,并不保证包装器被创建了就一定会被使用。)

除了对于`close()`的处理,应用返回文件包装器的语义应该与应用返回`iter(filelike.read, ‘’)`一样。换言之,数据传输应该从当前的文件读写指针位置开始,直到到达文件尾或者达到`Content-Length`要求的字节数。(如果应用没有提供`Content-Length`包头,服务端可以根据自己的文件实现机制对具体的文件生成一个。)

当然,平台相关的文件传送`API`一般不会随便接受一个类文件对象。因此`wsgi.file_wrapper`必须自己检查所提供的对象有没有诸如`fileno()`(在`Unix`类系统上)或`java.nio.FileChannel`(在`Jython`平台上)之类的东西,以保证类文件对象正确使用了平台特有的`API`。

另外要注意的是即使该对象不适应平台特有的`API`,`wsgi.file_wrapper`也必须返回一个包装了`read()`和`close()`的迭代器,以使使用文件包装器的应用能够跨平台移植。下面有一个简单的不依赖特定平台的文件包装器类,适用于所有版本的`Python`:

```python
class FileWrapper:

    def __init__(self, filelike, blksize=8192):
        self.filelike = filelike
        self.blksize = blksize
        if hasattr(filelike, 'close'):
            self.close = filelike.close

    def __getitem__(self, key):
        data = self.filelike.read(self.blksize)
        if data:
            return data
        raise IndexError
```

下面一段代码是从服务端代码中抽出来的,支持访问平台相关的`API`:

```python
environ['wsgi.file_wrapper'] = FileWrapper
result = application(environ, start_response)

try:
    if isinstance(result, FileWrapper):
        # check if result.filelike is usable w/platform-specific
        # API, and if so, use that API to transmit the result.
        # If not, fall through to normal iterable handling
        # loop below.

    for data in result:
        # etc.

finally:
    if hasattr(result, 'close'):
        result.close()
```


## 四、numpy教程


https://www.numpy.org.cn/reference/routines/math.html#%E5%8A%A0%E6%B3%95%E5%87%BD%E6%95%B0-%E4%B9%98%E6%B3%95%E5%87%BD%E6%95%B0-%E5%87%8F%E6%B3%95%E5%87%BD%E6%95%B0

## 五、matplotlib教程

![](http://pic3.zhimg.com/v2-9345e8a161f2b0363ad0f9cb47ee1862_r.jpg)

<img src="http://pic3.zhimg.com/80/v2-cfe3dd3becbae38d3af4659b4ff1676a_1440w.jpg" style="width: 60%">

`matplotlib`的API都位于`matplotlib.pyplot`模块中,通常的引入约定为: `import matplotlib.pyplot as plt`。

画图相关的概念如图:

![](http://pic4.zhimg.com/v2-406d1e6a28e113801a057d8104d81067_r.jpg)

https://zhuanlan.zhihu.com/p/139052035

https://zhuanlan.zhihu.com/p/136854657

### 5.1 Figure画图

| 使用 | 代码 | 
| :--- | :--- |
| 设置标题 | `plt.title('AAPL stock price change')` |
| 设置图例 | `plt.plot(x, y, label='AAPL')`<br>`plt.legend()` |  
| 设置坐标轴标签 | `plt.xlabel('time')`<br>`plt.ylabel('stock price')` |
| 设置坐标轴范围 | `plt.xlim(datetime(2008,1,1), datetime(2010,12,31))`<br>`plt.ylim(0,300)`<br>或者`plt.axis([datetime(2008,1,1), datetime(2010,12,31), 0, 300])`|
| 设置图像大小 | `plt.figure(figsize=[6,6])` |
| 设置(箭头)标注 | `plt.annotate()` |
| 添加文字 | `plt.text()`/`AxesSubplot.text()` |    

注意设置图像大小的语句要放在`plot()`方法之前

* **设置箭头标注**

`annotate(s, xy, *args, **kwargs)`

| 字段 | 说明 |
| :--- | :--- |
| `s`  | 注释字符串 |
| `xy` | 注释目标点的坐标 |
| `xytext` | 注释字符串的坐标 |
| `textcoords` | 注释字符串(xytext)所在的坐标系统<br>默认与xy所在的相同,也可以设置为'offset points'或'offset pixels'这种偏移量的形式 |
| `arrowprops` | 箭头属性(见下表) |

箭头样式属性:

| 名字 | 属性 |
| :--- | :--- |
| `'-'` | None |
| `'->'` | head_length=0.4,head_width=0.2 |
| `'-['` | widthB=1.0,lengthB=0.2,angleB=None |
| `'|-|'` | widthA=1.0,widthB=1.0 |
| `'-|>'` | head_length=0.4,head_width=0.2 |
| `'<-'` | head_length=0.4,head_width=0.2 |
| `'<->'` | head_length=0.4,head_width=0.2 |
| `'<|-'` | head_length=0.4,head_width=0.2 |
| `'<|-|>'` | head_length=0.4,head_width=0.2 |
| `'fancy'` | head_length=0.4,head_width=0.4,tail_width=0.4 |
| `'simple'` | head_length=0.5,head_width=0.5,tail_width=0.2 |
| `'wedge'` | tail_width=0.3,shrink_factor=0.5 |


连接样式(具体见下图):

![](https://pic3.zhimg.com/v2-ec1a78076514ac39c63487bbcf785f02_r.jpg)

* **添加文本**

`text(x, y, s, fontdict=None, **kwargs)`:在(x,y)坐标处添加文本

| 参数 | 说明 |
| :--- | :--- |
| `x` | 文本的x坐标 |
| `y` | 文本的y坐标 |
| `s` | 文本 |
| `fontsize` | 文本字体大小 |
| `ha` | ha是HorizontalAlignment的简写,ha='center'即水平对齐,除此之外还可以选择'left'(左对齐)或'right'(右对齐) |
| `va` | va则是VerticalAlignment的简写,va可以选择['center'|'top'|'bottom'|'baseline']中的任何一个,意思分别为'垂直居中'、'顶端居中'、'底端居中'和'底线居中' |



* **颜色、标记、线型和图表风格**

`plot(x,y,color='',marker='',linestyle='')`:`matplotlib`的plot函数接受一组X和Y坐标,还可以通过color、marker和linestyle关键字传入指定的颜色、标记和线型,或者用一个表示颜色、标记和线型的格式字符串替代,两种方法是等效的。格式字符串中color、marker和linestyle可以任意排列,如'`ko--`'，'`k--o`'，'`o--k`'

常用的颜色都有一个缩写词,如:

| character | color |
| :--- | :---|
| `'b'` | blue |
| `'g'` | green |
| `'r'` | red |
| `'c'` | cyan |
| `'m'` | magenta |
| `'y'` | yellow |
| `'k'` | black |
| `'w'` | white |

详细的corlor如下

![](http://pic4.zhimg.com/v2-bc7fde8469ddf6b65269c5a9f8f2eab7_r.jpg)


要使用其他颜色任意颜色可以指定特定颜色的16进制颜色码,如'`#998301`'。

完整的marker样式:

![](http://pic4.zhimg.com/v2-d225a0d234b43e7cae94cfaf37fdff93_r.jpg)



再讲style,matplotlib的style有如下几种

![](http://pic2.zhimg.com/80/v2-01545d1309a81a7a54af6d9f615abe2d_720w.jpg)

以`plt.style.use('ggplot')`的形式使用。


* **·Subplot`画图**

`plt.subplots()`方法创建一个figure对象和指定布局的多个子图,返回一个figure对象和一个Axes对象的数组

```
subplots(nrows=1, ncols=1, sharex=False, sharey=False, squeeze=True,
         subplot_kw=None, gridspec_kw=None, **fig_kw)
```

| 参数 | 说明 |
| :--- | :--- |
| nrows | subplot的行数 |
| ncols | subplot的列数 |
| sharex | 所有subplot使用相同的X轴刻度(调节xlim将会影响所有subplot) |
| sharey | 所有subplot使用相同的Y轴刻度(调节ylim将会影响所有subplot) |

返回的AxesSubplot对象的数组非常好用,,数组中的每个元素都代表一个子图,数组的形状就是子图的布局(layout),通过对这个数组的索引(如axes[0,1])调用AxesSubplot对象的实例方法就可以实现在对应的子图里画图了


`plt.suptitle()`/`fig.suptitle()`方法可以为figure对象添加一个居中的标题,对于多个子图的情况经常用到这一方法:`suptitle(t, **kwargs)`在图中添加一个居中的标题

| 参数 | 说明 |
| :--- | :--- |
| `t` | 标题 |
| `fontsize` | 标题文本的字体大小 |


在`DataFrame`/`Series`上调用`plot()`方法返回的是一个`AxesSubplot`对象,而用`plt.plot(x,y)`这种形式的绘图返回的是一个表示绘制数据的Line2D对象的列表

`plt.subplot`创建子图:用于在当前figure对象中添加子图

```python
subplot(nrows, ncols, index, **kwargs)
```

默认情况下,`matplotlib`会在subplot外围留下一定的边距,并在subplot之间留下一定的间距。间距跟图像的高度和宽度有关，因此,如果调整了图像大小,间距也会自动调整。利用Figure对象subplots_adjust方法可以轻而易举地修改间距,此外,它也是一个顶级函数(可以通过`plt.subplots_adjust()`的方式调用)。

设置子图的标题、轴标签、刻度、刻度标签以及添加图例:

| 方法 | 说明 | 
| :--- | :--- |
| `AxesSubplot.set_title()` | 设置标题 |
| `AxesSubplot.set_xlabel()`<br>`AxesSubplot.set_ylabel()` | 设置轴标签 |
| `AxesSubplot.set_xticks()`<br>`AxesSubplot.set_yticks()` | 设置刻度(横坐标等于哪些值的时候显示刻度) |
| `AxesSubplot.set_xticklabels()`<br>`AxesSubplot.set_yticklabels()` |设置刻度标签(刻度之下显示什么,默认是其代表的值) |


* **常见的代码**

> * 导入`matplotlib`库简写为`plt`

```python
import matplotlib.pyplot as plt
```

> * **用plot方法画出x=(0,10)间sin的图像**

```python
x = np.linspace(0, 10, 30)
plt.plot(x, np.sin(x));
```

> * **用点加线的方式画出x=(0,10)间sin的图像**

```python
plt.plot(x, np.sin(x), '-o');
```

> * **用scatter方法画出x=(0,10)间sin的点图像**

```python
plt.scatter(x, np.sin(x));
```

> * **用饼图的面积及颜色展示一组4维数据**

```python
rng = np.random.RandomState(0)
x = rng.randn(100)
y = rng.randn(100)
colors = rng.rand(100)
sizes = 1000 * rng.rand(100)

plt.scatter(x, y, c=colors, s=sizes, alpha=0.3,
            cmap='viridis')
plt.colorbar(); # 展示色阶
```

> * **绘制一组误差为±0.8的数据的误差条图**

```python
x = np.linspace(0, 10, 50)
dy = 0.8
y = np.sin(x) + dy * np.random.randn(50)

plt.errorbar(x, y, yerr=dy, fmt='.k')
```

> * **绘制一个柱状图**

```python
x = [1,2,3,4,5,6,7,8]
y = [3,1,4,5,8,9,7,2]
label=['A','B','C','D','E','F','G','H']

plt.bar(x,y,tick_label = label);
```

> * **绘制一个水平方向柱状图**

```python
plt.barh(x,y,tick_label = label);
```

> * **绘制1000个随机值的直方图**

```python
data = np.random.randn(1000)
plt.hist(data);
```

> * **设置直方图分30个bins,并设置为频率分布**

```pythonn
plt.hist(data, bins=30,histtype='stepfilled', density=True)
plt.show();
```

> * **在一张图中绘制3组不同的直方图,并设置透明度**

```python
x1 = np.random.normal(0, 0.8, 1000)
x2 = np.random.normal(-2, 1, 1000)
x3 = np.random.normal(3, 2, 1000)

kwargs = dict(alpha=0.3, bins=40, density = True)

plt.hist(x1, **kwargs);
plt.hist(x2, **kwargs);
plt.hist(x3, **kwargs);
```

> * **绘制一张二维直方图**

```python
mean = [0, 0]
cov = [[1, 1], [1, 2]]
x, y = np.random.multivariate_normal(mean, cov, 10000).T
plt.hist2d(x, y, bins=30);
```

> * **绘制一张设置网格大小为30的六角形直方图**

```python
plt.hexbin(x, y, gridsize=30);
```

> * **绘制x=(0,10)间sin的图像,设置线性为虚线**

```python
x = np.linspace(0,10,100)
plt.plot(x,np.sin(x),'--');
```

> * **设置y轴显示范围为(-1.5,1.5)**

```python
x = np.linspace(0,10,100)
plt.plot(x, np.sin(x))
plt.ylim(-1.5, 1.5);
```

> * **设置x,y轴标签variable x，value y**

```python
x = np.linspace(0.05, 10, 100)
y = np.sin(x)
plt.plot(x, y, label='sin(x)')
plt.xlabel('variable x');
plt.ylabel('value y');
```

> * **设置图表标题“三角函数”**

```python
x = np.linspace(0.05, 10, 100)
y = np.sin(x)
plt.plot(x, y, label='sin(x)')
plt.title('三角函数');
```

> * **显示网格**

```python
x = np.linspace(0.05, 10, 100)
y = np.sin(x)
plt.plot(x, y)
plt.grid()
```

> * **绘制平行于x轴y=0.8的水平参考线**

```python
x = np.linspace(0.05, 10, 100)
y = np.sin(x)
plt.plot(x, y)
plt.axhline(y=0.8, ls='--', c='r')
```

> * **绘制垂直于x轴x<4 and x>6的参考区域,以及y轴y<0.2 and y>-0.2的参考区域**

```python
x = np.linspace(0.05, 10, 100)
y = np.sin(x)
plt.plot(x, y)
plt.axvspan(xmin=4, xmax=6, facecolor='r', alpha=0.3) # 垂直x轴
plt.axhspan(ymin=-0.2, ymax=0.2, facecolor='y', alpha=0.3);  # 垂直y轴
```

> * **添加注释文字sin(x)**

```python
x = np.linspace(0.05, 10, 100)
y = np.sin(x)
plt.plot(x, y)
plt.text(3.2, 0, 'sin(x)', weight='bold', color='r');
```

> * **用箭头标出第一个峰值**

```python
x = np.linspace(0.05, 10, 100)
y = np.sin(x)
plt.plot(x, y)
plt.annotate('maximum',xy=(np.pi/2, 1),xytext=(np.pi/2+1, 1),
             weight='bold',
             color='r',
             arrowprops=dict(arrowstyle='->', connectionstyle='arc3', color='r'));
```

> * **在一张图里绘制sin、cos的图形,并展示图例**

```python
x = np.linspace(0, 10, 1000)
fig, ax = plt.subplots()

ax.plot(x, np.sin(x), label='sin')
ax.plot(x, np.cos(x), '--', label='cos')
ax.legend();
```

> * **调整图例在左上角展示,且不显示边框**

```python
ax.legend(loc='upper left', frameon=False);
```

> * **调整图例在画面下方居中展示,且分成2列**

```python
ax.legend(frameon=False, loc='lower center', ncol=2)
```

> * **绘制$\sin(x),\sin(x+\pi/2),\sin(\pi+x)$的图像,并只显示前2者的图例

```python
y = np.sin(x[:, np.newaxis] + np.pi * np.arange(0, 2, 0.5))
lines = plt.plot(x, y)

# lines 是 plt.Line2D 类型的实例的列表
plt.legend(lines[:2], ['first', 'second']);

# 第二个方法
#plt.plot(x, y[:, 0], label='first')
#plt.plot(x, y[:, 1], label='second')
#plt.plot(x, y[:, 2:])
#plt.legend(framealpha=1, frameon=True);
```

> * **将图例分不同的区域展示**

```python
fig, ax = plt.subplots()

lines = []
styles = ['-', '--', '-.', ':']
x = np.linspace(0, 10, 1000)

for i in range(4):
    lines += ax.plot(x, np.sin(x - i * np.pi / 2),styles[i], color='black')
ax.axis('equal')

# 设置第一组标签
ax.legend(lines[:2], ['line A', 'line B'],
          loc='upper right', frameon=False)

# 创建第二组标签
from matplotlib.legend import Legend
leg = Legend(ax, lines[2:], ['line C', 'line D'],
             loc='lower right', frameon=False)
ax.add_artist(leg);
```

> * **展示色阶**

```python
x = np.linspace(0, 10, 1000)
I = np.sin(x) * np.cos(x[:, np.newaxis])

plt.imshow(I)
plt.colorbar();
29.改变配色为'gray'

plt.imshow(I, cmap='gray');
```

> * **将色阶分成6个离散值显示**

```python
plt.imshow(I, cmap=plt.cm.get_cmap('Blues', 6))
plt.colorbar()
plt.clim(-1, 1);
```

> * **在一个1010的画布中,(0.65,0.65)的位置创建一个0.20.2的子图**

```python
ax1 = plt.axes()
ax2 = plt.axes([0.65, 0.65, 0.2, 0.2])
```

> * **在2个子图中,显示sin(x)和cos(x)的图像**

```python
fig = plt.figure()
ax1 = fig.add_axes([0.1, 0.5, 0.8, 0.4], ylim=(-1.2, 1.2))
ax2 = fig.add_axes([0.1, 0.1, 0.8, 0.4], ylim=(-1.2, 1.2))

x = np.linspace(0, 10)
ax1.plot(np.sin(x));
ax2.plot(np.cos(x));
```

> * **用for创建6个子图,并且在图中标识出对应的子图坐标**

```python
for i in range(1, 7):
    plt.subplot(2, 3, i)
    plt.text(0.5, 0.5, str((2, 3, i)),fontsize=18, ha='center')
    
# 方法二
# fig = plt.figure()
# fig.subplots_adjust(hspace=0.4, wspace=0.4)
# for i in range(1, 7):
#     ax = fig.add_subplot(2, 3, i)
#     ax.text(0.5, 0.5, str((2, 3, i)),fontsize=18, ha='center')
```

> * **设置相同行和列共享x,y轴**

```python
fig, ax = plt.subplots(2, 3, sharex='col', sharey='row')
```

> * **用[]的方式取出每个子图,并添加子图座标文字**

```python
for i in range(2):
    for j in range(3):
        ax[i, j].text(0.5, 0.5, str((i, j)),fontsize=18, ha='center')
```

> * **组合绘制大小不同的子图,样式如下**

![](http://pic1.zhimg.com/v2-301cd83e25d34153892b8334ad85dd7c_r.jpg)
```python
grid = plt.GridSpec(2, 3, wspace=0.4, hspace=0.3)
plt.subplot(grid[0, 0])
plt.subplot(grid[0, 1:])
plt.subplot(grid[1, :2])
plt.subplot(grid[1, 2]);
```

> * **显示一组二维数据的频度分布,并分别在x,y轴上,显示该维度的数据的频度分布**

```python
mean = [0, 0]
cov = [[1, 1], [1, 2]]
x, y = np.random.multivariate_normal(mean, cov, 3000).T

# Set up the axes with gridspec
fig = plt.figure(figsize=(6, 6))
grid = plt.GridSpec(4, 4, hspace=0.2, wspace=0.2)
main_ax = fig.add_subplot(grid[:-1, 1:])
y_hist = fig.add_subplot(grid[:-1, 0], xticklabels=[], sharey=main_ax)
x_hist = fig.add_subplot(grid[-1, 1:], yticklabels=[], sharex=main_ax)

# scatter points on the main axes
main_ax.scatter(x, y,s=3,alpha=0.2)

# histogram on the attached axes
x_hist.hist(x, 40, histtype='stepfilled',
            orientation='vertical')
x_hist.invert_yaxis()

y_hist.hist(y, 40, histtype='stepfilled',
            orientation='horizontal')
y_hist.invert_xaxis()
```

> * **创建一个三维画布**

```python
from mpl_toolkits import mplot3d
fig = plt.figure()
ax = plt.axes(projection='3d')
```

> * **绘制一个三维螺旋线**

```python
ax = plt.axes(projection='3d')

# Data for a three-dimensional line
zline = np.linspace(0, 15, 1000)
xline = np.sin(zline)
yline = np.cos(zline)
ax.plot3D(xline, yline, zline);
```

> * **绘制一组三维点**

```python
ax = plt.axes(projection='3d')
zdata = 15 * np.random.random(100)
xdata = np.sin(zdata) + 0.1 * np.random.randn(100)
ydata = np.cos(zdata) + 0.1 * np.random.randn(100)
ax.scatter3D(xdata, ydata, zdata, c=zdata, cmap='Greens');
```

> * **展示前5个宝可梦的Defense,Attack,HP的堆积条形图**

```python
pokemon = df['Name'][:5]
hp = df['HP'][:5]
attack = df['Attack'][:5]
defense = df['Defense'][:5]
ind = [x for x, _ in enumerate(pokemon)]

plt.figure(figsize=(10,10))
plt.bar(ind, defense, width=0.8, label='Defense', color='blue', bottom=attack+hp)
plt.bar(ind, attack, width=0.8, label='Attack', color='gold', bottom=hp)
plt.bar(ind, hp, width=0.8, label='Hp', color='red')

plt.xticks(ind, pokemon)
plt.ylabel("Value")
plt.xlabel("Pokemon")
plt.legend(loc="upper right")
plt.title("5 Pokemon Defense & Attack & Hp")

plt.show()
```

> * **展示前5个宝可梦的Attack,HP的簇状条形图**

```python
N = 5
pokemon_hp = df['HP'][:5]
pokemon_attack = df['Attack'][:5]

ind = np.arange(N) 
width = 0.35       
plt.bar(ind, pokemon_hp, width, label='HP')
plt.bar(ind + width, pokemon_attack, width,label='Attack')

plt.ylabel('Values')
plt.title('Pokemon Hp & Attack')

plt.xticks(ind + width / 2, (df['Name'][:5]),rotation=45)
plt.legend(loc='best')
plt.show()
```

> * **展示前5个宝可梦的Defense,Attack,HP的堆积图**

```python
x = df['Name'][:4]
y1 = df['HP'][:4]
y2 = df['Attack'][:4]
y3 = df['Defense'][:4]

labels = ["HP ", "Attack", "Defense"]

fig, ax = plt.subplots()
ax.stackplot(x, y1, y2, y3)
ax.legend(loc='upper left', labels=labels)
plt.xticks(rotation=90)
plt.show()
```

> * **公用x轴,展示前5个宝可梦的Defense,Attack,HP的折线图**

```python
x = df['Name'][:5]
y1 = df['HP'][:5]
y2 = df['Attack'][:5]
y3 = df['Defense'][:5]

# Create two subplots sharing y axis
fig, (ax1, ax2,ax3) = plt.subplots(3, sharey=True)

ax1.plot(x, y1, 'ko-')
ax1.set(title='3 subplots', ylabel='HP')

ax2.plot(x, y2, 'r.-')
ax2.set(xlabel='Pokemon', ylabel='Attack')

ax3.plot(x, y3, ':')
ax3.set(xlabel='Pokemon', ylabel='Defense')

plt.show()
```

> * **展示前15个宝可梦的Attack,HP的折线图**

```python
plt.plot(df['HP'][:15], '-r',label='HP')
plt.plot(df['Attack'][:15], ':g',label='Attack')
plt.legend();
```

> * **用scatter的x,y,c属性,展示所有宝可梦的Defense,Attack,HP数据**

```python
x = df['Attack']
y = df['Defense']
colors = df['HP']

plt.scatter(x, y, c=colors, alpha=0.5)
plt.title('Scatter plot')
plt.xlabel('HP')
plt.ylabel('Attack')
plt.colorbar();
```

> * **展示所有宝可梦的攻击力的分布直方图,bins=10**

```python
x = df['Attack']
num_bins = 10
n, bins, patches = plt.hist(x, num_bins, facecolor='blue', alpha=0.5)
plt.title('Histogram')
plt.xlabel('Attack')
plt.ylabel('Value')
plt.show()
```

> * **展示所有宝可梦Type 1的饼图**

```python
plt.figure(1, figsize=(8,8))
df['Type 1'].value_counts().plot.pie(autopct="%1.1f%%")
plt.legend()
```

> * **展示所有宝可梦Type 1的柱状图**

```python
ax = df['Type 1'].value_counts().plot.bar(figsize = (12,6),fontsize = 14)
ax.set_title("Pokemon Type 1 Count", fontsize = 20)
ax.set_xlabel("Pokemon Type 1", fontsize = 20)
ax.set_ylabel("Value", fontsize = 20)

plt.show()
```

> * **展示综合评分最高的10只宝可梦的系数间的相关系数矩阵**

```python
import seaborn as sns

top_10_pokemon=df.sort_values(by='Total',ascending=False).head(10)
corr=top_10_pokemon.corr()

fig, ax=plt.subplots(figsize=(10, 6))
sns.heatmap(corr,annot=True)
ax.set_ylim(9, 0)
plt.show()
```

> * **标题/图例/坐标轴标签无法设置成中文**

```python
# 开头导入以下几行代码即可
import matplotlib as mpl
mpl.rcParams['font.sans-serif']=['Microsoft YaHei']  # 步骤一(替换sans-serif字体)
mpl.rcParams['axes.unicode_minus']=False   # 步骤二(解决坐标轴负数的负号显示问题)
```

或

```python
plt.rcParams['font.sans-serif'] = ['SimHei']  
plt.rcParams['axes.unicode_minus'] = False  
```

## 二、样例

### 2.1 Lines,bars and markers

* **Filled polygon**

```python
import numpy as np
import matplotlib.pyplot as plt


def koch_snowflake(order, scale=10):
    """
    Return two lists x, y of point coordinates of the Koch snowflake.
    Arguments
    ---------
    order : int
        The recursion depth.
    scale : float
        The extent of the snowflake (edge length of the base triangle).
    """
    def _koch_snowflake_complex(order):
        if order == 0:
            # initial triangle
            angles = np.array([0, 120, 240]) + 90
            return scale / np.sqrt(3) * np.exp(np.deg2rad(angles) * 1j)
        else:
            ZR = 0.5 - 0.5j * np.sqrt(3) / 3

            p1 = _koch_snowflake_complex(order - 1)  # start points
            p2 = np.roll(p1, shift=-1)  # end points
            dp = p2 - p1  # connection vectors

            new_points = np.empty(len(p1) * 4, dtype=np.complex128)
            new_points[::4] = p1
            new_points[1::4] = p1 + dp / 3
            new_points[2::4] = p1 + dp * ZR
            new_points[3::4] = p1 + dp / 3 * 2
            return new_points

    points = _koch_snowflake_complex(order)
    x, y = points.real, points.imag
    return x, y
```
基本使用:

```python
x, y = koch_snowflake(order=5)

plt.figure(figsize=(8, 8))
plt.axis('equal')
plt.fill(x, y)
plt.show()
```

![](http://matplotlib.org/3.1.1/_images/sphx_glr_fill_001.png)

使用facecolor和edgecolor来修改颜色:

```python
x, y = koch_snowflake(order=2)

fig, (ax1, ax2, ax3) = plt.subplots(1, 3, figsize=(9, 3),
                                    subplot_kw={'aspect': 'equal'})
ax1.fill(x, y)
ax2.fill(x, y, facecolor='lightsalmon', edgecolor='orangered', linewidth=3)
ax3.fill(x, y, facecolor='none', edgecolor='purple', linewidth=3)

plt.show() # 自己试验
```

### 2.2 Images, contours and fields

* **Barcode Demo**

```python
"""
============
Barcode Demo
============

This demo shows how to produce a one-dimensional image, or "bar code".
"""
import matplotlib.pyplot as plt
import numpy as np

# Fixing random state for reproducibility
np.random.seed(19680801)

# the bar
x = np.random.rand(500) > 0.7

barprops = dict(aspect='auto', cmap='binary', interpolation='nearest')

fig = plt.figure()

# a vertical barcode
ax1 = fig.add_axes([0.1, 0.1, 0.1, 0.8])
ax1.set_axis_off()
ax1.imshow(x.reshape((-1, 1)), **barprops)

# a horizontal barcode
ax2 = fig.add_axes([0.3, 0.4, 0.6, 0.2])
ax2.set_axis_off()
ax2.imshow(x.reshape((1, -1)), **barprops)

plt.show()
```


* **Creating annotated heatmaps**

**A simple categorical heatmap:**

```python
import numpy as np
import matplotlib
import matplotlib.pyplot as plt
# sphinx_gallery_thumbnail_number = 2

vegetables = ["cucumber", "tomato", "lettuce", "asparagus",
              "potato", "wheat", "barley"]
farmers = ["Farmer Joe", "Upland Bros.", "Smith Gardening",
           "Agrifun", "Organiculture", "BioGoods Ltd.", "Cornylee Corp."]

harvest = np.array([[0.8, 2.4, 2.5, 3.9, 0.0, 4.0, 0.0],
                    [2.4, 0.0, 4.0, 1.0, 2.7, 0.0, 0.0],
                    [1.1, 2.4, 0.8, 4.3, 1.9, 4.4, 0.0],
                    [0.6, 0.0, 0.3, 0.0, 3.1, 0.0, 0.0],
                    [0.7, 1.7, 0.6, 2.6, 2.2, 6.2, 0.0],
                    [1.3, 1.2, 0.0, 0.0, 0.0, 3.2, 5.1],
                    [0.1, 2.0, 0.0, 1.4, 0.0, 1.9, 6.3]])


fig, ax = plt.subplots()
im = ax.imshow(harvest)

# We want to show all ticks...
ax.set_xticks(np.arange(len(farmers)))
ax.set_yticks(np.arange(len(vegetables)))
# ... and label them with the respective list entries
ax.set_xticklabels(farmers)
ax.set_yticklabels(vegetables)

# Rotate the tick labels and set their alignment.
plt.setp(ax.get_xticklabels(), rotation=45, ha="right", rotation_mode="anchor")

# Loop over data dimensions and create text annotations.
for i in range(len(vegetables)):
    for j in range(len(farmers)):
        text = ax.text(j, i, harvest[i, j], ha="center", va="center", color="w")

ax.set_title("Harvest of local farmers (in tons/year)")
fig.tight_layout()
plt.show()
```

**Using the helper function code style:**

```python
def heatmap(data, row_labels, col_labels, ax=None, cbar_kw={}, cbarlabel="", **kwargs):
    """
    Create a heatmap from a numpy array and two lists of labels.
    Parameters
    -------------
    data
        A 2D numpy array of shape (N, M).
    row_labels
        A list or array of length N with the labels for the rows.
    col_labels
        A list or array of length M with the labels for the columns.
    ax
        A `matplotlib.axes.Axes` instance to which the heatmap is plotted.  If
        not provided, use current axes or create a new one.  Optional.
    cbar_kw
        A dictionary with arguments to `matplotlib.Figure.colorbar`.  Optional.
    cbarlabel
        The label for the colorbar.  Optional.
    **kwargs
        All other arguments are forwarded to `imshow`.
    """

    if not ax:
        ax = plt.gca()

    # Plot the heatmap
    im = ax.imshow(data, **kwargs)

    # Create colorbar
    cbar = ax.figure.colorbar(im, ax=ax, **cbar_kw)
    cbar.ax.set_ylabel(cbarlabel, rotation=-90, va="bottom")

    # We want to show all ticks...
    ax.set_xticks(np.arange(data.shape[1]))
    ax.set_yticks(np.arange(data.shape[0]))
    # ... and label them with the respective list entries.
    ax.set_xticklabels(col_labels)
    ax.set_yticklabels(row_labels)

    # Let the horizontal axes labeling appear on top.
    ax.tick_params(top=True, bottom=False,labeltop=True, labelbottom=False)

    # Rotate the tick labels and set their alignment.
    plt.setp(ax.get_xticklabels(), rotation=-30, ha="right", rotation_mode="anchor")

    # Turn spines off and create white grid.
    for edge, spine in ax.spines.items():
        spine.set_visible(False)

    ax.set_xticks(np.arange(data.shape[1]+1)-.5, minor=True)
    ax.set_yticks(np.arange(data.shape[0]+1)-.5, minor=True)
    ax.grid(which="minor", color="w", linestyle='-', linewidth=3)
    ax.tick_params(which="minor", bottom=False, left=False)

    return im, cbar


def annotate_heatmap(im, data=None, valfmt="{x:.2f}", textcolors=["black", "white"], 
                     threshold=None, **textkw):
    """
    A function to annotate a heatmap.
    Parameters
    ---------------
    im
        The AxesImage to be labeled.
    data
        Data used to annotate.  If None, the image's data is used.  Optional.
    valfmt
        The format of the annotations inside the heatmap.  This should either
        use the string format method, e.g. "$ {x:.2f}", or be a
        `matplotlib.ticker.Formatter`.  Optional.
    textcolors
        A list or array of two color specifications.  The first is used for
        values below a threshold, the second for those above.  Optional.
    threshold
        Value in data units according to which the colors from textcolors are
        applied.  If None (the default) uses the middle of the colormap as
        separation.  Optional.
    **kwargs
        All other arguments are forwarded to each call to `text` used to create
        the text labels.
    """

    if not isinstance(data, (list, np.ndarray)):
        data = im.get_array()

    # Normalize the threshold to the images color range.
    if threshold is not None:
        threshold = im.norm(threshold)
    else:
        threshold = im.norm(data.max())/2.

    # Set default alignment to center, but allow it to be overwritten by textkw.
    kw = dict(horizontalalignment="center", verticalalignment="center")
    kw.update(textkw)

    # Get the formatter in case a string is supplied
    if isinstance(valfmt, str):
        valfmt = matplotlib.ticker.StrMethodFormatter(valfmt)

    # Loop over the data and create a `Text` for each "pixel".
    # Change the text's color depending on the data.
    texts = []
    for i in range(data.shape[0]):
        for j in range(data.shape[1]):
            kw.update(color=textcolors[int(im.norm(data[i, j]) > threshold)])
            text = im.axes.text(j, i, valfmt(data[i, j], None), **kw)
            texts.append(text)

    return texts

fig, ax = plt.subplots()
im, cbar = heatmap(harvest, vegetables, farmers, ax=ax,cmap="YlGn", cbarlabel="harvest [t/year]")
texts = annotate_heatmap(im, valfmt="{x:.1f} t")

fig.tight_layout()
plt.show()
```

**Some more complex heatmap examples:**

```python
np.random.seed(19680801)
fig, ((ax, ax2), (ax3, ax4)) = plt.subplots(2, 2, figsize=(8, 6))

# Replicate the above example with a different font size and colormap.
im, _ = heatmap(harvest, vegetables, farmers, ax=ax, cmap="Wistia", cbarlabel="harvest [t/year]")
annotate_heatmap(im, valfmt="{x:.1f}", size=7)

# Create some new data, give further arguments to imshow (vmin),
# use an integer format on the annotations and provide some colors.
data = np.random.randint(2, 100, size=(7, 7))
y = ["Book {}".format(i) for i in range(1, 8)]
x = ["Store {}".format(i) for i in list("ABCDEFG")]
im, _ = heatmap(data, y, x, ax=ax2, vmin=0, cmap="magma_r", cbarlabel="weekly sold copies")
annotate_heatmap(im, valfmt="{x:d}", size=7, threshold=20, textcolors=["red", "white"])

# Sometimes even the data itself is categorical. Here we use a
# :class:`matplotlib.colors.BoundaryNorm` to get the data into classes
# and use this to colorize the plot, but also to obtain the class
# labels from an array of classes.

data = np.random.randn(6, 6)
y = ["Prod. {}".format(i) for i in range(10, 70, 10)]
x = ["Cycle {}".format(i) for i in range(1, 7)]

qrates = np.array(list("ABCDEFG"))
norm = matplotlib.colors.BoundaryNorm(np.linspace(-3.5, 3.5, 8), 7)
fmt = matplotlib.ticker.FuncFormatter(lambda x, pos: qrates[::-1][norm(x)])

im, _ = heatmap(data, y, x, ax=ax3,cmap=plt.get_cmap("PiYG", 7), norm=norm,
                cbar_kw=dict(ticks=np.arange(-3, 4), format=fmt),cbarlabel="Quality Rating")
annotate_heatmap(im, valfmt=fmt, size=9, fontweight="bold", threshold=-1,
                 textcolors=["red", "black"])

# We can nicely plot a correlation matrix. Since this is bound by -1 and 1,
# we use those as vmin and vmax. We may also remove leading zeros and hide
# the diagonal elements (which are all 1) by using a
# :class:`matplotlib.ticker.FuncFormatter`.
corr_matrix = np.corrcoef(np.random.rand(6, 5))
im, _ = heatmap(corr_matrix, vegetables, vegetables, ax=ax4, cmap="PuOr", vmin=-1, vmax=1,
                cbarlabel="correlation coeff.")


def func(x, pos):
    return "{:.2f}".format(x).replace("0.", ".").replace("1.00", "")

annotate_heatmap(im, valfmt=matplotlib.ticker.FuncFormatter(func), size=7)

plt.tight_layout()
plt.show()
```

### 2.3 Subplots, axes and figures

### 2.4 Statistics

* **Demo of the histogram (hist) function with a few features**

```python
"""
=========================================================
Demo of the histogram (hist) function with a few features
=========================================================

In addition to the basic histogram, this demo shows a few optional features:

* Setting the number of data bins.
* The ``normed`` flag, which normalizes bin heights so that the integral of
  the histogram is 1. The resulting histogram is an approximation of the
  probability density function.
* Setting the face color of the bars.
* Setting the opacity (alpha value).

Selecting different bin counts and sizes can significantly affect the shape
of a histogram. The Astropy docs have a great section_ on how to select these
parameters.

.. _section: http://docs.astropy.org/en/stable/visualization/histogram.html
"""

import matplotlib
import numpy as np
import matplotlib.pyplot as plt

np.random.seed(19680801)

# example data
mu = 100  # mean of distribution
sigma = 15  # standard deviation of distribution
x = mu + sigma * np.random.randn(437)

num_bins = 50

fig, ax = plt.subplots()

# the histogram of the data
n, bins, patches = ax.hist(x, num_bins, density=1)

# add a 'best fit' line
y = ((1 / (np.sqrt(2 * np.pi) * sigma)) * np.exp(-0.5 * (1 / sigma * (bins - mu))**2))
ax.plot(bins, y, '--')
ax.set_xlabel('Smarts')
ax.set_ylabel('Probability density')
ax.set_title(r'Histogram of IQ: $\mu=100$, $\sigma=15$')

# Tweak spacing to prevent clipping of ylabel
fig.tight_layout()
plt.show()
```



## 六、scipy教程


## 七、tensorflow

```python
# 导入tensorflow库简写为tf,并输出版本
import tensorflow as tf
tf.__version__
```
### 7.1 Tensor张量

* **常量**

```python
# 创建一个3x3的0常量张量
c = tf.zeros([3, 3])
# 根据张量的形状,创建一个一样形状的1常量张量
tf.ones_like(c)
# 创建一个2x3,数值全为6的常量张量
tf.fill([2, 3], 6)  # 2x3全为6的常量Tensor
# 创建3x3随机的随机数组
tf.random.normal([3,3])
# 通过二维数组创建一个常量张量
a = tf.constant([[1, 2], [3, 4]])  # 形状为(2, 2)的二维常量
# 取出张量中的numpy数组
a.numpy()
# 从1.0-10.0等间距取出5个数形成一个常量张量
tf.linspace(1.0, 10.0, 5)
# 从1开始间隔2取1个数字，到大等于10为止
tf.range(start=1, limit=10, delta=2)
```

* **运算**

```python
# 将两个张量相加
a + a
# 将两个张量做矩阵乘法
tf.matmul(a, a)
# 两个张量做点乘
tf.multiply(a, a)
# 将一个张量转置
tf.linalg.matrix_transpose(c)
# 将一个12x1张量变形成3行的张量
b = tf.linspace(1.0, 10.0, 12)
tf.reshape(b,[3,4])
## 方法二
tf.reshape(b,[3,-1])
```

### 7.2 自动微分
这一部分将会实现$y=x^2$在$x=1$处的导数

* **变量**

```python
# 新建一个1x1变量,值为1
x = tf.Variable([1.0])
# 新建一个GradientTape追踪梯度,把要微分的公式写在里面
with tf.GradientTape() as tape:  # 追踪梯度
    y = x * x
# 求y对于x的导数
grad = tape.gradient(y, x)  # 计算梯度
```

### 7.3 线性回归案例

这一部分将生成添加随机噪声的沿100个$y=3x+2$的数据点,再对这些数据点进行拟合。

```python
# 生成X,y数据,X为100个随机数,y=3X+2+noise,noise为100个随机数
X = tf.random.normal([100, 1]).numpy()
noise = tf.random.normal([100, 1]).numpy()
y = 3*X+2+noise

# 可视化这些点
plt.scatter(X, y)
# 创建需要预测的参数W,b(变量张量)
W = tf.Variable(np.random.randn())
b = tf.Variable(np.random.randn())
print('W: %f, b: %f'%(W.numpy(), b.numpy()))
# 创建线性回归预测模型
def linear_regression(x):
    return W * x + b
# 创建损失函数，此处采用真实值与预测值的差的平方
def mean_square(y_pred, y_true):
    return tf.reduce_mean(tf.square(y_pred-y_true))
# 创建GradientTape,写入需要微分的过程
with tf.GradientTape() as tape:
    pred = linear_regression(X)
    loss = mean_square(pred, y)
# 对loss,分别求关于W,b的偏导数
dW, db = tape.gradient(loss, [W, b])
# 用最简单朴素的梯度下降更新W,b,learning_rate设置为0.1
W.assign_sub(0.1*dW)
b.assign_sub(0.1*db)
print('W: %f, b: %f'%(W.numpy(), b.numpy()))
# 以上就是单次迭代的过程,现在我们要继续循环迭代20次,并且记录每次的loss,W,b
for i in range(20):
    with tf.GradientTape() as tape:
        pred = linear_regression(X)
        loss = mean_square(pred, y)
    dW, db = tape.gradient(loss, [W, b])
    W.assign_sub(0.1*dW)
    b.assign_sub(0.1*db)
    print("step: %i, loss: %f, W: %f, b: %f" % (i+1, loss, W.numpy(), b.numpy()))
# 画出最终拟合的曲线
plt.plot(X, y, 'ro', label='Original data')
plt.plot(X, np.array(W * X + b), label='Fitted line')
plt.legend()
plt.show()
```

### 7.4 变量保存&读取

这一部分,我们实现最简单的保存&读取变量值

```python
# 新建一个Checkpoint对象，并且往里灌一个刚刚训练完的数据
save = tf.train.Checkpoint()
save.listed = [fc3_b]
save.mapped = {'fc3_b': save.listed[0]}
# 利用save()的方法保存，并且记录返回的保存路径
save_path = save.save('/home/kesci/work/data/tf_list_example')
print(save_path)
# 新建一个Checkpoint对象,从里读出数据
restore = tf.train.Checkpoint()
fc3_b2 = tf.Variable(tf.zeros([10]))
print(fc3_b2.numpy())
restore.restore(save_path)
print(fc3_b2.numpy())
```


## 八、python压缩

压缩文件格式一般有下列几种:

> gz:即gzip,通常只能压缩一个文件。与tar结合起来就可以实现先打包,再压缩。
> 
> tar:linux系统下的打包工具,只打包,不压缩
> 
> tgz:即tar.gz。先用tar打包,然后再用gz压缩得到的文件
> 
> zip:不同于gzip,虽然使用相似的算法,可以打包压缩多个文件,不过分别压缩文件,压缩率低于tar。
> 
> rar:打包压缩文件,最初用于DOS,基于window操作系统。压缩率比zip高,但速度慢,随机访问的速度也慢。


* **gz**

由于gz一般只压缩一个文件,所有常与其他打包工具一起工作。比如可以先用tar打包为XXX.tar,然后在压缩为XXX.tar.gz

```python

import gzip
import os
def un_gz(file_name):
    """ungz zip file"""
    f_name = file_name.replace(".gz", "")
    #获取文件的名称，去掉
    g_file = gzip.GzipFile(file_name)
    #创建gzip对象
    open(f_name, "w+").write(g_file.read())
    #gzip对象用read()打开后，写入open()建立的文件中。
    g_file.close()
    #关闭gzip对象
```

* **tar**

XXX.tar.gz解压后得到XXX.tar,还要进一步解压出来。

```python
import tarfile
def un_tar(file_name):
       untar zip file"""
    tar = tarfile.open(file_name)
    names = tar.getnames()
    if os.path.isdir(file_name + "_files"):
        pass
    else:
        os.mkdir(file_name + "_files")
    #由于解压后是许多文件，预先建立同名文件夹
    for name in names:
        tar.extract(name, file_name + "_files/")
    tar.close()
```

* **zip**

与tar类似,先读取多个文件名,然后解压,如下：

```python
import zipfile
def un_zip(file_name):
    """unzip zip file"""
    zip_file = zipfile.ZipFile(file_name)
    if os.path.isdir(file_name + "_files"):
        pass
    else:
        os.mkdir(file_name + "_files")
    for names in zip_file.namelist():
        zip_file.extract(names,file_name + "_files/")
    zip_file.close()
```

* **rar**

```python
import rarfile
import os
def un_rar(file_name):
    """unrar zip file"""
    rar = rarfile.RarFile(file_name)
    if os.path.isdir(file_name + "_files"):
        pass
    else:
        os.mkdir(file_name + "_files")
    os.chdir(file_name + "_files"):
    rar.extractall()
    rar.close()
```

* **tar打包**

在写打包代码的过程中,使用tar.add()增加文件时,会把文件本身的路径也加进去,加上arcname就能根据自己的命名规则将文件加入tar包

```python
# 打包代码：
import tarfile  
import os  
import time  
  
start = time.time()  
tar=tarfile.open('/path/to/your.tar,'w')  
for root,dir,files in os.walk('/path/to/dir/'):  
        for file in files:  
                fullpath=os.path.join(root,file)  
                tar.add(fullpath,arcname=file)  
tar.close()  
print time.time()-start  
```

在打包的过程中可以设置压缩规则,如想要以gz压缩的格式打包:`tar=tarfile.open('/path/to/your.tar.gz','w:gz')`,其他格式如下表:(tarfile.open的mode有很多种)

| mode | action |
| `'r'` or `'r:*'` | Open for reading with transparent compression (recommended). |
| `'r:'` | Open for reading exclusively without compression. |
| `'r:gz'` | Open for reading with gzip compression. |
| `'r:bz2'` | Open for reading with bzip2 compression. |
| `'a'` or `'a:'` | Open for appending with no compression. The file is created if it does not exist. |
| `'w' or 'w:'` | Open for uncompressed writing. |
| `'w:gz'` | Open for gzip compressed writing. |
| `'w:bz2'` | Open for bzip2 compressed writing. |
 
* **tar解包**

tar解包也可以根据不同压缩格式来解压。

```python
import tarfile  
import time  
  
start = time.time()  
t = tarfile.open("/path/to/your.tar", "r:")  
t.extractall(path = '/path/to/extractdir/')  
t.close()  
print time.time()-start  
```

```python 
tar = tarfile.open(filename, 'r:gz')  
for tar_info in tar:  
    file = tar.extractfile(tar_info)  
    do_something_with(file) 
```