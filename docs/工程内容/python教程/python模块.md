# python模块

## 一、模块打包
### 1.1 setup.py编写简易指南

`python`有非常丰富的第三方库可以使用,很多开发者会向pypi上提交自己的`python`包。要想向`pypi`包仓库提交自己开发的包,首先要将自己的代码打包,才能上传分发。

* **`distutils`简介**

`distutils`是标准库中负责建立`python`第三方库的安装器,使用它能够进行`python`模块的安装和发布。`distutils`对于简单的分发很有用,但功能缺少。大部分`python`用户会使用更先进的`setuptools`模块。

* **`setuptools`简介**

`setuptools`是`distutils`增强版,不包括在标准库中。其扩展了很多功能,能够帮助开发者更好的创建和分发`python`包。大部分`python`用户都会使用更先进的`setuptools`模块。

`Setuptools`有一个`fork`分支是`distribute`。它们共享相同的命名空间,因此如果安装了`distribute`,`import setuptools`时实际上将导入使用`distribute`创建的包。`Distribute`已经合并回`setuptools`。

还有一个大包分发工具是`distutils2`,其试图尝试充分利用`distutils`,`detuptools`和`distribute`并成为`python`标准库中的标准工具。但该计划并没有达到预期的目的,且已经是一个废弃的项目。

因此`setuptools`是一个优秀的，可靠的`python`包安装与分发工具。以下设计到包的安装与分发均针对`setuptools`,并不保证`distutils`可用。

* **包格式**

`python`库打包的格式包括`wheel`和`egg`。`egg`格式是由`setuptools`在`2004`年引入,而`wheel`格式是由`PEP427`在2012年定义。使用`wheel`和`egg`安装都不需要重新构建和编译,其在发布之前就应该完成测试和构建。

`egg`和`wheel`本质上都是一个zip格式包,`egg`文件使用`.egg`扩展名,`wheel`使用`.whl`扩展名。`wheel`的出现是为了替代`egg`,其现在被认为是`python`的二进制包的标准格式。

以下是`wheel`和`egg`的主要区别:

> * `wheel`有一个官方的`PEP427`来定义,而`egg`没有PEP定义
> * `wheel`是一种分发格式,即打包格式。而`egg`既是一种分发格式,也是一种运行时安装的格式,并且是可以被直接`import
 wheel`文件不会包含`.pyc`文件
> * `wheel`使用和PEP376兼容的`.dist-info`目录,而`egg`使用`.egg-info`目录
> * `wheel`有着更丰富的命名规则。
> * `wheel`是有版本的。每个`wheel`文件都包含`wheel`规范的版本和打包的实现
> * `wheel`在内部被sysconfig path type管理,因此转向其他格式也更容易

* **`setup.py`文件**

`python`库打包分发的关键在于编写`setup.py`文件。`setup.py`文件编写的规则是从`setuptools`或者`distuils`模块导入`setup`函数,并传入各类参数进行调用。

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

`setup`函数常用的参数如下：

| 参数 | 说明 |
| :--- | :---: |
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
| `py_modules` | 需要打包的`python`单文件列表 |
| `download_url` | 程序的下载地址 |
| `cmdclass` | 添加自定义命令 |
| `package_data` | 指定包内需要包含的数据文件 |
| `include_package_data` | 自动包含包内所有受版本控制(`cvs/svn/git`)的数据文件 |
| `exclude_package_data` | 当`include_package_data`为`True`时该选项用于排除部分文件 |
| `data_files` | 打包时需要打包的数据文件,如图片、配置文件等 |
| `ext_modules` | 指定扩展模块 |
| `scripts` | 指定可执行脚本,安装时脚本会被安装到系统`PATH`路径下 |
| `package_dir` | 指定哪些目录下的文件被映射到哪个源码包 | 
| `requires` | 指定依赖的其他包 | 
| `provides` | 指定可以为哪些模块提供依赖 |
| `install_requires` | 安装时需要安装的依赖包 |
| `entry_points` | 动态发现服务和插件,下面详细讲 |
| `setup_requires` | 指定运行`setup.py`文件本身所依赖的包 |
| `dependency_links` | 指定依赖包的下载地址 |
| `extras_require` | 当前包的高级/额外特性需要依赖的分发包 |
| `zip_safe` | 不压缩包,而是以目录的形式安装 |

更多参数可见: https://setuptools.readthedocs.io/en/latest/setuptools.html

> * `find_packages`

对于简单工程来说,手动增加`packages`参数是容易。而对于复杂的工程来说,可能添加很多的包,这是手动添加就变得麻烦。`setuptools`模块提供了一个`find_packages`函数,它默认在与`setup.py`文件同一目录下搜索各个含有`__init__.py`的目录做为要添加的包。

```python
find_packages(where='.', exclude=(), include=('*',))
```

`find_packages`函数的第一个参数用于指定在哪个目录下搜索包,参数`exclude`用于指定排除哪些包,参数`include`指出要包含的包。

默认默认情况下`setup.py`文件只在其所在的目录下搜索包。如果不用`find_packages`,想要找到其他目录下的包,也可以设置`package_dir`参数,其指定哪些目录下的文件被映射到哪个源码包,如:`package_dir={'': 'src'}`表示"`root package`"中的模块都在`src`目录中。

> * **包含数据文件**

**`package_data`:**

