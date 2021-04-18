lname="DESKTOP-GOMS8S8"
for i in {0..3..1}
do
  echo "running node ${i}"
  rebar3 shell --sname $"adi${i}@${lname}"
done
echo "done"