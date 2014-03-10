package com.keithderuiter.dataslicer;

import java.awt.Color;
import java.awt.Cursor;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.MouseMotionListener;
import java.util.ArrayList;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

import javax.swing.JPanel;
import javax.swing.JScrollPane;

public class DataEditorPanel extends JPanel implements MouseListener, MouseMotionListener {

	Timer repaintTimer;
	TimerTask repaintTask;
	public static long frameInterval = 10;

	public enum BrushType { None, Building, Entity, EntityTrigger, Player, Eraser, Ruler };

	private BrushType currentBrush;

	private JScrollPane scrollPane;
	private ControlPanel cp;
	private DataEditorToolbar det;
	private SnippetViewer sv;

	
	public static int WIDTH_POINTS = 480;
	public static int HEIGHT_POINTS = 320;
	public int verticalScaleFactor = 40;
	public float horizontalScaleFactor = 3;

	//Accessed from toolbar
	public int selectionStartIndex;
	public int selectionEndIndex;
	public List<DataSet> dataSets;


	public DataEditorPanel() {
		dataSets = new ArrayList<>();

		currentBrush = BrushType.Ruler;
		this.addMouseListener(this);
		this.addMouseMotionListener(this);

		repaintTimer = new Timer();
		repaintTask = new TimerTask() {
			@Override
			public void run() {
				//scrollPane.repaint();
				repaint();
			}
		};

	}

	public void start() {
		repaintTimer.scheduleAtFixedRate(repaintTask, 100, frameInterval);
	}

	public void clearData() {
		dataSets.clear();
	}
	
	public int getDataLength() {
		if(dataSets.size() > 0) {
			return dataSets.get(0).getLength();
		} else {
			return 0;
		}
	}
	
	public BrushType getCurrentBrush() {
		return currentBrush;
	}

	public void setCurrentBrush(BrushType currentBrush) {
		this.currentBrush = currentBrush;
	}

	public void setScrollPane(JScrollPane pane) {
		this.scrollPane = pane;
	}

	public JScrollPane getScrollPane() {
		return this.scrollPane;
	}

	public void setControlPanel(ControlPanel cp) {
		this.cp = cp;
	}

	public void setLevelEditorToolbar(DataEditorToolbar det) {
		this.det = det;
	}

	public void setSnippetViewer(SnippetViewer sv) {
		this.sv = sv;
	}

	public static Color getColorForChannel(int t) {
		if(t == 1) {
			return Color.red;
		} else if(t == 2) {
			return Color.green;
		} else if(t == 3) {
			return Color.blue;
		} else {
			return new Color((t * 40)%255, (50 + (t * 10)) % 255, 50);
		}
	}

	public void paintComponent(Graphics g) {
		super.paintComponent(g);
		Graphics2D g2d = (Graphics2D) g;

		//paint the horizontal axis
		g2d.setColor(Color.BLACK);
		g2d.drawLine(0, this.getHeight() / 2, this.getWidth(), this.getHeight() / 2);

		//paint each dataset
		for(int setIndex = 1; setIndex < dataSets.size(); setIndex++) {	//start at 1 to hide seq
			DataSet ds = dataSets.get(setIndex);
			g2d.setColor(ds.getColor());
			List<Float> data = ds.getData();
			for(int i = 0; i < ds.getLength() - 1; i++) {
				//g2d.fillRect((int)i * horizontalScaleFactor, this.getHeight()/2 - (Math.round(data.get(i)) * verticalScaleFactor), 2, 2);
				g2d.drawLine((int)(i * horizontalScaleFactor), this.getHeight()/2 - (Math.round(data.get(i) * verticalScaleFactor)),
						(int)((i + 1) * horizontalScaleFactor), this.getHeight()/2 - (Math.round(data.get(i + 1) * verticalScaleFactor)));
			}
		}

		//paint ruler
		/*if(displayRuler) {
			g2d.setColor(new Color(200, 200, 200, 110));
			g2d.fillRect(0, 0, rulerPosition - DataEditorPanel.WIDTH_POINTS/2, DataEditorPanel.HEIGHT_POINTS);
			g2d.fillRect(rulerPosition + DataEditorPanel.WIDTH_POINTS/2, 0, this.getWidth(), DataEditorPanel.HEIGHT_POINTS);
		}*/

		//paint selection and ABN snippets
		g2d.setColor(new Color(250, 160, 160, 90));
		g2d.fillRect((int)(Math.min(selectionStartIndex, selectionEndIndex) * horizontalScaleFactor), 0,
					 (int)(Math.abs(selectionEndIndex - selectionStartIndex) * horizontalScaleFactor), this.getHeight());
		
		List<Pair<Integer, Integer>> snips = sv.getSnippetsList();
		for(int i = 0; i < snips.size(); i++) {
			Pair<Integer, Integer> p = snips.get(i);
			int drawStartIndex = p.first;
			int drawEndIndex = p.second;
					
			g2d.setColor(new Color(240, 200, 200, 90));
			g2d.fillRect((int)(Math.min(drawStartIndex, drawEndIndex) * horizontalScaleFactor), 0,
					(int)(Math.abs(drawEndIndex - drawStartIndex) * horizontalScaleFactor), this.getHeight());
			
		}


		//g2d.setColor(Color.ORANGE);
		//g2d.fillOval((int)click.x, (int)click.y, 12, 12);
	}

