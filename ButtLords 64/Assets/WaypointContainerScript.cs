using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;

// TODO: Pull waypoints from children rather than having to explicitly define it in the properties.

public class WaypointContainerScript : MonoBehaviour, IEnumerable {

	// Public so it can be populated from the IDE.
	public Waypoint[] waypoints;

	// lastNext is guaranteed to have been the index of the next waypoint last time GetNextWaypoint was called.
	// It is used to allow us to keep track of the next waypoint.
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
		if (lastNext >= waypoints.Length)
			return null;
		
		if (waypoints[lastNext].isVisited) {
			lastNext++;
			Debug.LogFormat ("Visiting waypoint {0}", lastNext);
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
