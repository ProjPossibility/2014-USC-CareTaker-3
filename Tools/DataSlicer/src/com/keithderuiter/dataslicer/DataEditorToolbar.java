package com.keithderuiter.dataslicer;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

import javax.swing.JButton;
import javax.swing.JFileChooser;
import javax.swing.JToolBar;
import javax.swing.filechooser.FileNameExtensionFilter;

import com.keithderuiter.dataslicer.DataEditorPanel.BrushType;

public class DataEditorToolbar extends JToolBar implements ActionListener {

	private DataEditorPanel dep;
	private SnippetViewer sv;

	private JButton snipSelectionToFileButton;
	private JButton snipSelectionToStorageButton;
	private JButton deleteStoredSnipButton;
	private JButton writeSnipsToFilesButton;
	private JButton writeSnipInversesToFilesButton;
	private JButton loadDataButton;
	private JButton clearDataButton;

	//private JLabel currentBrushLabel;


	public DataEditorToolbar(DataEditorPanel depIn, SnippetViewer svIn) {
		this.dep = depIn;
		this.sv = svIn; 

		//currentBrushLabel = new JLabel("  Current Brush: None");

		snipSelectionToFileButton = new JButton("Snip Selection to File");
		snipSelectionToStorageButton = new JButton("Store Selection");
		deleteStoredSnipButton = new JButton("Remove Selected Snip");
		writeSnipsToFilesButton = new JButton("Write Snips to File");
		writeSnipInversesToFilesButton = new JButton("Write Snip Inverses to File");
		loadDataButton = new JButton("Load Data");
		clearDataButton = new JButton("Clear Data");

		snipSelectionToFileButton.addActionListener(this);
		snipSelectionToStorageButton.addActionListener(this);
		deleteStoredSnipButton.addActionListener(this);
		writeSnipsToFilesButton.addActionListener(this);
		writeSnipInversesToFilesButton.addActionListener(this);
		loadDataButton.addActionListener(this);	
		clearDataButton.addActionListener(this);	

		this.add(snipSelectionToFileButton);
		this.add(snipSelectionToStorageButton);
		this.add(deleteStoredSnipButton);
		this.add(writeSnipsToFilesButton);
		this.add(writeSnipInversesToFilesButton);
		this.add(loadDataButton);
		this.add(clearDataButton);

		//this.add(currentBrushLabel);
	}

	@Override
	public void actionPerformed(ActionEvent e) {
		if(e.getSource().equals(snipSelectionToFileButton)) {
			//TODO perform snip
			int startIndex = dep.selectionStartIndex;
			int endIndex = dep.selectionEndIndex;
			
			String outputFilename = "split_" + startIndex + "-" + endIndex + sv.currentDataName;
			DataSlicer.writeDataSetsForRangeToFile(dep.dataSets, startIndex, endIndex, outputFilename, "ABN");
		}
		else if(e.getSource().equals(snipSelectionToStorageButton)) {
			int startIndex = Math.min(dep.selectionStartIndex, dep.selectionEndIndex);
			int endIndex = Math.max(dep.selectionEndIndex, dep.selectionStartIndex);
			sv.addSnippet(startIndex, endIndex);
		}
		else if(e.getSource().equals(deleteStoredSnipButton)) {
			sv.removeCurrentlySelectedSnippet();
		}
		else if(e.getSource().equals(writeSnipsToFilesButton)) {
			for(Pair<Integer, Integer> p : sv.getSnippetsList()) {
				int startIndex = p.first;
				int endIndex = p.second;
				
				String outputFilename = "split_" + startIndex + "-" + endIndex + sv.currentDataName;
				DataSlicer.writeDataSetsForRangeToFile(dep.dataSets, startIndex, endIndex, outputFilename, "ABN");
			}
		}
		else if(e.getSource().equals(writeSnipInversesToFilesButton)) {
			List<Pair<Integer, Integer>> snipList = sv.getStartSortedSnippetsList();
			int numSamples = dep.getDataLength();

			class SnipPairElement implements Comparable<SnipPairElement> {
				Integer pos;
				boolean isStart;

				public SnipPairElement(Integer pos, boolean isStart) {
					this.pos = pos;
					this.isStart = isStart;
				}
				@Override
				public int compareTo(SnipPairElement o) {
					return pos.compareTo(((SnipPairElement) o).pos);
				}
			};

			List<SnipPairElement> parenthesisList = new ArrayList<SnipPairElement>();
			for(Pair<Integer, Integer> p : snipList) {
				parenthesisList.add(new SnipPairElement(p.first, true));
				parenthesisList.add(new SnipPairElement(p.second, false));
			}
			parenthesisList.add(new SnipPairElement(0, false));	//Add beginning of the list
			parenthesisList.add(new SnipPairElement(numSamples, true));
			Collections.sort(parenthesisList);

			int snipIndex = 0;
			int startIndex = 0;
			int endIndex = parenthesisList.size() == 0 ? numSamples : parenthesisList.get(0).pos;
			//int endIndex = parenthesisList.get(0).pos;	//should be position of first start
			//endIndex = (snipList.size() == 0) ? (dep.dataSets.get(0).getLength()) : snipList.get(snipIndex).first;
			int parenthesisCount = 1;

			for(int i = 0; i < parenthesisList.size(); i++) {				
				if(parenthesisList.get(i).isStart) {
					parenthesisCount++;
				} else {
					parenthesisCount--;
				}

				if(parenthesisCount == 0) {
					startIndex = parenthesisList.get(i).pos;	//Is the end of a ABN run
					if(i == parenthesisList.size() - 1) {
						endIndex = numSamples; 
					}
					else {
						endIndex = parenthesisList.get(i + 1).pos;	//Is the start of a ABN run
					}
					System.out.println("PRINTING GOOD DATA IN RANGE: " + startIndex + "-" + endIndex);
					String outputFilename = "split_" + startIndex + "-" + endIndex + sv.currentDataName;
					DataSlicer.writeDataSetsForRangeToFile(dep.dataSets, startIndex, endIndex, outputFilename, "NOR");
				}
				
			}



		}
		else if(e.getSource().equals(clearDataButton)) {
			dep.clearData();
			sv.clearData();
		}
		else if(e.getSource().equals(loadDataButton)) {
			Timer timer = new Timer();
			timer.schedule(new TimerTask() {
				public void run() {
					String path = "";

					JFileChooser chooser = new JFileChooser(System.getProperty("user.dir"));
					FileNameExtensionFilter filter = new FileNameExtensionFilter("Text files", "txt");
					chooser.setFileFilter(filter);
					int returnVal = chooser.showOpenDialog(dep);
					if(returnVal == JFileChooser.APPROVE_OPTION) {
						try {
							path = chooser.getSelectedFile().getCanonicalPath();
						} catch (IOException e) {
							e.printStackTrace();
						}
						sv.clearData();
						dep.clearData();
						System.out.println("Loading file: " + path);
						dep.dataSets = DataSlicer.loadDataSetsFromFile(path);
						sv.currentDataName = chooser.getSelectedFile().getName();
					}
				}
			}, 0);
		}
	}

	public void setCurrentBrushTypeLabel(BrushType t) {
		//currentBrushLabel.setText("  Current Brush: " + t.toString());
	}
}
