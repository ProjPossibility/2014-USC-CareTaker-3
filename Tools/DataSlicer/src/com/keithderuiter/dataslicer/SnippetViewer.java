package com.keithderuiter.dataslicer;

import java.awt.BorderLayout;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTree;
import javax.swing.event.TreeModelEvent;
import javax.swing.event.TreeModelListener;
import javax.swing.event.TreeSelectionEvent;
import javax.swing.event.TreeSelectionListener;
import javax.swing.tree.DefaultMutableTreeNode;
import javax.swing.tree.DefaultTreeModel;
import javax.swing.tree.MutableTreeNode;
import javax.swing.tree.TreePath;
import javax.swing.tree.TreeSelectionModel;

public class SnippetViewer extends JPanel implements TreeModelListener, TreeSelectionListener {
	private JTree tree;	//The thing that displays
	private List<Pair<Integer, Integer>> snippets;
	private DefaultMutableTreeNode rootNode;
	private DefaultTreeModel treeModel;
	public String currentDataName;
	private DataEditorPanel dep;
	

	SnippetViewer(DataEditorPanel dep) {
		this.dep = dep;
		currentDataName = "";

		//Data holding snippets
		snippets = new ArrayList<Pair<Integer, Integer>>();

		//Tree stuff
		rootNode = new DefaultMutableTreeNode("ABN Snips");
		//createNodesFromRoot(root);

		treeModel = new DefaultTreeModel(rootNode);
		treeModel.addTreeModelListener(this);

		tree = new JTree(treeModel);
		tree.setEditable(false);
		tree.getSelectionModel().setSelectionMode(TreeSelectionModel.SINGLE_TREE_SELECTION); 
		//tree.setShowsRootHandles(true);
		tree.addTreeSelectionListener(this);


		JScrollPane treeViewScrollPane = new JScrollPane(tree);
		this.setLayout(new BorderLayout());
		this.add(treeViewScrollPane, BorderLayout.CENTER);
	}
	
	public List<Pair<Integer, Integer>> getStartSortedSnippetsList() {
		List<Pair<Integer, Integer>> ret = new ArrayList<Pair<Integer, Integer>>(snippets);
		Collections.sort(ret, new PairFirstComparator());
		return ret;
	}
	
	public List<Pair<Integer, Integer>> getSnippetsList() {
		return snippets;
	}
	
	public void clearData() {
		snippets.clear();
		rootNode.removeAllChildren();
		treeModel.reload();
	}

	private void createNodesFromRoot(DefaultMutableTreeNode root) {
		//DefaultMutableTreeNode category = null;
		DefaultMutableTreeNode snippet = null;

		//category = new DefaultMutableTreeNode("Books for Java Programmers");
		//top.add(category);

		for(Pair<Integer, Integer> p : snippets) {
			snippet = new DefaultMutableTreeNode(p);
			root.add(snippet);
		}
	}

	public void removeCurrentlySelectedSnippet() {
        TreePath currentSelection = tree.getSelectionPath();
        if (currentSelection != null) {
            DefaultMutableTreeNode currentNode = (DefaultMutableTreeNode) (currentSelection.getLastPathComponent());
            MutableTreeNode parent = (MutableTreeNode)(currentNode.getParent());
            if (parent != null) {
                treeModel.removeNodeFromParent(currentNode);
                snippets.remove(currentNode.getUserObject());
                return;
            }
        } 
 
        // Either there was no selection, or the root was selected.
        return;
    }
	
	public void addSnippet(int start, int end) {
		Pair<Integer, Integer> p = new Pair<Integer, Integer>(start, end);
		snippets.add(p);
		addObjectToTree(p);
	}

	//Tree Methods
	public DefaultMutableTreeNode addObjectToTree(Object child) {
		DefaultMutableTreeNode parentNode = null;
		TreePath parentPath = tree.getSelectionPath();

		/*if (parentPath == null) {
			//There is no selection. Default to the root node.
			parentNode = rootNode;
		} else {
			parentNode = (DefaultMutableTreeNode) (parentPath.getLastPathComponent());
		}*/
		parentNode = rootNode;

		return addObjectToTree(parentNode, child, true);
	}

	public DefaultMutableTreeNode addObjectToTree(DefaultMutableTreeNode parent, Object child, boolean shouldBeVisible) {
		DefaultMutableTreeNode childNode = new DefaultMutableTreeNode(child);
		treeModel.insertNodeInto(childNode, parent, parent.getChildCount());

		//Make sure the user can see the lovely new node.
		if (shouldBeVisible) {
			tree.scrollPathToVisible(new TreePath(childNode.getPath()));
		}
		return childNode;
	}


	@Override
	public void treeNodesChanged(TreeModelEvent e) {
		DefaultMutableTreeNode node;
		node = (DefaultMutableTreeNode) (e.getTreePath().getLastPathComponent());

		/*
		 * If the event lists children, then the changed
		 * node is the child of the node we have already
		 * gotten.  Otherwise, the changed node and the
		 * specified node are the same.
		 */
		try {
			int index = e.getChildIndices()[0];
			node = (DefaultMutableTreeNode) (node.getChildAt(index));
		} catch (NullPointerException exc) {

		}

		System.out.println("The user has finished editing the node.");
		System.out.println("New value: " + node.getUserObject());
	}

	@Override
	public void treeNodesInserted(TreeModelEvent e) {
		// TODO Auto-generated method stub
		System.out.println("Node Inserted: " + e.getTreePath());
	}

	@Override
	public void treeNodesRemoved(TreeModelEvent e) {
		// TODO Auto-generated method stub

	}

	@Override
	public void treeStructureChanged(TreeModelEvent e) {
		// TODO Auto-generated method stub

	}

	@SuppressWarnings("unchecked")	//For the Pair<Integer, Integer> casts
	@Override
	public void valueChanged(TreeSelectionEvent e) {
		//Returns the last path element of the selection.
		//This method is useful only when the selection model allows a single selection.
		DefaultMutableTreeNode node = (DefaultMutableTreeNode) tree.getLastSelectedPathComponent();

		if (node == null) {
			//Nothing is selected.     
			return;
		}

		Object nodeInfo = node.getUserObject();
		if (node.isLeaf()) {
			Pair<Integer, Integer> p = null;
			if(nodeInfo instanceof Pair<?, ?>) {
				p = (Pair<Integer, Integer>) nodeInfo;
				dep.selectionStartIndex = p.first;
				dep.selectionEndIndex = p.second;
			}
		}
	}
}
