#! /bin/sh

echo "Generating testing file..."
echo "$ normal data" > intermediate_data_files/acc_test
for filename in ./accelerometer_data/test/*.nor_test; do
    python format_for_test.py "$filename" temp
    cat temp >> intermediate_data_files/acc_test
done

echo "$ abnormal data" >> intermediate_data_files/acc_test

for filename in ./accelerometer_data/test/*.abn_test; do
    python format_for_test.py "$filename" temp
    cat temp >> intermediate_data_files/acc_test
done

rm temp