该参数是一个从包名称到`glob`模式列表的字典。如果数据文件包含在包的子目录中,则`glob`可以包括子目录名称。其格式一般为`{'package_name': ['files']}`,比如:`package_data={'mypkg': ['data/*.dat'],}`。

**`include_package_data`:**

该参数被设置为`True`时自动添加包中受版本控制的数据文件,可替代`package_data`,同时`exclude_package_data`可以排除某些文件。注意当需要加入没有被版本控制的文件时,还是仍然需要使用`package_data`参数才行。

**`data_files`:**

该参数通常用于包含不在包内的数据文件,即包的外部文件,如:配置文件,消息目录,数据文件。其指定了一系列二元组,即(目的安装目录、源文件),表示哪些文件被安装到哪些目录中。如果目录名是相对路径,则相对于安装前缀进行解释。

**`manifest template`:**

manifest template即编写`MANIFEST.in`文件,文件内容就是需要包含在分发包中的文件。一个`MANIFEST.in`文件如下:

```
include *.txt
recursive-include examples *.txt *.py
prune examples/sample?/build
```

`MANIFEST.in`文件的编写规则可参考:https://docs.python.org/3.6/distutils/sourcedist.html

> * **生成脚本**

有两个参数`scripts`参数或`console_scripts`可用于生成脚本。

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

`scripts`参数是一个`list`,安装包时在该参数中列出的文件会被安装到系统`PATH`路径下。如:

```python
scripts=['bin/foo.sh', 'bar.py']
```

用如下方法可以将脚本重命名,例如去掉脚本文件的扩展名(`.py`、`.sh`):

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

其中,`cmdclass`参数表示自定制命令,后文详述。

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

// 注册函数
// PyMethodDef列表中结构体成员有四个函数:
//  "add"导出后在pyhton中可见的方法名。
//  W_add实际映射到C中的方法名。
//  METH_VARARGS表示传入方法的是普通参数,当然还可以处理关键词参数。
//  此方法的注释。
static PyMethodDef ExtendMethods[] = {
    {"add", W_add, METH_VARARGS, "a function from C"},
    {NULL, NULL, 0, NULL},
};

// 注册模块
//  方法名必须是init加上模块名,然后调用Py_InitModule来注册模块,
//  这个函数的第一个参数就是模块名,第二个参数是此模块中我们导出的方法,就是上一步定义的结构体
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

如果您正在编写包含在Cpython中的C代码,那么你必须遵循PEP 7。这些指南适用于您所贡献的python版本。除非你最终希望将它们贡献给python,否则你的第三方扩展模块不需要遵循这些约定.


* **包含文件**

使用python所需的所有函数,类型和宏定义C API包含在您的代码中,如下所示:

```c
#include"python.h"
```

这意味着包含以下标准标题:<stdio.h>,<string.h>,<errno.h>,<limits.h>,<assert.h>和<stdlib.h>(如果可用).

注意:

> 由于python可能会定义一些影响某些系统上标准头的预处理器定义,所以在包含任何标准头之前你must包含python.h
>
> python.h定义的所有用户可见名称(包括标准头文件定义的除外)都有一个前缀Py或_Py。以_Py开头的名称供python实现内部使用,不应由扩展编写者使用。结构成员名称没有保留前缀.
>
> 重要的用户代码永远不应该定义以Py或_Py开头的名称。这会使读者感到困惑,并危及用户代码对未来python版本的可移植性,这些版本可能会定义以这些前缀之一开头的其他名称.
>
头文件通常与python一起安装。在Unix上,它们位于prefix/include/pythonversion/和exec_prefix/include/pythonversion/目录中,其中prefix和exec_prefix由python的相应参数定义配置脚本和version是"%d.%d"%sys.version_info[:2]。在Windows上,标题安装在prefix/include中,其中prefix是指定给安装程序的安装目录.
>
> 要包含标题,请将两个目录(如果不同)放在编译器上包含的搜索路径。做not将父目录放在搜索路径上,然后使用#include<pythonX.Y/python.h>;这将打破多平台构建,因为prefix下面的平台独立头包含来自exec_prefix.
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

大多数python/C API函数都有一个或多个参数以及类型的返回值PyObject*。此类型是指向表示任意python对象的不透明数据类型的指针。由于在大多数情况下(例如赋值,范围规则和参数传递),python语言都以相同的方式处理所有python对象类型,因此它们应该由单个C类型表示。几乎所有python对象都存在于堆中:你永远不会声明类型为PyObject,只能声明PyObject*类型的指针变量。唯一的例外是类型对象;因为它们绝对不能被分配,所以它们通常是静态的PyTypeObject对象.

所有python对象(甚至python整数)都有type和referencecount。对象的类型确定它是什么类型的对象(例如,整数,列表或用户定义的函数;还有更多的问题在中标准类型层次结构)。对于每个众所周知的类型,都有一个macroto检查对象是否属于该类型;例如,PyList_Check(a)istrueif(且仅当)a指向的对象是一个python列表.

**引用计数**

引用计数很重要因为今天的计算机有一个有限的(并且是严重限制)内存大小;它计算有多少不同的地方有一个对象的引用。这样的位置可以是另一个对象,或全局(或静态)C变量,或某个C函数中的局部变量。当对象的引用计数变为零时,该对象将被释放。Ifit包含对其他对象的引用,它们的引用计数递减。如果此递减使其引用计数变为零,则可以依次释放其他对象,依此类推。(这里有一个明显的问题,对象在这里相互引用;现在,解决方案是“不要用dothat。”)

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


## 四、numpy教程
