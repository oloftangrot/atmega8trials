while true; do 
  ./usbtemp temp 9227A5010800; 
  exitcode=$?
  echo "Exitcode: $exitcode" 
  if [ $exitcode != "0" ]; then
	echo "Failed to compensate USB error!"
	exit $exitcode
  fi
done
