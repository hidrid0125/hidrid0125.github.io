#!/bin/bash
#set -x
# modified version from http://forum.netkas.org/index.php/topic,692.0.html
# STLVNUB 20/07/2014
workDIR="$(dirname $0)"
cd "$workDIR"

if [ ! -f N210D3GI.FJ1.efi ]; then # this is the MAGIC UEFI file
	echo "No N210D3GI.FJ1.efi :(" && exit 1
else	
	EFIFILE=N210D3GI.FJ1.efi #"efi.gop.rom"
fi
if [ ! -f Rom/*.rom ]; then # do as it says
	echo "Name your VBios as DevID-VenID.rom
e.g 10DE.638f.rom
place it in Rom folder
and rerun" && exit 1
else	
	ORIGROM=$(basename $(ls Rom/*.rom))
fi
VENID=${ORIGROM:0:4}
DEVID=${ORIGROM:5:4}	
size=`java getSize Rom/"${ORIGROM}"` # javascript to size the rom
echo "orig size - $size"
echo "$VENID $DEVID"
EFIROM="uefi.rom" # name for UEFI rom
[[ -f "$EFIROM" ]] && rm -rf "$EFIROM"

./Efirom -o "$EFIROM" -b Rom/"${ORIGROM}" -ec "$EFIFILE" -l 0x30000 -f 0x$VENID -i 0x$DEVID
python fixrom.py "$EFIROM" "$EFIROM" # fix some things
echo "Your 'new' UEFI rom is ready at $EFIROM" # finished rom.
./Efirom -d $EFIROM >info.txt
open info.txt