	@Override
	public void mouseClicked(MouseEvent e) {
	}

	@Override
	public void mousePressed(MouseEvent e) {
		if(e.isAltDown()) {
			this.currentBrush = BrushType.None;
			this.det.setCurrentBrushTypeLabel(BrushType.None);
			return;
		}

		int xPos = e.getX();
		int yPos = e.getY();	//This is in JPanel space, subtract from Level height for position in game world

		if(currentBrush == BrushType.Ruler) {
			selectionStartIndex = (int) ((float)xPos / horizontalScaleFactor);
			selectionEndIndex = (int) ((float)xPos / horizontalScaleFactor);
		}
	}

	@Override
	public void mouseReleased(MouseEvent e) {
		int xPos = e.getX();
		int yPos = e.getY();	//This is in JPanel space, subtract from Level height for position in game world
		//		click.x = xPos;
		//		click.y = yPos;

		if(currentBrush == BrushType.Eraser) {

		} 
		else if(currentBrush == BrushType.Building) {

		}
		else if(currentBrush == BrushType.Entity) {

		}
		else if(currentBrush == BrushType.Player) {

		}
		else if(currentBrush == BrushType.EntityTrigger) {

		}
		else if(currentBrush == BrushType.Ruler) {

		}
	}
	@Override
	public void mouseEntered(MouseEvent e) {
	}
	@Override
	public void mouseExited(MouseEvent e) {
	}

	@Override
	public void mouseDragged(MouseEvent e) {
		if(currentBrush == BrushType.Ruler) {
			selectionEndIndex = (int)((float)Math.min(Math.max(e.getX(), 0), this.getWidth()) / horizontalScaleFactor);
		}
	}

	@Override
	public void mouseMoved(MouseEvent e) {
		int x = e.getX();
		int y = e.getY();
		
		cp.setCoordLabelValues((int)(x / horizontalScaleFactor), (float)((this.getHeight()/2) - y) / verticalScaleFactor);
		
		if(currentBrush == BrushType.EntityTrigger) {
			boolean overBar = false;

			if(overBar) {
				this.setCursor(new Cursor(Cursor.W_RESIZE_CURSOR));
			} else {
				this.setCursor(new Cursor(Cursor.CROSSHAIR_CURSOR));
			}
		} else if(currentBrush == BrushType.Building || currentBrush == BrushType.Entity || currentBrush == BrushType.Player) {
			this.setCursor(new Cursor(Cursor.CROSSHAIR_CURSOR));			
		} else if(currentBrush == BrushType.Ruler) {
			this.setCursor(new Cursor(Cursor.HAND_CURSOR));
		} else {
			this.setCursor(new Cursor(Cursor.DEFAULT_CURSOR));
		}
	}

}
