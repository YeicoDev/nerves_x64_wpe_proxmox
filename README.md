# Nerves x64 System with WPE

```bash
uname -a
Linux builder 6.2.16-3-pve #1 SMP PREEMPT_DYNAMIC PVE 6.2.16-3 (2023-06-17T05:58Z) x86_64 x86_64 x86_64 GNU/Linux

lsb_release -a
No LSB modules are available.
Distributor ID: Ubuntu
Description:    Ubuntu 23.04
Release:        23.04
Codename:       lunar

cat ~/.tool-versions 
erlang 25.3
elixir 1.14.5-otp-25

mix local.hex --force
mix local.rebar --force
mix archive.install hex nerves_bootstrap --force

rm -fr deps/ _build/ .nerves/
mix deps.get
mix nerves.system.shell
...
exit
mix nerves.artifact

cd hello_fw
export MIX_TARGET=x64
mix deps.get
mix firmware
fwup -a -d hello_fw.img -i _build/x64_dev/nerves/images/hello_fw.fw -t complete

ssh root@10.77.0.48 << EOF
qm stop 101
rsync -Lavr samuel@builder:yeico_core_x64_wpe/hello_fw/hello_fw.img .
qm unlink 101 virtio0
lvremove -f pve/vm-101-disk-0
qm importdisk 101 hello_fw.img local-lvm
qm set 101 --virtio0 local-lvm:vm-101-disk-0
qm start 101
exit
EOF
```

- make menuconfig
  - make savedefconfig -> nerves_defconfig
- make linux-menuconfig
  - make linux-update-defconfig -> linux-5.4.defconfig
- make busybox-menuconfig
  - manual copy 

## Notes and References

- use libwxgtk-webview3.2-dev for erlang asdf 25.3
- buildroot-2022.11.3 includes 
  - erlang 25.3
  - wpewebkit 2.38.5
  - wpebackend-fdo 1.12.1
  - libwpe 1.12.3
  - cog 0.14.1
  - weston 10.0.1
- see ./deps/nerves_system_br/buildroot-2022.11.3
- https://hexdocs.pm/nerves/customizing-systems.html
- https://github.com/nerves-project/nerves_system_x86_64/releases/tag/v1.22.2
- https://github.com/buildroot/buildroot/releases/tag/2022.11.3
- https://github.com/nerves-web-kiosk/kiosk_system_x86_64
- https://nightly.buildroot.org/manual.html
