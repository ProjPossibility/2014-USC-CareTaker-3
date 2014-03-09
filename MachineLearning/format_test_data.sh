#! /bin/sh

echo "Generating testing file..."
echo "$ normal data" > acc_test
for filename in ./accelerometer_data/test/*.nor_test; do
    python format_for_test.py $filename temp
    cat temp >> acc_test
done

echo "$ abnormal data" >> acc_test

for filename in ./accelerometer_data/test/*.abn_test; do
    python format_for_test.py $filename temp
    cat temp >> acc_test
done