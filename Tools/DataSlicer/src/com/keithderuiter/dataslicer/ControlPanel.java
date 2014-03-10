package com.keithderuiter.dataslicer;

import java.awt.Dimension;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Insets;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.IOException;
import java.util.Timer;
import java.util.TimerTask;

import javax.swing.JButton;
import javax.swing.JFileChooser;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JSlider;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;
import javax.swing.filechooser.FileNameExtensionFilter;

public class ControlPanel extends JPanel implements ChangeListener {
	public static final int X_SCALE_SLIDER_MIN = 0;
	public static final int X_SCALE_SLIDER_MAX = 100;
	public static final int X_SCALE_SLIDER_INIT = 30;
	public static final int Y_SCALE_SLIDER_MIN = 0;
	public static final int Y_SCALE_SLIDER_MAX = 100;
	public static final int Y_SCALE_SLIDER_INIT = 50;

	private DataEditorPanel dep;
	private SnippetViewer sv;

	private JButton loadDataButton;
	private JButton clearDataButton;

	private JLabel xScalingSliderLabel;
	private JLabel yScalingSliderLabel;
	private JSlider xScalingSlider;
	private JSlider yScalingSlider;

	private JLabel coordLabel;

	
	public ControlPanel(DataEditorPanel dep, SnippetViewer sv) {
		this.dep = dep;
		this.sv = sv;
		setUpGui();
	}

	private void setUpGui() {
		this.setLayout(new GridBagLayout());
		GridBagConstraints c = new GridBagConstraints();
		Dimension tfSize = new Dimension(50, 22);
		Dimension lengthTfSize = new Dimension(180, 22);

		coordLabel = new JLabel("pos: < 0, 0.0 >");
		coordLabel.setPreferredSize(lengthTfSize);
		coordLabel.setMinimumSize(lengthTfSize);
		
		xScalingSliderLabel = new JLabel("X Scale:");
		xScalingSlider = new JSlider(JSlider.HORIZONTAL, X_SCALE_SLIDER_MIN, X_SCALE_SLIDER_MAX, X_SCALE_SLIDER_INIT);
		xScalingSlider.setMajorTickSpacing(20);
		xScalingSlider.setPaintTicks(true);
		xScalingSlider.setPaintLabels(true);
		xScalingSlider.addChangeListener(this);
		
		yScalingSliderLabel = new JLabel("Y Scale:");
		yScalingSlider = new JSlider(JSlider.HORIZONTAL, Y_SCALE_SLIDER_MIN, Y_SCALE_SLIDER_MAX, Y_SCALE_SLIDER_INIT);
		yScalingSlider.setMajorTickSpacing(20);
		yScalingSlider.setPaintTicks(true);
		yScalingSlider.setPaintLabels(true);
		yScalingSlider.addChangeListener(this);

		
		clearDataButton = new JButton("Clear Data");
		clearDataButton.addActionListener(new ActionListener() {		
			@Override
			public void actionPerformed(ActionEvent e) {
				dep.clearData();
				sv.clearData();
			}
		});
		

		loadDataButton = new JButton("Load Data");
		loadDataButton.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent e) {
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
		});

		c.insets = new Insets(3, 5, 3, 5);
		c.anchor = GridBagConstraints.WEST;

		c.anchor = GridBagConstraints.CENTER;
		c.gridx = 0;
		c.gridy = 0;
		add(loadDataButton, c);
		
		c.anchor = GridBagConstraints.CENTER;
		c.gridx = 1;
		c.gridy = 0;
		add(clearDataButton, c);
		
		c.anchor = GridBagConstraints.CENTER;
		c.gridx = 2;
		c.gridy = 0;
		add(xScalingSliderLabel, c);
		
		c.anchor = GridBagConstraints.CENTER;
		c.gridx = 4;
		c.gridy = 0;
		add(yScalingSliderLabel, c);
		
		c.anchor = GridBagConstraints.CENTER;
		c.gridx = 3;
		c.gridy = 0;
		add(xScalingSlider, c);
		
		c.anchor = GridBagConstraints.CENTER;
		c.gridx = 5;
		c.gridy = 0;
		add(yScalingSlider, c);
		
		c.anchor = GridBagConstraints.CENTER;
		c.gridx = 7;
		c.gridy = 0;
		add(coordLabel, c);


	}

	public void setCoordLabelValues(int x, float y) {
		this.coordLabel.setText("pos: < " + String.valueOf(x) + ", " + String.format("%.2f", y) + " >");
	}
	
	
	@Override
	public void stateChanged(ChangeEvent e) {
	    JSlider source = (JSlider)e.getSource();
	    if(source.equals(this.xScalingSlider)) {
	    	this.dep.horizontalScaleFactor = (float)Math.pow(1.03, source.getValue()) - 0.9f - (0.1f * ((float)Math.pow((source.getValue() + .3), 0.1)));
	    	if(this.dep.dataSets.size() > 0) {
	    		this.dep.setPreferredSize(new Dimension((int)(this.dep.horizontalScaleFactor * this.dep.dataSets.get(0).getLength()),
	    												this.dep.getPreferredSize().height));
	    	}
			this.dep.getScrollPane().setViewportView(dep);
	    } else if(source.equals(this.yScalingSlider)) {
	    	this.dep.verticalScaleFactor = (int)source.getValue();	    	
	    	this.dep.setPreferredSize(new Dimension(this.dep.getPreferredSize().width, (Integer)source.getValue()));
	    	this.dep.getScrollPane().setViewportView(dep);
	    }
	}


}
