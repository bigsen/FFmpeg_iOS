![](http://upload-images.jianshu.io/upload_images/790890-616616e451d2bc98.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 概述
网上充斥着大量的 iOS FFmpeg 编译的教程，有的时间比较早了，有的很多都没有说详细，或者有个别坑作者没有讲到，有的讲到到了一半，没有例子。

所以本人参考了网上的编译FFmpeg教程到集成的很多文章，然后加上本人进行了实际操作，总结出了此篇文章，希望大家如果有用到FFmpeg，以后少走一些坑。

##### 此篇文章内容会包含：
从新建 iOS 工程  -------> 到调用FFmpeg 命令   -------> 直到运行项目成功的本人实操的所有步骤。

---

## 目录
1. FFmpeg 简介
2. FFmpeg 的编译
3. iOS 集成 FFmpeg
4. iOS 集成 FFmpeg Tool
5. 优化解决集成后问题
6. iOS 调用 FFmpeg Tool

####一、FFmpeg 简介
***                        
#####1，FFmpeg 是什么 ？
你可以把 FFmpeg 理解成一套音视频解决方案，使用 C语言 开发的开源程序，并且免费、开源、跨平台，它提供了录制、转换以及流化音视频，编码，特效，视音频操作等功能，包含了非常先进的音频/视频编解码库。

######（1）FFmpeg 能做什么 ？
可以实现播放歌曲、视频，甚至通过命令实现对 视频文件的转码、混合、剪辑，采集等各
种复杂处理。

######（2）哪些地方用到了FFmpeg?
使 FFmpeg内核视频播放 :  Mplayer，射手播放器 ，暴风影音 ，KMPlayer...
使 FFmpeg作为内核的Direct show Filter 解码 : ffdshow，lav filters...
使 FFmpeg作为内核的转码工具: ffmpeg，格式工厂...


#####2，FFmpeg 作者
![](http://upload-images.jianshu.io/upload_images/790890-44afe3933df66073.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

法布里斯·贝拉（FabriceBellard）是一位著名的计算机程序员，1972年生于法国Grenoble，大学就读于巴黎高等综合理工学院，后在[国立巴黎高等电信学院](http://baike.baidu.com/subview/4420360/4420360.htm)攻读。因FFmpeg、QEMU等项目而闻名业内。他也是最快圆周率算法贝拉公式、TCCBOOT和TCC（微型C编译器）等项目的作者。

#####《个人成就》：
1997年 - 他发现了最快速的计算圆周率的算法。
2000年 - 他化名Gérard Lantau，创建了 FFmpeg 项目。
2004年 - 他编写了一个只有138KB的启动加载程序TCCBOOT，可以在15秒内从源代码编译并启动Linux系统。
2009年 - 他声称打破了圆周率计算的世界纪录，算出小数点后2.7万亿位，仅用一台普通PC机。
2011年 - 他单用JavaScript写了一个PC虚拟机Jslinux，实现能在浏览器里跑Linux 。

#####3，FFmpeg 项目的组成 
###### （1）基本：
- ffmpeg  ：是一个命令行工具，用来对视频文件转换格式；
- ffsever ：是一个HTTP多媒体实时广播流服务器；
- ffplay  ：是一个简单的播放器，使用ffmpeg 库解析和解码，通过SDL显示；

###### （2）其它：
- libavutil ：包含一些公共的工具函数；
- libavcodec  ：用于各种类型声音/图像编解码；
- libswscale  ：用于视频场景比例缩放、色彩映射转换；
- libpostproc ：用于后期效果处理；
- libavformat ：用于音视频封装格式的生成和解析, 包括获取解码所需信息以生成解码上下文结构和读取音视频帧等功能。


#####4，FFmpeg 的使用方式 （FFmpeg 代码是包括两部分）
###### （1）一部分是library
* 直接调用静态库，c语言的文件。
* API 都是在library ，如果直接调 api 来操作视频的话，就需要写c或者c++了。

###### （2）一部分是 Tool  
* 使用的是命令行，则不需要自己去编码来实现视频操作的流程，实际上tool就是把命令行转换为api的操作，不需要使用者懂C++。

#### 本篇文章实践部分，主要是使用 Tool 命令方式。

---

####二、 FFmpeg 的编译
##### 1. 介绍
* FFmpeg是一个多平台多媒体处理工具，所以也可以在Mac下运行，先说一下Mac下如何安装FFmpeg。

##### 2. 相关地址
* FFmpeg 官网 : http://ffmpeg.org/download.html
* FFmpeg 源码 : https://github.com/FFmpeg/FFmpeg
* FFmpeg doc  : http://www.ffmpeg.org/documentation.html
* FFmpeg wiki : https://trac.ffmpeg.org/wiki
* Homebrew 安装网站 : http://brew.sh/index_zh-cn.html
* FFmpeg官方安装教程 : https://trac.ffmpeg.org/wiki/CompilationGuide/MacOSX

##### 3. 编译Mac下可用 FFmpeg
* 编译Mac下可用 FFmpeg，主要是可以在mac中，使用 FFmpeg 进行操作视频等。
##### Homebrew介绍
* 简称brew，是Mac OSX上的软件包管理工具，能在Mac中方便的安装软件或者卸载软件。

##### Homebrew安装
* 打开终端执行
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)”

##### Homebrew命令
* 搜索软件：brew search 软件名， 如brew search wget
* 安装软件：brew install 软件名，   如brew install wget
* 卸载软件：brew remove 软件名，如brew remove wget

##### 通过Homebrew 安装 FFmpeg
* 终端执行：执行  brew install ffmpeg --with-libvpx --with-libvorbis --with-ffplay

* 在终端中执行一下命令，等待安装完成即可：
```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```
* 安装好Homebrew，然后终端执行 "brew install ffmpeg"，等待完成即可。
* 执行结束，在终端中输入ffmpeg，验证是否安装成功。

* ![如果显示大概如上图，那么说明安装成功](http://upload-images.jianshu.io/upload_images/790890-ed0e694bed0c6558.png)


##### 4. 编译 iOS 下 FFmpeg
* 主要是用于iOS下进行使用FFmpeg
##### 在进行编译之前，我们首先需要做一些准备工作安装必备文件：
######（1）安装 gas-preprocessor
* 后面运行 FFmpeg-iOS-build-script 这个自动编译脚本需要 gas-preprocessor .

* 安装步骤（依次执行下面命令）： 
```
sudo git clone https://github.com/bigsen/gas-preprocessor.git  /usr/local/bin/gas
sudo cp /usr/local/bin/gas/gas-preprocessor.pl /usr/local/bin/gas-preprocessor.pl
sudo chmod 777 /usr/local/bin/gas-preprocessor.pl
sudo rm -rf /usr/local/bin/gas/
```

######（2）安装 yams 
* yasm是汇编编译器，因为ffmpeg中为了提高效率用到了汇编指令，所以编译时需要安装 

* 安装步骤（依次执行下面命令）： 
```
curl http://www.tortall.net/projects/yasm/releases/yasm-1.2.0.tar.gz -o yasm-1.2.0.gz
tar -zxvf yasm-1.2.0.gz
cd yasm-1.2.0
./configure && make -j 4 && sudo make install 
```

######（3）配置 FFmpeg 编译脚本
###### 1. 说明： 
* 编译FFmpeg可使用一个脚本：FFmpeg-iOS-build-script.sh。
* FFmpeg-iOS-build-script 是一个外国人写的自动编译的脚本，脚本则会自动从github中把ffmpeg源码下到本地并开始编译出iOS可用的库，支持各种架构。
```
手动编译FFmpeg网上有一些方法，但是稍显复杂而陈旧, 所以使用这个脚本比较方便。 
```

###### 2. 脚本下载地址：
```
git clone https://github.com/kewlbear/FFmpeg-iOS-build-script.git
```

###### 3. 配置FFmpeg版本：
* 下载完成后我们可指定编译的FFmpeg版本，修改 FF_VERSION 后面的参数就行了，本篇文章使用2.8版本。
* ![](https://upload-images.jianshu.io/upload_images/790890-a98e7124fc16fe3e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 配置裁剪（可选项）： 
FFmpeg库是一个非常庞大的库，包括编码，解码以及流媒体的支持等，如果不做裁剪全部编译进来的话，最后生成的静态库会很大。并且有很多不需要的东西，都可以禁止掉。

##### 1. 配置裁剪方法： 
修改配置 build-ffmpeg.sh 脚本里面 CONFIGURE_FLAGS 后面的内容即可
例如：
>![](http://upload-images.jianshu.io/upload_images/790890-ba5c8df31ecc75bd.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

配置的一些参数是为了更好的选择自己需要的功能，进行精简和优化ffmpeg。
我们可以手动看一下，在ffmpeg源码目录下，终端执行 ./configure --help列出全部参数 。下面简单列出部分参数：
######标准选项参数
```
--help ：          // 打印帮助信息 ./configure --help > ffmpegcfg.txt
--prefix=PREFIX ：// 安装程序到指定目录[默认：空]
--bindir=DIR ：  // 安装程序到指定目录[默认：/bin]
--datadir=DIR ：// 安装数据文件到指定目录[默认：/share/ffmpeg]
--incdir=DIR ：// 安装头文件到指定目录[默认：/include]
--mandir=DIR ：// 安装man page到指定路径[默认：/share/man]
```
##### 2. 配置选项参数
```
--disable-static ：// 不构建静态库[默认：关闭]
--enable-shared ：// 构建共享库
--enable-gpl ：  // 允许使用GPL代码。
--enable-nonfree ：// 允许使用非免费代码。
--disable-doc ：  // 不构造文档
--disable-avfilter  ：// 禁止视频过滤器支持
--enable-small  ：   // 启用优化文件尺寸大小（牺牲速度）
--cross-compile  ： // 使用交叉编译
--disable-hwaccels  ：// 禁用所有硬件加速(本机不存在硬件加速器，所有不需要)
--disable-network  ：//  禁用网络
```
```
--disable-ffmpeg  --disable-ffplay  --disable-ffprobe  --disable-ffserver
// 禁止ffmpeg、ffplay、ffprobe、ffserver 

--disable-avdevice --disable-avcodec --disable-avcore
// 禁止libavdevice、libavcodec、libavcore 
```

```
--list-decoders ： // 显示所有可用的解码器
--list-encoders ： // 显示所有可用的编码器
--list-hwaccels ： // 显示所有可用的硬件加速器            
--list-protocols ： // 显示所有可用的协议                                  
--list-indevs ：   // 显示所有可用的输入设备
--list-outdevs ： // 显示所有可用的输出设备
--list-filters ：// 显示所有可用的过滤器
--list-parsers ：// 显示所有的解析器
--list-bsfs ：  // 显示所有可用的数据过滤器   
```

```
--disable-encoder=NAME ： // 禁用XX编码器 | disables encoder NAME
--enable-encoder=NAME ： // 用XX编码器 | enables encoder NAME
--disable-decoders ：   // 禁用所有解码器 | disables all decoders

--disable-decoder=NAME ： // 禁用XX解码器 | disables decoder NAME
--enable-decoder=NAME ： // 启用XX解码器 | enables decoder NAME
--disable-encoders ：   // 禁用所有编码器 | disables all encoders

--disable-muxer=NAME ： // 禁用XX混音器 | disables muxer NAME
--enable-muxer=NAME ： // 启用XX混音器 | enables muxer NAME
--disable-muxers ：   // 禁用所有混音器 | disables all muxers

--disable-demuxer=NAME ： // 禁用XX解轨器 | disables demuxer NAME
--enable-demuxer=NAME ： // 启用XX解轨器 | enables demuxer NAME
--disable-demuxers ：   // 禁用所有解轨器 | disables all demuxers

--enable-parser=NAME ：  // 启用XX剖析器 | enables parser NAME
--disable-parser=NAME ： // 禁用XX剖析器 | disables parser NAME
--disable-parsers ：    // 禁用所有剖析器 | disa
```

#### 运行脚本生成 FFmpeg：
配置好选项参数后就可以运行脚本，等待生成FFmpeg库。
* ![](https://upload-images.jianshu.io/upload_images/790890-1be2201663d8a4fb.gif?imageMogr2/auto-orient/strip)


##### 运行完毕就会生成：
* ffmpeg-2.8、FFmpeg-iOS 、scratch、thin 等这些文件夹。
* lib：对应的 FFmpeg 静态库
![](https://upload-images.jianshu.io/upload_images/790890-ac2b145251fde76e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

* include：对应的 FFmpeg 头文件
![](https://upload-images.jianshu.io/upload_images/790890-ac5b53b42548c1f4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

####三、iOS 下 集成 FFmpeg
生成完FFmpeg库与代码后，我们就可以集成到iOS项目中进行使用
######1，新建一个空项目，在Link Binary With Libraries 里添加
* libz.tbd
* libbz2.tbd
* libiconv.tbd
* CoreMedia.framework
* VideoToolbox.framework
* AVFoundation.framework
* ![](https://upload-images.jianshu.io/upload_images/790890-b6e6308661971d6f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###### 2，导入库文件
（1）将目录下的 include 和  lib文件夹 拖拽进项目中。
（2）设置 Header Search Paths 路径，指向 项目中include目录 。
例如：
```
$(SRCROOT)/FFmpeg_iOS/FFmpeg/include
```
* ![](https://upload-images.jianshu.io/upload_images/790890-a54aad33bd46ce3a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

（3）然后导入 #import "avformat.h"   在代码中 写 av_register_all() 然后进行编译，如果没有报错，代表编译成功。
* ![](https://upload-images.jianshu.io/upload_images/790890-9b0401c424d30e50.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

####四、iOS 运行 FFmpeg Tool

（1）到这一步其实已经可以使用library库了，如果要对音视频进行操作，需要手动写C++代码去调用 API 使用FFmpeg。

（2）如果想要使用Tool工具来调用 FFmpg 的话，就是直接通过调用传参的方式执行ffmpeg 命令的话，就需要:
* 把剩下的 ffmpeg.h ffmpeg.c 等依赖的文件拖进项目中，并导入ffmpeg.h 文件。
* 然后进行调用 ffmpeg_main 函数传递参数，执行 ffmpeg 命令即可。

##### FFmpeg Tool 相关文件：
* ffmpeg.c
* ffmpeg.h
* ffmpeg_opt.c
* ffmpeg_filter.c
* cmdutils.c
* cmdutils.h
* cmdutils_common_opts.h

![](https://upload-images.jianshu.io/upload_images/790890-941d574d6475c5b6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

* config.h 文件 (在scratch目录下四个文件都有 )：

![](https://upload-images.jianshu.io/upload_images/790890-efb70b72b833b5d8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##### 示例 - 拖入对应文件到工程
 * ![](https://upload-images.jianshu.io/upload_images/790890-787c672da35dd47b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##### 注释掉无关代码：
* 如果把相关其他文件导入后，编译的时候会发现有一些头文件比如 <avutil/internal.h>找不到。
不用担心，在我了解到 应该是 在 iOS 的 arm下不支持，也就不需要了。
* 那么这时候只需要把报红的地方注释掉就行了，另外如果精简掉某些库，那么依赖的类文件也会找不到，也是直接注释掉相关报错没问题的。

##### 头文件
```
#include "compat/va_copy.h"
#include "libavresample/avresample.h"
#include "libpostproc/postprocess.h"
#include "libavutil/libm.h"
#include "libavutil/time_internal.h"
#include "libavutil/internal.h"
#include "libavutil/libm.h"
#include "libavformat/network.h"
#include "libavcodec/mathops.h"
#include "libavformat/os_support.h"
```

##### 宏定义调用
```
FF_DISABLE_DEPRECATION_WARNINGS
```

##### 函数调用
```
 nb0_frames = nb_frames = mid_pred(ost->last_nb0_frames[0],
                                          ost->last_nb0_frames[1],
                                          ost->last_nb0_frames[2]);

 ff_dlog(NULL, "force_key_frame: n:%f n_forced:%f prev_forced_n:%f t:%f prev_forced_t:%f -> res:%f\n",
                    ost->forced_keyframes_expr_const_values[FKF_N],
                    ost->forced_keyframes_expr_const_values[FKF_N_FORCED],
                    ost->forced_keyframes_expr_const_values[FKF_PREV_FORCED_N],
                    ost->forced_keyframes_expr_const_values[FKF_T],
                    ost->forced_keyframes_expr_const_values[FKF_PREV_FORCED_T],
                    res);

PRINT_LIB_INFO(avresample, AVRESAMPLE, flags, level);
PRINT_LIB_INFO(postproc, POSTPROC, flags, level);
```

##### 其它
```
{ "videotoolbox_pixfmt", HAS_ARG | OPT_STRING | OPT_EXPERT, { &videotoolbox_pixfmt}, "" },

{ "videotoolbox",   videotoolbox_init,   HWACCEL_VIDEOTOOLBOX,   AV_PIX_FMT_VIDEOTOOLBOX },
```

##### 解决导入后编译问题：
* GIF文件大小有限制，分开上传了
###### （1）解决编译问题1：
* ![](https://upload-images.jianshu.io/upload_images/790890-416c5b025967018c.gif?imageMogr2/auto-orient/strip)


###### （2）解决编译问题2：
* ![](https://upload-images.jianshu.io/upload_images/790890-4ec86c0ac061a235.gif?imageMogr2/auto-orient/strip)

如果提示以下错误，还需注释以下代码
* ![](https://upload-images.jianshu.io/upload_images/790890-3e0ab390584750af.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
```
{ "videotoolbox_pixfmt", HAS_ARG | OPT_STRING | OPT_EXPERT, { &videotoolbox_pixfmt}, "" },

{ "videotoolbox",   videotoolbox_init,   HWACCEL_VIDEOTOOLBOX,   AV_PIX_FMT_VIDEOTOOLBOX },
```

##### （3）解决main函数重复问题
FFmpeg也有个main函数，如果不改名就会冲突报错。
* 打开 **ffmpeg.c** 文件，找到main函数，修改为 ffmpeg_main。
* 并在 ffmpeg.h 中声明。
* ![](https://upload-images.jianshu.io/upload_images/790890-6dd8c1e53ef2aea5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 五、优化解决集成后问题
这个时候，我们应该已经能否编译成功了，但是还有一些小问题，需要修改下。

##### 1. 计数器置零问题 （ffmpeg.c的代码中会访问空属性导致程序崩溃）
* 解决方法：
* 在 **ffmpeg.c** 中 找到 **ffmpeg_cleanup** 方法，在 term_exit() 前，将各个计数器置零：
```    
    nb_filtergraphs=0;
    nb_output_files=0;
    nb_output_streams=0;
    nb_input_files=0;
    nb_input_streams=0;
```
* 如下图：
* ![](https://upload-images.jianshu.io/upload_images/790890-8302dc5f87d3e971.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##### 2. 命令执行结束崩溃问题
##### 说明
* FFmpeg 默认执行完会执行 exit_program 方法结束进程，而iOS下只能启动一个进程，如果默认不做处理，执行完一条命令后app就自动退出了，所以需要做一个处理。

##### 解决方案有两种：
##### （1）第一种方案（有缺点）：
* 网上流传的方法的方法都是找到 exit_program 函数，然后注释掉结束进程的代码，然后调用 pthread_exit 结束线程来代替结束进程，进行解决。
* ![](https://upload-images.jianshu.io/upload_images/790890-23bb175299357a53.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
* ![](https://upload-images.jianshu.io/upload_images/790890-c16302f2e3dfc032.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##### 这种方法的缺点：
* 执行完 ffmpeg 的 main 函数后会回调一个code，这个回调是用于判断命令指定过程中是否执行错误的回调。但是我们如果在退出的时候调用了pthread_exit 这样线程就结束了，然后也不会走执行是否成功的回调了。
* 并且这样的话，想要监听到命令结束，必须要注册一个通知，进行监听线程结束。

##### （2）第二种方案（修复缺点）：
* 在命令执行完不进行结束线程和进程，只进行 cleanup。

##### 具体做法：
* 在 ffmpeg.c 的 ffmpeg_main 函数中，把所有调用 exit_program 函数 ，改为调用 ffmpeg_cleanup 函数就可以了。
![](https://upload-images.jianshu.io/upload_images/790890-0d6c96a7ba8d38e1.gif?imageMogr2/auto-orient/strip)

##### 六、iOS 调用 FFmpeg Tool
目前为止，我们做完上面所有步骤后，我们已经可以调用 FFmpeg Tool 进行各种音视频操作了，例如 视频合成、视频转Gif、视频帧操作、视频特效、格式转换，视频调速，等各种操作了。

###### 1. FFmpeg 命令简单介绍
使用ffmpeg命令行的大致格式如下：
```
ffmpeg [options] [[infile options] -i infile]... {[outfile options] outfile}...
```

##### 2. FFmpeg 命令常见参数
-f 强制指定编码格式
-i 输出源
-t 指定输入输出时长
-r 指定帧率，即1S内的帧数
-threads 指定线程数
-c:v 指定视频的编码格式
-ss 指定持续时长
-b:v 指定比特率
-s 指定分辨率
-y 覆盖输出
-filter 指定过滤器
-vf 指定视频过滤器
-an 指定去除对音频的影响

##### 3. FFmpeg 命令示例 （更多使用可查看其它文档）
```
格式转换
ffmpeg -i mkv.mkv -acodec copy -vcodec copy newVideo.mp4
ffmpeg -i wav.wav -ar 44100 -y outputmusic.aac

视频转GIF
ffmpeg -i mkv.mkv -ss 00:00:10 -t 10 -pix_fmt rgb24 -f gif -s vga gif.gif

视频声音分离 与合成
ffmpeg -i mp4.mp4 -f mp3 -vn mp3.mp3
ffmpeg -i mp4.mp4 -an mp4No.mp4
ffmpeg -i mp3.mp3 -i mp4No.mp4 -map 0:0 -map 1:0 -c:v copy -c:a libfaac sound.mp4

旋转视频
ffmpeg -i mp4.mp4 -vf transpose=2 transpose.mp4

反转视频
水平翻转 ：ffmpeg -i mp4.mp4 -vf hflip reversed.mp4
垂直翻转 ：ffmpeg -i mp4.mp4 -vf vflip reversed.mp4

合并视频
ffmpeg -f concat -i filelist.txt -y -acodec copy -strict -2 toName

水印字幕合成
ffmpeg -i fromName -i fromOther -filter_complex [0:v][1:v]overlay=0:H-h:enable='between(t,0,1)'[tmp];[tmp][1:v]overlay=0:H-h:enable='between(t,3,4)' -t 7 -y -strict -2 toName
```

##### 4. iOS 中调用FFmpeg Tool 示例：
![](https://upload-images.jianshu.io/upload_images/790890-e2e056a51bc64fc5.gif?imageMogr2/auto-orient/strip)

##### （1）第一种调用方式
简单容易理解，但是麻烦。
```
#import "ViewController.h"
#import "ffmpeg.h"
@interface ViewController ()
@end
@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *fromFile = [[NSBundle mainBundle]pathForResource:@"video.mov" ofType:nil];
    NSString *toFile = @"/Users/sen/Desktop/Output/video.gif";
    
    int argc = 4;
    char **arguments = calloc(argc, sizeof(char*));
    if(arguments != NULL)
    {
        arguments[0] = "ffmpeg";
        arguments[1] = "-i";
        arguments[2] = (char *)[fromFile UTF8String];
        arguments[3] = (char *)[toFile UTF8String];
        
        if (!ffmpeg_main(argc, arguments)) {
            NSLog(@"生成成功");
        }
    }
}
@end
```

##### （2）第二种调用方式
比第一种方案，遍历 FFmpeg 字符串命令，然后调用ffmpeg_main 传递参数。
```
/**
 第二种调用方式
 */
- (void)normalRun2{
    
    NSString *fromFile = [[NSBundle mainBundle]pathForResource:@"video.mov" ofType:nil];
    NSString *toFile   = @"/Users/sen/Desktop/Output/video.gif";
    
    NSString *command_str = [NSString stringWithFormat:@"ffmpeg -i %@ %@",fromFile,toFile];
    
    // 分割字符串
    NSMutableArray  *argv_array  = [command_str componentsSeparatedByString:(@" ")].mutableCopy;
    
    // 获取参数个数
    int argc = (int)argv_array.count;
    
    // 遍历拼接参数
    char **argv = calloc(argc, sizeof(char*));
    
    for(int i=0; i<argc; i++)
    {
        NSString *codeStr = argv_array[i];
        argv_array[i]     = codeStr;
        argv[i]      = (char *)[codeStr UTF8String];
    }
    
    ffmpeg_main(argc, argv);
}
```

### 结尾
* 到目前我们已经可以在iOS平台调用FFmpeg了，更多FFmpeg命令可查看其它相关文章。
* 后续的话，我会放出一款工具，可以更方便的调用FFmpeg进行处理命令。
