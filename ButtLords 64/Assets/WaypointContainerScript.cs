using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class WaypointContainerScript : MonoBehaviour, IEnumerable {

	public List<Transform> waypoints;

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
	
	}

	// TODO: This may not be necessary -- write the PlayerScript to follow waypoints and see how it works out. Clean
	// this up appropriately.
	public IEnumerator GetEnumerator()
	{
		foreach (Transform waypoint in waypoints) {
			yield return waypoint;
		}
	}
}
