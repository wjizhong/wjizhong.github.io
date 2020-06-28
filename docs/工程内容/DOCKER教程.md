# Docker教程

参考链接:[`https://docs.docker.com/engine/reference/run/`](https://docs.docker.com/engine/reference/run/)

如今Docker的使用已经非常普遍,特别在一线互联网公司。使用Docker技术可以帮助企业快速水平扩展服务,从而到达弹性部署业务的能力。在云服务概念兴起之后,Docker的使用场景和范围进一步发展,如今在微服务架构越来越流行的情况下,微服务+Docker的完美组合,更加方便微服务架构运维部署落地。

## 一、引言

### 1.1 什么是Docker

Docker是世界领先的软件容器平台。开发人员利用Docker可以消除协作编码时“在我的机器上可正常工作”的问题。运维人员利用Docker可以在隔离容器中并行运行和管理应用,获得更好的计算密度。企业利用Docker可以构建敏捷的软件交付管道,以更快的速度、更高的安全性和可靠的信誉为Linux和Windows Server应用发布新功能。Docker属于Linux容器的一种封装,提供简单易用的容器使用接口。它是目前最流行的Linux容器解决方案。Docker将应用程序与该程序的依赖,打包在一个文件里面。运行这个文件,就会生成一个虚拟容器。程序在这个虚拟容器里运行,就好像在真实的物理机上运行一样。有了Docker,就不用担心环境问题。总体来说,Docker的接口相当简单,用户可以方便地创建和使用容器,把自己的应用放入容器。容器还可以进行版本管理、复制、分享、修改,就像管理普通的代码一样。

Docker最初是dotCloud公司创始人Solomon Hykes在法国期间发起的一个公司内部项目,它是基于dotCloud公司多年云服务技术的一次革新,并于2013年3月以Apache 2.0授权协议开源,主要项目代码在GitHub上进行维护。Docker项目后来还加入了Linux基金会,并成立推动开放容器联盟(OCI)。Docker自开源后受到广泛的关注和讨论,至今其GitHub项目已经超过4万6千个星标和一万多个fork。甚至由于Docker项目的火爆,在2013年底,dotCloud公司决定改名为Docker。Docker最初是在Ubuntu 12.04上开发实现的;Red Hat则从RHEL 6.5开始对Docker进行支持;Google也在其PaaS产品中广泛应用Docker。

### 1.2 为什么要使用Docker

容器除了运行其中应用外,基本不消耗额外的系统资源,使得应用的性能很高,同时系统的开销尽量小。传统虚拟机方式运行10个不同的应用就要起10个虚拟机,而Docker只需要启动10个隔离的应用即可。具体说来,Docker在如下几个方面具有较大的优势。

**更快速的交付和部署** :对开发和运维(devop)人员来说,最希望的就是一次创建或配置,可以在任意地方正常运行。开发者可以使用一个标准的镜像来构建一套开发容器,开发完成之后,运维人员可以直接使用这个容器来部署代码。Docker可以快速创建容器,快速迭代应用程序,并让整个过程全程可见,使团队中的其他成员更容易理解应用程序是如何创建和工作的。Docker容器很轻很快!容器的启动时间是秒级的,大量地节约开发、测试、部署的时间。

**更高效的虚拟化** :Docker容器的运行不需要额外的hypervisor支持,它是内核级的虚拟化,因此可以实现更高的性能和效率。

**更轻松的迁移和扩展** :Docker容器几乎可以在任意的平台上运行,包括物理机、虚拟机、公有云、私有云、个人电脑、服务器等。这种兼容性可以让用户把一个应用程序从一个平台直接迁移到另外一个。

**更简单的管理**:使用Docker,只需要小小的修改,就可以替代以往大量的更新工作。所有的修改都以增量的方式被分发和更新,从而实现自动化并且高效的管理。

### 1.3 Docker vs VM

从下图可以看出,VM是一个运行在宿主机之上的完整的操作系统,VM运行自身操作系统会占用较多的CPU、内存、硬盘资源。Docker不同于VM,只包含应用程序以及依赖库,基于libcontainer运行在宿主机上,并处于一个隔离的环境中,这使得Docker更加轻量高效,启动容器只需几秒钟之内完成。由于Docker轻量、资源占用少,使得Docker可以轻易的应用到构建标准化的应用中。但Docker目前还不够完善,比如隔离效果不如VM,共享宿主机操作系统的一些基础库等;网络配置功能相对简单,主要以桥接方式为主;查看日志也不够方便灵活。

<img src="http://www.ityouknow.com/assets/images/2018/docker/docker_vs_vm.png" style="width: 50%"> 

Docker在容器的基础上,进行了进一步的封装,从文件系统、网络互联到进程隔离等等,极大的简化了容器的创建和维护。使得Docker技术比虚拟机技术更为轻便、快捷。作为一种新兴的虚拟化方式,Docker跟传统的虚拟化方式相比具有众多的优势。Docker容器的启动可以在秒级实现,这相比传统的虚拟机方式要快得多;Docker对系统资源的利用率很高,一台主机上可以同时运行数千个Docker容器。

### 1.4 相关概念

Docker是CS架构,主要有两个概念:

> **Docker daemon** :运行在宿主机上,Docker守护进程,用户通过Docker client(Docker命令)与Docker daemon交互
> 
> **Docker client** :Docker命令行工具,是用户使用Docker的主要方式,Docker client与Docker daemon通信并将结果返回给用户,Docker client也可以通过socket或者RESTful api访问远程的Docker daemon

<img src="http://www.ityouknow.com/assets/images/2018/docker/docker_component.png" style="width: 50%"> 

了解了Docker的组成,再来了解一下Docker的三个主要概念:

> **Docker image** :镜像是只读的,镜像中包含有需要运行的文件。镜像用来创建container,一个镜像可以运行多个container;镜像可以通过Dockerfile创建,也可以从Docker hub/registry上下载。
> 
> **Docker container** :容器是Docker的运行组件,启动一个镜像就是一个容器,容器是一个隔离环境,多个容器之间不会相互影响,保证容器中的程序运行在一个相对安全的环境中。
> 
> **Docker hub/registry** :共享和管理Docker镜像,用户可以上传或者下载上面的镜像,官方地址为https://registry.hub.docker.com/,也可以搭建自己私有的Docker registry。

镜像就相当于打包好的版本,镜像启动之后运行在容器中,仓库就是装存储镜像的地方。

## 二、Docker配置

### 2.1 Docker安装

建议在linux环境下安装Docker,window环境搭建比较复杂且容易出错,使用Centos7+yum来安装Docker环境很方便。Docker软件包已经包括在默认的CentOS-Extras软件源里。因此想要安装docker,只需要运行yum命令:yum install docker。安装完成后,使用下面的命令来启动docker服务,并将其设置为开机启动:

```sh
systemctl start docker.service
systemctl enable docker.service
```

测试:`docker version`。输入上述命令,返回docker的版本相关信息,证明docker安装成功。

* **docker常用命令**

主要用法:`docker [docker命令选项] [子命令] [子命令选项]`, 可以用`docker [子命令] --help`可查看每个子命令的详细用法。

<img src="http://upload-images.jianshu.io/upload_images/10006770-1cbcbd231e853471" style="width: 50%">

### 2.2 docker命令选项列表

| 选项 | 说明 | 其他 |
| :--- | --- | --- |
| --config [string] | 客户端本地配置文件路径 | 默认为~/.docker |
| -D, --debug | 启用调试模式 | |
| --help | 打印用法 | |
| -H, --host list | 通过socket访问指定的docker守护进程(服务端) | unix://, fd://, tcp:// |
| -l, --log-level [string] | 设置日志级别(debug、info、warn、error、fatal) | 默认为info |
| --tls | 启用TLS加密 |  |
| --tlscacert [string] | 指定信任的CA根证书路径 | 默认为~/.docker/ca.pem |
| --tlscert [string] | 客户端证书路径 | 默认为 ~/.docker/cert.pem |
| --tlskey [string] | 客户端证书私钥路径 | 默认为 ~/.docker/key.pem |
| --tlsverify | 启用TLS加密并验证客户端证书 |  |
| -v, --version | 打印docker客户端版本信息 |  |

### 2.3 镜像仓库

```sh
# docker search [条件]
# 查询三颗星及以上名字包含alpine的镜像
docker search -f=stars=3 alpine

# docker pull [仓库]:[tag]
# 仓库格式为 [仓库url]/[用户名]/[应用名], 除了官方仓库外的第三方仓库要指定url,
# 获取alpine Linux 的镜像
docker pull alpine

# 推送镜像到仓库
docker push [镜像名]:[tag]

# 登录/退出第三方仓库
docker [login/logout] [仓库地址]
```

### 2.4 本地镜像

```sh
# 查看本地镜像
docker images

# 删除本地镜像
docker rmi [镜像名 or 镜像id]
# 如果用镜像id作为参数, 可以只输入前几位,能唯一确定即可(可以同时删除多个镜像, 空格隔开)。
# 此外, 如果该镜像启动了容器需要先删除容器。

# 查看镜像详情
docker inspect [镜像名 or 镜像id]
# 样例结果
    [
        {
            "Id": "sha256:a41a7446062d197dd4b21b38122dcc7b2399deb0750c4110925a7dd37c80f118",
            "RepoTags": [
                "alpine:latest"
            ],
            "RepoDigests": [
                "alpine@sha256:0b94d1d1b5eb130dd0253374552445b39470653fb1a1ec2d81490948876e462c"
            ],
            "Parent": "",
            "Comment": "",
            "Created": "2017-05-25T23:33:22.029729271Z",
            "Container": "19ee1cd90c07eb7b3c359aaec3706e269a871064cca47801122444cef51c5038",
        ......
            }
        }
    ]

# 打包本地镜像, 使用压缩包来完成迁移。默认为文件流输出
docker save [镜像名] > [文件路径]
# 或者使用 '-o' 选项指定输出文件路径
docker save -o /usr/anyesu/docker/alpine.img alpine

# 导入镜像压缩包
# docker load < [文件路径]
# 默认从标准输入读取
docker load < /usr/anyesu/docker/alpine.img
# 用 '-i' 选项指定输入文件路径
docker load -i /usr/anyesu/docker/alpine.img

# 修改镜像tag
# docker tag [镜像名 or 镜像id]  [新镜像名]:[新tag]
docker tag a41 anyesu/alpine:1.0
```

### 2.4 创建容器

创建、启动容器并执行相应的命令:`docker run [参数] [镜像名 or 镜像id] [命令]`

如果没有指定命令是执行镜像默认的命令,创建镜像的时候可设置。另外要注意的一点, 启动容器后要执行一个前台进程(就是能在控制台不断输出的,如tomcat的catalina.sh)才能使容器保持运行状态, 否则, 命令执行完容器就关闭了。

run命令常用选项:

| 选项 | 说明 |
| :--- | --- |
| -d, --detach=false | 指定容器运行于前台还是后台,默认为false。后台运行容器, 并返回容器ID;不指定时, 启动后开始打印日志,Ctrl+C退出命令同时会关闭容器 |
| -i, --interactive=false | 打开STDIN,用于控制台交互 ,通常与-t同时使用 |
| -t, --tty=false   | 分配tty设备,该可以支持终端登录,默认为false 。通常与-i同时使用 |
| -u, --user=""     | 指定容器的用户 |
| -a, --attach=[]   | 登录容器(必须是以docker run -d启动的容器) | 
| -w, --workdir=""  | 指定容器的工作目录 |
| -c, --cpu-shares=0 | 设置容器CPU权重,在CPU共享场景使用 | 
| -e, --env=[]       | 指定环境变量,容器中可以使用该环境变量 |    
| -m, --memory=""    | 指定容器的内存上限 |
| -P, --publish-all=false | 指定容器暴露的端口 |
| -p, --publish=[]        | 指定容器暴露的端口 |
| -h, --hostname=""  | 指定容器的主机名 |
| -v, --volume=[]    | 给容器挂载存储卷,挂载到容器的某个目录 |
| --volumes-from=[]  | 给容器挂载其他容器上的卷,挂载到容器的某个目录 | 
| --cap-add=[]       | 添加权限,权限清单详见:http://linux.die.net/man/7/capabilities  | 
| --cap-drop=[]      | 删除权限,权限清单详见:http://linux.die.net/man/7/capabilities |   
| --cidfile=""       | 运行容器后,在指定文件中写入容器PID值,一种典型的监控系统用法 |
| --cpuset=""        | 设置容器可以使用哪些CPU,此参数可以用来容器独占CPU | 
| --device=[]        | 添加主机设备给容器,相当于设备直通 |    
| --dns=[]           | 指定容器的dns服务器 |
| --dns-search=[]    | 指定容器的dns搜索域名,写入到容器的/etc/resolv.conf文件 |
| --entrypoint=""    | 覆盖image的入口点 |
| --env-file=[]      | 指定环境变量文件,文件格式为每行一个环境变量 |   
| --expose=[]        | 指定容器暴露的端口,即修改镜像的暴露端口 |
| --link=[]          | 指定容器间的关联,使用其他容器的IP、env等信息 |   
| --lxc-conf=[]      | 指定容器的配置文件,只有在指定--exec-driver=lxc时使用 | 
| --name=""          | 指定容器名字,后续可以通过名字进行容器管理,links特性需要使用名字 |   
| --net="bridge"     | 容器网络设置: <br>  bridge使用docker daemon指定的网桥 <br>  host:容器使用主机的网络<br> container:<NAME_or_ID\>:使用其他容器的网路,共享IP和PORT等网络资源<br>none:容器使用自己的网络(类似--net=bridge),但是不进行配置 |
| --privileged=false | 指定容器是否为特权容器,特权容器拥有所有的capabilities |
| --restart="no"     | 指定容器停止后的重启策略:<br>no:容器退出时不重启<br>on-failure:容器故障退出(返回值非零)时重启<br>always:容器退出时总是重启 |  
| --rm=false         | 指定容器停止后自动删除容器(不支持以docker run -d启动的容器) |
| --sig-proxy=true   | 设置由代理接受并处理信号,但是SIGCHLD、SIGSTOP和SIGKILL不能被代理 | 

单字符选项可以合并, 如`-i -t`可以合并为`-it`

### 2.6 容器相关

```sh
# 查看运行中的容器, 加 -a 选项可查看所有的容器
docker ps 

# 开启/停止/重启容器
# 关闭容器(发送SIGTERM信号,做一些'退出前工作',再发送SIGKILL信号)
docker stop ontainer_name/container_id
# 强制关闭容器(默认发送SIGKILL信号, 加-s参数可以发送其他信号)
docker kill ontainer_name/container_id

docker kill $(docker ps -a -q)  # 杀死所有正在运行的容器

# 启动容器
docker start ontainer_name/container_id
# 重启容器
docker restart ontainer_name/container_id

# 删除容器,可以指定多个容器一起删除, 加-f选项可强制删除正在运行的容器
docker rm [容器名 or 容器id]
docker rm $(docker ps -a -q)  # 删除所有已经停止的容器

# 查看容器详情
# docker inspect [容器名 or 容器id]
docker inspect anyesu-container

# 查看容器中正在运行的进程
docker top [容器名 or 容器id]

# 将容器保存为镜像
docker commit [容器名 or 容器id] [镜像名]:[tag]
```

### 2.7 其他命令

```sh
# 使用Dockerfile构建镜像
docker build -t [镜像名]:[tag] -f [DockerFile名] [DockerFile所在目录]

# 显示容器硬件资源使用情况
docker stats [选项] [0个或多个正在运行容器]

# 更新容器的硬件资源限制
docker update [选项]

# 停止所有的container(容器)
docker stop $(docker ps -a -q) 或者 docker stop $(docker ps -aq)
# 如果想要删除所有container(容器)的话再加一个指令:
docker rm $(docker ps -a -q) 或者 docker rm $(docker ps -aq)
# 删除untagged images,也就是那些id为""的image
docker rmi $(docker images | grep "^<none>" | awk "{print $3}")
# 删除所有未打dangling标签的镜像
docker rmi $(docker images -q -f dangling=true)
# 要删除全部image(镜像)的话
docker rmi $(docker images -q)
# 强制删除全部image的话
docker rmi -f $(docker images -q)
# 删除所有不使用的镜像
docker image prune --force --all或者docker image prune -f -a


# 后台启动容器进行调试
docker run -d <image_name> tail -f /dev/null
docker run -i -t <image_name> [command]
# 然后Ctrl+P+Q即可退出控制台,但是容器没有退出
docker run -i -t centos /bin/bash
```

### 2.8 基础子命令列表

| 选项 | 说明 |
| :--- | --- |
| attach | 进入运行中的容器,显示该容器的控制台界面。注意, 从该指令退出会导致容器关闭 |
| build | 根据Dockerfile文件构建镜像 |
| commit | 提交容器所做的改为为一个新的镜像 |
| cp | 在容器和宿主机之间复制文件 |
| create | 根据镜像生成一个新的容器 |
| diff | 展示容器相对于构建它的镜像内容所做的改变 |
| events | 实时打印服务端执行的事件 |
| exec | 在已运行的容器中执行命令 |
| export | 导出容器到本地快照文件 |
| history | 显示镜像每层的变更内容 |
| images | 列出本地所有镜像 |
| import | 导入本地容器快照文件为镜像 |
| info | 显示Docker详细的系统信息 |
| inspect | 查看容器或镜像的配置信息,默认为json数据 |
| kill | -s选项向容器发送信号,默认为SIGKILL信号(强制关闭) |
| load | 导入镜像压缩包 |
| login | 登录第三方仓库 |
| logout | 退出第三方仓库 |
| logs | 打印容器的控制台输出内容 |
| pause | 暂停容器 |
| port | 容器端口映射列表 |
| ps | 列出正在运行的容器,-a选项显示所有容器 |
| pull | 从镜像仓库拉取镜像 |
| push | 将镜像推送到镜像仓库 |
| rename | 重命名容器名 |
| restart | 重启容器 |
| rm | 删除已停止的容器,-f选项可强制删除正在运行的容器 |
| rmi | 删除镜像(必须先删除该镜像构建的所有容器) |
| run | 根据镜像生成并进入一个新的容器 |
| save | 打包本地镜像,使用压缩包来完成迁移 |
| search | 查找镜像 |
| start | 启动关闭的容器 |
| stats | 显示容器对资源的使用情况(内存、CPU、磁盘等) |
| stop | 关闭正在运行的容器 |
| tag | 修改镜像tag |
| top | 显示容器中正在运行的进程(相当于容器内执行`ps -ef`命令) |
| unpause | 恢复暂停的容器 |
| update | 更新容器的硬件资源限制(内存、CPU等) |
| version | 显示docker客户端和服务端版本信息 |
| wait | 阻塞当前命令直到对应的容器被关闭,容器关闭后打印结束代码 |


### 2.9 管理子命令列表

| 选项 | 说明 |
| :--- | --- |
| container | 管理容器 |
| image | 管理镜像 |
| network | 管理容器网络(默认为bridge、host、none三个网络配置) |
| plugin | 管理插件 |
| system | 管理系统资源。其中,`docker system prune`命令用于清理没有使用的镜像,容器,数据卷以及网络 |
| volume | 管理数据卷 |
| swarm | 管理Swarm模式 |
| service | 管理Swarm模式下的服务 |
| node | 管理Swarm模式下的docker集群中的节点 |
| secret | 管理Swarm模式下的敏感数据 |
| stack | Swarm模式下利用compose-file管理服务 |

## 三、搭建私人仓库

### 3.1 概述

Docker Registry是什么?Registry是用于存储和分发Docker镜像的服务端应用程序。个人或组织可以用Registry来搭建自己的Docker镜像仓库。Registry还可以用来搭建Docker Hub的镜像站点(通常说的加速器)。

使用Docker Registry的好处:

> * 严格控制镜像的存储位置
> * 完全自有的镜像分发渠道
> * 将镜像存储和分发紧密地集成到自己的内部开发流程中
> * 其他可选方案

如果你想找一个零成本、开箱即用的解决方案,建议使用Docker Hub。Docker Hub提供了一个免费的Registry,而且添加了一些附加功能(组织账户,自动构建,等等)。寻找Registry商业支持版的用户可以考虑Docker Trusted Registry。

### 3.2 部署一个Registry服务

本节所有操作都在同一台宿主机上完成。

* **部署**

Registry服务本身也是以Docker镜像的形式发布。我们只需要pull一个Registry镜像,然后利用该镜像运行一个容器即可。开启一个Registry服务

```sh
docker run -d -p 5000:5000 --restart=always --name registry registry:latest
```

以上命令将拉取一个registry镜像,创建一个容器,将宿主机的5000端口映射到容器的5000端口。现在一个registry服务就启动了,并监听在5000端口。

* **验证**

从hub pull一个很小的busybox镜像:`docker pull busybox:1.25.1-musl`。给它一个tag,让它指向我们的registry服务:

```sh
docker tag busybox:1.25.1-musl localhost:5000/busybox:1.25.1-musl
```

查看本地现有的镜像

```sh
$ docker images 
REPOSITORY               TAG                 IMAGE ID            CREATED             SIZE
registry                 2.5.1               c9bd19d022f6        4 weeks ago         33.3 MB
busybox                  1.25.1-musl         733eb3059dce        6 weeks ago         1.213 MB
localhost:5000/busybox   1.25.1-musl         733eb3059dce        6 weeks ago         1.213 MB
```

可以看到最后一个busybox仓库名为localhost:5000/busybox指向我们的registry服务。push到我们的registry服务

```sh
$ docker push localhost:5000/busybox:1.25.1-musl 
The push refers to a repository [localhost:5000/busybox]
981f3d18e054: Pushed 
1.25.1-musl: digest: sha256:46634e32e559271b8e18b7f1b21d981da4cd63ed8d36fbdc35c0b56464238a0c size: 527
```

查看registry服务器上是否存在我们刚才push的镜像

```sh
$ curl -XGET 0.0.0.0:5000/v2/_catalog
{"repositories":["busybox"]}
$ curl -XGET 0.0.0.0:5000/v2/busybox/tags/list
{"name":"busybox","tags":["1.25.1-musl"]}
```

`API v2/_catalog`用于查询所有仓库。`v2/busybox/tags/list`用于查看busybox仓库中的所有镜像。上面的输出信息说明前一步的push成功。你还可以删除本地的`localhost:5000/busybox:1.25.1-musl`镜像,再从registry上pull回来。

* **使用**

> * **理解镜像命名**

虽然前面我们快速部署了一个registry,但如果你是第一次使用registry,肯定对前面用的pull和push命令有点疑惑:为什们镜像名这么长？

docker命令行中用到的镜像名都反映了镜像的来源,比如:`docker pull ubuntu`指示docker从官方的Docker Hub上拉取一个名为ubuntu的镜像。该命令其实是`docker pull docker.io/library/ubuntu`的缩写,`docker.io/libary`指明了官方仓库的位置。

`docker push localhost:5000/busybox:1.25.1-mus`指示`docker`将镜像推送到位于`localhost:5000`的registry服务。所以使用registry的方式就是用仓库名将镜像和registry联系起来。使用docker tag命令可以给镜像指定仓库名和tag。

> * **指定镜像存储位置**

Registry默认会通过数据卷将镜像数据保存宿主机的文件系统中,但该数据卷在主机中对应的目录是在创建容器时随机选择的。你可能想明确指定数据卷在host中对应的目录,这样访问镜像数据更方便。

```sh
$ docker run -d -p 5000:5000 --restart=always --name registry -v /var/data:/var/lib/registry 
\ registry:2.5.1
```

`/var/lib/registry`目录是registry容器中默认的保存镜像数据的目录,通过数据卷映射到host的`/var/data`。以后registry服务的镜像都保存在host的`/var/data`目录下。

* **通过HTTP访问registry服务**

> * **跨主机访问registry**

前面部署和验证时,我们都是在同一台宿主机上操作。现在尝试到另一台Docker宿主机上访问registry试试。假设部署有registry的主机为host1,另一台Docker主机为host2。

在host1上查看IP:


```sh
$ ip addr show ens33 
2: ens33: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 00:0c:29:75:75:dc brd ff:ff:ff:ff:ff:ff
    inet 192.168.59.137/24 brd 192.168.59.255 scope global dynamic ens33
       valid_lft 1379sec preferred_lft 1379sec
    inet6 fe80::c55:1d99:7614:31d5/64 scope link 
       valid_lft forever preferred_lft forever
```

host1的网卡名为ens33,你需要根据你主机上的网卡名来查询。我们查询到的IP为`192.168.59.137`。

在host2上访问:

```sh
$ docker pull 192.168.59.137:5000/busybox:1.25.1-musl
Error response from daemon: Get https://192.168.59.137:5000/v1/_ping: http: server gave HTTP response to HTTPS client
```

尝试拉取镜像失败!这是因为registry服务默认接受HTTP访问,而docker默认通过HTTPS访问远程的registry服务。我们可以给registry服务配置HTTPS,也可以在需要访问registry服务的每台Docker主机上强制docker使用HTTP访问指定的registry服务。强制docker通过HTTP访问registry服务。在host2上,编辑`/etc/docker/daemon.json`,加入

```sh
{
    "insecure-registries":["192.168.59.137:5000"]
}
```

重启docker守护进程(还是在host2上):

```sh
$ sudo service docker restart
```

再次访问host1上的registry服务:

```sh
$ docker pull 192.168.59.137:5000/busybox:1.25.1-musl
1.25.1-musl: Pulling from busybox
Digest: sha256:46634e32e559271b8e18b7f1b21d981da4cd63ed8d36fbdc35c0b56464238a0c
Status: Downloaded newer image for 192.168.59.137:5000/busybox:1.25.1-musl
```

以后在每台需要访问该registry服务的Docker主机上都需要这么修改。

* **Registry配置HTTPS**

> * **使用自签名证书-针对域名签证**

如果你的registry服务有域名,或者你可以自定义一个域名,在每台需要访问该registry服务的Docker主机上在hosts文件中添加自定义域名到该registry服务主机IP的映射。

**step 1:** 生成自签名证书

```sh
$ mkdir certs
$ openssl req -newkey rsa:4096 -nodes -sha256 -keyout certs/domain.key  -x509 -days 365 -out certs/domain.crt
```

命令会进入交互式模式,你需要输入国家、省、市、组织名、域名:

```sh
Country Name (2 letter code) [AU]:CN
State or Province Name (full name) [Some-State]:Shangxi
Locality Name (eg, city) []:Xian 
Organization Name (eg, company) [Internet Widgits Pty Ltd]:sse lab
Organizational Unit Name (eg, section) []:sse lab
Common Name (e.g. server FQDN or YOUR name) []:example.com
Email Address []:*****@**.com
```

填写Common Name时要特别注意,要填写正确的域名。这里假设域名为example.com执行完毕后会在certs目录下生成私钥文件domain.key、证书文件domain.crt。

**step 2:** 启动支持HTTPS访问的registry服务

确保掉前面启动的registry服务已经停止和删除。

```sh
$ docker run -d -p 5000:5000 --restart=always --name registry -v pwd/certs:/certs \
    -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt \
    -e REGISTRY_HTTP_TLS_KEY=/certs/domain.key registry:2.5.1
```

该命令启动了一个registry容器,并通过数据卷将证书和私钥传进了容器,并通过环境变量指定了其路径。

**step3:** 将证书文件复制到每台需要访问registry服务的客户机

由于是自签名证书,我们需要将生成的证书文件给客户机,客户机才能信任registry服务。准备好前面生成的domain.crt,在每台需要访问服务的docker主机上:

```sh
$ sudo cp domain.crt /etc/docker/certs.d/example.com:5000/ca.crt
```

重启docker服务

```sh
$ sudo service docker restart
```

如果你使用的自定义域名,你还需要在hosts文件中手动加入域名到IP的映射,比如我的registry服务的IP为192.168.59.137,自定义的域名为example.com。 我需要在/etc/hosts文件中加入一行192.168.59.137 example.com。

**step 4:** 验证

在docker客户机上:

```sh
# push 验证
$ docker pull busybox:1.25.1-musl
$ docker tag busybox:1.25.1-musl example.com:5000/busybox:1.25.1-musl
busybox:1.25.1-musl
$ docker push example.com:5000/busybox:1.25.1-musl 
The push refers to a repository [example:5000/busybox]
981f3d18e054: Pushed 
1.25.1-musl: digest: sha256:46634e32e559271b8e18b7f1b21d981da4cd63ed8d36fbdc35c0b56464238a0c size: 527

# API 验证:
$ curl -k https://example:5000/v2/_catalog
{"repositories":["busybox"]}
~$ curl -k https://192.168.59.137:5000/v2/busybox/tags/list
{"name":"busybox","tags":["1.25.1-musl"]}
```

看到类似的输出就说明成功了。我每次都选择busybox的镜像做实验,因为busybox是我系统上最小的镜像,你可以选择更小的官方提供的helloworld镜像做实验。

> * **使用自签名证书-针对IP地址做签证**

如果没有购买域名,又觉得自定义域名太麻烦(需要修改每台客户机的hosts文件),喜欢直接用 IP 地址来访问。我们可以针对IP做签证。只是生成证书的地方多一个操作。假设registry服务的IP为`192.168.59.137`。

**step 0:** 修改openssl的配置文件

编辑`/etc/ssl/openssl.cnf`,搜索`v3_ca`,在`[ v3_ca ]`下面加入下面这行:

```sh
subjectAltName = IP:192.168.59.137
```

注意将`192.168.59.137`替换为你registry服务的IP。这一步很关键,网上很多遇到的报错:`registry endpoint...x509: cannot validate certificate for ... because it doesn't contain any IP SANs`都是这一步没做好。

**step 1:** 生成自签名证书

```sh
$ mkdir certs
$ openssl req -newkey rsa:4096 -nodes -sha256 -keyout certs/domain.key  -x509 -days 365 -out certs/domain.crt
```

命令会进入交互式模式,你需要输入国家、省、市、组织名、域名:

```sh
Country Name (2 letter code) [AU]:CN
State or Province Name (full name) [Some-State]:Shangxi
Locality Name (eg, city) []:Xian 
Organization Name (eg, company) [Internet Widgits Pty Ltd]:sse lab
Organizational Unit Name (eg, section) []:sse lab
Common Name (e.g. server FQDN or YOUR name) []:192.168.59.137
Email Address []:*****@**.com
```

执行完毕后会在certs目录下生成私钥文件domain.key、证书文件domain.crt。

**step 2:** 验证证书

```sh
$ openssl x509 -text -in certs/domain.crt -noout | grep IP
                IP Address:192.168.59.137
```

或者直接运行`openssl x509 -text -in certs/domain.crt -noout`,在输出信息中`X509V3 extensions`后面看到:

```sh
X509v3 Subject Alternative Name: 
                IP Address:192.168.59.137
```

**step 3:** 启动支持HTTPS访问的registry服务

确保掉前面启动的registry服务已经停止和删除。

```sh
$ docker run -d -p 5000:5000 --restart=always --name registry -v pwd/certs:/certs \
    -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt \
    -e REGISTRY_HTTP_TLS_KEY=/certs/domain.key registry:2.5.1
```

该命令启动了一个registry容器,并通过数据卷将证书和私钥传进了容器,并通过环境变量指定了其路径。

**step 4:** 将证书文件复制到每台需要访问registry服务的客户机

由于是自签名证书,我们需要将生成的证书文件给客户机,客户机才能信任registry服务。准备好前面生成的domain.crt,在每台需要访问服务的docker主机上:

```sh
$ sudo cp domain.crt /etc/docker/certs.d/example.com:5000/ca.crt
```

重启docker服务

```sh
$ sudo service docker restart
```

如果你使用的自定义域名,你还需要在hosts文件中手动加入域名到IP的映射,比如我的registry服务的IP为`192.168.59.137`,自定义的域名为`example.com`。 我需要在`/etc/hosts`文件中加入一行`192.168.59.137 example.com`。

**step 4:** 验证

在docker客户机上:

```sh
push 验证
$ docker pull busybox:1.25.1-musl
$ docker tag busybox:1.25.1-musl example.com:5000/busybox:1.25.1-musl
busybox:1.25.1-musl
$ docker push example.com:5000/busybox:1.25.1-musl 
The push refers to a repository [example:5000/busybox]
981f3d18e054: Pushed 
1.25.1-musl: digest: sha256:46634e32e559271b8e18b7f1b21d981da4cd63ed8d36fbdc35c0b56464238a0c size: 527

API 验证:
$ curl -k https://example:5000/v2/_catalog
{"repositories":["busybox"]}
~$ curl -k https://192.168.59.137:5000/v2/busybox/tags/list
{"name":"busybox","tags":["1.25.1-musl"]}
```

看到类似的输出就说明成功了。我每次都选择busybox的镜像做实验,因为busybox是我系统上最小的镜像,你可以选择更小的官方提供的helloworld镜像做实验。

## 四、Dockerfile文件

首先通过一张图来了解Docker镜像、容器和Dockerfile三者之间的关系。

<img src="http://www.mooooc.com/assets/images/2018/docker/DockerFile.png" style="width: 50%">

通过上图可以看出使用Dockerfile定义镜像,运行镜像启动容器。

### 4.1 Dockerfile概念

Docker镜像是一个特殊的文件系统,除了提供容器运行时所需的程序、库、资源、配置等文件外,还包含了一些为运行时准备的一些配置参数(如匿名卷、环境变量、用户等)。镜像不包含任何动态数据,其内容在构建之后也不会被改变。

镜像的定制实际上就是定制每一层所添加的配置、文件。如果我们可以把每一层修改、安装、构建、操作的命令都写入一个脚本,用这个脚本来构建、定制镜像,那么之前提及的无法重复的问题、镜像构建透明性的问题、体积的问题就都会解决。这个脚本就是Dockerfile。

Dockerfile是一个文本文件,其内包含了一条条的指令(Instruction),每一条指令构建一层,因此每一条指令的内容,就是描述该层应当如何构建。有了Dockerfile,当我们需要定制自己额外的需求时,只需在Dockerfile上添加或者修改指令,重新生成image即可,省去了敲命令的麻烦。

### 4.2 Dockerfile文件格式

Dockerfile文件格式如下:

```sh
## Dockerfile文件格式
    
# This dockerfile uses the ubuntu image
# VERSION 2 - EDITION 1
# Author: docker_user
# Command format: Instruction [arguments / command] ..

# 1、第一行必须指定基础镜像信息
FROM ubuntu

# 2、维护者信息
MAINTAINER docker_user docker_user@email.com

# 3、镜像操作指令
RUN echo "deb http://archive.ubuntu.com/ubuntu/ raring main universe" >> /etc/apt/sources.list
RUN apt-get update && apt-get install -y nginx
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf

# 4、容器启动执行指令
CMD /usr/sbin/nginx
```

Dockerfile分为四部分:基础镜像信息、维护者信息、镜像操作指令、容器启动执行指令。一开始必须要指明所基于的镜像名称,接下来一般会说明维护者信息;后面则是镜像操作指令,例如RUN指令。每执行一条RUN指令,镜像添加新的一层,并提交;最后是 CMD 指令,来指明运行容器时的操作命令。

### 4.3 构建镜像

docker build命令会根据Dockerfile文件及上下文构建新Docker镜像。构建上下文是指Dockerfile所在的本地路径或一个URL(Git仓库地址)。构建上下文环境会被递归处理,所以构建所指定的路径还包括了子目录,而URL还包括了其中指定的子模块。

将当前目录做为构建上下文时,可以像下面这样使用docker build命令构建镜像:

```sh
docker build .
Sending build context toDockerdaemon  6.51 MB
...
```

说明:构建会在Docker后台守护进程(daemon)中执行,而不是CLI中。构建前,构建进程会将全部内容(递归)发送到守护进程。大多情况下,应该将一个空目录作为构建上下文环境,并将Dockerfile文件放在该目录下。在构建上下文中使用的Dockerfile文件,是一个构建指令文件。为了提高构建性能,可以通过.dockerignore文件排除上下文目录下不需要的文件和目录。

在Docker构建镜像的第一步,docker CLI会先在上下文目录中寻找.dockerignore文件,根据.dockerignore文件排除上下文目录中的部分文件和目录,然后把剩下的文件和目录传递给Docker服务。Dockerfile一般位于构建上下文的根目录下,也可以通过-f指定该文件的位置:

```sh
docker build -f /path/to/a/Dockerfile.
```

构建时,还可以通过-t参数指定构建成镜像的仓库、标签。

### 4.4 镜像标签

```sh
docker build -t nginx/v3 .
```

如果存在多个仓库下,或使用多个镜像标签,就可以使用多个-t参数:

```sh
docker build -t nginx/v3:1.0.2 -t nginx/v3:latest .
```

在Docker守护进程执行Dockerfile中的指令前,首先会对Dockerfile进行语法检查,有语法错误时会返回:

```sh
docker build -t nginx/v3 .
Sending build context toDockerdaemon 2.048 kB
Error response from daemon: Unknown instruction: RUNCMD
```

### 4.5 缓存

Docker守护进程会一条一条的执行Dockerfile中的指令,而且会在每一步提交并生成一个新镜像,最后会输出最终镜像的ID。生成完成后,Docker守护进程会自动清理你发送的上下文。Dockerfile文件中的每条指令会被独立执行,并会创建一个新镜像,RUN cd /tmp等命令不会对下条指令产生影响。Docker会重用已生成的中间镜像,以加速docker build的构建速度。以下是一个使用了缓存镜像的执行过程:

```sh
$ docker build -t svendowideit/ambassador .
Sending build context toDockerdaemon 15.36 kB
Step 1/4 : FROM alpine:3.2
 ---> 31f630c65071
Step 2/4 : MAINTAINER SvenDowideit@home.org.au
 ---> Using cache
 ---> 2a1c91448f5f
Step 3/4 : RUN apk update &&      apk add socat &&        rm -r /var/cache/
 ---> Using cache
 ---> 21ed6e7fbb73
Step 4/4 : CMD env | grep _TCP= | (sed 's/.*_PORT_\([0-9]*\)_TCP=tcp:\/\/\(.*\):\(.*\)/socat -t 100000000 TCP4-LISTEN:\1,fork,reuseaddr TCP4:\2:\3 \&/' && echo wait) | sh
 ---> Using cache
 ---> 7ea8aef582cc
Successfully built 7ea8aef582cc
```

构建缓存仅会使用本地父生成链上的镜像,如果不想使用本地缓存的镜像,也可以通过--cache-from指定缓存。指定后将不再使用本地生成的镜像链,而是从镜像仓库中下载。

### 4.6 寻找缓存的逻辑

Docker寻找缓存的逻辑其实就是树型结构根据Dockerfile指令遍历子节点的过程。下图可以说明这个逻辑。

```sh
 FROM base_image:version          Dockerfile:
       +----------+                FROM base_image:version
       |base image|                RUN cmd1  --> use cache because we found base image
       +-----X----+                RUN cmd11 --> use cache because we found cmd1
            / \
           /   \
   RUN cmd1     RUN cmd2          Dockerfile:
   +------+     +------+           FROM base_image:version
   |image1|     |image2|           RUN cmd2  --> use cache because we found base image
   +---X--+     +------+           RUN cmd21 --> not use cache because there's no child node
      / \                                        running cmd21, so we build a new image here
     /   \
RUN cmd11     RUN cmd12
+-------+     +-------+
|image11|     |image12|
+-------+     +-------+
```

大部分指令可以根据上述逻辑去寻找缓存,除了ADD和COPY。这两个指令会复制文件内容到镜像内,除了指令相同以外,Docker还会检查每个文件内容校验(不包括最后修改时间和最后访问时间),如果校验不一致,则不会使用缓存。除了这两个命令,Docker并不会去检查容器内的文件内容,比如RUN apt-get -y update,每次执行时文件可能都不一样,但是Docker认为命令一致,会继续使用缓存。这样一来,以后构建时都不会再重新运行apt-get -y update。

如果Docker没有找到当前指令的缓存,则会构建一个新的镜像,并且之后的所有指令都不会再去寻找缓存。

### 4.7 简单示例

接下来用一个简单的示例来感受一下Dockerfile是如何用来构建镜像启动容器。我们以定制nginx镜像为例,在一个空白目录中,建立一个文本文件,并命名为Dockerfile:

```sh
mkdir mynginx
cd mynginx
viDockerfile
```

构建一个Dockerfile文件内容为:

```sh
FROM nginx
RUN echo '<h1>Hello, Docker!</h1>' > /usr/share/nginx/html/index.html
```

这个Dockerfile很简单,一共就两行涉及到了两条指令:FROM和RUN,FROM表示获取指定基础镜像,RUN执行命令,在执行的过程中重写了nginx 的默认页面信息,将信息替换为:Hello, Docker!。

在Dockerfile文件所在目录执行:

```sh
docker build -t nginx:v1 .
```

命令最后有一个.表示当前目录

构建完成之后,使用docker images命令查看所有镜像,如果存在REPOSITORY为nginx和TAG是v1的信息,就表示构建成功。

```sh
docker images
REPOSITORY                      TAG                 IMAGE ID            CREATED             SIZE
nginx                           v1                  8c92471de2cc        6 minutes ago       108.6 MB
```

接下来使用docker run命令来启动容器

```sh
docker run  --name docker_nginx_v1   -d -p 80:80 nginx:v1
```

这条命令会用nginx镜像启动一个容器,命名为docker\_nginx\_v1,并且映射了80端口,这样我们可以用浏览器去访问这个nginx服务器:curl 0.0.0.0.这样一个简单使用Dockerfile构建镜像,运行容器的示例就完成了!

容器启动后,需要对容器内的文件进行进一步的完善,可以使用docker exec -it xx bas命令再次进行修改,以上面的示例为基础,修改nginx启动页面内容:

```sh
docker exec -it docker_nginx_v1   bash
root@3729b97e8226:/# echo '<h1>Hello,Dockerneo!</h1>' > /usr/share/nginx/html/index.html
root@3729b97e8226:/# exit
exit
```

以交互式终端方式进`docker_nginx_v1`容器,并执行了bash命令,也就是获得一个可操作的Shell。然后,我们用`<h1>Hello,Docker neo!`覆盖了`/usr/share/nginx/html/index.html`的内容。 再次刷新内容,会发现内容被改变。修改了容器的文件,也就是改动了容器的存储层,可以通过`docker diff`命令看到具体的改动。

```sh
docker diff docker_nginx_v1
```

## 五、Dockerfile指令

### 5.1 FROM:指定基础镜像

FROM指令用于指定其后构建新镜像所使用的基础镜像。FROM指令必是Dockerfile文件中的首条命令,启动构建流程后,Docker将会基于该镜像构建新镜像,FROM后的命令也会基于这个基础镜像。

FROM语法格式为:`FROM <image>`或`FROM <image>:<tag>`或`FROM <image>:<digest>`

通过FROM指定的镜像,可以是任何有效的基础镜像。FROM有以下限制:

> * FROM必须是Dockerfile中第一条非注释命令
> * 在一个Dockerfile文件中创建多个镜像时,FROM可以多次出现。只需在每个新命令FROM之前,记录提交上次的镜像ID。
> * tag或digest是可选的,如果不使用这两个值时,会使用latest版本的基础镜像

### 5.2 RUN执行命令

在镜像的构建过程中执行特定的命令,并生成一个中间镜像。格式:

```sh
# shell格式
RUN <command>
# exec格式
RUN ["executable", "param1", "param2"]
```

> * RUN命令将在当前image中执行任意合法命令并提交执行结果。命令执行提交后,就会自动执行Dockerfile中的下一个指令。
> * 层级RUN指令和生成提交是符合Docker核心理念的做法。它允许像版本控制那样,在任意一个点,对image镜像进行定制化构建。
> * RUN指令创建的中间镜像会被缓存,并会在下次构建中使用。如果不想使用这些缓存镜像,可以在构建时指定--no-cache参数,如:docker build --no-cache。

### 5.3 COPY复制文件

格式:

```sh
COPY <源路径>... <目标路径>
COPY ["<源路径1>",... "<目标路径>"]
```

和RUN指令一样,也有两种格式,一种类似于命令行,一种类似于函数调用。COPY指令将从构建上下文目录中<源路径>的文件/目录复制到新的一层的镜像内的<目标路径>位置。比如:COPY package.json /usr/src/app/。<源路径>可以是多个,甚至可以是通配符,其通配符规则要满足Go的filepath.Match规则,如:

```sh
COPY hom* /mydir/
COPY hom?.txt /mydir/
```

<目标路径\>可以是容器内的绝对路径,也可以是相对于工作目录的相对路径(工作目录可以用WORKDIR指令来指定)。目标路径不需要事先创建,如果目录不存在会在复制文件前先行创建缺失目录。

此外,还需要注意一点,使用COPY指令,源文件的各种元数据都会保留。比如读、写、执行权限、文件变更时间等。这个特性对于镜像定制很有用。特别是构建相关文件都在使用Git进行管理的时候。

### 5.4 ADD更高级的复制文件

ADD指令和COPY的格式和性质基本一致。但是在COPY基础上增加了一些功能。比如\<源路径\>可以是一个URL,这种情况下,Docker引擎会试图去下载这个链接的文件放到<目标路径>去。

在构建镜像时,复制上下文中的文件到镜像内,格式:

```sh
ADD <源路径>... <目标路径>
ADD ["<源路径>",... "<目标路径>"]
```

**注意**:如果docker发现文件内容被改变,则接下来的指令都不会再使用缓存。关于复制文件时需要处理的/,基本跟正常的copy一致

### 5.5 ENV设置环境变量

格式有两种:

```sh
ENV <key> <value>
ENV <key1>=<value1> <key2>=<value2>...
```

这个指令很简单,就是设置环境变量而已,无论是后面的其它指令,如RUN,还是运行时的应用,都可以直接使用这里定义的环境变量。

```sh
ENV VERSION=1.0 DEBUG=on \
    NAME="Happy Feet"
```

这个例子中演示了如何换行,以及对含有空格的值用双引号括起来的办法,这和Shell下的行为是一致的。

### 5.6 EXPOSE

为构建的镜像设置监听端口,使容器在运行时监听。格式:`EXPOSE <port> [<port>...]`。

EXPOSE指令并不会让容器监听host的端口,如果需要,需要在`docker run`时使用`-p、-P`参数来发布容器端口到host的某个端口上。

### 5.7 VOLUME定义匿名卷

VOLUME用于创建挂载点,即向基于所构建镜像创始的容器添加卷:VOLUME ["/data"]。

一个卷可以存在于一个或多个容器的指定目录,该目录可以绕过联合文件系统,并具有以下功能:

> * 卷可以容器间共享和重用
> * 容器并不一定要和其它容器共享卷
> * 修改卷后会立即生效
> * 对卷的修改不会对镜像产生影响
> * 卷会一直存在,直到没有任何容器在使用它

VOLUME让我们可以将源代码、数据或其它内容添加到镜像中,而又不并提交到镜像中,并使我们可以多个容器间共享这些内容。

### 5.8 WORKDIR指定工作目录

WORKDIR用于在容器内设置一个工作目录:WORKDIR /path/to/workdir。

通过WORKDIR设置工作目录后,Dockerfile中其后的命令RUN、CMD、ENTRYPOINT、ADD、COPY等命令都会在该目录下执行。 如使用WORKDIR设置工作目录:

```sh
WORKDIR /a
WORKDIR b
WORKDIR c
RUN pwd
```

在以上示例中,pwd最终将会在/a/b/c目录中执行。在使用docker run运行容器时,可以通过-w参数覆盖构建时所设置的工作目录。

### 5.9 USER指定当前用户

USER用于指定运行镜像所使用的用户:USER daemon。

使用USER指定用户时,可以使用用户名、UID或GID,或是两者的组合。以下都是合法的指定试:

```sh
USER user
USER user:group
USER uid
USER uid:gid
USER user:gid
USER uid:group
```

使用USER指定用户后,Dockerfile中其后的命令RUN、CMD、ENTRYPOINT都将使用该用户。镜像构建完成后,通过`docker run`运行容器时,可以通过-u参数来覆盖所指定的用户。

### 5.10 CMD

CMD用于指定在容器启动时所要执行的命令。CMD有以下三种格式:

```sh
CMD ["executable","param1","param2"]
CMD ["param1","param2"]
CMD command param1 param2
```

省略可执行文件的exec格式,这种写法使CMD中的参数当做ENTRYPOINT的默认参数,此时ENTRYPOINT也应该是exec格式,具体与ENTRYPOINT的组合使用,参考ENTRYPOINT。

**注意**与RUN指令的区别:RUN在构建的时候执行,并生成一个新的镜像,CMD在容器运行的时候执行,在构建时不进行任何操作。

### 5.11 ENTRYPOINT

ENTRYPOINT用于给容器配置一个可执行程序。也就是说,每次使用镜像创建容器时,通过ENTRYPOINT指定的程序都会被设置为默认程序。ENTRYPOINT有以下两种形式:

```sh
ENTRYPOINT ["executable", "param1", "param2"]
ENTRYPOINT command param1 param2
```

ENTRYPOINT与CMD非常类似,不同的是通过docker run执行的命令不会覆盖ENTRYPOINT,而docker run命令中指定的任何参数,都会被当做参数再次传递给ENTRYPOINT。Dockerfile中只允许有一个ENTRYPOINT命令,多指定时会覆盖前面的设置,而只执行最后的ENTRYPOINT 指令。

docker run运行容器时指定的参数都会被传递给ENTRYPOINT,且会覆盖CMD命令指定的参数。如执行`docker run <image> -d`时,-d参数将被传递给入口点。也可以通过docker run --entrypoint重写ENTRYPOINT入口点。如可以这样指定一个容器执行程序:`ENTRYPOINT ["/usr/bin/nginx"]`

完整构建代码:

```sh
# Version: 0.0.3
FROM ubuntu:16.04
MAINTAINER 何民三 "cn.liuht@gmail.com"
RUN apt-get update
RUN apt-get install -y nginx
RUN echo 'Hello World, 我是个容器' \ 
    > /var/www/html/index.html
ENTRYPOINT ["/usr/sbin/nginx"]
EXPOSE 80
```

使用docker build构建镜像,并将镜像指定为`itbilu/test:docker build -t="itbilu/test" .`。构建完成后,使用itbilu/test启动一个容器:`docker run -i -t  itbilu/test -g "daemon off;"`。

在运行容器时,我们使用了`-g "daemon off;"`,这个参数将会被传递给ENTRYPOINT,最终在容器中执行的命令为`/usr/sbin/nginx -g "daemon off;"`。

### 5.12 LABEL

LABEL用于为镜像添加元数据,元数以键值对的形式指定:`LABEL <key>=<value> <key>=<value> <key>=<value> ...`

使用LABEL指定元数据时,一条LABEL指定可以指定一或多条元数据,指定多条元数据时不同元数据之间通过空格分隔。推荐将所有的元数据通过一条LABEL指令指定,以免生成过多的中间镜像。 如通过LABEL指定一些元数据:`LABEL version="1.0" description="这是一个Web服务器" by="IT笔录"`。

指定后可以通过docker inspect查看:

```sh
docker inspect itbilu/test
"Labels": {
    "version": "1.0",
    "description": "这是一个Web服务器",
    "by": "IT笔录"
},
```

### 5.13 ARG

ARG用于指定传递给构建运行时的变量:`ARG <name>[=<default value>]`。如通过ARG指定两个变量:

```sh
ARG site
ARG build_user=IT笔录
```

以上我们指定了site和build_user两个变量,其中build_user指定了默认值。在使用docker build构建镜像时,可以通过`--build-arg <varname>=<value>`参数来指定或重设置这些变量的值。

```sh
docker build --build-arg site=itiblu.com -t itbilu/test .
```

这样我们构建了`itbilu/test`镜像,其中site会被设置为`itbilu.com`,由于没有指定build_user,其值将是默认值IT笔录。

### 5.14 ONBUILD

ONBUILD用于设置镜像触发器:`ONBUILD [INSTRUCTION]`。

当所构建的镜像被用做其它镜像的基础镜像,该镜像中的触发器将会被钥触发。 如当镜像被使用时,可能需要做一些处理:

```sh
[...]
ONBUILD ADD . /app/src
ONBUILD RUN /usr/local/bin/python-build --dir /app/src
[...]
```

### 5.15 STOPSIGNAL

STOPSIGNAL用于设置停止容器所要发送的系统调用信号:`STOPSIGNAL signal`。所使用的信号必须是内核系统调用表中的合法的值,如:SIGKILL。

### 5.16 SHELL

SHELL用于设置执行命令(shell式)所使用的的默认 shell 类型:`SHELL ["executable", "parameters"]`。SHELL在Windows环境下比较有用,Windows下通常会有cmd和powershell两种shell,可能还会有sh。这时就可以通过SHELL来指定所使用的shell类型:

```sh
FROM microsoft/windowsservercore

# Executed as cmd /S /C echo default
RUN echo default

# Executed as cmd /S /C powershell -command Write-Host default
RUN powershell -command Write-Host default

# Executed as powershell -command Write-Host hello
SHELL ["powershell", "-command"]
RUN Write-Host hello

# Executed as cmd /S /C echo hello
SHELL ["cmd", "/S"", "/C"]
RUN echo hello
```

### 5.16 Dockerfile示例

```sh
FROM scratch

ADD alpine-minirootfs-3.10.3-x86_64.tar.gz /

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN addgroup -S -g 1000 redis && adduser -S -G redis -u 999 redis
# alpine already has a gid 999, so we'll use the next id

RUN apk add --no-cache \
# grab su-exec for easy step-down from root
    'su-exec>=0.2' \
# add tzdata for https://github.com/docker-library/redis/issues/138
    tzdata

ENV REDIS_VERSION 5.0.7
ENV REDIS_DOWNLOAD_URL http://download.redis.io/releases/redis-5.0.7.tar.gz
ENV REDIS_DOWNLOAD_SHA 61db74eabf6801f057fd24b590232f2f337d422280fd19486eca03be87d3a82b

RUN set -eux; \
  \
  apk add --no-cache --virtual .build-deps \
    coreutils \
    gcc \
    linux-headers \
    make \
    musl-dev \
  ; \
  \
  wget -O redis.tar.gz "$REDIS_DOWNLOAD_URL"; \
  echo "$REDIS_DOWNLOAD_SHA *redis.tar.gz" | sha256sum -c -; \
  mkdir -p /usr/src/redis; \
  tar -xzf redis.tar.gz -C /usr/src/redis --strip-components=1; \
  rm redis.tar.gz; \
  \
# disable Redis protected mode [1] as it is unnecessary in context of Docker
# (ports are not automatically exposed when running inside Docker, but rather explicitly by specifying -p / -P)
# [1]: https://github.com/antirez/redis/commit/edd4d555df57dc84265fdfb4ef59a4678832f6da
  grep -q '^#define CONFIG_DEFAULT_PROTECTED_MODE 1$' /usr/src/redis/src/server.h; \
  sed -ri 's!^(#define CONFIG_DEFAULT_PROTECTED_MODE) 1$!\1 0!' /usr/src/redis/src/server.h; \
  grep -q '^#define CONFIG_DEFAULT_PROTECTED_MODE 0$' /usr/src/redis/src/server.h; \
# for future reference, we modify this directly in the source instead of just supplying a default configuration flag because apparently "if you specify any argument to redis-server, [it assumes] you are going to specify everything"
# see also https://github.com/docker-library/redis/issues/4#issuecomment-50780840
# (more exactly, this makes sure the default behavior of "save on SIGTERM" stays functional by default)
  \
  make -C /usr/src/redis -j "$(nproc)"; \
  make -C /usr/src/redis install; \
  \
# TODO https://github.com/antirez/redis/pull/3494 (deduplicate "redis-server" copies)
  serverMd5="$(md5sum /usr/local/bin/redis-server | cut -d' ' -f1)"; export serverMd5; \
  find /usr/local/bin/redis* -maxdepth 0 \
    -type f -not -name redis-server \
    -exec sh -eux -c ' \
      md5="(md5sum"1" | cut -d" " -f1)"; \
      test "md5"="serverMd5"; \
    ' -- '{}' ';' \
    -exec ln -svfT 'redis-server' '{}' ';' \
  ; \
  \
  rm -r /usr/src/redis; \
  \
  runDeps="$( \
    scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
      | tr ',' '\n' \
      | sort -u \
      | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
  )"; \
  apk add --no-network --virtual .redis-rundeps $runDeps; \
  apk del --no-network .build-deps; \
  \
  redis-cli --version; \
  redis-server --version

RUN mkdir /data && chown redis:redis /data
VOLUME /data
WORKDIR /data

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 6379
CMD ["redis-server"]
```
