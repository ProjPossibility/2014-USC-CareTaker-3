#! /bin/sh

echo "Formatting training data..."
index=0
for filename in ./accelerometer_data/nor/*.txt; do
    output_filename="intermediate_data_files/"$index".nor_train"
    python format_for_train_NOR.py "$filename" $output_filename
    index=$((index+1))
done

index=0
for filename in ./accelerometer_data/abn/*.txt; do
    output_filename="intermediate_data_files/"$index".abn_train"
    python format_for_train_ABN.py "$filename" $output_filename
    index=$((index+1))
done

echo "Generating training file..."

echo "$ training file" > intermediate_data_files/acc_train_ordered
for filename in ./intermediate_data_files/*.nor_train; do
    cat $filename >> intermediate_data_files/acc_train_ordered
done

for filename in ./intermediate_data_files/*.abn_train; do
    cat $filename >> intermediate_data_files/acc_train_ordered
done

echo "Randomizing order of training data..."
cat intermediate_data_files/acc_train_ordered | gsort -R > intermediate_data_files/acc_train

echo "Finished."
