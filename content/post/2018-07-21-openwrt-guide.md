---
date: 2018-07-21
lastmod: 2018-07-21
title: "openwrt/LEDE 教程"
slug: "openwrt-guide"
autoCollapseToc: true
tags: [
    "openwrt",
    "LEDE",
    "软路由",
    "3215U"
]
categories: [
    "IT",
    "硬件",
]
---



朋友最近入手了一台 J1900 CPU 的低功耗电脑主机作为路由器，我也跟着中毒了，决定买一台当玩具尝试一把软路由。我后来选择的是 3215U 这款CPU，性能与 J1900 差不多，只是支持虚拟化，理论上可以通过安装 [ESXI](https://www.vmware.com/products/esxi-and-esx.html) 来支持多个系统的运行。

陆陆续续折腾了几天，是时候总结一下各种坑和经验了。

## 安装系统

软路由常用的系统是[openwrt](https://openwrt.org/)。曾经有一个团队从 openwrt 分离出来成立了 LEDE 项目，但后来 LEDE 项目又合并回 openwrt 了。所以LEDE和 openwrt 都是指相同的系统了。

最简单的安装方式就是使用 winPE 的U盘启动3215U主机，然后通过 physdiskwrite 把 openwrt 的镜像文件刷到3215U主机的硬盘。

WinPE 推荐[微PE工具箱](http://www.wepe.com.cn/)的版本。phpsdiskwrite 从[官网](https://m0n0.ch/wall/physdiskwrite.php)下载。openwrt 有官方原版与koolshare加工后的国内版本，为了省事就从[koolshare](http://firmware.koolshare.cn/LEDE_X64_fw867/) 下载国内版本。国内版本又分为`combined`和 `uefi-gpt` 两种，前者支持MBR的分区表和BIOS系统，后者支持GPT 分区表和EFI系统。我用了 `uefi-gpt` 。openwrt 解压之后，得到一个`openwrt*uefi-gpt-squashfs.img`文件。

WinPE 启动电脑之后， `phpsdiskwrite -u openwrt*uefi-gpt-squashfs.img` 就刷完了。

## 初步设置与拨号上网

3215U主机配了4个千兆网卡，机箱写着 Lan1、Lan2、Lan3和Lan4。

用电脑通过网线接到3215U主机的Lan1，浏览器访问 192.168.1.1，正常情况下，输入用户名和密码就能登陆了。原始用户名`root`密码`koolshare`。

登陆之后的系统首页显示了3215U主机的概况，目前没啥看头，也当不了路由器，默认情况下，网络接口显示了 Lan，Wan 和 Wan 6。其中，Lan 为路由器下方接口用于连接局域网的设备，Wan 为路由器的上方接口用于连接外部，Wan 6 为 ipv6 的Wan。

到菜单`系统`=>`进阶设置`=>`模式切换`里面，切换到`正常模式`，就能快速地使3215U主机设置为一台路由器。此时，Wan6 消失了，就剩 Lan 和 Wan 了。

Wan 中，选择 pppoe ，填入拨号的用户名和密码，正常情况下，就能联网了。3215U主机的4个网口，默认Lan1 是Wan，Lan2至Lan4才是Lan，所以，这时候要把电脑连接到3215U主机的 Lan2~Lan4的其中一个接口才能连接到3215U主机了。

## 把剩余的硬盘用起来

通过 xshell ，ssh 到3215U主机 。`df -h`可列出当前使用的分区情况，可以看到，openwrt 默认使用的硬盘空间很小，不到2G。我买的是16G的SSD，剩下的14G处于未分区的状态。`fdisk -l`同样能列出磁盘的分区信息。

我的硬盘被命名为`/dev/sda`。

运行'fdisk /dev/sda' 就能对 `/dev/sda`硬盘进行处理了，主要是把这14G未分配的空间分成一个区。fdisk 的操作比较简单，不清楚时就输入 `m` 来获取帮助即可。印象中，`n`就是新建分区。

我这边新分出的分区是`/dev/sda5`。`  mkfs.ext4 /dev/sda5`将其格式化为ext4格式，然后运行如下命令编辑 fstab 文件：

```bash
nano /etc/config/fstab
```

在文末新增这一段：

```bash
config 'mount'
        option  target  '/mnt/data1'
        option  device '/dev/sda5'
        option  enabled '1'
```

也可以使用 `blkid`把`/dev/sda5`的UUID找出来，然后以UUID代替`/dev/sda5`，即：

```bash
config 'mount'
        option  target  '/mnt/data1'
        option  uuid    'cc1ce16c-8b6f-42aa-b602-e10776c20686'
        option  enabled '1'
```

运行 `mount -a` 就能把这个分区挂到系统了。

## 设置 swapfile 文件作为交换分区

后来折腾的过程中，发现有时候2G内存不够用，所以我新建了一个 swapfile 文件作为交换分区。

```bash
 dd if=/dev/zero of=/mnt/data1/swapfile bs=1k count=2048k
 chmod 600 /mnt/data1/swapfile
 mkswap /mnt/data1/swapfile
 swapon /mnt/data1/swapfile
```

然后`nano /etc/config/fstab`编辑 fstab文件，在末尾增加：

```bash
# a swap file
config 'swap'
        option  device  '/mnt/data1/swapfile'
```

`free -h`应该能看到虚拟内存（swapfile）的使用情况了。

## 设置软件源

默认的软件源是`mirrors.ustc.edu.cn`的，在我这里很难连接上，所以替换到`openwrt.proxy.ustclug.org`。

在`系统`=>`软件包`=>`配置`里面，把发行版软件源修改为：

```bash
src/gz openwrt_koolshare_mod_core http://openwrt.proxy.ustclug.org/snapshots/targets/x86/64/packages
src/gz openwrt_koolshare_mod_base http://openwrt.proxy.ustclug.org/snapshots/packages/x86_64/base
src/gz openwrt_koolshare_mod_luci http://openwrt.proxy.ustclug.org/snapshots/packages/x86_64/luci
src/gz openwrt_koolshare_mod_packages http://openwrt.proxy.ustclug.org/snapshots/packages/x86_64/packages
src/gz openwrt_koolshare_mod_routing http://openwrt.proxy.ustclug.org/snapshots/packages/x86_64/routing
src/gz openwrt_koolshare_mod_telephony http://openwrt.proxy.ustclug.org/snapshots/packages/x86_64/telephony
```

## 安装酷软

这一步，才是软路由值得折腾的地方。通过这里，可以把软路由DIY成近似于一台低配的电脑。

下面就简单说说几个坑

### aira2

aira2 是一个下载工具。可用于下载 http/https/ftp/bt/磁力链接等。

测试时，我发现BT和磁力死活下载不了，折腾了很久。后来发现，不是 aira2 下载不了BT/磁力，而是我选择的种子太冷门，根本没有源。拜拜浪费我的时间啊。

## v2ray

这是一个网络加速工具。

如果电脑A直接连接电脑C的网速很慢，而如果电脑A直接连接电脑B很快，且电脑B直接连接电脑C也很快，那么，通过通过`A<=>B<=>C`的方式，实现电脑A与电脑C之间的加速。两点之间，直线最短，但不一定最快。

v2ray 的坑主要是，填写的配置文件只需要`outbound`的部分，外加一对大括号`{}`，不能有其他的内容了，否则就出错了。即，只能填写：

```json
{

    "outbound": {
        必须的内容
    }

}
```

酷软里面，科学上网工具也有类似的加速的功能。

### 卸载软件

曾经有一段时间，发现有些软件点击卸载之后，仍然处于“已安装”的状态。后来才知道，需要先把`启动`的勾去掉，也就是先禁止软件运行，否则就无法卸载。

### 网络共享

折腾路由器，除了让路由器能够下载之外，还希望路由器能把自己的硬盘共享出来。

网络共享是通过`samba`这个协议/程序实现的。比较坑的地方是，openwrt 默认只有`root`用户，而`samba`默认不支持 `root`，所以需要先ssh 到3215U主机，`adduer aaa`来新建一个名为`aaa`的用户。

另一个坑就是，刚才`adduser`新建aaa用户时设定的密码还不是`samba`的密码。需要``smbpasswd -a aaa `来设定用户aaa的密码，即，网络共享时需要输入 `smbpasswd`设置的密码。

在网页界面中，`服务`=>`网络共享`中设置共享的文件夹就行。我把`/mnt/data1/download`共享了。有时候会发现访问这个共享文件夹时，没有写入或者删除的权限，运行如下命令即可：

```bash
chown -R a:root /mnt/data1/download/
```

## 计划任务/crontab

Linux 系统经常使用 `crontab -e`来设定各种计划任务，这种计划任务依赖于一个叫 cron 或者 crond 的守护程序。openwrt 比较坑的地方时，默认没有启用 cron 。所以需要运行如下命令：

```bash
/etc/init.d/cron restart
/etc/init.d/cron enable
/etc/init.d/cron reload
```

网页端，`系统`=>`计划任务`中，写入：

```bash
*/5 * * * * chown -R a:root /mnt/data1/download/
```

这句话的意思时，每5分钟，就把 download 文件夹里面的所有文件划归到用户aaa，这样，网络共享中，aaa就有权限修改、删除了。

想要的功能都实现了，忽然感觉空虚了。