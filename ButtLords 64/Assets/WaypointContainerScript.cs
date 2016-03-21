using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;

public class WaypointContainerScript : MonoBehaviour, IEnumerable {

	// Public so it can be populated from the IDE.
	public Waypoint[] waypoints;

	// lastNext is guaranteed to have been the index of the next waypoint last time GetNextWaypoint was called.
	// Used to allow us to keep track of the next waypoint.
	private int lastNext;

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
	
	}

	// GetNextWaypoint returns the lowest-numbered waypoint which has not yet been visited.
	// Returns null after the final waypoint.
	public Waypoint GetNextWaypoint() {
		while (waypoints[lastNext].isVisited) {
			lastNext++;
		}
		try {
			return waypoints[lastNext];
		} catch (IndexOutOfRangeException) {
			return null;
		}
	}

	// TODO: This may not be necessary -- write the PlayerScript to follow waypoints and see how it works out. Clean
	// this up appropriately.
	public IEnumerator GetEnumerator()
	{
		foreach (Waypoint waypoint in waypoints) {
			yield return waypoint;
		}
	}
}
