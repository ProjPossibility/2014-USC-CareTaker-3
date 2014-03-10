package com.keithderuiter.dataslicer;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class DataSlicer {
	
	public static void writeDataSetsForRangeToFile(List<DataSet> dataSets, int startIndex, int endIndex, String filename, String tag) {
		String output = "$ Data Slice- Start: " + startIndex + " End: " + endIndex + " Channels: " + dataSets.size() + " TAG: " + tag + "\n";	//TODO generate file
		for(int index = startIndex; index < endIndex; index++) {
			for(int channel = 0; channel < dataSets.size(); channel++) {
				float val = dataSets.get(channel).getData().get(index);
				int valInt = (int) val;
				String valString = String.valueOf(channel != 0 ? Float.toString(val): Integer.toString(valInt));
				output += valString;	//output this element of data
				if(channel < dataSets.size() - 1) {
					output += "/";
				} else {
					output += "\n";
				}
			}
		}


		try {
			//write converted data to a file
			FileWriter writer = new FileWriter(filename);
			writer.write(output);
			writer.close();

		} catch (IOException e) {
			e.printStackTrace();
		}

		System.out.println(output);
	}

	public static List<DataSet> loadDataSetsFromFile(String filename) {
		
		
		List<DataSet> dataSets = new ArrayList<>();

		try {
			//read data file			
			BufferedReader reader = new BufferedReader(new FileReader(filename));
			String line = "";

			while((line = reader.readLine()) != null) {
				if(line.startsWith("$")) {
					continue;
				}

				String[] splitStr = line.split("/");
				int numSplits = splitStr.length;

				for(int i = 0; i < numSplits; i++) {
					if(dataSets.size() != numSplits) {	//If this is the first pass, create sets
						dataSets.add(new DataSet(DataEditorPanel.getColorForChannel(i)));
					}

					float value = Float.valueOf(splitStr[i]);
					dataSets.get(i).addDataPoint(value);
				}

			}
			reader.close();


		} catch (IOException e) {
			e.printStackTrace();
		}

		return dataSets; 
	}

}
