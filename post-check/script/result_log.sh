#!/bin/bash

touch tmp/summary.html
cat script/head.html > tmp/summary.html
touch tmp/summary_pass.html
touch tmp/summary_fail.html
sleep 2

function wait_rspec_stop(){
    while [ `ps aux | grep -v grep | grep -c rspec` -gt 0 ]; do
        sleep 60
    done
}

function count_case(){
    pass_case=`grep "<tr" tmp/summary_pass.html | wc -l`
    failed_case=`grep "<tr" tmp/summary_fail.html | wc -l`
    case=`expr $pass_case + $failed_case`
    echo "<h3>Case tot: $case</h3>" >>  tmp/summary.html
    echo "<h3>Pass case: $pass_case</h3>" >> tmp/summary.html
    echo "<h3>Failed case: $failed_case</h3>" >> tmp/summary.html
}

wait_rspec_stop
count_case

cat tmp/summary_fail.html >> tmp/summary.html
cat tmp/summary_pass.html >> tmp/summary.html
echo "</table>" >> tmp/summary.html

cat tmp/summary_detail.html >> tmp/summary.html

rm -rf tmp/summary_pass.html
rm -rf tmp/summary_fail.html
rm -rf tmp/summary_detail.html