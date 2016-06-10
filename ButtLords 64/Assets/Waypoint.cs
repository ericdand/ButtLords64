using UnityEngine;
using System.Collections;

public class Waypoint : MonoBehaviour {

	internal bool isVisited;

	// Use this for initialization
	void Start () {
	}
	
	// Update is called once per frame
	void Update () {
	
	}

	public Vector2 Position() {
		return this.transform.position;
	}
}
