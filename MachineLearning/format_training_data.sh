#! /bin/sh

echo "Formatting training data..."
index=0
for filename in ./accelerometer_data/nor/*.txt; do
    output_filename=$index".nor_train"
    python format_for_train_NOR.py "$filename" $output_filename
    index=$((index+1))
done

index=0
for filename in ./accelerometer_data/abn/*.txt; do
    output_filename=$index".abn_train"
    python format_for_train_ABN.py "$filename" $output_filename
    index=$((index+1))
done

echo "Generating training file..."

echo "$ training file" > acc_train_ordered
for filename in ./*.nor_train; do
    cat $filename >> acc_train_ordered
done

for filename in ./*.abn_train; do
    cat $filename >> acc_train_ordered
done

echo "Randomizing order of training data..."
cat acc_train_ordered | gsort -R > acc_train

echo "Finished."