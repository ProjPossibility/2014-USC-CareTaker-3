#! /bin/sh

python format_for_train_NOR.py accelerometer_data/acc09.txt acc09
python format_for_train_NOR.py accelerometer_data/acc10.txt acc10
python format_for_train_NOR.py accelerometer_data/acc11.txt acc11

echo "Generating training file..."

echo "ABN 0.106 -0.706 -0.699 0.000184 0.000144 0.000649" > acc_train
cat acc09 >> acc_train
cat acc10 >> acc_train
cat acc11 >> acc_train

echo "Generating testing file..."
python format_for_test.py accelerometer_data/acc09.txt acc_test

echo "Training..."
python train.py acc_train model 20
echo "Classifying..."
python classify.py model acc_test acc_output