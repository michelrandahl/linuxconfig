To use vyprVPN in linux, use the package 'openvpn' and download the vyprvpn config files from https://support.goldenfrog.com/hc/en-us/articles/225607167-Where-can-I-find-the-OpenVPN-files-

You can now simply connect to a vyprvpn endpoint like this:

$ sudo openvpn --config /etc/openvpn/OpenVPN256/United\ Kingdom.ovpn

To make openvpn status 'visible' to i3blocks change the line "dev tun" to "dev tun0" in the .opvn file, and use the writepid option to write the openvpn pid to a place like /run/openvpn/home.pid.

Execute openvpn like this:

$ sudo openvpn --config /etc/openvpn/OpenVPN256/United\ Kingdom.ovpn --writepid /run/openvpn/home.pid
