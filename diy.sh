#!/bin/bash
set -eux

# 安装 passwall2 、 ssr-plus 和 adguardhome 插件
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall2.git package/passwall2
git clone --depth=1 https://github.com/fw876/helloworld.git package/helloworld
git clone --depth=1 https://github.com/AdguardTeam/AdGuardHome.git package/adguardhome

# 更新 feeds
./scripts/feeds update -a

# 安装需要的插件
./scripts/feeds install -a -p passwall2 luci-app-passwall2
./scripts/feeds install -a -p helloworld luci-app-ssr-plus
# AdguardHome 插件若在 feed 中可用则安装
# 如果 clone 到 package，make 会自动包含

# 禁用 IPv6
sed -i '/CONFIG_IPV6=y/d' .config || true
sed -i '/CONFIG_PACKAGE_ipv6helper=y/d' .config || true
echo 'CONFIG_IPV6=n' >> .config

# 设置默认后台 IP 与 root 密码
sed -i '/CONFIG_DEFAULT_ipaddr=/d' .config
echo 'CONFIG_DEFAULT_ipaddr="192.168.1.1"' >> .config
sed -i '/CONFIG_DEFAULT_netmask=/d' .config
echo 'CONFIG_DEFAULT_netmask="255.255.255.0"' >> .config
sed -i '/CONFIG_DEFAULT_root_password=/d' .config
echo 'CONFIG_DEFAULT_root_password="root"' >> .config
