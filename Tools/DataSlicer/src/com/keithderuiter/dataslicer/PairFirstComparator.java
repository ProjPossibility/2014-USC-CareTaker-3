package com.keithderuiter.dataslicer;

import java.util.Comparator;

public class PairFirstComparator implements Comparator<Pair<Integer, Integer>> {
	@Override
	public int compare(Pair<Integer, Integer>o1, Pair<Integer, Integer>o2) {
		return o1.first.compareTo(o2.first);
	}
}
