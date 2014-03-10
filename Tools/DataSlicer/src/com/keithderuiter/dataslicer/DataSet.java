package com.keithderuiter.dataslicer;

import java.awt.Color;
import java.util.ArrayList;
import java.util.List;

public class DataSet {
	
	private List<Float> dataSet;
	private Color color;
	
	
	public DataSet(Color color) {
		dataSet = new ArrayList<Float>();
		this.color = color;
	}
	
	public DataSet() {
		dataSet = new ArrayList<Float>();
		this.color = Color.BLACK;
	}
	
	public int getLength() {
		return dataSet.size();
	}

	public List<Float> getData() {
		return dataSet;
	}
	
	public void setColor(Color color) {
		this.color = color;
	}
	
	public Color getColor() {
		return this.color;
	}
	
	public void addDataPoint(float point) {
		dataSet.add(point);
	}

}
