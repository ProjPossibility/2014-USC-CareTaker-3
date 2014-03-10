package com.keithderuiter.dataslicer;

import java.awt.BorderLayout;
import java.awt.Dimension;

import javax.swing.JFrame;
import javax.swing.JScrollPane;
import javax.swing.JSplitPane;

public class Main {

	public static final int WINDOW_X = 480 * 2;
	public static final int WINDOW_Y = 320 + 180;
	public static final int SNIPPET_VIEWER_PREFERRED_WIDTH = 140;
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		DataSlicer blc = new DataSlicer();
		
		JFrame frame = new JFrame();
		frame.setLayout(new BorderLayout());
		frame.setPreferredSize(new Dimension(WINDOW_X, WINDOW_Y));
		frame.setMinimumSize(new Dimension(WINDOW_X, WINDOW_Y));
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		
		DataEditorPanel dep = new DataEditorPanel();
		dep.setPreferredSize(new Dimension(DataEditorPanel.WIDTH_POINTS, DataEditorPanel.HEIGHT_POINTS));
				
		JScrollPane scrollPane = new JScrollPane();
		scrollPane.setMinimumSize(new Dimension(WINDOW_X, WINDOW_Y));
		scrollPane.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_ALWAYS);
		dep.setScrollPane(scrollPane);
		scrollPane.setViewportView(dep);

		SnippetViewer sv = new SnippetViewer(dep);
		sv.setPreferredSize(new Dimension(SNIPPET_VIEWER_PREFERRED_WIDTH, WINDOW_Y));	//It is in a borderlayout, so only width matters
		
		ControlPanel cp = new ControlPanel(dep, sv);
		dep.setControlPanel(cp);
		
		DataEditorToolbar let = new DataEditorToolbar(dep, sv);
		dep.setLevelEditorToolbar(let);
		dep.setSnippetViewer(sv);
		
		//JSplitPane centerSplitPane = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT, sv, dep);
		//centerSplitPane.setDividerLocation(60);

		frame.add(let, BorderLayout.NORTH);
		frame.add(scrollPane, BorderLayout.CENTER);
		//frame.add(centerSplitPane, BorderLayout.CENTER);
		frame.add(cp, BorderLayout.SOUTH);
		frame.add(sv, BorderLayout.WEST);
		dep.start();
		frame.setVisible(true);
		frame.requestFocus();
	}

}
