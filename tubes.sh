#!/bin/bash
while true; do
	clear
	echo " ===================================================== "
	echo "       H A L O!  S I L A H K A N   D I P I L I H       "
	echo " ===================================================== "
	echo " 1. Tampilkan Daftar Directory"
	echo " 2. Informasi Jaringan"
	echo " 3. Tampilkan Detail OS"
	echo " 4. Informasi User"
	echo " 0. keluar"
	read -p "Pilih Opsi [0,1,2,3,4]: " opsi

case $opsi in
	0)
		echo
		echo "Terimakasih! Keluar dari program..."
		break
		;;
	1)
		echo
		echo " Daftar Direktori di $(pwd) "
		ls -lah
		;;
	2)
		echo
		echo " Informasi Jaringan "
		echo
	
		ip_addr=$(ip addr show enp0s3 | grep 'inet' | awk '{print $2}' | cut -d'/' -f1)
		gateway=$(ip route | grep default | awk '{print $3}')
		netmask=$(ip addr show enp0s3 | grep 'inet' | awk '{print $2}')
		dns=$(grep "nameserver" /etc/resolv.conf | awk '{print $2}')

		echo "Alamat IP Lokal : $ip_addr"
		echo "Gateway         : $gateway"
		echo "Netmask         : $netmask"
		echo "DNS Server      : $dns"
		echo

		echo -n "Status Koneksi ke Internet : "
		ping -c1 8.8.8.8 &> /dev/null && echo "Tersambung ke internet." || echo "Tidak tersambung ke internet"

		echo
		echo "Status Koneksi LAN/WIFI: "
		echo "DEVICE  TYPE      STATE                   CONNECTION"
		nmcli -t -f DEVICE,TYPE,STATE,CONNECTION device | column -t -s ':'
		echo

		lokasi=$(curl -s ipinfo.io/json | jq -r '.city, .region, .country' | paste -sd ",")
		echo "Lokasi IP: $lokasi"
		;;
	3)
		echo
		echo " Detail Sistem Operasi "
		echo "Nama OS : $(lsb_release -d | cut -f2)"
		echo "Versi   : $(lsb_release -r | cut -f2)"
		echo "ID      : $(lsn_release -i | cut -f2)"
		echo "Keterangan: $(lsb_release -c | cut -f2)"
		echo
		echo "Informasi Kernel: "
		uname -r
		echo
		
		echo "Proses CPU Terakhir:"
		mpstat 1 1 | awk '/Average/ {print "%Cpu(s): " $3 " us, " $5 " sy, " $6 " ni, " $12 " id, "$8 " wa, " $9 " hi, " $10 " si, " $11 " st"}'
		echo

		echo "Pengguna Memori: "
		free -h
		echo

		echo "Penggunaan Disk: "
		df -h
		;;
	4)
		echo
		echo " Informasi User "
		echo " Username       : $USER"
		echo " User ID        : $(id -u)"
		echo " Group ID       : $(id -g)"
		echo " Nama Lengkap   : $(getent passwd "$USER" | cut -d ',' -f 1)"
		echo " shell          : $SHELL"
		echo " Home Dir       : $HOME"
		;;

	*)
		echo 
		echo "OPSI TIDAK VALID! Silahkan Pilih 0, 1, 2, atau 3."
		;;
	esac
	echo
	read -p "ENTER untuk Kembali..."
done

